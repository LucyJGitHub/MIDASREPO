000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200528      *****************************************************************
000400200528/*XBIA*  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
000500200528/*XBIB*  OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)                *
000600200528/*STD *  RPGBASEMOD                                                   *
000700200528/*EXI *  TEXT('Midas GL Validate and update')                         *
000800200528      *****************************************************************
000900200528      *                                                               *
001000200528      *  Midas - General Ledger ILE Module                            *
001100200528      *                                                               *
001200200528      *  GLAMADVU - Account Maintenance validate and update           *
001300200528      *                                                               *
001400200528      *  Function: This Program Validates Midas Account Details for   *
001500200528      *            Input into the Midas database.                     *
001600200528      *            Processes executed controlled by input Action Code *
001700200528      *            - For I (=Insert) or A (=Amend)                    *
001800200528      *              - Validate the Transaction details fields        *
001900200528      *            - For A (=AMEND),                                  *
002000200528      *              - if transaction is a partial amendment, call a  *
002100200528      *                separate function to complete the transaction  *
002200200528      *                details.                                       *
002300200528      *              - if transaction is valid, call a separate       *
002400200528      *                function to check whether it is a valid        *
002500200528      *                amendment.                                     *
002600200528      *            - For D (=DELETE), call a separate function to     *
002700200528      *              process the transaction and bypass the rest of   *
002800200528      *              the validation.                                  *
002900200528      *                                                               *
003000200528      *            For all action codes, the decision to as to        *
003100200528      *            whether to write to the Valid or Invalid file and  *
003200200528      *            the call to the Message Handler will take place    *
003300200528      *            in this module                                     *
003400200528      *                                                               *
003500200528      *  (c) Finastra International Limited 2003                      *
003600200528      *                                                               *
003700200604      *  Last Amend No. 250822             Date 22May20               *
003800200528      *  Prev Amend No. MD054028           Date 05Sep19               *
003900200528      *                 MD041837           Date 16Jun19               *
004000200528      *                 CER050             Date 16Jun19               *
004100200528      *                 CSD101             Date 07Dec18               *
004200200528      *                 CSD102             Date 08Jan19               *
004300200528      *                 MD051247           Date 17Jul18               *
004400200528      *                 MD044880           Date 15Jan18               *
004500200528      *                 MD046248           Date 27Oct17               *
004600200528      *                 MD044546           Date 20Mar17               *
004700200528      *                 MD043890           Date 06Feb17               *
004800200528      *                 MD042713           Date 05Dec16               *
004900200528      *                 222427             Date 05Dec16               *
005000200528      *                 MD040328           Date 16Aug16               *
005100200528      *                 MD040146           Date 11Aug16               *
005200200528      *                 LLN022A            Date 03Jun15               *
005300200528      *                 CRE101             Date 27Aug14               *
005400200528      *                 CGL165             Date 17Feb15               *
005500200528      *                 MD028970           Date 25Nov14               *
005600200528      *                 MD026979           Date 09Jun14               *
005700200528      *                 MD024398           Date 11May14               *
005800200528      *                 AR801992           Date 27Jul12               *
005900200528      *                 AR971184A          Date 22Jun12               *
006000200528      *                 AR971184           Date 28May12               *
006100200528      *                 AR946674           Date 03Apr12               *
006200200528      *                 AR947093           Date 26Apr12               *
006300200528      *                 AR847249           Date 28Jan12               *
006400200528      *                 CSF011A            Date 28Nov11               *
006500200528      *                 AR869261           Date 13Dec11               *
006600200528      *                 CSF011             Date 12Sep11               *
006700200528      *                 AR812501           Date 07Sep11               *
006800200528      *                 AR820577           Date 31Aug11               *
006900200528      *                 CER049             Date 06Dec10               *
007000200528      *                 CRE073             Date 06Dec10               *
007100200528      *                 CER055             Date 06Dec10               *
007200200528      *                 AR802610           Date 15Jul11               *
007300200528      *                 CRE075             Date 06Dec10               *
007400200528      *                 CER059             Date 19Jul10               *
007500200528      *                 262070             Date 26Oct09               *
007600200528      *                 BUG24157           Date 04Jun09               *
007700200528      *                 BUG22742           Date 07Feb09               *
007800200528      *                 CER047             Date 19May08               *
007900200528      *                 BUG22973           Date 27May10               *
008000200528      *                 BUG23484           Date 27May10               *
008100200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
008200200528      *                 CRE015             Date 18Dec09               *
008300200528      *                 CRE030             Date 10Jul06               *
008400200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
008500200528      *                 256564             Date 17Sep08               *
008600200528      *                 BUG17361A          Date 11Apr08               *
008700200528      *                 245029A            Date 12Mar07               *
008800200528      *                 249966             Date 30Aug07               *
008900200528      *                 249660             Date 14Aug07               *
009000200528      *                 BUG13639           Date 27Mar07               *
009100200528      *                 245648             Date 15Feb07               *
009200200528      *                 243436             Date 22Dec06               *
009300200528      *                 243129             Date 27Oct06               *
009400200528      *                 BUG13120a          Date 26Jan07               *
009500200528      *                 BUG13120           Date 24Jan07               *
009600200528      * Midas Plus 1.3 ----------- Base ------------------------------*
009700200528      *                 242488             Date 27Sep06               *
009800200528      *                 240916             Date 12Sep06               *
009900200528      *                 CPK025             Date 29Aug06               *
010000200528      *                 240366             Date 19Jun06               *
010100200528      *                 237646             Date 13Jun06               *
010200200528      *                 240205             Date 06Jun06               *
010300200528      *                 240312             Date 06Jun06               *
010400200528      *                 239316             Date 01Jun06               *
010500200528      *                 237341             Date 29Apr06               *
010600200528      *                 238839 (Reopen)    Date 12Apr06               *
010700200528      *                 238625             Date 06Apr06               *
010800200528      *                 238839             Date 29Mar06               *
010900200528      *                 CSD031             Date 10Apr06               *
011000200528      *                 237401             Date 10Feb06               *
011100200528      *                 BUG10280           Date 02Feb06               *
011200200528      *                 CSD027             Date 09Dec05               *
011300200528      *                 BUG9141            Date 02Dec05               *
011400200528      *                 BUG8210            Date 02Sep05               *
011500200528      *                 BUG8104            Date 19Aug05               *
011600200528      *                 CAP086             Date 08Jun05               *
011700200528      *                 CSW037A            Date 02May05               *
011800200528      *                 TMPFX01            Date 23Mar05               *
011900200528      *                 CER001             Date 25Apr05               *
012000200528      *                 LLN022             Date 24Jan05               *
012100200528      *                 BUG6218            Date 10Mar05               *
012200200528      *                 BUG4615            Date 26Oct04               *
012300200528      *                 CSD025             Date 11Jan05               *
012400200528      *                 CSW037             Date 15Dec04               *
012500200528      *                 CSW036             Date 15Dec04               *
012600200528      *                 BUG4686            Date 05Nov04               *
012700200528      *                 BUG4400            Date 30Sep04               *
012800200528      *                 CRE010             Date 10Sep04               *
012900200528      *                 BUG4252            Date 17Sep04               *
013000200528      *                 BUG4196            Date 09Sep04               *
013100200528      *                 BUG3068            Date 07Jun04               *
013200200528      *                 CLE025             Date 20Oct03               *
013300200528      *                 BUG2733            Date 18May04               *
013400200528      *                 BG2557             Date 13May04               *
013500200528      *                 BG2651             Date 12May04               *
013600200528      *                 TDA084             Date 16Apr04               *
013700200528      *                 BUG553             Date 14Apr04               *
013800200528      *                 CSC022             Date 24Feb04               *
013900200528      *                 CGL029             Date 01Sep03               *
014000200528      *                 CAP084  *CREATE    Date 17Jul03               *
014100200528      *                                                               *
014200200528      *---------------------------------------------------------------*
014300200528      *                                                               *
014400200528      *  250822 - Commented-out /cpy GLAMADSMV1 as this is irrelevant *
014500200528      *           since it was not changed for HUT003.                *
014600200528      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
014700200528      *             being updated                                     *
014800200528      *  MD041837 - Tax indicator is not defaulted anymore with       *
014900200528      *             CER050.                                           *
015000200528      *  CER050 - Annualised Percentage Rate                          *
015100200528      *  CSD101 - Password Encryption                                 *
015200200528      *  CSD102 - Password Length Extension (Recompile)               *
015300200528      *  MD051247 - SP15_CUSD API issue                               *
015400200528      *           - Code improvement                                  *
015500200528      *  MD044880 - BOE Switched On Testing and Fixing                *
015600200528      *  MD046248 - Finastra Rebranding                               *
015700200528      *  MD044546 - Enable the ABC flag when CAP205 is on.            *
015800200528      *  MD043890 - Cannot insert term and notice                     *
015900200528      *  MD042713 - Display Default Statement commission.             *
016000200528      *  222427 - AMAN - 'Extra Daily Statement Commission' default   *
016100200528      *           value is 0.00.  Data structure which includes       *
016200200528      *           DDSTFQ should be included in the parameter list on  *
016300200528      *           call to module GLAMAD4DT.                           *
016400200528      *           Partially Applied for MD042713.                     *
016500200528      *  MD040328 - Unable to update Include Account Balance check    *
016600200528      *             field via SOAP in AMAD                            *
016700200528      *  MD040146 - Account maintenance - Account name different from *
016800200528      *             Customer report name                              *
016900200528      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
017000200528      *            /COPY members and add switchability.               *
017100200528      *  CRE101 - Interim Interest Statements on a Frequency          *
017200200528      *           Added hooks: CRE101_008, CRE101_009, CRE101_014,    *
017300200528      *                        CRE101_017, CRE101_020, CRE101_022     *
017400200528      *                        CRE101_026, CRE101_028, CRE101_032     *
017500200528      *                        CRE101_033, CRE101_034, CRE101_035     *
017600200528      *                        CRE101_036, CRE101_037, CRE101_038     *
017700200528      *                        CRE101_039, CRE101_040, CRE101_041     *
017800200528      *                        CRE101_042, CRE101_043, CRE101_044     *
017900200528      *                        CRE101_045, CRE101_046, CRE101_047     *
018000200528      *                        CRE101_048, CRE101_057, CRE101_061     *
018100200528      *                        CRE101_062, CRE101_069                 *
018200200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
018300200528      *  MD028970 - Added checking for feature CRE010 when processing *
018400200528      *             Account Balance Check.                            *
018500200528      *  MD026979 - Added field for Retail account and IBAN           *
018600200528      *             validation against WIP entries                    *
018700200528      *  MD024398 - API Performance Optimisation                      *
018800200528      *           - When deleting, retrieve account moves the need for*
018900200528      *             details for validation.  This removes the need for*
019000200528      *             Java to call APTRANR before APTRANVU.             *
019100200528      *  AR801992 - AcnothDet was blanked out when reviewing Accounts.*
019200200528      *             Blank out AcnothDet only for Insert transactions. *
019300200528      *             (Child: AR801993)                                 *
019400200528      *  AR971184A- During Amend Front Ofc Id must be updated with the*
019500200528      *             new one                                           *
019600200528      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
019700200528      *             Office Id is no more updated in master database   *
019800200528      *             files which provokes some big problems in third   *
019900200528      *             party product such as TOF.(Child:AR971185)        *
020000200528      *  AR946674 - Serious midas error has occured (Child: AR946675) *
020100200528      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
020200200528      *  AR847249 - Negative interest is shown in the main list and   *
020300200528      *             Loan Details enquiry screen                       *
020400200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
020500200528      *          - Some codes of CSF011 will be physically deleted    *
020600200528      *  AR869261 - Account Name defaulted to old customer when       *
020700200528      *             it is manually inserted                           *
020800200528      *  CSF011 - Customer Name on Inputs                             *
020900200528      *  AR812501 - Acct name is mandatory in MQ/SOAP testing of AMAD *
021000200528      *  AR820577 - Previous Overdraft fields not displayed in        *
021100200528      *             Confirmation pages for Close action               *
021200200528      *  CER049 - Stamp Tax                                           *
021300200528      *  CRE073 - Interest Rate Rounding                              *
021400200528      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
021500200528      *  AR802610 - Add Interest Scale flag in API definition.        *
021600200528      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
021700200528      *  CER059 - German Feature Upgrade to Delhi                     *
021800200528      *  262070 - Problem with flag for par24C in Account details.    *
021900200528      *           Default par24C according to customer maintenance.   *
022000200528      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
022100200528      *             when field is set to Y (Recompile)                *
022200200528      *  BUG22742 - Rectify the invalid defaulting when customer is   *
022300200528      *             flagged as Taxable                                *
022400200528      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
022500200528      *  BUG22973 - No TimeStamp in Transaction Confirmation during   *
022600200528      *             Completion and Authorisation                      *
022700200528      *  BUG23484 - Amend and AutoAuthorise existing record via SOAP  *
022800200528      *             fails, gets error message MMM1067                 *
022900200528      *  CRE015 - Retail Term and Notice Accounts                     *
023000200528      *  CRE030 - Default RE Accounts by Currency                     *
023100200528      *  256564 - Recompile due to PF changes done by fix 256330      *
023200200528      *  BUG17361A- Incorrect IBAN number written on account          *
023300200528      *             maintenance(Recompile)                            *
023400200528      *  245029A - Problem on RETABLE parameter when calling GLAMAD4VL*
023500200528      *            GLAMAD4VL. The parameter is cleared after call to  *
023600200528      *            GLAMAD1VL.                                         *
023700200528      *  249966 - Blank out AcnothDet only when defaulting has been   *
023800200528      *           done for an account.  Otherwise, retain the values  *
023900200528      *           as these values may have come from the interface or *
024000200528      *           is system defined.                                  *
024100200528      *  249660 - Correct retail account defaulting.                  *
024200200528      *  BUG13639 - Serious midas error in AMAD                       *
024300200528      *  245648 - Do not allow account to be edited when it already   *
024400200528      *           has been updated by another user.                   *
024500200528      *  243436 - BUG9141 has changed the conditioning for            *
024600200528      *           GLAMADJC01 - Move /COPY.                            *
024700200528      *  243129 - Initialise AccnFilFmt data structure.               *
024800200528      *  BUG13120a - Reverse Fix for BUG13120                         *
024900200528      *  BUG13120 - Missing Field - Passbook used on savings account  *
025000200528      *  242488  - Recompiled over changes to GLAMADUPD.              *
025100200528      *  240916  - Allowed execution of subroutine DFT@O when DDACTN  *
025200200528      *            is equal to 'I'.                                   *
025300200528      *  CPK025 - MidasPlus 1.3 packaging.  Field name conflict.      *
025400200528      *  240366 - Correct part of 240312. GL defaults should not be   *
025500200528      *           used when default retail account exists.            *
025600200528      *  237646 - Do not reset value of Idx when calling GLAMADRTV so *
025700200528      *           that errors found in validation will not be lost.   *
025800200528      *  240205 - Don't default retail indicators.  Patterned from    *
025900200528      *           215802.                                             *
026000200528      *  240312 - WPROCDATE is not initialised properly               *
026100200528      *         - Wrong parameters on call to GLAMADCVT               *
026200200528      *         - Allow defaulting only if called from initial screen *
026300200528      *         - Blank next day if statement frequency not periodic  *
026400200528      *  239316 - Upon insert confirmation, error message "A serious  *
026500200528      *           Midas error has occured." was displayed.            *
026600200528      *         - Error message "Account code is mandatory." appears  *
026700200528      *           twice. Code already here as TMPFX01 - now annotated *
026800200528      *           as 239316.                                          *
026900200528      *  237341 - Allow to refresh the AccnInMast dataarea to update  *
027000200528      *           the default values of the account code.             *
027100200528      *  238839 (Reopen) - IBAN field disappears when message RE72026 *
027200200528      *           is displayed because DDIBA1 is blank.  Execute      *
027300200528      *           GLVALID within INVALID tag, do not execute DFT@O    *
027400200528      *           if there are errors.                                *
027500200528      *  238625 - DDICNST is incorrect, initialise field properly     *
027600200528      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
027700200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
027800200528      *  237401  - Unable to delate account - error message on        *
027900200528      *            Dr Change value date. Caused by BUG4615.           *
028000200528      *            Also correct error in parameter length between     *
028100200528      *            GLAMASDVU and GLAMADRTV                            *
028200200528      *  BUG10280- Could not Amend record on AMAD                     *
028300200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
028400200528      *  BUG9141 - Only call ValdAcMast if delete (recompile)         *
028500200528      *  BUG8210 - GLC3571 failed due to DBERR in ACCNTBXC (empty)    *
028600200528      *            Need to change condition to read/write on ACCNTBXC *
028700200528      *            simply for all retail accounts. (Recompile)        *
028800200528      *  BUG8104- Reinstate call to AOACODR0 to populate A5ACTY       *
028900200528      *           needed by condition to display. BUG8104 shows an    *
029000200528      *           error message 'Portfolio Reference not valid'.      *
029100200528      *           This occurs when DDPTFR is validated as blank but   *
029200200528      *           not displayed. To prevent TMPFX01 from reoccuring,  *
029300200528      *           do not add message to array as this is also done in *
029400200528      *           GLAMAD1VL in validation GLVPFPO.                    *
029500200528      *  CAP086 - Introduce Auto Authorisation to the API's           *
029600200528      *           without it.                                         *
029700200528      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
029800200528      *  TMPFX01- 2 same error msgs (Account code is mandatory).      *
029900200528      *  CER001 - LUX Upgrade to MidasPlus                            *
030000200528      *  LLN022 - BOE Upgrade to MidasPlus.                           *
030100200528      *  BUG6218- Extra data must be included in the buffer           *
030200200528      *  BUG4615 - Show warning message upon deletion of account      *
030300200528      *            with cheque book details still existing            *
030400200528      *  CSD025 - Customer De-Activation                              *
030500200528      *  CSW037 - Additional Field Data on MT300/MT320                *
030600200528      *  CSW036 - Dual SWIFT BIC held on Client Details               *
030700200528      *  BUG4686- When defaulting retail accounts do not default      *
030800200528      *           customer name as this is not the name for the       *
030900200528      *           newly entered accounts' customer                    *
031000200528      *  BUG4400 - DB error occurred due to invalid timestamp         *
031100200528      *  CRE010 - Retail Account Balance Check                        *
031200200528      *  BUG4252 - Make sure files are mapped correctly (RECOMD/      *
031300200528      *            GLVAMCOPD and REAPWDPD/GLVAMPWPD)                  *
031400200528      *  BUG4196- Stopping changes being overwritten by other user    *
031500200528      *           when try to amend the record at the same time.      *
031600200528      *  BUG3068- Move INVALID tag after EXSR GLVALID                 *
031700200528      *  CLE025 - Credit Lines                                        *
031800200528      *  BUG2733 - Make sure files are mapped correctly (RECOMD/      *
031900200528      *            GLVAMCOPD and REAPWDPD/GLVAMPWPD)                  *
032000200528      *  BG2557 - Amend program to cater CSD012 changes, Standing     *
032100200528      *           Data Authorisation.                                 *
032200200528      *  BG2651 - DB error occurs if currency is blank on insert      *
032300200528      *  TDA084 - Mismatched fields between ExRIFilFmt and ValidExRI  *
032400200528      *           data structures.  Some fields in ValidExRi are      *
032500200528      *           overwritten when the values of ExRIFilFmt are moved *
032600200528      *           into it.   Move the fields of ExRIFilfmt  only to   *
032700200528      *           their matching fields in ValidExRI.                 *
032800200528      *  BUG553 - Ensure SRDEFT defaulting is for blank fields.       *
032900200528      *         - Set defaults from default RE account if applicable. *
033000200528      *         - Remove changes for BUG545 after fix BUG1271.        *
033100200528      *         - Remove CPY@ array from footer of source.            *
033200200528      *  CSC022 - Commitment Control Changes for MidasPlus            *
033300200528      *  CGL029 - Increase Account Code to 10 digits                  *
033400200528      *  CAP084 - API Wrapper project                                 *
033500200528      *                                                               *
033600200528      *****************************************************************
033700200528      ** +--------------------------------------+
033800200528      ** ¦ F-specs                              ¦
033900200528      ** ¦ =======                              ¦
034000200528      ** +--------------------------------------+
034100200528      *****************************************************************
034200200528
034300200528     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
034400200528
034500200528     FTABTBRE   IF   E             DISK    INFSR(*pssr)
034600200528     F                                     PREFIX(R_)
034700200528
034800200528     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)  USROPN
034900200528     FACCPTFR   IF   E           K DISK    INFSR(*PSSR)
035000200528     F                                     RENAME(ACCNTABF:ACCPTFRF)
035100200528     F                                     PREFIX(AC_)
035200200528      ** Default Retail Account
035300200528     FREDEF     IF   E           K DISK    INFSR(*PSSR)
035400200528     F                                     PREFIX(X_)
035500200528     F                                     IGNORE(REDEFAF)
035600200528     F                                     IGNORE(REDEFZF)
035700200528
035800200528      ** Retail Interest and Charge File
035900200528     FREIACXX   IF   E           K DISK    INFSR(*PSSR)
036000200528
036100200528      ** Accounts by Branch
036200200528     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
036300200528
036400200528      ** Account Numbers
036500200528     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMTBF)
036600200528     F                                     INFSR(*PSSR)
036700200528
036800200528      ** BRT Customer Details
036900200528     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
037000200528                                                                                              CRE015
037100200528      ** Account code extension                                                               CRE015
037200200528                                                                                              CRE015
037300200528     FSDACD1L0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
037400200528     F                                     PREFIX(X5:2)                                       CRE015
037500200528
037600200528     F/COPY WNCPYSRC,GLAMADJF01
037700200528      *                                                                                      LLN022A
037800200528     FBYACCTY0  IF   E           K DISK    INFSR(*pssr)                                      LLN022A
037900200528     F                                     USROPN                                           MD051247
038000200528      *                                                                                      LLN022A
038100200528      *****************************************************************
038200200528      ** +--------------------------------------+
038300200528      ** ¦ Automatically included D-specs       ¦
038400200528      ** ¦ ==============================       ¦
038500200528      ** +--------------------------------------+
038600200528      **
038700200528      ** Standard D-specs
038800200528      ** ================
038900200528      **
039000200528      ** The following /COPY line includes the LDA layout,
039100200528      ** the copyright array definition,
039200200528      ** and the following named constants:
039300200528      **    True       logical = *on (for indicator processing)
039400200528      **    False      logical = *off (for indicator processing)
039500200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
039600200528      **                                    handler)
039700200528      ** and the following variables:
039800200528      **    RunBefore  1A (for the PSSR)
039900200528
040000200528     D/COPY ZACPYSRC,STD_D_SPEC
040100200528
040200200528      ** Program Status Data Structure
040300200528      ** =============================
040400200528      ** The following /COPY line includes all the defined fields in the
040500200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
040600200528
040700200528     D/COPY ZACPYSRC,PSDS
040800200528      ** The following /COPY line includes definitions for the above fields
040900200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
041000200528      ** corresponding fields in the PSDS /COPY member, so that member
041100200528      ** must be included where this one is used.
041200200528
041300200528     D/COPY ZACPYSRC,PROCPARMS
041400200528
041500200528      **--------------------------------------------------------------------------------------------
041600200528      ** The following /COPY line includes the definitions for error and
041700200528      ** warning message arrays.
041800200528     D/COPY ZACPYSRC,ERR_ARRAYS
041900200528      **--------------------------------------------------------------------------------------------
042000200528
042100200528      **--------------------------------------------------------------------------------------------
042200200528      ** The following /COPY line includes the definitions for arrays
042300200528      ** specific to API *CTL modules.
042400200528     D/COPY ZACPYSRC,APICTLARR
042500200528      **--------------------------------------------------------------------------------------------
042600200528
042700200528      ** +--------------------------------------+
042800200528      ** ¦ End of automatically included D-specs¦
042900200528      ** ¦ =====================================¦
043000200528      ** +--------------------------------------+
043100200528
043200200528      *****************************************************************
043300200528      /EJECT
043400200528      *****************************************************************
043500200528
043600200528      ** +--------------------------------------+
043700200528      ** ¦ Manually included D-specs            ¦
043800200528      ** ¦ =========================            ¦
043900200528      ** +--------------------------------------+
044000200528
044100200528      ** +--------------------------------------+
044200200528      ** ¦ Named constants                      ¦
044300200528      ** ¦ ===============                      ¦
044400200528      ** +--------------------------------------+
044500200528
044600200528      ** +--------------------------------------+
044700200528      ** ¦ Arrays and Data Structures           ¦
044800200528      ** ¦ ==========================           ¦
044900200528      ** +--------------------------------------+
045000200528
045100200528      * Incoming Header
045200200528     D HeadIn        E DS                  EXTNAME(APHEADPD)
045300200528
045400200528      * Incoming Transaction
045500200528     D AccnInMast    E DS                  EXTNAME(GLAMADPD)
045600200528     D  AcnOthDet             84    213                                                       249660
045700200528     D  AccIn130             177    253                                                     MD041837
045800200528     D AccnInDebi    E DS                  EXTNAME(GLAMDIPD)
045900200528     D AccnInCred    E DS                  EXTNAME(GLAMCIPD)
046000200528     D AccnInComm    E DS                  EXTNAME(GLAMCOPD)
046100200528     D AccnInOthe    E DS                  EXTNAME(GLAMODPD)
046200200528     D AccnInPena    E DS                  EXTNAME(GLAMPPPD)                                  CRE015
046300200528     D AccnInPena1   E DS                  EXTNAME(GLAMPP1PD) PREFIX(P1:2)                    CRE015
046400200528     D AccnInPena2   E DS                  EXTNAME(GLAMPP2PD) PREFIX(P2:2)                    CRE015
046500200528     D/COPY OFCPYSRCZ,CRE101_017                                                              CRE101
046600200528
046700200528     D/COPY WNCPYSRC,GLAMADJD01
046800200528
046900200528     D ValidBoe      E DS                  EXTNAME(GLVAMADX0)                                LLN022A
047000200528
047100200528     D/COPY QWINDSRC,GLAMADDTA
047200200528      * Valid Account layout
047300200528     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
047400200528     D                                     PREFIX(V_)
047500200528      * Valid Extn. Account layout -> ACCNTBXC
047600200528     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
047700200528     D                                     PREFIX(V_)
047800200528     D V_QQACC1      E                     EXTFLD(QQACOD)                                     CGL029
047900200528      * Valid Extn. Account layout -> REIACD
048000200528     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
048100200528     D                                     PREFIX(V_)
048200200528     D V_QQACC2      E                     EXTFLD(QQACOD)                                     CGL029
048300200528     D ValidExR2     E DS                  EXTNAME(GLVAMRIPD)                                 TDA084
048400200528     D                                     PREFIX(W_)                                         TDA084
048500200528     D ValidExsh               1    144                                                       TDA084
048600200528     D ValidExex             212    284                                                       TDA084
048700200528      * Valid Extn. Account layout -> RECOMD
048800200528     D ValidExCO     E DS                  EXTNAME(GLVAMCOPD)
048900200528     D                                     PREFIX(V_)
049000200528     D V_QQACC3      E                     EXTFLD(QQACOD)                                     CGL029
049100200528     D ValidExCO1              1    286                                                      BUG2733
049200200528     D ValidExCOEx           354    363                                                      BUG2733
049300200528      **Valid Extn. Account layout ->*REAPWDPD*************************                       CSD101
049400200528     D ValidExPW     E DS                  EXTNAME(GLVAMPWPD)
049500200528     D                                     PREFIX(V_)
049600200528     D V_QQACC4      E                     EXTFLD(QQACOD)                                     CGL029
049700200528     D*ValidExPW1              1     33                                               BUG2733 CSD101
049800200528     D***ValidExPWEx           101    110                                             BUG2733 CSD101
049900200528     D ValidExPW1              1    146                                                       CSD101
050000200528     D ValidExPWEx           214    223                                                       CSD101
050100200528      * Valid Extn. Account layout -> REPRPNPD                                                CRE015
050200200528     D ValidPena     E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
050300200528     D                                     PREFIX(V_)                                         CRE015
050400200528
050500200528     D/COPY OFCPYSRCZ,CRE101_032                                                              CRE101
050600200528     D ValidLux      E DS                  EXTNAME(GLVAMLX1PD)                                CER001
050700200528     D                                     PREFIX(V_)                                         CER001
050800200528     D SVRCD         E DS                  EXTNAME(REACX1PD)                                  CER001
050900200528     D                                     PREFIX(E_)                                         CER001
051000200528
051100200528     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
051200200528     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
051300200528     D                                     PREFIX(A_)
051400200528     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
051500200528     D                                     PREFIX(B_)
051600200528     D ExRIFilsh               1    144                                                       TDA084
051700200528     D ExRIFilex             146    218                                                       TDA084
051800200528     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
051900200528     D                                     PREFIX(C_)
052000200528     D ExCOFilFmt1             1    286                                                      BUG2733
052100200528     D ExCOFilFmtEx          287    296                                                      BUG2733
052200200528     D***ExPWFilFmt    E DS                  EXTNAME(REAPWDPD)                                CSD101
052300200528     D***                                     PREFIX(D_)                                      CSD101
052400200528     D***ExPWFilFmt1             1     33                                             BUG2733 CSD101
052500200528     D***ExPWFilFmtEx           34     43                                             BUG2733 CSD101
052600200528     D ExPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CSD101
052700200528     D                                     PREFIX(D2_)                                        CSD101
052800200528     D ExPWFilFmt1             1    146                                                       CSD101
052900200528     D ExPWFilFmtEx          214    223                                                       CSD101
053000200528     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                  CRE015
053100200528     D                                     PREFIX(E_)                                         CRE015
053200200528     D/COPY OFCPYSRCZ,CRE101_033                                                              CRE101
053300200528
053400200528
053500200528      * (Current) Account in Screen Format - Master Details
053600200528     D CurAcMast     E DS                  EXTNAME(GLAMADPD)
053700200528     D                                     PREFIX(@)
053800200528      * (Current) Account in Screen Format - Debit Details
053900200528     D CurAcDebi     E DS                  EXTNAME(GLAMDIPD)
054000200528     D                                     PREFIX(@)
054100200528      * (Current) Account in Screen Format - Credit Details
054200200528     D CurAcCred     E DS                  EXTNAME(GLAMCIPD)
054300200528     D                                     PREFIX(@)
054400200528      * (Current) Account in Screen Format - Commision Details
054500200528     D CurAcComm     E DS                  EXTNAME(GLAMCOPD)
054600200528     D                                     PREFIX(@)
054700200528      * (Current) Account in Screen Format - Other Details
054800200528     D CurAcOthe     E DS                  EXTNAME(GLAMODPD)
054900200528     D                                     PREFIX(@)
055000200528      * Current account in screen format - Period and Penalty                                 CRE015
055100200528     D CurAcPena     E DS                  EXTNAME(GLAMPPPD)                                  CRE015
055200200528     D                                     PREFIX(@)                                          CRE015
055300200528     D CurExtDta     E DS                  EXTNAME(GLAMEXPD)                                MD044880
055400200528     D                                     PREFIX(@)                                        MD044880
055500200528     D/COPY OFCPYSRCZ,CRE101_034                                                              CRE101
055600200528      * Current Account in File Format                                                        BUG553
055700200528     D********CrAcFilFmt    E DS                  EXTNAME(ACCNTAB)                     BUG553 240312
055800200528     D**********                           PREFIX(E_)                                  BUG553 240312
055900200528     D CrAcFilFmt    E DS                  EXTNAME(GLVAMADPD)                                 240312
056000200528     D                                     PREFIX(E_)                                         240312
056100200528     D V_QQACC8      E                     EXTFLD(QQACOD)                                     CPK025
056200200528      * Current Account in File Format (Extension File)
056300200528     D*******CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)                            240312
056400200528     D**********                           PREFIX(CA_)                                        240312
056500200528     D CABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)                                 240312
056600200528     D                                     PREFIX(CA_)                                        240312
056700200528     D V_QQACC5      E                     EXTFLD(QQACOD)                                     240312
056800200528      * Current Account in File Format (Extension File)                                       BUG553
056900200528     D**********     CARIFilFmt    E DS                  EXTNAME(REIACD)               BUG553 240312
057000200528     D**********                           PREFIX(CB_)                                 BUG553 240312
057100200528     D CARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)                                 240312
057200200528     D                                     PREFIX(CB_)                                        240312
057300200528     D V_QQACC6      E                     EXTFLD(QQACOD)                                     240312
057400200528      * Current Account in File Format (Extension File)                                       BUG553
057500200528     D*******CACOFilFmt    E DS                  EXTNAME(RECOMD)                       BUG553 240312
057600200528     D**********                           PREFIX(CC_)                                 BUG553 240312
057700200528     D CACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)                                 240312
057800200528     D                                     PREFIX(CC_)                                        240312
057900200528     D V_QQACC7      E                     EXTFLD(QQACOD)                                     240312
058000200528      * Current Account in File Format (Extension File)                                       BUG553
058100200528     D***CAPWFilFmt    E DS                  EXTNAME(REAPWDPD)                         BUG553 240312
058200200528     D***                                    PREFIX(CD_)                               BUG553 240312
058300200528     D CAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 240312
058400200528     D                                     PREFIX(CD_)                                        240312
058500200528     D CAPPFilFmt    E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
058600200528     D                                     PREFIX(PP_)                                        CRE015
058700200528     D/COPY OFCPYSRCZ,CRE101_035                                                              CRE101
058800200528      * New Account in File Format                                                            BUG553
058900200528     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)                                 BUG553
059000200528      * New Account in File Format (Extension File)
059100200528     D NABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
059200200528     D                                     PREFIX(A_)
059300200528     D QQACOD1       E                     EXTFLD(QQACOD)                                     CGL029
059400200528      * New Account in File Format (Extension File)                                           BUG553
059500200528     D NARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)                                 BUG553
059600200528     D                                     PREFIX(B_)                                         BUG553
059700200528      * New Account in File Format (Extension File)                                           BUG553
059800200528     D NACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)                                 BUG553
059900200528     D                                     PREFIX(C_)                                         BUG553
060000200528      * New Account in File Format (Extension File)                                           BUG553
060100200528     D NAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 BUG553
060200200528     D                                     PREFIX(D_)                                         BUG553
060300200528     D NAPPFilFmt    E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
060400200528     D                                     PREFIX(P_)                                         CRE015
060500200528      * New Account in Screen Format - First Details                                          BUG553
060600200528     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)                                  BUG553
060700200528     D                                     PREFIX(N)                                          BUG553
060800200528      * New Account in Screen Format - Debit Details                                          BUG553
060900200528     D NewAcDebt     E DS                  EXTNAME(GLAMDIPD)                                  BUG553
061000200528     D                                     PREFIX(N)                                          BUG553
061100200528      * New Account in Screen Format - Credit Details                                         BUG553
061200200528     D NewAcCrdt     E DS                  EXTNAME(GLAMCIPD)                                  BUG553
061300200528     D                                     PREFIX(N)                                          BUG553
061400200528      * New Account in Screen Format - Commission Details                                     BUG553
061500200528     D NewAcComm     E DS                  EXTNAME(GLAMCOPD)                                  BUG553
061600200528     D                                     PREFIX(N)                                          BUG553
061700200528      * New Account in Screen Format - Other Details                                          BUG553
061800200528     D NewAcOthr     E DS                  EXTNAME(GLAMODPD)                                  BUG553
061900200528     D                                     PREFIX(N)                                          BUG553
062000200528      * New Account in Screen Format - Period and Penalty                                     CRE015
062100200528     D NewAcPena     E DS                  EXTNAME(GLAMPPPD)                                  CRE015
062200200528     D                                     PREFIX(N)                                          CRE015
062300200528     D/COPY OFCPYSRCZ,CRE101_036                                                              CRE101
062400200528
062500200528
062600200528      * Error indicators
062700200528     D OKAcMast      E DS                  EXTNAME(GLEAMADPD)
062800200528     D OKAcDebi      E DS                  EXTNAME(GLEAMDIPD)
062900200528     D OKAcCred      E DS                  EXTNAME(GLEAMCIPD)
063000200528     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
063100200528     D OKAcOthe      E DS                  EXTNAME(GLEAMODPD)
063200200528     D OKAcPena      E DS                  EXTNAME(GLEAMPPPD) PREFIX(X:1)                     CRE015
063300200528     D/COPY OFCPYSRCZ,CRE101_037                                                              CRE101
063400200528
063500200528
063600200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
063700200528      ** External DS for Bank Details
063800200528
063900200528     D RETABLE       E DS                  EXTNAME(TABTBRE)
064000200528     D                                     PREFIX(R_)
064100200528      ** EXTERNAL DS FOR RETAIL TABLE FILE
064200200528
064300200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
064400200528      ** External DS for Midas Modules details
064500200528
064600200528     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
064700200528      ** EXTERNAL DS FOR BRANCH DETAILS
064800200528
064900200528     D SDCURR        E DS                  EXTNAME(SDCURRPD)
065000200528      ***  External DS for currency details
065100200528
065200200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)
065300200528      ** External DS for API ICD
065400200528
065500200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)
065600200528
065700200528     D SCA_LCD       E                     EXTFLD(LCD)
065800200528      ** EXTERNAL DS FOR SAR DETAILS
065900200528                                                                                              CRE010
066000200528      ** Externally described DS for Nostro Code details                                      CRE010
066100200528     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CRE010
066200200528     D SDNOSTACCD    E                     EXTFLD(QQACCD)                                     CRE010
066300200528
066400200528     D InfData       E DS                  EXTNAME(GLAMIFPD)                                  CAP086
066500200528     D                                     PREFIX(IF_)                                        CAP086
066600200528      ** GL Extra Data - Classe 1 Data - File (D/B) format                                    CAP086
066700200528                                                                                              CAP086
066800200528     D ExtData       E DS                  EXTNAME(GLAMEXPD)
066900200528      * GL Accounts Extra Data - File (D/B) format
067000200528      *                                                                                       CER001
067100200528     D RegData       E DS                  EXTNAME(GLAMRXPD)                                  CER001
067200200528      *                                                                                       CER001
067300200528      ** GL Accounts Extra Data                                                               CER001
067400200528      *                                                                                       CER001
067500200528     D DSFDY         E DS                  EXTNAME(DSFDY)
067600200528      * First DS for Access programs - short data structure
067700200528     D DSSDY         E DS                  EXTNAME(DSSDY)
067800200528      * Second DS for Access programs - long data structure
067900200528
068000200528     D DSLDY         E DS                  EXTNAME(DSLDY)
068100200528      * Third DS for access programs, very long data structure
068200200528                                                                                              BG2557
068300200528      **  Data Structure for AOSVALR0 string                                                  BG2557
068400200528     DSVAL1            DS           200                                                       BG2557
068500200528     DSVAL11                   1      1                                                       BG2557
068600200528                                                                                              BG2557
068700200528     D CSD012          S              1A                                                      BG2557
068800200528     D SVALKK          C                   CONST('AuthReqAccntMaint')                         BG2557
068900200528     D*Wtimeval*       C                   CONST('0000-00-00-00.00.00.0000000')   BUG13120 BUG13120A
069000200528                                                                                              BG2557
069100200528      ** Override SDAULGL0                                                                    BG2557
069200200528     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          BG2557
069300200528                                                                                              BG2557
069400200528
069500200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
069600200528      ** 24X7 status dataarea
069700200528
069800200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
069900200528      ** SD data area
070000200528
070100200528     D SDACOD        E DS                  EXTNAME(SDACODPD)
070200200528      ** External DS for Account Code Details
070300200528
070400200528     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
070500200528      ** External DS for Portfolio Customer Details
070600200528
070700200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
070800200528     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
070900200528      ** External DS for Customer Details
071000200528
071100200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)
071200200528     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
071300200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
071400200528
071500200528      *                                                                                       CER001
071600200528      ** DS for Dealing Details                                                               CER001
071700200528      *                                                                                       CER001
071800200528     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CER001
071900200528     D QQACCD2       E                     EXTFLD(QQACCD)                                     CER001
072000200528                                                                                              CER001
072100200528     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
072200200528      ** EXTERNAL DS FOR MIDAS BASE RATE CODE DETAILS
072300200528
072400200528     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
072500200528     D  WCMTJOBS               4    103A                                                      CSC022
072600200528      ** Commitment Control dataarea                                                          CSC022
072700200528                                                                                              CSC022
072800200528      *                                                                                       CER001
072900200528      ** Valid Extended Account in File Format                                                CER001
073000200528      *                                                                                       CER001
073100200528     D ValidFilExt   E DS                  EXTNAME(GLVAMLX1PD)                                CER001
073200200528      *                                                                                       CER001
073300200528      ** Errors Indicators Extended Fields                                                    CER001
073400200528      *                                                                                       CER001
073500200528     D OkFlagsExt    E DS                  EXTNAME(GLEAMLX1PD)                                CER001
073600200528      *                                                                                       CER001
073700200528     D/COPY WNCPYSRC,GLH00644
073800200528      **--------------------------------------------------------------------------------------------
073900200528     D RUNDAT          DS            13
074000200528      * Rundate data area
074100200528     D  AGMBIN                13     13
074200200528
074300200528      *                                                                                       CER001
074400200528      ** Data Structure for CER001                                                            CER001
074500200528      *                                                                                       CER001
074600200528     D DATALUX         DS          1024                                                       CER001
074700200528     D  #1FLD1                 1      6  0                                                    CER001
074800200528      *                                                                                       CER001
074900200528     D  #1CNUM                 1      6                                                       CER001
075000200528     D  #1CCY                  7      9                                                       CER001
075100200528     D  #1ACOD                10     19                                                       CER001
075200200528     D  #1ACSQ                20     21                                                       CER001
075300200528     D  #1BRCA                22     24                                                       CER001
075400200528     D  #1ATYP                25     25                                                       CER001
075500200528     D  #1STFQ                26     26                                                       CER001
075600200528     D  #1AMNT                27     41  0                                                    CER001
075700200528     D  #1FOTR                45     64                                                       CER001
075800200528     D  #1TMST                65     90Z                                                      CER001
075900200528      *                                                                                       CER001
076000200528      ** +--------------------------------------+
076100200528      ** ¦ Declared variables                   ¦
076200200528      ** ¦ ==================                   ¦
076300200528      ** +--------------------------------------+
076400200528
076500200528      ** Error message field(s)
076600200528     D     Msg1        S                   LIKE(#MsgID)
076700200528
076800200528      ** Index for arrays of warning message ids etc
076900200528     D WIdx            S              3P 0
077000200528
077100200528      ** Fields (500A) to receive the incoming transaction
077200200528     D Accnt5001       S            500A
077300200528     D Accnt5002       S            500A
077400200528     D Accnt5003       S            500A
077500200528     D Accnt5004       S            500A
077600200528     D Accnt5005       S            500A
077700200528     D Accnt5006       S            500A                                                      CRE015
077800200528     D StmpTax500      S            500A                                                      CER049
077900200528     D*RepeatData      S           4500A                                               CRE015 CRE073
078000200528     D RepeatData      S           5382A                                                      CRE073
078100200528     D/COPY OFCPYSRCZ,CRE101_038                                                              CRE101
078200200528
078300200528      ** Field (500A) to receive the incoming Extra Data                                      CAP086
078400200528     D InfData500      S            500A                                                      CAP086
078500200528                                                                                              CAP086
078600200528      ** Field (500A) to receive the incoming Extra Data
078700200528     D ExtData500      S            500A
078800200528
078900200528      *                                                                                       CER001
079000200528      ** Field (500A) to receive the incoming Extra Data                                      CER001
079100200528      *                                                                                       CER001
079200200528     D RegData500      S            500A                                                      CER001
079300200528      *                                                                                       CER001
079400200528      ** Index for arrays of error message ids etc in Amend validation
079500200528     D AmIdx           S              3P 0
079600200528
079700200528      ** Indices for arrays used to set up corresponding sequence numbers
079800200528      ** for the fields that are in error
079900200528     D Ix              S              3P 0
080000200528     D Iy              S              3P 0
080100200528     D TIx             S              3P 0                                                    238839
080200200528
080300200528      ** Field to tell whether Commissions are to be displayed
080400200528     D CommDisp        S              1A
080500200528
080600200528      ** Fields for enhancement CSC022                                                        CSC022
080700200528     D CSC022          S              1A   INZ('N')                                           CSC022
080800200528     D WCmtSk          S              1A                                                      CSC022
080900200528                                                                                              CSC022
081000200528      ** Auto Authorisation flag                                                              CAP086
081100200528     D CAP086          S              1    INZ('N')                                           CAP086
081200200528                                                                                              CAP086
081300200528      ** Array to hold commitment jobs name                                                   CSC022
081400200528     D WCMT            S             10A   DIM(10)                                            CSC022
081500200528                                                                                              CSC022
081600200528     D DDEABC          S              1A                                                      CRE010
081700200528     D DDZINS          S              1A                                                    AR802610
081800200528     D TranInStamp     S            124A                                                      CER049
081900200528     D FillerBOE       S             25A                                                    MD043890
082000200528      ** Flags to indicate whether substitution is required in
082100200528      ** each of the various parts the transaction
082200200528     D RepMast         S              1A   inz('N')
082300200528     D RepDebi         S              1A   inz('N')
082400200528     D RepCred         S              1A   inz('N')
082500200528     D RepComm         S              1A   inz('N')
082600200528     D RepOthe         S              1A   inz('N')
082700200528
082800200528     D WProcDate       S                   LIKE(BJRDNB)
082900200528     D CSC011          S              1A   INZ('N')
083000200528     D CRE015          S              1A                                                      CRE015
083100200528     D CER055          S              1A                                                      CER055
083200200528     D CRE010          S              1A                                                    MD028970
083300200528     D CAP205          S              1A                                                    MD044546
083400200528                                                                                              240312
083500200528      ** Flag to indicate whether defaulting is required                                      240312
083600200528     D DefaultFlag     S              1A                                                      240312
083700200528
083800200528      ** APR Fields                                                                         MD054028
083900200528     D CER050          S              1A                                                    MD054028
084000200528     D DDAPRC          S              1A                                                    MD054028
084100200528     D DDAPDR          S              8A                                                    MD054028
084200200528     D DDAPCR          S              8A                                                    MD054028
084300200528     D @DDAPRC         S              1A                                                    MD054028
084400200528     D @DDAPDR         S              8A                                                    MD054028
084500200528     D @DDAPCR         S              8A                                                    MD054028
084600200528      ** Input parameters on call to AOPLCSR1
084700200528     D I@PARM          DS           256
084800200528     D  I#PORS                 1      1
084900200528     D  I#R997                 2      5
085000200528     D  I#CUST                 6     15
085100200528     D  I#BRCA                16     18
085200200528     D  I#BOOK                19     20
085300200528     D  I#PTFR                21     24
085400200528     D  I#CPGM                25     34
085500200528
085600200528      ** Output parameters on call to AOPLCSR1
085700200528     D O@PARM          S            256
085800200528
085900200528      *                                                                                       CER001
086000200528      ** Parameters on call to GLAMAD6UP                                                      CER001
086100200528      *                                                                                       CER001
086200200528     D PFIND           S              1                                                       CER001
086300200528      *                                                                                       CER001
086400200528      ** Introduced by CER001                                                                 CER001
086500200528      *                                                                                       CER001
086600200528     D ULX606          S              1                                                       CER001
086700200528      *                                                                                     BUG22742
086800200528      ** Introduced by CER048                                                               BUG22742
086900200528      *                                                                                     BUG22742
087000200528     D CER048          S              1                                                     BUG22742
087100200528      *                                                                                     BUG22742
087200200528     D/COPY OFCPYSRCZ,CRE101_039                                                              CRE101
087300200528     D/COPY WNCPYSRC,GLAMADVD01
087400200528
087500200528      *                                                                                      LLN022A
087600200528      ** Bank of England Details File                                                        LLN022A
087700200528      *                                                                                      LLN022A
087800200528     D SSVRCD        E DS                  EXTNAME(BYACCTY1)                                 LLN022A
087900200528     D                                     PREFIX(SV)                                        LLN022A
088000200528      *                                                                                      LLN022A
088100200528      ** Error indicators (OK#S)                                                             LLN022A
088200200528      *                                                                                      LLN022A
088300200528     D OkFlags       E DS                  EXTNAME(GLEAMADX0)                                LLN022A
088400200528      *                                                                                      LLN022A
088500200528     D WFind           S              1                                                      LLN022A
088600200528     D Idx             S              3P 0                                                   LLN022A
088700200528      *                                                                                      LLN022A
088800200528      ** +--------------------------------------+
088900200528      ** ¦ End of D-specs                       ¦
089000200528      ** ¦ ==============                       ¦
089100200528      ** +--------------------------------------+
089200200528
089300200528      ** +----------------------------------------+
089400200528      ** ¦ Hook for non-core D-specs (all types)  ¦
089500200528      ** ¦ also any I-specs (if necessary)        ¦
089600200528      ** ¦ =====================================  ¦
089700200528      ** +----------------------------------------+
089800200528
089900200528      *****************************************************************
090000200528      /EJECT
090100200528      *****************************************************************
090200200528
090300200528     C                   MOVEL     Accnt5001     AccnInMast
090400200528     C                   MOVEL     Accnt5002     AccnInDebi
090500200528     C                   MOVEL     Accnt5003     AccnInCred
090600200528     C                   MOVEL     Accnt5004     AccnInComm
090700200528     C                   MOVEL     Accnt5005     AccnInOthe
090800200528     C                   MOVEL     Accnt5006     AccnInPena1                                  CRE015
090900200528     C                   EVAL      DDZINS = %SUBST(Accnt5006:33:1)                          AR802610
091000200528     C                   MOVEL     StmpTax500    TranInStamp                                  CER049
091100200528     C                   MOVEL     InfData500    InfData                                      CAP086
091200200528     C                   MOVEL     Extdata500    Extdata
091300200528     C                   MOVEL     RegData500    RegData                                      CER001
091400200528     C                   MOVEL     RepeatData    AccnInPena2                                  CRE015
091500200528     C                   EVAL      AccnInPena = AccnInPena1 + AccnInPena2                     CRE015
091600200528     C                   EVAL      DDEABC = %SUBST(Buffer:865:1)                            MD040328
091700200528     C/COPY OFCPYSRCZ,CRE101_040                                                              CRE101
091800200528     C                   EVAL      WAPFOTranID = APFOTRANID + APFOASOCID                    AR971184
091900200528     C                   EVAL      FOTRID =  APFOTRANID + APFOASOCID                        AR971184
092000200528      ** ExtData Buffer Pointer                                                             MD054028
092100200528     C                   Z-ADD     1             eBfp              4 0                      MD054028
092200200528     C                   MOVEL     'GLAMEXPD'    FileName                                   MD054028
092300200528     C                   EXSR      GETRCDLN                                                 MD054028
092400200528     C                   ADD       RecordLen     eBfp                                       MD054028
092500200528      ** CER050 Fields                                                                      MD054028
092600200528     C                   IF        CER050 = 'Y'                                             MD054028
092700200528     C                   EVAL      DDAPRC = %SUBST(Extdata500:eBfp:1)                       MD054028
092800200528     C                   ADD       1             eBfp                                       MD054028
092900200528     C                   IF        DDAPRC = 'Y'                                             MD054028
093000200528     C                   EVAL      DDAPDR = %SUBST(Extdata500:eBfp:8)                       MD054028
093100200528     C                   ADD       8             eBfp                                       MD054028
093200200528     C                   EVAL      DDAPCR = %SUBST(Extdata500:eBfp:8)                       MD054028
093300200528     C                   ADD       8             eBfp                                       MD054028
093400200528     C                   ELSE                                                               MD054028
093500200528     C                   EVAL      DDAPDR = *BLANKS                                         MD054028
093600200528     C                   ADD       8             eBfp                                       MD054028
093700200528     C                   EVAL      DDAPCR = *BLANKS                                         MD054028
093800200528     C                   ADD       8             eBfp                                       MD054028
093900200528     C                   ENDIF                                                              MD054028
094000200528     C                   ENDIF                                                              MD054028
094100200528      *                                                                                       249660
094200200528      * Only default field values if called from the initial screen                           249660
094300200528     C                   Eval      DefaultFlag = 'N'                                          249660
094400200528     C                   If        DDACTN = 'I'                                               249660
094500200528     C                             or DDACTN = '1'                                            249660
094600200528     C                   Eval      DefaultFlag = 'Y'                                          249660
094700200528     C                   Eval      DDACTN = 'I'                                               249660
094800200528     C                   EndIf                                                                249660
094900200528
095000200528      * Reset variables gradually updated
095100200528
095200200528     C                   EXSR      RESETCYCLE
095300200528
095400200528     C                   MOVE      *OFF          *IN30
095500200528     C     DDACTN        IFEQ      'I'
095600200528     C                   MOVE      *ON           *IN30
095700200528     C                   ENDIF
095800200528      *
095900200528      *  Processing for Inserts
096000200528
096100200528     C                   EXSR      GLVACSQ
096200200528
096300200528      *  Validate Action Code
096400200528
096500200528     C     DDACTN        IFNE      'I'                                                        249660
096600200528     C     DefaultFlag   OREQ      'Y'                                                        249660
096700200528     C                   EXSR      ValidatAcn
096800200528     C                   ENDIF                                                                249660
096900200528
097000200528      *  If error in validation of action code, fail this input
097100200528      *
097200200528     C                   Eval      TIx = Ix                                                   238839
097300200528     C     Ix            IFNE      0
097400200528     C*****BLANKCHK      Ifeq      *Blanks                                           249966 MD041837
097500200528     C     AccIn130      Ifeq      *Blanks                                                  MD041837
097600200528     C     DDACTN        ANDEQ     'I'                                                      AR801992
097700200528     C                   MOVE      *Blanks       AcnOthDet                                    249660
097800200528     C                   Endif                                                                249966
097900200528     C                   GOTO      INVALID
098000200528     C                   END
098100200528     ***COPY*WNCPYSRC,GLAMADSMV1**                                                            250822
098200200528     C/COPY WNCPYSRC,GLAMADVC01
098300200528      *                                                                                      LLN022A
098400200528      ** Move fields from main screen to Data structure                                      LLN022A
098500200528      ** to be passed to window                                                              LLN022A
098600200528      *                                                                                      LLN022A
098700200528     C     LLN007        IFEQ      'Y'                                                       LLN022A
098800200528     C                   MOVE      DDBRCA        BYBRCD                                      LLN022A
098900200528     C                   MOVE      DDCUSN        BYCNUM                                      LLN022A
099000200528     C                   MOVE      DDCCY         BYCCY                                       LLN022A
099100200528     C                   MOVE      DDACOD        BYACOD                                      LLN022A
099200200528     C                   MOVE      DDACSQ        BYACSQ                                      LLN022A
099300200528      *                                                                                      LLN022A
099400200528      ** Account Type                                                                        LLN022A
099500200528      *                                                                                      LLN022A
099600200528     C                   MOVE      AMATYP        BYATYP                                      LLN022A
099700200528     C                   ENDIF                                                               LLN022A
099800200528      *                                                                                      LLN022A
099900200528
100000200528     C/COPY WNCPYSRC,GLAMADVC01
100100200528      *                                                                                      LLN022A
100200200528     C     Key_Byaccty0  KLIST                                                               LLN022A
100300200528     C                   KFLD                    LBRCD                                       LLN022A
100400200528     C                   KFLD                    LCNUM                                       LLN022A
100500200528     C                   KFLD                    LCCY                                        LLN022A
100600200528     C                   KFLD                    LACOD                                       LLN022A
100700200528     C                   KFLD                    LACSQ                                       LLN022A
100800200528      *                                                                                      LLN022A
100900200528     C                   IF        LLN007 = 'Y'                                              LLN022A
101000200528     C                   CLEAR                   SSVRCD                                      LLN022A
101100200528      *                                                                                      LLN022A
101200200528     C                   MOVE      DDBRCA        LBRCD                                       LLN022A
101300200528     C                   MOVE      DDCUSN        LCNUM                                       LLN022A
101400200528     C                   MOVE      DDCCY         LCCY                                        LLN022A
101500200528     C                   MOVE      DDACOD        LACOD                                       LLN022A
101600200528     C                   MOVE      DDACSQ        LACSQ                                       LLN022A
101700200528      *                                                                                      LLN022A
101800200528     C     Key_Byaccty0  CHAIN     BYACCTY0                                                  LLN022A
101900200528      *                                                                                      LLN022A
102000200528     C                   IF        %FOUND(BYACCTY0)                                          LLN022A
102100200528     C                   EVAL      SVLBRCD  = LBRCD                                          LLN022A
102200200528     C                   EVAL      SVLCNUM  = LCNUM                                          LLN022A
102300200528     C                   EVAL      SVLCCY   = LCCY                                           LLN022A
102400200528     C                   EVAL      SVLACODQ = LACODQ                                         LLN022A
102500200528     C                   EVAL      SVLACOD  = LACOD                                          LLN022A
102600200528     C                   EVAL      SVLACSQ  = LACSQ                                          LLN022A
102700200528     C                   EVAL      SVLNETI  = LNETI                                          LLN022A
102800200528     C                   EVAL      SVLDPTP  = LDPTP                                          LLN022A
102900200528     C                   EVAL      SVLSNOD  = LSNOD                                          LLN022A
103000200528     C                   EVAL      SVLLNTP  = LLNTP                                          LLN022A
103100200528     C                   EVAL      SVLMDAT  = LMDAT                                          LLN022A
103200200528     C                   EVAL      SVLLLIM  = LLLIM                                          LLN022A
103300200528     C                   ENDIF                                                               LLN022A
103400200528     C                   ENDIF                                                               LLN022A
103500200528
103600200528      *  Processing depends upon Action Code
103700200528
103800200528     C                   SELECT
103900200528
104000200528     C                   WHEN         DDACTN = 'I'
104100200528      ********************************OR DDACTN = 'D'                                BUG4615 BUG9141
104200200528      *  Processing for Inserts
104300200528     C                   EXSR      ValidateAc
104400200528     C/COPY WNCPYSRC,GLAMADJC01                                                               243436
104500200528     C                   EXSR      ValidateBOE                                              MD044880
104600200528                                                                                             BUG9141
104700200528     C                   WHEN         DDACTN = 'D'                                           BUG9141
104800200528      ***Processing*for*Inserts                                                     BUG9141 MD024398
104900200528      *  Processing for Deletes - set up field values from file to prevent                  MD024398
105000200528      *  failures in validation                                                             MD024398
105100200528     C                   EXSR      SetupAmd                                                 MD024398
105200200528     C                   MOVEL     CurAcMast     AccnInMast                                 MD024398
105300200528     C                   EVAL      DDACTN = 'D'                                             MD024398
105400200528     C                   MOVEL     CurAcDebi     AccnInDebi                                 MD024398
105500200528     C                   MOVEL     CurAcCred     AccnInCred                                 MD024398
105600200528     C                   MOVEL     CurAcComm     AccnInComm                                 MD024398
105700200528     C                   MOVEL     CurAcOthe     AccnInOthe                                 MD024398
105800200528     C                   MOVEL     CurAcPena     AccnInPena1                                MD024398
105900200528     C                   MOVEL     CurExtDta     ExtData                                    MD044880
106000200528     C/COPY OFCPYSRCZ,CRE101_041                                                              CRE101
106100200528     C                   EXSR      ValdAcMast                                                BUG9141
106200200528     C                   MOVEL     ExBXFilFmt    ValidExBX                                  AR820577
106300200528     C/COPY WNCPYSRC,GLH00645
106400200528                                                                                             BUG9141
106500200528     C*COPY*WNCPYSRC,GLAMADJC01*****                                                          243436
106600200528
106700200528     C                   EXSR      ValidateBOE                                              MD044880
106800200528     C**********         IF        LLN007 = 'Y'                                     LLN022A MD044880
106900200528     C**********         CALLB     'BYAMADW0VL'                                     LLN022A MD044880
107000200528     C**********         PARM                    DDACTN                             LLN022A MD044880
107100200528     C**********         PARM                    DATA                               LLN022A MD044880
107200200528     C**********         PARM                    ExtData                            LLN022A MD044880
107300200528     C**********         PARM                    OKFlags                            LLN022A MD044880
107400200528     C**********         PARM                    FldNameArr                         LLN022A MD044880
107500200528     C**********         PARM                    MsgIDArr                           LLN022A MD044880
107600200528     C**********         PARM                    MsgDtaArr                          LLN022A MD044880
107700200528     C**********         PARM                    Idx                                LLN022A MD044880
107800200528     C**********         PARM                    WFldNamArr                         LLN022A MD044880
107900200528     C**********         PARM                    WMsgIDArr                          LLN022A MD044880
108000200528     C**********         PARM                    WMsgDtaArr                         LLN022A MD044880
108100200528     C**********         PARM                    WIdx                               LLN022A MD044880
108200200528     C**********         PARM                    ValidBoe                           LLN022A MD044880
108300200528     C**********         ENDIF                                                      LLN022A MD044880
108400200528      *                                                                                      LLN022A
108500200528     C                   WHEN         DDACTN = 'A'
108600200528
108700200528      *  Processing for Amends or Changes
108800200528     C                   EXSR      SetupAmd
108900200528     C                   EXSR      ValdateAmd
109000200528     C                   EXSR      ValidateAc
109100200528     C/COPY WNCPYSRC,GLAMADJC02
109200200528
109300200528     C                   EXSR      ValidateBOE                                              MD044880
109400200528     C**********         IF        LLN007 = 'Y'                                     LLN022A MD044880
109500200528     C**********         CALLB     'BYAMADW0VL'                                     LLN022A MD044880
109600200528     C**********         PARM                    DDACTN                             LLN022A MD044880
109700200528     C**********         PARM                    DATA                               LLN022A MD044880
109800200528     C**********         PARM                    ExtData                            LLN022A MD044880
109900200528     C**********         PARM                    OKFlags                            LLN022A MD044880
110000200528     C**********         PARM                    FldNameArr                         LLN022A MD044880
110100200528     C**********         PARM                    MsgIDArr                           LLN022A MD044880
110200200528     C**********         PARM                    MsgDtaArr                          LLN022A MD044880
110300200528     C**********         PARM                    Idx                                LLN022A MD044880
110400200528     C**********         PARM                    WFldNamArr                         LLN022A MD044880
110500200528     C**********         PARM                    WMsgIDArr                          LLN022A MD044880
110600200528     C**********         PARM                    WMsgDtaArr                         LLN022A MD044880
110700200528     C**********         PARM                    WIdx                               LLN022A MD044880
110800200528     C**********         PARM                    ValidBoe                           LLN022A MD044880
110900200528     C**********         ENDIF                                                      LLN022A MD044880
111000200528      *                                                                                      LLN022A
111100200528     C                   ENDSL
111200200528      *
111300200528     C*****INVALID       TAG                                                                 BUG3068
111400200528     C     INVALID       TAG                                                                  238839
111500200528                                                                                              CSF011
111600200528      ** Populate Customer Details                                                            CSF011
111700200528                                                                                              CSF011
111800200528     C                   EXSR      SrPopCust                                                  CSF011
111900200528      *
112000200528      * Validate miscellaneous screen fields.
112100200528     C                   EXSR      GLVALID
112200200528      **********                                                                      BUG3068 238839
112300200528     C*****INVALID       TAG                                                          BUG3068 238839
112400200528
112500200528      *  Write to database
112600200528
112700200528     C     UpdateYN      IFEQ      'Y'
112800200528     C     Ix            ANDEQ     0
112900200528     C                   EXSR      WriteToDB
113000200528     C                   ENDIF
113100200528
113200200528     C                   SETON                                        LR
113300200528
113400200528     C     DDAPRC        Ifeq      'N'                                                        CER050
113500200528     C     DDAPCR        Ifne      *Blanks                                                    CER050
113600200528     C                   Move      *Blanks       DDAPCR                                       CER050
113700200528     C                   Endif                                                                CER050
113800200528     C     DDAPDR        Ifne      *Blanks                                                    CER050
113900200528     C                   Move      *Blanks       DDAPDR                                       CER050
114000200528     C                   Endif                                                                CER050
114100200528     C                   Endif                                                                CER050
114200200528     C     DDAPRC        Ifeq      'Y'                                                        CER050
114300200528     C     DDAPCR        Ifeq      *Blanks                                                    CER050
114400200528     C     @DDAPCR       andne     *Blanks                                                    CER050
114500200528     C                   Move      @DDAPCR       DDAPCR                                       CER050
114600200528     C                   Endif                                                                CER050
114700200528     C     DDAPDR        Ifeq      *Blanks                                                    CER050
114800200528     C     @DDAPDR       andne     *Blanks                                                    CER050
114900200528     C                   Move      @DDAPDR       DDAPDR                                       CER050
115000200528     C                   Endif                                                                CER050
115100200528     C                   Endif                                                                CER050
115200200528      ** Please ensure that when setting up the buffer, new core fields                      BUG6218
115300200528      ** are added before the data structure ExtData                                         BUG6218
115400200528                                                                                             BUG6218
115500200528      **If*timestamp*is*equal*to*blanks*retrieve*a*value*on*time*stamp*           BUG13120 BUG13120A
115600200528      **so*JAVA*program*can*process*proper*data*structure**************           BUG13120 BUG13120A
115700200528     C**********         IF        @TimeStamp = *Blanks                           BUG13120 BUG13120A
115800200528     C**********         EVAL      @TimeStamp = Wtimeval                          BUG13120 BUG13120A
115900200528     C**********         ENDIF                                                    BUG13120 BUG13120A
116000200528      **********                                                                  BUG13120 BUG13120A
116100200528     C                   MOVEL     AccnInPena    AccnInPena1                                  CRE015
116200200528     C                   MOVE      AccnInPena    AccnInPena2                                  CRE015
116300200528                                                                                              CRE015
116400200528     C                   EVAL                    Buffer = AccnInMast
116500200528     C                                           + AccnInDebi + AccnInCred
116600200528     C                                           + AccnInComm + AccnInOthe
116700200528     C                                           + @TimeStamp                                BUG4196
116800200528     C                                           + DDFAMT + AMATYP + AMSTYP
116900200528     C                                           + DODRCD + DOCRCD + INCST
117000200528     C                                           + BRT + ALT + LTYP + LINK
117100200528     C                                           + IBA1 + DOPOLC + DOPOLE
117200200528     C                                           + DSPTFR + DDDRMG1 + DDCRMG1
117300200528     C                                           + DDCEXA1 + DDCEXB1 + DDCEXC1
117400200528     C                                           + DDCEXD1 + DDCEXE1 + DDCEXF1
117500200528     C                                           + DDCEXG1
117600200528     C**********                                 + DDEABC                              CRE010 CAP086
117700200528     C**********                                 + DDEABC + InfData                    CAP086 CRE015
117800200528     C                                           + DDEABC                                     CRE015
117900200528     C                                           + AccnInPena1                                CRE015
118000200528     C                                           + DDZINS                                   AR802610
118100200528     C                                           + TranInStamp                                CER049
118200200528     C                                           + GLFullAcct                               MD026979
118300200528     C/COPY OFCPYSRCZ,CRE101_020                                                              CRE101
118400200528     C                                           + InfData                                    CRE015
118500200528     C                                           + ExtData                                  MD044880
118600200528     C                                           + DDAPRC                                   MD054028
118700200528     C                                           + DDAPDR                                   MD054028
118800200528     C                                           + DDAPCR                                   MD054028
118900200528     C**********                                 + FillerBOE                       MD043890 MD044880
119000200528     C                                           + AccnInPena2                                CRE015
119100200528     C                                           + RegData                                  MD044880
119200200528     C**********                                 + RegData                             CER001 CRE073
119300200528     C**********                                 + ExtData                           BUG62183 CRE073
119400200528     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4973) +                CRE073 CSF011
119500200528     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4933) +              CSF011 AR946674
119600200528     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
119700200528     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4924) +            AR946674 MD044880
119800200528     C***/COPY*OFCPYSRCZ,CRE101_068                                                  CRE101 MD044880
119900200528     C**********                               RegData + ExtData                     CRE073 MD044880
120000200528
120100200528     C     *IN28         IFEQ      *ON
120200200528     C                   CLOSE     PMPORTLL
120300200528     C                   ENDIF
120400200528      *
120500200528     C     LLN007        IFEQ      'Y'                                                      MD051247
120600200528     C                   CLOSE     BYACCTY0                                                 MD051247
120700200528     C                   ENDIF                                                              MD051247
120800200528     C                   RETURN
120900200528
121000200528      *****************************************************************
121100200528      /EJECT
121200200528      *****************************************************************
121300200528      *                                                               *
121400200528      * ValidatAcn - Routine to validate action code versus the       *
121500200528      *    Account IDs supplied                                       *
121600200528      *                                                               *
121700200528      *****************************************************************
121800200528     C     ValidatAcn    BEGSR
121900200528
122000200528     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
122100200528     C                             DDACTN = 'I'                                             AR971184
122200200528     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
122300200528     C                   ELSE                                                               AR971184
122400200528     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
122500200528     C                   ENDIF                                                              AR971184
122600200528      * Validate action code versus account IDs supplied
122700200528      * This function will set the Midas account reference
122800200528      * The account in file format from the GL database is retrieved as well
122900200528
123000200528     C                   RESET                   ReturnCode
123100200528     C                   CALLB     'GLAMADRTV'
123200200528      *
123300200528      * INPUTS
123400200528      *
123500200528      * Return code
123600200528     C                   PARM                    ReturnCode
123700200528      *
123800200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
123900200528      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
124000200528      *
124100200528     C                   PARM                    ModeofOp          6
124200200528      *
124300200528      * Response mode
124400200528     C                   PARM      'S'           APRESPMODE
124500200528      *
124600200528      * Action Code
124700200528     C                   PARM                    DDACTN            1
124800200528      *
124900200528      * Front Office Transaction ID
125000200528     C**********         PARM      DDACCN        APFOTranID                                   CLE025
125100200528     C**********         PARM      DDACCN        WAPFOTranID      40                 CLE025 AR971184
125200200528     C                   PARM                    WAPFOTranID      40                        AR971184
125300200528      *
125400200528      * (Midas) Account Key
125500200528     C                   PARM                    DDCUSN
125600200528     C                   PARM                    DDCCY
125700200528     C                   PARM                    DDACOD
125800200528     C                   PARM                    DDACSQ
125900200528     C                   PARM                    DDBRCA
126000200528     C                   PARM                    DDACNO
126100200528      *
126200200528      * Commissions
126300200528     C                   PARM                    CommDisp
126400200528      * IBAN
126500200528     C                   PARM                    CFT004
126600200528     C                   PARM                    DDIBAN                                       238839
126700200528     C                   PARM                    CRE015                                       CRE015
126800200528     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
126900200528      *
127000200528      ** New Accounts Currency
127100200528      *
127200200528     C                   PARM                    WDCCY             3
127300200528      *
127400200528      * OUTPUTS
127500200528      *
127600200528      * (Current) Account in file format
127700200528      * (Current) Account extension in file format
127800200528     C                   PARM                    AccnFilFmt
127900200528     C                   PARM                    ExBXFilFmt
128000200528     C                   PARM                    ExRIFilFmt
128100200528     C                   PARM                    ExCOFilFmt
128200200528     C                   PARM                    ExPWFilFmt
128300200528     C                   PARM                    DDPSWD                                       CSD101
128400200528     C                   PARM                    ExPPFilFmt                                   CRE015
128500200528     C/COPY OFCPYSRCZ,CRE101_014                                                              CRE101
128600200528      *
128700200528      * OK - Action code
128800200528     C                   PARM                    DDActnOK          1
128900200528      * OK - Account Key
129000200528     C                   PARM                    DDCUSNOK
129100200528     C                   PARM                    DDCCYOK
129200200528     C                   PARM                    DDACODOK
129300200528     C                   PARM                    DDACSQOK
129400200528     C                   PARM                    DDBRCAOK
129500200528     C                   PARM                    DDACNOOK
129600200528      *
129700200528      * Error fields/message IDs/message data (arrays) from/to caller
129800200528     C                   PARM                    FldNameArr
129900200528     C                   PARM                    MsgIdArr
130000200528     C                   PARM                    MsgDtaArr
130100200528      *
130200200528      * Array index (3P0) from/to caller
130300200528     C                   PARM                    Ix
130400200528      * Base Rate Auth Req
130500200528     C                   PARM                    AUTHRQ            1
130600200528      * Authorisation Mode
130700200528     C                   PARM                    AUTHMD            1
130800200528
130900200528     C                   IF        ULX606 = 'Y'                                               CER001
131000200528     C                   CALLB     'GLAMAD2RV'                                                CER001
131100200528     C                   PARM                    ReturnCode                                   CER001
131200200528     C                   PARM                    DDACTN                                       CER001
131300200528     C                   PARM                    WAPFOTranID                                  CER001
131400200528     C                   PARM                    DDCUSN                                       CER001
131500200528     C                   PARM                    DDCCY                                        CER001
131600200528     C                   PARM                    DDACOD                                       CER001
131700200528     C                   PARM                    DDACSQ                                       CER001
131800200528     C                   PARM                    DDBRCA                                       CER001
131900200528     C                   PARM                    DDACNO                                       CER001
132000200528     C                   PARM                    SVRCD                                        CER001
132100200528     C                   ENDIF                                                                CER001
132200200528      *                                                                                       245648
132300200528      ** Determine if another user has already updated the account                            245648
132400200528      ** before proceeding when action is not "Insert".                                       245648
132500200528      *                                                                                       245648
132600200528     C     DDACTN        IFNE      'I'                                                        245648
132700200528     C                   MOVEL     TMST          TimeStamp        26                          245648
132800200528      *                                                                                       CER001
132900200528     C     @TimeStamp    IFNE      *BLANKS                                                  BUG23484
133000200528      *                                                                                     BUG23484
133100200528     C     @TimeStamp    IFNE      TimeStamp                                                  245648
133200200528     C                   ADD       1             Ix                                           245648
133300200528     C                   MOVEL     '*ANY'        FldNameArr(1)                                245648
133400200528     C                   MOVEL     'MMM1067'     MsgIdArr(1)                                  245648
133500200528     C                   END                                                                  245648
133600200528      *                                                                                     BUG23484
133700200528     C                   ENDIF                                                              BUG23484
133800200528      *                                                                                       245648
133900200528     C                   ENDIF                                                                245648
134000200528      *                                                                                       245648
134100200528     C                   ENDSR
134200200528      *****************************************************************
134300200528      /EJECT
134400200528      *****************************************************************                       CER001
134500200528      *                                                               *                       CER001
134600200528      * ValidateLUX - Routine to validate Gl Amad File - LU Window    *                       CER001
134700200528      *                                                               *                       CER001
134800200528      *****************************************************************                       CER001
134900200528     C     ValidateLUX   BEGSR                                                                CER001
135000200528                                                                                              CER001
135100200528     C                   MOVE      DDCCY         #1CCY                                        CER001
135200200528     C                   MOVE      DDACOD        #1ACOD                                       CER001
135300200528     C                   MOVE      DDACSQ        #1ACSQ                                       CER001
135400200528     C                   MOVE      DDBRCA        #1BRCA                                       CER001
135500200528     C                   MOVE      DDCUSN        #1CNUM                                       CER001
135600200528     C                   MOVE      AMATYP        #1ATYP                                       CER001
135700200528      *                                                                                       CER001
135800200528     C                   CALLB     'GLAMAD6VL'                                                CER001
135900200528     C                   PARM                    DDACTN                                       CER001
136000200528     C                   PARM                    DATALUX                                      CER001
136100200528     C                   PARM                    RegData                                      CER001
136200200528     C                   PARM                    BNDCSP                                       CER001
136300200528     C                   PARM                    OkFlagsExt                                   CER001
136400200528     C                   PARM                    FldNameArr                                   CER001
136500200528     C                   PARM                    MsgIdArr                                     CER001
136600200528     C                   PARM                    MsgDtaArr                                    CER001
136700200528     C                   PARM                    Ix                                           CER001
136800200528     C                   PARM                    WFldNamArr                                   CER001
136900200528     C                   PARM                    WMsgIdArr                                    CER001
137000200528     C                   PARM                    WMsgDtaArr                                   CER001
137100200528     C                   PARM                    WIdx                                         CER001
137200200528     C                   PARM                    ValidFilExt                                  CER001
137300200528      *                                                                                       CER001
137400200528     C                   ENDSR                                                                CER001
137500200528      *****************************************************************                       CER001
137600200528      /EJECT                                                                                  CER001
137700200528     C/COPY WNCPYSRC,GLH00646
137800200528      **********************************************************************
137900200528     C     GLVACSQ       BEGSR
138000200528
138100200528     C                   CALLB     'GLVACSQ'
138200200528      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
138300200528      * INPUTS :
138400200528      * Return code
138500200528     C                   PARM      *BLANK        RetCodeOut
138600200528      * Account Screen Fields
138700200528     C**********         PARM                    DDACOD            4                          CGL029
138800200528     C                   PARM                    DDACOD           10                          CGL029
138900200528     C                   PARM                    DDACSQ            2
139000200528     C                   PARM                    DDCUSN            6
139100200528     C                   PARM                    A8BICN            6
139200200528     C                   PARM                    AGMBIN            1
139300200528      * OUTPUTS :
139400200528      * Error fields/message IDs/message data (arrays) from/to caller
139500200528     C                   PARM                    FldNameArr
139600200528     C                   PARM                    MsgIdArr
139700200528     C                   PARM                    MsgDtaArr
139800200528      *
139900200528     C                   PARM                    AMATYP            1
140000200528     C                   PARM                    AMSTYP            1
140100200528     C                   PARM                    WWTOIN            1
140200200528     C                   PARM                    WWRETL            1
140300200528      * Account Code - OK
140400200528      * Account Sequence - OK
140500200528     C**********         PARM      *ZERO         DDACODOK          1                        AR869261
140600200528     C**********         PARM      *ZERO         DDACSQOK          1                        AR869261
140700200528     C                   PARM      'Y'           DDACODOK          1                        AR869261
140800200528     C                   PARM      'Y'           DDACSQOK          1                        AR869261
140900200528      *                                                                                      239316
141000200528      ** Use the calling of this module only to populate necessary parameters                239316
141100200528      ** Clear the error messages as these fields will again be validated                    239316
141200200528      ** in GLAMAD1VL to avoid displaying the same error twice.                              239316
141300200528      *                                                                                      239316
141400200528     C                   CLEAR                   FldNameArr                                  239316
141500200528     C                   CLEAR                   MsgIdArr                                    239316
141600200528     C                   CLEAR                   MsgDtaArr                                   239316
141700200528     C**********         EVAL      DDACODOK = *BLANK                                 239316 AR869261
141800200528     C**********         EVAL      DDACSQOK = *BLANK                                 239316 AR869261
141900200528      *
142000200528      ** Access Account Code details via access program
142100200528      *  (database error handling done in access program)
142200200528     C**********         CALL      'AOACODR0'                                                239316
142300200528     C**********         PARM      '*DBERR '     @RTCD                                        BUG553
142400200528     C**********         PARM      *BLANKS       @RTCD                                BUG553 239316
142500200528     C**********         PARM      '*KEY   '     @OPTN                                       239316
142600200528     C**********         PARM      DDACOD        @ACOD            10                         239316
142700200528     C*****SDACOD        PARM      SDACOD        DSFDY                                       239316
142800200528      *
142900200528      * Not Found
143000200528     C*****@RTCD*        IFNE      *BLANKS                                                   239316
143100200528     C*****DDACOD        ANDNE     *BLANKS                                                   239316
143200200528     C***********        MOVEL     'N'           DDACODOK                                    239316
143300200528     C***********        ADD       1             Ix                                          239316
143400200528     C***********        MOVEL     'DDACOD'      FldNameArr(Ix)                              239316
143500200528     C***********        MOVEL     'RE71037'     MsgIdArr(Ix)                                239316
143600200528     C***********        END                                                                 239316
143700200528      *                                                                                      BUG8104
143800200528      ** Access Account Code details via access program                                      BUG8104
143900200528      ** (database error handling done in access program)                                    BUG8104
144000200528      ** The call is reinstated in order to populate SDACOD                                  BUG8104
144100200528      *                                                                                      BUG8104
144200200528     C                   CALL      'AOACODR0'                                                BUG8104
144300200528     C                   PARM      '*MSG   '     @RTCD                                       BUG8104
144400200528     C                   PARM      '*KEY   '     @OPTN                                       BUG8104
144500200528     C                   PARM      DDACOD        @ACOD            10                         BUG8104
144600200528     C     SDACOD        PARM      SDACOD        DSFDY                                       BUG8104
144700200528      *                                                                                      BUG8104
144800200528      *
144900200528      ** If each field filled, generate error on 1st input screen if account already exists.
145000200528      *
145100200528     C     DDCUSN        IFNE      *BLANKS
145200200528     C     DDCCY         ANDNE     *BLANKS
145300200528     C     DDACOD        ANDNE     *BLANKS
145400200528     C     DDACSQ        ANDNE     *BLANKS
145500200528     C     DDBRCA        ANDNE     *BLANKS
145600200528     C     DDACTN        ANDEQ     'I'
145700200528      **
145800200528     C                   MOVE      DDCUSN        WWCNUM
145900200528     C                   MOVEL     DDCCY         WWCCY
146000200528     C                   MOVE      DDACOD        WWACOD
146100200528     C                   MOVE      DDACSQ        WWACSQ
146200200528     C                   MOVE      DDBRCA        WWBRCA            3
146300200528      *
146400200528     C     WWACKA        CHAIN     ACCNTLXX                           80
146500200528      *
146600200528      ** If record was found then this account cannot be entered as new.
146700200528      ** Highlight Branch field (as only one field can be highlighted).
146800200528      *
146900200528     C     *IN80         IFEQ      '0'
147000200528     C                   MOVEL     'N'           DDBRCAOK
147100200528     C                   ADD       1             Ix
147200200528     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
147300200528     C                   MOVEL     'RE71025'     MsgIdArr(Ix)
147400200528      *
147500200528     C                   END
147600200528     C                   END
147700200528      *
147800200528      ** Ensure all fields are defauted if appropriate.
147900200528      *
148000200528     C     DDACTN        IFEQ      'I'
148100200528     C                   EXSR      SRDEFT
148200200528     C                   ENDIF
148300200528
148400200528     C                   ENDSR
148500200528      **********************************************************************
148600200528      /EJECT
148700200528      **********************************************************************
148800200528     C     GLVALID       BEGSR
148900200528
149000200528      *
149100200528      * Initialise screen conditioning fields for initial insert.
149200200528      *
149300200528     C     CER055        IFEQ      'Y'                                                        CER055
149400200528     C     V_BXPOLC      IFEQ      *ZEROS                                                     CER055
149500200528     C                   EVAL      DOPOLC = *BLANKS                                           CER055
149600200528     C                   ELSE                                                                 CER055
149700200528     C                   EVAL      ZDAYNO = V_BXPOLC                                          CER055
149800200528     C                   CALLB     'ZDATE2'                                                   CER055
149900200528     C                   PARM                    ZDAYNO                                       CER055
150000200528     C                   PARM                    BJDFIN                                       CER055
150100200528     C                   PARM                    ZDATE                                        CER055
150200200528     C                   PARM      *ZEROS        ZADATE                                       CER055
150300200528     C                   MOVEL(P)  ZDATE         DOPOLC                                       CER055
150400200528     C                   ENDIF                                                                CER055
150500200528      *                                                                                       CER055
150600200528     C     V_BXPOLE      IFEQ      *ZEROS                                                     CER055
150700200528     C                   EVAL      DOPOLE = *BLANKS                                           CER055
150800200528     C                   ELSE                                                                 CER055
150900200528     C                   EVAL      ZDAYNO = V_BXPOLE                                          CER055
151000200528     C                   CALLB     'ZDATE2'                                                   CER055
151100200528     C                   PARM                    ZDAYNO                                       CER055
151200200528     C                   PARM                    BJDFIN                                       CER055
151300200528     C                   PARM                    ZDATE                                        CER055
151400200528     C                   PARM      *ZEROS        ZADATE                                       CER055
151500200528     C                   MOVEL(P)  ZDATE         DOPOLE                                       CER055
151600200528     C                   ENDIF                                                                CER055
151700200528      *                                                                                       CER055
151800200528     C     V_BXPOLA      IFEQ      *ZEROS                                                     CER055
151900200528     C                   EVAL      DDPOLA = *BLANKS                                           CER055
152000200528     C                   ELSE                                                                 CER055
152100200528     C                   EVAL      ZFLD15 = V_BXPOLA                                          CER055
152200200528     C                   CALLB     'ZSEDIT'                                                   CER055
152300200528     C                   PARM                    ZFLD15           15 0                        CER055
152400200528     C                   PARM                    ZDECS             1 0                        CER055
152500200528     C                   PARM      *BLANKS       ZECODE            1                          CER055
152600200528     C                   PARM                    ZOUT21           21                          CER055
152700200528     C                   MOVE      ZOUT21        DDPOLA                                       CER055
152800200528     C                   ENDIF                                                                CER055
152900200528      *                                                                                       CER055
153000200528     C                   EVAL      ZFLD15 = *ZEROS                                            CER055
153100200528                                                                                              CER055
153200200528     C                   ELSE                                                                 CER055
153300200528     C                   MOVE      *BLANKS       DOPOLC            6
153400200528     C                   MOVE      *BLANKS       DOPOLE            6
153500200528     C                   ENDIF                                                                CER055
153600200528     C                   MOVEL     'N'           ALT               1
153700200528     C                   MOVEL     ' '           LTYP              1
153800200528     C                   MOVEL     *BLANKS       LINK             18
153900200528
154000200528     C                   MOVEL     'N'           INCST             1
154100200528      *
154200200528     C                   CLEAR                   SDCURR                                       BG2651
154300200528     C                   CALLB     'AOCURRR0'
154400200528     C                   PARM      *BLANKS       @RTCD
154500200528     C                   PARM      '*KEY   '     @OPTN
154600200528     C                   PARM      DDCCY         @CYCD             3
154700200528     C     SDCURR        PARM      SDCURR        DSSDY
154800200528     C*****@RTCD*********IFNE      *BLANKS                                                    BG2651
154900200528     C******LOCK*********IN        LDA                                                        BG2651
155000200528     C*******************MOVEL     'SDCURRPD'    DBFILE                         ************* BG2651
155100200528     C*******************Z-ADD     5             DBASE                          * DBERR 005 * BG2651
155200200528     C*******************MOVEL     CCY           DBKEY                          ************* BG2651
155300200528     C*******************OUT       LDA                                                        BG2651
155400200528     C*******************EXSR      *PSSR                                                      BG2651
155500200528     C*******************ENDIF                                                                BG2651
155600200528      *
155700200528      * Display if is an In currency past the transition start date.
155800200528      *
155900200528     C     A6INCY        IFEQ      'Y'
156000200528     C     A6TPSD        ANDLE     WProcDate
156100200528     C     CSC011        ANDEQ     'Y'                                                        238625
156200200528     C     A6INCY        OREQ      'Y'                                                        238625
156300200528     C     A6TPSD        ANDLE     BJRDNB                                                     238625
156400200528     C     CSC011        ANDNE     'Y'                                                        238625
156500200528     C                   MOVEL     'Y'           INCST
156600200528     C                   ENDIF
156700200528      *
156800200528      * Validate BRT category extension record exists.
156900200528      *
157000200528     C                   MOVEL     'N'           BRT               1
157100200528     C**********         MOVE      DDCUSN        @CNUM6            6 0                        CSD027
157200200528     C                   MOVE      DDCUSN        @CNUM6            6                          CSD027
157300200528      *
157400200528     C     S01383        IFEQ      'Y'
157500200528     C     @CNUM6        CHAIN     SDCBRTL1                           81
157600200528     C     *IN81         IFEQ      *OFF
157700200528     C     XRECI         ANDEQ     'D'
157800200528     C                   MOVEL     'Y'           BRT
157900200528     C                   ENDIF
158000200528     C                   ENDIF
158100200528      *
158200200528      ** Access Branch details
158300200528      *
158400200528     C                   CALL      'AOBRCHR1'
158500200528     C                   PARM      *BLANKS       @RTCD
158600200528     C                   PARM      '*KEY   '     @OPTN
158700200528     C                   PARM      DDBRCA        @BRCH             3
158800200528     C     SDBRCH        PARM      SDBRCH        DSSDY
158900200528      *
159000200528      ** Not Found
159100200528      *
159200200528     C     @RTCD         IFNE      *BLANKS
159300200528     C                   MOVEL     'N'           DDBRCAOK
159400200528     C                   ADD       1             Ix
159500200528     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
159600200528     C                   MOVEL     'RE71040'     MsgIdArr(Ix)
159700200528     C                   MOVE      'Y'           IBA1              1
159800200528     C                   ELSE
159900200528     C     A8GENM        IFEQ      '1'
160000200528     C     A8GENM        OREQ      ' '
160100200528     C                   MOVE      'N'           IBA1
160200200528     C                   ELSE
160300200528     C                   MOVE      'Y'           IBA1
160400200528     C                   ENDIF
160500200528     C                   ENDIF
160600200528      *
160700200528      ** Restrict output of Portfolio Reference
160800200528     C     BGPFMG        IFEQ      'Y'
160900200528      *
161000200528     C                   MOVEL     DDCUSN        I#CUST
161100200528     C                   MOVEL     DDBRCA        I#BRCA
161200200528     C                   MOVEL     *BLANKS       I#PTFR
161300200528     C                   MOVEL     *BLANKS       I#CPGM
161400200528      *
161500200528     C                   CALLB     'AOPLCSR1'
161600200528     C                   PARM      *BLANKS       @RTCD
161700200528     C                   PARM      '*KEY   '     @OPTN
161800200528     C                   PARM                    I@PARM
161900200528     C                   PARM      *BLANKS       O@PARM
162000200528     C     SDPLCS        PARM      SDPLCS        DSFDY
162100200528      *
162200200528      ** Default to display.
162300200528     C                   MOVE      'Y'           DSPTFR            1
162400200528     C     @RTCD         IFEQ      'PMA0008'
162500200528     C     @RTCD         OREQ      'PMA0009'
162600200528      *
162700200528     C     *IN30         ORNE      *ON
162800200528     C     I#PORS        ANDNE     'B'
162900200528     C     AMATYP        ANDNE     'R'
163000200528      *
163100200528     C     *IN30         ORNE      *ON
163200200528     C     I#PORS        ANDEQ     'B'
163300200528     C     AMATYP        ANDNE     'R'
163400200528     C     AMATYP        ANDNE     'N'
163500200528      *
163600200528     C     *IN30         OREQ      *ON
163700200528     C     I#PORS        ANDNE     'B'
163800200528     C     A5ACTY        ANDNE     'R'
163900200528      *
164000200528     C     *IN30         OREQ      *ON
164100200528     C     I#PORS        ANDEQ     'B'
164200200528     C     A5ACTY        ANDNE     'R'
164300200528     C     A5ACTY        ANDNE     'N'
164400200528      *
164500200528      ** Suppress Portfolio Reference.
164600200528     C                   MOVE      'N'           DSPTFR
164700200528      *
164800200528     C                   ENDIF
164900200528      *
165000200528     C                   ENDIF
165100200528      *
165200200528      ** Restrict output of Portfolio Reference
165300200528     C     BGN4ST        IFEQ      'Y'
165400200528     C                   MOVEL     DDCUSN        @KEY10
165500200528     C                   CALLB     'AOCUSTR1'
165600200528     C                   PARM      *BLANKS       @RTCD
165700200528     C                   PARM      '*KEY   '     @OPTN
165800200528     C                   PARM                    @KEY10           10
165900200528     C                   PARM      *BLANKS       @KEY7             7
166000200528     C     SDCUST        PARM      SDCUST        DSLDY
166100200528      *
166200200528     C     @RTCD         IFEQ      *BLANKS
166300200528     C     BBPRBA        ANDEQ     'Y'
166400200528      ** Default to display.
166500200528     C                   MOVE      'Y'           DSPTFR
166600200528     C                   ELSE
166700200528     C     BGPFMG        IFNE      'Y'
166800200528      ** Suppress Portfolio Reference.
166900200528     C                   MOVE      'N'           DSPTFR
167000200528     C                   ENDIF
167100200528     C                   ENDIF
167200200528     C                   ENDIF
167300200528      *
167400200528     C     A5ACTY        IFEQ      'R'
167500200528     C     DSPTFR        ANDEQ     'Y'
167600200528     C     *IN28         ANDEQ     *ON
167700200528     C     DDPTFR        IFEQ      *BLANKS
167800200528     C**********         MOVEL     DDCUSN        KPCNUM            6 0                        CSD027
167900200528     C                   MOVEL     DDCUSN        KPCNUM            6                          CSD027
168000200528     C                   MOVE      DDCUSN        WWCNUM
168100200528     C                   MOVE      DDCCY         WWCCY
168200200528     C                   MOVE      DDACOD        WWACOD
168300200528     C                   MOVE      DDACSQ        WWACSQ
168400200528     C                   MOVE      'N'           WWVAL             1
168500200528     C     KPCNUM        SETLL     PMPORTLL
168600200528     C     KPCNUM        READE     PMPORTLL                               88
168700200528      *
168800200528     C     *IN88         DOWEQ     *OFF
168900200528     C     WWVAL         ANDEQ     'N'
169000200528     C     PNDPCL        IFEQ      0
169100200528     C                   MOVE      PNPTFR        WWPTFR            4
169200200528     C     PTFRK         CHAIN     ACCPTFR                            81
169300200528      *
169400200528     C     *IN81         IFEQ      '0'
169500200528     C     KPCNUM        READE     PMPORTLL                               88
169600200528     C                   ELSE
169700200528     C                   MOVE      PNPTFR        DDPTFR
169800200528     C                   MOVE      'Y'           WWVAL
169900200528     C                   ENDIF
170000200528      *
170100200528     C                   ELSE
170200200528     C     KPCNUM        READE     PMPORTLL                               88
170300200528     C                   ENDIF
170400200528     C                   ENDDO
170500200528     C                   ENDIF
170600200528     C                   ENDIF
170700200528      *
170800200528     C*****DDACTN        IFNE      'I'                                                        240916
170900200528     C     DDACTN        IFEQ      'I'                                                        240916
171000200528     C     TIx           ANDEQ     0                                                          238839
171100200528     C                   EXSR      DFT@O
171200200528     C                   END
171300200528      *
171400200528      ** Set up Enable Account Balance Check Flag                                             CRE010
171500200528     C                   IF        CRE010 = 'Y'                                             MD028970
171600200528     C                             or CAP205 = 'Y'                                          MD044546
171700200528     C                   EXSR      SREnableABC                                                CRE010
171800200528     C                   ENDIF                                                              MD028970
171900200528                                                                                              CRE010
172000200528     C                   ENDSR
172100200528      *****************************************************************                       CRE010
172200200528      /EJECT                                                                                  CRE010
172300200528      *****************************************************************                       CRE010
172400200528      *                                                               *                       CRE010
172500200528      *  SREnableABC - Subroutine to setup Enable Account Balance     *                       CRE010
172600200528      *                Check flag                                     *                       CRE010
172700200528      *                                                               *                       CRE010
172800200528      *****************************************************************                       CRE010
172900200528     C     SREnableABC   BEGSR                                                                CRE010
173000200528                                                                                              CRE010
173100200528      ** Initialise account flag to 'N'                                                       CRE010
173200200528     C                   EVAL      DDEABC = 'N'                                               CRE010
173300200528                                                                                              CRE010
173400200528      ** Set to 'Y' only if retail and non=nostro account                                     CRE010
173500200528                                                                                              CRE010
173600200528     C                   IF        AMATYP = 'R'                                               CRE010
173700200528     C                   CALLB     'AONOSTR0'                                                 CRE010
173800200528     C                   PARM      *BLANKS       PRTCD             7                          CRE010
173900200528     C                   PARM      '*KEY   '     POPTN             7                          CRE010
174000200528     C                   PARM      DDCUSN        PKCUST            6                          CRE010
174100200528     C                   PARM      DDCCY         PKCYCD            3                          CRE010
174200200528     C                   PARM      DDACOD        PKACCD           10                          CRE010
174300200528     C                   PARM      DDACSQ        PKACSN            2                          CRE010
174400200528     C                   PARM                    PKNONB            2                          CRE010
174500200528     C                   PARM      DDBRCA        PKBRCD            3                          CRE010
174600200528     C                   PARM                    PKUCSN           10                          CRE010
174700200528     C                   PARM                    PKPNOI            1                          CRE010
174800200528     C     SDNOST        PARM      SDNOST        DSFDY                                        CRE010
174900200528                                                                                              CRE010
175000200528     C                   IF        PRTCD <> *BLANKS                                           CRE010
175100200528     C                   EVAL      DDEABC = 'Y'                                               CRE010
175200200528     C                   ENDIF                                                                CRE010
175300200528                                                                                              CRE010
175400200528     C                   ENDIF                                                                CRE010
175500200528                                                                                              CRE010
175600200528     C                   ENDSR                                                                CRE010
175700200528      **********************************************************************
175800200528      /EJECT
175900200528      **********************************************************************
176000200528      * DFT@O   - DEFAULTING FOR COMMISSIONS & OVERRIDES SCREEN
176100200528      **********************************************************************
176200200528     C     DFT@O         BEGSR
176300200528      *
176400200528     C                   MOVEL     CABXFilFmt    NABXFilFmt
176500200528      *
176600200528     C                   CALLB     'AOCUSTR1'
176700200528     C                   PARM      '*DBERR '     @RTCD
176800200528     C                   PARM      '*KEY   '     @OPTN
176900200528     C                   PARM      DDCUSN        @CNUM            10
177000200528     C                   PARM      *BLANKS       @CNST             7
177100200528     C     SDCUST        PARM      SDCUST        DSLDY
177200200528      *
177300200528     C     BBCGRP        IFEQ      *BLANKS
177400200528     C     @RTCD         ORNE      *BLANKS
177500200528     C                   MOVEL     '1'           BBCGRP
177600200528     C                   ENDIF
177700200528      *
177800200528      *
177900200528     C                   MOVEL     DDCCY         CCY                                          240916
178000200528     C                   MOVE      DDSTFQ        NDDSTFQ                                    MD042713
178100200528      *                                                                                     BUG13639
178200200528      ** Do not execute GLAMAD4DT when currency code is blanks,                             BUG13639
178300200528      ** Serious midas error will be encountered                                            BUG13639
178400200528      *                                                                                     BUG13639
178500200528     C                   If        DDCCY <> *Blanks                                         BUG13639
178600200528     C                   CALLB     'GLAMAD4DT'
178700200528      *
178800200528      * INPUTS :
178900200528      * Response mode
179000200528     C                   PARM                    RetCodeIn
179100200528
179200200528      * Customer Retail Group
179300200528     C                   PARM                    BBCGRP
179400200528      *
179500200528      ** CCRM Revenue Analysis
179600200528     C                   PARM                    CDE002
179700200528
179800200528      * Account details (DS) in file format
179900200528     C                   PARM                    AccnFilFmt
180000200528     C                   PARM                    NABXFilFmt
180100200528     C                   PARM                    NewAcPrim                                    222427
180200200528
180300200528      * OUTPUTS :
180400200528      * Screen 4 Output
180500200528     C                   PARM                    DDCEXA1          11
180600200528     C                   PARM                    DDCEXB1          11
180700200528     C                   PARM                    DDCEXC1          11
180800200528     C                   PARM                    DDCEXD1           8
180900200528     C                   PARM                    DDCEXE1           8
181000200528     C                   PARM                    DDCEXF1           8
181100200528     C                   PARM                    DDCEXG1           8
181200200528     C                   PARM                    DDDRMG1
181300200528     C                   PARM                    DDCRMG1
181400200528     C                   EndIf                                                              BUG13639
181500200528
181600200528     C                   ENDSR
181700200528      **********************************************************************
181800200528      /EJECT
181900200528      *****************************************************************
182000200528      *                                                               *
182100200528      * SETUPAMD - Set up fields that are needed in the validation    *
182200200528      *    of amendments and changes.                                 *
182300200528      *                                                               *
182400200528      *****************************************************************
182500200528     C     SetupAmd      BEGSR
182600200528
182700200528      * For Amends, put the complete (pre-existing) Account into the Valid
182800200528      *  file record - fields in this will be updated during processing
182900200528
183000200528     C                   MOVEL     AccnFilFmt    ValidAccn
183100200528     C                   MOVEL     ExBXFilFmt    ValidExBX
183200200528     C**********         MOVEL     ExRIFilFmt    ValidExRI                                    TDA084
183300200528     C                   CLEAR                   ValidExR2                                    TDA084
183400200528     C                   MOVEL     ExRIFilsh     ValidExsh                                    TDA084
183500200528     C                   MOVEL     ExRIFilex     ValidExex                                    TDA084
183600200528     C                   MOVEL     ValidExR2     ValidExRI                                    TDA084
183700200528     C**********         MOVEL     ExCOFilFmt    ValidExCO                                   BUG2733
183800200528     C                   MOVEL     ExCOFilFmt1   ValidExCO1                                  BUG2733
183900200528     C                   MOVEL     ExCOFilFmtEx  ValidExCOEx                                 BUG2733
184000200528     C                   MOVEL     ExPWFilFmt    ValidExPW                            BUG2733 CSD101
184100200528     C                   MOVEL     ExPWFilFmt1   ValidExPW1                                  BUG2733
184200200528     C                   MOVEL     ExPWFilFmtEx  ValidExPWEx                                 BUG2733
184300200528     C                   IF        CRE015 = 'Y'                                               CRE015
184400200528     C                   MOVEL     ExPPFilFmt    ValidPena                                    CRE015
184500200528     C                   ENDIF                                                                CRE015
184600200528     C/COPY OFCPYSRCZ,CRE101_045                                                              CRE101
184700200528
184800200528      * For Amends, convert the Account to screen format
184900200528
185000200528     C                   IF        CER050 = 'Y'                                             MD054028
185100200528     C                   MOVE      DDAPRC        V_BXAPRC                                   MD054028
185200200528     C                   ENDIF                                                              MD054028
185300200528      *                                                                                     MD054028
185400200528     C                   CALLB     'GLAMADCVT'
185500200528      *
185600200528      * INPUTS
185700200528      *
185800200528      * Return Code
185900200528     C                   PARM                    RetCodeIn
186000200528      *
186100200528      * Account - file formats
186200200528     C                   PARM                    ValidAccn
186300200528     C                   PARM                    ValidExBX
186400200528     C                   PARM                    ValidExRI
186500200528     C                   PARM                    ValidExCO
186600200528     C                   PARM                    ValidExPW
186700200528     C                   PARM                    ValidPena                                    CRE015
186800200528     C/COPY OFCPYSRCZ,CRE101_046                                                              CRE101
186900200528      *
187000200528      * Commissions
187100200528     C                   PARM                    CommDisp
187200200528      * CCRM Revenue Analysis
187300200528     C                   PARM                    CDE002            1
187400200528      * Retail charges details
187500200528     C                   PARM                    R_FACH
187600200528     C                   PARM                    R_TSTMC
187700200528      *                                                                                     MD054028
187800200528     C                   PARM                    DDAPRC            1                        MD054028
187900200528     C                   PARM                    DDAPDR            8                        MD054028
188000200528     C                   PARM                    DDAPCR            8                        MD054028
188100200528      *
188200200528      * Output parameters
188300200528      *
188400200528      * Account - screen formats
188500200528     C                   PARM                    CurAcMast
188600200528     C                   PARM                    CurAcDebi
188700200528     C                   PARM                    CurAcCred
188800200528     C                   PARM                    CurAcComm
188900200528     C                   PARM                    CurAcOthe
189000200528     C                   PARM                    CurAcPena                                    CRE015
189100200528     C/COPY OFCPYSRCZ,CRE101_057                                                              CRE101
189200200528      *
189300200528      * Screen 1 Output
189400200528     C                   PARM      *BLANK        DDDACC            6
189500200528     C**********         PARM      *BLANK        DDLINK           18                          CGL029
189600200528     C                   PARM      *BLANK        DDLINK           24                          CGL029
189700200528     C                   PARM      *BLANK        DDFAMT            8
189800200528      *
189900200528      * Screen 2 Output
190000200528     C                   PARM      *BLANK        DODRCD            6
190100200528     C**********         PARM      *BLANK        DDPOLC            6                          CER055
190200200528     C**********         PARM      *BLANK        DDPOLE            6                          CER055
190300200528     C                   PARM                    DOPOLC            6                          CER055
190400200528     C                   PARM                    DOPOLE            6                          CER055
190500200528      *
190600200528      * Screen 3 Output
190700200528     C                   PARM      *BLANK        DOCRCD            6
190800200528      *
190900200528      * Screen 4 Output
191000200528     C                   PARM      *BLANK        DDCEXA1          11
191100200528     C                   PARM      *BLANK        DDCEXB1          11
191200200528     C                   PARM      *BLANK        DDCEXC1          11
191300200528     C                   PARM      *BLANK        DDCEXD1           8
191400200528     C                   PARM      *BLANK        DDCEXE1           8
191500200528     C                   PARM      *BLANK        DDCEXF1           8
191600200528     C                   PARM      *BLANK        DDCEXG1           8
191700200528     C                   PARM      *BLANK        DDDRMG1          12
191800200528     C                   PARM      *BLANK        DDCRMG1          12
191900200528      *                                                                                     MD054028
192000200528     C                   MOVE      DDAPCR        @DDAPCR           8                        MD054028
192100200528     C                   MOVE      DDAPDR        @DDAPDR           8                        MD054028
192200200528
192300200528     C                   IF        LLN007 = 'Y'                                             MD044880
192400200528     C                   CALLB     'GLAMADCVT1'                                             MD044880
192500200528     C                   PARM                    RetCodeIn                                  MD044880
192600200528     C                   PARM                    DDCUSN                                     MD044880
192700200528     C                   PARM                    DDCCY                                      MD044880
192800200528     C                   PARM                    DDACOD                                     MD044880
192900200528     C                   PARM                    DDACSQ                                     MD044880
193000200528     C                   PARM                    DDBRCA                                     MD044880
193100200528     C                   PARM                    SSVRCD                                     MD044880
193200200528     C                   PARM                    CurExtDta                                  MD044880
193300200528     C                   ENDIF                                                              MD044880
193400200528
193500200528     C                   ENDSR
193600200528     C/COPY WNCPYSRC,GLH00647
193700200528      *****************************************************************
193800200528      /EJECT
193900200528      *****************************************************************
194000200528      *                                                               *
194100200528      * ValidateAc - Routine to validate the main Account details     *
194200200528      *                                                               *
194300200528      *****************************************************************
194400200528     C     ValidateAc    BEGSR
194500200528
194600200528      * Validate Account master details
194700200528
194800200528     C                   EXSR      ValdAcMast
194900200528      *
195000200528      *  If error in validation, fail this input
195100200528      *
195200200528     C     Ix            IFNE      0
195300200528     C                   GOTO      EValidTr
195400200528     C                   END
195500200528
195600200528     C     V_AMATYP      IFEQ      'R'
195700200528     C     DDACTN        ANDNE     'D'                                                        237401
195800200528                                                                                              CRE015
195900200528      ** Validate period and penalty details before the standard                              CRE015
196000200528      ** debit and credit details                                                             CRE015
196100200528                                                                                              CRE015
196200200528     C                   IF        CRE015 = 'Y'                                               CRE015
196300200528     C                             AND X5ATTY = 'P'                                           CRE015
196400200528     C                   EXSR      ValidatePen                                                CRE015
196500200528                                                                                              CRE015
196600200528      ** If error in validation, fail this input                                              CRE015
196700200528                                                                                              CRE015
196800200528     C     Ix            IFNE      0                                                          CRE015
196900200528     C                   GOTO      EValidTr                                                   CRE015
197000200528     C                   ENDIF                                                                CRE015
197100200528     C                   ENDIF                                                                CRE015
197200200528                                                                                              CRE015
197300200528      * Validate Account debit details
197400200528
197500200528     C                   EXSR      ValdAcDebi
197600200528      *
197700200528      *  If error in validation, fail this input
197800200528      *
197900200528     C     Ix            IFNE      0
198000200528     C                   GOTO      EValidTr
198100200528     C                   END
198200200528
198300200528      * Validate Account credit details
198400200528
198500200528     C                   EXSR      ValdAcCred
198600200528      *
198700200528      *  If error in validation, fail this input
198800200528      *
198900200528     C     Ix            IFNE      0
199000200528     C                   GOTO      EValidTr
199100200528     C                   END
199200200528
199300200528      * Validate Account commission details
199400200528
199500200528     C                   EXSR      ValdAcComm
199600200528      *
199700200528      *  If error in validation, fail this input
199800200528      *
199900200528     C     Ix            IFNE      0
200000200528     C                   GOTO      EValidTr
200100200528     C                   END
200200200528
200300200528      * Validate Account other details
200400200528
200500200528     C                   EXSR      ValdAcOthe
200600200528      *
200700200528      *  If error in validation, fail this input
200800200528      *
200900200528     C     Ix            IFNE      0
201000200528     C                   GOTO      EValidTr
201100200528     C                   END
201200200528     C                   ENDIF
201300200528
201400200528      ** Validate Lux Amad File - LU Window                                                   CER001
201500200528      *                                                                                       CER001
201600200528     C     ULX606        IFEQ      'Y'                                                        CER001
201700200528     C                   EXSR      ValidateLux                                                CER001
201800200528      *                                                                                       CER001
201900200528      ** If error in validation, fail this input                                              CER001
202000200528      *                                                                                       CER001
202100200528     C     Ix            IFNE      0                                                          CER001
202200200528     C                   LEAVESR                                                              CER001
202300200528     C                   ENDIF                                                                CER001
202400200528      *                                                                                       CER001
202500200528     C                   ENDIF                                                                CER001
202600200528      *                                                                                       CER001
202700200528     C/COPY WNCPYSRC,GLH00648
202800200528     C     EValidTr      ENDSR
202900200528      *****************************************************************
203000200528      /EJECT
203100200528      *****************************************************************
203200200528      *                                                               *
203300200528      * ValdAcMast - Validate Account Master details                  *
203400200528      *                                                               *
203500200528      *****************************************************************
203600200528     C     ValdAcMast    BEGSR
203700200528
203800200528     C                   MOVE      RETABLE       WRETABLE         52                         245029A
203900200528     C                   CALLB     'GLAMAD1VL'
204000200528
204100200528      * INPUTS
204200200528
204300200528      * Response mode
204400200528     C                   PARM      'S'           APRESPMODE
204500200528
204600200528      * Screen Format
204700200528     C**********         PARM      '  '          WFMT              2                          BUG553
204800200528     C                   PARM                    WFMT              2                          BUG553
204900200528
205000200528      ** ICD
205100200528     C                   PARM                    RETABLE
205200200528
205300200528      ** Account Master details
205400200528     C                   PARM                    AccnInMast
205500200528      * Front Office ID
205600200528     C**********         PARM                    APFOTranID       20                          CLE025
205700200528     C                   PARM                    WAPFOTranID                                  CLE025
205800200528
205900200528      ** Account Master Details OK inds
206000200528     C                   PARM                    OKAcMast
206100200528
206200200528      * Error fields/message IDs/message data (arrays) from/to caller
206300200528     C                   PARM                    FldNameArr
206400200528     C                   PARM                    MsgIDArr
206500200528     C                   PARM                    MsgDtaArr
206600200528      * Array index (3P0) from/to caller
206700200528     C                   PARM                    Ix
206800200528
206900200528      * Warning fields/message IDs/message data (arrays) from/to caller
207000200528     C                   PARM                    WFldNamArr
207100200528     C                   PARM                    WMsgIDArr
207200200528     C                   PARM                    WMsgDtaArr
207300200528      * Array index (3P0) from/to caller
207400200528     C                   PARM                    WIdx
207500200528
207600200528      * Full GL Account Number
207700200528     C**********         PARM      *BLANKS       WGLKEY           18                          CGL029
207800200528     C                   PARM      *BLANKS       WGLKEY           24                          CGL029
207900200528      * IBAN Sequence
208000200528     C                   Parm                    DDIBSQ            3
208100200528
208200200528      * Valid Account layout (DS) from/to caller
208300200528     C                   PARM                    ValidAccn
208400200528     C                   PARM                    ValidEXBX
208500200528      * Base Rate Auth req
208600200528     C                   PARM                    AUTHRQ            1
208700200528      * Authorisation Mode
208800200528     C                   PARM                    AUTHMD            1
208900200528      *                                                                                     MD054028
209000200528     C                   PARM                    DDAPRC            1                        MD054028
209100200528     C                   PARM                    DDAPDR            8                        MD054028
209200200528     C                   PARM                    DDAPCR            8                        MD054028
209300200528      *
209400200528      * Ensure first individual alternate address field is read if error encountered.
209500200528     C                   Z-ADD     1             I                 3 0
209600200528     C                   MOVEL     'DDRef     '  TEST             10
209700200528     C     TEST          LOOKUP    FldNameArr(I)                          99
209800200528     C     *IN99         IFEQ      '1'
209900200528     C                   MOVEL     'DDRF01    '  FldNameArr(I)
210000200528     C                   END
210100200528     C                   MOVE      WRETABLE      RETABLE                                     245029A
210200200528
210300200528     C                   ENDSR
210400200528      *****************************************************************
210500200528      /EJECT
210600200528      *****************************************************************
210700200528      *                                                               *
210800200528      * ValdAcDebi - Validate Account Debit details                   *
210900200528      *                                                               *
211000200528      *****************************************************************
211100200528     C     ValdAcDebi    BEGSR
211200200528
211300200528     C                   CALLB     'GLAMAD2VL'
211400200528
211500200528      * INPUTS
211600200528
211700200528      ** Account Master details
211800200528     C                   PARM                    AccnInMast
211900200528
212000200528      ** Account Debit details
212100200528     C                   PARM                    AccnInDebi
212200200528
212300200528      ** Account Commision details
212400200528     C                   PARM                    AccnInComm
212500200528
212600200528      * Front Office ID
212700200528     C**********         PARM                    APFOTranID       20                          CLE025
212800200528     C                   PARM                    WAPFOTranID                                  CLE025
212900200528
213000200528      ** Account Debit Details OK inds
213100200528     C                   PARM                    OKAcDebi
213200200528
213300200528      * Error fields/message IDs/message data (arrays) from/to caller
213400200528     C                   PARM                    FldNameArr
213500200528     C                   PARM                    MsgIDArr
213600200528     C                   PARM                    MsgDtaArr
213700200528      * Array index (3P0) from/to caller
213800200528     C                   PARM                    Ix
213900200528      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
214000200528     C                   PARM                    WFldNamArr                                   CER055
214100200528     C                   PARM                    WMsgIDArr                                    CER055
214200200528     C                   PARM                    WMsgDtaArr                                   CER055
214300200528      * Array index (3P0) from/to caller                                                      CER055
214400200528     C                   PARM                    WIdx                                         CER055
214500200528
214600200528      * Valid Account layout (DS) from/to caller
214700200528     C                   PARM                    ValidAccn
214800200528     C                   PARM                    ValidExBX
214900200528     C                   PARM                    ValidExRI
215000200528      * Revenue Analysis
215100200528     C                   PARM                    CDE002            1
215200200528     C                   PARM                    CRE015                                     AR947093
215300200528     C                   PARM                    X5ATTY                                     AR947093
215400200528      **********                                                                              BUG553
215500200528      **Ensure*first*branch*field*is*highlighted*for*alt.*DR*int.*popup*errors.               BUG553
215600200528     C**********         Z-ADD     1             I                 3 0                        BUG553
215700200528     C**********         MOVEL     'DDDACP    '  TEST             10                          BUG553
215800200528     C*****TEST*         LOOKUP    FldNameArr(I)                          99                  BUG553
215900200528     C******IN99         IFEQ      '1'                                                        BUG553
216000200528     C**********         MOVEL     'DDDRBR    '  FldNameArr(I)                                BUG553
216100200528     C**********         END                                                                  BUG553
216200200528
216300200528     C                   ENDSR
216400200528      *****************************************************************
216500200528      /EJECT
216600200528      *****************************************************************
216700200528      *                                                               *
216800200528      * ValdAcCred - Validate Account Credit details                  *
216900200528      *                                                               *
217000200528      *****************************************************************
217100200528     C     ValdAcCred    BEGSR
217200200528
217300200528     C                   CALLB     'GLAMAD3VL'
217400200528
217500200528      ** Account Master details
217600200528     C                   PARM                    AccnInMast
217700200528
217800200528      ** Account Credit details
217900200528     C                   PARM                    AccnInCred
218000200528
218100200528      ** Account Commision details
218200200528     C                   PARM                    AccnInComm
218300200528
218400200528      ** ICD
218500200528     C                   PARM                    R_TCAL
218600200528      * Front Office ID
218700200528     C**********         PARM                    APFOTranID       20                          CLE025
218800200528     C                   PARM                    WAPFOTranID                                  CLE025
218900200528
219000200528      ** Account Credit details OK inds
219100200528     C                   PARM                    OKAcCred
219200200528
219300200528      * Error fields/message IDs/message data (arrays) from/to caller
219400200528     C                   PARM                    FldNameArr
219500200528     C                   PARM                    MsgIDArr
219600200528     C                   PARM                    MsgDtaArr
219700200528      * Array index (3P0) from/to caller
219800200528     C                   PARM                    Ix
219900200528      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
220000200528     C                   PARM                    WFldNamArr                                 AR847249
220100200528     C                   PARM                    WMsgIDArr                                  AR847249
220200200528     C                   PARM                    WMsgDtaArr                                 AR847249
220300200528      ** Array index (3P0) from/to caller                                                   AR847249
220400200528     C                   PARM                    WIdx                                       AR847249
220500200528
220600200528      * Valid Account layout (DS) from/to caller
220700200528     C                   PARM                    ValidAccn
220800200528     C                   PARM                    ValidExRI
220900200528     C                   PARM                    ValidExBX
221000200528      * Revenue Analysis
221100200528     C                   PARM                    CDE002
221200200528     C                   PARM                    CRE015                                     AR947093
221300200528     C                   PARM                    X5ATTY                                     AR947093
221400200528      **********                                                                              BUG553
221500200528      **Ensure*first*branch*field*is*highlighted*for*alt.*CR*int.*popup*errors.               BUG553
221600200528     C**********         Z-ADD     1             I                 3 0                        BUG553
221700200528     C**********         MOVEL     'DDCACP    '  TEST             10                          BUG553
221800200528     C*****TEST*         LOOKUP    FldNameArr(I)                          99                  BUG553
221900200528     C******IN99         IFEQ      '1'                                                        BUG553
222000200528     C**********         MOVEL     'DDCRBR    '  FldNameArr(I)                                BUG553
222100200528     C**********         END                                                                  BUG553
222200200528      **********                                                                              BUG553
222300200528      **Ensure*first*branch*field*is*highlighted*for*alt.*charges*popup*errors.               BUG553
222400200528     C**********         Z-ADD     1             I                 3 0                        BUG553
222500200528     C**********         MOVEL     'DDCHCP    '  TEST             10                          BUG553
222600200528     C*****TEST*         LOOKUP    FldNameArr(I)                          99                  BUG553
222700200528     C******IN99         IFEQ      '1'                                                        BUG553
222800200528     C**********         MOVEL     'DDCHBR    '  FldNameArr(I)                                BUG553
222900200528     C**********         END                                                                  BUG553
223000200528
223100200528     C                   ENDSR
223200200528      *****************************************************************
223300200528      /EJECT
223400200528      *****************************************************************
223500200528      *                                                               *
223600200528      * ValdAcComm - Validate Account Commission details              *
223700200528      *                                                               *
223800200528      *****************************************************************
223900200528     C     ValdAcComm    BEGSR
224000200528
224100200528     C                   CALLB     'GLAMAD4VL'
224200200528
224300200528      ** Account Master details
224400200528     C                   PARM                    AccnInMast
224500200528
224600200528      ** Account Commision details
224700200528     C                   PARM                    AccnInComm
224800200528
224900200528      ** ICD
225000200528     C                   PARM                    RETABLE
225100200528      ** CCRM Revenue Analysis
225200200528     C                   PARM                    CDE002            1
225300200528
225400200528      ** Account Commissions OK inds
225500200528     C                   PARM                    OKAcComm
225600200528
225700200528      * Error fields/message IDs/message data (arrays) from/to caller
225800200528     C                   PARM                    FldNameArr
225900200528     C                   PARM                    MsgIDArr
226000200528     C                   PARM                    MsgDtaArr
226100200528      * Array index (3P0) from/to caller
226200200528     C                   PARM                    Ix
226300200528
226400200528      * Warning fields/message IDs/message data (arrays) from/to caller
226500200528     C                   PARM                    WFldNamArr
226600200528     C                   PARM                    WMsgIDArr
226700200528     C                   PARM                    WMsgDtaArr
226800200528      * Array index (3P0) from/to caller
226900200528     C                   PARM                    WIdx
227000200528      * Valid Account layout (DS) from/to caller
227100200528     C                   PARM                    ValidExCO
227200200528      * Valid Account layout (extension file) (DS) from/to caller
227300200528     C                   PARM                    ValidExBX
227400200528      * Valid Account layout (DS) from/to caller
227500200528     C                   PARM                    ValidAccn
227600200528
227700200528     C                   ENDSR
227800200528      *****************************************************************
227900200528      /EJECT
228000200528      *****************************************************************
228100200528      *                                                               *
228200200528      * ValdAcOthe - Validate Account Other details                   *
228300200528      *                                                               *
228400200528      *****************************************************************
228500200528     C     ValdAcOthe    BEGSR
228600200528
228700200528     C                   CALLB     'GLAMAD5VL'
228800200528
228900200528      ** Account Master details
229000200528     C                   PARM                    AccnInMast
229100200528
229200200528      ** Account Other Details
229300200528     C                   PARM                    AccnInOthe
229400200528     C/COPY OFCPYSRCZ,CRE101_022                                                              CRE101
229500200528
229600200528      ** Account Other details OK inds
229700200528     C                   PARM                    OKAcOthe
229800200528     C/COPY OFCPYSRCZ,CRE101_061                                                              CRE101
229900200528
230000200528      * Error fields/message IDs/message data (arrays) from/to caller
230100200528     C                   PARM                    FldNameArr
230200200528     C                   PARM                    MsgIDArr
230300200528     C                   PARM                    MsgDtaArr
230400200528      * Array index (3P0) from/to caller
230500200528     C                   PARM                    Ix
230600200528
230700200528      * Warning fields/message IDs/message data (arrays) from/to caller                       CER047
230800200528     C                   PARM                    WFldNamArr                                   CER047
230900200528     C                   PARM                    WMsgIDArr                                    CER047
231000200528     C                   PARM                    WMsgDtaArr                                   CER047
231100200528      * Array index (3P0) from/to caller                                                      CER047
231200200528     C                   PARM                    WIdx                                         CER047
231300200528                                                                                              CER047
231400200528      * Valid Account layout (DS) from/to caller
231500200528     C                   PARM                    ValidAccn
231600200528     C                   PARM                    ValidExRI
231700200528     C                   PARM                    ValidExPW
231800200528     C/COPY OFCPYSRCZ,CRE101_046                                                              CRE101
231900200528
232000200528     C                   ENDSR
232100200528      *****************************************************************                       CRE015
232200200528      /EJECT                                                                                  CRE015
232300200528      *****************************************************************                       CRE015
232400200528      *                                                               *                       CRE015
232500200528      *  ValidatePen - Validate Period and Penalty Details            *                       CRE015
232600200528      *                                                               *                       CRE015
232700200528      *****************************************************************                       CRE015
232800200528     C     ValidatePen   BEGSR                                                                CRE015
232900200528                                                                                              CRE015
233000200528     C                   CALLB     'GLAMAD7VL'                                                CRE015
233100200528                                                                                              CRE015
233200200528      ** Input                                                                                CRE015
233300200528                                                                                              CRE015
233400200528     C                   PARM                    AccnInMast                                   CRE015
233500200528     C                   PARM                    AccnInDebi                                   CRE015
233600200528     C                   PARM                    AccnInCred                                   CRE015
233700200528     C                   PARM                    CurAcDebi                                    CRE015
233800200528     C                   PARM                    CurAcCred                                    CRE015
233900200528     C                   PARM                    AccnInPena                                   CRE015
234000200528     C                   PARM                    OKAcPena                                     CRE015
234100200528                                                                                              CRE015
234200200528      ** Error fields/message IDs/message data (arrays) from/to caller                        CRE015
234300200528                                                                                              CRE015
234400200528     C                   PARM                    FldNameArr                                   CRE015
234500200528     C                   PARM                    MsgIDArr                                     CRE015
234600200528     C                   PARM                    MsgDtaArr                                    CRE015
234700200528     C                   PARM                    Ix                                           CRE015
234800200528                                                                                              CRE015
234900200528      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE015
235000200528                                                                                              CRE015
235100200528     C                   PARM                    WFldNamArr                                   CRE015
235200200528     C                   PARM                    WMsgIDArr                                    CRE015
235300200528     C                   PARM                    WMsgDtaArr                                   CRE015
235400200528     C                   PARM                    WIdx                                         CRE015
235500200528                                                                                              CRE015
235600200528      ** Valid account layout (DS) from/to caller                                             CRE015
235700200528                                                                                              CRE015
235800200528     C                   PARM                    AccnFilFmt                                   CRE015
235900200528     C                   PARM                    ValidAccn                                    CRE015
236000200528     C                   PARM                    ValidPena                                    CRE015
236100200528                                                                                              CRE015
236200200528     C                   ENDSR                                                                CRE015
236300200528      *****************************************************************
236400200528      /EJECT
236500200528      *****************************************************************
236600200528      *                                                               *
236700200528      * ValdateAmd - Routine to check whether the fields amended      *
236800200528      *    are amendable.                                             *
236900200528      *                                                               *
237000200528      *****************************************************************
237100200528     C     ValdateAmd    BEGSR
237200200528
237300200528     C                   CALLB     'GLAMADAMD'
237400200528      *
237500200528      * INPUTS
237600200528      *
237700200528      * Return Code
237800200528     C                   PARM                    RetCodeIn
237900200528      *
238000200528      * Incoming Account in Screen Format :
238100200528 Form * - Master Details
238200200528      * - Debit Details
238300200528      * - Credit Details
238400200528      * - Commision Details
238500200528      * - Other Details
238600200528     C                   PARM                    AccninMast
238700200528     C                   PARM                    AccninDebi
238800200528     C                   PARM                    AccninCred
238900200528     C                   PARM                    AccninComm
239000200528     C                   PARM                    AccninOthe
239100200528     C                   PARM                    AccnInPena                                   CRE015
239200200528      *
239300200528      * (Current) Account in Screen Format :
239400200528 Form * - Master Details
239500200528      * - Debit Details
239600200528      * - Credit Details
239700200528      * - Commision Details
239800200528      * - Other Details
239900200528     C                   PARM                    CurAcMast
240000200528     C                   PARM                    CurAcDebi
240100200528     C                   PARM                    CurAcCred
240200200528     C                   PARM                    CurAcComm
240300200528     C                   PARM                    CurAcOthe
240400200528     C                   PARM                    CurAcPena                                    CRE015
240500200528      *
240600200528      * OUTPUTS
240700200528      *
240800200528      * Error Indicators
240900200528     C                   PARM                    OKAcMast
241000200528     C                   PARM                    OKAcDebi
241100200528     C                   PARM                    OKAcCred
241200200528     C                   PARM                    OKAcComm
241300200528     C                   PARM                    OKAcOthe
241400200528     C                   PARM                    OKAcPena                                     CRE015
241500200528      *
241600200528      * Error fields/message IDs/message data (arrays) from/to caller
241700200528     C                   PARM                    AmFldNamAr
241800200528     C                   PARM                    AmMsgIdArr
241900200528     C                   PARM                    AmMsgDtaAr
242000200528      *
242100200528      * Array index (3P0) from/to caller
242200200528     C                   PARM                    AmIdx
242300200528      *
242400200528      * Amendments OK
242500200528     C                   PARM                    AmendOk           1
242600200528      *
242700200528      * Reset of Fields in Error Required (Y/N)
242800200528     C                   PARM      'Y'           ResetErrs         1
242900200528
243000200528      ** If any errors overwrite previous error information
243100200528
243200200528     C                   IF        AmIdx <> 0
243300200528     C                   MOVEA     AmMsgIdArr    MsgidArr
243400200528     C                   MOVEA     AmFldNamAr    FldNameArr
243500200528     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
243600200528     C                   Z-ADD     AmIdx         Ix
243700200528     C                   ENDIF
243800200528
243900200528     C                   ENDSR
244000200528      *****************************************************************
244100200528      /EJECT                                                                                MD044880
244200200528      *****************************************************************                     MD044880
244300200528      *                                                               *                     MD044880
244400200528      * ValidatBOE - Routine to validate Bank of England fields       *                     MD044880
244500200528      *                                                               *                     MD044880
244600200528      *****************************************************************                     MD044880
244700200528     C     ValidateBOE   BEGSR                                                              MD044880
244800200528     C                   IF        LLN007 = 'Y'                                             MD044880
244900200528     C                   CALLB     'BYAMADW0VL'                                             MD044880
245000200528     C                   PARM                    DDACTN                                     MD044880
245100200528     C                   PARM                    DATA                                       MD044880
245200200528     C                   PARM                    ExtData                                    MD044880
245300200528     C                   PARM                    OKFlags                                    MD044880
245400200528     C                   PARM                    FldNameArr                                 MD044880
245500200528     C                   PARM                    MsgIDArr                                   MD044880
245600200528     C                   PARM                    MsgDtaArr                                  MD044880
245700200528     C                   PARM                    Ix                                         MD044880
245800200528     C                   PARM                    WFldNamArr                                 MD044880
245900200528     C                   PARM                    WMsgIDArr                                  MD044880
246000200528     C                   PARM                    WMsgDtaArr                                 MD044880
246100200528     C                   PARM                    WIdx                                       MD044880
246200200528     C                   PARM                    ValidBoe                                   MD044880
246300200528     C                   ENDIF                                                              MD044880
246400200528     C                   ENDSR                                                              MD044880
246500200528      *****************************************************************                     MD044880
246600200528      /EJECT
246700200528      *****************************************************************
246800200528     C     WriteToDB     BEGSR
246900200528
247000200528     C     Ix            IFEQ      0
247100200528     C                   EXSR      SETUPVALID
247200200528     C                   EXSR      UpdateDB
247300200528     C/COPY WNCPYSRC,GLAMADJC03
247400200528      *                                                                                      LLN022A
247500200528     C                   IF        LLN007 = 'Y'                                              LLN022A
247600200528     C                   CALLB     'BYAMADW0UP'                                              LLN022A
247700200528     C                   PARM                    DDACTN                                      LLN022A
247800200528     C                   PARM                    DATA                                        LLN022A
247900200528     C                   PARM                    @RTCD                                       LLN022A
248000200528     C                   PARM                    WFIND                                       LLN022A
248100200528     C                   PARM                    ValidBoE                                    LLN022A
248200200528     C                   PARM                    SSVRCD                                      LLN022A
248300200528     C                   ENDIF                                                               LLN022A
248400200528      *                                                                                      LLN022A
248500200528     C                   ENDIF
248600200528
248700200528     C                   ENDSR
248800200528      *****************************************************************
248900200528      /EJECT
249000200528      *****************************************************************
249100200528      *                                                               *
249200200528      * RESETCYCLE- Reset error information that is gradually         *
249300200528      *    updated during each run of this program                    *
249400200528      *                                                               *
249500200528      *****************************************************************
249600200528     C     RESETCYCLE    BEGSR
249700200528
249800200528     C                   RESET                   FldNameArr
249900200528     C                   RESET                   MsgIDArr
250000200528     C                   RESET                   MsgDtaArr
250100200528     C                   RESET                   Ix
250200200528
250300200528     C                   RESET                   WFldNamArr
250400200528     C                   RESET                   WMsgIDArr
250500200528     C                   RESET                   WMsgDtaArr
250600200528     C                   RESET                   WIdx
250700200528
250800200528     C                   RESET                   AmFldNamAr
250900200528     C                   RESET                   AmMsgIDArr
251000200528     C                   RESET                   AmMsgDtaAr
251100200528     C                   RESET                   AmIdx
251200200528
251300200528     C                   RESET                   FldNoArr
251400200528
251500200528     C                   CLEAR                   CurAcMast
251600200528     C                   CLEAR                   CurAcDebi
251700200528     C                   CLEAR                   CurAcCred
251800200528     C                   CLEAR                   CurAcComm
251900200528     C                   CLEAR                   CurAcOthe
252000200528     C                   CLEAR                   CurAcPena                                    CRE015
252100200528     C/COPY OFCPYSRCZ,CRE101_042                                                              CRE101
252200200528
252300200528     C                   MOVE      *ALL'Y'       OKAcMast
252400200528     C                   MOVE      *ALL'Y'       OKAcDebi
252500200528     C                   MOVE      *ALL'Y'       OKAcCred
252600200528     C                   MOVE      *ALL'Y'       OKAcComm
252700200528     C                   MOVE      *ALL'Y'       OKAcOthe
252800200528     C                   MOVE      *ALL'Y'       OKAcPena                                     CRE015
252900200528     C/COPY OFCPYSRCZ,CRE101_043                                                              CRE101
253000200528     C/COPY WNCPYSRC,GLH00649
253100200528
253200200528     C                   CLEAR                   AccnFilFmt                                   243129
253300200528     C                   CLEAR                   ValidAccn
253400200528     C                   CLEAR                   ValidExBX
253500200528     C                   CLEAR                   ValidExCO
253600200528     C                   CLEAR                   ValidExRI
253700200528     C                   CLEAR                   ValidExPW
253800200528     C                   CLEAR                   ValidPena                                    CRE015
253900200528     C/COPY OFCPYSRCZ,CRE101_044                                                              CRE101
254000200528                                                                                              CRE015
254100200528      ** Access account code extension details                                                CRE015
254200200528                                                                                              CRE015
254300200528     C                   IF        CRE015 = 'Y'                                               CRE015
254400200528     C     DDACOD        CHAIN     SDACD1L0                                                   CRE015
254500200528     C                   IF        NOT %FOUND(SDACD1L0)                                       CRE015
254600200528     C                   EVAL      X5ATTY = *BLANKS                                           CRE015
254700200528     C                   ENDIF                                                                CRE015
254800200528     C                   ENDIF                                                                CRE015
254900200528
255000200528     C                   ENDSR
255100200528      *****************************************************************
255200200528      /EJECT
255300200528      *****************************************************************
255400200528      *                                                               *
255500200528      * SETUPVALID - Set up additional fields that are needed on the  *
255600200528      *    Valid file record.                                         *
255700200528      *                                                               *
255800200528      *****************************************************************
255900200528     C     SETUPVALID    BEGSR
256000200528
256100200528      * Set Valid file field for a delete.
256200200528     C                   IF        DDACTN = 'D'
256300200528     C                   EVAL      ValidAccn = AccnFilFmt
256400200528     C                   MOVEL     ExCOFilFmt    ValidExCO                                   BUG4252
256500200528     C                   MOVEL     ExPWFilFmt    ValidExPW                                   BUG4252
256600200528     C                   IF        CRE015 = 'Y'                                               CRE015
256700200528     C                   MOVEL     ExPPFilFmt    ValidPena                                    CRE015
256800200528     C                   ENDIF                                                                CRE015
256900200528     C/COPY OFCPYSRCZ,CRE101_045                                                              CRE101
257000200528     C                   ENDIF
257100200528      * Set Valid file field(s) that are needed for all Action Codes
257200200528     C                   EVAL      V_AMCHTP = DDACTN
257300200528     C                   EVAL      V_AMIBAN = DDIBAN
257400200528     C                   EVAL      V_AMIBSEQN = DDIBSQ
257500200528                                                                                            AR971184
257600200528     C**********         IF        DDACTN = 'I'                                   AR971184 AR971184A
257700200528     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
257800200528     C                   EVAL      V_AMFRNT =  APFOTranID                                   AR971184
257900200528     C                   EVAL      V_AMAFRT =  APFOAsocID                                   AR971184
258000200528     C                   EVAL      V_AMREPA =  APRprLocn                                    AR971184
258100200528     C                   ENDIF                                                              AR971184
258200200528                                                                                             BUG4196
258300200528      * Restore Timestamp from the original record                                           BUG4196
258400200528     C                   IF        DDACTN <> 'I'                                             BUG4196
258500200528                                                                                             BUG4400
258600200528      ** If timestamp is blank, then generate it                                             BUG4400
258700200528     C                   IF        @TimeStamp = *BLANKS                                      BUG4400
258800200528     C                   CALLB     'ZAGENTMSTM'                                              BUG4400
258900200528     C                   PARM                    @TimeStamp                                  BUG4400
259000200528     C                   ENDIF                                                               BUG4400
259100200528                                                                                             BUG4400
259200200528     C                   MOVEL     @TimeStamp    AMTMST                                      BUG4196
259300200528     C                   ENDIF                                                               BUG4196
259400200528      ** Set Auto Authorise flag for transactions from Interface                              CAP086
259500200528                                                                                              CAP086
259600200528     C                   IF        CAP086 = 'Y'                                               CAP086
259700200528     C                   EVAL      V_AMAUTH = IF_AUTH                                         CAP086
259800200528     C                   ENDIF                                                                CAP086
259900200528
260000200528     C                   ENDSR
260100200528      *****************************************************************
260200200528      /EJECT
260300200528      *****************************************************************
260400200528      *                                                               *
260500200528      * UPDATEDB - Update Database                                    *
260600200528      *                                                               *
260700200528      *****************************************************************
260800200528
260900200528     C     UPDATEDB      BEGSR
261000200528
261100200528      ** ACCOUNT DATABASE UPDATE
261200200528     C                   CALLB     'GLAMADUPD'
261300200528     C                   PARM      *BLANK        @@RTCD            7
261400200528     C                   PARM      'S'           RespMode          1
261500200528     C                   PARM                    ValidAccn
261600200528     C                   PARM                    ValidExBX
261700200528     C                   PARM                    ValidExRI
261800200528     C                   PARM                    ValidExCO
261900200528     C                   PARM                    ValidExPW
262000200528     C                   PARM                    ValidPena                                    CRE015
262100200528     C/COPY OFCPYSRCZ,CRE101_046                                                              CRE101
262200200528     C                   PARM                    CEU013
262300200528     C                   PARM                    CRT001
262400200528     C                   PARM                    CRT002
262500200528     C                   PARM                    CRE001
262600200528     C                   PARM                    CRT101
262700200528     C                   PARM                    CFT004
262800200528     C                   PARM                    CDE002            1
262900200528     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
263000200528     C                   PARM                    R_FACH
263100200528     C                   PARM                    R_TSTMC
263200200528      * Base Rate Auth req
263300200528     C                   PARM                    AUTHRQ            1
263400200528      * Authorisation Mode
263500200528     C                   PARM                    AUTHMD            1
263600200528      *
263700200528      *                                                                                       CER001
263800200528      ** Update extension details if ULX606 is switched on.                                   CER001
263900200528      *                                                                                       CER001
264000200528     C                   IF        @@RTCD = *BLANKS AND                                       CER001
264100200528     C                             ULX606 = 'Y'                                               CER001
264200200528     C                   CALLB     'GLAMAD6UP'                                                CER001
264300200528     C                   PARM                    DDACTN                                       CER001
264400200528     C                   PARM                    @@RTCD                                       CER001
264500200528     C                   PARM                    PFIND                                        CER001
264600200528     C                   PARM                    ValidFilExt                                  CER001
264700200528     C                   PARM                    SVRCD                                        CER001
264800200528     C                   ENDIF                                                                CER001
264900200528      *                                                                                       CER001
265000200528     C/COPY WNCPYSRC,GLH00650
265100200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
265200200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
265300200528      *
265400200528     C*****@RTCD         IFNE      *BLANK                                                     CLE025
265500200528     C*****@RTCD         ANDNE     '*RECUPD'                                                  CLE025
265600200528     C     @@RTCD        IFNE      *BLANK                                                     CLE025
265700200528     C     @@RTCD        ANDNE     '*RECUPD'                                                  CLE025
265800200528     C                   MOVEL     '0'           APIRetc
265900200528     C                   IF        (CSC022 = 'N')                                             CSC022
266000200528     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
266100200528     C                   ROLBK
266200200528     C                   ENDIF                                                                CSC022
266300200528     C                   EXSR      *PSSR
266400200528     C                   ELSE
266500200528     C                   IF        (CSC022 = 'N')                                             CSC022
266600200528     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
266700200528     C                   COMMIT
266800200528     C                   ENDIF                                                                CSC022
266900200528     C                   END
267000200528      *
267100200528      ** If update not done due to record being updated by another
267200200528      *  workstation send message to screen.
267300200528     C
267400200528     C*****@RTCD         IFEQ      '*RECUPD'                                                  245648
267500200528     C     @@RTCD        IFEQ      '*RECUPD'                                                  245648
267600200528     C
267700200528     C                   MOVEL     '*ANY'        FldNameArr(1)
267800200528     C                   MOVEL     'MMM1067'     MsgIdArr(1)
267900200528     C
268000200528     C                   END
268100200528
268200200528      ** Send the timestamp back to the screen                                              BUG22973
268300200528                                                                                            BUG22973
268400200528     C     @@RTCD        IFEQ      *BLANKS                                                  BUG22973
268500200528     C                   MOVEL     V_AMTMST      @Timestamp                                 BUG22973
268600200528     C                   ENDIF                                                              BUG22973
268700200528                                                                                            BUG22973
268800200528     C                   ENDSR
268900200528      *****************************************************************
269000200528      /EJECT
269100200528      ********************************************************************
269200200528     C/COPY ZACPYSRC,PSSR_ILE
269300200528      ********************************************************************
269400200528      /EJECT
269500200528      ********************************************************************
269600200528      * SRDEFT - Process default values in INSERT MODE
269700200528      ********************************************************************
269800200528     C     SRDEFT        BEGSR
269900200528      *                                                                                       249660
270000200528     C                   MOVE      AccnInMast    BLANKCHK        130                          249660
270100200528      *
270200200528      ** Initialise screen fields to default values:
270300200528      ** if called from initial screen                                                        240312
270400200528     C                   If        DefaultFlag = 'Y'                                          240312
270500200528     C**********                   and Blankchk = *BLANKS                            249660 MD041837
270600200528     C                             and AccIn130 = *BLANKS                                   MD041837
270700200528      ***Test rightmost 130 characters of screen, if blank then default.               BUG553 240312
270800200528     C******             MOVE      AccnInMast    BLANKCHK        130                   BUG553 240312
270900200528     C*****BLANKCHK      IFEQ      *BLANKS                                             BUG553 237341
271000200528      *                                                                                       BUG553
271100200528      ** If account code is retail and on REDEFD then default from that.                      BUG553
271200200528     C     AMATYP        IFEQ      'R'                                                        BUG553
271300200528      *                                                                                       BUG553
271400200528     C                   MOVE      DDACOD        WWACOK                                       BUG553
271500200528     C                   MOVE      'D'           WWRECI                                       BUG553
271600200528      *                                                                                       CRE030
271700200528     C                   IF        CRE030 = 'Y'                                               CRE030
271800200528     C                   MOVE      DDCCY         WWACCY                                       CRE030
271900200528     C     ACODK2        CHAIN     REDEFDF                            50                      CRE030
272000200528     C                   ELSE                                                                 CRE030
272100200528     C*****ACODK         CHAIN     REDEF                              50               BUG553 CRE030
272200200528     C     ACODK         CHAIN     REDEFDF                            50                      CRE030
272300200528     C                   ENDIF                                                                CRE030
272400200528      *                                                                                       BUG553
272500200528     C     *IN50         IFEQ      '0'                                                        BUG553
272600200528     C     X_RECI        ANDEQ     'D'                                                        BUG553
272700200528      *                                                                                       BUG553
272800200528      * Save key of account being entered.                                                    BUG553
272900200528      *                                                                                       BUG553
273000200528     C                   MOVE      DDACTN        WDACTN            1                          BUG553
273100200528     C                   MOVE      DDCUSN        WDCUSN            6                          BUG553
273200200528     C                   MOVE      DDCCY         WDCCY             3                          BUG553
273300200528     C                   MOVE      DDACOD        WDACOD           10                          BUG553
273400200528     C                   MOVE      DDACSQ        WDACSQ            2                          BUG553
273500200528     C                   MOVE      DDBRCA        WDBRCA            3                          BUG553
273600200528     C                   MOVE      DDACNO        WDACNO           10                          BUG553
273700200528      *                                                                                       BUG553
273800200528      * Lookup account for default account found.                                             BUG553
273900200528      * Result returned to Current file formats.                                              BUG553
274000200528      *                                                                                       BUG553
274100200528     C                   MOVE      'R'           DDACTN                                       BUG553
274200200528      *                                                                                       BUG553
274300200528     C                   EXSR      SRRTVACC                                                   BUG553
274400200528      *                                                                                       BUG553
274500200528      * Convert the default Account to screen format                                          BUG553
274600200528      * Result returned to New screen formats.                                                BUG553
274700200528      * Then moved to the Current screen formats.                                             BUG553
274800200528      *                                                                                       BUG553
274900200528     C                   MOVE      WDACTN        DDACTN                                       BUG553
275000200528     C     DDCUSNOK      IFEQ      'N'                                                        249660
275100200528     C     DDCCYOK       OREQ      'N'                                                        249660
275200200528     C     DDACODOK      OREQ      'N'                                                        249660
275300200528     C     DDACSQOK      OREQ      'N'                                                        249660
275400200528     C     DDBRCAOK      OREQ      'N'                                                        249660
275500200528     C     DDACNOOK      OREQ      'N'                                                        249660
275600200528     C     Ix            ORNE      *Zero                                                      249660
275700200528     C                   Eval      DefaultFlag = 'N'                                          249660
275800200528     C                   Endif                                                                249660
275900200528      *                                                                                       249660
276000200528     C     DefaultFlag   Ifeq      'Y'                                                        249660
276100200528     C                   EXSR      SRCVTACC                                                   BUG553
276200200528      * Set action code in CurAcMast.                                                         BUG553
276300200528     C                   MOVE      WDACTN        @DDACTN                                      BUG553
276400200528      *                                                                                       BUG553
276500200528      ** Replace the original account reference and reset basic fields.                       BUG553
276600200528      *                                                                                       BUG553
276700200528     C                   MOVE      WDCUSN        DDCUSN                                       BUG553
276800200528     C                   MOVE      WDCCY         DDCCY                                        BUG553
276900200528     C                   MOVE      WDACOD        DDACOD                                       BUG553
277000200528     C                   MOVE      WDACSQ        DDACSQ                                       BUG553
277100200528     C                   MOVE      WDBRCA        DDBRCA                                       BUG553
277200200528     C                   MOVE      WDACNO        DDACNO                                       BUG553
277300200528     C                   MOVE      *BLANKS       DDDACO                                       BUG553
277400200528     C                   MOVE      *BLANKS       DDIBAN                                       BUG553
277500200528      *                                                                                       BUG553
277600200528      ** Copy the New account details to the current account details.                         BUG553
277700200528      *                                                                                       BUG553
277800200528     C******             MOVE      WDCUSN        E_CNUM                                BUG553 240312
277900200528     C******             MOVE      WDCCY         E_CCY                                 BUG553 240312
278000200528     C******             MOVE      WDACOD        E_ACOD                                BUG553 240312
278100200528     C******             MOVE      WDACSQ        E_ACSQ                                BUG553 240312
278200200528     C******             MOVE      WDBRCA        E_BRCA                                BUG553 240312
278300200528     C******             MOVE      WDACNO        E_ACNO                                BUG553 240312
278400200528     C******             MOVE      *BLANKS       E_IBAN                                BUG553 240312
278500200528     C******             MOVE      *BLANKS       E_IBSEQN                              BUG553 240312
278600200528     C                   MOVE      WDCUSN        E_AMCNUM                                     240312
278700200528     C                   MOVE      WDCCY         E_AMCCY                                      240312
278800200528     C                   MOVE      WDACOD        E_AMACOD                                     240312
278900200528     C                   MOVE      WDACSQ        E_AMACSQ                                     240312
279000200528     C                   MOVE      WDBRCA        E_AMBRCA                                     240312
279100200528     C                   MOVE      WDACNO        E_AMACNO                                     240312
279200200528     C                   MOVE      *BLANKS       E_AMIBAN                                     240312
279300200528     C                   MOVE      *BLANKS       E_AMIBSEQN                                   240312
279400200528     C                   MOVE      WDCUSN        E_AMCNUM                                     240312
279500200528                                                                                              240312
279600200528      *                                                                                       BUG553
279700200528     C                   MOVE      DDACOD        WWACOK                                       BUG553
279800200528     C                   MOVE      'D'           WWRECI                                       BUG553
279900200528      *                                                                                       BUG553
280000200528     C                   IF        CRE030 = 'Y'                                               CRE030
280100200528     C                   MOVE      DDCCY         WWACCY                                       CRE030
280200200528     C     ACODK2        CHAIN     REDEFDF                            99                      CRE030
280300200528     C                   ELSE                                                                 CRE030
280400200528     C*****ACODK         CHAIN     REDEF                              99               BUG553 CRE030
280500200528     C     ACODK         CHAIN     REDEFDF                            99                      CRE030
280600200528     C                   ENDIF                                                                CRE030
280700200528      *                                                                                       BUG553
280800200528     C     *IN99         IFEQ      '0'                                                        BUG553
280900200528     C     X_RECI        ANDEQ     'D'                                                        BUG553
281000200528      *                                                                                       BUG553
281100200528     C*****X_CNUM        IFEQ      *ZEROS                                              BUG553 CSD027
281200200528     C     X_CNUM        IFEQ      *BLANKS                                                    CSD027
281300200528      *                                                                                       BUG553
281400200528     C     X_RETN        CHAIN     ACNUM                              99                      BUG553
281500200528     C     *IN99         IFEQ      '0'                                                        BUG553
281600200528     C                   MOVE      CNUM          WWCUSK                                       BUG553
281700200528     C                   MOVE      CCY           WWCCYK                                       BUG553
281800200528     C                   MOVE      ACOD          WWACOK                                       BUG553
281900200528     C                   MOVE      ACSQ          WWACSK                                       BUG553
282000200528     C                   MOVE      BRCA          WWBRCK                                       BUG553
282100200528     C     WWACKB        CHAIN     ACCNTLXX                           99                      BUG553
282200200528     C                   ENDIF                                                                BUG553
282300200528      *                                                                                       BUG553
282400200528     C                   ELSE                                                                 BUG553
282500200528     C                   MOVE      X_CNUM        WWCUSK                                       BUG553
282600200528     C                   MOVE      X_RCCY        WWCCYK                                       BUG553
282700200528     C                   MOVE      X_ACOD        WWACOK                                       BUG553
282800200528     C                   MOVE      X_SEQR        WWACSK                                       BUG553
282900200528     C                   MOVE      X_BRCA        WWBRCK                                       BUG553
283000200528     C     WWACKB        CHAIN     ACCNTLXX                           99                      BUG553
283100200528     C                   ENDIF                                                                BUG553
283200200528      *                                                                                       BUG553
283300200528     C     *IN99         IFEQ      '0'                                                        BUG553
283400200528      *                                                                                       CRE030
283500200528      ** Default Minimum Balance if CRE030 is enabled                                         CRE030
283600200528     C                   IF        CRE030 = 'Y'                                               CRE030
283700200528     C                   IF        MINB=*ZERO                                                 CRE030
283800200528     C                   EVAL      DDMINB=*BLANKS                                             CRE030
283900200528     C                   ELSE                                                                 CRE030
284000200528     C                   MOVE      *BLANKS       ZFIELD                                       CRE030
284100200528     C                   MOVE(P)   MINB          ZFIELD                                       CRE030
284200200528     C                   Z-ADD     *ZERO         ZADEC                                        CRE030
284300200528     C                   CALLB     'ZEDIT'                                                    CRE030
284400200528     C                   PARM                    ZFIELD                                       CRE030
284500200528     C                   PARM                    ZADEC                                        CRE030
284600200528     C                   MOVEL     ZFIELD        DDMINB                                       CRE030
284700200528     C                   ENDIF                                                                CRE030
284800200528     C                   ENDIF                                                                CRE030
284900200528      *                                                                                       BUG553
285000200528     C     X_RCCY        IFEQ      DDCCY                                                      BUG553
285100200528     C     DRIB          IFEQ      *ZEROS                                                     BUG553
285200200528     C                   MOVEL     *BLANKS       DDDRIB                                       BUG553
285300200528     C                   ELSE                                                                 BUG553
285400200528     C                   MOVE      DRIB          DDDRIB                                       BUG553
285500200528     C                   ENDIF                                                                BUG553
285600200528      *                                                                                       BUG553
285700200528      ** If not the same Ccy - Check Base Type is valid for other Ccy                         BUG553
285800200528     C                   ELSE                                                                 BUG553
285900200528     C     DRIB          IFNE      *ZEROS                                                     BUG553
286000200528     C                   MOVE      DRIB          WWRIB             2                          BUG553
286100200528      *                                                                                       BUG553
286200200528      ** Get Base Rate Codes                                                                  BUG553
286300200528     C                   CALL      'AOBSRTR0'                                                 BUG553
286400200528     C                   PARM      '*MSG   '     @RTCD                                        BUG553
286500200528     C                   PARM      '*KEY   '     @OPTN                                        BUG553
286600200528     C                   PARM                    DDCCY                                        BUG553
286700200528     C                   PARM                    WWRIB                                        BUG553
286800200528     C     SDBSRT        PARM      SDBSRT        DSFDY                                        BUG553
286900200528                                                                                              BUG553
287000200528     C     @RTCD         IFEQ      *BLANKS                                                    BUG553
287100200528     C                   MOVE      DRIB          DDDRIB                                       BUG553
287200200528     C                   ELSE                                                                 BUG553
287300200528     C                   MOVE      *BLANKS       DDDRIB                                       BUG553
287400200528     C                   ENDIF                                                                BUG553
287500200528     C                   ENDIF                                                                BUG553
287600200528     C                   ENDIF                                                                BUG553
287700200528      *                                                                                       BUG553
287800200528     C     DRIS          IFEQ      *ZEROS                                                     BUG553
287900200528     C                   MOVE      *BLANKS       DDDRIS                                       BUG553
288000200528     C                   ELSE                                                                 BUG553
288100200528     C     DRIS          IFLT      *ZEROS                                                     BUG553
288200200528     C                   MOVE      '-'           DDDSIG                                       BUG553
288300200528     C                   Z-SUB     DRIS          DRIS                                         BUG553
288400200528     C                   ELSE                                                                 BUG553
288500200528     C                   MOVE      ' '           DDDSIG                                       BUG553
288600200528     C                   ENDIF                                                                BUG553
288700200528     C                   MOVE      *BLANKS       ZFIELD                                       BUG553
288800200528     C                   MOVE(P)   DRIS          ZFIELD                                       BUG553
288900200528     C                   Z-ADD     7             ZADEC                                        BUG553
289000200528     C                   CALLB     'ZEDIT'                                                    BUG553
289100200528     C                   PARM                    ZFIELD           16                          BUG553
289200200528     C                   PARM                    ZADEC             1 0                        BUG553
289300200528     C                   MOVEL     ZFIELD        DDDRIS                                       BUG553
289400200528     C                   ENDIF                                                                BUG553
289500200528      *                                                                                       BUG553
289600200528     C     X_RCCY        IFEQ      DDCCY                                                      BUG553
289700200528     C     CRIB          IFEQ      *ZEROS                                                     BUG553
289800200528     C                   MOVEL     *BLANKS       DDCRIB                                       BUG553
289900200528     C                   ELSE                                                                 BUG553
290000200528     C                   MOVE      CRIB          DDCRIB                                       BUG553
290100200528     C                   ENDIF                                                                BUG553
290200200528      *                                                                                       BUG553
290300200528      ** If not the same Ccy - Check Base Type is valid for other Ccy                         BUG553
290400200528     C                   ELSE                                                                 BUG553
290500200528     C     CRIB          IFNE      *ZEROS                                                     BUG553
290600200528     C                   MOVE      CRIB          WWRIB                                        BUG553
290700200528      *                                                                                       BUG553
290800200528      ** Get Base Rate Codes                                                                  BUG553
290900200528     C                   CALLB     'AOBSRTR0'                                                 BUG553
291000200528     C                   PARM      '*MSG   '     @RTCD                                        BUG553
291100200528     C                   PARM      '*KEY   '     @OPTN                                        BUG553
291200200528     C                   PARM                    DDCCY                                        BUG553
291300200528     C                   PARM                    WWRIB                                        BUG553
291400200528     C     SDBSRT        PARM      SDBSRT        DSFDY                                        BUG553
291500200528      *                                                                                       BUG553
291600200528     C     @RTCD         IFEQ      *BLANKS                                                    BUG553
291700200528     C                   MOVE      CRIB          DDCRIB                                       BUG553
291800200528     C                   ELSE                                                                 BUG553
291900200528     C                   MOVE      *BLANKS       DDCRIB                                       BUG553
292000200528     C                   ENDIF                                                                BUG553
292100200528     C                   ENDIF                                                                BUG553
292200200528     C                   ENDIF                                                                BUG553
292300200528      *                                                                                       BUG553
292400200528     C     CRIS          IFEQ      *ZEROS                                                     BUG553
292500200528     C                   MOVE      *BLANKS       DDCRIS                                       BUG553
292600200528     C                   ELSE                                                                 BUG553
292700200528     C     CRIS          IFLT      *ZEROS                                                     BUG553
292800200528     C                   MOVE      '-'           DDCSIG                                       BUG553
292900200528     C                   Z-SUB     CRIS          CRIS                                         BUG553
293000200528     C                   ELSE                                                                 BUG553
293100200528     C                   MOVE      ' '           DDCSIG                                       BUG553
293200200528     C                   ENDIF                                                                BUG553
293300200528     C                   MOVE      *BLANKS       ZFIELD                                       BUG553
293400200528     C                   MOVE(P)   CRIS          ZFIELD                                       BUG553
293500200528     C                   Z-ADD     7             ZADEC                                        BUG553
293600200528     C                   CALLB     'ZEDIT'                                                    BUG553
293700200528     C                   PARM                    ZFIELD           16                          BUG553
293800200528     C                   PARM                    ZADEC             1 0                        BUG553
293900200528     C                   MOVEL     ZFIELD        DDCRIS                                       BUG553
294000200528     C                   ENDIF                                                                BUG553
294100200528     C                   ENDIF                                                                BUG553
294200200528      *                                                                                       BUG553
294300200528     C     DRIC          IFEQ      *ZEROS                                                     BUG553
294400200528     C                   MOVE      *BLANKS       DDDRIC                                       BUG553
294500200528     C                   ELSE                                                                 BUG553
294600200528     C                   MOVE      DRIC          DDDRIC                                       BUG553
294700200528     C                   ENDIF                                                                BUG553
294800200528      *                                                                                       BUG553
294900200528     C     NDID          IFNE      *ZEROS                                                     BUG553
295000200528     C                   CallB     'ZDATE2'                                                   BUG553
295100200528     C                   Parm      NDID          ZDAYNO            5 0                        BUG553
295200200528     C                   Parm                    BJDFIN                                       BUG553
295300200528     C                   Parm      0             ZDATE             6 0                        BUG553
295400200528     C                   Parm      *Blanks       ZADATE            7                          BUG553
295500200528     C                   Move      ZDATE         DDNDID                                       BUG553
295600200528     C                   ELSE                                                                 BUG553
295700200528     C                   MOVEL     *BLANKS       DDNDID                                       BUG553
295800200528     C                   ENDIF                                                                BUG553
295900200528      *                                                                                       BUG553
296000200528     C                   MOVE      *BLANKS       DDDRCD                                       BUG553
296100200528     C                   MOVE      *BLANKS       DDCRCD                                       BUG553
296200200528      *                                                                                       BUG553
296300200528     C                   MOVEL     DRIF          DDDRIF                                       BUG553
296400200528     C                   MOVEL     CRIF          DDCRIF                                       BUG553
296500200528      *                                                                                       BUG553
296600200528     C     DDDRIF        IFEQ      'M'                                                        BUG553
296700200528     C     DDDRIF        OREQ      'T'                                                        BUG553
296800200528     C     DDDRIF        OREQ      'Q'                                                        BUG553
296900200528     C     DDDRIF        OREQ      'X'                                                        BUG553
297000200528     C     DDDRIF        OREQ      'Y'                                                        BUG553
297100200528     C                   MOVE      DRDY          DDDNCD                                       BUG553
297200200528     C                   ELSE                                                                 BUG553
297300200528     C                   MOVE      *BLANKS       DDDNCD                                       BUG553
297400200528     C                   ENDIF                                                                BUG553
297500200528      *                                                                                       BUG553
297600200528     C     DDCRIF        IFEQ      'M'                                                        BUG553
297700200528     C     DDCRIF        OREQ      'T'                                                        BUG553
297800200528     C     DDCRIF        OREQ      'Q'                                                        BUG553
297900200528     C     DDCRIF        OREQ      'X'                                                        BUG553
298000200528     C     DDCRIF        OREQ      'Y'                                                        BUG553
298100200528     C                   MOVE      CRDY          DDCNCD                                       BUG553
298200200528     C                   ELSE                                                                 BUG553
298300200528     C                   MOVE      *BLANKS       DDCNCD                                       BUG553
298400200528     C                   ENDIF                                                                BUG553
298500200528      *                                                                                       BUG553
298600200528     C     CRIC          IFEQ      *ZEROS                                                     BUG553
298700200528     C                   MOVE      *BLANKS       DDCRIC                                       BUG553
298800200528     C                   ELSE                                                                 BUG553
298900200528     C                   MOVE      CRIC          DDCRIC                                       BUG553
299000200528     C                   ENDIF                                                                BUG553
299100200528      *                                                                                       BUG553
299200200528     C     NCID          IFNE      *ZEROS                                                     BUG553
299300200528     C                   CallB     'ZDATE2'                                                   BUG553
299400200528     C                   Parm      NCID          ZDAYNO            5 0                        BUG553
299500200528     C                   Parm                    BJDFIN                                       BUG553
299600200528     C                   Parm      0             ZDATE             6 0                        BUG553
299700200528     C                   Parm      *Blanks       ZADATE            7                          BUG553
299800200528     C                   Move      ZDATE         DDNCID                                       BUG553
299900200528     C                   ELSE                                                                 BUG553
300000200528     C                   MOVEL     *BLANKS       DDNCID                                       BUG553
300100200528     C                   ENDIF                                                                BUG553
300200200528      *                                                                                       BUG553
300300200528     C     WWACK2        CHAIN     REIACXX                            99                      BUG553
300400200528      *                                                                                       BUG553
300500200528     C     *IN99         IFEQ      '0'                                                        BUG553
300600200528      *                                                                                       BUG553
300700200528     C     X_RCCY        IFEQ      DDCCY                                                      BUG553
300800200528      *                                                                                       BUG553
300900200528     C                   MOVEL     *BLANKS       DDDICT                                       BUG553
301000200528     C     DICT          IFNE      *ZEROS                                                     BUG553
301100200528     C                   MOVE      DICT          DDDICT                                       BUG553
301200200528     C                   ENDIF                                                                BUG553
301300200528      *                                                                                       BUG553
301400200528     C                   MOVEL     *BLANKS       DDCICT                                       BUG553
301500200528     C     CICT          IFNE      *ZEROS                                                     BUG553
301600200528     C                   MOVE      CICT          DDCICT                                       BUG553
301700200528     C                   ENDIF                                                                BUG553
301800200528      *                                                                                       BUG553
301900200528     C     DCST          IFEQ      *ZEROS                                                     BUG553
302000200528     C                   MOVEL     *BLANKS       DDDCST                                       BUG553
302100200528     C                   ELSE                                                                 BUG553
302200200528     C                   MOVE      DCST          DDDCST                                       BUG553
302300200528     C                   ENDIF                                                                BUG553
302400200528      *                                                                                       BUG553
302500200528     C     CCST          IFEQ      *ZEROS                                                     BUG553
302600200528     C                   MOVEL     *BLANKS       DDCCST                                       BUG553
302700200528     C                   ELSE                                                                 BUG553
302800200528     C                   MOVE      CCST          DDCCST                                       BUG553
302900200528     C                   ENDIF                                                                BUG553
303000200528      *                                                                                       BUG553
303100200528     C                   ENDIF                                                                BUG553
303200200528      *                                                                                       BUG553
303300200528     C                   ENDIF                                                                BUG553
303400200528      *                                                                                       BUG553
303500200528     C                   ENDIF                                                                BUG553
303600200528      *                                                                                       BUG553
303700200528      ** This moves the CurAcFilFmt retail defaults to CurAcMast.                             BUG553
303800200528     C******             Z-ADD     WprocDate     E_DACO                               BUG553  240312
303900200528     C                   Z-ADD     WprocDate     E_AMDACO                                     240312
304000200528     C                   EXSR      SRCVTACC                                                   BUG553
304100200528      * Set action code in CurAcMast.                                                         BUG553
304200200528     C                   MOVE      WDACTN        @DDACTN                                      BUG553
304300200528      ** Move the defaults to the screen fields.                                              BUG553
304400200528     C                   MOVEL     CurAcMast     AccnInMast                                   BUG553
304500200528     C                   CALLB     'AOCUSTR1'                                               MD040146
304600200528     C                   PARM      '*DBERR '     @RTCD                                      MD040146
304700200528     C                   PARM      '*KEY   '     @OPTN                                      MD040146
304800200528     C                   PARM      DDCUSN        @CNUM                                      MD040146
304900200528     C                   PARM      *BLANKS       @CNST                                      MD040146
305000200528     C     SDCUST        PARM      SDCUST        DSLDY                                      MD040146
305100200528     C                   EVAL      DDANAM = BBCRNM                                          MD040146
305200200528     C                   MOVEL     CurAcDebi     AccnInDebi                                   BUG553
305300200528     C                   MOVEL     CurAcCred     AccnInCred                                   BUG553
305400200528     C                   MOVEL     CurAcComm     AccnInComm                                   BUG553
305500200528     C                   MOVEL     CurAcOthe     AccnInOthe                                   BUG553
305600200528     C                   IF        CRE015 = 'Y'                                               CRE015
305700200528     C                   MOVEL     CurAcPena     AccnInPena                                   CRE015
305800200528     C                   ENDIF                                                                CRE015
305900200528     C/COPY OFCPYSRCZ,CRE101_062                                                              CRE101
306000200528      **********                                                                    BUG4686 AR869261
306100200528     C***Access*customer*details*doDdefault*theRcorrect*client*name****             BUG4686 AR869261
306200200528     C**********         CALLB     'AOCUSTR1'                                       BUG4686 AR869261
306300200528     C**********         PARM      '*DBERR '     @RTCD                              BUG4686 AR869261
306400200528     C**********         PARM      '*KEY   '     @OPTN                              BUG4686 AR869261
306500200528     C**********         PARM      DDCUSN        @CNUM            10                BUG4686 AR869261
306600200528     C**********         PARM      *BLANKS       @CNST             7                BUG4686 AR869261
306700200528     C*****SDCUST        PARM      SDCUST        DSLDY                              BUG4686 AR869261
306800200528      **********                                                                    BUG4686 AR869261
306900200528     C**********         Eval      DDANAM = BBCRNM                                  BUG4686 AR869261
307000200528      *                                                                                       240205
307100200528      * Setup DDACCN and reset values that shouldn't be defaulted                             240205
307200200528     C                   EVAL      %SUBST(DDACCN:1:3)=DDBRCA                                  240205
307300200528     C                   EVAL      %SUBST(DDACCN:4:6)=DDCUSN                                  240205
307400200528     C                   EVAL      %SUBST(DDACCN:10:3)=DDCCY                                  240205
307500200528     C                   EVAL      %SUBST(DDACCN:13:10)=DDACOD                                240205
307600200528     C                   EVAL      %SUBST(DDACCN:23:2)=DDACSQ                                 240205
307700200528     C                   MOVE      'N'           DDINAI                                       240205
307800200528     C                   MOVE      'N'           DDBRLI                                       240205
307900200528     C                   MOVE      'N'           DDBADI                                       240205
308000200528      *                                                                                       BUG553
308100200528     C                   ENDIF                                                                BUG553
308200200528      *                                                                                       BUG553
308300200528     C                   ENDIF                                                                249660
308400200528      *                                                                                       249660
308500200528     C                   ENDIF                                                                BUG553
308600200528      *                                                                                       262070
308700200528     C                   EVAL      DD24C = *BLANKS                                            262070
308800200528      *                                                                                       BUG553
308900200528     C**********         ENDIF                                                         BUG553 237341
309000200528     C                   EndIf                                                                240312
309100200528      *                                                                                       BUG553
309200200528      ** Proceed to the GL defaults if no RE default account was used.                        BUG553
309300200528      ** - if called from initial screen                                                      240312
309400200528     C                   MOVE      AccnInMast    BLANKCHK        130                          240366
309500200528     C                   If        DefaultFlag = 'Y'                                          240312
309600200528     C**********                   and Blankchk = *BLANKS                            240366 MD041837
309700200528     C                             and AccIn130 = *BLANKS                                   MD041837
309800200528      ** Test rightmost 130 characters of screen, if blank then default.                      BUG553
309900200528     C******             MOVE      AccnInMast    BLANKCHK                              BUG553 240312
310000200528     C*****BLANKCHK      IFEQ      *BLANKS                                             BUG553 240312
310100200528      *                                                                                       BUG553
310200200528     C                   MOVE      'Y'           DDPTAD
310300200528     C                   MOVE      'N'           DDRAD
310400200528     C                   MOVE      'N'           DDRAC
310500200528     C                   MOVE      'N'           DDBAD
310600200528     C                   MOVE      'N'           DDBAC
310700200528      *
310800200528      ** Dft the Statement Freq to the value held on the GL ICD (SdGelr)
310900200528     C                   MOVE      BKDSFC        DDSTFQ
311000200528      *                                                                                       240312
311100200528      ** Blank the next statement day field if it is an invalid period                        240312
311200200528     C                   If        BKDSFC <> 'M' and                                          240312
311300200528     C                             BKDSFC <> 'T' and                                          240312
311400200528     C                             BKDSFC <> 'Q' and                                          240312
311500200528     C                             BKDSFC <> 'X' and                                          240312
311600200528     C                             BKDSFC <> 'Y'                                              240312
311700200528     C                   Eval      DDNSDN = *Blanks                                           240312
311800200528     C                   EndIf                                                                240312
311900200528      *
312000200528      ** Access customer details
312100200528     C                   CALLB     'AOCUSTR1'
312200200528     C                   PARM      '*DBERR '     @RTCD
312300200528     C                   PARM      '*KEY   '     @OPTN
312400200528     C                   PARM      DDCUSN        @CNUM            10
312500200528     C                   PARM      *BLANKS       @CNST             7
312600200528     C     SDCUST        PARM      SDCUST        DSLDY
312700200528      *
312800200528      ***Dft*Account*Name*to*Client*Name*******************************                     AR869261
312900200528     C**********         MOVE      BBCRNM        DDANAM                                     AR869261
313000200528     C**********         MOVE      BBCRNM        WWANAM           20                        AR869261
313100200528      *
313200200528      ** If Midas/Trade Innovation Interface is switched on then
313300200528      ** TI Account defaults to 'N' and other TI fields to blanks
313400200528     C     BGN3ST        IFEQ      'Y'
313500200528     C                   MOVE      'N'           DDTIAC
313600200528     C**********         MOVE      *BLANKS       DDTIAN                                       BUG553
313700200528     C**********         MOVE      *BLANKS       DDTIAS                                       BUG553
313800200528     C                   ENDIF
313900200528      *
314000200528     C**********         MOVE      *BLANKS       DDDACO                                       BUG553
314100200528     C**********         MOVE      *BLANKS       DDNSTD                                       BUG553
314200200528     C**********         MOVE      *BLANKS       DDENOC                                       BUG553
314300200528     C**********         MOVE      *BLANKS       DDNSDN                                       BUG553
314400200528     C**********         MOVE      *BLANKS       DDEUSB                                       BUG553
314500200528     C**********         MOVE      *BLANKS       DDREF                                        BUG553
314600200528     C**********         MOVE      *BLANKS       DDPRFC                                       BUG553
314700200528     C**********         MOVE      *BLANKS       DDMFFQ                                       BUG553
314800200528     C**********         MOVE      *BLANKS       DDPTFR                                       BUG553
314900200528      *
315000200528     C     CRE007        IFEQ      'N'
315100200528     C                   MOVE      BBTAIN        DDITAX
315200200528     C                   ELSE
315300200528     C                   MOVE      'N'           DDITAX
315400200528     C                   ENDIF
315500200528      *                                                                                     BUG22742
315600200528     C                   IF        CER048 = 'Y'                                             BUG22742
315700200528     C                   EVAL      DDITAX = *BLANKS                                         BUG22742
315800200528     C                   ENDIF                                                              BUG22742
315900200528      *
316000200528     C                   MOVE      R_TSTMC       DDSTCI
316100200528     C**********         MOVE      *BLANKS       DDCHIN                                       BUG553
316200200528     C**********         MOVE      *BLANKS       DDCHAM                                       BUG553
316300200528      *
316400200528     C                   EVAL      DD24C = *BLANKS                                            262070
316500200528      *                                                                                       262070
316600200528     C                   ENDIF                                                                BUG553
316700200528      *                                                                                       BUG553
316800200528     C**********         IF        DDANAM  =  *BLANKS                              AR812501 AR869261
316900200528     C**********         CALLB     'AOCUSTR1'                                      AR812501 AR869261
317000200528     C**********         PARM      '*DBERR '     @RTCD                             AR812501 AR869261
317100200528     C**********         PARM      '*KEY   '     @OPTN                             AR812501 AR869261
317200200528     C**********         PARM      DDCUSN        @CNUM                             AR812501 AR869261
317300200528     C**********         PARM      *BLANKS       @CNST                             AR812501 AR869261
317400200528     C*****SDCUST        PARM      SDCUST        DSLDY                             AR812501 AR869261
317500200528      **********                                                                   AR812501 AR869261
317600200528      ***Retrieve*Account*Name*from*Customer*Report*Name***************            AR812501 AR869261
317700200528      **********                                                                   AR812501 AR869261
317800200528     C**********         EVAL      DDANAM = BBCRNM                                 AR812501 AR869261
317900200528     C**********         ENDIF                                                     AR812501 AR869261
318000200528                                                                                              CRE015
318100200528      ** Retrieve penalty default details for period accounts                                 CRE015
318200200528                                                                                              CRE015
318300200528     C                   IF        CRE015 = 'Y'                                               CRE015
318400200528     C                             AND X5ATTY = 'P'                                           CRE015
318500200528     C                   MOVEL     AccnInPena    Blankchk                                     CRE015
318600200528     C                   IF        DefaultFlag = 'Y'                                          CRE015
318700200528     C                             AND Blankchk = *BLANKS                                     CRE015
318800200528     C                             AND DDCUSN <> *BLANKS                                      CRE015
318900200528     C                             AND DDCCY  <> *BLANKS                                      CRE015
319000200528     C                             AND DDACOD <> *BLANKS                                      CRE015
319100200528     C                   EXSR      SRRTVACC                                                   CRE015
319200200528     C                   IF        Ix = 0                                                     CRE015
319300200528     C                   EXSR      SRCVTACC                                                   CRE015
319400200528     C                   MOVEL     CurAcPena     AccnInPena                                   CRE015
319500200528     C                   ENDIF                                                                CRE015
319600200528     C                   ENDIF                                                                CRE015
319700200528     C                   ENDIF                                                                CRE015
319800200528                                                                                              CRE015
319900200528     C                   ENDSR
320000200528      *****************************************************************
320100200528      /EJECT                                                                                  BUG553
320200200528      *****************************************************************                       BUG553
320300200528      * SRRTVACC - Retrieve Account                                                           BUG553
320400200528      *****************************************************************                       BUG553
320500200528     C     SRRTVACC      BEGSR                                                                BUG553
320600200528                                                                                            AR971184
320700200528     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
320800200528     C                             DDACTN = 'I'                                             AR971184
320900200528     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
321000200528     C                   ELSE                                                               AR971184
321100200528     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
321200200528     C                   ENDIF                                                              AR971184
321300200528      *                                                                                       BUG553
321400200528      * Retrieve Account                                                                      BUG553
321500200528      *                                                                                       BUG553
321600200528     C                   CALLB     'GLAMADRTV'                                                BUG553
321700200528      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                 BUG553
321800200528      * INPUTS :                                                                              BUG553
321900200528      * Return code                                                                           BUG553
322000200528     C                   PARM      *BLANK        RetCodeOut                                   BUG553
322100200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  BUG553
322200200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              BUG553
322300200528     C                   PARM      '      '      @@MODE            6                          BUG553
322400200528      * Response mode                                                                         BUG553
322500200528     C                   PARM      'S'           @@RSMD            1                          BUG553
322600200528      * Action Code                                                                           BUG553
322700200528     C                   PARM                    DDACTN                                       BUG553
322800200528      * Front Office Transaction ID                                                           BUG553
322900200528     C*******            PARM                    FOTRID           20                   BUG553 237401
323000200528     C                   PARM                    FOTRID           40                          237401
323100200528      * (Midas) Account Reference                                                             BUG553
323200200528     C                   PARM                    DDCUSN                                       BUG553
323300200528     C                   PARM                    DDCCY                                        BUG553
323400200528     C                   PARM                    DDACOD                                       BUG553
323500200528     C                   PARM                    DDACSQ                                       BUG553
323600200528     C                   PARM                    DDBRCA                                       BUG553
323700200528     C                   PARM                    DDACNO                                       BUG553
323800200528      * Commissions                                                                           BUG553
323900200528     C                   PARM                    CommDisp                                     BUG553
324000200528      * IBAN                                                                                  BUG553
324100200528     C                   PARM                    CFT004                                       BUG553
324200200528     C                   PARM                    DDIBAN                                       238839
324300200528     C                   PARM                    CRE015                                       CRE015
324400200528     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
324500200528      *                                                                                       BUG553
324600200528      ** New Accounts Currency                                                                BUG553
324700200528      *                                                                                       BUG553
324800200528     C                   PARM                    WDCCY                                        BUG553
324900200528      * OUTPUTS :                                                                             BUG553
325000200528      * (Current) Account in file format                                                      BUG553
325100200528     C                   PARM                    CrAcFilFmt                                   BUG553
325200200528     C                   PARM                    CABXFilFmt                                   BUG553
325300200528     C                   PARM                    CARIFilFmt                                   BUG553
325400200528     C                   PARM                    CACOFilFmt                                   BUG553
325500200528     C                   PARM                    CAPWFilFmt                                   BUG553
325600200528     C                   PARM                    DDPSWD                                       CSD101
325700200528     C                   PARM                    CAPPFilFmt                                   CRE015
325800200528     C/COPY OFCPYSRCZ,CRE101_026                                                              CRE101
325900200528      * OK - Action code                                                                      BUG553
326000200528     C                   PARM      *BLANK        DDACTNOK                                     BUG553
326100200528      * OK - Account Reference                                                                BUG553
326200200528     C                   PARM                    DDCUSNOK                                     BUG553
326300200528     C                   PARM                    DDCCYOK                                      BUG553
326400200528     C                   PARM                    DDACODOK                                     BUG553
326500200528     C                   PARM                    DDACSQOK                                     BUG553
326600200528     C                   PARM                    DDBRCAOK                                     BUG553
326700200528     C                   PARM                    DDACNOOK                                     BUG553
326800200528      * Error fields/message IDs/message data (arrays) from/to caller                         BUG553
326900200528     C                   PARM                    FldNameArr                                   BUG553
327000200528     C                   PARM                    MsgIdArr                                     BUG553
327100200528     C                   PARM                    MsgDtaArr                                    BUG553
327200200528      * Array index (3P0) from/to caller                                                      BUG553
327300200528     C***********        PARM      *ZERO         Ix                                    BUG553 237646
327400200528     C                   PARM                    Ix                                           237646
327500200528      * Base Rate Auth req                                                                    BUG553
327600200528     C                   PARM                    AUTHRQ                                       BUG553
327700200528      * Authorisation Mode                                                                    BUG553
327800200528     C                   PARM                    AUTHMD                                       BUG553
327900200528      *                                                                                       BUG553
328000200528     C     EndRTVACC     ENDSR                                                                BUG553
328100200528      *****************************************************************                       BUG553
328200200528      /EJECT                                                                                  BUG553
328300200528      *****************************************************************                       BUG553
328400200528      * SRCVTACC - Put a Account on the detial screens                                        BUG553
328500200528      *****************************************************************                       BUG553
328600200528     C     SRCVTACC      BEGSR                                                                BUG553
328700200528      *                                                                                       BUG553
328800200528     C                   IF        CER050 = 'Y'                                             MD054028
328900200528     C                   MOVE      DDAPRC        V_BXAPRC                                   MD054028
329000200528     C                   ENDIF                                                              MD054028
329100200528      * Call program to fill screen fields with data from master files                        BUG553
329200200528      *                                                                                       BUG553
329300200528     C                   CALLB     'GLAMADCVT'                                                BUG553
329400200528      *                                                                                       BUG553
329500200528      * INPUTS :                                                                              BUG553
329600200528      * Return Code                                                                           BUG553
329700200528      * Account in file format                                                                BUG553
329800200528     C                   PARM      *BLANK        RetCodeOut                                   BUG553
329900200528     C                   PARM                    CrAcFilFmt                                   BUG553
330000200528     C                   PARM                    CABXFilFmt                                   BUG553
330100200528     C                   PARM                    CARIFilFmt                                   BUG553
330200200528     C                   PARM                    CACOFilFmt                                   BUG553
330300200528     C                   PARM                    CAPWFilFmt                                   BUG553
330400200528     C                   PARM                    CAPPFilFmt                                   CRE015
330500200528     C/COPY OFCPYSRCZ,CRE101_026                                                              CRE101
330600200528      *                                                                                       BUG553
330700200528      * Commissions                                                                           BUG553
330800200528     C                   PARM                    CommDisp                                     BUG553
330900200528      * CCRM Revenue Analysis                                                                 BUG553
331000200528     C                   PARM                    CDE002            1                          BUG553
331100200528      *                                                                                       BUG553
331200200528      * Retail Details                                                                        BUG553
331300200528     C                   PARM                    R_FACH                                       BUG553
331400200528     C                   PARM                    R_TSTMC                                      BUG553
331500200528      *                                                                                     MD054028
331600200528     C                   PARM                    DDAPRC                                     MD054028
331700200528     C                   PARM                    DDAPDR                                     MD054028
331800200528     C                   PARM                    DDAPCR                                     MD054028
331900200528      * OUTPUTS                                                                               BUG553
332000200528      * Account - screen formats                                                              BUG553
332100200528     C                   PARM                    NewAcPrim                                    BUG553
332200200528     C                   PARM                    NewAcDebt                                    BUG553
332300200528     C                   PARM                    NewAcCrdt                                    BUG553
332400200528     C                   PARM                    NewAcComm                                    BUG553
332500200528     C                   PARM                    NewAcOthr                                    BUG553
332600200528     C                   PARM                    NewAcPena                                    CRE015
332700200528     C/COPY OFCPYSRCZ,CRE101_028                                                              CRE101
332800200528      *                                                                                       BUG553
332900200528      * Screen 1 Output                                                                       BUG553
333000200528     C                   PARM                    DDDACC            6                          BUG553
333100200528     C                   PARM                    DDLINK           24                          BUG553
333200200528     C                   PARM                    DDFAMT            8                          BUG553
333300200528      *                                                                                       BUG553
333400200528      * Screen 2 Output                                                                       BUG553
333500200528     C                   PARM                    DODRCD            6                          BUG553
333600200528     C                   PARM                    DOPOLC            6                          BUG553
333700200528     C                   PARM                    DOPOLE            6                          BUG553
333800200528      *                                                                                       BUG553
333900200528      * Screen 3 Output                                                                       BUG553
334000200528     C                   PARM                    DOCRCD            6                          BUG553
334100200528      *                                                                                       BUG553
334200200528      * Screen 4 Output                                                                       BUG553
334300200528     C                   PARM                    DDCEXA1          11                          BUG553
334400200528     C                   PARM                    DDCEXB1          11                          BUG553
334500200528     C                   PARM                    DDCEXC1          11                          BUG553
334600200528     C                   PARM                    DDCEXD1           8                          BUG553
334700200528     C                   PARM                    DDCEXE1           8                          BUG553
334800200528     C                   PARM                    DDCEXF1           8                          BUG553
334900200528     C                   PARM                    DDCEXG1           8                          BUG553
335000200528     C                   PARM                    DDDRMG1          12                          BUG553
335100200528     C                   PARM                    DDCRMG1          12                          BUG553
335200200528      *                                                                                     MD054028
335300200528     C                   MOVE      DDAPCR        @DDAPCR                                    MD054028
335400200528     C                   MOVE      DDAPDR        @DDAPDR                                    MD054028
335500200528      *                                                                                       BUG553
335600200528      * Update 'Current' Account with Account in Screen Format                                BUG553
335700200528      *                                                                                       BUG553
335800200528     C                   MOVEL     NewAcPrim     CurAcMast                                    BUG553
335900200528     C                   MOVEL     NewAcDebt     CurAcDebi                                    BUG553
336000200528     C                   MOVEL     NewAcCrdt     CurAcCred                                    BUG553
336100200528     C                   MOVEL     NewAcComm     CurAcComm                                    BUG553
336200200528     C                   MOVEL     NewAcOthr     CurAcOthe                                    BUG553
336300200528     C                   IF        CRE015 = 'Y'                                               CRE015
336400200528     C                   MOVEL     NewAcPena     CurAcPena                                    CRE015
336500200528     C                   ENDIF                                                                CRE015
336600200528     C/COPY OFCPYSRCZ,CRE101_047                                                              CRE101
336700200528      *                                                                                       BUG553
336800200528     C                   ENDSR                                                                BUG553
336900200528      *****************************************************************                       BUG553
337000200528      /EJECT
337100200528      *****************************************************************                       CSF011
337200200528      *                                                               *                       CSF011
337300200528      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
337400200528      *                                                               *                       CSF011
337500200528      *****************************************************************                       CSF011
337600200528      *                                                                                       CSF011
337700200528     C     SrPopCust     BEGSR                                                                CSF011
337800200528                                                                                              CSF011
337900200528      ** Retrieve Customer Details                                                            CSF011
338000200528                                                                                              CSF011
338100200528     C                   IF        DDCUSN <> *BLANKS                                          CSF011
338200200528                                                                                              CSF011
338300200528     C                   EXSR      SrRtvCust                                                  CSF011
338400200528     C                   IF        @RTCD = *BLANKS                                            CSF011
338500200528     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
338600200528     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
338700200528     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
338800200528     C                   ENDIF                                                                CSF011
338900200528                                                                                              CSF011
339000200528     C                   ENDIF                                                                CSF011
339100200528                                                                                              CSF011
339200200528     C                   ENDSR                                                                CSF011
339300200528      *****************************************************************                       CSF011
339400200528      /EJECT                                                                                  CSF011
339500200528      *****************************************************************                       CSF011
339600200528      *                                                               *                       CSF011
339700200528      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
339800200528      *                                                               *                       CSF011
339900200528      *****************************************************************                       CSF011
340000200528     C     SrRtvCust     BEGSR                                                                CSF011
340100200528                                                                                              CSF011
340200200528      ** Call AOCUSTR0 to get Customer Details                                                CSF011
340300200528                                                                                              CSF011
340400200528     C                   CALLB     'AOCUSTR0'                                                 CSF011
340500200528     C                   PARM      *BLANKS       @RTCD                                        CSF011
340600200528     C                   PARM      '*KEY   '     @OPTN                                        CSF011
340700200528     C                   PARM      DDCUSN        @KEY10                                       CSF011
340800200528     C                   PARM      *BLANKS       @KEY7                                        CSF011
340900200528     C     SDCUST        PARM      SDCUST        DSLDY                                        CSF011
341000200528                                                                                              CSF011
341100200528     C                   ENDSR                                                                CSF011
341200200528      *****************************************************************                       CSF011
341300200528      /EJECT                                                                                  CSF011
341400200528      ****************************************************************                      MD054028
341500200528      *  Get Record Lengths of Transaction Data Blocks               *                      MD054028
341600200528      ****************************************************************                      MD054028
341700200528     C     GETRCDLN      BEGSR                                                              MD054028
341800200528                                                                                            MD054028
341900200528     C                   CALLB     'UTGETRCDLN'                                             MD054028
342000200528     C                   PARM                    ReturnCode       10                        MD054028
342100200528     C                   PARM      *ZERO         RecordLen         5 0                      MD054028
342200200528     C                   PARM                    FileName         10                        MD054028
342300200528     C                   PARM      '*LIBL     '  FileLib          10                        MD054028
342400200528                                                                                            MD054028
342500200528      ** If file not found (or any other error) shut down the program                       MD054028
342600200528     C     ReturnCode    Ifne      *Blanks                                                  MD054028
342700200528     C                   EXSR      *pssr                                                    MD054028
342800200528     C                   EndIf                                                              MD054028
342900200528                                                                                            MD054028
343000200528     C                   ENDSR                                                              MD054028
343100200528      *****************************************************************                     MD054028
343200200528      /EJECT                                                                                MD054028
343300200528      *****************************************************************
343400200528      *                                                               *
343500200528      * *INZSR - Program Initialisation routine                       *
343600200528      *                                                               *
343700200528      *****************************************************************
343800200528     C     *INZSR        BEGSR
343900200528
344000200528     C     *ENTRY        PLIST
344100200528      * Common header information (DS) from source system
344200200528     C                   PARM                    HeadIn
344300200528      * Transaction information
344400200528     C                   PARM                    Accnt5001
344500200528     C                   PARM                    Accnt5002
344600200528     C                   PARM                    Accnt5003
344700200528     C                   PARM                    Accnt5004
344800200528     C                   PARM                    Accnt5005
344900200528     C                   PARM                    Accnt5006                                    CRE015
345000200528     C                   PARM                    StmpTax500                                   CER049
345100200528     C/COPY OFCPYSRCZ,CRE101_048                                                              CRE101
345200200528     C                   PARM                    InfData500                                 BUG10280
345300200528     C                   PARM                    RegData500                                   CER001
345400200528     C**********         PARM                    InfData500                                 BUG10280
345500200528     C                   PARM                    ExtData500
345600200528     C                   PARM                    RepeatData                                   CRE015
345700200528     C                   PARM                    FldNameArr
345800200528     C                   PARM                    MsgIDArr
345900200528     C                   PARM                    MsgDtaArr
346000200528     C                   PARM                    WFldNamArr
346100200528     C                   PARM                    WMsgIDArr
346200200528     C                   PARM                    WMsgDtaArr
346300200528     C                   PARM                    MsgFArray
346400200528     C                   PARM                    UpdateYN          1
346500200528     C**********         PARM                    Buffer         6000                        MD044880
346600200528     C**********         PARM                    Buffer2        3999                 CRE073 MD044880
346700200528     C                   PARM                    Buffer         9999                        MD044880
346800200528     C                   PARM                    APIRetc           1
346900200528     C                   PARM                    @TimeStamp       26                         BUG4196
347000200528     C                   PARM                    GLFullAcct       24                        MD026979
347100200528                                                                                            MD026979
347200200528     C/COPY WNCPYSRC,GLAMADVC02
347300200528
347400200528      *                                                                                      LLN022A
347500200528      ** Access SAR details file to determine if LLN007                                      LLN022A
347600200528      ** Bank of England Yellow Book Changes is on.                                          LLN022A
347700200528      *                                                                                      LLN022A
347800200528     C                   MOVE      'N'           LLN007            1                         LLN022A
347900200528     C                   CALLB     'AOSARDR0'                                                LLN022A
348000200528     C                   PARM      *BLANKS       @RTCD                                       LLN022A
348100200528     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
348200200528     C                   PARM      'LLN007'      @SARD                                       LLN022A
348300200528     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
348400200528      *                                                                                      LLN022A
348500200528      ** Switchable Feature LLN007 is *ON                                                    LLN022A
348600200528      *                                                                                      LLN022A
348700200528     C                   IF        @RTCD = *Blanks                                           LLN022A
348800200528     C                   EVAL      LLN007 = 'Y'                                              LLN022A
348900200528     C                   OPEN      BYACCTY0                                                 MD051247
349000200528     C                   ENDIF                                                               LLN022A
349100200528      *                                                                                      LLN022A
349200200528      * Set up the names of the message files from which the message handler
349300200528      * will get the messages
349400200528     C                   EVAL      MsgFArray(1) = 'REUSRMSG'
349500200528     C                   EVAL      MsgFArray(2) = 'DRSMM'
349600200528     C                   EVAL      MsgFArray(3) = 'SDUSRMSG'                                  CRE073
349700200528     C/COPY WNCPYSRC,GLH00651
349800200528
349900200528      * Hook to enable non-core message files to be included
350000200528     D/COPY WNCPYSRC,GLAMADM01
350100200528      *                                                                                      LLN022A
350200200528     C                   IF        LLN007 = 'Y'                                              LLN022A
350300200528     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
350400200528     C                             'GBBYUSRMSG'                                              LLN022A
350500200528     C                   ENDIF                                                               LLN022A
350600200528                                                                                              BG2557
350700200528      * Override SDAULGL0                                                                     BG2557
350800200528     C                   Z-ADD     50            CMDLEN           15 5                        BG2557
350900200528     C                   CALL      'QCMDEXC'                                                  BG2557
351000200528     C                   PARM                    CMD                                          BG2557
351100200528     C                   PARM                    CMDLEN                                       BG2557
351200200528      *
351300200528      ** Access Bank details via access program
351400200528      *  (database error handling done in access program)
351500200528     C                   CALLB     'AOBANKR0'
351600200528     C                   PARM      '*DBERR '     @RTCD             7
351700200528     C                   PARM      '*FIRST '     @OPTN             7
351800200528     C     SDBANK        PARM      SDBANK        DSFDY
351900200528      *
352000200528      ** Access MIDAS Modules details via access program
352100200528      *  (database error handling done in access program)
352200200528     C                   CALLB     'AOMMODR0'
352300200528     C                   PARM      '*DBERR '     @RTCD
352400200528     C                   PARM      '*FIRST '     @OPTN
352500200528     C     SDMMOD        PARM      SDMMOD        DSFDY
352600200528      *
352700200528      ** Access SAR details file to determine if CRE001 Overdraft
352800200528      ** interest calculations is switched on
352900200528      *
353000200528     C                   CALLB     'AOSARDR0'
353100200528     C                   PARM      *BLANKS       @RTCD
353200200528     C                   PARM      '*VERIFY'     @OPTN
353300200528     C                   PARM      'CRE001'      @SARD             6
353400200528     C     SCSARD        PARM      SCSARD        DSFDY
353500200528     C     @RTCD         IFEQ      *BLANK
353600200528     C                   MOVEL     'Y'           CRE001            1
353700200528     C                   ELSE
353800200528     C                   MOVEL     'N'           CRE001
353900200528     C                   END
354000200528      *
354100200528      ** Access SAR file to determine if S01383 is present.
354200200528     C                   CALLB     'AOSARDR0'
354300200528     C                   PARM      *BLANKS       @RTCD
354400200528     C                   PARM      '*VERIFY'     @OPTN
354500200528     C                   PARM      'S01383'      @SARD
354600200528     C     SCSARD        PARM      SCSARD        DSFDY
354700200528     C     @RTCD         IFNE      *BLANKS
354800200528     C     @RTCD         ANDNE     '*NRF   '
354900200528     C     *LOCK         IN        LDA
355000200528     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
355100200528     C                   Z-ADD     6             DBASE                          * DBERR 006 *
355200200528     C                   MOVEL     'S01383'      DBKEY                          *************
355300200528     C                   OUT       LDA
355400200528     C                   SETON                                        U7U8LR
355500200528     C                   EXSR      *PSSR
355600200528     C                   ENDIF
355700200528     C                   MOVEL     'N'           S01383            1
355800200528     C     @RTCD         IFEQ      *BLANK
355900200528     C                   MOVEL     'Y'           S01383
356000200528     C                   ENDIF
356100200528      *                                                                                       BG2557
356200200528      ** Access SAR details file to determine if CSD012 is on.                                BG2557
356300200528      *                                                                                       BG2557
356400200528     C                   CALLB     'AOSARDR0'                                                 BG2557
356500200528     C                   PARM      *BLANKS       @RTCD                                        BG2557
356600200528     C                   PARM      '*VERIFY'     @OPTN                                        BG2557
356700200528     C                   PARM      'CSD012'      @SARD                                        BG2557
356800200528     C     SCSARD        PARM      SCSARD        DSFDY                                        BG2557
356900200528      *                                                                                       BG2557
357000200528     C     @RTCD         IFEQ      *BLANK                                                     BG2557
357100200528     C                   MOVE      'Y'           CSD012                                       BG2557
357200200528     C                   ELSE                                                                 BG2557
357300200528     C                   MOVE      'N'           CSD012                                       BG2557
357400200528     C                   ENDIF                                                                BG2557
357500200528                                                                                              BG2557
357600200528      ** If CSD012 is ON, Check if Account Authorisation is ON                                BG2557
357700200528 B1  C     CSD012        IFEQ      'Y'                                                        BG2557
357800200528      *                                                                                       BG2557
357900200528     C                   CALL      'AOSVALR0'                                                 BG2557
358000200528     C                   PARM                    @RTCD                                        BG2557
358100200528     C                   PARM      SVALKK        SVALK1           20                          BG2557
358200200528     C                   PARM                    SVAL1           200                          BG2557
358300200528     C                   PARM                    SVALK2           20                          BG2557
358400200528     C                   PARM                    SVAL2           200                          BG2557
358500200528     C                   PARM                    SVALK3           20                          BG2557
358600200528     C                   PARM                    SVAL3           200                          BG2557
358700200528     C                   PARM                    SVALK4           20                          BG2557
358800200528     C                   PARM                    SVAL4           200                          BG2557
358900200528     C                   PARM                    SVALK5           20                          BG2557
359000200528     C                   PARM                    SVAL5           200                          BG2557
359100200528     C                   PARM                    SVALK6           20                          BG2557
359200200528     C                   PARM                    SVAL6           200                          BG2557
359300200528     C                   PARM                    SVALK7           20                          BG2557
359400200528     C                   PARM                    SVAL7           200                          BG2557
359500200528     C                   PARM                    SVALK8           20                          BG2557
359600200528     C                   PARM                    SVAL8           200                          BG2557
359700200528     C                   PARM                    SVALK9           20                          BG2557
359800200528     C                   PARM                    SVAL9           200                          BG2557
359900200528     C                   PARM                    SVALK0           20                          BG2557
360000200528     C                   PARM                    SVAL10          200                          BG2557
360100200528      *                                                                                       BG2557
360200200528     C     @RTCD         IFNE      *BLANKS                                                    BG2557
360300200528                                                                                              BG2557
360400200528     C     SVAL10        IFEQ      '*NRF'                                                     BG2557
360500200528     C                   MOVE      SVALK0        DBKEY                                        BG2557
360600200528     C                   ENDIF                                                                BG2557
360700200528     C     SVAL9         IFEQ      '*NRF'                                                     BG2557
360800200528     C                   MOVE      SVALK9        DBKEY                                        BG2557
360900200528     C                   ENDIF                                                                BG2557
361000200528     C     SVAL8         IFEQ      '*NRF'                                                     BG2557
361100200528     C                   MOVE      SVALK8        DBKEY                                        BG2557
361200200528     C                   ENDIF                                                                BG2557
361300200528     C     SVAL7         IFEQ      '*NRF'                                                     BG2557
361400200528     C                   MOVE      SVALK7        DBKEY                                        BG2557
361500200528     C                   ENDIF                                                                BG2557
361600200528     C     SVAL6         IFEQ      '*NRF'                                                     BG2557
361700200528     C                   MOVE      SVALK6        DBKEY                                        BG2557
361800200528     C                   ENDIF                                                                BG2557
361900200528     C     SVAL5         IFEQ      '*NRF'                                                     BG2557
362000200528     C                   MOVE      SVALK5        DBKEY                                        BG2557
362100200528     C                   ENDIF                                                                BG2557
362200200528     C     SVAL4         IFEQ      '*NRF'                                                     BG2557
362300200528     C                   MOVE      SVALK4        DBKEY                                        BG2557
362400200528     C                   ENDIF                                                                BG2557
362500200528     C     SVAL3         IFEQ      '*NRF'                                                     BG2557
362600200528     C                   MOVE      SVALK3        DBKEY                                        BG2557
362700200528     C                   ENDIF                                                                BG2557
362800200528     C     SVAL2         IFEQ      '*NRF'                                                     BG2557
362900200528     C                   MOVE      SVALK2        DBKEY                                        BG2557
363000200528     C                   ENDIF                                                                BG2557
363100200528     C     SVAL1         IFEQ      '*NRF'                                                     BG2557
363200200528     C                   MOVE      SVALK1        DBKEY                                        BG2557
363300200528     C                   ENDIF                                                                BG2557
363400200528                                                                                              BG2557
363500200528     C     *LOCK         IN        LDA                                                        BG2557
363600200528     C                   Z-ADD     13            DBASE                                        BG2557
363700200528     C                   MOVE      'SDSVALPD'    DBFILE                                       BG2557
363800200528     C                   MOVE      'GLAMADSIN'   DBPGM                                        BG2557
363900200528     C                   OUT       LDA                                                        BG2557
364000200528     C                   EXSR      *PSSR                                                      BG2557
364100200528     C                   ENDIF                                                                BG2557
364200200528      *                                                                                       BG2557
364300200528      ** If Account Authorisation is On set to Authorise                                      BG2557
364400200528     C     SVAL11        IFEQ      'Y'                                                        BG2557
364500200528     C                   MOVE      'Y'           AUTHRQ            1                          BG2557
364600200528     C                   ELSE                                                                 BG2557
364700200528     C                   MOVE      'N'           AUTHRQ                                       BG2557
364800200528     C                   ENDIF                                                                BG2557
364900200528      *                                                                                       BG2557
365000200528 E1  C                   ENDIF                                                                BG2557
365100200528      *
365200200528      ** Portfolio Management
365300200528      ** or Private Banking Module
365400200528     C                   MOVE      *OFF          *IN28
365500200528     C     BGPFMG        IFEQ      'Y'
365600200528     C     BGN4ST        OREQ      'Y'
365700200528     C                   OPEN      PMPORTLL
365800200528     C                   MOVE      *ON           *IN28
365900200528     C                   ENDIF
366000200528
366100200528      *
366200200528      ** Access SAR details file to determine if CRT001 Retail
366300200528      ** Teller System is switched on
366400200528      *
366500200528     C                   CALLB     'AOSARDR0'
366600200528     C                   PARM      *BLANKS       @RTCD
366700200528     C                   PARM      '*VERIFY'     @OPTN
366800200528     C                   PARM      'CRT001'      @SARD
366900200528     C     SCSARD        PARM      SCSARD        DSFDY
367000200528     C     @RTCD         IFEQ      *BLANK
367100200528     C                   MOVEL     'Y'           CRT001            1
367200200528     C                   ELSE
367300200528     C                   MOVEL     'N'           CRT001
367400200528     C                   END
367500200528
367600200528      *
367700200528      ** Access SAR details file to determine if CRT101 Password on
367800200528      ** Retail Teller account facilities is switched on
367900200528      *
368000200528     C                   CALLB     'AOSARDR0'
368100200528     C                   PARM      *BLANKS       @RTCD
368200200528     C                   PARM      '*VERIFY'     @OPTN
368300200528     C                   PARM      'CRT101'      @SARD
368400200528     C     SCSARD        PARM      SCSARD        DSFDY
368500200528     C     @RTCD         IFEQ      *BLANK
368600200528     C                   MOVEL     'Y'           CRT101            1
368700200528     C                   ELSE
368800200528     C                   MOVEL     'N'           CRT101
368900200528     C                   END
369000200528      *
369100200528      ** Access SAR details file to determine if CFT004 is on.
369200200528      *
369300200528     C                   CALLB     'AOSARDR0'
369400200528     C                   PARM      *BLANKS       @RTCD
369500200528     C                   PARM      '*VERIFY'     @OPTN
369600200528     C                   PARM      'CFT004'      @SARD
369700200528     C     SCSARD        PARM      SCSARD        DSFDY
369800200528      *
369900200528     C     @RTCD         IFEQ      *BLANK
370000200528     C                   MOVEL     'Y'           CFT004            1
370100200528     C                   ELSE
370200200528     C                   MOVEL     'N'           CFT004
370300200528     C                   END
370400200528      *
370500200528      ** Access SAR details file to determine if CDE002 is on.
370600200528      *
370700200528     C                   CALLB     'AOSARDR0'
370800200528     C                   PARM      *BLANKS       @RTCD
370900200528     C                   PARM      '*VERIFY'     @OPTN
371000200528     C                   PARM      'CDE002'      @SARD
371100200528     C     SCSARD        PARM      SCSARD        DSFDY
371200200528      *
371300200528     C     @RTCD         IFEQ      *BLANK
371400200528     C                   MOVEL     'Y'           CDE002            1
371500200528     C                   ELSE
371600200528     C                   MOVEL     'N'           CDE002
371700200528     C                   END
371800200528      *
371900200528      ** Access SAR details file to determine if CEU013
372000200528      ** (EMU Account Postings Narrative) is on.
372100200528      *
372200200528     C                   CALLB     'AOSARDR0'
372300200528     C                   PARM      *BLANKS       @RTCD             7
372400200528     C                   PARM      '*VERIFY'     @OPTN             7
372500200528     C                   PARM      'CEU013'      @SARD             6
372600200528     C     SCSARD        PARM      SCSARD        DSFDY
372700200528      *
372800200528     C     @RTCD         IFEQ      *BLANK
372900200528     C                   MOVEL     'Y'           CEU013            1
373000200528     C                   ELSE
373100200528     C                   MOVEL     'N'           CEU013
373200200528     C                   END
373300200528      *
373400200528      ** Access SAR details file to determine if CRT002
373500200528      ** (Retail Branch Access) is on.
373600200528      *
373700200528     C                   CALLB     'AOSARDR0'
373800200528     C                   PARM      *BLANKS       @RTCD
373900200528     C                   PARM      '*VERIFY'     @OPTN
374000200528     C                   PARM      'CRT002'      @SARD
374100200528     C     SCSARD        PARM      SCSARD        DSFDY
374200200528      *
374300200528     C     @RTCD         IFEQ      *BLANK
374400200528     C                   MOVEL     'Y'           CRT002            1
374500200528     C                   ELSE
374600200528     C                   MOVEL     'N'           CRT002
374700200528     C                   END
374800200528      *
374900200528      * Access SAR details file to determine if CSC011 switchable feature
375000200528      * is switched on
375100200528      ** CSC011 is a redundant feature. No need to check                                    MD024398
375200200528
375300200528     C**********         CALLB     'AOSARDR0'                                               MD024398
375400200528     C**********         PARM      *BLANKS       @RTCD                                      MD024398
375500200528     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
375600200528     C**********         PARM      'CSC011'      @SARD                                      MD024398
375700200528     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
375800200528      **********                                                                            MD024398
375900200528     C**********         IF        @RTCD = *Blanks                                          MD024398
376000200528      **********                                                                            MD024398
376100200528     C**********         EVAL      CSC011 = 'Y'                                             MD024398
376200200528      **********                                                                            MD024398
376300200528     C**********         IN        SC24X7                                                   MD024398
376400200528     C**********         IN        SDSTAT                                                   MD024398
376500200528      **********                                                                     240312 MD024398
376600200528     C**********         Else                                                        240312 MD024398
376700200528      ***Database*error************************************************              240312 MD024398
376800200528      **********                                                                     240312 MD024398
376900200528     C**********         If        @RTCD <> '*NRF'                                   240312 MD024398
377000200528     C******LOCK         In        LDA                                               240312 MD024398
377100200528     C**********         Eval      DBKEY = 'CSC011'                                  240312 MD024398
377200200528     C**********         Eval      DBFILE = 'SCSARDPD'                               240312 MD024398
377300200528     C**********         Eval      DBASE = 900                                       240312 MD024398
377400200528     C**********         Out       LDA                                               240312 MD024398
377500200528     C**********         ExSr      *PSSR                                             240312 MD024398
377600200528     C**********         EndIf                                                       240312 MD024398
377700200528      **********                                                                     240312 MD024398
377800200528     C**********         EndIf                                                       240312 MD024398
377900200528      *                                                                                       CER055
378000200528      * Access SAR details file to determine if CER055 switchable feature                     CER055
378100200528      * is switched on                                                                        CER055
378200200528                                                                                              CER055
378300200528     C                   CALLB     'AOSARDR0'                                                 CER055
378400200528     C                   PARM      *BLANKS       @RTCD                                        CER055
378500200528     C                   PARM      '*VERIFY'     @OPTN                                        CER055
378600200528     C                   PARM      'CER055'      @SARD                                        CER055
378700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
378800200528                                                                                              CER055
378900200528     C                   IF        @RTCD = *Blanks                                            CER055
379000200528     C                   EVAL      CER055 = 'Y'                                               CER055
379100200528     C                   ELSE                                                                 CER055
379200200528     C                   EVAL      CER055 = 'N'                                               CER055
379300200528      ** Database error                                                                       CER055
379400200528     C                   IF        @RTCD <> '*NRF'                                            CER055
379500200528     C     *LOCK         IN        LDA                                                        CER055
379600200528     C                   EVAL      DBKEY = 'CER055'                                           CER055
379700200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
379800200528     C                   EVAL      DBASE = 904                                                CER055
379900200528     C                   OUT       LDA                                                        CER055
380000200528     C                   EXSR      *PSSR                                                      CER055
380100200528     C                   EndIf                                                                CER055
380200200528                                                                                              CER055
380300200528     C                   EndIf                                                                CER055
380400200528
380500200528      ** If 24X7 Midas availability is installed and support system is
380600200528      ** active, used processing date from dataarea SC24X7 as the
380700200528      ** rundate.
380800200528
380900200528     C                   IF        CSC011 = 'Y' AND
381000200528     C                             S1SUPP = LIBR
381100200528     C                   EVAL      WProcDate = S1DATE
381200200528     C                   ELSE
381300200528     C                   EVAL      WProcDate = BJRDNB
381400200528     C                   ENDIF
381500200528
381600200528     C******             ELSE                                                                 240312
381700200528      ***Database error                                                                       240312
381800200528      ******                                                                                  240312
381900200528     C******             IF        @RTCD <> '*NRF'                                            240312
382000200528     C******LOCK         IN        LDA                                                        240312
382100200528     C******             EVAL      DBKEY = 'CSC011'                                           240312
382200200528     C******             EVAL      DBFILE = 'SCSARDPD'                                        240312
382300200528     C******             EVAL      DBASE = 900                                                240312
382400200528     C******             OUT       LDA                                                        240312
382500200528     C******             EXSR      *PSSR                                                      240312
382600200528     C******             ENDIF                                                                240312
382700200528      ******                                                                                  240312
382800200528     C******             ENDIF                                                                240312
382900200528      *                                                                                       CSC022
383000200528      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
383100200528      ** is switched on                                                                       CSC022
383200200528      *                                                                                       CSC022
383300200528      ** CSC022 is a mandatory feature already, so its always on                            MD024398
383400200528                                                                                            MD024398
383500200528     C**********         CALLB     'AOSARDR0'                                        CSC022 MD024398
383600200528     C**********         PARM      *BLANKS       @RTCD                               CSC022 MD024398
383700200528     C**********         PARM      '*VERIFY'     @OPTN                               CSC022 MD024398
383800200528     C**********         PARM      'CSC022'      @SARD                               CSC022 MD024398
383900200528     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC022 MD024398
384000200528      **********                                                                     CSC022 MD024398
384100200528     C**********         IF        @RTCD = *Blanks                                   CSC022 MD024398
384200200528      **********                                                                     CSC022 MD024398
384300200528     C                   EVAL      CSC022 = 'Y'                                               CSC022
384400200528     C                   EVAL      WCMTSK = 'N'                                               CSC022
384500200528                                                                                              CSC022
384600200528     C                   IN        SCCMTJOB                                                   CSC022
384700200528                                                                                              CSC022
384800200528     C                   IF        COMITNUM > 0                                               CSC022
384900200528                                                                                              CSC022
385000200528     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
385100200528                                                                                              CSC022
385200200528     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
385300200528     C                   EVAL      WCMTSK = 'Y'                                               CSC022
385400200528     C                   ENDIF                                                                CSC022
385500200528                                                                                              CSC022
385600200528     C                   ENDIF                                                                CSC022
385700200528                                                                                              CSC022
385800200528     C**********         ELSE                                                        CSC022 MD024398
385900200528     C**********         IF        @RTCD <> '*NRF'                                   CSC022 MD024398
386000200528     C******LOCK         IN        LDA                                               CSC022 MD024398
386100200528     C**********         EVAL      DBKEY = 'CSC022'                                  CSC022 MD024398
386200200528     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC022 MD024398
386300200528     C**********         EVAL      DBASE = 901                                       CSC022 MD024398
386400200528     C**********         OUT       LDA                                               CSC022 MD024398
386500200528     C**********         EXSR      *PSSR                                             CSC022 MD024398
386600200528     C**********         ENDIF                                                       CSC022 MD024398
386700200528      **********                                                                     CSC022 MD024398
386800200528     C**********         ENDIF                                                       CSC022 MD024398
386900200528      *
387000200528      ** Access SAR details file to determine if CRE007 is on.
387100200528      *
387200200528     C                   CALLB     'AOSARDR0'
387300200528     C                   PARM      *BLANKS       @RTCD
387400200528     C                   PARM      '*VERIFY'     @OPTN
387500200528     C                   PARM      'CRE007'      @SARD
387600200528     C     SCSARD        PARM      SCSARD        DSFDY
387700200528      *
387800200528      * Database Error
387900200528      *
388000200528     C     @RTCD         IFNE      *BLANKS
388100200528     C     @RTCD         ANDNE     '*NRF   '
388200200528     C                   MOVEL     'SCSARDPD'    DBFILE
388300200528     C                   Z-ADD     7             DBASE
388400200528     C                   MOVEL     'CRE007'      DBKEY
388500200528     C                   EXSR      *PSSR
388600200528     C                   END
388700200528      *
388800200528     C     @RTCD         IFEQ      *BLANK
388900200528     C                   MOVE      'Y'           CRE007            1
389000200528     C                   ELSE
389100200528     C                   MOVE      'N'           CRE007
389200200528     C                   END
389300200528      *                                                                                       CER001
389400200528      ** Access SAR details file to determine if ULX606 is on.                                CER001
389500200528      *                                                                                       CER001
389600200528     C                   CALLB     'AOSARDR0'                                                 CER001
389700200528     C                   PARM      *BLANKS       @RTCD                                        CER001
389800200528     C                   PARM      '*VERIFY'     @OPTN                                        CER001
389900200528     C                   PARM      'ULX606'      @SARD                                        CER001
390000200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
390100200528      *                                                                                       CER001
390200200528      ** Database Error                                                                       CER001
390300200528      *                                                                                       CER001
390400200528     C     @RTCD         IFNE      *BLANKS                                                    CER001
390500200528     C     @RTCD         ANDNE     '*NRF   '                                                  CER001
390600200528     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
390700200528     C                   Z-ADD     902           DBASE                                        CER001
390800200528     C                   MOVEL     'ULX606'      DBKEY                                        CER001
390900200528     C                   EXSR      *PSSR                                                      CER001
391000200528     C                   ENDIF                                                                CER001
391100200528      *                                                                                       CER001
391200200528     C     @RTCD         IFEQ      *BLANK                                                     CER001
391300200528     C                   MOVE      'Y'           ULX606                                       CER001
391400200528     C                   ELSE                                                                 CER001
391500200528     C                   MOVE      'N'           ULX606                                       CER001
391600200528     C                   ENDIF                                                                CER001
391700200528      *
391800200528      ** ACCESS GENERAL LEDGER DETAILS
391900200528      *
392000200528     C                   CALLB     'AOGELRR1'
392100200528     C                   PARM      *BLANKS       @RTCD
392200200528     C                   PARM      '*FIRST '     @OPTN
392300200528     C     SDGELR        PARM      SDGELR        DSSDY
392400200528      *
392500200528      * DATABASE ERROR
392600200528      *
392700200528     C     @RTCD         IFNE      *BLANKS
392800200528     C                   MOVEL     'SDGELRPD'    DBFILE
392900200528     C                   Z-ADD     2             DBASE
393000200528     C                   MOVEL     @OPTN         DBKEY
393100200528     C                   EXSR      *PSSR
393200200528     C                   END
393300200528      *
393400200528      ** Access Retail ICD for Commissions
393500200528      *
393600200528     C                   IF        BGNXST='Y' or BGNYST='Y'
393700200528     C     1             SETLL     TABTBRE
393800200528     C                   READ      TABTBRE                                80
393900200528     C     *IN80         IFEQ      *ON
394000200528     C     R_RECI        ORNE      'D'
394100200528     C                   MOVEL     'TABTBRE '    DBFILE                         ************
394200200528     C                   MOVEL     '101'         DBASE                          * DBERR 101*
394300200528     C                   EXSR      *PSSR                                        ************
394400200528     C                   ELSE
394500200528     C                   IF        R_CDTO='Y' or R_CHOV='Y' or R_FXAC='Y'
394600200528     C                             or R_CNDS='Y' or R_CDRI='Y'
394700200528     C                             or R_CMBL='Y' or R_CINA='Y'
394800200528     C                   EVAL      CommDisp='Y'
394900200528     C                   ELSE
395000200528     C                   EVAL      CommDisp='N'
395100200528     C                   ENDIF
395200200528     C                   ENDIF
395300200528     C                   ELSE
395400200528     C                   EVAL      CommDisp='N'
395500200528     C                   ENDIF
395600200528
395700200528      ** Access API ICD via access program
395800200528     C                   CALLB     'AOAPIR0'
395900200528     C                   PARM      '*DBERR '     @RTCD
396000200528     C                   PARM      '*FIRST '     @OPTN
396100200528     C     SDAPI         PARM      SDAPI         DSFDY
396200200528      *
396300200528      ** Access Dealing details via access program                                            CER001
396400200528      ** (database error handling done in access program)                                     CER001
396500200528      *                                                                                       CER001
396600200528     C                   CALLB     'AODEALR0'                                                 CER001
396700200528     C                   PARM      '*DBERR '     @RTCD                                        CER001
396800200528     C                   PARM      '*FIRST '     @OPTN                                        CER001
396900200528     C     SDDEAL        PARM      SDDEAL        DSFDY                                        CER001
397000200528      *                                                                                       CER001
397100200528      **  GET RUNDAT to access multi-branching indicator on.
397200200528      *
397300200528     C     *DTAARA       DEFINE                  RUNDAT
397400200528     C                   IN        RUNDAT
397500200528     C                   UNLOCK    RUNDAT
397600200528                                                                                              CAP086
397700200528      ** Access SAR details file to determine if                                              CAP086
397800200528      ** Automatic Authorisation is installed                                                 CAP086
397900200528                                                                                              CAP086
398000200528     C                   EVAL      CAP086 = 'N'                                               CAP086
398100200528     C                   CALL      'AOSARDR0'                                                 CAP086
398200200528     C                   PARM      *BLANKS       @RTCD                                        CAP086
398300200528     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
398400200528     C                   PARM      'CAP086'      @SARD                                        CAP086
398500200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
398600200528                                                                                              CAP086
398700200528     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
398800200528     C                             @RTCD <> '*NRF'                                            CAP086
398900200528     C     *LOCK         IN        LDA                                                        CAP086
399000200528     C                   EVAL      DBPGM = 'GLAMADVU'                                         CAP086
399100200528     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
399200200528     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
399300200528     C                   EVAL      DBASE  = 1                                                 CAP086
399400200528     C                   OUT       LDA                                                        CAP086
399500200528     C                   EXSR      *PSSR                                                      CAP086
399600200528     C                   ENDIF                                                                CAP086
399700200528                                                                                              CAP086
399800200528     C     @RTCD         IFEQ      *BLANK                                                     CAP086
399900200528     C                   MOVEL     'Y'           CAP086                                       CAP086
400000200528     C                   ENDIF                                                                CAP086
400100200528      *                                                                                       CRE030
400200200528      ** Check if feature CRE030 is active                                                    CRE030
400300200528      *                                                                                       CRE030
400400200528     C                   CALL      'AOSARDR0'                                                 CRE030
400500200528     C                   PARM      '       '     @RTCD             7                          CRE030
400600200528     C                   PARM      '*VERIFY'     @OPTN             7                          CRE030
400700200528     C                   PARM      'CRE030'      @SARD             6                          CRE030
400800200528     C*                                                                                       CRE030
400900200528     C                   IF        @RTCD = *BLANKS                                            CRE030
401000200528     C                   MOVE      'Y'           CRE030            1                          CRE030
401100200528     C                   ELSE                                                                 CRE030
401200200528     C                   MOVE      'N'           CRE030                                       CRE030
401300200528     C                   ENDIF                                                                CRE030
401400200528                                                                                              CRE015
401500200528      ** Check if term and notice account feature is installed                                CRE015
401600200528                                                                                              CRE015
401700200528     C                   EVAL      CRE015 = 'N'                                               CRE015
401800200528     C                   CALL      'AOSARDR0'                                                 CRE015
401900200528     C                   PARM      *BLANKS       @RTCD                                        CRE015
402000200528     C                   PARM      '*VERIFY'     @OPTN                                        CRE015
402100200528     C                   PARM      'CRE015'      @SARD                                        CRE015
402200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
402300200528                                                                                              CRE015
402400200528     C                   IF        @RTCD <> *BLANKS AND                                       CRE015
402500200528     C                             @RTCD <> '*NRF'                                            CRE015
402600200528     C     *LOCK         IN        LDA                                                        CRE015
402700200528     C                   EVAL      DBPGM = 'GLAMADVU'                                         CRE015
402800200528     C                   EVAL      DBKEY = 'CRE015'                                           CRE015
402900200528     C                   EVAL      DBFILE ='SCSARDPD'                                         CRE015
403000200528     C                   EVAL      DBASE  = 903                                               CRE015
403100200528     C                   OUT       LDA                                                        CRE015
403200200528     C                   EXSR      *PSSR                                                      CRE015
403300200528     C                   ENDIF                                                                CRE015
403400200528                                                                                              CRE015
403500200528     C                   IF        @RTCD = *BLANKS                                            CRE015
403600200528     C                   EVAL      CRE015 = 'Y'                                               CRE015
403700200528     C                   ENDIF                                                                CRE015
403800200528      *
403900200528      ** Access SAR details file to determine if CER048 is on.                              BUG22742
404000200528      *                                                                                     BUG22742
404100200528     C                   EVAL      CER048 = 'N'                                             BUG22742
404200200528      *                                                                                     BUG22742
404300200528     C                   CALL      'AOSARDR0'                                               BUG22742
404400200528     C                   PARM      *BLANKS       @RTCD                                      BUG22742
404500200528     C                   PARM      '*VERIFY'     @OPTN                                      BUG22742
404600200528     C                   PARM      'CER048'      @SARD                                      BUG22742
404700200528     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG22742
404800200528      *                                                                                     BUG22742
404900200528     C                   IF        @RTCD <> *BLANKS AND                                     BUG22742
405000200528     C                             @RTCD <> '*NRF'                                          BUG22742
405100200528     C     *LOCK         IN        LDA                                                      BUG22742
405200200528     C                   EVAL      DBPGM = 'GLAMADVU'                                       BUG22742
405300200528     C                   EVAL      DBKEY = 'CER048'                                         BUG22742
405400200528     C                   EVAL      DBFILE ='SCSARDPD'                                       BUG22742
405500200528     C                   EVAL      DBASE = 903                                              BUG22742
405600200528     C                   OUT       LDA                                                      BUG22742
405700200528     C                   EXSR      *PSSR                                                    BUG22742
405800200528     C                   ENDIF                                                              BUG22742
405900200528      *                                                                                     BUG22742
406000200528     C     @RTCD         IFEQ      *BLANK                                                   BUG22742
406100200528     C                   MOVEL     'Y'           CER048                                     BUG22742
406200200528     C                   ENDIF                                                              BUG22742
406300200528      *                                                                                     BUG22742
406400200528      ** Check if retail account balance check feature is installed.                        MD028970
406500200528                                                                                            MD028970
406600200528     C                   EVAL      CRE010 = 'N'                                             MD028970
406700200528     C                   CALL      'AOSARDR0'                                               MD028970
406800200528     C                   PARM      *BLANKS       @RTCD                                      MD028970
406900200528     C                   PARM      '*VERIFY'     @OPTN                                      MD028970
407000200528     C                   PARM      'CRE010'      @SARD                                      MD028970
407100200528     C     SCSARD        PARM      SCSARD        DSFDY                                      MD028970
407200200528                                                                                            MD028970
407300200528     C                   IF        @RTCD <> *BLANKS AND                                     MD028970
407400200528     C                             @RTCD <> '*NRF'                                          MD028970
407500200528     C     *LOCK         IN        LDA                                                      MD028970
407600200528     C                   EVAL      DBPGM = 'GLAMADVU'                                       MD028970
407700200528     C                   EVAL      DBKEY = 'CRE010'                                         MD028970
407800200528     C                   EVAL      DBFILE ='SCSARDPD'                                       MD028970
407900200528     C                   EVAL      DBASE  = 903                                             MD028970
408000200528     C                   OUT       LDA                                                      MD028970
408100200528     C                   EXSR      *PSSR                                                    MD028970
408200200528     C                   ENDIF                                                              MD028970
408300200528                                                                                            MD028970
408400200528     C                   IF        @RTCD = *BLANKS                                          MD028970
408500200528     C                   EVAL      CRE010 = 'Y'                                             MD028970
408600200528     C                   ENDIF                                                              MD028970
408700200528      *                                                                                     MD044546
408800200528      ** Check if CAP205 is installed.                                                      MD044546
408900200528      *                                                                                     MD044546
409000200528     C                   EVAL      CAP205 = 'N'                                             MD044546
409100200528     C                   CALL      'AOSARDR0'                                               MD044546
409200200528     C                   PARM      *BLANKS       @RTCD                                      MD044546
409300200528     C                   PARM      '*VERIFY'     @OPTN                                      MD044546
409400200528     C                   PARM      'CAP205'      @SARD                                      MD044546
409500200528     C     SCSARD        PARM      SCSARD        DSFDY                                      MD044546
409600200528                                                                                            MD044546
409700200528     C                   IF        @RTCD <> *BLANKS AND                                     MD044546
409800200528     C                             @RTCD <> '*NRF'                                          MD044546
409900200528     C     *LOCK         IN        LDA                                                      MD044546
410000200528     C                   EVAL      DBPGM = 'GLAMADVU'                                       MD044546
410100200528     C                   EVAL      DBKEY = 'CAP205'                                         MD044546
410200200528     C                   EVAL      DBFILE ='SCSARDPD'                                       MD044546
410300200528     C                   EVAL      DBASE  = 905                                             MD044546
410400200528     C                   OUT       LDA                                                      MD044546
410500200528     C                   EXSR      *PSSR                                                    MD044546
410600200528     C                   ENDIF                                                              MD044546
410700200528                                                                                            MD044546
410800200528     C                   IF        @RTCD = *BLANKS                                          MD044546
410900200528     C                   EVAL      CAP205 = 'Y'                                             MD044546
411000200528     C                   ENDIF                                                              MD044546
411100200528      *                                                                                     MD044546
411200200528      ** Check if CER050 is ON                                                              MD054028
411300200528      *                                                                                     MD054028
411400200528     C                   CALLB     'AOSARDR0'                                               MD054028
411500200528     C                   PARM      *BLANKS       @RTCD                                      MD054028
411600200528     C                   PARM      '*VERIFY'     @OPTN                                      MD054028
411700200528     C                   PARM      'CER050'      @SARD                                      MD054028
411800200528     C     SCSARD        PARM      SCSARD        DSFDY                                      MD054028
411900200528                                                                                            MD054028
412000200528     C     @RTCD         IFEQ      *BLANK                                                   MD054028
412100200528     C                   EVAL      CER050 = 'Y'                                             MD054028
412200200528     C                   ELSE                                                               MD054028
412300200528     C                   EVAL      CER050 = 'N'                                             MD054028
412400200528     C                   ENDIF                                                              MD054028
412500200528      *                                                                                     MD054028
412600200528     C/COPY OFCPYSRCZ,CRE101_009                                                              CRE101
412700200528     C/COPY WNCPYSRC,GLH00652
412800200528      **  Define key list to access ACCPTFR
412900200528     C     PTFRK         KLIST
413000200528     C                   KFLD                    WWPTFR            4
413100200528     C**********         KFLD                    WWCNUM            6 0                        CSD027
413200200528     C                   KFLD                    WWCNUM            6                          CSD027
413300200528     C                   KFLD                    WWCCY             3
413400200528     C                   KFLD                    WWACOD           10 0
413500200528     C                   KFLD                    WWACSQ            2 0
413600200528     C*
413700200528     C** Key list to access full account details from ACCNTLXX
413800200528     C*
413900200528     C     WWACKA        KLIST
414000200528     C                   KFLD                    WWBRCA
414100200528     C                   KFLD                    WWCNUM
414200200528     C                   KFLD                    WWCCY
414300200528     C                   KFLD                    WWACOD
414400200528     C                   KFLD                    WWACSQ
414500200528      *                                                                                       BUG553
414600200528     C     ACODK         KLIST                                                                BUG553
414700200528     C                   KFLD                    WWACOK           10 0                        BUG553
414800200528     C                   KFLD                    WWRECI            1                          BUG553
414900200528      *                                                                                       CRE030
415000200528     C     ACODK2        KLIST                                                                CRE030
415100200528     C                   KFLD                    WWACOK                                       CRE030
415200200528     C                   KFLD                    WWRECI                                       CRE030
415300200528     C                   KFLD                    WWACCY            3                          CRE030
415400200528      *                                                                                       BUG553
415500200528     C     WWACKB        KLIST                                                                BUG553
415600200528     C                   KFLD                    WWBRCK            3                          BUG553
415700200528     C**********         KFLD                    WWCUSK            6 0                 BUG553 CSD027
415800200528     C                   KFLD                    WWCUSK            6                          CSD027
415900200528     C                   KFLD                    WWCCYK            3                          BUG553
416000200528     C                   KFLD                    WWACOK           10 0                        BUG553
416100200528     C                   KFLD                    WWACSK            2 0                        BUG553
416200200528      *                                                                                       BUG553
416300200528     C     WWACK2        KLIST                                                                BUG553
416400200528     C                   KFLD                    WWCUSK                                       BUG553
416500200528     C                   KFLD                    WWCCYK                                       BUG553
416600200528     C                   KFLD                    WWACOK                                       BUG553
416700200528     C                   KFLD                    WWACSK                                       BUG553
416800200528     C                   KFLD                    WWBRCK                                       BUG553
416900200528
417000200528     C                   ENDSR
417100200528      *****************************************************************
