000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*XBIA*: OVRDBF FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)          : *
000500200604/*XBIB*: OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)          : *
000600200604/*XBIC*: OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)          : *
000700200604/*XBID*: OVRDBF FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)          : *                      BUG3362
000800200604/*XBIE*: OVRDBF FILE(SDCMRKLR) TOFILE(SDCMRKL1) SHARE(*NO)          : *                       CSD079
000900200604/*XBIF*: OVRDBF FILE(SDACUSLR) TOFILE(SDACUSL1) SHARE(*NO)          : *                       CSD079
001000200604/*XBIG*: OVRDBF FILE(SDCFCDLR) TOFILE(SDCFCDL1) SHARE(*NO)          : *                       CSD079
001100200604/*XBIH*: OVRDBF FILE(SDCHEQLR) TOFILE(SDCHEQL1) SHARE(*NO)          : *                       CSD079
001200200604/*XBII*: OVRDBF FILE(SDCRWALR) TOFILE(SDCRWAL1) SHARE(*NO)          : *                       CSD079
001300200604/*XBIJ*: OVRDBF FILE(SDFOCSLR) TOFILE(SDFOCSL1) SHARE(*NO)          : *                       CSD079
001400200604/*XBIK*: OVRDBF FILE(SDPLCSLR) TOFILE(SDPLCSL0) SHARE(*NO)          : *                       CSD079
001500200604/*XBIL*: OVRDBF FILE(SDFOX1LR) TOFILE(SDFOX1L0) SHARE(*NO)          : *                       CSD079
001600200604/*XBIM*: OVRDBF FILE(SDCUX2LR) TOFILE(SDCUX2L0) SHARE(*NO)          : *                       CSD079
001700200604/*XBIN*: OVRDBF FILE(SDCUX1LR) TOFILE(SDCUX1L0) SHARE(*NO)          : *                       CSD079
001800200604/*STD *  RPGBASEMOD                                                   *
001900200604/*EXI *  TEXT('Midas SD Cust details retrieve + act/cust val')        *
002000200604      *****************************************************************
002100200604      *                                                               *
002200200604      *  Midas - Standing Data ILE Module                             *
002300200604      *                                                               *
002400200604      *  SDCUSDRTV - CUSTOMER DETAILS RETRIEVE                        *
002500200604      *              (WITH ACTION CODE VERSUS CUSTOMER NO VALIDATION  *
002600200604      *                                                               *
002700200604      *  Function:  This module retrieves a customer from             *
002800200604      *             the database. As it does so, it validates the     *
002900200604      *             action code and Customer number.                  *
003000200604      *                                                               *
003100200604      *  (c) Finastra International Limited 2001                      *
003200200604      *                                                               *
003300200604      *  Last Amend No. 254109             Date 01Jun20               *
003400200604      *  Prev Amend No. MD048748           Date 16Dec19               *
003500200604      *                 MD052297           Date 14Nov19               *
003600200604      *                 MD053634           Date 21Oct19               *
003700200604      *                 CER050             Date 16Jun19               *
003800200604      *                 MD052425           Date 22Aug19               *
003900200604      *                 MD050457           Date 06Mar19               *
004000200604      *                 MD050212           Date 02Apr18               *
004100200604      *                 MD041527           Date 22Sep16               *
004200200604      *                 MD041337           Date 16Sep16               *
004300200604      *                 MD039670           Date 26Jul16               *
004400200604      *                 CGL177             Date 11Jan16               *
004500200604      *                 MD035388           Date 20Oct15               *
004600200604      *                 CGL157             Date 17Aug15               *
004700200604      *                 MD046248           Date 27Oct17               *
004800200604      *                 MD042652           Date 06Feb17               *
004900200604      *                 CSW216             Date 14Mar16               *
005000200604      *                 CER071             Date 01Aug16               *
005100200604      *                 CER070             Date 03Dec14               *
005200200604      *                 CSW214             Date 03Dec14               *
005300200604      *                 MD030956           Date 09Oct14               *
005400200604      *                 CER069             Date 03Jul14               *
005500200604      *                 MD025006           Date 19Aug14               *
005600200604      *                 MD022997           Date 24Apr14               *
005700200604      *                 MD026780           Date 08May14               *
005800200604      *                 MD026253           Date 09May14               *
005900200604      *                 CGL132             Date 01May13               *
006000200604      *                 AR1086546          Date 18Jun13               *
006100200604      *                 MD023955           Date 05Dec13               *
006200200604      *                 MD022766           Date 09Oct13               *
006300200604      *                 MD023115           Date 03Nov13               *
006400200604      *                 MD022861           Date 15Oct13               *
006500200604      *                 MD022587           Date 27Sep13               *
006600200604      *                 MD022557A          Date 03Oct13               *
006700200604      *                 MD022557           Date 02Oct13               *
006800200604      *                 MD022463           Date 27Sep13               *
006900200604      *                 MD022520           Date 24Sep13               *
007000200604      *                 MD022408           Date 16Sep13               *
007100200604      *                 MD022395           Date 15Sep13               *
007200200604      *                 CFT050             Date 03Jun13               *
007300200604      *                 CSW213             Date 03Jun13               *
007400200604      *                 AR725233           Date 20May13               *
007500200604      *                 MD000091           Date 03May13               *
007600200604      *                 MD019261           Date 12Apr13               *
007700200604      *                 CLE134             Date 01Aug12               *
007800200604      *                 AR855391           Date 27Oct11               *
007900200604      *                 CSD090             Date 06Dec10               *
008000200604      *                 CSD091             Date 04Jun11               *
008100200604      *                 CER059             Date 19Jul10               *
008200200604      *                 BUG23518           Date 30Mar09               *
008300200604      *                 BUG23513           Date 20Mar09               *
008400200604      *                 BUG27866           Date 05Jul10               *
008500200604      * Bank Fusion Midas 1.4 Base -----------------------------------*
008600200604      *                 258838             Date 20Feb09               *
008700200604      * Midas Plus 1.4 Base 04 ---------------------------------------*
008800200604      *                 256564             Date 17Sep08               *
008900200604      *                 253344 (BUG16825)  Date 13Mar08               *
009000200604      *                 253211             Date 05Mar08               *
009100200604      *                 BUG15872           Date 12Feb08               *
009200200604      *                 BUG15138           Date 25Oct07               *
009300200604      *                 CSW207A            Date 23Jul07               *
009400200604      *                 CSW207             Date 06Jul07               *
009500200604      *                 246639             Date 05Jun07               *
009600200604      *                 249593             Date 22Aug07               *
009700200604      *                 249322             Date 03Aug07               *
009800200604      *                 249029             Date 11Jul07               *
009900200604      *                 246639             Date 05Jun07               *
010000200604      * Midas Plus 1.4 Base ------------------------------------------*
010100200604      *                 241040             Date 07Feb07               *
010200200604      *                 BUG13525           Date 05Mar07               *
010300200604      *                 CSD079             Date 05Feb07               *
010400200604      *                 BG12238            Date 24Oct06               *
010500200604      *                 BG12033            Date 19Sep06               *
010600200604      *                 CRE026             Date 06Jun06               *
010700200604      * Midas Plus 1.3 ----------- Base ------------------------------*
010800200604      *                 BUG11935           Date 22Aug06               *
010900200604      *                 BUG11932           Daet 23Aug06               *
011000200604      *                 BUG11934           Date 21Aug06               *
011100200604      *                 BUG11917           Daet 18Aug06               *
011200200604      *                 BUG11886           Date 17Aug06               *
011300200604      *                 BUG11828           Date 13Aug06               *
011400200604      *                 BUG11888           Date 11Aug06               *
011500200604      *                 CSD031             Date 10Apr06               *
011600200604      *                 BUG8550            Date 07Oct05               *
011700200604      *                 CSD027             Date 09Dec05               *
011800200604      *                 CRN001             Date 04Nov05               *
011900200604      *                 CSD028             Date 22Aug05               *
012000200604      *                 BUG8169            Date 06Sep05               *
012100200604      *                 BUG7233            Date 20May05               *
012200200604      *                 CSW037A            Date 02May05               *
012300200604      *                 BUG6198            Date 04Apr05               *
012400200604      *                 CSD023             Date 18Nov04               *
012500200604      *                 CSD025             Date 11Jan05               *
012600200604      *                 CSW037             Date 15Dec04               *
012700200604      *                 CSW036             Date 15Dec04               *
012800200604      *                 BUG3362            Date 28Jul04               *
012900200604      *                 CLE025             Date 20Oct03               *
013000200604      *                 BUG2653            Date 15May04               *
013100200604      *                 BUG2313            Date 28Apr04               *
013200200604      *                 CSD021             Date 10Jul03               *
013300200604      *                 CGL029             Date 03Sep01               *
013400200604      *                 CGP001             Date 23May03               *
013500200604      *                 215524             Date 19Jun03               *
013600200604      *                 214144             Date 11Feb03               *
013700200604      *                 CGL013             Date 29Mar02               *
013800200604      *                 CSD012             Date 15Oct02               *
013900200604      * Midas Release 4.01.03 ----------------------------------------*
014000200604      * Midas Release 4.01 -------------------------------------------*
014100200604      *                 198304             Date 18Feb02               *
014200200604      *                 CSW024             Date 31Aug01               *
014300200604      * Midas Release 4 --------------- Base -------------------------*
014400200604      * Midas DBA 3.05 -----------------------------------------------*
014500200604      *                 CRE007             Date 01Mar01               *
014600200604      * Midas DBA 3.04 -----------------------------------------------*
014700200604      *                 CSD007             Date 28Aug00               *
014800200604      *                 CDL008             Date 02May00               *
014900200604      * Midas DBA 3.02 -----------------------------------------------*
015000200604      *                 CAP034  *CREATE    Date 27Apr99               *
015100200604      *                                                               *
015200200604      *---------------------------------------------------------------*
015300200604      *                                                               *
015400200604      *  254109 - Introduce new err msgs; one for the 'D' action code *
015500200604      *           and another one for 'C' and 'R' action codes ( when *
015600200604      *           CSD007 feauture is switched on) just to indicate the*
015700200604      *           reason why action code is invalid.                  *
015800200604      *  MD048748 - Error Authorising Release of a Closed Customer    *
015900200604      *             with Parent Defined                               *
016000200604      *  MD052297 - Meaningless error message displayed when closing  *
016100200604      *             customer.                                         *
016200200604      *  MD053634 - Requested Customer Authority Holders Link Report *
016300200604      *             for KWG$24c not generated.                       *
016400200604      *  CER050 - Annualised Percentage Rate (Recompile)              *
016500200604      *  MD052425 - COB Failure re New Customer Closure feature CSD007*
016600200604      *  MD050457 - Customer deletion: Issue detailed error message   *
016700200604      *             Patterned fix from 261272.                        *
016800200604      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
016900200604      *  MD041527 - Customer cannot be amended after deleting         *
017000200604      *             Additional Customer Details                       *
017100200604      *  MD041337 - Customer cannot be enquired after deleting        *
017200200604      *             Additional Customer Details                       *
017300200604      *  MD039670 - FATCA Housekeeping program                        *
017400200604      *  CGL177 - CRS Reporting Phase 2                               *
017500200604      *  MD033588 - FATCA Screen order rework                         *
017600200604      *  CGL157 - CRS Reporting                                       *
017700200604      *  MD046248 - Finastra Rebranding                               *
017800200604      *  MD042652 - FFC0800 FAILED IN COB                             *
017900200604      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
018000200604      *  CER071 - BAIS - Legal Form field (Recompile)                 *
018100200604      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
018200200604      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
018300200604      *  MD030956 - Additional changes to BFM-TI enhancement          *
018400200604      *  CER069 - German Tax Enhancement                              *
018500200604      *  MD025006 - Incorrect error message displayed when amending   *
018600200604      *             an already deleted customer                       *
018700200604      *  MD022997 - Customer being filtered was not displayed on the  *
018800200604      *             main list view of CUSD maintenance                *
018900200604      *  MD026780 - Issues on Authority Holders                       *
019000200604      *  MD026253 - Added Authority Holder is not displayed after     *
019100200604      *              Amendment Authorisation                          *
019200200604      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
019300200604      *           Classification - Master                             *
019400200604      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
019500200604      *              Applied for MD021813                             *
019600200604      *  MD023955 - Invalid value on Clearing ID is reflected to      *
019700200604      *             other transactions with blank Clearing ID         *
019800200604      *  MD022766 - Value of fields are cleared when transaction is   *
019900200604      *             authorized                                        *
020000200604      *  MD023115 - Cannot Complete CUAP for Fedwire, Bankleitzahl,   *
020100200604      *             BOJ Financial Institution, Chaps  Sort Code De-   *
020200200604      *             faulting                                          *
020300200604      *  MD022861 - 1st and 2nd line of MT3xx Receiver Party Infor-   *
020400200604      *             mation fields were not defaulted.                 *
020500200604      *  MD022587 - Clearing System incorrect defaulting for ISO      *
020600200604      *             Country code CA  and CH                           *
020700200604      *  MD022557A - Incorrect validation in MT3xx receiver party     *
020800200604      *             information and LEI (Reopen)                      *
020900200604      *  MD022557 - Incorrect validation in MT3xx receiver party      *
021000200604      *             information and LEI                               *
021100200604      *  MD022463 - No screen is displayed to show Bank Directory     *
021200200604      *             Plus Detail Screen on Linked Customers during     *
021300200604      *             Amend and Enquire                                 *
021400200604      *  MD022520 - National ID with ISO Country Code DE not defaulted*
021500200604      *             to Bankleitzahl.                                  *
021600200604      *  MD022408 - Institution status from Bank Directory plus is not*
021700200604      *             defaulted not defaulted in Bank field in customer *
021800200604      *             details after pressing complete button            *
021900200604      *  MD022395 - Value of Clearing System on previously checked    *
022000200604      *             customer is copied into another customer when     *
022100200604      *             amending it                                       *
022200200604      *  CFT050 - SWIFTRef Directories upload                         *
022300200604      *  CSW213 - SWIFT Changes 2013                                  *
022400200604      *  AR725233 - Deleted customer shows blank fields. Prevent      *
022500200604      *             error message for deleted customer during enquiry *
022600200604      *             so system will still retrieve available details.  *
022700200604      *             (Child: AR725234)                                 *
022800200604      *  MD000091 - Event Codes Substitution                          *
022900200604      *  MD019261 - Incorrect error message displayed upon closing    *
023000200604      *             customer attached to facility.                    *
023100200604      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
023200200604      *  AR855391 - CUSD Overridable Errors not found in EN System    *
023300200604      *  CSD090 - Customer Segmentation (Recompile)                   *
023400200604      *  CSD091 - Overrideable Errors Configurability Enabler Phase 2 *
023500200604      *  CER059 - German Feature Upgrade to Delhi                     *
023600200604      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
023700200604      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
023800200604      *             Customer Closure                                  *
023900200604      *  BUG23513 - Add missing parameter due to changes made to      *
024000200604      *             SD0010U. Apply GEMS fix 253823                    *
024100200604      *  BUG27866 - Timeout happens during delete                     *
024200200604      *  258838 - Create new system values to check the branch/user   *
024300200604      *           authority.                                          *
024400200604      *  256564 - Recompile due to PF changes done by fix 256330      *
024500200604      *  253344 - Misleading error msg USR9834 when closing customer. *
024600200604      *           Amend message to explain cause of the problem.      *
024700200604      *           (BUG16825)                                          *
024800200604      *  253211 - Add missing parameter to prevent parameter not      *
024900200604      *           passed error. Apply fix 248959A.                    *
025000200604      *  BUG15872 - Parameter mismatch.                               *
025100200604      *  BUG15138 - IBEI is not updated when CSW207 is off            *
025200200604      *  CSW207A - SWIFT 2007 Changes                                 *
025300200604      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
025400200604      *  246639 - FOOB in LEC08 pgm LE0710 happens due to access to a *
025500200604      *           parent customer which is closed. Pattern fix after  *
025600200604      *           230157.                                             *
025700200604      *  249593 - Reverse 249322 and add parameters to SDCUSDVU       *
025800200604      *           instead of removing them in SDCUSDRTV.              *
025900200604      *  249322 - Comment out added *ENTRY parms for CSD031.          *
026000200604      *           Applied partial fix of 13525.                       *
026100200604      *  249029 - Correct S270006 message.                            *
026200200604      *  246639 - FOOB in LEC08 pgm LE0710 happens due to access to a *
026300200604      *           parent customer which is closed. Pattern fix after  *
026400200604      *           230157.                                             *
026500200604      *  241040 - Allow enquiry on deleted cutomers.                  *
026600200604      *  BUG13525 - ECSD Mismatch between XML and RPG                 *
026700200604      *  CSD079 - Enhanced Customer Maintenance API                   *
026800200604      *  BG12238 - Conditional writes to files within wholesale/      *
026900200604      *            universal customer input                           *
027000200604      *  BG12033 - Error in Universal Customer Maintenance in         *
027100200604      *            Consumer Banking                                   *
027200200604      *  CRE026 - Consumer Banking                                    *
027300200604      *  BUG11935 - Record in zonal not updated when amendment was    *
027400200604      *             globally                                          *
027500200604      *  BUG11932 - When Alphanumeric customer number set to 'Y',     *
027600200604      *             program should not use Modulus 10 check at all.   *
027700200604      *  BUG11934 - Screen did not move when pressing F8              *
027800200604      *  BUG11917 - Different error message appear when enquiring/    *
027900200604      *             accepting/deleting a record in zonal acceptance   *
028000200604      *  BUG11886 - Record inserted in Singapore Global not found     *
028100200604      *             in England Zone                                   *
028200200604      *  BUG11828 - If CSD031 is on, System Values are defined        *
028300200604      *             centrally.                                        *
028400200604      *  BUG11888 - Wrong validation error message displayed          *
028500200604      *  CSD031 - Enhanced Centralised Static Data                    *
028600200604      *  BUG8550 - Reposition capture of ZMUSER data area             *
028700200604      *            (code fix similar to CSD031)                       *
028800200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
028900200604      *  CRN001 - FRS Regulatory Reporting Interface                  *
029000200604      *  CSD028 - KYC (Standing Data Authorisations )                 *
029100200604      *  BUG8169 - Option/Action code field should be validated       *
029200200604      *            accordingly.                                       *
029300200604      *  BUG7233- Error message insufficient for CSD023               *
029400200604      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
029500200604      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
029600200604      *  CSD023 - Automatic Customer Account Closure                  *
029700200604      *  CSD025 - Customer De-Activation                              *
029800200604      *  CSW037 - Additional Field Data on MT300/MT320                *
029900200604      *  CSW036 - Dual SWIFT BIC held on Client Details               *
030000200604      *  BUG3362 - Added TI details for SD authorisation.             *
030100200604      *  CLE025 - Credit Lines (Recompile)                            *
030200200604      *  BUG2653 - Check allowed action codes against correct branch  *
030300200604      *            instead of the default branch defined in ZMUSER.   *
030400200604      *  BUG2313 - Numerous errors concerning global customer id      *
030500200604      *  CSD021 - System Generated Customer Number.                   *
030600200604      *  CGL029 - Increase Account Code to 10 digits                  *
030700200604      *  CGP001 - Global Processing                                   *
030800200604      *  215524 - Amendment possible to closed customers. Added       *
030900200604      *           validation not to allow amendment when customer     *
031000200604      *           closure flag is 'Y'.                                *
031100200604      *  214144 - Customer Maintenance. We are unable to Amend or     *
031200200604      *           Enquire on customers that fail the Modulus 10 check.*
031300200604      *           Fix is to amend this module so that Modulus 10      *
031400200604      *           checking would only be done on 'I'nsert.            *
031500200604      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
031600200604      *                                      of SDNWRKPD)             *
031700200604      *  CSD012 - Standing Data Authorisation                         *
031800200604      *  198304 - Amend so that customer deletion is not allowed if   *
031900200604      *           customer is a syndication agent of a branch.        *
032000200604      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
032100200604      *  CRE007 - Base Rate Tax 2001 - Recompiled.                    *
032200200604      *  CSD007 - Customer Closing:                                   *
032300200604      *           Allow for action codes 'C' (closure) and 'R'        *
032400200604      *           (release).                                          *
032500200604      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
032600200604      *  CAP034 - Conversion of SD inputs into modular structure to   *
032700200604      *           use as APIs.                                        *
032800200604      *                                                               *
032900200604      *****************************************************************
033000200604      ** +--------------------------------------+
033100200604      ** ¦ F-specs                              ¦
033200200604      ** ¦ =======                              ¦
033300200604      ** +--------------------------------------+
033400200604
033500200604     FSDCUSTLR  IF   E           K DISK    INFSR(*PSSR)
033600200604
033700200604     FSDCMRKLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
033800200604      ** Marketing Information   Retrieval index                                              CSD079
033900200604                                                                                              CSD079
034000200604     FSDACUSLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
034100200604      ** Additional Customer Details Retrieval index                                          CSD079
034200200604                                                                                              CSD079
034300200604     FSDCFCDLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
034400200604      ** Service Fees Retrieval index                                                         CSD079
034500200604                                                                                              CSD079
034600200604     FSDCHEQLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
034700200604      ** Cheques and Cards Details Retrieval index                                            CSD079
034800200604                                                                                              CSD079
034900200604     FSDSAFEL1  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
035000200604      ** Safe Details Retrieval index                                                         CSD079
035100200604                                                                                              CSD079
035200200604     FSDCRWALR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
035300200604      ** Risk Weighted Assets Details Retrieval index                                         CSD079
035400200604                                                                                              CSD079
035500200604     FSDFOCSLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
035600200604      ** Midas SD Futures and Options client retrieval                                        CSD079
035700200604                                                                                              CSD079
035800200604     FSDFOX1LR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
035900200604      ** Valid Futures & options European Reporting layout                                    CSD079
036000200604                                                                                              CSD079
036100200604     FSDPLCSLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
036200200604      ** Portfolio Management Retrieval index                                                 CSD079
036300200604                                                                                              CSD079
036400200604     FSDBRCHL5  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
036500200604      ** RSQ : Midas SD Branch codes by customer number                                       CSD079
036600200604                                                                                              CSD079
036700200604     FSDCUX2LR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
036800200604      ** Lux(European Reporting) file by customer Number                                      CSD079
036900200604                                                                                              CSD079
037000200604     FSDCUX1LR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
037100200604      ** Lux(IBLC - Extended Information)file by customer Number                              CSD079
037200200604                                                                                              CSD079
037300200604     FSDCUSDL0  IF   E           K DISK    INFSR(*PSSR)
037400200604     F                                     RENAME(SDCUSTD0:SDCUSFOI)
037500200604
037600200604     FSDCBRTLR  IF   E           K DISK    INFSR(*PSSR)
037700200604
037800200604     FSDPBDSLR  IF   E           K DISK    INFSR(*PSSR)
037900200604     F                                     PREFIX(A_)
038000200604     FSDTICSLR  IF   E           K DISK    INFSR(*PSSR)                                      BUG3362
038100200604     F                                     PREFIX(A_)                                        BUG3362
038200200604
038300200604      ** Global Customers X-Reference Retrieval index                                         CGP001
038400200604     FGPCUSTXL1 IF   E           K DISK    INFSR(*PSSR)                                       CGP001
038500200604                                                                                              CGP001
038600200604      * RTV : Customer Risk Weight Code Retrieval index
038700200604     FSDCRWCL1  IF   E           K DISK    INFSR(*PSSR)
038800200604
038900200604      * RTV : Midas SD Message type descriptions retrieval
039000200604     FSDMTPYL1  IF   E           K DISK    INFSR(*PSSR)
039100200604
039200200604      * RTV : Message Network Details   Retrieval index
039300200604     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
039400200604                                                                                              CSD012
039500200604      * RTV : Authorisation Log - by Function                                                 CSD012
039600200604     FSDAULGL2  IF   E           K DISK    INFSR(*PSSR)                                       CSD012
039700200604      *                                                                                       CSD028
039800200604     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
039900200604      ** RTV: Customer Details Shadow File                                                    CSD028
040000200604                                                                                              CSD028
040100200604     FSDCBSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
040200200604     F                                     RENAME(SDCBRTD0:@BRTRF)                            CSD028
040300200604      ** RTV: BRT Customer Details Shadow File                                                CSD028
040400200604                                                                                              CSD028
040500200604     FSDPBSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
040600200604     F                                     RENAME(SDPBDSD0:@CPBRF)                            CSD028
040700200604      ** RTV: SD API Cust Private Banking Shadow File                                         CSD028
040800200604                                                                                              CSD028
040900200604     FSDTDSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
041000200604      ** RTV: TI Customer Details Shadow File                                                 CSD028
041100200604                                                                                              CSD028
041200200604     FSDCSSWL1  IF   E           K DISK    INFSR(*PSSR)                                       CSW207
041300200604      *                                                                                       CSW207
041400200604      ** RTV : Midas SD Customer Swift extension file                                         CSW207
041500200604      *                                                                                       CSW207
041600200604      ** FATCA Customer details file                                                          CGL132
041700200604     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
041800200604                                                                                              CGL132
041900200604      ** FATCA Customer details file by Front office ID                                       CGL132
042000200604     FSDFTCSL2  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
042100200604     F                                     PREFIX(A_)                                         CGL132
042200200604     F                                     RENAME(SDFTCSD0:SDFTCSD1)                          CGL132
042300200604                                                                                              CGL132
042400200604      *                                                                                       CGL132
042500200604      ** RTV : Midas SD Customer Extension - C                                                CGL132
042600200604      *                                                                                       CGL132
042700200604     FSDCUSXL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
042800200604     F                                     RENAME(SDCUSTX0:SDCUSTX1)                          CGL132
042900200604                                                                                              CGL132
043000200604      ** Midas SD CRS Customer Details Retrieval                                              CGL157
043100200604     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
043200200604                                                                                              CGL157
043300200604      * Midas SD CRS Details File                                                             CGL157
043400200604     FSDCRSDL0  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
043500200604                                                                                              CSD031
043600200604      ** Customer Details Acceptance - Retrieve Index                                         CSD031
043700200604     F***SDACSTL1  IF   E           K DISK    INFSR(*PSSR)                           CSD031 BUG13525
043800200604     F**********                           RENAME(SDCUSTD0:SDACSTD1)                 CSD031 BUG13525
043900200604     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23518
044000200604      *                                                                                     BUG23518
044100200604      ** RTV : Midas SD Customer by Country of Tax File                                     BUG23518
044200200604      *                                                                                     BUG23518
044300200604     FSDACTXL4  IF   E           K DISK    INFSR(*PSSR)                                       CER059
044400200604     F                                     RENAME(SDACTXD0:SDACTXD4)                          CER059
044500200604      ** RTV : Midas SD Customer by Country of Tax File                                       CER059
044600200604                                                                                              CER059
044700200604     FSDCUAHLA  IF   E           K DISK    INFSR(*PSSR)                                       CER059
044800200604      ** RTV : Midas SD Customer Authority Holder File                                        CER059
044900200604                                                                                              CSD031
045000200604     F/COPY WNCPYSRC,SDCUSDIF01
045100200604                                                                                              CSD027
045200200604      * Customer Details Sorted By Shortname                                                  CSD027
045300200604     FSDCUSTLH  IF   E           K DISK    INFSR(*PSSR)                                       CSD027
045400200604     FMEBIB3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
045500200604      *                                                                                       CFT050
045600200604      ** RTV : SWIFTRef BANK DIRECTORY Plus                                                   CFT050
045700200604      *                                                                                       CFT050
045800200604     FMEIBN3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
045900200604      *                                                                                       CFT050
046000200604      ** RTV : SWIFTRef IBAN Plus                                                             CFT050
046100200604      *                                                                                       CFT050
046200200604      ** Country codes                                                                        CFT050
046300200604     FSDCTRYL3  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
046400200604
046500200604      *****************************************************************
046600200604      ** +--------------------------------------+
046700200604      ** ¦ Automatically included D-specs       ¦
046800200604      ** ¦ ==============================       ¦
046900200604      ** +--------------------------------------+
047000200604      **
047100200604      **--------------------------------------------------------------------------------------------
047200200604      ** The following /COPY line includes (among others) the LDA layout
047300200604      ** and the copyright array definition:
047400200604     D/COPY ZACPYSRC,STD_D_SPEC
047500200604      **--------------------------------------------------------------------------------------------
047600200604
047700200604      **--------------------------------------------------------------------------------------------
047800200604      ** The following /COPY includes the MM standard declares:
047900200604     D/COPY ZACPYSRC,STDDECLARE
048000200604      **--------------------------------------------------------------------------------------------
048100200604
048200200604      **--------------------------------------------------------------------------------------------
048300200604      ** The following /COPY line includes all the defined fields in the
048400200604      ** Program Status Data Structures.  They have meaningful
048500200604      ** names, prefixed by 'PS'.
048600200604     D/COPY ZACPYSRC,PSDS
048700200604      **--------------------------------------------------------------------------------------------
048800200604
048900200604      **--------------------------------------------------------------------------------------------
049000200604      ** The following /COPY line includes the definitions for error and
049100200604      ** warning message arrays.
049200200604     D/COPY ZACPYSRC,ERR_ARRAYS
049300200604      **--------------------------------------------------------------------------------------------
049400200604
049500200604      ** +--------------------------------------+
049600200604      ** ¦ End of automatically included D-specs¦
049700200604      ** ¦ =====================================¦
049800200604      ** +--------------------------------------+
049900200604
050000200604      *****************************************************************
050100200604      /EJECT
050200200604      *****************************************************************
050300200604
050400200604      ** +--------------------------------------+
050500200604      ** ¦ Manually included D-specs            ¦
050600200604      ** ¦ =========================            ¦
050700200604      ** +--------------------------------------+
050800200604
050900200604      ** +--------------------------------------+
051000200604      ** ¦ Named constants                      ¦
051100200604      ** ¦ ===============                      ¦
051200200604      ** +--------------------------------------+
051300200604                                                                                              CGL132
051400200604     D SysVal1         C                   'FATCADftCLsNewCustNH'                             CGL132
051500200604     D SysVal2         C                   'FATCACountryofTax'                                CGL132
051600200604
051700200604      ** +--------------------------------------+
051800200604      ** ¦ Arrays and Data Structures           ¦
051900200604      ** ¦ ==========================           ¦
052000200604      ** +--------------------------------------+
052100200604
052200200604     D SDBANK        E DS                  EXTNAME(SDBANKPD)
052300200604      ** EXTERNAL DS FOR BANK DETAILS ICD retrieval
052400200604     D DSFDY         E DS                  EXTNAME(DSFDY)
052500200604      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
052600200604
052700200604     D DSSDY         E DS                  EXTNAME(DSSDY)
052800200604      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
052900200604     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CGL132
053000200604
053100200604     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  CSD079
053200200604      ** Data Structure for Portfolio Management Details                                      CSD079
053300200604
053400200604      ** External DS for Customer Details                                                   BUG23518
053500200604     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23518
053600200604     D                                     PREFIX(A)                                        BUG23518
053700200604      ** Customer in File Format
053800200604     D CustFilFmt    E DS                  EXTNAME(SDCUSTPD)
053900200604      ** Customer Ext in File Format                                                          CGL132
054000200604     D CuXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                  CGL132
054100200604      ** SWIFT Details in File Format                                                         CSW207
054200200604     D SwftFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
054300200604      ** Customer Base Rate Tax in File Format
054400200604     D CubrFilFmt    E DS                  EXTNAME(SDCBRTPD)
054500200604      ** Customer Private Banking in File Format
054600200604     D CuPbFilFmt    E DS                  EXTNAME(SDPBDSPD)
054700200604     D                                     PREFIX(A_)
054800200604      ** TI Customer Details in File Format                                                  BUG3362
054900200604     D CuTIFilFmt    E DS                  EXTNAME(SDTICSPD)                                 BUG3362
055000200604     D                                     PREFIX(A_)                                        BUG3362
055100200604      ** Global Customer X-Reference in File Format                                           CGP001
055200200604     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
055300200604      ** FATCA Customer Details in file format                                                CGL132
055400200604     D CuFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                  CGL132
055500200604                                                                                              CGL132
055600200604      ** Midas FATCA Classification Code                                                      CGL132
055700200604     D SDFATC        E DS                  EXTNAME(SDFATCPD)                                  CGL132
055800200604     D                                     PREFIX(C_)                                         CGL132
055900200604                                                                                              CSD079
056000200604      ** Marketing Information Details in File Format                                         CSD079
056100200604     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
056200200604                                                                                              CSD079
056300200604      ** Additional Customer details in File Format                                           CSD079
056400200604     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
056500200604                                                                                              CSD079
056600200604      ** Service Fees Details in File Format                                                  CSD079
056700200604     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079
056800200604     D Q_QQSMAC      E                     EXTFLD(QQSMAC)                                     CSD079
056900200604                                                                                              CSD079
057000200604      ** Cheques and Cards Details in File Format                                             CSD079
057100200604     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
057200200604                                                                                              CSD079
057300200604      ** Safe details in File Format                                                          CSD079
057400200604     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
057500200604                                                                                              CSD079
057600200604      ** Risk weighted assets in Valid File Format                                            CSD079
057700200604     D RwanFilFmt    E DS                  EXTNAME(SDVRWANPD)                                 CSD079
057800200604                                                                                              CSD079
057900200604      ** Future and option Detail in File Format                                              CSD079
058000200604     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
058100200604                                                                                              CSD079
058200200604      ** Future & options European reporting in File Format                                   CSD079
058300200604     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CSD079
058400200604                                                                                              CSD079
058500200604      ** Fiduciary Details in File Format                                                     CSD079
058600200604     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
058700200604                                                                                              CSD079
058800200604     ** Lux(European Reporting) in file format                                                CSD079
058900200604     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CSD079
059000200604                                                                                              CSD079
059100200604     ** Lux(IBLC - Extended Information) in file format                                       CSD079
059200200604     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CSD079
059300200604                                                                                              CSD079
059400200604      ** Customer Acceptance Details Data Structure                                           CSD031
059500200604     D*SDACST***     E DS                  EXTNAME(SDACSTPD)                         CSD031 BUG13525
059600200604     D**********                           PREFIX(B_)                                CSD031 BUG13525
059700200604      ** Currency/Time of Netting Details File Format                                      AR1086546
059800200604     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)                              AR1086546
059900200604                                                                                           AR1086546
060000200604      ** Customer dtls Bank directory plus detail                                             CFT050
060100200604     D CuSW13        E DS                  EXTNAME(SDSW13PD)                                  CFT050
060200200604     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
060300200604     ** Business Entity Identifier                                                            CFT050
060400200604     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CFT050
060500200604     D TranInMT3X    E DS                  EXTNAME(SDCUMTPD)                                  CFT050
060600200604     D TranInPrim    E DS                  EXTNAME(SDCUPRPD)                                  CFT050
060700200604     D                                     PREFIX(D)                                          CFT050
060800200604     D TranInSeco    E DS                  EXTNAME(SDCUSEPD)                                  CFT050
060900200604
061000200604     D RUNDAT          DS
061100200604     D  @MBIN                 13     13
061200200604     D ZMUSER          DS
061300200604     D  DBRN                  11     13
061400200604     D  BANK                  17     17
061500200604                                                                                              CSD079
061600200604     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSD079
061700200604     D BGN4STC       E                     EXTFLD(BGN4ST)                                     CSD079
061800200604      ** External DS for MIDAS modules details                                                CSD079
061900200604                                                                                              CSD021
062000200604      ** Data Structure for SAR Details                                                       CSD021
062100200604     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD021
062200200604                                                                                              CSD012
062300200604      ** External DS for CRS Details                                                          CGL157
062400200604     D SDVCRSD       E DS                  EXTNAME(SDVCRSDPD)                                 CGL157
062500200604                                                                                              CGL157
062600200604      ** External DS for Country of Tax Codes                                                 CGL157
062700200604     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  CGL157
062800200604                                                                                              CGL157
062900200604     D***@KEY***         DS            20                                              CSD012 CGL029
063000200604     D @KEY            DS            26                                                       CGL029
063100200604     D @DDCUSN                 1      6                                                       CSD012
063200200604     D FUNCD           C                   CONST('CUSTOMER DETAILS')                          CSD012
063300200604                                                                                              CER059
063400200604     D CUAHArrDS       DS                                                                     CER059
063500200604     D***CUAHArr                      22A   DIM(50)                                  CER059 MD026780
063600200604     D  CUAHArr                      26A   DIM(50)                                          MD026780
063700200604                                                                                              CER059
063800200604     D CCTXArrDS       DS                                                                     CER059
063900200604     D  CCTXArr                      51A   DIM(50)                                            CER059
064000200604                                                                                              CER059
064100200604     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
064200200604     D                                     PREFIX(AH)                                         CER059
064300200604     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
064400200604     D                                     PREFIX(TX)                                         CER059
064500200604     D*TranInCUAH1     DS            22                                              CER059 MD026780
064600200604     D TranInCUAH1     DS            26                                                     MD026780
064700200604     D  AHAUTH                 1     10                                                       CER059
064800200604     D  AHLTYP                11     12                                                       CER059
064900200604     D  AHPRG1                13     14                                                       CER059
065000200604     D  AHPRG2                15     16                                                       CER059
065100200604     D  AHPRG3                17     18                                                       CER059
065200200604     D  AHPRG4                19     20                                                       CER059
065300200604     D  AHTYPA                21     22                                                       CER059
065400200604     D  AHCINT                23     23                                                     MD026780
065500200604     D  AHPCNT                24     26                                                     MD026780
065600200604     D TranInCCTX1   E DS                  EXTNAME (SDCCTXPD)                                 CER059
065700200604     D                                     PREFIX(TX:2)                                       CER059
065800200604                                                                                              CGL157
065900200604      ** Transaction Details in File Format                                                   CGL157
066000200604     D CrsdFilFmt    E DS                  EXTNAME(SDCRSHPD)                                  CGL157
066100200604     D PCrsdF          S            219A   DIM(30)                                            CGL177
066200200604                                                                                              CGL157
066300200604
066400200604      ** +--------------------------------------+
066500200604      ** ¦ Declared variables                   ¦
066600200604      ** ¦ ==================                   ¦
066700200604      ** +--------------------------------------+
066800200604                                                                                              CGL132
066900200604      ** Parameter variables for AOSVALR0 string                                              CGL132
067000200604     D SValK1          S             20                                                       CGL132
067100200604     D SVal1           S            200                                                       CGL132
067200200604     D SValK2          S             20                                                       CGL132
067300200604     D SVal2           S            200                                                       CGL132
067400200604     D SValK3          S             20                                                       CGL132
067500200604     D SVal3           S            200                                                       CGL132
067600200604     D SValK4          S             20                                                       CGL132
067700200604     D SVal4           S            200                                                       CGL132
067800200604     D SValK5          S             20                                                       CGL132
067900200604     D SVal5           S            200                                                       CGL132
068000200604     D SValK6          S             20                                                       CGL132
068100200604     D SVal6           S            200                                                       CGL132
068200200604     D SValK7          S             20                                                       CGL132
068300200604     D SVal7           S            200                                                       CGL132
068400200604     D SValK8          S             20                                                       CGL132
068500200604     D SVal8           S            200                                                       CGL132
068600200604     D SValK9          S             20                                                       CGL132
068700200604     D SVal9           S            200                                                       CGL132
068800200604     D SValK0          S             20                                                       CGL132
068900200604     D SVal10          S            200                                                       CGL132
069000200604
069100200604      ** For QUSRJOBI                                                                       BUG27866
069200200604     D WWRTRN          DS           187                                                     BUG27866
069300200604     D  WWJOB                  9     18                                                     BUG27866
069400200604     D  WJOBTP                61     61                                                     BUG27866
069500200604                                                                                            BUG27866
069600200604      ** For date conversion                                                                  CSD079
069700200604     D ##DOB           DS                                                                     CSD079
069800200604     D ##DAT1                  1      4                                                       CSD079
069900200604     D ##CC                    5      6                                                       CSD079
070000200604     D ##YY                    7      8                                                       CSD079
070100200604                                                                                              CSD079
070200200604     D CSD079          S              1A    inz('N')                                          CSD079
070300200604     D S01425          S              1A    inz('N')                                          CSD079
070400200604     D CSD008          S              1A    inz('N')                                          CSD079
070500200604     D CDL002          S              1A    inz('N')                                          CSD079
070600200604     D CDL006          S              1A    inz('N')                                          CSD079
070700200604     D CGL018          S              1A    inz('N')                                          CSD079
070800200604     D ULX004          S              1A    inz('N')                                          CSD079
070900200604     D ULX609          S              1A    inz('N')                                          CSD079
071000200604     D ULX043          S              1A    inz('N')                                          CSD079
071100200604     D CGL157          S              1A    INZ('N')                                          CGL157
071200200604                                                                                              CSD079
071300200604     D PMODE           S              1                                                       CSD079
071400200604     D CDL018          S              1                                                       CSD079
071500200604                                                                                              CSD079
071600200604     D CDL025          S              1A    inz('N')                                       AR1086546
071700200604                                                                                           AR1086546
071800200604     D X               S              2S 0                                                    CGL157
071900200604     D WCNCD           S              2A                                                      CGL157
072000200604     D WCOLC           S              2A                                                      CGL157
072100200604     D @PCTRT          S              2A                                                      CGL157
072200200604     D @PCTRR          S              2A                                                      CGL157
072300200604     D @WCDS1          DS           200
072400200604     D   WDS1000               1    200
072500200604     D   WDS1001               1      1
072600200604     D   WDS1002               2      2
072700200604     D   WDS1003               3      3
072800200604     D   WDS1004               4      4
072900200604     D   WDS1005               5      5
073000200604     D   WDS1006               6      6
073100200604     D   WDS1007               7      7
073200200604     D   WDS1008               8      8
073300200604     D   WDS1009               9      9
073400200604     D   WDS1010              10     10
073500200604     D   WDS1011              11     11
073600200604     D   WDS1012              12     12
073700200604     D   WDS1013              13     13
073800200604     D   WDS1014              14     14
073900200604     D   WDS1015              15     15
074000200604     D   WDS1016              16     16
074100200604     D   WDS1017              17     17
074200200604     D   WDS1018              18     18
074300200604     D   WDS1019              19     19
074400200604     D   WDS1020              20     20
074500200604     D   WDS1021              21     21
074600200604     D   WDS1022              22     22
074700200604     D   WDS1023              23     23
074800200604     D   WDS1024              24     24
074900200604     D   WDS1025              25     25
075000200604     D   WDS1026              26     26
075100200604     D   WDS1027              27     27
075200200604     D   WDS1028              28     28
075300200604     D   WDS1029              29     29
075400200604     D   WDS1030              30     30
075500200604     D   WDS1031              31     31
075600200604     D   WDS1032              32     32
075700200604     D   WDS1033              33     33
075800200604     D   WDS1034              34     34
075900200604     D   WDS1035              35     35
076000200604     D   WDS1036              36     36
076100200604     D   WDS1037              37     37
076200200604     D   WDS1038              38     38
076300200604     D   WDS1039              39     39
076400200604     D   WDS1040              40     40
076500200604     D   WDS1041              41     41
076600200604     D   WDS1042              42     42
076700200604     D   WDS1043              43     43
076800200604     D   WDS1044              44     44
076900200604     D   WDS1045              45     45
077000200604     D   WDS1046              46     46
077100200604     D   WDS1047              47     47
077200200604     D   WDS1048              48     48
077300200604     D   WDS1049              49     49
077400200604     D   WDS1050              50     50
077500200604
077600200604     D @WCDS2          DS           200
077700200604     D   WDS2000               1    200
077800200604     D   WDS2001               1      1
077900200604     D   WDS2002               2      2
078000200604     D   WDS2003               3      3
078100200604     D   WDS2004               4      4
078200200604     D   WDS2005               5      5
078300200604     D   WDS2006               6      6
078400200604     D   WDS2007               7      7
078500200604     D   WDS2008               8      8
078600200604     D   WDS2009               9      9
078700200604     D   WDS2010              10     10
078800200604     D   WDS2011              11     11
078900200604     D   WDS2012              12     12
079000200604     D   WDS2013              13     13
079100200604     D   WDS2014              14     14
079200200604     D   WDS2015              15     15
079300200604     D   WDS2016              16     16
079400200604     D   WDS2017              17     17
079500200604     D   WDS2018              18     18
079600200604     D   WDS2019              19     19
079700200604     D   WDS2020              20     20
079800200604     D   WDS2021              21     21
079900200604     D   WDS2022              22     22
080000200604     D   WDS2023              23     23
080100200604     D   WDS2024              24     24
080200200604     D   WDS2025              25     25
080300200604     D   WDS2026              26     26
080400200604     D   WDS2027              27     27
080500200604     D   WDS2028              28     28
080600200604     D   WDS2029              29     29
080700200604     D   WDS2030              30     30
080800200604     D   WDS2031              31     31
080900200604     D   WDS2032              32     32
081000200604     D   WDS2033              33     33
081100200604     D   WDS2034              34     34
081200200604     D   WDS2035              35     35
081300200604     D   WDS2036              36     36
081400200604     D   WDS2037              37     37
081500200604     D   WDS2038              38     38
081600200604     D   WDS2039              39     39
081700200604     D   WDS2040              40     40
081800200604     D   WDS2041              41     41
081900200604     D   WDS2042              42     42
082000200604     D   WDS2043              43     43
082100200604     D   WDS2044              44     44
082200200604     D   WDS2045              45     45
082300200604     D   WDS2046              46     46
082400200604     D   WDS2047              47     47
082500200604     D   WDS2048              48     48
082600200604     D   WDS2049              49     49
082700200604     D   WDS2050              50     50
082800200604
082900200604     D @WCDS3          DS           200
083000200604     D   WDS3000               1    200
083100200604     D   WDS3001               1      1
083200200604     D   WDS3002               2      2
083300200604     D   WDS3003               3      3
083400200604     D   WDS3004               4      4
083500200604     D   WDS3005               5      5
083600200604     D   WDS3006               6      6
083700200604     D   WDS3007               7      7
083800200604     D   WDS3008               8      8
083900200604     D   WDS3009               9      9
084000200604     D   WDS3010              10     10
084100200604     D   WDS3011              11     11
084200200604     D   WDS3012              12     12
084300200604     D   WDS3013              13     13
084400200604     D   WDS3014              14     14
084500200604     D   WDS3015              15     15
084600200604     D   WDS3016              16     16
084700200604     D   WDS3017              17     17
084800200604     D   WDS3018              18     18
084900200604     D   WDS3019              19     19
085000200604     D   WDS3020              20     20
085100200604     D   WDS3021              21     21
085200200604     D   WDS3022              22     22
085300200604     D   WDS3023              23     23
085400200604     D   WDS3024              24     24
085500200604     D   WDS3025              25     25
085600200604     D   WDS3026              26     26
085700200604     D   WDS3027              27     27
085800200604     D   WDS3028              28     28
085900200604     D   WDS3029              29     29
086000200604     D   WDS3030              30     30
086100200604     D   WDS3031              31     31
086200200604     D   WDS3032              32     32
086300200604     D   WDS3033              33     33
086400200604     D   WDS3034              34     34
086500200604     D   WDS3035              35     35
086600200604     D   WDS3036              36     36
086700200604     D   WDS3037              37     37
086800200604     D   WDS3038              38     38
086900200604     D   WDS3039              39     39
087000200604     D   WDS3040              40     40
087100200604     D   WDS3041              41     41
087200200604     D   WDS3042              42     42
087300200604     D   WDS3043              43     43
087400200604     D   WDS3044              44     44
087500200604     D   WDS3045              45     45
087600200604     D   WDS3046              46     46
087700200604     D   WDS3047              47     47
087800200604     D   WDS3048              48     48
087900200604     D   WDS3049              49     49
088000200604     D   WDS3050              50     50
088100200604
088200200604     D @WCDS4          DS           200
088300200604     D   WDS4000               1    200
088400200604     D   WDS4001               1      1
088500200604     D   WDS4002               2      2
088600200604     D   WDS4003               3      3
088700200604     D   WDS4004               4      4
088800200604     D   WDS4005               5      5
088900200604     D   WDS4006               6      6
089000200604     D   WDS4007               7      7
089100200604     D   WDS4008               8      8
089200200604     D   WDS4009               9      9
089300200604     D   WDS4010              10     10
089400200604     D   WDS4011              11     11
089500200604     D   WDS4012              12     12
089600200604     D   WDS4013              13     13
089700200604     D   WDS4014              14     14
089800200604     D   WDS4015              15     15
089900200604     D   WDS4016              16     16
090000200604     D   WDS4017              17     17
090100200604     D   WDS4018              18     18
090200200604     D   WDS4019              19     19
090300200604     D   WDS4020              20     20
090400200604     D   WDS4021              21     21
090500200604     D   WDS4022              22     22
090600200604     D   WDS4023              23     23
090700200604     D   WDS4024              24     24
090800200604     D   WDS4025              25     25
090900200604     D   WDS4026              26     26
091000200604     D   WDS4027              27     27
091100200604     D   WDS4028              28     28
091200200604     D   WDS4029              29     29
091300200604     D   WDS4030              30     30
091400200604     D   WDS4031              31     31
091500200604     D   WDS4032              32     32
091600200604     D   WDS4033              33     33
091700200604     D   WDS4034              34     34
091800200604     D   WDS4035              35     35
091900200604     D   WDS4036              36     36
092000200604     D   WDS4037              37     37
092100200604     D   WDS4038              38     38
092200200604     D   WDS4039              39     39
092300200604     D   WDS4040              40     40
092400200604     D   WDS4041              41     41
092500200604     D   WDS4042              42     42
092600200604     D   WDS4043              43     43
092700200604     D   WDS4044              44     44
092800200604     D   WDS4045              45     45
092900200604     D   WDS4046              46     46
093000200604     D   WDS4047              47     47
093100200604     D   WDS4048              48     48
093200200604     D   WDS4049              49     49
093300200604     D   WDS4050              50     50
093400200604
093500200604     D @WCDS5          DS           200
093600200604     D   WDS5000               1    200
093700200604     D   WDS5001               1      1
093800200604     D   WDS5002               2      2
093900200604     D   WDS5003               3      3
094000200604     D   WDS5004               4      4
094100200604     D   WDS5005               5      5
094200200604     D   WDS5006               6      6
094300200604     D   WDS5007               7      7
094400200604     D   WDS5008               8      8
094500200604     D   WDS5009               9      9
094600200604     D   WDS5010              10     10
094700200604     D   WDS5011              11     11
094800200604     D   WDS5012              12     12
094900200604     D   WDS5013              13     13
095000200604     D   WDS5014              14     14
095100200604     D   WDS5015              15     15
095200200604     D   WDS5016              16     16
095300200604     D   WDS5017              17     17
095400200604     D   WDS5018              18     18
095500200604     D   WDS5019              19     19
095600200604     D   WDS5020              20     20
095700200604     D   WDS5021              21     21
095800200604     D   WDS5022              22     22
095900200604     D   WDS5023              23     23
096000200604     D   WDS5024              24     24
096100200604     D   WDS5025              25     25
096200200604     D   WDS5026              26     26
096300200604     D   WDS5027              27     27
096400200604     D   WDS5028              28     28
096500200604     D   WDS5029              29     29
096600200604     D   WDS5030              30     30
096700200604     D   WDS5031              31     31
096800200604     D   WDS5032              32     32
096900200604     D   WDS5033              33     33
097000200604     D   WDS5034              34     34
097100200604     D   WDS5035              35     35
097200200604     D   WDS5036              36     36
097300200604     D   WDS5037              37     37
097400200604     D   WDS5038              38     38
097500200604     D   WDS5039              39     39
097600200604     D   WDS5040              40     40
097700200604     D   WDS5041              41     41
097800200604     D   WDS5042              42     42
097900200604     D   WDS5043              43     43
098000200604     D   WDS5044              44     44
098100200604     D   WDS5045              45     45
098200200604     D   WDS5046              46     46
098300200604     D   WDS5047              47     47
098400200604     D   WDS5048              48     48
098500200604     D   WDS5049              49     49
098600200604     D   WDS5050              50     50
098700200604
098800200604      ** Index for arrays of of error message ids etc
098900200604     D Ix              S              3P 0
099000200604     D Idy             S              3P 0                                                    CER059
099100200604                                                                                              CSD028
099200200604     D CSD028          S              1                                                       CSD028
099300200604     D P@Rtcd          S              7                                                       CSD028
099400200604     D P@Optn          S              7                                                       CSD028
099500200604     D P@Sard          S              6                                                       CSD028
099600200604                                                                                              CSD028
099700200604      ** Swift installed flag                                                                 CSW207
099800200604     D CSW207          S              1A                                                      CSW207
099900200604     D KFCusn          S              6A                                                    BUG23518
100000200604     D KFCTax          S              2A                                                    BUG23518
100100200604     D PCusn           S             10A                                                    BUG23518
100200200604     D PKySt           S              7A                                                    BUG23518
100300200604     D CER048          S              1A                                                    BUG23518
100400200604     D CER034          S              1A                                                      CER059
100500200604     D CER069          S              1A                                                      CER069
100600200604     D CGL032          S              1A                                                      CER059
100700200604     D WIx             S              3P 0                                                  BUG23518
100800200604      *                                                                                     BUG23518
100900200604     D/COPY WNCPYSRC,SDCUSDID01
101000200604                                                                                              CSD031
101100200604     D*PAccMde**       S              1A                                             CSD031 BUG13525
101200200604     D*PUpdYN***       S              1A                                             CSD031 BUG13525
101300200604     D PRtCd           S              7A                                                      CSD031
101400200604     D POptn           S              7A                                                      CSD031
101500200604     D PSARD           S              6A                                                      CSD031
101600200604     D*CSD037***       S              1A   INZ('N')                                  CSD031 BUG13525
101700200604     D*WCustLR**       S              1A                                             CSD031 BUG13525
101800200604     D*WTyLC****       S              1A                                             CSD031 BUG13525
101900200604
102000200604      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                   CSD027
102100200604     D PRetCode        S              7A                                                      CSD027
102200200604     D PSysValK1       S             20A                                                      CSD027
102300200604     D PSysVal1        S            200A                                                      CSD027
102400200604     D PSysValK2       S             20A                                                      CSD027
102500200604     D PSysVal2        S            200A                                                      CSD027
102600200604     D PSysValK3       S             20A                                                      CSD027
102700200604     D PSysVal3        S            200A                                                      CSD027
102800200604     D PSysValK4       S             20A                                                      CSD027
102900200604     D PSysVal4        S            200A                                                      CSD027
103000200604     D PSysValK5       S             20A                                                      CSD027
103100200604     D PSysVal5        S            200A                                                      CSD027
103200200604     D PSysValK6       S             20A                                                      CSD027
103300200604     D PSysVal6        S            200A                                                      CSD027
103400200604     D PSysValK7       S             20A                                                      CSD027
103500200604     D PSysVal7        S            200A                                                      CSD027
103600200604     D PSysValK8       S             20A                                                      CSD027
103700200604     D PSysVal8        S            200A                                                      CSD027
103800200604     D PSysValK9       S             20A                                                      CSD027
103900200604     D PSysVal9        S            200A                                                      CSD027
104000200604     D PSysValK10      S             20A                                                      CSD027
104100200604     D PSysVal10       S            200A                                                      CSD027
104200200604      *                                                                                       CSD027
104300200604      * For holding the system values                                                         CSD027
104400200604     DWCusAlphaAllow   S            200A                                                      CSD027
104500200604     DWCusAlphChksum   S            200A                                                      CSD027
104600200604     DWCusAlphaSupNum  S            200A                                                      CSD027
104700200604      *                                                                                       CSD027
104800200604      ** Parameters for calling SDCUSTISO (Validate Customer Number)                          CSD027
104900200604     D PCust           S              6A                                                      CSD027
105000200604     D PValid          S              6A                                                      CSD027
105100200604     D PCheckDigit     S              1A                                                      CSD027
105200200604     D W_SkipFlag      S              1A                                                    BUG11886
105300200604
105400200604      ** Work Variables for CSD079                                                            CSD079
105500200604     D ModeofOp        S              6A                                                      CSD079
105600200604     D RespMode        S              1A                                                      CSD079
105700200604     D From_Cust       S              1A                                                      CSD079
105800200604     D WUPMSC          S              1A                                                      CSD079
105900200604     D W0RTN           S              7A                                                      CSD079
106000200604                                                                                              CSD079
106100200604     D WWLENG          S              4B 0                                                  BUG27866
106200200604     D WWINPT          S              8A                                                    BUG27866
106300200604     D WWQUAL          S             26A                                                    BUG27866
106400200604     D WWINTR          S             16A                                                    BUG27866
106500200604                                                                                            BUG27866
106600200604      ** Constant paramater for AOSVALR0                                                      258838
106700200604     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      258838
106800200604     D CurSysVal       DS           200                                                       258838
106900200604     D CurVal                  1      1                                                       258838
107000200604                                                                                              CER059
107100200604     D ZDAYNO          S              5  0                                                    CER059
107200200604     D ZDATE           S              6  0                                                    CER059
107300200604     D ZADATE          S              7A                                                      CER059
107400200604                                                                                              CER059
107500200604     D BChar           DS                                                                   MD000091
107600200604     D   BLen                  1      2B 0                                                  MD000091
107700200604     D   LenStr                1      2                                                     MD000091
107800200604     D CSW213          S              1A                                                      CSW213
107900200604     D***CSW204*         S              1                                            CFT050 MD022463
108000200604     D CSW024          S              1                                                     MD022463
108100200604     D SvDDLEIC        S                   LIKE(DDLEIC)                                       CFT050
108200200604     D SvDDCLSY        S                   LIKE(DDCLSY)                                       CFT050
108300200604     D SvDDCLID        S                   LIKE(DDCLID)                                       CFT050
108400200604     D SvDDBDRK        S                   LIKE(DDBDRK)                                       CFT050
108500200604     D SvDDBDRK2       S                   LIKE(DDBDRK)                                       CFT050
108600200604     D SVCNCZ          S              2A                                                      CFT050
108700200604     D SVCOLC          S              2A                                                      CFT050
108800200604     D SVCLSY          S              2A                                                      CFT050
108900200604     D PBICD           S              4A                                                      CFT050
109000200604     D CFT050          S              1A                                                    MD022463
109100200604     D CGL132          S              1A                                                      CGL132
109200200604     D CGL133          S              1A                                                      CGL132
109300200604     D DDDATE          S              5P 0                                                    CGL132
109400200604     D DDSEQN          S              3S 0                                                    CGL132
109500200604     D @CLAC           S              5A                                                      CGL132
109600200604     D PCustNo         S              6A                                                      CGL132
109700200604     D DDCRTT          S              2A                                                      CGL132
109800200604     D WWTINO          S             25A                                                      CGL132
109900200604     D WCTAX           S              2A                                                      CGL132
110000200604     D WWCLAC          S              5A                                                      CGL132
110100200604     D CTI006          S              1A                                                    MD030956
110200200604      ** +--------------------------------------+
110300200604      ** ¦ End of D-specs                       ¦
110400200604      ** ¦ ==============                       ¦
110500200604      ** +--------------------------------------+
110600200604      *****************************************************************
110700200604      /EJECT
110800200604     C**************************************************************
110900200604      *
111000200604      * INITIALIZATION
111100200604      *
111200200604      ** Retrive ZMUSER if not job update                                                   BUG11935
111300200604     C**********         If        PAccMde <> 'J' and CSD037 = 'Y'                 BUG11935 BUG13525
111400200604      *                                                                                      BUG8550
111500200604      **  GET ZMUSER to access default branch.                                               BUG8550
111600200604      *                                                                                      BUG8550
111700200604     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
111800200604     C                   IN        ZMUSER                                                    BUG8550
111900200604      *                                                                                      BUG8550
112000200604     C**********         EndIf                                                     BUG11935 BUG13525
112100200604     C                   EXSR      INIT
112200200604      *
112300200604      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
112400200604      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
112500200604      *
112600200604     C     ModeofOp      IFEQ      '*FRONT'
112700200604     C                   EXSR      VFRNT
112800200604      *
112900200604      **  Carry out no further validation if errors have occurred.
113000200604      *
113100200604     C     OKACTN        IFEQ      'N'
113200200604     C     OKCUST        OREQ      'N'
113300200604     C                   RETURN
113400200604     C                   END
113500200604     C                   END
113600200604      *
113700200604      * VALIDATE ACTION CODE & CUSTOMER NUMBER
113800200604      *
113900200604     C                   EXSR      VAL
114000200604      *
114100200604      **  Carry out no further validation if errors have occurred.
114200200604      *
114300200604     C     OKACTN        IFEQ      'N'
114400200604     C     OKCUST        OREQ      'N'
114500200604     C                   RETURN
114600200604     C                   END
114700200604      *
114800200604      *  *-----------------------------------------------*
114900200604      *  * Access Security Checking                      *
115000200604      *  *-----------------------------------------------*
115100200604      *
115200200604     C     RespMode      IFEQ      'S'
115300200604     C                   EVAL      ZACTN=DDACTN
115400200604      *
115500200604      ** If single branching
115600200604      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
115700200604      *
115800200604     C     BJSBRC        IFNE      *BLANK
115900200604     C     RESPMODE      ANDEQ     'S'
116000200604     C                   EXSR      ACSSES
116100200604     C                   END
116200200604      *
116300200604      ** If multibranching
116400200604      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
116500200604      *
116600200604     C     BJSBRC        IFEQ      *BLANK
116700200604     C     DDACTN        ANDNE     'I'
116800200604     C     RESPMODE      ANDEQ     'S'
116900200604     C                   EXSR      ACSSEM
117000200604     C                   END
117100200604     C                   END
117200200604      *
117300200604      **  Carry out no further validation if errors have occurred.
117400200604      *
117500200604     C     OKACTN        IFEQ      'N'
117600200604     C                   RETURN
117700200604     C                   END
117800200604                                                                                              CSD031
117900200604      ** Get customer acceptance details if required.                                         CSD031
118000200604                                                                                              CSD031
118100200604     C**********         IF        PAccMde = 'A'                                     CSD031 BUG13525
118200200604     C**********         EXSR      SRGetACst                                         CSD031 BUG13525
118300200604     C**********         ENDIF                                                       CSD031 BUG13525
118400200604      *
118500200604      *  *--------------------------------*
118600200604      *  * Validation for Action Code 'I' *
118700200604      *  *--------------------------------*
118800200604      *  (only if the Customer number is not to be generated.)
118900200604      *
119000200604     C     DDACTN        IFEQ      'I'
119100200604     C     DDCUSN        ANDNE     *BLANKS
119200200604     C                   EXSR      VALACI
119300200604     C                   END
119400200604      *
119500200604      *  *--------------------------------*
119600200604      *  * Validation for Action Code 'E' *
119700200604      *  *--------------------------------*
119800200604      *
119900200604     C     DDACTN        IFEQ      'E'
120000200604     C                   EXSR      RTVCUS
120100200604     C                   END
120200200604      *
120300200604      *  *--------------------------------*
120400200604      *  * Validation for Action Code 'A' *
120500200604      *  *--------------------------------*
120600200604      *
120700200604     C     DDACTN        IFEQ      'A'
120800200604     C                   EXSR      RTVCUS
120900200604     C                   END
121000200604      *
121100200604      *  *--------------------------------*
121200200604      *  * Validation for Action Code 'D' *
121300200604      *  *--------------------------------*
121400200604      *
121500200604     C     DDACTN        IFEQ      'D'
121600200604     C                   EXSR      RTVCUS
121700200604     C                   EXSR      VALACD
121800200604     C                   END
121900200604      *                                                                                       CSD007
122000200604      *  *--------------------------------*                                                   CSD007
122100200604      *  * Validation for Action Code 'C' *                                                   CSD007
122200200604      *  *--------------------------------*                                                   CSD007
122300200604      *                                                                                       CSD007
122400200604     C     DDACTN        IFEQ      'C'                                                        CSD007
122500200604     C                   EXSR      RTVCUS                                                     CSD007
122600200604     C                   EXSR      VALACC                                                     CSD007
122700200604     C                   ENDIF                                                                CSD007
122800200604      *                                                                                       CSD007
122900200604      *  *--------------------------------*                                                   CSD007
123000200604      *  * Validation for Action Code 'R' *                                                   CSD007
123100200604      *  *--------------------------------*                                                   CSD007
123200200604      *                                                                                       CSD007
123300200604     C     DDACTN        IFEQ      'R'                                                        CSD007
123400200604     C                   EXSR      RTVCUS                                                     CSD007
123500200604     C                   EXSR      VALACR                                                     CSD007
123600200604     C                   ENDIF                                                                CSD007
123700200604      *
123800200604      **  Carry out no further validation if errors occurred.
123900200604      *
124000200604     C     OKACTN        IFEQ      'N'
124100200604     C     OKCUST        OREQ      'N'
124200200604     C                   RETURN
124300200604     C                   END
124400200604
124500200604     C     S01383        IFEQ      'Y'
124600200604      *
124700200604      * SET UP SDCBRTPD DETAILS IF BASE RATE TAX IS ON
124800200604      *
124900200604     C                   EXSR      RTVBRT
125000200604
125100200604     C                   ENDIF
125200200604      *
125300200604     C     BGN4ST        IFEQ      'Y'
125400200604      *
125500200604      * SET UP SDPBDSPD DETAILS IF PRIVATE BANKING IS ON
125600200604      *
125700200604     C                   EXSR      RTVPRV
125800200604
125900200604     C                   ENDIF
126000200604      *                                                                                      BUG3362
126100200604      ** Retrieve Details for TI if CSD012 is ON                                             BUG3362
126200200604      *                                                                                      BUG3362
126300200604     C     BBTICS        IFEQ      'Y'                                                       BUG3362
126400200604     C     BGN3ST        ANDEQ     'Y'                                                       BG12033
126500200604     C     BBTICS        OREQ      'Y'                                                      MD030956
126600200604     C     CTI006        ANDEQ     'Y'                                                      MD030956
126700200604      *                                                                                      BUG3362
126800200604     C                   EXSR      RTVTID                                                    BUG3362
126900200604     C                   ENDIF                                                               BUG3362
127000200604                                                                                              CGP001
127100200604     C     CGP001        IFEQ      'Y'                                                        CGP001
127200200604                                                                                              CGP001
127300200604      ** Set up GPCUSTXPD details if Global Data Layout is on                                 CGP001
127400200604                                                                                              CGP001
127500200604     C                   EXSR      RTVGLB                                                     CGP001
127600200604                                                                                              CGP001
127700200604     C                   ENDIF                                                                CGP001
127800200604                                                                                              CGP001
127900200604     C                   IF         CSD079 = 'Y'                                              CSD079
128000200604                                                                                              CSD079
128100200604      ** Retrieve Marketing Information                                                       CSD079
128200200604                                                                                              CSD079
128300200604     C                   EXSR      RtvCumi                                                    CSD079
128400200604                                                                                              CSD079
128500200604      ** Retrieve Additional Customer Details                                                 CSD079
128600200604                                                                                              CSD079
128700200604     C     S01425        IFEQ      'Y'                                                        CSD079
128800200604     C                   EXSR      RtvCuad                                                    CSD079
128900200604     C                   ENDIF                                                                CSD079
129000200604                                                                                              CSD079
129100200604      ** Retrieve Service Fees                                                                CSD079
129200200604                                                                                              CSD079
129300200604     C     CSD008        IFEQ      'Y'                                                        CSD079
129400200604     C                   EXSR      RtvSfee                                                    CSD079
129500200604     C                   ENDIF                                                                CSD079
129600200604                                                                                              CSD079
129700200604      ** Retrieve Cheques and Card Details                                                    CSD079
129800200604                                                                                              CSD079
129900200604     C     BGNXST        IFEQ      'Y'                                                        CSD079
130000200604     C                   EXSR      RtvChec                                                    CSD079
130100200604     C                   ENDIF                                                                CSD079
130200200604                                                                                              CSD079
130300200604      ** Retrieve Safe Details                                                                CSD079
130400200604                                                                                              CSD079
130500200604     C                   EXSR      RtvCusf                                                    CSD079
130600200604                                                                                              CSD079
130700200604      ** Retrieve Risk weighted assets                                                        CSD079
130800200604                                                                                              CSD079
130900200604     C     CGL018        IFEQ      'Y'                                                        CSD079
131000200604     C                   EXSR      RtvRwan                                                    CSD079
131100200604     C                   ENDIF                                                                CSD079
131200200604                                                                                              CER059
131300200604      ** Retrieve Customer Authority Holder                                                   CER059
131400200604                                                                                              CER059
131500200604     C**********         IF        CER034 = 'Y'                                      CER059 MD026253
131600200604     C**********                   AND DDACTN <> 'I'                                 CER059 MD026253
131700200604     C                   IF        DDACTN <> 'I'                                            MD026253
131800200604     C                             AND DDACTN <> 'A'                                          CER059
131900200604     C                   EXSR      RtvCUAH                                                    CER059
132000200604     C                   ENDIF                                                                CER059
132100200604                                                                                              CER059
132200200604      ** Retrieve Customer by Country of Tax                                                  CER059
132300200604                                                                                              CER059
132400200604     C                   IF        CGL032 = 'Y'                                               CER059
132500200604     C                             AND DDACTN <> 'I'                                          CER059
132600200604     C                             AND DDACTN <> 'A'                                          CER059
132700200604     C                   EXSR      RtvCCTX                                                    CER059
132800200604     C                   ENDIF                                                                CER059
132900200604                                                                                              CSD079
133000200604      ** Retrieve Futures and Option                                                          CSD079
133100200604                                                                                              CSD079
133200200604     C     BGFUOP        IFEQ      'Y'                                                        CSD079
133300200604     C                   EXSR      RtvCufo                                                    CSD079
133400200604     C                   ENDIF                                                                CSD079
133500200604                                                                                              CSD079
133600200604      ** Retrieve Future and Option European Reporting                                        CSD079
133700200604                                                                                              CSD079
133800200604     C     ULX004        IFEQ      'Y'                                                        CSD079
133900200604     C                   EXSR      RtvCufn                                                    CSD079
134000200604     C                   ENDIF                                                                CSD079
134100200604                                                                                              CSD079
134200200604      ** Retrieve Portfolio Management                                                        CSD079
134300200604                                                                                              CSD079
134400200604     C     WUPMSC        IFEQ      'Y'                                                        CSD079
134500200604     C                   EXSR      RtvCupm                                                    CSD079
134600200604     C                   ENDIF                                                                CSD079
134700200604                                                                                              CSD079
134800200604      ** Retrieve Lux(European Reporting)                                                     CSD079
134900200604                                                                                              CSD079
135000200604     C     ULX609        IFEQ      'Y'                                                        CSD079
135100200604     C     BGLRIN        ANDEQ     'Y'                                                        CSD079
135200200604     C                   EXSR      RtvCulx2                                                   CSD079
135300200604     C                   ENDIF                                                                CSD079
135400200604                                                                                              CSD079
135500200604      ** Retrieve Lux(IBLC - Extended Information)                                            CSD079
135600200604                                                                                              CSD079
135700200604     C     ULX043        IFEQ      'Y'                                                        CSD079
135800200604     C     BGNWST        ANDEQ     'Y'                                                        CSD079
135900200604     C                   EXSR      RtvCulx1                                                   CSD079
136000200604     C                   ENDIF                                                                CSD079
136100200604      *                                                                                       CSD079
136200200604     C                   ENDIF                                                                CSD079
136300200604                                                                                              CGL132
136400200604     C                   IF        CGL132 = 'Y'                                               CGL132
136500200604     C                   EXSR      RTVFTC                                                     CGL132
136600200604     C                   ENDIF                                                                CGL132
136700200604                                                                                              CGL157
136800200604     C                   IF        CGL157 = 'Y'                                               CGL157
136900200604     C                   EXSR      RTVCRS                                                     CGL157
137000200604     C                   ENDIF                                                                CGL157
137100200604                                                                                           AR1086546
137200200604      ** Retrieve Currency/Time of Netting Details                                         AR1086546
137300200604                                                                                           AR1086546
137400200604     C     CDL025        IFEQ      'Y'                                                     AR1086546
137500200604     C                   EXSR      RTVCTNM                                                 AR1086546
137600200604     C                   ENDIF                                                             AR1086546
137700200604                                                                                           AR1086546
137800200604     C**********         IF        PAccMde = 'A'                                     CSD031 BUG13525
137900200604     C**********         EXSR      SROvrFlds                                         CSD031 BUG13525
138000200604     C**********         ENDIF                                                       CSD031 BUG13525
138100200604     C/COPY WNCPYSRC,SDCUSDIC07
138200200604      *
138300200604      * Return
138400200604      *
138500200604     C                   RETURN
138600200604      *****************************************************************
138700200604      /EJECT
138800200604      *****************************************************************
138900200604      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
139000200604      *****************************************************************
139100200604     C     ACSSES        BEGSR
139200200604      *
139300200604      **  Check user's authority for the action.
139400200604      *
139500200604     C                   CALL      'ZVACTU'
139600200604     C                   PARM                    ZACTN             1
139700200604     C                   PARM                    ERR               1 0
139800200604      *
139900200604      **  If action invalid for user
140000200604      *
140100200604     C     ERR           IFEQ      1
140200200604     C                   MOVEL     'N'           OKACTN
140300200604     C                   ADD       1             Ix
140400200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
140500200604     C                   SELECT
140600200604     C                   WHEN      DDACTN='E'
140700200604     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
140800200604     C                   WHEN      DDACTN='I'
140900200604     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
141000200604     C                   WHEN      DDACTN='A'
141100200604     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
141200200604     C                   WHEN      DDACTN='D'
141300200604     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
141400200604     C                   WHEN      DDACTN='C'                                                 CSD007
141500200604     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                                 CSD007
141600200604     C                   WHEN      DDACTN='R'                                                 CSD007
141700200604     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                                 CSD007
141800200604     C**********         WHEN      DDACTN='X'                                        CSD031 BUG13525
141900200604     C**********         MOVEL     'CSF9008'     MsgIdArr(Ix)                        CSD031 BUG13525
142000200604     C/COPY WNCPYSRC,SDH00481
142100200604     C                   ENDSL
142200200604     C                   ENDIF
142300200604      *
142400200604     C                   ENDSR
142500200604      *****************************************************************
142600200604     C/EJECT
142700200604      *****************************************************************
142800200604      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
142900200604      *****************************************************************
143000200604     C     ACSSEM        BEGSR
143100200604     C                   Eval      W_SkipFlag = 'N'                                         BUG11886
143200200604      *                                                                                      BUG2653
143300200604      ** Access customer's file to check on the branch code of the customer.                 BUG2653
143400200604      ** Use this to check the valid user branch/combination instead of default              BUG2653
143500200604      ** branch DBRN.                                                                        BUG2653
143600200604     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
143700200604     C     DDCUSN        CHAIN     SDCDSHL1                           44                      CSD028
143800200604     C                   ELSE                                                                 CSD028
143900200604     C     DDCUSN        CHAIN     SDCUSTLR                           44                     BUG2653
144000200604     C                   ENDIF                                                                CSD028
144100200604     C                   MOVE      BBBRCD        ZBR                                         BUG2653
144200200604                                                                                              CSD031
144300200604     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
144400200604     C**********                   AND PaccMde = 'A'                                 CSD031 BUG13525
144500200604     C*****DDCUSN        CHAIN     SDACSTL1                           44             CSD031 BUG13525
144600200604     C**********         EVAL      ZBR = BBBRCD                                      CSD031 BUG13525
144700200604      *                                                                                     BUG11886
144800200604      ** Skip Security Checking if Branch code is blanks                                    BUG11886
144900200604      *                                                                                     BUG11886
145000200604     C                   If        ZBR =  *Blanks                                           BUG11886
145100200604     C                   Eval      W_SkipFlag = 'Y'                                         BUG11886
145200200604     C                   EndIf                                                              BUG11886
145300200604     C**********         ENDIF                                                       CSD031 BUG13525
145400200604      *
145500200604      **  Check user's authority for the action & Booking Branch.
145600200604      *
145700200604     C                   CALLB     'AOSVALR0'                                                 258838
145800200604     C                   PARM                    @RTCD             7                          258838
145900200604     C                   PARM      BRCUSR        @OP01            20                          258838
146000200604     C     CurSysVal     PARM                    @VL01           200                          258838
146100200604     C                   PARM                    @OP02            20                          258838
146200200604     C                   PARM                    @VL02           200                          258838
146300200604     C                   PARM                    @OP03            20                          258838
146400200604     C                   PARM                    @VL03           200                          258838
146500200604     C                   PARM                    @OP04            20                          258838
146600200604     C                   PARM                    @VL04           200                          258838
146700200604     C                   PARM                    @OP05            20                          258838
146800200604     C                   PARM                    @VL05           200                          258838
146900200604     C                   PARM                    @OP06            20                          258838
147000200604     C                   PARM                    @VL06           200                          258838
147100200604     C                   PARM                    @OP07            20                          258838
147200200604     C                   PARM                    @VL07           200                          258838
147300200604     C                   PARM                    @OP08            20                          258838
147400200604     C                   PARM                    @VL08           200                          258838
147500200604     C                   PARM                    @OP09            20                          258838
147600200604     C                   PARM                    @VL09           200                          258838
147700200604     C                   PARM                    @OP10            20                          258838
147800200604     C                   PARM                    @VL10           200                          258838
147900200604      *                                                                                       258838
148000200604     C**********         If        W_SkipFlag = 'Y'                                BUG11886 BUG11917
148100200604     C                   If        W_SkipFlag = 'N'                                         BUG11917
148200200604     C                   If        CurVal = 'N'                                               258838
148300200604     C**********         CALL      'ZVACTBU'                                         258838 MD022997
148400200604     C**********         PARM                    ZACTN             1                 258838 MD022997
148500200604     C**********         PARM      DBRN          ZBR               3                 258838 MD022997
148600200604     C**********         PARM                    ERR               1 0               258838 MD022997
148700200604     C                   CALL      'ZVACTBU01'                                              MD022997
148800200604     C                   PARM                    ZACTN                                      MD022997
148900200604     C                   PARM                    ERR                                        MD022997
149000200604     C                   Else                                                                 258838
149100200604     C                   CALL      'ZVACTBU'
149200200604     C                   PARM                    ZACTN             1
149300200604     C**********         PARM      DBRN          ZBR               3                         BUG2653
149400200604     C                   PARM                    ZBR               3                         BUG2653
149500200604     C                   PARM                    ERR               1 0
149600200604     C**********         EndIf                                                     BUG11886 BUG11917
149700200604     C                   Endif                                                                258838
149800200604      *
149900200604      **   If action invalid for user
150000200604      *
150100200604     C     ERR           IFEQ      1
150200200604     C                   MOVEL     'N'           OKACTN
150300200604     C                   ADD       1             Ix
150400200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
150500200604     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
150600200604     C                   ELSE
150700200604     C     ERR           IFEQ      2
150800200604     C                   MOVEL     'N'           OKACTN
150900200604     C                   ADD       1             Ix
151000200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
151100200604     C                   SELECT
151200200604     C                   WHEN      DDACTN='E'
151300200604     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
151400200604     C                   WHEN      DDACTN='I'
151500200604     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
151600200604     C                   WHEN      DDACTN='A'
151700200604     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
151800200604     C                   WHEN      DDACTN='D'
151900200604     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
152000200604     C                   WHEN      DDACTN='C'                                                 CSD007
152100200604     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                                 CSD007
152200200604     C                   WHEN      DDACTN='R'                                                 CSD007
152300200604     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                                 CSD007
152400200604     C**********         WHEN      DDACTN='X'                                        CSD031 BUG13525
152500200604     C**********         MOVEL     'CSF9008'     MsgIdArr(Ix)                        CSD031 BUG13525
152600200604     C/COPY WNCPYSRC,SDH00482
152700200604     C                   ENDSL
152800200604     C                   END
152900200604     C                   END
153000200604     C                   EndIf                                                              BUG11917
153100200604      *
153200200604     C                   ENDSR
153300200604      *****************************************************************
153400200604      /EJECT
153500200604      *****************************************************************
153600200604      * RTVCUS - RETRIEVE CUSTOMER IF ACTION CODE 'A', 'E' OR 'D'
153700200604      *****************************************************************
153800200604     C     RTVCUS        BEGSR
153900200604      *
154000200604      * Access Customer from the Customers file
154100200604      *
154200200604     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
154300200604     C     DDCUSN        CHAIN     SDCDSHL1                           44                      CSD028
154400200604     C                   ELSE                                                                 CSD028
154500200604     C     DDCUSN        CHAIN     SDCUSTLR                           44
154600200604     C                   ENDIF                                                                CSD028
154700200604      *
154800200604      * Customer details not found
154900200604      *
155000200604      ** Skip validation if the customer came from the acceptance file.                       CSD031
155100200604                                                                                              CSD031
155200200604     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
155300200604     C     *IN44         IFEQ      '1'
155400200604     C                   MOVEL     'N'           OKCUST
155500200604     C                   ADD       1             Ix
155600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
155700200604     C                   MOVEL     'USR0081'     MsgIdArr(Ix)
155800200604      * Customer must reference an active Customer
155900200604     C                   ELSE
156000200604                                                                                              CGL132
156100200604     C     DDCUSN        CHAIN     SDCUSTX1                                                   CGL132
156200200604                                                                                              CSW207
156300200604     C**********         IF        CSW207 = 'Y' OR BGN4ST = 'Y'                     CSW207A BUG15138
156400200604     C     DDCUSN        CHAIN     SDCSSWL1                                                   CSW207
156500200604     C**********         IF        DDACTN <> 'A'                                     CFT050 MD022395
156600200604     C**********         EVAL      DDLEIC = CSLEIC                                   CFT050 MD022395
156700200604     C**********         EVAL      DDCLSY = CSCLSY                                   CFT050 MD022395
156800200604     C**********         EVAL      DDCLID = CSCLID                                   CFT050 MD022395
156900200604     C**********         EVAL      DDBDRK = CSBDRK                                   CFT050 MD022395
157000200604     C**********         ENDIF                                                       CFT050 MD022395
157100200604     C**********         IF        CSBDRK <> *BLANKS                                 CFT050 MD022766
157200200604     C**********                   AND CSW213 = 'Y'                                  CFT050 MD022463
157300200604     C**********         EXSR      Pop_SW13                                          CFT050 MD022463
157400200604     C**********                   AND CFT050 = 'Y'                                MD022463 MD022766
157500200604     C                   EXSR      Pop_SW13Scrn                                             MD022463
157600200604     C**********         ENDIF                                                       CFT050 MD022766
157700200604     C**********         ENDIF                                                       CSW207 BUG15138
157800200604                                                                                              CSW207
157900200604     C     BBDTDL        IFNE      *ZERO
158000200604     C     DDACTN        ANDNE     'E'                                                        CSW024
158100200604     C                   MOVEL     'N'           OKCUST
158200200604     C                   ADD       1             Ix
158300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
158400200604     C                   IF        DDACTN = 'I'                                             MD025006
158500200604     C                   MOVEL     'USR0342'     MsgIdArr(Ix)
158600200604     C                   ELSEIF    DDACTN = 'A' OR DDACTN = 'D'                             MD025006
158700200604     C                   MOVEL     '5046257'     MsgIdArr(Ix)                               MD025006
158800200604     C                   ENDIF                                                              MD025006
158900200604     C                   ELSE                                                                 215524
159000200604     C     BBCLST        IFEQ      'Y'                                                        215524
159100200604     C     DDACTN        ANDEQ     'A'                                                        215524
159200200604     C                   MOVEL     'N'           OKCUST                                       215524
159300200604     C                   ADD       1             Ix                                           215524
159400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               215524
159500200604     C                   MOVEL     'USR9236'     MsgIdArr(Ix)                                 215524
159600200604     C                   END                                                                  215524
159700200604     C                   END
159800200604     C                   END
159900200604     C**********         ENDIF                                                       CSD031 BUG13525
160000200604
160100200604     C                   ENDSR
160200200604      *****************************************************************
160300200604      /EJECT
160400200604      *****************************************************************
160500200604      * RTVBRT - RETRIEVE CUSTOMER BASE RATE TAX DETAILS IF S01383 = 'Y'
160600200604      *****************************************************************
160700200604     C     RTVBRT        BEGSR
160800200604      *
160900200604      * Access Customer Base Rate Tax details from the BRT file
161000200604      *
161100200604     C                   MOVEL     DDCUSN        XCNUM
161200200604     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
161300200604     C     XCNUM         CHAIN     @BRTRF                             45                      CSD028
161400200604     C                   ELSE                                                                 CSD028
161500200604     C     XCNUM         CHAIN     SDCBRTLR                           45
161600200604     C                   ENDIF                                                                CSD028
161700200604      *
161800200604     C**  IF INSERT AND LIVE RECORD FOUND - ERROR
161900200604      *
162000200604      ** Skip validation if the customer came from the acceptance file.                       CSD031
162100200604                                                                                              CSD031
162200200604     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
162300200604     C     DDACTN        IFEQ      'I'
162400200604
162500200604     C     *IN45         IFEQ      '0'
162600200604     C     XRECI         ANDEQ     'D'
162700200604     C                   MOVEL     'N'           OKCUST
162800200604     C                   ADD       1             Ix
162900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
163000200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)
163100200604     C                   END
163200200604      *
163300200604     C**  IF DELETE, AMEND OR ENQUIRE
163400200604     C                   ELSE
163500200604     C*
163600200604     C**  IF LIVE RECORD NOT FOUND - ERROR
163700200604     C*
163800200604     C     *IN45         IFEQ      '1'
163900200604     C     XRECI         ORNE      'D'
164000200604     C     DDACTN        ANDNE     'E'                                                        241040
164100200604     C                   MOVEL     'N'           OKCUST
164200200604     C                   ADD       1             Ix
164300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
164400200604     C                   MOVEL     'USR3855'     MsgIdArr(Ix)
164500200604     C                   END
164600200604
164700200604     C                   ENDIF
164800200604     C**********         ENDIF                                                       CSD031 BUG13525
164900200604
165000200604     C                   ENDSR
165100200604      *****************************************************************                       CGL132
165200200604      /EJECT                                                                                  CGL132
165300200604      *****************************************************************                       CGL132
165400200604      * RTVFTC - Retrieve FATCA customer details if CGL132 = 'Y'                              CGL132
165500200604      *****************************************************************                       CGL132
165600200604                                                                                              CGL132
165700200604     C     RTVFTC        BEGSR                                                                CGL132
165800200604                                                                                              CGL132
165900200604      ** Access FATCA customer details                                                        CGL132
166000200604                                                                                              CGL132
166100200604     C     DDCUSN        CHAIN     SDFTCSL1                           45                      CGL132
166200200604                                                                                              CGL132
166300200604      **  If insert and live record found - error                                             CGL132
166400200604                                                                                              CGL132
166500200604     C     DDACTN        IFEQ      'I'                                                        CGL132
166600200604                                                                                              CGL132
166700200604     C     *IN45         IFEQ      '0'                                                        CGL132
166800200604     C                   MOVEL     'N'           OKCUST                                       CGL132
166900200604     C                   ADD       1             Ix                                           CGL132
167000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
167100200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CGL132
167200200604     C                   ENDIF                                                                CGL132
167300200604                                                                                              CGL132
167400200604     C                   CLEAR                   CuFaFilFmt                                   CGL132
167500200604     C                   EVAL      FACUST = DDCUSN                                            CGL132
167600200604     C                   EVAL      FACLAC = WWCLAC                                            CGL132
167700200604                                                                                              CGL132
167800200604      ** Retrieve classification description                                                  CGL132
167900200604                                                                                              CGL132
168000200604     C                   CALL      'AOFATCR0'                                                 CGL132
168100200604     C                   PARM      *BLANKS       @RTCD                                        CGL132
168200200604     C                   PARM      '*KEY    '    @OPTN                                        CGL132
168300200604     C                   PARM      FACLAC        @CLAC                                        CGL132
168400200604     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
168500200604                                                                                              CGL132
168600200604      ** If value entered by user is not found on the FATCA                                   CGL132
168700200604      ** classification code file then return an error                                        CGL132
168800200604                                                                                              CGL132
168900200604     C                   IF        @RTCD = '*NRF' OR                                          CGL132
169000200604     C                             @RTCD <> *BLANKS                                           CGL132
169100200604     C                   MOVEL     'N'           OKCUST                                       CGL132
169200200604     C                   ADD       1             Ix                                           CGL132
169300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
169400200604     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
169500200604     C                   ENDIF                                                                CGL132
169600200604                                                                                              CGL132
169700200604      **  If delete, amend or enquire                                                         CGL132
169800200604     C                   ELSE                                                                 CGL132
169900200604                                                                                              CGL132
170000200604      **  If record not found - ERROR                                                         CGL132
170100200604                                                                                              CGL132
170200200604     C     DDACTN        IFNE      'D'                                                      MD039670
170300200604     C     DDACTN        ANDNE     'E'                                                      MD041337
170400200604     C     DDACTN        ANDNE     'A'                                                      MD041527
170500200604     C     *IN45         IFEQ      '1'                                                        CGL132
170600200604     C                   MOVEL     'N'           OKCUST                                       CGL132
170700200604     C                   ADD       1             Ix                                           CGL132
170800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
170900200604     C                   MOVEL     'USS0172'     MsgIdArr(Ix)                                 CGL132
171000200604     C                   ELSE                                                                 CGL132
171100200604                                                                                              CGL132
171200200604     C                   IF        FACLAC <> *BLANKS                                          CGL132
171300200604      ** Retrieve classification description                                                  CGL132
171400200604                                                                                              CGL132
171500200604     C                   CALL      'AOFATCR0'                                                 CGL132
171600200604     C                   PARM      *BLANKS       @RTCD                                        CGL132
171700200604     C                   PARM      '*KEY    '    @OPTN                                        CGL132
171800200604     C                   PARM      FACLAC        @CLAC                                        CGL132
171900200604     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
172000200604                                                                                              CGL132
172100200604      ** If value entered by user is not found on the FATCA                                   CGL132
172200200604      ** classification code file then return an error                                        CGL132
172300200604                                                                                              CGL132
172400200604     C                   IF        @RTCD = '*NRF' OR                                          CGL132
172500200604     C                             @RTCD <> *BLANKS                                           CGL132
172600200604     C                   MOVEL     'N'           OKCUST                                       CGL132
172700200604     C                   ADD       1             Ix                                           CGL132
172800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
172900200604     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
173000200604     C                   ENDIF                                                                CGL132
173100200604     C                   ENDIF                                                                CGL132
173200200604                                                                                              CGL132
173300200604     C                   IF        FAPCLA <> *BLANKS                                          CGL132
173400200604      ** Retrieve classification description                                                  CGL132
173500200604                                                                                              CGL132
173600200604     C                   CALL      'AOFATCR0'                                                 CGL132
173700200604     C                   PARM      *BLANKS       @RTCD                                        CGL132
173800200604     C                   PARM      '*KEY    '    @OPTN                                        CGL132
173900200604     C                   PARM      FAPCLA        @CLAC                                        CGL132
174000200604     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
174100200604                                                                                              CGL132
174200200604      ** If value entered by user is not found on the FATCA                                   CGL132
174300200604      ** classification code file then return an error                                        CGL132
174400200604                                                                                              CGL132
174500200604     C                   IF        @RTCD = '*NRF' OR                                          CGL132
174600200604     C                             @RTCD <> *BLANKS                                           CGL132
174700200604     C                   MOVEL     'N'           OKCUST                                       CGL132
174800200604     C                   ADD       1             Ix                                           CGL132
174900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
175000200604     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
175100200604     C                   ENDIF                                                                CGL132
175200200604     C                   ENDIF                                                                CGL132
175300200604                                                                                              CGL132
175400200604     C                   IF        CGL133 = 'N'                                               CGL132
175500200604     C                   MOVE      *BLANKS       WWTINO                                       CGL132
175600200604     C                   IF        E5TNC5 = WCTAX                                             CGL132
175700200604     C                   MOVE      *BLANKS       WWTINO                                       CGL132
175800200604     C                   MOVEL     E5TIN5        WWTINO                                       CGL132
175900200604     C                   ENDIF                                                                CGL132
176000200604     C                   IF        E5TNC4 = WCTAX                                             CGL132
176100200604     C                   MOVE      *BLANKS       WWTINO                                       CGL132
176200200604     C                   MOVEL     E5TIN4        WWTINO                                       CGL132
176300200604     C                   ENDIF                                                                CGL132
176400200604     C                   IF        E5TNC3 = WCTAX                                             CGL132
176500200604     C                   MOVE      *BLANKS       WWTINO                                       CGL132
176600200604     C                   MOVEL     E5TIN3        WWTINO                                       CGL132
176700200604     C                   ENDIF                                                                CGL132
176800200604     C                   IF        E5TNC2 = WCTAX                                             CGL132
176900200604     C                   MOVE      *BLANKS       WWTINO                                       CGL132
177000200604     C                   MOVEL     E5TIN2        WWTINO                                       CGL132
177100200604     C                   ENDIF                                                                CGL132
177200200604     C                   IF        BBCOLC = WCTAX                                             CGL132
177300200604     C                   MOVE      *BLANKS       WWTINO                                       CGL132
177400200604     C                   MOVEL     E5TINO        WWTINO                                       CGL132
177500200604     C                   ENDIF                                                                CGL132
177600200604     C                   ELSE                                                                 CGL132
177700200604     C                   EVAL      WWTINO = FAUTIN                                            CGL132
177800200604     C                   ENDIF                                                                CGL132
177900200604     C                   EVAL      FAUTIN = WWTINO                                            CGL132
178000200604     C                   ENDIF                                                                CGL132
178100200604                                                                                              CGL132
178200200604     C                   ENDIF                                                              MD039670
178300200604     C                   ENDIF                                                                CGL132
178400200604                                                                                              CGL132
178500200604     C                   ENDSR                                                                CGL132
178600200604                                                                                              CGL132
178700200604      *****************************************************************
178800200604      /EJECT
178900200604      *****************************************************************
179000200604      * RTVPRV - RETRIEVE PRIVATE BANKING CUS DETAILS IF PBSwtc = 'Y'  '
179100200604      *****************************************************************
179200200604     C     RTVPRV        BEGSR
179300200604      *
179400200604      * Access Customer Private Banking details from the PB file
179500200604      *
179600200604     C                   MOVEL     DDCUSN        A_PBCNUM
179700200604     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
179800200604     C     A_PBCNUM      CHAIN     @CPBRF                             45                      CSD028
179900200604     C                   ELSE                                                                 CSD028
180000200604     C     A_PBCNUM      CHAIN     SDPBDSLR                           45
180100200604     C                   ENDIF                                                                CSD028
180200200604      *
180300200604     C**  IF INSERT AND LIVE RECORD FOUND - ERROR
180400200604      *
180500200604      ** Skip validation if the customer came from the acceptance file.                       CSD031
180600200604                                                                                              CSD031
180700200604     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
180800200604     C     DDACTN        IFEQ      'I'
180900200604
181000200604     C     *IN45         IFEQ      '0'
181100200604     C     A_PBRECI      ANDEQ     'D'
181200200604     C                   MOVEL     'N'           OKCUST
181300200604     C                   ADD       1             Ix
181400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
181500200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)
181600200604     C                   END
181700200604      *
181800200604     C**  IF DELETE, AMEND OR ENQUIRE
181900200604     C                   ELSE
182000200604     C*
182100200604     C**  IF LIVE RECORD NOT FOUND - ERROR
182200200604     C*
182300200604     C     *IN45         IFEQ      '1'
182400200604     C     A_PBRECI      ORNE      'D'
182500200604     C     DDACTN        ANDNE     'E'                                                        CSW024
182600200604     C                   MOVEL     'N'           OKCUST
182700200604     C                   ADD       1             Ix
182800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
182900200604     C                   MOVEL     'USR3865'     MsgIdArr(Ix)
183000200604     C                   END
183100200604
183200200604     C                   ENDIF
183300200604     C**********         ENDIF                                                       CSD031 BUG13525
183400200604
183500200604     C                   ENDSR
183600200604      *****************************************************************
183700200604      * RTVTID - Retrieve TI Customer Details                                                BUG3362
183800200604      *****************************************************************                      BUG3362
183900200604     C     RTVTID        BEGSR                                                               BUG3362
184000200604      *                                                                                      BUG3362
184100200604      * Access TI Customer Details from PF/SDICSPD                                           BUG3362
184200200604      *                                                                                      BUG3362
184300200604     C                   MOVEL     DDCUSN        A_TCCUST          6                         BUG3362
184400200604     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
184500200604     C     A_TCCUST      CHAIN     SDTICSD0                           45                      CSD028
184600200604     C                   ELSE                                                                 CSD028
184700200604     C     A_TCCUST      CHAIN     SDTICSLR                           45                     BUG3362
184800200604     C                   ENDIF                                                               CSD028
184900200604      *                                                                                      BUG3362
185000200604      ** If Insert and live record found - ERROR                                             BUG3362
185100200604      *                                                                                      BUG3362
185200200604     C     DDACTN        IFEQ      'I'                                                       BUG3362
185300200604                                                                                             BUG3362
185400200604     C     *IN45         IFEQ      '0'                                                       BUG3362
185500200604     C                   MOVEL     'N'           OKCUST                                      BUG3362
185600200604     C                   ADD       1             Ix                                          BUG3362
185700200604     C                   MOVEL     'A_TCCUST'    FldNameArr(Ix)                              BUG3362
185800200604      ** need to check for proper error message ID                                           BUG3362
185900200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                BUG3362
186000200604     C                   ENDIF                                                               BUG3362
186100200604      *                                                                                      BUG3362
186200200604      ****If*Delete, Amend Or Enquire                                                BUG3362 BG12238
186300200604     C**********         ELSE                                                        BUG3362 BG12238
186400200604      **********                                                                     BUG3362 BG12238
186500200604      ****If*live record not found - ERROR                                           BUG3362 BG12238
186600200604      **********                                                                     BUG3362 BG12238
186700200604     C******IN45         IFEQ      '1'                                               BUG3362 BG12238
186800200604     C*****DDACTN        ANDNE     'E'                                               BUG3362 BG12238
186900200604     C**********         MOVEL     'N'           OKCUST                              BUG3362 BG12238
187000200604     C**********         ADD       1             Ix                                  BUG3362 BG12238
187100200604     C**********         MOVEL     'A_TCCUST'    FldNameArr(Ix)                      BUG3362 BG12238
187200200604      ***DBerror, details not found                                                  BUG3362 BG12238
187300200604     C**********         MOVEL     'USR4181'     MsgIdArr(Ix)                        BUG3362 BG12238
187400200604     C**********         ENDIF                                                       BUG3362 BG12238
187500200604                                                                                             BUG3362
187600200604     C                   ENDIF                                                               BUG3362
187700200604                                                                                             BUG3362
187800200604     C                   ENDSR                                                               BUG3362
187900200604      *****************************************************************                      BUG3362
188000200604      /EJECT                                                                                  CGP001
188100200604      *****************************************************************                       CGP001
188200200604      * RTVGLB - Retrieve Global Customers X-Reference details                                CGP001
188300200604      *          if CGP001 = 'Y'                                                              CGP001
188400200604      *****************************************************************                       CGP001
188500200604     C     RTVGLB        BEGSR                                                                CGP001
188600200604                                                                                              CGP001
188700200604     C     KRTVG         KLIST                                                                CGP001
188800200604     C                   KFLD                    BBBRCD                                       CGP001
188900200604     C                   KFLD                    DDCUSN                                       CGP001
189000200604                                                                                              CGP001
189100200604      ** Access Global Customer X-Reference Details                                           CGP001
189200200604                                                                                              CGP001
189300200604     C                   CLEAR                   GCustFilFmt                                 BUG2313
189400200604     C     KRTVG         CHAIN     GPCUSTXL1                          45                      CGP001
189500200604                                                                                              CGP001
189600200604      ** If insert and exist in file, error                                                   CGP001
189700200604                                                                                              CGP001
189800200604     C     DDACTN        IFEQ      'I'                                                        CGP001
189900200604                                                                                              CGP001
190000200604     C                   IF        *IN45 = '0'                                                CGP001
190100200604     C                   EVAL      OKCUST = 'N'                                               CGP001
190200200604     C                   EVAL      Ix = Ix + 1                                                CGP001
190300200604     C                   EVAL      FldNameArr(Ix) = 'DDCUSN'                                  CGP001
190400200604     C                   EVAL      MsgIdArr(Ix) = 'Y2U0003'                                   CGP001
190500200604     C                   ENDIF                                                                CGP001
190600200604                                                                                              CGP001
190700200604     C                   ENDIF                                                                CGP001
190800200604                                                                                              CGP001
190900200604     C                   ENDSR                                                                CGP001
191000200604      *****************************************************************                       CGP001
191100200604      /EJECT
191200200604     C/COPY WNCPYSRC,SDCUSDIC08
191300200604      *****************************************************************
191400200604      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
191500200604      *****************************************************************
191600200604     C     VFRNT         BEGSR
191700200604      *
191800200604      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
191900200604      *
192000200604     C     DDACTN        IFNE      'I'
192100200604     C     DDACTN        ANDNE     'A'
192200200604     C     DDACTN        ANDNE     'E'
192300200604     C     DDACTN        ANDNE     'D'
192400200604     C                   MOVEL     'N'           OKACTN
192500200604     C                   ADD       1             Ix
192600200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
192700200604     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
192800200604     C                   END
192900200604      *
193000200604      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
193100200604      *
193200200604     C     FOTRID        IFEQ      *BLANK
193300200604     C                   MOVE      'N'           OKACTN
193400200604     C                   ADD       1             Ix
193500200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
193600200604     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
193700200604     C                   GOTO      EVFRNT
193800200604     C                   END
193900200604      *
194000200604      * ACCESS CUSTOMER WITH FRONT OFFICE TRANSACTION ID
194100200604      *
194200200604     C     FOTRID        CHAIN     SDCUSFOI                           99
194300200604      *
194400200604      * IF INSERT
194500200604      *
194600200604     C     DDACTN        IFEQ      'I'
194700200604      *
194800200604      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
194900200604      *
195000200604     C     *IN99         IFEQ      '0'
195100200604     C                   MOVE      'N'           OKACTN
195200200604     C                   ADD       1             Ix
195300200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
195400200604     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
195500200604     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
195600200604     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
195700200604     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
195800200604     C                   GOTO      EVFRNT
195900200604     C                   END
196000200604      *
196100200604     C                   ELSE
196200200604      *
196300200604      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
196400200604      *
196500200604     C     *IN99         IFEQ      '1'
196600200604     C                   MOVE      'N'           OKACTN
196700200604     C                   ADD       1             Ix
196800200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
196900200604     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
197000200604     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
197100200604     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
197200200604     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
197300200604     C                   GOTO      EVFRNT
197400200604     C                   END
197500200604      *
197600200604      * IF NOT INSERT, UPDATE MIDAS CUSTOMER NUMBER
197700200604      *
197800200604     C                   MOVEL     BBCUST        DDCUSN
197900200604
198000200604     C                   END
198100200604                                                                                              CGL132
198200200604      ** Access FATCA customer with Front office transaction ID                               CGL132
198300200604                                                                                              CGL132
198400200604     C     FOTRID        CHAIN     SDFTCSL2                           99                      CGL132
198500200604                                                                                              CGL132
198600200604      ** if insert                                                                            CGL132
198700200604                                                                                              CGL132
198800200604     C     DDACTN        IFEQ      'I'                                                        CGL132
198900200604                                                                                              CGL132
199000200604      ** Front office transaction ID can't be present already                                 CGL132
199100200604                                                                                              CGL132
199200200604     C     *IN99         IFEQ      '0'                                                        CGL132
199300200604     C                   MOVE      'N'           OKACTN                                       CGL132
199400200604     C                   ADD       1             Ix                                           CGL132
199500200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL132
199600200604     C                   MOVEL     'APM0202'     MsgIdArr(Ix)                                 CGL132
199700200604     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CGL132
199800200604     C                   GOTO      EVFRNT                                                     CGL132
199900200604     C                   ENDIF                                                                CGL132
200000200604                                                                                              CGL132
200100200604     C                   ELSE                                                                 CGL132
200200200604                                                                                              CGL132
200300200604      ** If not insert, Front office transaction ID must be present                           CGL132
200400200604                                                                                              CGL132
200500200604     C     *IN99         IFEQ      '1'                                                        CGL132
200600200604     C                   MOVE      'N'           OKACTN                                       CGL132
200700200604     C                   ADD       1             Ix                                           CGL132
200800200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL132
200900200604     C                   MOVEL     'APM0203'     MsgIdArr(Ix)                                 CGL132
201000200604     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CGL132
201100200604     C                   GOTO      EVFRNT                                                     CGL132
201200200604     C                   ENDIF                                                                CGL132
201300200604                                                                                              CGL132
201400200604      ** If not insert, update Midas customer number                                          CGL132
201500200604                                                                                              CGL132
201600200604     C                   MOVEL     FACUST        DDCUSN                                       CGL132
201700200604                                                                                              CGL132
201800200604     C                   ENDIF                                                                CGL132
201900200604      *
202000200604     C     EVFRNT        ENDSR
202100200604      *****************************************************************
202200200604      /EJECT
202300200604      *****************************************************************
202400200604      * VAL - VALIDATION OF ACTION CODE AND CUSTOMER NUMBER
202500200604      *****************************************************************
202600200604     C     VAL           BEGSR
202700200604      *
202800200604      * Action Code
202900200604      *
203000200604      *  .. must be 'I','A','D' or 'E'
203100200604      *  .. or 'C' or 'R'                                                                     CSD007
203200200604      *
203300200604     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
203400200604                                                                                              CSD031
203500200604     C     DDACTN        IFNE      'I'
203600200604     C     DDACTN        ANDNE     'A'
203700200604     C     DDACTN        ANDNE     'D'
203800200604     C     DDACTN        ANDNE     'E'
203900200604     C     DDACTN        ANDNE     'C'                                                        CSD007
204000200604     C     DDACTN        ANDNE     'R'                                                        CSD007
204100200604     C/COPY WNCPYSRC,SDH00483
204200200604     C                   MOVEL     'N'           OKACTN
204300200604     C                   ADD       1             Ix
204400200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
204500200604     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
204600200604     C**********         MOVEL     'SDA0006'     MsgIdArr(Ix)                        CSD031 BUG13525
204700200604     C**********         ELSE                                                        CSD031 BUG13525
204800200604     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
204900200604     C**********         ENDIF                                                       CSD031 BUG13525
205000200604     C                   GOTO      EVAL                                                      BUG8169
205100200604     C                   END
205200200604                                                                                              CSD031
205300200604     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
205400200604     C*****DDCUSN        CHAIN     SDACSTL1                                          CSD031 BUG13525
205500200604     C**********         IF        %FOUND AND                                        CSD031 BUG13525
205600200604     C**********                   DDACTN <> 'I' AND                                 CSD031 BUG13525
205700200604     C**********                   DDACTN <> 'E'                                     CSD031 BUG13525
205800200604     C**********         MOVEL     'N'           OKACTN                              CSD031 BUG13525
205900200604     C**********         ADD       1             Ix                                  CSD031 BUG13525
206000200604     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                      CSD031 BUG13525
206100200604     C**********         MOVEL     'CSD0002'     MsgIdArr(Ix)                        CSD031 BUG13525
206200200604     C**********         GOTO      EVAL                                              CSD031 BUG13525
206300200604     C**********         ENDIF                                                       CSD031 BUG13525
206400200604     C**********         ENDIF                                                       CSD031 BUG13525
206500200604                                                                                              CSD031
206600200604     C**********         ELSE                                                        CSD031 BUG13525
206700200604                                                                                              CSD031
206800200604     C*****DDACTN        IFNE      'I'                                               CSD031 BUG13525
206900200604     C*****DDACTN        ANDNE     'A'                                               CSD031 BUG13525
207000200604     C*****DDACTN        ANDNE     'D'                                               CSD031 BUG13525
207100200604     C*****DDACTN        ANDNE     'E'                                               CSD031 BUG13525
207200200604     C*****DDACTN        ANDNE     'X'                                               CSD031 BUG13525
207300200604     C**********         MOVEL     'N'           OKACTN                              CSD031 BUG13525
207400200604     C**********         ADD       1             Ix                                  CSD031 BUG13525
207500200604     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                      CSD031 BUG13525
207600200604     C**********         MOVEL     'SDA0013'     MsgIdArr(Ix)                        CSD031 BUCSD031
207700200604     C**********         MOVEL     'CSF9094'     MsgIdArr(Ix)                      BUG11888 BUG13525
207800200604     C**********         ENDIF                                                       CSD031 BUG13525
207900200604                                                                                              CSD031
208000200604      ** Skip further validation if the customer came from the acceptance file.               CSD031
208100200604                                                                                              CSD031
208200200604     C**********         LEAVESR                                                     CSD031 BUG13525
208300200604     C**********         ENDIF                                                       CSD031 BUG13525
208400200604      *
208500200604      * Customer Number
208600200604      *
208700200604      *  If the Customer Number is not blank, check that it is numeric.
208800200604      *
208900200604     C                   TESTN                   DDCUSN               98
209000200604     C                   MOVE      DDCUSN        @1CUST            1
209100200604     C                   TESTZ                   @1CUST                   99
209200200604      *
209300200604      ** If Alphanumeric Customer Numbers are enabled                                         CSD027
209400200604     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
209500200604     C                   Eval      PCust = DDCUSN                                             CSD027
209600200604     C                   Eval      PValid = *BLANKS                                           CSD027
209700200604     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
209800200604      * If Error                                                                              CSD027
209900200604     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
210000200604     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
210100200604     C                   Eval      DBASE = 913                                                CSD027
210200200604     C                   Eval      DBKEY = PCust                                              CSD027
210300200604     C                   ExSr      *PSSR                                                      CSD027
210400200604     C                   EndIf                                                                CSD027
210500200604      *                                                                                       CSD027
210600200604     C                   EndIf                                                                CSD027
210700200604      *                                                                                       CSD027
210800200604     C*****DDCUSN        IFNE      *BLANKS                                                    CSD027
210900200604     C******IN98         ANDEQ     '0'                                                        CSD027
211000200604     C*****DDCUSN        ORNE      *BLANKS                                                    CSD027
211100200604     C******IN99         ANDEQ     '0'                                                        CSD027
211200200604     C**********         MOVEL     'N'           OKCUST                                       CSD027
211300200604     C**********         ADD       1             Ix                                           CSD027
211400200604     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD027
211500200604     C**********         MOVEL     'USR0822'     MsgIdArr(Ix)                                 CSD027
211600200604     C**********         GOTO      EVAL                                                       CSD027
211700200604     C**********         END                                                                  CSD027
211800200604      *                                                                                       CSD027
211900200604      * Check if Customer# is valid                                                           CSD027
212000200604     C                   If        DDCUSN = *BLANKS                                           CSD027
212100200604     C                             Or                                                         CSD027
212200200604     C                             (WCusAlphaAllow = 'N' And                                  CSD027
212300200604     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
212400200604     C                             Or                                                         CSD027
212500200604     C                             (DDACTN <> 'I' And                                         CSD027
212600200604     C                              WCusAlphaAllow = 'Y' And                                  CSD027
212700200604     C                              WCusAlphaSupNum = 'Y' And                                 CSD027
212800200604     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
212900200604     C                             Or                                                         CSD027
213000200604     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
213100200604     C                              PValid = *BLANKS)                                         CSD027
213200200604     C                             Or                                                       BUG11934
213300200604     C                             (WCusAlphaAllow = 'Y' And                                BUG11934
213400200604     C                              WCusAlphaSupNum = 'Y' And                               BUG11934
213500200604     C                              PValid = *BLANKS)                                       BUG11934
213600200604      *                                                                                       CSD027
213700200604     C                   Else                                                                 CSD027
213800200604      * If invalid Customer#                                                                  CSD027
213900200604     C                   Eval      OKCUST = 'N'                                               CSD027
214000200604     C                   Add       1             Ix                                           CSD027
214100200604     C                   Eval      FldNameArr(Ix) = 'DDCUSN'                                  CSD027
214200200604     C                   If        WCusAlphaAllow = 'N'                                       CSD027
214300200604     C                   Eval      MsgIdArr(Ix) = 'S270003'                                   CSD027
214400200604     C                   Else                                                                 CSD027
214500200604     C                   Eval      MsgIdArr(Ix) = 'S270004'                                   CSD027
214600200604     C                   EndIf                                                                CSD027
214700200604     C                   Goto      EVAL                                                       CSD027
214800200604      *                                                                                       CSD027
214900200604     C                   EndIf                                                                CSD027
215000200604      *                                                                                       CSD021
215100200604      ** Customer Number mandatory if DDACTN = 'I' and CSD021 is off                          CSD021
215200200604      **                           OR DDACTN <> 'I'                                           CSD021
215300200604     C     CSD021        IFNE      'Y'                                                        CSD021
215400200604     C     DDACTN        ANDEQ     'I'                                                        CSD021
215500200604     C     DDACTN        ORNE      'I'                                                        CSD021
215600200604      *
215700200604      *  Customer number required
215800200604      *
215900200604     C     DDCUSN        IFEQ      *BLANKS
216000200604     C     DDCUSN        OREQ      *ZEROS
216100200604     C                   MOVEL     'N'           OKCUST
216200200604     C                   ADD       1             Ix
216300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
216400200604     C                   MOVEL     'USR0246'     MsgIdArr(Ix)
216500200604     C                   GOTO      EVAL
216600200604     C                   END
216700200604     C/COPY WNCPYSRC,SDCUSDIC04
216800200604      *                                                                                       CSD021
216900200604     C                   ENDIF                                                                CSD021
217000200604      *                                                                                       CSD021
217100200604      ** Call SD0011U only if DDCUSN is not blank                                             CSD021
217200200604     C     DDCUSN        IFNE      *BLANK                                                     CSD021
217300200604      *
217400200604     C                   Eval      @RTCD = *BLANKS                                            CSD027
217500200604     C                   Eval      PValid = *BLANKS                                           CSD027
217600200604      *
217700200604      *  Modulus 10 Validation if Apply Modulus 10 Check
217800200604      *
217900200604     C     BJMODT        IFEQ      'Y'
218000200604     C     DDACTN        ANDEQ     'I'                                                        214144
218100200604     C*****WCusAlphChksumANDEQ     'N'                                               CSD027 BUG11932
218200200604     C     WCusAlphaAllowANDEQ     'N'                                                      BUG11932
218300200604      *
218400200604     C/COPY WNCPYSRC,SDCUSDIC01
218500200604     C                   CALL      'SD0011U'
218600200604     C                   PARM      *BLANKS       @RTCD             7
218700200604     C                   PARM      DDCUSN        @CUST             6
218800200604      *
218900200604     C                   EndIf                                                                CSD027
219000200604      *                                                                                       CSD027
219100200604     C                   If        DDACTN = 'I' And WCusAlphChksum = 'Y'                      CSD027
219200200604     C                             And  WCusAlphaAllow = 'Y'                                BUG11932
219300200604     C                   Eval      PCust = DDCUSN                                             CSD027
219400200604     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
219500200604      * If Error                                                                              CSD027
219600200604     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
219700200604     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
219800200604     C                   Eval      DBASE = 915                                                CSD027
219900200604     C                   Eval      DBKEY = PCust                                              CSD027
220000200604     C                   ExSr      *PSSR                                                      CSD027
220100200604     C                   EndIf                                                                CSD027
220200200604      *                                                                                       CSD027
220300200604     C                   EndIf                                                                CSD027
220400200604      *                                                                                       CSD027
220500200604      *  ERROR DETECTED ?
220600200604      *
220700200604     C     @RTCD         IFNE      *BLANKS
220800200604     C     PValid        ORNE      *BLANKS                                                    CSD027
220900200604     C                   MOVEL     'N'           OKCUST
221000200604     C                   ADD       1             Ix
221100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
221200200604     C**********         If        WCusAlphChksum = 'N'                              CSD027 BUG11932
221300200604     C                   If        WCusAlphaAllow = 'N'                                     BUG11932
221400200604     C                   MOVEL     'USR0986'     MsgIdArr(Ix)
221500200604     C                   Else                                                                 CSD027
221600200604     C                   Eval      MsgIdArr(Ix) = 'S270005'                                   CSD027
221700200604     C                   EndIf                                                                CSD027
221800200604     C                   GOTO      EVAL
221900200604     C                   END
222000200604      *
222100200604     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
222200200604     C                   MoveL(P)  DDCUSN        @CSSN            10                          CSD027
222300200604      *                                                                                       CSD027
222400200604      * Check if customer# is same as any other customer's shortname                          CSD027
222500200604     C     @CSSN         Chain     SDCUSTLH                                                   CSD027
222600200604      *                                                                                       CSD027
222700200604      * If record found, send error message                                                   CSD027
222800200604     C                   If        %Found(SDCUSTLH)                                           CSD027
222900200604     C     BBCUST        Ifne      @CSSN                                                      CSD027
223000200604     C**********         Eval      OKCUST = 'N'                                        CSD027 CSD091
223100200604     C**********         Add       1             Ix                                    CSD027 CSD091
223200200604     C**********         Eval      FldNameArr(Ix) = 'DDCUSN'                           CSD027 CSD091
223300200604     C**********         Eval      MsgIdArr(Ix) = 'S270006'                            CSD027 249029
223400200604     C**********         Eval      MsgIdArr(Ix) = 'S270013'                            249029 CSD091
223500200604                                                                                              CSD091
223600200604     C**********         EVAL      OKCUST = 'W'                                      CSD091 AR855391
223700200604     C**********         EVAL      WIx = WIx + 1                                     CSD091 AR855391
223800200604     C**********         EVAL      WFldNamArr(WIx) = 'DDCUSN'                        CSD091 AR855391
223900200604     C**********         EVAL      WMsgIDArr(WIx) = 'S270013'                        CSD091 AR855391
224000200604                                                                                              CSD091
224100200604     C                   Eval      OKCUST = 'N'                                             AR855391
224200200604     C                   Add       1             Ix                                         AR855391
224300200604     C                   Eval      FldNameArr(Ix) = 'DDCUSN'                                AR855391
224400200604     C                   Eval      MsgIdArr(Ix) = 'S270013'                                 AR855391
224500200604     C                   Goto      EVAL                                                       CSD027
224600200604     C                   EndIf                                                                CSD027
224700200604     C                   EndIf                                                                CSD027
224800200604     C                   EndIf                                                                CSD027
224900200604      *                                                                                       CSD027
225000200604     C/COPY WNCPYSRC,SDCUSDIC02
225100200604     C**********         ENDIF                                                                CSD027
225200200604      *                                                                                       CSD021
225300200604     C                   ENDIF                                                                CSD021
225400200604      *
225500200604      *  If manual deletion of customers is not allowed
225600200604      *  then action code 'D' delete is not valid
225700200604      *  and action codes 'C' closure and 'R' release are also not valid                      CSD007
225800200604      *
225900200604     C     BJMDEL        IFEQ      'N'
226000200604     C*****DDACTN        ANDEQ     'D'                                                        CSD007
226100200604     C     DDACTN        IFEQ      'C'                                                        CSD007
226200200604     C     DDACTN        OREQ      'R'                                                        CSD007
226300200604     C*****DDACTN        OREQ      'D'                                                 CSD007 254109
226400200604      ***Delete*Action*is*not*allowed**********************************                       254109
226500200604     C                   MOVEL     'N'           OKACTN
226600200604     C                   ADD       1             Ix
226700200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
226800200604     C**********         MOVEL     'USR0553'     MsgIdArr(Ix)                                 254109
226900200604     C                   MOVEL     'USR9921'     MsgIdArr(Ix)                                 254109
227000200604     C                   GOTO      EVAL
227100200604      *
227200200604     C                   ENDIF
227300200604      *                                                                                       CSD007
227400200604     C     DDACTN        IFEQ      'D'                                                        254109
227500200604      *                                                                                       254109
227600200604     C                   MOVEL     'N'           OKACTN                                       254109
227700200604     C                   ADD       1             Ix                                           254109
227800200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               254109
227900200604     C                   MOVEL     'USR9920'     MsgIdArr(Ix)                                 254109
228000200604     C                   GOTO      EVAL                                                       254109
228100200604      *                                                                                       254109
228200200604     C                   ENDIF                                                                254109
228300200604      *                                                                                       254109
228400200604     C                   ENDIF                                                                CSD007
228500200604      *                                                                                       CSD012
228600200604      * If Authorisation check is on,                                                         CSD012
228700200604      * check if unathorised record exists on Authorisation Log.                              CSD012
228800200604     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
228900200604     C     AUTHMD        ANDNE     'X'                                                        CSD012
229000200604     C     DDACTN        ANDNE     'E'                                                        CSD012
229100200604      *                                                                                       CSD012
229200200604     C                   MOVEL     DDCUSN        @DDCUSN                                      CSD012
229300200604     C     KAULG         CHAIN     SDAULGL2                           90                      CSD012
229400200604      *                                                                                       CSD012
229500200604      * If record exists then prevent amendment                                               CSD012
229600200604     C     *IN90         IFEQ      *OFF                                                       CSD012
229700200604     C     TransType     ANDNE     'AUTH'                                                     CSD028
229800200604      *                                                                                       CSD012
229900200604     C                   MOVEL     'N'           OKCUST                                       CSD012
230000200604     C                   MOVEL     'N'           OKACTN                                       CSD012
230100200604     C                   MOVE      1             Ix                                           CSD012
230200200604     C                   MOVEL     @KEY          FldNameArr(Ix)                               CSD012
230300200604     C                   MOVEL     'USR9265'     MsgIdArr(Ix)                                 CSD012
230400200604     C                   ENDIF                                                                CSD012
230500200604      *                                                                                       CSD012
230600200604     C                   ENDIF                                                                CSD012
230700200604      *                                                                                       CSD012
230800200604      *
230900200604     C     EVAL          ENDSR
231000200604      *****************************************************************
231100200604      /EJECT
231200200604      *****************************************************************                     BUG23518
231300200604      *                                                               *                     BUG23518
231400200604      *  SRChkSts - Check if Customer is Taxable when Action is Close *                     BUG23518
231500200604      *                                                               *                     BUG23518
231600200604      *  Called By: VAL                                               *                     BUG23518
231700200604      *                                                               *                     BUG23518
231800200604      *  Calls: None                                                  *                     BUG23518
231900200604      *                                                               *                     BUG23518
232000200604      *****************************************************************                     BUG23518
232100200604     C     SRChkSts      BEGSR                                                              BUG23518
232200200604      *                                                                                     BUG23518
232300200604     C                   EVAL      PCusn = DDCUSN                                           BUG23518
232400200604      *                                                                                     BUG23518
232500200604      ** Retrieve Taxable Flag value from Customer Details                                  BUG23518
232600200604      *                                                                                     BUG23518
232700200604     C                   CALLB     'AOCUSTR0'                                               BUG23518
232800200604     C                   PARM      *Blanks       P@Rtcd                                     BUG23518
232900200604     C                   PARM      '*KEY'        P@Optn                                     BUG23518
233000200604     C                   PARM                    PCusn                                      BUG23518
233100200604     C                   PARM                    PKySt                                      BUG23518
233200200604     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23518
233300200604      *                                                                                     BUG23518
233400200604     C                   IF        P@Rtcd <> *BLANKS                                        BUG23518
233500200604      *                                                                                     BUG23518
233600200604     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG23518
233700200604     C                   EVAL      DBASE = 903                                              BUG23518
233800200604     C                   EVAL      DBKEY = P@Optn                                           BUG23518
233900200604     C                   EXSR      *PSSR                                                    BUG23518
234000200604      *                                                                                     BUG23518
234100200604     C                   ENDIF                                                              BUG23518
234200200604      *                                                                                     BUG23518
234300200604      ** Retrieve European Tax Status                                                       BUG23518
234400200604      *                                                                                     BUG23518
234500200604     C                   EVAL      KFCusn = DDCUSN                                          BUG23518
234600200604     C                   EVAL      KFCTax = ABBCOLC                                         BUG23518
234700200604      *                                                                                     BUG23518
234800200604     C     KLActx        CHAIN     SDACTXL1                                                 BUG23518
234900200604      *                                                                                     BUG23518
235000200604      ** If Customer found and is Taxable, display warning                                  BUG23518
235100200604      *                                                                                     BUG23518
235200200604     C                   IF        %FOUND(SDACTXL1)                                         BUG23518
235300200604      *                                                                                     BUG23518
235400200604     C                   IF        AXETXS = 'T'                                             BUG23518
235500200604     C                             OR (AXETXS = 'Y' AND CER069 = 'Y')                         CER069
235600200604      *                                                                                     BUG23518
235700200604     C                   EVAL      OKCUST = 'W'                                             BUG23518
235800200604     C                   EVAL      WIx = WIx + 1                                            BUG23518
235900200604     C                   EVAL      WFldNamArr(WIx) = 'DDCUSN'                               BUG23518
236000200604     C                   EVAL      WMsgIDArr(WIx)  = 'USR6501'                              BUG23518
236100200604      *                                                                                     BUG23518
236200200604     C                   ENDIF                                                              BUG23518
236300200604      *                                                                                     BUG23518
236400200604     C                   ENDIF                                                              BUG23518
236500200604      *                                                                                     BUG23518
236600200604     C                   ENDSR                                                              BUG23518
236700200604      *****************************************************************                     BUG23518
236800200604      /EJECT                                                                                BUG23518
236900200604      *****************************************************************
237000200604      * VALACI - VALIDATION OF ACTION CODE 'I'
237100200604      *****************************************************************
237200200604     C     VALACI        BEGSR
237300200604      *
237400200604      * Access Customer from the Customers file
237500200604      *
237600200604     C     DDCUSN        CHAIN     SDCUSTLR                           44
237700200604      *
237800200604      * Error if present already
237900200604      *
238000200604     C     *IN44         IFEQ      '0'
238100200604     C                   MOVEL     'N'           OKCUST
238200200604     C                   ADD       1             Ix
238300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
238400200604     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
238500200604      *                                                                                       CFT050
238600200604      ** Get customer swift details                                                           CFT050
238700200604      *                                                                                       CFT050
238800200604     C                   ELSE                                                                 CFT050
238900200604     C**********         IF        CSW213 = 'Y'                                      CFT050 MD022463
239000200604     C**********                   AND DDBDRK <> *BLANKS                             CFT050 MD022463
239100200604     C**********         IF        CFT050 = 'Y'                                    MD022463 MD022766
239200200604     C                   EXSR      Pop_SW13                                                   CFT050
239300200604     C**********         ENDIF                                                       CFT050 MD022766
239400200604     C                   END
239500200604      *
239600200604     C     EVALAI        ENDSR
239700200604      *****************************************************************
239800200604      /EJECT
239900200604      *****************************************************************
240000200604      * VALACD - VALIDATION OF ACTION CODE 'D'
240100200604      *****************************************************************
240200200604     C     VALACD        BEGSR
240300200604      *
240400200604     C                   MOVEL     'N'           WUERCD            1
240500200604                                                                                            BUG27866
240600200604     C                   EVAL      WWRTRN = *BLANKS                                         BUG27866
240700200604     C                   Z-ADD     187           WWLENG                                     BUG27866
240800200604     C                   EVAL      WWINPT = 'JOBI0300'                                      BUG27866
240900200604     C                   EVAL      WWQUAL = *BLANKS                                         BUG27866
241000200604     C                   EVAL      WWINTR = *BLANKS                                         BUG27866
241100200604     C                   EVAL      @WQUTP = 'Y'                                             BUG27866
241200200604                                                                                            BUG27866
241300200604     C                   CALL      'QUSRJOBI'                                               BUG27866
241400200604     C                   PARM                    WWRTRN                                     BUG27866
241500200604     C                   PARM                    WWLENG                                     BUG27866
241600200604     C                   PARM                    WWINPT                                     BUG27866
241700200604     C                   PARM      '*'           WWQUAL                                     BUG27866
241800200604     C                   PARM                    WWINTR                                     BUG27866
241900200604                                                                                            BUG27866
242000200604     C                   IF        WJOBTP = 'I' AND                                         BUG27866
242100200604     C                             WWJOB <> 'QZDASOINIT'                                    BUG27866
242200200604     C                   EVAL      @WQUTP = 'N'                                             BUG27866
242300200604     C                   ENDIF                                                              BUG27866
242400200604      *
242500200604      *  Customer Deletion Pre-checks - Client Details
242600200604      *
242700200604     C                   CALL      'SD0011X'                            90
242800200604     C                   PARM      *BLANKS       @RTCD             7
242900200604     C                   PARM      DDCUSN        @CUST             6
243000200604      * Customer Delete Status
243100200604     C                   PARM      WUDELS        @WDELS            7
243200200604      * Customer Deln String 1
243300200604     C                   PARM      WDS1000       @WCDS1          200
243400200604      * Customer Deln String 2
243500200604     C                   PARM      WDS2000       @WCDS2          200
243600200604      * Customer Deln String 3
243700200604     C                   PARM      WDS3000       @WCDS3          200
243800200604      * Customer Deln String 4
243900200604     C                   PARM      WDS4000       @WCDS4          200
244000200604      * Customer Deln String 5
244100200604     C                   PARM      WDS5000       @WCDS5          200
244200200604      * Quit program
244300200604     C**********         PARM      'N'           @WQUTP            1                        BUG27866
244400200604     C                   PARM                    @WQUTP                                     BUG27866
244500200604      *
244600200604      *  Call to program ended in error
244700200604      *
244800200604     C     *IN90         IFEQ      '1'
244900200604     C                   MOVEL     'N'           OKCUST
245000200604     C                   ADD       1             Ix
245100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
245200200604     C                   MOVEL     'Y2U0032'     MsgIdArr(Ix)
245300200604     C                   GOTO      EVALAD
245400200604     C                   END
245500200604      *
245600200604      *  ERROR DETECTED ?
245700200604      *
245800200604     C     @RTCD         IFNE      *BLANKS
245900200604     C                   MOVEL     'N'           OKCUST
246000200604     C                   ADD       1             Ix
246100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
246200200604     C                   MOVEL     'USR2209'     MsgIdArr(Ix)
246300200604     C                   GOTO      EVALAD
246400200604     C                   END
246500200604     C     @WDELS        IFNE      'DELETE'
246600200604     C                   MOVEL     'Y'           WUERCD
246700200604      * CUSTOMER SPECIFIC CHECKS:
246800200604      * Customer delete rejected by Bank specific check number 1.
246900200604      * CASE: WRK.Customer Deln Flag 801 is Do not delete
247000200604     C     WDS5001       IFEQ      'F'
247100200604     C                   MOVEL     'N'           OKCUST
247200200604     C                   ADD       1             Ix
247300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
247400200604     C                   MOVEL     'USR2209'     MsgIdArr(Ix)
247500200604     C                   GOTO      EVALAD
247600200604     C                   END
247700200604      * Customer delete rejected by Bank specific check number 2.
247800200604      * CASE: WRK.Customer Deln Flag 802 is Do not delete
247900200604     C     WDS5002       IFEQ      'F'
248000200604     C                   MOVEL     'N'           OKCUST
248100200604     C                   ADD       1             Ix
248200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
248300200604     C                   MOVEL     'USR2210'     MsgIdArr(Ix)
248400200604     C                   GOTO      EVALAD
248500200604     C                   END
248600200604      * Customer delete rejected by Bank specific check number 3.
248700200604      * CASE: WRK.Customer Deln Flag 803 is Do not delete
248800200604     C     WDS5003       IFEQ      'F'
248900200604     C                   MOVEL     'N'           OKCUST
249000200604     C                   ADD       1             Ix
249100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
249200200604     C                   MOVEL     'USR2211'     MsgIdArr(Ix)
249300200604     C                   GOTO      EVALAD
249400200604     C                   END
249500200604      * Customer delete rejected by Bank specific check number 4.
249600200604      * CASE: WRK.Customer Deln Flag 804 is Do not delete
249700200604     C     WDS5004       IFEQ      'F'
249800200604     C                   MOVEL     'N'           OKCUST
249900200604     C                   ADD       1             Ix
250000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
250100200604     C                   MOVEL     'USR2212'     MsgIdArr(Ix)
250200200604     C                   GOTO      EVALAD
250300200604     C                   END
250400200604      * Customer delete rejected by Bank specific check number 5.
250500200604      * CASE: WRK.Customer Deln Flag 805 is Do not delete
250600200604     C     WDS5005       IFEQ      'F'
250700200604     C                   MOVEL     'N'           OKCUST
250800200604     C                   ADD       1             Ix
250900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
251000200604     C                   MOVEL     'USR2213'     MsgIdArr(Ix)
251100200604     C                   GOTO      EVALAD
251200200604     C                   END
251300200604      * Customer delete rejected by Bank specific check number 6.
251400200604      * CASE: WRK.Customer Deln Flag 806 is Do not delete
251500200604     C     WDS5006       IFEQ      'F'
251600200604     C                   MOVEL     'N'           OKCUST
251700200604     C                   ADD       1             Ix
251800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
251900200604     C                   MOVEL     'USR2214'     MsgIdArr(Ix)
252000200604     C                   GOTO      EVALAD
252100200604     C                   END
252200200604      * Customer delete rejected by Bank specific check number 7.
252300200604      * CASE: WRK.Customer Deln Flag 807 is Do not delete
252400200604     C     WDS5007       IFEQ      'F'
252500200604     C                   MOVEL     'N'           OKCUST
252600200604     C                   ADD       1             Ix
252700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
252800200604     C                   MOVEL     'USR2215'     MsgIdArr(Ix)
252900200604     C                   GOTO      EVALAD
253000200604     C                   END
253100200604      * Customer delete rejected by Bank specific check number 8.
253200200604      * CASE: WRK.Customer Deln Flag 808 is Do not delete
253300200604     C     WDS5008       IFEQ      'F'
253400200604     C                   MOVEL     'N'           OKCUST
253500200604     C                   ADD       1             Ix
253600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
253700200604     C                   MOVEL     'USR2216'     MsgIdArr(Ix)
253800200604     C                   GOTO      EVALAD
253900200604     C                   END
254000200604      * Customer delete rejected by Bank specific check number 9.
254100200604      * CASE: WRK.Customer Deln Flag 809 is Do not delete
254200200604     C     WDS5009       IFEQ      'F'
254300200604     C                   MOVEL     'N'           OKCUST
254400200604     C                   ADD       1             Ix
254500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
254600200604     C                   MOVEL     'USR2217'     MsgIdArr(Ix)
254700200604     C                   GOTO      EVALAD
254800200604     C                   END
254900200604      * Customer delete rejected by Bank specific check number 10.
255000200604      * CASE: WRK.Customer Deln Flag 810 is Do not delete
255100200604     C     WDS5010       IFEQ      'F'
255200200604     C                   MOVEL     'N'           OKCUST
255300200604     C                   ADD       1             Ix
255400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
255500200604     C                   MOVEL     'USR2218'     MsgIdArr(Ix)
255600200604     C                   GOTO      EVALAD
255700200604     C                   END
255800200604      * GENERAL LEDGER CHECKS:
255900200604      * Customer defined on ACCNT.
256000200604      * CASE: WRK.Customer Deln Flag 201 is Do not delete
256100200604     C     WDS2001       IFEQ      'F'
256200200604     C                   MOVEL     'N'           OKCUST
256300200604     C                   ADD       1             Ix
256400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
256500200604     C                   MOVEL     'USR1119'     MsgIdArr(Ix)
256600200604     C                   GOTO      EVALAD
256700200604     C                   END
256800200604      * SECURITIES TRADING CHECKS:
256900200604      * Customer defined on CDEPPD.
257000200604      * CASE: WRK.Customer Deln Flag 213 is Do not delete
257100200604     C     WDS2013       IFEQ      'F'
257200200604     C                   MOVEL     'N'           OKCUST
257300200604     C                   ADD       1             Ix
257400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
257500200604     C                   MOVEL     'USR2078'     MsgIdArr(Ix)
257600200604     C                   GOTO      EVALAD
257700200604     C                   END
257800200604      * Depot customer has a live depot movement defined on DPTMVD.
257900200604      * CASE: WRK.Customer Deln Flag 214 is Do not delete
258000200604     C     WDS2014       IFEQ      'F'
258100200604     C                   MOVEL     'N'           OKCUST
258200200604     C                   ADD       1             Ix
258300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
258400200604     C                   MOVEL     'USR2224'     MsgIdArr(Ix)
258500200604     C                   GOTO      EVALAD
258600200604     C                   END
258700200604      * Customer has a live depot movement defined on DPTMVD.
258800200604      * CASE: WRK.Customer Deln Flag 215 is Do not delete
258900200604     C     WDS2015       IFEQ      'F'
259000200604     C                   MOVEL     'N'           OKCUST
259100200604     C                   ADD       1             Ix
259200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
259300200604     C                   MOVEL     'USR2225'     MsgIdArr(Ix)
259400200604     C                   GOTO      EVALAD
259500200604     C                   END
259600200604      * Depot customer has a reversed depot movement defined on DPTMVD.
259700200604      * CASE: WRK.Customer Deln Flag 216 is Do not delete
259800200604     C     WDS2016       IFEQ      'F'
259900200604     C                   MOVEL     'N'           OKCUST
260000200604     C                   ADD       1             Ix
260100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
260200200604     C                   MOVEL     'USR2226'     MsgIdArr(Ix)
260300200604     C                   GOTO      EVALAD
260400200604     C                   END
260500200604      * Customer has a reversed depot movement defined on DPTMVD.
260600200604      * CASE: WRK.Customer Deln Flag 217 is Do not delete
260700200604     C     WDS2017       IFEQ      'F'
260800200604     C                   MOVEL     'N'           OKCUST
260900200604     C                   ADD       1             Ix
261000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
261100200604     C                   MOVEL     'USR2227'     MsgIdArr(Ix)
261200200604     C                   GOTO      EVALAD
261300200604     C                   END
261400200604      * Customer defined on SECTYD.
261500200604      * CASE: WRK.Customer Deln Flag 225 is Do not delete
261600200604     C     WDS2025       IFEQ      'F'
261700200604     C                   MOVEL     'N'           OKCUST
261800200604     C                   ADD       1             Ix
261900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
262000200604     C                   MOVEL     'USR2077'     MsgIdArr(Ix)
262100200604     C                   GOTO      EVALAD
262200200604     C                   END
262300200604      * Customer defined on TRADSD.
262400200604      * CASE: WRK.Customer Deln Flag 221 is Do not delete
262500200604     C     WDS2021       IFEQ      'F'
262600200604     C                   MOVEL     'N'           OKCUST
262700200604     C                   ADD       1             Ix
262800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
262900200604     C                   MOVEL     'USR2076'     MsgIdArr(Ix)
263000200604     C                   GOTO      EVALAD
263100200604     C                   END
263200200604      * Depot customer defined on TRADSD.
263300200604      * CASE: WRK.Customer Deln Flag 222 is Do not delete
263400200604     C     WDS2022       IFEQ      'F'
263500200604     C                   MOVEL     'N'           OKCUST
263600200604     C                   ADD       1             Ix
263700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
263800200604     C                   MOVEL     'USR2219'     MsgIdArr(Ix)
263900200604     C                   GOTO      EVALAD
264000200604     C                   END
264100200604      * Customer defined on HSTTRD.
264200200604      * CASE: WRK.Customer Deln Flag 219 is Do not delete
264300200604     C     WDS2019       IFEQ      'F'
264400200604     C                   MOVEL     'N'           OKCUST
264500200604     C                   ADD       1             Ix
264600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
264700200604     C                   MOVEL     'USR2228'     MsgIdArr(Ix)
264800200604     C                   GOTO      EVALAD
264900200604     C                   END
265000200604      * Depot customer defined on HSTTRD.
265100200604      * CASE: WRK.Customer Deln Flag 220 is Do not delete
265200200604     C     WDS2020       IFEQ      'F'
265300200604     C                   MOVEL     'N'           OKCUST
265400200604     C                   ADD       1             Ix
265500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
265600200604     C                   MOVEL     'USR2229'     MsgIdArr(Ix)
265700200604     C                   GOTO      EVALAD
265800200604     C                   END
265900200604      * Customer defined on investment type INVTPD.
266000200604      * CASE: WRK.Customer Deln Flag 223 is Do not delete
266100200604     C     WDS2023       IFEQ      'F'
266200200604     C                   MOVEL     'N'           OKCUST
266300200604     C                   ADD       1             Ix
266400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
266500200604     C                   MOVEL     'USR2230'     MsgIdArr(Ix)
266600200604     C                   GOTO      EVALAD
266700200604     C                   END
266800200604      * Customer has a position settlement on POSETD.
266900200604      * CASE: WRK.Customer Deln Flag 224 is Do not delete
267000200604     C     WDS2024       IFEQ      'F'
267100200604     C                   MOVEL     'N'           OKCUST
267200200604     C                   ADD       1             Ix
267300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
267400200604     C                   MOVEL     'USR2231'     MsgIdArr(Ix)
267500200604     C                   GOTO      EVALAD
267600200604     C                   END
267700200604      * Customer has a security limit on SLIMH.
267800200604      * CASE: WRK.Customer Deln Flag 226 is Do not delete
267900200604     C     WDS2026       IFEQ      'F'
268000200604     C                   MOVEL     'N'           OKCUST
268100200604     C                   ADD       1             Ix
268200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
268300200604     C                   MOVEL     'USR2232'     MsgIdArr(Ix)
268400200604     C                   GOTO      EVALAD
268500200604     C                   END
268600200604      * Customer has a standard settlement defined on STDSED.
268700200604      * CASE: WRK.Customer Deln Flag 227 is Do not delete
268800200604     C     WDS2027       IFEQ      'F'
268900200604     C                   MOVEL     'N'           OKCUST
269000200604     C                   ADD       1             Ix
269100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
269200200604     C                   MOVEL     'USR2233'     MsgIdArr(Ix)
269300200604     C                   GOTO      EVALAD
269400200604     C                   END
269500200604      * Depot customer defined on a standard settlement on STDSED.
269600200604      * CASE: WRK.Customer Deln Flag 228 is Do not delete
269700200604     C     WDS2028       IFEQ      'F'
269800200604     C                   MOVEL     'N'           OKCUST
269900200604     C                   ADD       1             Ix
270000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
270100200604     C                   MOVEL     'USR2234'     MsgIdArr(Ix)
270200200604     C                   GOTO      EVALAD
270300200604     C                   END
270400200604      * Customer has user positions defined on UDEPPD.
270500200604      * CASE: WRK.Customer Deln Flag 229 is Do not delete
270600200604     C     WDS2029       IFEQ      'F'
270700200604     C                   MOVEL     'N'           OKCUST
270800200604     C                   ADD       1             Ix
270900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
271000200604     C                   MOVEL     'USR2235'     MsgIdArr(Ix)
271100200604     C                   GOTO      EVALAD
271200200604     C                   END
271300200604      * DEALING CHECKS:
271400200604      * Customer defined on CUSDL.
271500200604      * CASE: WRK.Customer Deln Flag 202 is Do not delete
271600200604     C     WDS2002       IFEQ      'F'
271700200604     C                   MOVEL     'N'           OKCUST
271800200604     C                   ADD       1             Ix
271900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
272000200604     C                   MOVEL     'USR1878'     MsgIdArr(Ix)
272100200604     C                   GOTO      EVALAD
272200200604     C                   END
272300200604      * CUSTOMER LENDING CHECKS:
272400200604      * Customer defined on FACIL.
272500200604      * CASE: WRK.Customer Deln Flag 203 is Do not delete
272600200604     C     WDS2003       IFEQ      'F'
272700200604     C                   MOVEL     'N'           OKCUST
272800200604     C                   ADD       1             Ix
272900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
273000200604     C                   MOVEL     'USR1116'     MsgIdArr(Ix)
273100200604     C                   GOTO      EVALAD
273200200604     C                   END
273300200604      * Customer has a live facility defined on FCLTY.
273400200604      * CASE: WRK.Customer Deln Flag 204 is Do not delete
273500200604      * Customer has a reversed facility defined on FCLTY.
273600200604     C     WDS2004       IFEQ      'F'
273700200604     C                   MOVEL     'N'           OKCUST
273800200604     C                   ADD       1             Ix
273900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
274000200604     C                   MOVEL     'USR1118'     MsgIdArr(Ix)
274100200604     C                   GOTO      EVALAD
274200200604     C                   END
274300200604      * Customer has a reversed facility defined on FCLTY.
274400200604      * CASE: WRK.Customer Deln Flag 207 is Do not delete
274500200604     C     WDS2007       IFEQ      'F'
274600200604     C                   MOVEL     'N'           OKCUST
274700200604     C                   ADD       1             Ix
274800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
274900200604     C                   MOVEL     'USR2220'     MsgIdArr(Ix)
275000200604     C                   GOTO      EVALAD
275100200604     C                   END
275200200604      * Customer has a closed facility defined on FCLTY.
275300200604      * CASE: WRK.Customer Deln Flag 208 is Do not delete
275400200604     C     WDS2008       IFEQ      'F'
275500200604     C                   MOVEL     'N'           OKCUST
275600200604     C                   ADD       1             Ix
275700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
275800200604     C                   MOVEL     'USR2221'     MsgIdArr(Ix)
275900200604     C                   GOTO      EVALAD
276000200604     C                   END
276100200604      * Customer has an expired facility defined on FCLTY.
276200200604      * CASE: WRK.Customer Deln Flag 209 is Do not delete
276300200604     C     WDS2009       IFEQ      'F'
276400200604     C                   MOVEL     'N'           OKCUST
276500200604     C                   ADD       1             Ix
276600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
276700200604     C                   MOVEL     'USR2222'     MsgIdArr(Ix)
276800200604     C                   GOTO      EVALAD
276900200604     C                   END
277000200604      * Customer defined on GTEES.
277100200604      * CASE: WRK.Customer Deln Flag 205 is Do not delete
277200200604      * Customer defined on LEREF.
277300200604     C     WDS2005       IFEQ      'F'
277400200604     C                   MOVEL     'N'           OKCUST
277500200604     C                   ADD       1             Ix
277600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
277700200604     C                   MOVEL     'USR1124'     MsgIdArr(Ix)
277800200604     C                   GOTO      EVALAD
277900200604     C                   END
278000200604      * Customer defined on LEREF.
278100200604      * CASE: WRK.Customer Deln Flag 206 is Do not delete
278200200604     C     WDS2006       IFEQ      'F'
278300200604     C                   MOVEL     'N'           OKCUST
278400200604     C                   ADD       1             Ix
278500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
278600200604     C                   MOVEL     'USR1122'     MsgIdArr(Ix)
278700200604     C                   GOTO      EVALAD
278800200604     C                   END
278900200604      * Customer defined on CLOANCL.
279000200604      * CASE: WRK.Customer Deln Flag 230 is Do not delete
279100200604     C     WDS2030       IFEQ      'F'
279200200604     C                   MOVEL     'N'           OKCUST
279300200604     C                   ADD       1             Ix
279400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
279500200604     C                   MOVEL     'USR2237'     MsgIdArr(Ix)
279600200604     C                   GOTO      EVALAD
279700200604     C                   END
279800200604      * EXPOSURE MANAGEMENT CHECKS:
279900200604      * Customer defined on EMLIML2.
280000200604      * CASE: WRK.Customer Deln Flag 212 is Do not delete
280100200604     C     WDS2012       IFEQ      'F'
280200200604     C                   MOVEL     'N'           OKCUST
280300200604     C                   ADD       1             Ix
280400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
280500200604     C                   MOVEL     'USR2238'     MsgIdArr(Ix)
280600200604     C                   GOTO      EVALAD
280700200604     C                   END
280800200604      * STANDING DATA CHECKS:
280900200604      * Customer defined on SDBANKPD.
281000200604      * CASE: WRK.Customer Deln Flag 002 is Do not delete
281100200604     C     WDS1002       IFEQ      'F'
281200200604     C                   MOVEL     'N'           OKCUST
281300200604     C                   ADD       1             Ix
281400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
281500200604     C                   MOVEL     'USR1110'     MsgIdArr(Ix)
281600200604     C                   GOTO      EVALAD
281700200604     C                   END
281800200604      * Customer defined on SDBRCHPD.
281900200604      * CASE: WRK.Customer Deln Flag 003 is Do not delete
282000200604     C     WDS1003       IFEQ      'F'
282100200604     C                   MOVEL     'N'           OKCUST
282200200604     C                   ADD       1             Ix
282300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
282400200604     C                   MOVEL     'USR1115'     MsgIdArr(Ix)
282500200604     C                   GOTO      EVALAD
282600200604     C                   END
282700200604      *                                                                                       198304
282800200604      ** CASE: WRK.Customer Deln Flag 043 is Do not delete                                    198304
282900200604      *                                                                                       198304
283000200604     C     WDS1043       IFEQ      'F'                                                        198304
283100200604     C                   MOVEL     'N'           OKCUST                                       198304
283200200604     C                   ADD       1             Ix                                           198304
283300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               198304
283400200604     C                   MOVEL     'USR3966'     MsgIdArr(Ix)                                 198304
283500200604     C                   GOTO      EVALAD                                                     198304
283600200604     C                   ENDIF                                                                198304
283700200604      *                                                                                       198304
283800200604      * Customer defined on SDCLLMPD.
283900200604      * CASE: WRK.Customer Deln Flag 027 is Do not delete
284000200604     C     WDS1027       IFEQ      'F'
284100200604     C                   MOVEL     'N'           OKCUST
284200200604     C                   ADD       1             Ix
284300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
284400200604     C                   MOVEL     'USR2223'     MsgIdArr(Ix)
284500200604     C                   GOTO      EVALAD
284600200604     C                   END
284700200604      * Customer defined as a parent on SDCUSTPD.
284800200604      * CASE: WRK.Customer Deln Flag 006 is Do not delete
284900200604     C     WDS1006       IFEQ      'F'
285000200604     C                   MOVEL     'N'           OKCUST
285100200604     C                   ADD       1             Ix
285200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
285300200604     C                   MOVEL     'USR1114'     MsgIdArr(Ix)
285400200604     C                   GOTO      EVALAD
285500200604     C                   END
285600200604      * Customer defined on SDDEALPD.
285700200604      * CASE: WRK.Customer Deln Flag 007 is Do not delete
285800200604     C     WDS1007       IFEQ      'F'
285900200604     C                   MOVEL     'N'           OKCUST
286000200604     C                   ADD       1             Ix
286100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
286200200604     C                   MOVEL     'USR1111'     MsgIdArr(Ix)
286300200604     C                   GOTO      EVALAD
286400200604     C                   END
286500200604      * Customer has extended settlements defined on SDEXSTPD.
286600200604      * CASE: WRK.Customer Deln Flag 008 is Do not delete
286700200604     C     WDS1008       IFEQ      'F'
286800200604     C                   MOVEL     'N'           OKCUST
286900200604     C                   ADD       1             Ix
287000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
287100200604     C                   MOVEL     'USR1125'     MsgIdArr(Ix)
287200200604     C                   GOTO      EVALAD
287300200604     C                   END
287400200604      * Customer is receipt ordering customer on SDEXSTPD.
287500200604      * CASE: WRK.Customer Deln Flag 009 is Do not delete
287600200604     C     WDS1009       IFEQ      'F'
287700200604     C                   MOVEL     'N'           OKCUST
287800200604     C                   ADD       1             Ix
287900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
288000200604     C                   MOVEL     'USR1127'     MsgIdArr(Ix)
288100200604     C                   GOTO      EVALAD
288200200604     C                   END
288300200604      * Customer is receipt ordering bank on SDEXSTPD.
288400200604      * CASE: WRK.Customer Deln Flag 010 is Do not delete
288500200604     C     WDS1010       IFEQ      'F'
288600200604     C                   MOVEL     'N'           OKCUST
288700200604     C                   ADD       1             Ix
288800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
288900200604     C                   MOVEL     'USR1126'     MsgIdArr(Ix)
289000200604     C                   GOTO      EVALAD
289100200604     C                   END
289200200604      * Customer is receipt intermediary bank on SDEXSTPD.
289300200604      * CASE: WRK.Customer Deln Flag 011 is Do not delete
289400200604     C     WDS1011       IFEQ      'F'
289500200604     C                   MOVEL     'N'           OKCUST
289600200604     C                   ADD       1             Ix
289700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
289800200604     C                   MOVEL     'USR1128'     MsgIdArr(Ix)
289900200604     C                   GOTO      EVALAD
290000200604     C                   END
290100200604      * Customer is pay ordering customer on SDEXSTPD.
290200200604      * CASE: WRK.Customer Deln Flag 012 is Do not delete
290300200604     C     WDS1012       IFEQ      'F'
290400200604     C                   MOVEL     'N'           OKCUST
290500200604     C                   ADD       1             Ix
290600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
290700200604     C                   MOVEL     'USR1130'     MsgIdArr(Ix)
290800200604     C                   GOTO      EVALAD
290900200604     C                   END
291000200604      * Customer is pay ordering bank on SDEXSTPD.
291100200604      * CASE: WRK.Customer Deln Flag 013 is Do not delete
291200200604     C     WDS1013       IFEQ      'F'
291300200604     C                   MOVEL     'N'           OKCUST
291400200604     C                   ADD       1             Ix
291500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
291600200604     C                   MOVEL     'USR1129'     MsgIdArr(Ix)
291700200604     C                   GOTO      EVALAD
291800200604     C                   END
291900200604      * Customer is pay intermediary bank on SDEXSTPD.
292000200604      * CASE: WRK.Customer Deln Flag 014 is Do not delete
292100200604     C     WDS1014       IFEQ      'F'
292200200604     C                   MOVEL     'N'           OKCUST
292300200604     C                   ADD       1             Ix
292400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
292500200604     C                   MOVEL     'USR1131'     MsgIdArr(Ix)
292600200604     C                   GOTO      EVALAD
292700200604     C                   END
292800200604      * Customer is receiver correspondant on SDEXSTPD.
292900200604      * CASE: WRK.Customer Deln Flag 015 is Do not delete
293000200604     C     WDS1015       IFEQ      'F'
293100200604     C                   MOVEL     'N'           OKCUST
293200200604     C                   ADD       1             Ix
293300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
293400200604     C                   MOVEL     'USR1132'     MsgIdArr(Ix)
293500200604     C                   GOTO      EVALAD
293600200604     C                   END
293700200604      * Customer is receiver number on SDEXSTPD.
293800200604      * CASE: WRK.Customer Deln Flag 016 is Do not delete
293900200604     C     WDS1016       IFEQ      'F'
294000200604     C                   MOVEL     'N'           OKCUST
294100200604     C                   ADD       1             Ix
294200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
294300200604     C                   MOVEL     'USR1133'     MsgIdArr(Ix)
294400200604     C                   GOTO      EVALAD
294500200604     C                   END
294600200604      * Customer is an account with Bank on SDEXSTPD.
294700200604      * CASE: WRK.Customer Deln Flag 017 is Do not delete
294800200604     C     WDS1017       IFEQ      'F'
294900200604     C                   MOVEL     'N'           OKCUST
295000200604     C                   ADD       1             Ix
295100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
295200200604     C                   MOVEL     'USR1134'     MsgIdArr(Ix)
295300200604     C                   GOTO      EVALAD
295400200604     C                   END
295500200604      * Customer is a beneficiary number on SDEXSTPD.
295600200604      * CASE: WRK.Customer Deln Flag 018 is Do not delete
295700200604     C     WDS1018       IFEQ      'F'
295800200604     C                   MOVEL     'N'           OKCUST
295900200604     C                   ADD       1             Ix
296000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
296100200604     C                   MOVEL     'USR1135'     MsgIdArr(Ix)
296200200604     C                   GOTO      EVALAD
296300200604     C                   END
296400200604      * Customer is our receive nostro on SDEXSTPD.
296500200604      * CASE: WRK.Customer Deln Flag 019 is Do not delete
296600200604     C     WDS1019       IFEQ      'F'
296700200604     C                   MOVEL     'N'           OKCUST
296800200604     C                   ADD       1             Ix
296900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
297000200604     C                   MOVEL     'USR1531'     MsgIdArr(Ix)
297100200604     C                   GOTO      EVALAD
297200200604     C                   END
297300200604      * Customer is our payment nostro on SDEXSTPD.
297400200604      * CASE: WRK.Customer Deln Flag 020 is Do not delete
297500200604     C     WDS1020       IFEQ      'F'
297600200604     C                   MOVEL     'N'           OKCUST
297700200604     C                   ADD       1             Ix
297800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
297900200604     C                   MOVEL     'USR1532'     MsgIdArr(Ix)
298000200604     C                   GOTO      EVALAD
298100200604     C                   END
298200200604      * Customer is the EUROCLEAR customer on SDSTRDPD.
298300200604      * CASE: WRK.Customer Deln Flag 023 is Do not delete
298400200604     C     WDS1023       IFEQ      'F'
298500200604     C                   MOVEL     'N'           OKCUST
298600200604     C                   ADD       1             Ix
298700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
298800200604     C                   MOVEL     'USR1100'     MsgIdArr(Ix)
298900200604     C                   GOTO      EVALAD
299000200604     C                   END
299100200604      * Customer is the CEDEL customer on SDSTRDPD.
299200200604      * CASE: WRK.Customer Deln Flag 024 is Do not delete
299300200604     C     WDS1024       IFEQ      'F'
299400200604     C                   MOVEL     'N'           OKCUST
299500200604     C                   ADD       1             Ix
299600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
299700200604     C                   MOVEL     'USR1101'     MsgIdArr(Ix)
299800200604     C                   GOTO      EVALAD
299900200604     C                   END
300000200604      * Customer is the KASSENVEREIN customer on SDSTRDPD.
300100200604      * CASE: WRK.Customer Deln Flag 025 is Do not delete
300200200604     C     WDS1025       IFEQ      'F'
300300200604     C                   MOVEL     'N'           OKCUST
300400200604     C                   ADD       1             Ix
300500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
300600200604     C                   MOVEL     'USR1102'     MsgIdArr(Ix)
300700200604     C                   GOTO      EVALAD
300800200604     C                   END
300900200604      * Customer is the Depot 4 customer on SDSTRDPD.
301000200604      * CASE: WRK.Customer Deln Flag 026 is Do not delete
301100200604     C     WDS1026       IFEQ      'F'
301200200604     C                   MOVEL     'N'           OKCUST
301300200604     C                   ADD       1             Ix
301400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
301500200604     C                   MOVEL     'USR1103'     MsgIdArr(Ix)
301600200604     C                   GOTO      EVALAD
301700200604     C                   END
301800200604      * Customer is the Depot 5 customer on SDSTRDPD.
301900200604      * CASE: WRK.Customer Deln Flag 028 is Do not delete
302000200604     C     WDS1028       IFEQ      'F'
302100200604     C                   MOVEL     'N'           OKCUST
302200200604     C                   ADD       1             Ix
302300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
302400200604     C                   MOVEL     'USR1104'     MsgIdArr(Ix)
302500200604     C                   GOTO      EVALAD
302600200604     C                   END
302700200604      * Customer is the Depot 6 customer on SDSTRDPD.
302800200604      * CASE: WRK.Customer Deln Flag 029 is Do not delete
302900200604     C     WDS1029       IFEQ      'F'
303000200604     C                   MOVEL     'N'           OKCUST
303100200604     C                   ADD       1             Ix
303200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
303300200604     C                   MOVEL     'USR1105'     MsgIdArr(Ix)
303400200604     C                   GOTO      EVALAD
303500200604     C                   END
303600200604      * Customer is the Depot 7 customer on SDSTRDPD.
303700200604      * CASE: WRK.Customer Deln Flag 030 is Do not delete
303800200604     C     WDS1030       IFEQ      'F'
303900200604     C                   MOVEL     'N'           OKCUST
304000200604     C                   ADD       1             Ix
304100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
304200200604     C                   MOVEL     'USR1106'     MsgIdArr(Ix)
304300200604     C                   GOTO      EVALAD
304400200604     C                   END
304500200604      * Customer is the Depot 8 customer on SDSTRDPD.
304600200604      * CASE: WRK.Customer Deln Flag 031 is Do not delete
304700200604     C     WDS1031       IFEQ      'F'
304800200604     C                   MOVEL     'N'           OKCUST
304900200604     C                   ADD       1             Ix
305000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
305100200604     C                   MOVEL     'USR1107'     MsgIdArr(Ix)
305200200604     C                   GOTO      EVALAD
305300200604     C                   END
305400200604      * Customer is the Depot 9 customer on SDSTRDPD.
305500200604      * CASE: WRK.Customer Deln Flag 032 is Do not delete
305600200604     C     WDS1032       IFEQ      'F'
305700200604     C                   MOVEL     'N'           OKCUST
305800200604     C                   ADD       1             Ix
305900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
306000200604     C                   MOVEL     'USR1108'     MsgIdArr(Ix)
306100200604     C                   GOTO      EVALAD
306200200604     C                   END
306300200604      * Customer is the Depot 10 customer on SDSTRDPD.
306400200604      * CASE: WRK.Customer Deln Flag 033 is Do not delete
306500200604     C     WDS1033       IFEQ      'F'
306600200604     C                   MOVEL     'N'           OKCUST
306700200604     C                   ADD       1             Ix
306800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
306900200604     C                   MOVEL     'USR1109'     MsgIdArr(Ix)
307000200604     C                   GOTO      EVALAD
307100200604     C                   END
307200200604      * Customer is a Leo customer on SDCLEOPD.
307300200604      * CASE: WRK.Customer Deln Flag 036 is Do not delete
307400200604     C     WDS1036       IFEQ      'F'
307500200604     C                   MOVEL     'N'           OKCUST
307600200604     C                   ADD       1             Ix
307700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
307800200604     C                   MOVEL     'USR2371'     MsgIdArr(Ix)
307900200604     C                   GOTO      EVALAD
308000200604     C                   END
308100200604      * F8 FUNCTION CHECKS:
308200200604      * Customer defined on SDACUSPD.
308300200604      * CASE: WRK.Customer Deln Flag 001 is Do not delete
308400200604     C     WDS1001       IFEQ      'F'
308500200604     C                   MOVEL     'N'           OKCUST
308600200604     C                   ADD       1             Ix
308700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
308800200604     C                   MOVEL     'USR1939'     MsgIdArr(Ix)
308900200604     C                   GOTO      EVALAD
309000200604     C                   END
309100200604      * Customer defined on SDCFCDPD.
309200200604      * CASE: WRK.Customer Deln Flag 004 is Do not delete
309300200604     C     WDS1004       IFEQ      'F'
309400200604     C                   MOVEL     'N'           OKCUST
309500200604     C                   ADD       1             Ix
309600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
309700200604     C                   MOVEL     'USR1940'     MsgIdArr(Ix)
309800200604     C                   GOTO      EVALAD
309900200604     C                   END
310000200604      * Customer defined on SDCMRKPD.
310100200604      * CASE: WRK.Customer Deln Flag 005 is Do not delete
310200200604     C     WDS1005       IFEQ      'F'
310300200604     C                   MOVEL     'N'           OKCUST
310400200604     C                   ADD       1             Ix
310500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
310600200604     C                   MOVEL     'USR1563'     MsgIdArr(Ix)
310700200604     C                   GOTO      EVALAD
310800200604     C                   END
310900200604      * Customer defined on SDFOCSPD.
311000200604      * CASE: WRK.Customer Deln Flag 021 is Do not delete
311100200604     C     WDS1021       IFEQ      'F'
311200200604     C                   MOVEL     'N'           OKCUST
311300200604     C                   ADD       1             Ix
311400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
311500200604     C                   MOVEL     'USR1113'     MsgIdArr(Ix)
311600200604     C                   GOTO      EVALAD
311700200604     C                   END
311800200604                                                                                            MD042652
311900200604      ** Customer is attached to an instrument type.                                        MD042652
312000200604     C     WDS1045       IFEQ      'F'                                                      MD042652
312100200604     C                   MOVEL     'N'           OKCUST                                     MD042652
312200200604     C                   ADD       1             Ix                                         MD042652
312300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                             MD042652
312400200604     C                   MOVEL     'USS0568'     MsgIDArr(Ix)                               MD042652
312500200604     C                   GOTO      EVALAD                                                   MD042652
312600200604     C                   ENDIF                                                              MD042652
312700200604                                                                                              CRN001
312800200604      * Regulatory Reporting checks:                                                          CRN001
312900200604      * Record exists on sdcustxb.                                                            CRN001
313000200604     C     WDS1044       IFEQ      'F'                                                        CRN001
313100200604     C                   MOVEL     'N'           OKCUST                                       CRN001
313200200604     C                   ADD       1             Ix                                           CRN001
313300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CRN001
313400200604     C                   MOVEL     'USR4050'     MsgIdArr(Ix)                                 CRN001
313500200604     C                   GOTO      EVALAD                                                     CRN001
313600200604     C                   END                                                                  CRN001
313700200604                                                                                              CRN001
313800200604      * Customer defined on SDSECSPD.
313900200604      * CASE: WRK.Customer Deln Flag 022 is Do not delete
314000200604     C     WDS1022       IFEQ      'F'
314100200604     C                   MOVEL     'N'           OKCUST
314200200604     C                   ADD       1             Ix
314300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
314400200604     C                   MOVEL     'USR1112'     MsgIdArr(Ix)
314500200604     C                   GOTO      EVALAD
314600200604     C                   END
314700200604      * Customer is a Portfolio Lending customer on SDLBCSPD.
314800200604      * CASE: WRK.Customer Deln Flag 035 is Do not delete
314900200604     C     WDS1035       IFEQ      'F'
315000200604     C                   MOVEL     'N'           OKCUST
315100200604     C                   ADD       1             Ix
315200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
315300200604     C                   MOVEL     'USR2373'     MsgIdArr(Ix)
315400200604     C                   GOTO      EVALAD
315500200604     C                   END
315600200604      * Customer is a Portfolio Management customer on SDPLCSPD.
315700200604      * CASE: WRK.Customer Deln Flag 034 is Do not delete
315800200604     C     WDS1034       IFEQ      'F'
315900200604     C                   MOVEL     'N'           OKCUST
316000200604     C                   ADD       1             Ix
316100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
316200200604     C                   MOVEL     'USR2372'     MsgIdArr(Ix)
316300200604     C                   GOTO      EVALAD
316400200604     C                   END
316500200604      * User Defined Correspondence
316600200604      * CASE: WRK.Customer Deln Flag 218 is Do not delete
316700200604     C     WDS2018       IFEQ      'F'
316800200604     C                   MOVEL     'N'           OKCUST
316900200604     C                   ADD       1             Ix
317000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
317100200604     C                   MOVEL     'USR2618'     MsgIdArr(Ix)
317200200604     C                   GOTO      EVALAD
317300200604     C                   END
317400200604      * Customer has Credit Card details defined on SDCCRDPD.
317500200604      * CASE: WRK.Customer Deln Flag 037 is Do not delete
317600200604     C     WDS1037       IFEQ      'F'
317700200604     C                   MOVEL     'N'           OKCUST
317800200604     C                   ADD       1             Ix
317900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
318000200604     C                   MOVEL     'USR3043'     MsgIdArr(Ix)
318100200604     C                   GOTO      EVALAD
318200200604     C                   END
318300200604      * Customer has Power of Attorney details defined on SDPATTPD.
318400200604      * CASE: WRK.Customer Deln Flag 038 is Do not delete
318500200604     C     WDS1038       IFEQ      'F'
318600200604     C                   MOVEL     'N'           OKCUST
318700200604     C                   ADD       1             Ix
318800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
318900200604     C                   MOVEL     'USR3044'     MsgIdArr(Ix)
319000200604     C                   GOTO      EVALAD
319100200604     C                   END
319200200604      * Customer has Joint A/c Holder details defined on SDJUSRPD.
319300200604      * CASE: WRK.Customer Deln Flag 039 is Do not delete
319400200604     C     WDS1039       IFEQ      'F'
319500200604     C                   MOVEL     'N'           OKCUST
319600200604     C                   ADD       1             Ix
319700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
319800200604     C                   MOVEL     'USR3045'     MsgIdArr(Ix)
319900200604     C                   GOTO      EVALAD
320000200604     C                   END
320100200604      * Customer has Related Customer Number details defined on SDRELCPD.
320200200604      * CASE: WRK.Customer Deln Flag 040 is Do not delete
320300200604     C     WDS1040       IFEQ      'F'
320400200604     C                   MOVEL     'N'           OKCUST
320500200604     C                   ADD       1             Ix
320600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
320700200604     C                   MOVEL     'USR3046'     MsgIdArr(Ix)
320800200604     C                   GOTO      EVALAD
320900200604     C                   END
321000200604      * Trade Innovation customers on SDTICSPD
321100200604      * CASE: WRK.Customer Deln Flag 041 is Do not delete
321200200604     C     WDS1041       IFEQ      'F'
321300200604     C                   MOVEL     'N'           OKCUST
321400200604     C                   ADD       1             Ix
321500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
321600200604     C                   MOVEL     'USR3538'     MsgIdArr(Ix)
321700200604     C                   GOTO      EVALAD
321800200604     C                   END
321900200604     C/COPY WNCPYSRC,SDCUSDIC09
322000200604      * End of change S01424 - Customer Deletion in COB.
322100200604      * Check to see if all the checks have been successfully completed.
322200200604      * CASE: WRK.Err Code is Error Found
322300200604     C     WUERCD        IFEQ      'Y'
322400200604     C                   MOVEL     'N'           OKCUST
322500200604     C                   ADD       1             Ix
322600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
322700200604     C                   MOVEL     'USR0152'     MsgIdArr(Ix)
322800200604     C                   GOTO      EVALAD
322900200604     C                   END
323000200604     C*
323100200604     C                   END
323200200604
323300200604     C     EVALAD        ENDSR
323400200604      *****************************************************************                       CSD007
323500200604      * VALACC - VALIDATION OF ACTION CODE 'C'                                                CSD007
323600200604      *****************************************************************                       CSD007
323700200604     C     VALACC        BEGSR                                                                CSD007
323800200604      *                                                                                       CSD007
323900200604     C     BBDTDL        IFNE      0                                                          CSD007
324000200604     C     BBCLST        OREQ      'Y'                                                        CSD007
324100200604     C                   MOVEL     'N'           OKACTN                                       CSD007
324200200604     C                   ADD       1             Ix                                           CSD007
324300200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CSD007
324400200604     C                   MOVEL     'USR0568'     MsgIdArr(Ix)                                 CSD007
324500200604     C                   ENDIF                                                                CSD007
324600200604      *                                                                                       CSD007
324700200604     C     BBCLST        IFNE      'Y'                                                        215524
324800200604     C                   CALL      'SD0010U'                                  Check for delet CSD007
324900200604     C                   PARM      DDCUSN        @CUST             6          Customer Number CSD007
325000200604     C                   PARM      *BLANK        @RTCD             7          *Return code    CSD007
325100200604     C                   PARM      *BLANK        @WCDS1          200          Customer Deln S CSD007
325200200604     C                   PARM      *BLANK        @WCDS2          200          Customer Deln S CSD007
325300200604     C                   PARM      *BLANK        @WCDS3          200                          253211
325400200604     C                   PARM      'N'           @WQUTP            1          Quit program on CSD007
325500200604     C                   PARM      'C'           @ACTN             1          Action Code     CSD007
325600200604      *                                                                                       CSD007
325700200604     C     @RTCD         IFNE      'DELETE'                                                   CSD007
325800200604     C                   MOVEL     'N'           OKCUST                                       CSD007
325900200604     C                   ADD       1             Ix                                           CSD007
326000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD007
326100200604     C*****              MOVEL     'USR0152'     MsgIdArr(Ix)                          CSD007 CSD023
326200200604     C*****WDS1001       IFEQ      'F'                                              BUG7233 MD052297
326300200604     C*****WDS2001       OREQ      'F'                                               253344 MD052297
326400200604     C*****CSD023        ANDEQ     'Y'                                                BUG7233 253344
326500200604     C*****CSD023        IFEQ      'Y'                                               253344 MD052297
326600200604     C**********         MOVEL     'USR9836'     MsgIdArr(Ix)                       BUG7233 MD052297
326700200604     C**********         ELSE                                                       BUG7233 MD052297
326800200604     C**********         MOVEL     'USR9834'     MsgIdArr(Ix)                        CSD023 MD052297
326900200604     C**********         ENDIF                                                      BUG7233 MD052297
327000200604     C**********         GOTO      EVALAC                                          MD019261 MD052297
327100200604     C**********         ENDIF                                                       253344 MD052297
327200200604      *                                                                                     MD052297
327300200604      ** GENERAL LEDGER CHECKS:                                                             MD052297
327400200604      ** Customer defined on ACCNT.                                                         MD052297
327500200604      ** CASE: WRK.Customer Deln Flag 201 is Do not close                                   MD052297
327600200604      *                                                                                     MD052297
327700200604     C     WDS2001       IFEQ      'F'                                                      MD052297
327800200604     C     CSD023        IFEQ      'Y'                                                      MD052297
327900200604     C                   MOVEL     'USR9836'     MsgIdArr(Ix)                               MD052297
328000200604     C                   ELSE                                                               MD052297
328100200604     C                   MOVEL     '5049318'     MsgIdArr(Ix)                               MD052297
328200200604     C                   ENDIF                                                              MD052297
328300200604     C                   GOTO      EVALAC                                                   MD052297
328400200604     C                   ENDIF                                                              MD052297
328500200604      *                                                                                     MD052297
328600200604      ** Customer has a retail account closed today.                                        MD052297
328700200604      ** CASE: WRK.Customer Deln Flag 211 is Do not close                                   MD052297
328800200604      *                                                                                     MD052297
328900200604     C     WDS2011       IFEQ      'F'                                                      MD052297
329000200604     C                   MOVEL     '5049332'     MsgIdArr(Ix)                               MD052297
329100200604     C                   GOTO      EVALAC                                                   MD052297
329200200604     C                   ENDIF                                                              MD052297
329300200604      *                                                                                     MD052297
329400200604      ** SECURITIES TRADING CHECKS:                                                         MD052297
329500200604      ** Customer defined on CDEPPD.                                                        MD052297
329600200604      ** CASE: WRK.Customer Deln Flag 213 is Do not close                                   MD052297
329700200604      *                                                                                     MD052297
329800200604     C     WDS2013       IFEQ      'F'                                                      MD052297
329900200604     C                   MOVEL     '5049319'     MsgIdArr(Ix)                               MD052297
330000200604     C                   GOTO      EVALAC                                                   MD052297
330100200604     C                   ENDIF                                                              MD052297
330200200604      *                                                                                     MD052297
330300200604      ** Depot customer has a live depot movement defined on DPTMVD.                        MD052297
330400200604      ** CASE: WRK.Customer Deln Flag 214 is Do not close                                   MD052297
330500200604      *                                                                                     MD052297
330600200604     C     WDS2014       IFEQ      'F'                                                      MD052297
330700200604     C                   MOVEL     '5049320'     MsgIdArr(Ix)                               MD052297
330800200604     C                   GOTO      EVALAC                                                   MD052297
330900200604     C                   ENDIF                                                              MD052297
331000200604      *                                                                                     MD052297
331100200604      ** Customer has a live depot movement defined on DPTMVD.                              MD052297
331200200604      ** CASE: WRK.Customer Deln Flag 215 is Do not close                                   MD052297
331300200604      *                                                                                     MD052297
331400200604     C     WDS2015       IFEQ      'F'                                                      MD052297
331500200604     C                   MOVEL     '5049321'     MsgIdArr(Ix)                               MD052297
331600200604     C                   GOTO      EVALAC                                                   MD052297
331700200604     C                   ENDIF                                                              MD052297
331800200604      *                                                                                     MD052297
331900200604      ** Depot customer has a reversed depot movement defined on                            MD052297
332000200604      ** DPTMVD.                                                                            MD052297
332100200604      ** CASE: WRK.Customer Deln Flag 216 is Do not close                                   MD052297
332200200604      *                                                                                     MD052297
332300200604     C     WDS2016       IFEQ      'F'                                                      MD052297
332400200604     C                   MOVEL     '5049322'     MsgIdArr(Ix)                               MD052297
332500200604     C                   GOTO      EVALAC                                                   MD052297
332600200604     C                   ENDIF                                                              MD052297
332700200604      *                                                                                     MD052297
332800200604      ** Customer has a reversed depot movement defined on DPTMVD.                          MD052297
332900200604      ** CASE: WRK.Customer Deln Flag 217 is Do not close                                   MD052297
333000200604      *                                                                                     MD052297
333100200604     C     WDS2017       IFEQ      'F'                                                      MD052297
333200200604     C                   MOVEL     '5049323'     MsgIdArr(Ix)                               MD052297
333300200604     C                   GOTO      EVALAC                                                   MD052297
333400200604     C                   ENDIF                                                              MD052297
333500200604      *                                                                                     MD052297
333600200604      ** Customer defined on SECTYD.                                                        MD052297
333700200604      ** CASE: WRK.Customer Deln Flag 225 is Do not close                                   MD052297
333800200604      *                                                                                     MD052297
333900200604     C     WDS2025       IFEQ      'F'                                                      MD052297
334000200604     C                   MOVEL     '5049324'     MsgIdArr(Ix)                               MD052297
334100200604     C                   GOTO      EVALAC                                                   MD052297
334200200604     C                   ENDIF                                                              MD052297
334300200604      *                                                                                     MD052297
334400200604      ** Customer has user positions defined on UDEPPD.                                     MD052297
334500200604      ** CASE: WRK.Customer Deln Flag 229 is Do not close                                   MD052297
334600200604      *                                                                                     MD052297
334700200604     C     WDS2029       IFEQ      'F'                                                      MD052297
334800200604     C                   MOVEL     '5049328'     MsgIdArr(Ix)                               MD052297
334900200604     C                   GOTO      EVALAC                                                   MD052297
335000200604     C                   ENDIF                                                              MD052297
335100200604      *                                                                                     MD052297
335200200604      ** DEALING CHECKS:                                                                    MD052297
335300200604      ** Customer defined on CUSDL.                                                         MD052297
335400200604      ** CASE: WRK.Customer Deln Flag 202 is Do not close                                   MD052297
335500200604      *                                                                                     MD052297
335600200604     C     WDS2002       IFEQ      'F'                                                      MD052297
335700200604     C                   MOVEL     '5049329'     MsgIdArr(Ix)                               MD052297
335800200604     C                   GOTO      EVALAC                                                   MD052297
335900200604     C                   ENDIF                                                              MD052297
336000200604      *                                                                                     MD052297
336100200604      ** Customer defined on TRADSD.                                                        MD052297
336200200604      ** CASE: WRK.Customer Deln Flag 221 is Do not close                                   MD052297
336300200604      *                                                                                     MD052297
336400200604     C     WDS2021       IFEQ      'F'                                                      MD052297
336500200604     C                   MOVEL     '5049325'     MsgIdArr(Ix)                               MD052297
336600200604     C                   GOTO      EVALAC                                                   MD052297
336700200604     C                   ENDIF                                                              MD052297
336800200604      *                                                                                     MD052297
336900200604      ** Depot customer defined on TRADSD.                                                  MD052297
337000200604      ** CASE: WRK.Customer Deln Flag 222 is Do not close                                   MD052297
337100200604      *                                                                                     MD052297
337200200604     C     WDS2022       IFEQ      'F'                                                      MD052297
337300200604     C                   MOVEL     '5049326'     MsgIdArr(Ix)                               MD052297
337400200604     C                   GOTO      EVALAC                                                   MD052297
337500200604     C                   ENDIF                                                              MD052297
337600200604      *                                                                                     MD052297
337700200604      ** Customer has a position settlement on POSETD.                                      MD052297
337800200604      ** CASE: WRK.Customer Deln Flag 224 is Do not close                                   MD052297
337900200604      *                                                                                     MD052297
338000200604     C     WDS2024       IFEQ      'F'                                                      MD052297
338100200604     C                   MOVEL     '5049327'     MsgIdArr(Ix)                               MD052297
338200200604     C                   GOTO      EVALAC                                                   MD052297
338300200604     C                   ENDIF                                                              MD052297
338400200604      *                                                                                     MD019261
338500200604      ** Customer has at least one live facility defined.                                   MD019261
338600200604      *                                                                                     MD019261
338700200604     C     WDS2004       IFEQ      'F'                                                      MD019261
338800200604     C                   MOVEL     '5045920'     MsgIdArr(Ix)                               MD019261
338900200604     C                   GOTO      EVALAC                                                   MD019261
339000200604     C                   ENDIF                                                              MD019261
339100200604      *                                                                                     MD019261
339200200604      ** Customer has at least one reversed facility.                                       MD019261
339300200604      *                                                                                     MD019261
339400200604     C     WDS2007       IFEQ      'F'                                                      MD019261
339500200604     C                   MOVEL     '5045921'     MsgIdArr(Ix)                               MD019261
339600200604     C                   GOTO      EVALAC                                                   MD019261
339700200604     C                   ENDIF                                                              MD019261
339800200604      *                                                                                     MD019261
339900200604      ** Customer has at least one closed facility.                                         MD019261
340000200604      *                                                                                     MD019261
340100200604     C     WDS2008       IFEQ      'F'                                                      MD019261
340200200604     C                   MOVEL     '5045922'     MsgIdArr(Ix)                               MD019261
340300200604     C                   GOTO      EVALAC                                                   MD019261
340400200604     C                   ENDIF                                                              MD019261
340500200604      *                                                                                     MD019261
340600200604      ** Customer has at least one expired facility.                                        MD019261
340700200604      *                                                                                     MD019261
340800200604     C     WDS2009       IFEQ      'F'                                                      MD019261
340900200604     C                   MOVEL     '5045923'     MsgIdArr(Ix)                               MD019261
341000200604     C                   GOTO      EVALAC                                                   MD019261
341100200604     C                   ENDIF                                                              MD019261
341200200604      *                                                                                     MD050457
341300200604      ** Customer has a facility closed today.                                              MD050457
341400200604      ** CASE: WRK.Customer Deln Flag 210 is Do not close                                   MD050457
341500200604      *                                                                                     MD050457
341600200604     C     WDS2010       IFEQ      'F'                                                      MD050457
341700200604     C                   MOVEL     '5049259'     MsgIdArr(Ix)                               MD050457
341800200604     C                   GOTO      EVALAC                                                   MD050457
341900200604     C                   ENDIF                                                              MD050457
342000200604      *                                                                                     MD050457
342100200604      ** Customer defined on GTEES.                                                         MD050457
342200200604      ** CASE: WRK.Customer Deln Flag 205 is Do not delete                                  MD050457
342300200604      ** Customer defined on LEREF.                                                         MD050457
342400200604      *                                                                                     MD050457
342500200604     C     WDS2005       IFEQ      'F'                                                      MD050457
342600200604     C**********         MOVEL     'USR1124'     MsgIdArr(Ix)                      MD050457 MD052297
342700200604     C                   MOVEL     '5049330'     MsgIdArr(Ix)                               MD052297
342800200604     C                   GOTO      EVALAC                                                   MD050457
342900200604     C                   ENDIF                                                              MD050457
343000200604      *                                                                                     MD050457
343100200604      ** Customer defined on LEREF.                                                         MD050457
343200200604      ** CASE: WRK.Customer Deln Flag 206 is Do not delete                                  MD050457
343300200604      *                                                                                     MD050457
343400200604     C     WDS2006       IFEQ      'F'                                                      MD050457
343500200604     C                   MOVEL     '5049260'     MsgIdArr(Ix)                               MD050457
343600200604     C                   GOTO      EVALAC                                                   MD050457
343700200604     C                   ENDIF                                                              MD050457
343800200604      *                                                                                     MD050457
343900200604      ** Customer defined on CLOANCL.                                                       MD050457
344000200604      ** CASE: WRK.Customer Deln Flag 230 is Do not delete                                  MD050457
344100200604      *                                                                                     MD050457
344200200604     C     WDS2030       IFEQ      'F'                                                      MD050457
344300200604     C                   MOVEL     '5049261'     MsgIdArr(Ix)                               MD050457
344400200604     C                   GOTO      EVALAC                                                   MD050457
344500200604     C                   ENDIF                                                              MD050457
344600200604      *                                                                                     MD052425
344700200604      ** Customer defined on CLOANCL.OLNO                                                   MD052425
344800200604      *                                                                                     MD052425
344900200604     C     WDS2031       IFEQ      'F'                                                      MD052425
345000200604     C                   MOVEL     '5049228'     MsgIdArr(Ix)                               MD052425
345100200604     C                   GOTO      EVALAC                                                   MD052425
345200200604     C                   ENDIF                                                              MD052425
345300200604      *                                                                                     MD050457
345400200604      ** Customer defined on LEFEEDL1                                                       MD050457
345500200604      ** CASE: WRK.Customer Deln Flag 240 is Do not delete                                  MD050457
345600200604      *                                                                                     MD050457
345700200604     C     WDS2041       IFEQ      'F'                                                      MD050457
345800200604     C                   MOVEL     '5049262'     MsgIdArr(Ix)                               MD050457
345900200604     C                   GOTO      EVALAC                                                   MD050457
346000200604     C                   ENDIF                                                              MD050457
346100200604      *                                                                                     MD052297
346200200604      ** EXPOSURE MANAGEMENT CHECKS:                                                        MD052297
346300200604      ** Customer defined on EMLIML2.                                                       MD052297
346400200604      ** CASE: WRK.Customer Deln Flag 212 is Do not close                                   MD052297
346500200604      *                                                                                     MD052297
346600200604     C     WDS2012       IFEQ      'F'                                                      MD052297
346700200604     C                   MOVEL     '5049331'     MsgIdArr(Ix)                               MD052297
346800200604     C                   GOTO      EVALAC                                                   MD052297
346900200604     C                   ENDIF                                                              MD052297
347000200604      *                                                                                       246639
347100200604      ** Customer defined as a parent on SDCUSTPD.                                            246639
347200200604      ** CASE: WRK.Customer Deln Flag 006 is Do not delete                                    246639
347300200604      *                                                                                       246639
347400200604     C     WDS1006       IFEQ      'F'                                                        246639
347500200604     C                   MOVEL     'USR9472'     MsgIdArr(Ix)                                 246639
347600200604     C                   GOTO      EVALAC                                                     246639
347700200604     C                   ENDIF                                                                246639
347800200604     C                   ENDIF                                                                CSD007
347900200604     C                   ENDIF                                                                215524
348000200604      *                                                                                     MD052297
348100200604      ** Customer defined as an internal customer in SDBRCHPD                               MD052297
348200200604      ** CASE: If Customer Flag 045 is flagged, do not close.                               MD052297
348300200604      *                                                                                     MD052297
348400200604     C     WDS1045       IFEQ      'F'                                                      MD052297
348500200604     C                   MOVEL     '5049333'     MsgIdArr(Ix)                               MD052297
348600200604     C                   GOTO      EVALAC                                                   MD052297
348700200604     C                   ENDIF                                                              MD052297
348800200604      *                                                                                     MD052297
348900200604      ** Customer defined as a Syndicated Agent in SDBRCHPD                                 MD052297
349000200604      ** CASE: If Customer Flag 044 is flagged, do not close.                               MD052297
349100200604      *                                                                                     MD052297
349200200604     C     WDS1044       IFEQ      'F'                                                      MD052297
349300200604     C                   MOVEL     '5049334'     MsgIdArr(Ix)                               MD052297
349400200604     C                   GOTO      EVALAC                                                   MD052297
349500200604     C                   ENDIF                                                              MD052297
349600200604      *                                                                                       CSD007
349700200604      ** Issue Warning when a 'T'axable Customer is Closed                                  BUG23518
349800200604      *                                                                                     BUG23518
349900200604     C                   IF        WUERCD <> 'Y'                                            BUG23518
350000200604      *                                                                                     BUG23518
350100200604     C                   IF        CER048 = 'Y' AND DDACTN = 'C'                            BUG23518
350200200604     C                   EXSR      SRChkSts                                                 BUG23518
350300200604     C                   ENDIF                                                              BUG23518
350400200604      *                                                                                     BUG23518
350500200604     C                   ENDIF                                                              BUG23518
350600200604      *                                                                                     BUG23518
350700200604     C     EVALAC        ENDSR                                                                CSD007
350800200604      *****************************************************************                       CSD007
350900200604      * VALACR - VALIDATION OF ACTION CODE 'R'                                                CSD007
351000200604      *****************************************************************                       CSD007
351100200604     C     VALACR        BEGSR                                                                CSD007
351200200604      *                                                                                       CSD007
351300200604     C     BBDTDL        IFNE      0                                                          CSD007
351400200604     C     BBCLST        ORNE      'Y'                                                        CSD007
351500200604     C                   MOVEL     'N'           OKACTN                                       CSD007
351600200604     C                   ADD       1             Ix                                           CSD007
351700200604     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CSD007
351800200604     C                   MOVEL     'USR0569'     MsgIdArr(Ix)                                 CSD007
351900200604     C                   ENDIF                                                                CSD007
352000200604      *                                                                                       246639
352100200604      ** Check if the customer is attached to a closed parent                                 246639
352200200604      *                                                                                       246639
352300200604     C     Ix            IFEQ      0                                                          246639
352400200604     C     BBPCNB        ANDNE     *BLANKS                                                    246639
352500200604     C     BBPCNB        CHAIN     SDCUSTLR                           44                      246639
352600200604     C     *IN44         IFEQ      '0'                                                        246639
352700200604     C     BBCLST        ANDEQ     'Y'                                                        246639
352800200604     C                   MOVEL     'N'           OKCUST                                       246639
352900200604     C                   ADD       1             Ix                                           246639
353000200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               246639
353100200604     C                   MOVEL     'USR9474'     MsgIdArr(Ix)                                 246639
353200200604     C                   ENDIF                                                                246639
353300200604     C                   ENDIF                                                                246639
353400200604      ** If parent customer defined and found, re access SDCUSTLR using the                 MD048748
353500200604      ** customer number to ensure it is these customer details returned to                 MD048748
353600200604      ** SDCUSDUPD                                                                          MD048748
353700200604     C     *IN44         IFEQ      '0'                                                      MD048748
353800200604     C     DDCUSN        CHAIN     SDCUSTLR                           44                    MD048748
353900200604     C                   ENDIF                                                              MD048748
354000200604      *                                                                                       CSD007
354100200604     C                   ENDSR                                                                CSD007
354200200604      *****************************************************************                       CSD031
354300200604      /EJECT                                                                                  CSD031
354400200604      *****************************************************************                       CSD031
354500200604      *                                                               *                       CSD031
354600200604      *  SRGetACst - Gets customer acceptance details.                *                       CSD031
354700200604      *                                                               *                       CSD031
354800200604      *****************************************************************                       CSD031
354900200604     C*****SRGetACst     BEGSR                                                       CSD031 BUG13525
355000200604                                                                                              CSD031
355100200604     C*****DDCUSN        CHAIN     SDCUSTLR                                          CSD031 BUG13525
355200200604                                                                                              CSD031
355300200604     C**********         EVAL      WCustLR = 'N'                                     CSD031 BUG13525
355400200604     C**********         EVAL      WTyLC = *BLANK                                    CSD031 BUG13525
355500200604                                                                                              CSD031
355600200604     C**********         IF        %FOUND(SDCUSTLR)                                  CSD031 BUG13525
355700200604     C**********         EVAL      WCustLR = 'Y'                                     CSD031 BUG13525
355800200604     C**********         EVAL      WTyLC = BBTYLC                                    CSD031 BUG13525
355900200604     C**********         ENDIF                                                       CSD031 BUG13525
356000200604                                                                                              CSD031
356100200604     C*****DDCUSN        CHAIN     SDACSTL1                                          CSD031 BUG13525
356200200604                                                                                              CSD031
356300200604     C**********         IF        %FOUND(SDACSTL1)                                  CSD031 BUG13525
356400200604                                                                                              CSD031
356500200604      ** Don't update master files if delete was taken from the acceptance subfile.           CSD031
356600200604                                                                                              CSD031
356700200604     C**********         IF        DDACTN = 'D'                                      CSD031 BUG13525
356800200604     C**********         EVAL      PUpdYN = 'N'                                      CSD031 BUG13525
356900200604     C**********         ENDIF                                                       CSD031 BUG13525
357000200604                                                                                              CSD031
357100200604     C**********         IF        DDACTN = 'X'                                      CSD031 BUG13525
357200200604                                                                                              CSD031
357300200604     C**********         IF        WCustLR = 'Y'                                     CSD031 BUG13525
357400200604                                                                                              CSD031
357500200604     C**********         SELECT                                                      CSD031 BUG13525
357600200604                                                                                              CSD031
357700200604     C**********         WHEN      BBTYLC = 'I'                                      CSD031 BUG13525
357800200604     C**********         EVAL      DDACTN = 'A'                                      CSD031 BUG13525
357900200604     C**********         EVAL      BBTYLC = 'A'                                      CSD031 BUG13525
358000200604                                                                                              CSD031
358100200604     C**********         WHEN      BBTYLC = 'D'                                      CSD031 BUG13525
358200200604     C**********         EVAL      DDACTN = 'D'                                      CSD031 BUG13525
358300200604                                                                                              CSD031
358400200604     C**********         IF        WTyLC = 'D'                                       CSD031 BUG13525
358500200604     C**********         EVAL      PUpdYN = 'N'                                      CSD031 BUG13525
358600200604     C**********         ENDIF                                                       CSD031 BUG13525
358700200604                                                                                              CSD031
358800200604     C**********         OTHER                                                       CSD031 BUG13525
358900200604     C**********         EVAL      DDACTN = BBTYLC                                   CSD031 BUG13525
359000200604                                                                                              CSD031
359100200604     C**********         ENDSL                                                       CSD031 BUG13525
359200200604                                                                                              CSD031
359300200604     C**********         ELSE                                                        CSD031 BUG13525
359400200604                                                                                              CSD031
359500200604     C**********         SELECT                                                      CSD031 BUG13525
359600200604                                                                                              CSD031
359700200604     C**********         WHEN      BBTYLC = 'A'                                      CSD031 BUG13525
359800200604     C**********         EVAL      DDACTN = 'I'                                      CSD031 BUG13525
359900200604     C**********         EVAL      BBTYLC = 'I'                                      CSD031 BUG13525
360000200604                                                                                              CSD031
360100200604      ** Don't update master files if delete was accepted for a non-existing record.          CSD031
360200200604                                                                                              CSD031
360300200604     C**********         WHEN      BBTYLC = 'D'                                      CSD031 BUG13525
360400200604     C**********         EVAL      DDACTN = 'D'                                      CSD031 BUG13525
360500200604     C**********         EVAL      PUpdYN = 'N'                                      CSD031 BUG13525
360600200604                                                                                              CSD031
360700200604     C**********         OTHER                                                       CSD031 BUG13525
360800200604     C**********         EVAL      DDACTN = BBTYLC                                   CSD031 BUG13525
360900200604                                                                                              CSD031
361000200604     C**********         ENDSL                                                       CSD031 BUG13525
361100200604                                                                                              CSD031
361200200604     C**********         ENDIF                                                       CSD031 BUG13525
361300200604                                                                                              CSD031
361400200604     C**********         ENDIF                                                       CSD031 BUG13525
361500200604                                                                                              CSD031
361600200604     C**********         ENDIF                                                       CSD031 BUG13525
361700200604                                                                                              CSD031
361800200604     C**********         MOVE      CustFilFmt    SDACST                              CSD031 BUG13525
361900200604                                                                                              CSD031
362000200604     C**********         ENDSR                                                       CSD031 BUG13525
362100200604      *****************************************************************                       CSD031
362200200604      /EJECT                                                                                  CSD031
362300200604      *****************************************************************                       CSD031
362400200604      *                                                               *                       CSD031
362500200604      *  SROvrFlds - Overrides customer details with acceptance       *                       CSD031
362600200604      *              details.                                         *                       CSD031
362700200604      *                                                               *                       CSD031
362800200604      *****************************************************************                       CSD031
362900200604     C*****SROvrFlds     BEGSR                                                       CSD031 BUG13525
363000200604                                                                                              CSD031
363100200604     C**********         IF        DDACTN = 'I' OR                                   CSD031 BUG13525
363200200604     C**********                   DDACTN = 'D' OR                                   CSD031 BUG13525
363300200604     C**********                   DDACTN = 'E'                                      CSD031 BUG13525
363400200604     C**********         MOVE      SDACST        CustFilFmt                          CSD031 BUG13525
363500200604     C**********         ENDIF                                                       CSD031 BUG13525
363600200604                                                                                              CSD031
363700200604     C**********         IF        DDACTN = 'A'                                      CSD031 BUG13525
363800200604     C**********         EVAL      BBCSSN = B_BBCSSN                                 CSD031 BUG13525
363900200604     C**********         EVAL      BBCNA1 = B_BBCNA1                                 CSD031 BUG13525
364000200604     C**********         EVAL      BBCNA2 = B_BBCNA2                                 CSD031 BUG13525
364100200604     C**********         EVAL      BBCNA3 = B_BBCNA3                                 CSD031 BUG13525
364200200604     C**********         EVAL      BBCNA4 = B_BBCNA4                                 CSD031 BUG13525
364300200604     C**********         EVAL      BBCRTN = B_BBCRTN                                 CSD031 BUG13525
364400200604     C**********         EVAL      BBCRNM = B_BBCRNM                                 CSD031 BUG13525
364500200604     C**********         EVAL      BBACOC = B_BBACOC                                 CSD031 BUG13525
364600200604     C**********         EVAL      BBCGRP = B_BBCGRP                                 CSD031 BUG13525
364700200604     C**********         EVAL      BBBRCD = B_BBBRCD                                 CSD031 BUG13525
364800200604     C**********         EVAL      BBCNCZ = B_BBCNCZ                                 CSD031 BUG13525
364900200604     C**********         EVAL      BBCOLC = B_BBCOLC                                 CSD031 BUG13525
365000200604     C**********         EVAL      BBPCNB = B_BBPCNB                                 CSD031 BUG13525
365100200604     C**********         EVAL      BBLCCD = B_BBLCCD                                 CSD031 BUG13525
365200200604     C**********         EVAL      BBDINC = B_BBDINC                                 CSD031 BUG13525
365300200604     C**********         EVAL      BBDTDL = B_BBDTDL                                 CSD031 BUG13525
365400200604     C**********         EVAL      BBCLST = B_BBCLST                                 CSD031 BUG13525
365500200604     C**********         EVAL      BBCLDT = B_BBCLDT                                 CSD031 BUG13525
365600200604     C**********         EVAL      BBTMST = B_BBTMST                                 CSD031 BUG13525
365700200604     C**********         EVAL      BBAACC = B_BBAACC                                 CSD031 BUG13525
365800200604     C**********         EVAL      BBEACC = B_BBEACC                                 CSD031 BUG13525
365900200604     C**********         ENDIF                                                       CSD031 BUG13525
366000200604                                                                                              CSD031
366100200604     C**********         ENDSR                                                       CSD031 BUG13525
366200200604      *****************************************************************                       CFT050
366300200604      ** Pop_SW13 - Set SWIFTRef Bank Direcotry Plus screen fields                            CFT050
366400200604      *****************************************************************                       CFT050
366500200604     C     Pop_SW13      BEGSR                                                                CFT050
366600200604      *                                                                                       CFT050
366700200604     C                   IF        CSW213   = 'Y'                                           MD022463
366800200604     C                   EVAL      SvDDLEIC = DDLEIC                                          CFT050
366900200604     C                   EVAL      SvDDCLSY = DDCLSY                                          CFT050
367000200604     C                   EVAL      SvDDCLID = DDCLID                                          CFT050
367100200604     C                   ENDIF                                                              MD022463
367200200604      *                                                                                     MD022766
367300200604     C                   IF        CFT050   = 'Y'                                           MD022766
367400200604     C                   EVAL      SvDDBDRK = DDBDRK                                          CFT050
367500200604     C                   ENDIF                                                              MD022766
367600200604                                                                                              CFT050
367700200604     C                   CLEAR                   CuSW13                                       CFT050
367800200604     C                   CLEAR                   MEBIB3D0                                     CFT050
367900200604     C                   CLEAR                   MEIBN3D0                                     CFT050
368000200604                                                                                              CFT050
368100200604     C                   IF        CSW213   = 'Y'                                           MD022463
368200200604     C                   EVAL      DDLEIC = SvDDLEIC                                          CFT050
368300200604     C                   EVAL      DDCLSY = SvDDCLSY                                          CFT050
368400200604     C                   EVAL      DDCLID = SvDDCLID                                          CFT050
368500200604     C                   ENDIF                                                              MD022463
368600200604      *                                                                                     MD022766
368700200604     C                   IF        CFT050   = 'Y'                                           MD022766
368800200604     C                   EVAL      DDBDRK = SvDDBDRK                                          CFT050
368900200604                                                                                              CFT050
369000200604     C     DDBDRK        CHAIN     MEBIB3L0                                                   CFT050
369100200604     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
369200200604     C                   EVAL      DDFLAG = B3FLAG                                            CFT050
369300200604     C                   EVAL      DDOFTP = B3OFTP                                            CFT050
369400200604     C                   EVAL      DDPOKY = B3POKY                                            CFT050
369500200604     C                   EVAL      DDHOKY = B3HOKY                                            CFT050
369600200604     C                   EVAL      DDLGTP = B3LGTP                                            CFT050
369700200604     C                   EVAL      DDLGPK = B3LGPK                                            CFT050
369800200604     C                   EVAL      DDGRTP = B3GRTP                                            CFT050
369900200604     C                   EVAL      DDGPKY = B3GPKY                                            CFT050
370000200604     C                   EVAL      DDISST = B3ISST                                            CFT050
370100200604     C                   EVAL      DDCGKY = B3CGKY                                            CFT050
370200200604     C                   EVAL      DDILEI = B3LEIC                                            CFT050
370300200604     C                   EVAL      DDBICC = B3BICC                                            CFT050
370400200604     C                   EVAL      S13DDBRCD = B3BRCD                                         CFT050
370500200604     C                   EVAL      DDBICC = B3UBIC                                            CFT050
370600200604     C                   EVAL      DDCHIP = B3CHIP                                            CFT050
370700200604     C                   EVAL      DDNATI = B3NATI                                            CFT050
370800200604     C                   EVAL      DDCBIC = B3CBIC                                            CFT050
370900200604     C                   EVAL      DDINS1 = B3INS1                                            CFT050
371000200604     C                   EVAL      DDINS2 = B3INS2                                            CFT050
371100200604     C                   EVAL      DDINS3 = B3INS3                                            CFT050
371200200604     C                   EVAL      DDBIN1 = B3BIN1                                            CFT050
371300200604     C                   EVAL      DDBIN2 = B3BIN2                                            CFT050
371400200604     C                   EVAL      DDPOBN = B3POBN                                            CFT050
371500200604     C                   EVAL      DDADD1 = B3ADD1                                            CFT050
371600200604     C                   EVAL      DDADD2 = B3ADD2                                            CFT050
371700200604     C                   EVAL      DDADD3 = B3ADD3                                            CFT050
371800200604     C                   EVAL      DDADD4 = B3ADD4                                            CFT050
371900200604     C                   EVAL      DDCITY = B3CITY                                            CFT050
372000200604     C                   EVAL      DDCPS1 = B3CPS1                                            CFT050
372100200604     C                   EVAL      DDCPS2 = B3CPS2                                            CFT050
372200200604     C                   EVAL      DDCPS3 = B3CPS3                                            CFT050
372300200604     C                   EVAL      DDZIP  = B3ZIP                                             CFT050
372400200604     C                   EVAL      DDCNT1 = B3CNT1                                            CFT050
372500200604     C                   EVAL      DDCNT2 = B3CNT2                                            CFT050
372600200604     C                   EVAL      DDISOC = B3ISOC                                            CFT050
372700200604     C                   EVAL      DDTMZN = B3TMZN                                            CFT050
372800200604     C                   EVAL      DDSTYP = B3STYP                                            CFT050
372900200604     C                   EVAL      DDNWCY = B3NWCY                                            CFT050
373000200604     C                   EVAL      DDBRQA = B3BRQA                                            CFT050
373100200604     C                   EVAL      DDSER1 = B3SER1                                            CFT050
373200200604     C                   EVAL      DDSER2 = B3SER2                                            CFT050
373300200604     C                   EVAL      DDSSIC = B3SSIC                                            CFT050
373400200604     C                   EVAL      DDIBNK = B3IBNK                                            CFT050
373500200604     C                   EVAL      DDFILA = B3FILA                                            CFT050
373600200604     C                   EVAL      DDFLB1 = B3FLB1                                            CFT050
373700200604     C                   EVAL      DDFLB2 = B3FLB2                                            CFT050
373800200604                                                                                              CFT050
373900200604     C     B3IBNK        CHAIN     MEIBN3L0                                                   CFT050
374000200604     C                   IF        %FOUND(MEIBN3L0)                                           CFT050
374100200604     C                   EVAL      DDIBNC = N3IBNC                                            CFT050
374200200604     C                   EVAL      DDIBIC = N3IBIC                                            CFT050
374300200604     C                   EVAL      DDRBIC = N3RBIC                                            CFT050
374400200604     C                   EVAL      DDINAT = N3INAT                                            CFT050
374500200604     C                   EVAL      DDSCTX = N3SCTX                                            CFT050
374600200604     C                   ENDIF                                                                CFT050
374700200604     C                   ENDIF                                                                CFT050
374800200604                                                                                              CFT050
374900200604     C                   IF        DDACTN = 'I'                                               CFT050
375000200604     C**********                   AND SVDDBDRK2 <> DDBDRK                           CFT050 MD022463
375100200604                                                                                              CFT050
375200200604     C                   EVAL      PCusn = DDCUSN                                             CFT050
375300200604      *                                                                                       CFT050
375400200604      ** Get parent key from customer file                                                    CFT050
375500200604      *                                                                                       CFT050
375600200604     C                   CALLB     'AOCUSTR0'                                                 CFT050
375700200604     C                   PARM      *Blanks       P@Rtcd                                       CFT050
375800200604     C                   PARM      '*KEY'        P@Optn                                       CFT050
375900200604     C                   PARM                    PCusn                                        CFT050
376000200604     C                   PARM                    PKySt                                        CFT050
376100200604     C     SDCUST        PARM      SDCUST        DSSDY                                        CFT050
376200200604     C                   IF        P@Rtcd =  *BLANKS                                          CFT050
376300200604     C                   IF        DDDPCNB = *BLANKS                                          CFT050
376400200604     C                   EVAL      DDDPCNB = BBPCNB                                           CFT050
376500200604     C                   ENDIF                                                                CFT050
376600200604     C                   ENDIF                                                                CFT050
376700200604                                                                                              CFT050
376800200604     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
376900200604      **                                                                                      CFT050
377000200604     C                   IF        DDDBNBI = *BLANKS                                          CFT050
377100200604     C                             OR DDDBNBI = 'N'                                         MD022408
377200200604     C                   IF        B3ISST = 'BANK'                                            CFT050
377300200604     C                             OR B3ISST = 'COOP'                                         CFT050
377400200604     C                             OR B3ISST = 'CBMA'                                         CFT050
377500200604     C                   EVAL      DDDBNBI = 'Y'                                              CFT050
377600200604     C                   ENDIF                                                                CFT050
377700200604     C                   ENDIF                                                                CFT050
377800200604      **                                                                                      CFT050
377900200604     C                   IF        DDDCNA1 = *BLANKS                                          CFT050
378000200604     C                   EVAL      DDDCNA1 = B3INS1                                           CFT050
378100200604     C                   ENDIF                                                                CFT050
378200200604      **                                                                                      CFT050
378300200604     C                   IF        DDDCRNM = *BLANKS                                          CFT050
378400200604     C                   EVAL      DDDCRNM = B3INS1                                           CFT050
378500200604     C                   ENDIF                                                                CFT050
378600200604      **                                                                                      CFT050
378700200604     C                   IF        DDDCNA2 = *BLANKS                                          CFT050
378800200604     C                   EVAL      DDDCNA2 = B3ADD1                                           CFT050
378900200604     C                   ENDIF                                                                CFT050
379000200604      **                                                                                      CFT050
379100200604     C                   IF        DDDCNA3 = *BLANKS                                          CFT050
379200200604     C                   EVAL      DDDCNA3 = B3ADD2                                           CFT050
379300200604     C                   ENDIF                                                                CFT050
379400200604      **                                                                                      CFT050
379500200604     C                   IF        DDDCRTN = *BLANKS                                          CFT050
379600200604     C                   EVAL      DDDCRTN = B3CITY                                           CFT050
379700200604     C                   ENDIF                                                                CFT050
379800200604      **                                                                                      CFT050
379900200604     C                   SELECT                                                               CFT050
380000200604     C                   WHEN      DDDCNA1 = *BLANKS                                          CFT050
380100200604     C                   EVAL      DDDCNA1 = B3CPS1                                           CFT050
380200200604     C                   WHEN      DDDCNA2 = *BLANKS                                          CFT050
380300200604     C                   EVAL      DDDCNA2 = B3CPS1                                           CFT050
380400200604     C                   WHEN      DDDCNA3 = *BLANKS                                          CFT050
380500200604     C                   EVAL      DDDCNA3 = B3CPS1                                           CFT050
380600200604     C                   WHEN      DDDCNA4 = *BLANKS                                          CFT050
380700200604     C                   EVAL      DDDCNA4 = B3CPS1                                           CFT050
380800200604     C                   ENDSL                                                                CFT050
380900200604      **                                                                                      CFT050
381000200604     C                   SELECT                                                               CFT050
381100200604     C                   WHEN      DDDCNA1 = *BLANKS                                          CFT050
381200200604     C                   EVAL      DDDCNA1 = B3CNT1                                           CFT050
381300200604     C                   WHEN      DDDCNA2 = *BLANKS                                          CFT050
381400200604     C                   EVAL      DDDCNA2 = B3CNT1                                           CFT050
381500200604     C                   WHEN      DDDCNA3 = *BLANKS                                          CFT050
381600200604     C                   EVAL      DDDCNA3 = B3CNT1                                           CFT050
381700200604     C                   WHEN      DDDCNA4 = *BLANKS                                          CFT050
381800200604     C                   EVAL      DDDCNA4 = B3CNT1                                           CFT050
381900200604     C                   ENDSL                                                                CFT050
382000200604      **                                                                                      CFT050
382100200604     C                   IF        DDDCNCZ = *BLANKS                                          CFT050
382200200604     C                   EVAL      DDDCNCZ = B3ISOC                                           CFT050
382300200604     C                   ENDIF                                                                CFT050
382400200604      **                                                                                      CFT050
382500200604     C                   IF        DDDCNCZ = *BLANKS                                          CFT050
382600200604     C                   EVAL      DDDCOLC = B3ISOC                                           CFT050
382700200604     C                   ENDIF                                                                CFT050
382800200604      **                                                                                      CFT050
382900200604     C                   EVAL      SVCNCZ = *BLANKS                                           CFT050
383000200604     C                   EVAL      SVCOLC = *BLANKS                                           CFT050
383100200604     C     B3ISOC        SETLL     SDCTRYL3                                                   CFT050
383200200604     C                   IF        %EQUAL                                                     CFT050
383300200604     C     B3ISOC        CHAIN     SDCTRYL3                                                   CFT050
383400200604     C                   DOW       %FOUND(SDCTRYL3)                                           CFT050
383500200604     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
383600200604     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
383700200604     C                   IF        B3ISOC = A4CNCD                                            CFT050
383800200604     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
383900200604     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
384000200604     C                   LEAVE                                                                CFT050
384100200604     C                   ENDIF                                                                CFT050
384200200604     C     B3ISOC        READE     SDCTRYL3                                                   CFT050
384300200604      ** SDCTRYL3 dow                                                                         CFT050
384400200604     C                   ENDDO                                                                CFT050
384500200604      **                                                                                      CFT050
384600200604     C                   IF        SVCNCZ <> *BLANKS                                          CFT050
384700200604     C                             AND DDDCNCZ = *BLANK                                       CFT050
384800200604     C                   EVAL      DDDCNCZ = SVCNCZ                                           CFT050
384900200604     C                   ENDIF                                                                CFT050
385000200604      **                                                                                      CFT050
385100200604     C                   IF        SVCOLC <> *BLANKS                                          CFT050
385200200604     C                             AND DDDCOLC = *BLANK                                       CFT050
385300200604     C                   EVAL      DDDCOLC = SVCOLC                                           CFT050
385400200604     C                   ENDIF                                                                CFT050
385500200604      ** SDCTRYL3 equal                                                                       CFT050
385600200604     C                   ENDIF                                                                CFT050
385700200604     C**********         ENDIF                                                       CFT050 MD023955
385800200604                                                                                              CFT050
385900200604      ** 3rd screen                                                                           CFT050
386000200604     C                   IF        DDCSID = *BLANKS                                           CFT050
386100200604     C                   EVAL      DDCSID = B3UBIC                                            CFT050
386200200604     C                   ENDIF                                                                CFT050
386300200604      **                                                                                      CFT050
386400200604     C                   IF        DDCIDA = *BLANKS                                           CFT050
386500200604     C                   EVAL      DDCIDA = B3CHIP                                            CFT050
386600200604     C                   ENDIF                                                                CFT050
386700200604      **                                                                                      CFT050
386800200604     C                   IF        B3ISOC = 'US'                                              CFT050
386900200604     C                   IF        DDFWCA = *BLANKS                                           CFT050
387000200604     C                   EVAL      DDFWCA = B3NATI                                            CFT050
387100200604     C                   ENDIF                                                                CFT050
387200200604     C                   ENDIF                                                                CFT050
387300200604      **                                                                                      CFT050
387400200604     C                   IF        B3ISOC = 'DE'                                              CFT050
387500200604     C**********         IF        DDFWCA = *BLANKS                                  CFT050 MD022520
387600200604     C**********         EVAL      DDFWCA = B3NATI                                   CFT050 MD022520
387700200604     C                   IF        DDBLCD = *BLANKS                                         MD022520
387800200604     C                   EVAL      DDBLCD = B3NATI                                          MD022520
387900200604     C                   ENDIF                                                                CFT050
388000200604     C                   ENDIF                                                                CFT050
388100200604      **                                                                                      CFT050
388200200604     C                   IF        B3ISOC = 'JP'                                              CFT050
388300200604     C                   IF        DDBFIC = *BLANKS                                           CFT050
388400200604     C                   EVAL      DDBFIC = B3NATI                                            CFT050
388500200604     C                   ENDIF                                                                CFT050
388600200604     C                   ENDIF                                                                CFT050
388700200604      **                                                                                      CFT050
388800200604     C                   IF        B3ISOC = 'GB'                                              CFT050
388900200604     C                   IF        DDCSCA = *BLANKS                                           CFT050
389000200604     C                   EVAL      DDCSCA = B3NATI                                            CFT050
389100200604     C                   ENDIF                                                                CFT050
389200200604     C                   ENDIF                                                                CFT050
389300200604      **                                                                                      CFT050
389400200604     C                   EVAL      SVCLSY = *BLANKS                                         MD022587
389500200604     C                   IF        CSW213 = 'Y'                                               CSW213
389600200604      *                                                                                       CSW213
389700200604     C                   IF        DDCLID = *BLANKS                                           CSW213
389800200604      ** Do not defaul if equal to the following ISO codes                                  MD023115
389900200604     C                             AND B3ISOC <> 'US'                                       MD023115
390000200604     C                             AND B3ISOC <> 'DE'                                       MD023115
390100200604     C                             AND B3ISOC <> 'JP'                                       MD023115
390200200604     C                             AND B3ISOC <> 'GB'                                       MD023115
390300200604     C                   EVAL      DDCLID = B3NATI                                            CSW213
390400200604     C                   ENDIF                                                                CSW213
390500200604      *                                                                                       CSW213
390600200604     C                   IF        DDCLSY = *BLANKS                                           CSW213
390700200604     C**********         EVAL      DDCLSY = B3ISOC                                   CSW213 MD022587
390800200604     C                   EVAL      SVCLSY = B3ISOC                                          MD022587
390900200604     C                   ENDIF                                                                CSW213
391000200604      *                                                                                       CSW213
391100200604     C**********         EVAL      SVCLSY = *BLANKS                                  CSW213 MD022587
391200200604     C                   SELECT                                                               CSW213
391300200604      *                                                                                       CSW213
391400200604     C                   WHEN      B3ISOC = 'AT'                                              CSW213
391500200604     C                   EVAL      SVCLSY = 'AT'                                              CSW213
391600200604      *                                                                                       CSW213
391700200604     C                   WHEN      B3ISOC = 'AU'                                              CSW213
391800200604     C                   EVAL      SVCLSY = 'AU'                                              CSW213
391900200604      *                                                                                       CSW213
392000200604     C                   WHEN      B3ISOC = 'CA'                                              CSW213
392100200604     C                   EVAL      SVCLSY = 'CC'                                              CSW213
392200200604      *                                                                                       CSW213
392300200604     C                   WHEN      B3ISOC = 'ES'                                              CSW213
392400200604     C                   EVAL      SVCLSY = 'ES'                                              CSW213
392500200604      *                                                                                       CSW213
392600200604     C                   WHEN      B3ISOC = 'GR'                                              CSW213
392700200604     C                   EVAL      SVCLSY = 'GR'                                              CSW213
392800200604      *                                                                                       CSW213
392900200604     C                   WHEN      B3ISOC = 'HK'                                              CSW213
393000200604     C                   EVAL      SVCLSY = 'HK'                                              CSW213
393100200604      *                                                                                       CSW213
393200200604     C                   WHEN      B3ISOC = 'IE'                                              CSW213
393300200604     C                   EVAL      SVCLSY = 'IE'                                              CSW213
393400200604      *                                                                                       CSW213
393500200604     C                   WHEN      B3ISOC = 'IN'                                              CSW213
393600200604     C                   EVAL      SVCLSY = 'IN'                                              CSW213
393700200604      *                                                                                       CSW213
393800200604     C                   WHEN      B3ISOC = 'IT'                                              CSW213
393900200604     C                   EVAL      SVCLSY = 'IT'                                              CSW213
394000200604      *                                                                                       CSW213
394100200604     C                   WHEN      B3ISOC = 'NZ'                                              CSW213
394200200604     C                   EVAL      SVCLSY = 'NZ'                                              CSW213
394300200604      *                                                                                       CSW213
394400200604     C                   WHEN      B3ISOC = 'PL'                                              CSW213
394500200604     C                   EVAL      SVCLSY = 'PL'                                              CSW213
394600200604      *                                                                                       CSW213
394700200604     C                   WHEN      B3ISOC = 'PT'                                              CSW213
394800200604     C                   EVAL      SVCLSY = 'PT'                                              CSW213
394900200604      *                                                                                       CSW213
395000200604     C                   WHEN      B3ISOC = 'RU'                                              CSW213
395100200604     C                   EVAL      SVCLSY = 'RU'                                              CSW213
395200200604      *                                                                                       CSW213
395300200604     C                   WHEN      B3ISOC = 'CH'                                              CSW213
395400200604     C                   EVAL      SVCLSY = 'SW'                                              CSW213
395500200604      *                                                                                       CSW213
395600200604     C                   WHEN      B3ISOC = 'SW'                                              CSW213
395700200604     C                   EVAL      SVCLSY = 'SW'                                              CSW213
395800200604      *                                                                                       CSW213
395900200604     C                   WHEN      B3ISOC = 'ZA'                                              CSW213
396000200604     C                   EVAL      SVCLSY = 'ZA'                                              CSW213
396100200604      *                                                                                       CSW213
396200200604     C                   OTHER                                                                CSW213
396300200604     C**********         EVAL      DDCLID = *BLANKS                                  CSW213 MD022557
396400200604     C**********         EVAL      DDCLSY = *BLANKS                                  CSW213 MD022557
396500200604      *                                                                                       CSW213
396600200604     C                   ENDSL                                                                CSW213
396700200604      *                                                                                       CSW213
396800200604     C                   IF        SVCLSY <> *BLANKS                                          CSW213
396900200604     C                             AND DDCLSY = *BLANKS                                       CSW213
397000200604      ** Do not defaul if equal to the following ISO codes                                  MD023115
397100200604     C                             AND B3ISOC <> 'US'                                       MD023115
397200200604     C                             AND B3ISOC <> 'DE'                                       MD023115
397300200604     C                             AND B3ISOC <> 'JP'                                       MD023115
397400200604     C                             AND B3ISOC <> 'GB'                                       MD023115
397500200604     C                   EVAL      DDCLSY = SVCLSY                                            CSW213
397600200604     C                   ENDIF                                                                CSW213
397700200604      *                                                                                       CSW213
397800200604     C                   IF        DDLEIC = *BLANKS                                           CSW213
397900200604     C                   EVAL      DDLEIC = B3LEIC                                            CSW213
398000200604     C                   ENDIF                                                                CSW213
398100200604      ** CSW213                                                                               CSW213
398200200604     C                   ENDIF                                                                CSW213
398300200604      **                                                                                      CFT050
398400200604     C                   IF        B3CBIC <> *BLANKS                                          CFT050
398500200604     C                   IF        DDCSID =  *BLANKS                                        MD022463
398600200604     C                   EVAL      DDCSID =  B3CBIC                                           CFT050
398700200604     C                   ENDIF                                                              MD022463
398800200604     C                   ENDIF                                                                CFT050
398900200604      **                                                                                      CFT050
399000200604     C                   CALLB     'AOBEISR0'                                                 CFT050
399100200604     C                   PARM      *BLANKS       @RTCD                                        CFT050
399200200604     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
399300200604     C                   PARM      B3STYP        PBICD                                        CFT050
399400200604     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CFT050
399500200604     C                   IF        @RTCD <> *BLANKS                                           CFT050
399600200604     C                   IF        DDSWFI = *BLANKS                                           CFT050
399700200604     C                   EVAL      DDSWFI = 'Y'                                               CFT050
399800200604     C                   ENDIF                                                                CFT050
399900200604     C                   ELSE                                                                 CFT050
400000200604     C                   IF        DDSWFI = *BLANKS                                           CFT050
400100200604     C                   EVAL      DDSWFI = 'N'                                               CFT050
400200200604     C                   ENDIF                                                                CFT050
400300200604     C                   ENDIF                                                                CFT050
400400200604      **                                                                                      CFT050
400500200604     C**********         IF        CSW204 = 'Y'                                      CFT050 MD022463
400600200604     C                   IF        CSW024 = 'Y'                                             MD022463
400700200604     C                             AND B3STYP = 'CORP'                                        CFT050
400800200604     C**********         IF        DDCRPC = *BLANKS                                  CFT050 MD022463
400900200604     C**********         EVAL      DDCRPC = 'Y'                                      CFT050 MD022463
401000200604     C                   IF        DDCORP = *BLANKS                                         MD022463
401100200604     C                             OR DDCORP = 'N'                                          MD022463
401200200604     C                   EVAL      DDCORP = 'Y'                                             MD022463
401300200604     C                   ENDIF                                                                CFT050
401400200604      ***CSW204*                                                                     CFT050 MD022463
401500200604     C**********         ENDIF                                                       CFT050 MD022463
401600200604      ** 8th screen                                                                           CFT050
401700200604     C                   IF        B3BICC <>*BLANKS                                         MD022463
401800200604                                                                                            MD022463
401900200604     C                   IF        DDCBEI = *BLANKS                                           CFT050
402000200604     C**********         EVAL      DDCBEI = B3BICC                                  CFT050 MD022557A
402100200604     C                   EVAL      DDCBEI = B3UBIC                                         MD022557A
402200200604     C                   ENDIF                                                                CFT050
402300200604                                                                                            MD022463
402400200604     C                   ELSE                                                               MD022463
402500200604      **                                                                                      CFT050
402600200604     C                   IF        DDRI01 = *BLANKS                                           CFT050
402700200604     C                   IF        B3BICC <> *BLANKS                                          CFT050
402800200604     C                   EVAL      DDRI01 = '/ABIC/' + B3BICC                                 CFT050
402900200604     C                   ELSE                                                                 CFT050
403000200604     C**********         EVAL      DDRI01 = '/ABIC/UKNW'                             CFT050 MD022861
403100200604     C                   EVAL      DDRI01 = '/ABIC/UKWN'                                    MD022861
403200200604     C                   ENDIF                                                                CFT050
403300200604     C                   ENDIF                                                                CFT050
403400200604      **                                                                                      CFT050
403500200604     C                   IF        DDRI02 = *BLANKS                                           CFT050
403600200604     C                   EVAL      DDRI02 = '/NAME/' + B3INS1                                 CFT050
403700200604     C                   ENDIF                                                                CFT050
403800200604      **                                                                                      CFT050
403900200604     C                   IF        CSW213 = 'Y'                                               CFT050
404000200604     C                             AND B3LEIC <> *BLANKS                                      CFT050
404100200604     C                   IF        DDRI03 = *BLANKS                                           CFT050
404200200604     C                   EVAL      DDRI03 = '/LEIC/' + B3LEIC                                 CFT050
404300200604     C                   ENDIF                                                                CFT050
404400200604     C                   ENDIF                                                                CFT050
404500200604      ** B3BICC                                                                             MD022463
404600200604     C                   ENDIF                                                              MD022463
404700200604      ** CSW024                                                                             MD022463
404800200604     C                   ENDIF                                                              MD022463
404900200604                                                                                              CFT050
405000200604     C                   ENDIF                                                                CFT050
405100200604     C                   ENDIF                                                              MD022766
405200200604     C                   ENDIF                                                              MD023955
405300200604     C**********         EVAL      SVDDBDRK2 = DDBDRK                                CFT050 MD022463
405400200604                                                                                              CFT050
405500200604     C                   ENDSR                                                                CFT050
405600200604      *****************************************************************                     MD022463
405700200604      ** Pop_SW13Scrn - Set SWIFTRef Bank Directory Plus screen fields                      MD022463
405800200604      *****************************************************************                     MD022463
405900200604     C     Pop_SW13Scrn  BEGSR                                                              MD022463
406000200604      *                                                                                     MD022463
406100200604     C                   IF        DDACTN = 'E'                                             MD022463
406200200604     C                   IF        CSW213 = 'Y'                                             MD022463
406300200604     C                   EVAL      DDLEIC = CSLEIC                                          MD022463
406400200604     C                   EVAL      DDCLSY = CSCLSY                                          MD022463
406500200604     C                   EVAL      DDCLID = CSCLID                                          MD022463
406600200604     C                   ENDIF                                                              MD022463
406700200604      *                                                                                     MD022766
406800200604     C                   IF        CFT050 = 'Y'                                             MD022766
406900200604     C                   EVAL      DDBDRK = CSBDRK                                          MD022463
407000200604     C                   ENDIF                                                              MD022766
407100200604      *                                                                                     MD022766
407200200604     C                   ENDIF                                                              MD022463
407300200604      *                                                                                     MD022463
407400200604     C                   IF        CSW213 = 'Y'                                             MD022463
407500200604     C                   EVAL      SvDDLEIC = DDLEIC                                        MD022463
407600200604     C                   EVAL      SvDDCLSY = DDCLSY                                        MD022463
407700200604     C                   EVAL      SvDDCLID = DDCLID                                        MD022463
407800200604     C                   ENDIF                                                              MD022463
407900200604      *                                                                                     MD022766
408000200604     C                   IF        CFT050 = 'Y'                                             MD022766
408100200604     C                   EVAL      SvDDBDRK = DDBDRK                                        MD022463
408200200604     C                   ENDIF                                                              MD022766
408300200604                                                                                            MD022463
408400200604     C                   CLEAR                   CuSW13                                     MD022463
408500200604     C                   CLEAR                   MEBIB3D0                                   MD022463
408600200604     C                   CLEAR                   MEIBN3D0                                   MD022463
408700200604                                                                                            MD022463
408800200604     C                   IF        CSW213 = 'Y'                                             MD022463
408900200604     C                   EVAL      DDLEIC = SvDDLEIC                                        MD022463
409000200604     C                   EVAL      DDCLSY = SvDDCLSY                                        MD022463
409100200604     C                   EVAL      DDCLID = SvDDCLID                                        MD022463
409200200604     C                   ENDIF                                                              MD022463
409300200604      *                                                                                     MD022766
409400200604     C                   IF        CFT050 = 'Y'                                             MD022766
409500200604     C                   EVAL      DDBDRK = SvDDBDRK                                        MD022463
409600200604                                                                                            MD022463
409700200604     C     DDBDRK        CHAIN     MEBIB3L0                                                 MD022463
409800200604     C                   IF        %FOUND(MEBIB3L0)                                         MD022463
409900200604     C                   EVAL      DDFLAG = B3FLAG                                          MD022463
410000200604     C                   EVAL      DDOFTP = B3OFTP                                          MD022463
410100200604     C                   EVAL      DDPOKY = B3POKY                                          MD022463
410200200604     C                   EVAL      DDHOKY = B3HOKY                                          MD022463
410300200604     C                   EVAL      DDLGTP = B3LGTP                                          MD022463
410400200604     C                   EVAL      DDLGPK = B3LGPK                                          MD022463
410500200604     C                   EVAL      DDGRTP = B3GRTP                                          MD022463
410600200604     C                   EVAL      DDGPKY = B3GPKY                                          MD022463
410700200604     C                   EVAL      DDISST = B3ISST                                          MD022463
410800200604     C                   EVAL      DDCGKY = B3CGKY                                          MD022463
410900200604     C                   EVAL      DDILEI = B3LEIC                                          MD022463
411000200604     C                   EVAL      DDBICC = B3BICC                                          MD022463
411100200604     C                   EVAL      S13DDBRCD = B3BRCD                                       MD022463
411200200604     C                   EVAL      DDBICC = B3UBIC                                          MD022463
411300200604     C                   EVAL      DDCHIP = B3CHIP                                          MD022463
411400200604     C                   EVAL      DDNATI = B3NATI                                          MD022463
411500200604     C                   EVAL      DDCBIC = B3CBIC                                          MD022463
411600200604     C                   EVAL      DDINS1 = B3INS1                                          MD022463
411700200604     C                   EVAL      DDINS2 = B3INS2                                          MD022463
411800200604     C                   EVAL      DDINS3 = B3INS3                                          MD022463
411900200604     C                   EVAL      DDBIN1 = B3BIN1                                          MD022463
412000200604     C                   EVAL      DDBIN2 = B3BIN2                                          MD022463
412100200604     C                   EVAL      DDPOBN = B3POBN                                          MD022463
412200200604     C                   EVAL      DDADD1 = B3ADD1                                          MD022463
412300200604     C                   EVAL      DDADD2 = B3ADD2                                          MD022463
412400200604     C                   EVAL      DDADD3 = B3ADD3                                          MD022463
412500200604     C                   EVAL      DDADD4 = B3ADD4                                          MD022463
412600200604     C                   EVAL      DDCITY = B3CITY                                          MD022463
412700200604     C                   EVAL      DDCPS1 = B3CPS1                                          MD022463
412800200604     C                   EVAL      DDCPS2 = B3CPS2                                          MD022463
412900200604     C                   EVAL      DDCPS3 = B3CPS3                                          MD022463
413000200604     C                   EVAL      DDZIP  = B3ZIP                                           MD022463
413100200604     C                   EVAL      DDCNT1 = B3CNT1                                          MD022463
413200200604     C                   EVAL      DDCNT2 = B3CNT2                                          MD022463
413300200604     C                   EVAL      DDISOC = B3ISOC                                          MD022463
413400200604     C                   EVAL      DDTMZN = B3TMZN                                          MD022463
413500200604     C                   EVAL      DDSTYP = B3STYP                                          MD022463
413600200604     C                   EVAL      DDNWCY = B3NWCY                                          MD022463
413700200604     C                   EVAL      DDBRQA = B3BRQA                                          MD022463
413800200604     C                   EVAL      DDSER1 = B3SER1                                          MD022463
413900200604     C                   EVAL      DDSER2 = B3SER2                                          MD022463
414000200604     C                   EVAL      DDSSIC = B3SSIC                                          MD022463
414100200604     C                   EVAL      DDIBNK = B3IBNK                                          MD022463
414200200604     C                   EVAL      DDFILA = B3FILA                                          MD022463
414300200604     C                   EVAL      DDFLB1 = B3FLB1                                          MD022463
414400200604     C                   EVAL      DDFLB2 = B3FLB2                                          MD022463
414500200604                                                                                            MD022463
414600200604     C     B3IBNK        CHAIN     MEIBN3L0                                                 MD022463
414700200604     C                   IF        %FOUND(MEIBN3L0)                                         MD022463
414800200604     C                   EVAL      DDIBNC = N3IBNC                                          MD022463
414900200604     C                   EVAL      DDIBIC = N3IBIC                                          MD022463
415000200604     C                   EVAL      DDRBIC = N3RBIC                                          MD022463
415100200604     C                   EVAL      DDINAT = N3INAT                                          MD022463
415200200604     C                   EVAL      DDSCTX = N3SCTX                                          MD022463
415300200604     C                   ENDIF                                                              MD022463
415400200604     C                   ENDIF                                                              MD022463
415500200604      *                                                                                     MD022766
415600200604     C                   ENDIF                                                              MD022766
415700200604                                                                                            MD022463
415800200604                                                                                            MD022463
415900200604     C                   ENDSR                                                              MD022463
416000200604      *****************************************************************
416100200604      /EJECT
416200200604     C*****************************************************************
416300200604     C* INIT - INITIALIZATION
416400200604     C*****************************************************************
416500200604     C     INIT          BEGSR
416600200604      *
416700200604      * CLEAR OUTPUTS
416800200604      *
416900200604     C                   CLEAR                   CustFilFmt
417000200604     C                   CLEAR                   CuBrFilFmt
417100200604     C                   CLEAR                   CuPbFilFmt
417200200604     C                   CLEAR                   CuTIFilFmt                                  BUG3362
417300200604     C                   CLEAR                   CuFaFilFmt                                   CGL132
417400200604     C                   CLEAR                   CuXCFilFmt                                   CGL132
417500200604     C                   CLEAR                   CrsdFilFmt                                   CGL157
417600200604     C                   CLEAR                   PCrsdF                                       CGL157
417700200604     C                   CLEAR                   CumiFilFmt                                   CSD079
417800200604     C                   CLEAR                   CuadFilFmt                                   CSD079
417900200604     C                   CLEAR                   SfeeFilFmt                                   CSD079
418000200604     C                   CLEAR                   ChecFilFmt                                   CSD079
418100200604     C                   CLEAR                   CusfFilFmt                                   CSD079
418200200604     C                   CLEAR                   RwanFilFmt                                   CSD079
418300200604     C                   CLEAR                   CufoFilFmt                                   CSD079
418400200604     C                   CLEAR                   CufnFilFmt                                   CSD079
418500200604     C                   CLEAR                   CupmFilFmt                                   CSD079
418600200604     C                   CLEAR                   CueuFilFmt                                   CSD079
418700200604     C                   CLEAR                   CuibfFilFmt                                  CSD079
418800200604     C                   CLEAR                   CtnmFilFmt                                AR1086546
418900200604     C                   MOVEL     'Y'           OKACTN
419000200604     C                   MOVEL     'Y'           OKCUST
419100200604     C**********         MOVEL     'Y'           PUpdYN                              CSD031 BUG13525
419200200604      *
419300200604     C                   MOVEL     *BLANK        WUDELS            7
419400200604     C                   MOVEL     *BLANK        WDS1000
419500200604     C                   MOVEL     *BLANK        WDS2000
419600200604     C                   MOVEL     *BLANK        WDS3000
419700200604     C                   MOVEL     *BLANK        WDS4000
419800200604     C                   MOVEL     *BLANK        WDS5000
419900200604      *
420000200604     C/COPY WNCPYSRC,SDCUSDIC03
420100200604     C                   ENDSR
420200200604     C********************************************************************
420300200604      /EJECT
420400200604      *****************************************************************                       CSD079
420500200604      *                                                               *                       CSD079
420600200604      *  RTVCUMI - RETRIEVE Customer Marketing Information            *                       CSD079
420700200604      *                                                               *                       CSD079
420800200604      *****************************************************************                       CSD079
420900200604     C     RTVCUMI       BEGSR                                                                CSD079
421000200604                                                                                              CSD079
421100200604      ** Access Customer Marketing Information                                                CSD079
421200200604                                                                                              CSD079
421300200604     C     DDCUSN        CHAIN     SDCMRKLR                           45                      CSD079
421400200604                                                                                              CSD079
421500200604      ** If Insert Record Found - Error                                                       CSD079
421600200604                                                                                              CSD079
421700200604     C     DDACTN        IFEQ      'I'                                                        CSD079
421800200604     C     *IN45         IFEQ      *OFF                                                       CSD079
421900200604     C                   MOVEL     'N'           OKCUST                                       CSD079
422000200604     C                   ADD       1             Ix                                           CSD079
422100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
422200200604     C                   MOVEL     'USR1479'     MsgIdArr(Ix)                                 CSD079
422300200604     C                   ENDIF                                                                CSD079
422400200604                                                                                              CSD079
422500200604      ** If Delete, Amend or Enquire                                                          CSD079
422600200604                                                                                              CSD079
422700200604     C                   ELSE                                                                 CSD079
422800200604                                                                                              CSD079
422900200604      ** If Live Record Not Found - Error                                                     CSD079
423000200604                                                                                              CSD079
423100200604     C     *IN45         IFEQ      *ON                                                        CSD079
423200200604     C     DDACTN        IFNE      'E'                                                      AR725233
423300200604     C     BBDTDL        OREQ      *ZERO                                                    AR725233
423400200604     C                   MOVEL     'N'           OKCUST                                       CSD079
423500200604     C                   ADD       1             Ix                                           CSD079
423600200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
423700200604     C                   MOVEL     'USR1478'     MsgIdArr(Ix)                                 CSD079
423800200604     C                   ENDIF                                                              AR725233
423900200604     C                   ENDIF                                                                CSD079
424000200604     C                   ENDIF                                                                CSD079
424100200604     C                   ENDSR                                                                CSD079
424200200604                                                                                              CSD079
424300200604      *****************************************************************                       CSD079
424400200604      /EJECT                                                                                  CSD079
424500200604      *****************************************************************                       CSD079
424600200604      *                                                               *                       CSD079
424700200604      *  RTVCUAD - RETRIEVE Customer Additional Details               *                       CSD079
424800200604      *                                                               *                       CSD079
424900200604      *****************************************************************                       CSD079
425000200604     C     RTVCUAD       BEGSR                                                                CSD079
425100200604                                                                                              CSD079
425200200604      ** Access Customer Additional Details                                                   CSD079
425300200604                                                                                              CSD079
425400200604     C     DDCUSN        CHAIN     SDACUSLR                           46                      CSD079
425500200604                                                                                              CSD079
425600200604      ** If Insert Record Found - Error                                                       CSD079
425700200604                                                                                              CSD079
425800200604     C     DDACTN        IFEQ      'I'                                                        CSD079
425900200604     C     *IN46         IFEQ      *OFF                                                       CSD079
426000200604     C                   MOVEL     'N'           OKCUST                                       CSD079
426100200604     C                   ADD       1             Ix                                           CSD079
426200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
426300200604     C                   MOVEL     'USR1915'     MsgIdArr(Ix)                                 CSD079
426400200604     C                   ENDIF                                                                CSD079
426500200604                                                                                              CSD079
426600200604      ** If Delete, Amend or Enquire                                                          CSD079
426700200604                                                                                              CSD079
426800200604     C                   ELSE                                                                 CSD079
426900200604                                                                                              CSD079
427000200604      ** If Live Record not Found - Error                                                     CSD079
427100200604                                                                                              CSD079
427200200604     C     *IN46         IFEQ      *ON                                                        CSD079
427300200604     C     DDACTN        IFNE      'E'                                                      AR725233
427400200604     C     BBDTDL        OREQ      *ZERO                                                    AR725233
427500200604     C                   MOVEL     'N'           OKCUST                                       CSD079
427600200604     C                   ADD       1             Ix                                           CSD079
427700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
427800200604     C                   MOVEL     'USR1914'     MsgIdArr(Ix)                                 CSD079
427900200604     C                   ENDIF                                                              AR725233
428000200604     C                   ENDIF                                                                CSD079
428100200604     C                   ENDIF                                                                CSD079
428200200604     C                   ENDSR                                                                CSD079
428300200604                                                                                              CSD079
428400200604      *****************************************************************                       CSD079
428500200604      /EJECT                                                                                  CSD079
428600200604      *****************************************************************                       CSD079
428700200604      *                                                               *                       CSD079
428800200604      *  RTVSFEE - RETRIEVE Customer Service Fees Details             *                       CSD079
428900200604      *                                                               *                       CSD079
429000200604      *****************************************************************                       CSD079
429100200604     C     RTVSFEE       BEGSR                                                                CSD079
429200200604                                                                                              CSD079
429300200604      ** Access Customer Service Fees Details                                                 CSD079
429400200604                                                                                              CSD079
429500200604     C     DDCUSN        CHAIN     SDCFCDLR                           47                      CSD079
429600200604                                                                                              CSD079
429700200604      **  If Insert Record Found - Error                                                      CSD079
429800200604                                                                                              CSD079
429900200604     C     DDACTN        IFEQ      'I'                                                        CSD079
430000200604     C     *IN47         IFEQ      *OFF                                                       CSD079
430100200604     C                   MOVEL     'N'           OKCUST                                       CSD079
430200200604     C                   ADD       1             Ix                                           CSD079
430300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
430400200604     C                   MOVEL     'USR1919'     MsgIdArr(Ix)                                 CSD079
430500200604     C                   ENDIF                                                                CSD079
430600200604                                                                                              CSD079
430700200604      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
430800200604     C**********         ELSE                                                         CRE026 BG12238
430900200604      **********                                                                      CRE026 BG12238
431000200604      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
431100200604      **********                                                                      CRE026 BG12238
431200200604     C******IN47         IFEQ      '1'                                                CRE026 BG12238
431300200604     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
431400200604     C**********         ADD       1             Ix                                   CRE026 BG12238
431500200604     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
431600200604     C**********         MOVEL     'USR1918'     MsgIdArr(Ix)                         CRE026 BG12238
431700200604     C**********         ENDIF                                                        CRE026 BG12238
431800200604     C                   ENDIF                                                                CSD079
431900200604     C                   ENDSR                                                                CSD079
432000200604                                                                                              CSD079
432100200604      *****************************************************************                       CSD079
432200200604      /EJECT                                                                                  CSD079
432300200604      *****************************************************************                       CSD079
432400200604      *                                                               *                       CSD079
432500200604      *  RTVCHEC - RETRIEVE Cheque and Card Details                   *                       CSD079
432600200604      *                                                               *                       CSD079
432700200604      *****************************************************************                       CSD079
432800200604     C     RTVCHEC       BEGSR                                                                CSD079
432900200604                                                                                              CSD079
433000200604      ** Access Cheque and Card Details                                                       CSD079
433100200604                                                                                              CSD079
433200200604     C                   MOVEL     DDCUSN        SCCUST                                       CSD079
433300200604     C     SCCUST        CHAIN     SDCHEQLR                           48                      CSD079
433400200604                                                                                              CSD079
433500200604      ** If Insert Record Found - Error                                                       CSD079
433600200604                                                                                              CSD079
433700200604     C     DDACTN        IFEQ      'I'                                                        CSD079
433800200604     C     *IN48         IFEQ      *OFF                                                       CSD079
433900200604     C                   MOVEL     'N'           OKCUST                                       CSD079
434000200604     C                   ADD       1             Ix                                           CSD079
434100200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
434200200604     C                   MOVEL     'MX00517'     MsgIdArr(Ix)                                 CSD079
434300200604     C                   ENDIF                                                                CSD079
434400200604                                                                                              CSD079
434500200604      ** If Delete, Amend or Enquire                                                          CSD079
434600200604                                                                                              CSD079
434700200604     C                   ELSE                                                                 CSD079
434800200604                                                                                              CSD079
434900200604      ** If Live Record Not Found - Error                                                     CSD079
435000200604                                                                                              CSD079
435100200604     C     *IN48         IFEQ      *ON                                                        CSD079
435200200604     C                   MOVEL     'N'           OKCUST                                       CSD079
435300200604     C                   ADD       1             Ix                                           CSD079
435400200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
435500200604     C                   MOVEL     'SD99908'     MsgIdArr(Ix)                                 CSD079
435600200604     C                   ENDIF                                                                CSD079
435700200604     C                   ENDIF                                                                CSD079
435800200604     C                   ENDSR                                                                CSD079
435900200604                                                                                              CSD079
436000200604      *****************************************************************                       CSD079
436100200604      /EJECT                                                                                  CSD079
436200200604      *****************************************************************                       CSD079
436300200604      *                                                               *                       CSD079
436400200604      *  RTVCUSF - RETRIEVE Safe Details                              *                       CSD079
436500200604      *                                                               *                       CSD079
436600200604      *****************************************************************                       CSD079
436700200604     C     RTVCUSF       BEGSR                                                                CSD079
436800200604                                                                                              CSD079
436900200604      ** Access Customer Safe Details                                                         CSD079
437000200604                                                                                              CSD079
437100200604     C     DDCUSN        CHAIN     SDSAFEL1                           49                      CSD079
437200200604                                                                                              CSD079
437300200604      ** If Insert Record Found - Error                                                       CSD079
437400200604                                                                                              CSD079
437500200604     C     DDACTN        IFEQ      'I'                                                        CSD079
437600200604     C     *IN49         IFEQ      *OFF                                                       CSD079
437700200604     C                   MOVEL     'N'           OKCUST                                       CSD079
437800200604     C                   ADD       1             Ix                                           CSD079
437900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
438000200604     C                   MOVEL     'MX00517'     MsgIdArr(Ix)                                 CSD079
438100200604     C                   ENDIF                                                                CSD079
438200200604                                                                                              CSD079
438300200604      ** If Delete, Amend or Enquire                                                          CSD079
438400200604                                                                                              CSD079
438500200604     C                   ELSE                                                                 CSD079
438600200604                                                                                              CSD079
438700200604      ** If Live Record Not Found - Error                                                     CSD079
438800200604                                                                                              CSD079
438900200604     C     *IN49         IFEQ      *ON                                                        CSD079
439000200604     C                   MOVEL     'N'           OKCUST                                       CSD079
439100200604     C                   ADD       1             Ix                                           CSD079
439200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
439300200604     C                   MOVEL     'SD99908'     MsgIdArr(Ix)                                 CSD079
439400200604     C                   ENDIF                                                                CSD079
439500200604     C                   ENDIF                                                                CSD079
439600200604     C                   ENDSR                                                                CSD079
439700200604      *****************************************************************                       CSD079
439800200604      /EJECT                                                                                  CSD079
439900200604      *****************************************************************                       CSD079
440000200604      *                                                               *                       CSD079
440100200604      * RTVRWAN - RETRIEVE Risk Weighted Assets Details               *                       CSD079
440200200604      *                                                               *                       CSD079
440300200604      *****************************************************************                       CSD079
440400200604     C     RTVRWAN       BEGSR                                                                CSD079
440500200604                                                                                              CSD079
440600200604      ** Access Customer Risk Weighted Assets Details                                         CSD079
440700200604                                                                                              CSD079
440800200604     C                   CALLB     'SDRWANRTV'                                                CSD079
440900200604                                                                                              CSD079
441000200604      ** Inputs                                                                               CSD079
441100200604      ** Return code                                                                          CSD079
441200200604                                                                                              CSD079
441300200604     C                   PARM                    RetCodeIn                                    CSD079
441400200604                                                                                              CSD079
441500200604      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                 CSD079
441600200604      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                             CSD079
441700200604                                                                                              CSD079
441800200604     C                   PARM                    ModeofOp                                     CSD079
441900200604                                                                                              CSD079
442000200604      ** Response mode                                                                        CSD079
442100200604                                                                                              CSD079
442200200604     C                   PARM                    RespMode                                     CSD079
442300200604                                                                                              CSD079
442400200604      ** Action Code                                                                          CSD079
442500200604                                                                                              CSD079
442600200604     C                   PARM                    DDACTN                                       CSD079
442700200604                                                                                              CSD079
442800200604      ** (Midas) Customer Number                                                              CSD079
442900200604                                                                                              CSD079
443000200604     C                   PARM                    DDCUSN                                       CSD079
443100200604                                                                                              CSD079
443200200604      ** From Customer Flag                                                                   CSD079
443300200604                                                                                              CSD079
443400200604     C                   PARM      'Y'           From_Cust         1                          CSD079
443500200604                                                                                              CSD079
443600200604      ** Outputs                                                                              CSD079
443700200604      ** Transaction Details in File Format                                                   CSD079
443800200604                                                                                              CSD079
443900200604     C                   PARM                    RwanFilFmt                                   CSD079
444000200604                                                                                              CSD079
444100200604      ** OK - Action code                                                                     CSD079
444200200604                                                                                              CSD079
444300200604     C                   PARM                    OKACTN                                       CSD079
444400200604                                                                                              CSD079
444500200604      ** OK - Customer Number                                                                 CSD079
444600200604                                                                                              CSD079
444700200604     C                   PARM                    OKCUST                                       CSD079
444800200604                                                                                              CSD079
444900200604      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
445000200604                                                                                              CSD079
445100200604     C                   PARM                    FldNameArr                                   CSD079
445200200604     C                   PARM                    MsgIDArr                                     CSD079
445300200604     C                   PARM                    MsgDtaArr                                    CSD079
445400200604                                                                                              CSD079
445500200604      ** Array index (3P0) from/to caller                                                     CSD079
445600200604                                                                                              CSD079
445700200604     C                   PARM                    Ix                                           CSD079
445800200604     C                   ENDSR                                                                CSD079
445900200604                                                                                              CSD079
446000200604      *****************************************************************                       CER059
446100200604      /EJECT                                                                                  CER059
446200200604      *****************************************************************                       CER059
446300200604      *                                                               *                       CER059
446400200604      *  RtvCUAH - Retrieve Customer Authority Holder Details         *                       CER059
446500200604      *                                                               *                       CER059
446600200604      *****************************************************************                       CER059
446700200604     C     RtvCUAH       BEGSR                                                                CER059
446800200604                                                                                              CER059
446900200604     C                   EVAL      Idy = 1                                                    CER059
447000200604     C     DDCUSN        SETLL     SDCUAHLA                                                   CER059
447100200604     C                   READ      SDCUAHLA                                                   CER059
447200200604     C                   DOW       NOT %EOF(SDCUAHLA)                                         CER059
447300200604     C                             AND DDCUSN = CACUST                                        CER059
447400200604     C                   IF        CATYLC <> 'D'                                            MD053634
447500200604     C                   EVAL      AHAUTH  = CAAUTH                                           CER059
447600200604     C                   EVAL      AHLTYP  = CALTYP                                           CER059
447700200604     C                   EVAL      AHPRG1  = CAPRG1                                           CER059
447800200604     C                   EVAL      AHPRG2  = CAPRG2                                           CER059
447900200604     C                   EVAL      AHPRG3  = CAPRG3                                           CER059
448000200604     C                   EVAL      AHPRG4  = CAPRG4                                           CER059
448100200604     C                   EVAL      AHTYPA  = CATYPA                                           CER059
448200200604     C                   EVAL      AHCINT  = CACINT                                         MD026780
448300200604     C                   EVAL      AHPCNT  = CAPCNT                                         MD026780
448400200604     C                   EVAL      CUAHArr(Idy) = TranInCUAH1                                 CER059
448500200604     C                   EVAL      Idy =Idy + 1                                               CER059
448600200604     C                   ENDIF                                                              MD053634
448700200604     C                   READ      SDCUAHLA                                                   CER059
448800200604     C                   ENDDO                                                                CER059
448900200604     C                   EVAL      TranInCUAH = CUAHArrDS                                     CER059
449000200604                                                                                              CER059
449100200604     C                   ENDSR                                                                CER059
449200200604      *****************************************************************                       CER059
449300200604      /EJECT                                                                                  CER059
449400200604      *****************************************************************                       CER059
449500200604      *                                                               *                       CER059
449600200604      *  RtvCCTX - Retrieve Customer by Country of Tax Details        *                       CER059
449700200604      *                                                               *                       CER059
449800200604      *****************************************************************                       CER059
449900200604     C     RtvCCTX       BEGSR                                                                CER059
450000200604                                                                                              CER059
450100200604     C                   EVAL      Idy = 1                                                    CER059
450200200604     C     DDCUSN        SETLL     SDACTXL4                                                   CER059
450300200604     C                   READ      SDACTXL4                                                   CER059
450400200604     C                   DOW       NOT %EOF(SDACTXL4)                                         CER059
450500200604     C                             AND DDCUSN = AXCUST                                        CER059
450600200604     C                   EVAL      TXACTN  = *BLANK                                           CER059
450700200604     C                   EVAL      TXCUST  = AXCUST                                           CER059
450800200604     C                   EVAL      TXCTTX  = AXCTTX                                           CER059
450900200604     C                   EVAL      TXETXS  = AXETXS                                           CER059
451000200604     C                   EVAL      TXCERF  = AXCERF                                           CER059
451100200604     C                   EVAL      TXCSTS  = AXCSTS                                           CER059
451200200604     C                   EVAL      TXCRTP  = AXCRTP                                           CER059
451300200604                                                                                              CER059
451400200604     C                   EVAL      TXCEEX  = *BLANK                                           CER059
451500200604     C                   IF        AXCEEX <> *ZERO                                            CER059
451600200604     C                   EVAL      ZDAYNO = AXCEEX                                            CER059
451700200604     C                   EXSR      ZDATE2                                                     CER059
451800200604     C                   MOVEL     ZDATE         TXCEEX                                       CER059
451900200604     C                   ENDIF                                                                CER059
452000200604                                                                                              CER059
452100200604     C                   EVAL      TXCADT  = *BLANK                                           CER059
452200200604     C                   IF        AXCADT <> *ZERO                                            CER059
452300200604     C                   EVAL      ZDAYNO = AXCADT                                            CER059
452400200604     C                   EXSR      ZDATE2                                                     CER059
452500200604     C                   MOVEL     ZDATE         TXCADT                                       CER059
452600200604     C                   ENDIF                                                                CER059
452700200604                                                                                              CER059
452800200604     C                   EVAL      TXCVDT  = *BLANK                                           CER059
452900200604     C                   IF        AXCVDT <> *ZERO                                            CER059
453000200604     C                   EVAL      ZDAYNO = AXCVDT                                            CER059
453100200604     C                   EXSR      ZDATE2                                                     CER059
453200200604     C                   MOVEL     ZDATE         TXCVDT                                       CER059
453300200604     C                   ENDIF                                                                CER059
453400200604                                                                                              CER059
453500200604     C                   EVAL      CCTXArr(Idy) = TranInCCTX1                                 CER059
453600200604     C                   EVAL      Idy =Idy + 1                                               CER059
453700200604     C                   READ      SDACTXL4                                                   CER059
453800200604     C                   ENDDO                                                                CER059
453900200604     C                   EVAL      TranInCCTX = CCTXArrDS                                     CER059
454000200604                                                                                              CER059
454100200604     C                   ENDSR                                                                CER059
454200200604      *****************************************************************                       CGL157
454300200604      /EJECT                                                                                  CGL157
454400200604      *****************************************************************                       CGL157
454500200604      *                                                               *                       CGL157
454600200604      *  RTVCRS - Retrieve CRS Customer Details                       *                       CGL157
454700200604      *                                                               *                       CGL157
454800200604      *****************************************************************                       CGL157
454900200604     C     RTVCRS        BEGSR                                                                CGL157
455000200604                                                                                              CGL157
455100200604      ** Retrieve CRS Customer Details if CGL157 is ON                                        CGL157
455200200604                                                                                              CGL157
455300200604     C     DDCUSN        CHAIN     SDCRSHL1                           96                    MD036311
455400200604     C     *IN96         IFEQ      '0'                                                        CGL157
455500200604     C     DDACTN        ANDEQ     'I'                                                        CGL157
455600200604     C                   MOVEL     'N'           OKCUST                                       CGL157
455700200604     C                   ADD       1             Ix                                           CGL157
455800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL157
455900200604     C                   MOVEL     'USR0542'     MsgIdArr(Ix)                                 CGL157
456000200604     C                   ENDIF                                                                CGL157
456100200604                                                                                              CGL157
456200200604     C                   EVAL      X = 1                                                      CGL157
456300200604     C     DDCUSN        SETLL     SDCRSDL0                                                   CGL157
456400200604     C     DDCUSN        READE     SDCRSDL0                                                   CGL157
456500200604     C                   DOW       NOT %EOF(SDCRSDL0)                                         CGL157
456600200604     C                             AND DDCUSN = CDCUST                                        CGL157
456700200604     C                             AND X < 31                                                 CGL157
456800200604     C                   EVAL      CVCTRY = CDCTRY                                            CGL157
456900200604     C                   EVAL      CVREPT = CDREPT                                            CGL157
457000200604     C                   EVAL      CVREPR = CDREPR                                            CGL157
457100200604     C                   EVAL      CVREPD = CDREPD                                            CGL157
457200200604     C                   EVAL      CVREPM = CDREPM                                            CGL157
457300200604     C                   EVAL      CVREPU = CDREPU                                            CGL157
457400200604     C                   EVAL      CVEVE1 = CDEVE1                                            CGL157
457500200604     C                   EVAL      CVEVS1 = CDEVS1                                            CGL157
457600200604     C                   EVAL      CVEVE2 = CDEVE2                                            CGL157
457700200604     C                   EVAL      CVEVS2 = CDEVS2                                            CGL157
457800200604     C                   EVAL      CVEVE3 = CDEVE3                                            CGL157
457900200604     C                   EVAL      CVEVS3 = CDEVS3                                            CGL157
458000200604     C                   EVAL      CVEVE4 = CDEVE4                                            CGL157
458100200604     C                   EVAL      CVEVS4 = CDEVS4                                            CGL157
458200200604     C                   EVAL      CVEVE5 = CDEVE5                                            CGL157
458300200604     C                   EVAL      CVEVS5 = CDEVS5                                            CGL157
458400200604     C                   EVAL      CVTINN = CDTINN                                            CGL157
458500200604     C                   EVAL      CVEFFD = CDEFFD                                            CGL157
458600200604     C                   EVAL      CVEXPD = CDEXPD                                            CGL157
458700200604     C                   EVAL      CVCODO = CDCODO                                            CGL157
458800200604     C                   EVAL      CVJACM = CDJACM                                            CGL157
458900200604     C                   EVAL      CVMAIL = CDMAIL                                            CGL157
459000200604     C                   EVAL      CVPHON = CDPHON                                            CGL157
459100200604     C                   EVAL      CVRPAY = CDRPAY                                            CGL157
459200200604     C                   EVAL      CVTINS = CDTINS                                            CGL177
459300200604                                                                                              CGL157
459400200604     C                   IF        CDCTRY = BBCOLC                                            CGL157
459500200604     C                   EVAL      CVCODO = 'Y'                                               CGL157
459600200604     C                   ENDIF                                                                CGL157
459700200604                                                                                              CGL157
459800200604     C                   EVAL      PCrsdF(X) = SDVCRSD                                        CGL157
459900200604     C                   EVAL      X = X + 1                                                  CGL157
460000200604     C     DDCUSN        READE     SDCRSDL0                                                   CGL157
460100200604     C                   ENDDO                                                                CGL157
460200200604                                                                                              CGL157
460300200604     C                   ENDSR                                                                CGL157
460400200604      *****************************************************************                       CSD079
460500200604      /EJECT                                                                                  CSD079
460600200604      *****************************************************************                       CSD079
460700200604      *                                                               *                       CSD079
460800200604      *  RTVCUFO - RETRIEVE Customer Future and Options Details       *                       CSD079
460900200604      *                                                               *                       CSD079
461000200604      *****************************************************************                       CSD079
461100200604     C     RTVCUFO       BEGSR                                                                CSD079
461200200604                                                                                              CSD079
461300200604      ** Access Customer Future and Options Details                                           CSD079
461400200604                                                                                              CSD079
461500200604     C     DDCUSN        CHAIN     SDFOCSLR                           51                      CSD079
461600200604                                                                                              CSD079
461700200604      ** If Insert Record Found - Error                                                       CSD079
461800200604                                                                                              CSD079
461900200604     C     DDACTN        IFEQ      'I'                                                        CSD079
462000200604     C     *IN51         IFEQ      *OFF                                                       CSD079
462100200604     C**********         MOVEL     'N'           OKCUST                                CSD079 CSD091
462200200604     C**********         ADD       1             Ix                                    CSD079 CSD091
462300200604     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                        CSD079 CSD091
462400200604     C**********         MOVEL     'USR0175'     MsgIdArr(Ix)                          CSD079 CSD091
462500200604                                                                                              CSD091
462600200604     C**********         EVAL      OKCUST = 'W'                                      CSD091 AR855391
462700200604     C**********         EVAL      WIx = WIx + 1                                     CSD091 AR855391
462800200604     C**********         EVAL      WFldNamArr(WIx) = 'DDCUSN'                        CSD091 AR855391
462900200604     C**********         EVAL      WMsgIDArr(WIx) = 'USR0175'                        CSD091 AR855391
463000200604                                                                                            AR855391
463100200604     C                   MOVEL     'N'           OKCUST                                     AR855391
463200200604     C                   ADD       1             Ix                                         AR855391
463300200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                             AR855391
463400200604     C                   MOVEL     'USR0175'     MsgIdArr(Ix)                               AR855391
463500200604                                                                                              CSD091
463600200604     C                   ENDIF                                                                CSD079
463700200604      *                                                                                       CSD079
463800200604      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
463900200604     C**********         ELSE                                                         CRE026 BG12238
464000200604      **********                                                                      CRE026 BG12238
464100200604      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
464200200604      **********                                                                      CRE026 BG12238
464300200604     C******IN51         IFEQ      '1'                                                CRE026 BG12238
464400200604     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
464500200604     C**********         ADD       1             Ix                                   CRE026 BG12238
464600200604     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
464700200604     C**********         MOVEL     'USR0174'     MsgIdArr(Ix)                         CRE026 BG12238
464800200604     C**********         ENDIF                                                        CRE026 BG12238
464900200604     C                   ENDIF                                                                CSD079
465000200604     C                   ENDSR                                                                CSD079
465100200604                                                                                              CSD079
465200200604      *****************************************************************                       CSD079
465300200604      /EJECT                                                                                  CSD079
465400200604      *****************************************************************                       CSD079
465500200604      *                                                               *                       CSD079
465600200604      *  RTVCUFN - RETRIEVE Customer Futures & options European       *                       CSD079
465700200604      *            Reporting                                          *                       CSD079
465800200604      *                                                               *                       CSD079
465900200604      *****************************************************************                       CSD079
466000200604     C     RTVCUFN       BEGSR                                                                CSD079
466100200604                                                                                              CSD079
466200200604      ** Access Customer Future and Options European Reporting details                        CSD079
466300200604                                                                                              CSD079
466400200604     C     DDCUSN        CHAIN     SDFOX1LR                           53                      CSD079
466500200604                                                                                              CSD079
466600200604      ** If Insert Record Found - Error                                                       CSD079
466700200604                                                                                              CSD079
466800200604     C     DDACTN        IFEQ      'I'                                                        CSD079
466900200604     C     *IN53         IFEQ      *OFF                                                       CSD079
467000200604     C                   MOVEL     'N'           OKCUST                                       CSD079
467100200604     C                   ADD       1             Ix                                           CSD079
467200200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
467300200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CSD079
467400200604     C                   ENDIF                                                                CSD079
467500200604      *                                                                                       CSD079
467600200604      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
467700200604     C**********         ELSE                                                         CRE026 BG12238
467800200604      **********                                                                      CRE026 BG12238
467900200604      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
468000200604      **********                                                                      CRE026 BG12238
468100200604     C******IN53         IFEQ      '1'                                                CRE026 BG12238
468200200604     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
468300200604     C**********         ADD       1             Ix                                   CRE026 BG12238
468400200604     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
468500200604     C**********         MOVEL     'Y2U0009'     MsgIdArr(Ix)                         CRE026 BG12238
468600200604     C**********         ENDIF                                                        CRE026 BG12238
468700200604     C                   ENDIF                                                                CSD079
468800200604     C                   ENDSR                                                                CSD079
468900200604                                                                                              CSD079
469000200604      *****************************************************************                       CSD079
469100200604      /EJECT                                                                                  CSD079
469200200604      *****************************************************************                       CSD079
469300200604      *                                                               *                       CSD079
469400200604      *  RTVCUPM - RETRIEVE Customer Portfolio Management Details     *                       CSD079
469500200604      *                                                               *                       CSD079
469600200604      *****************************************************************                       CSD079
469700200604     C     RTVCUPM       BEGSR                                                                CSD079
469800200604                                                                                              CSD079
469900200604      ** Access Customer Portfolio Management Details                                         CSD079
470000200604                                                                                              CSD079
470100200604     C     DDCUSN        CHAIN     SDPLCSLR                           52                      CSD079
470200200604                                                                                              CSD079
470300200604      ** If Insert Record Found - Error                                                       CSD079
470400200604                                                                                              CSD079
470500200604     C     DDACTN        IFEQ      'I'                                                        CSD079
470600200604     C     *IN52         IFEQ      *OFF                                                       CSD079
470700200604     C                   MOVEL     'N'           OKCUST                                       CSD079
470800200604     C                   ADD       1             Ix                                           CSD079
470900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
471000200604     C                   MOVEL     'USR2323'     MsgIdArr(Ix)                                 CSD079
471100200604     C                   END                                                                  CSD079
471200200604      *                                                                                       CSD079
471300200604      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
471400200604     C**********         ELSE                                                         CRE026 BG12238
471500200604      **********                                                                      CRE026 BG12238
471600200604      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
471700200604      **********                                                                      CRE026 BG12238
471800200604     C******IN52         IFEQ      '1'                                                CRE026 BG12238
471900200604     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
472000200604     C**********         ADD       1             Ix                                   CRE026 BG12238
472100200604     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
472200200604     C**********         MOVEL     'USR2322'     MsgIdArr(Ix)                         CRE026 BG12238
472300200604     C**********         ENDIF                                                        CRE026 BG12238
472400200604     C                   ENDIF                                                                CSD079
472500200604     C                   ENDSR                                                                CSD079
472600200604                                                                                              CSD079
472700200604      *****************************************************************                       CSD079
472800200604      /EJECT                                                                                  CSD079
472900200604      *****************************************************************                       CSD079
473000200604      *                                                               *                       CSD079
473100200604      *  RTVCULX2 - RETRIEVE Lux(European Reporting) file             *                       CSD079
473200200604      *                                                               *                       CSD079
473300200604      *****************************************************************                       CSD079
473400200604     C     RTVCULX2      BEGSR                                                                CSD079
473500200604                                                                                              CSD079
473600200604      ** Access Lux(European Reporting) file                                                  CSD079
473700200604                                                                                              CSD079
473800200604     C                   MOVEL     DDCUSN        VFCUST                                       CSD079
473900200604     C     VFCUST        CHAIN     SDCUX2LR                           54                      CSD079
474000200604                                                                                              CSD079
474100200604      ** If Insert Record Found - Error                                                       CSD079
474200200604                                                                                              CSD079
474300200604     C     DDACTN        IFEQ      'I'                                                        CSD079
474400200604     C     *IN54         IFEQ      *OFF                                                       CSD079
474500200604     C                   MOVEL     'N'           OKCUST                                       CSD079
474600200604     C                   ADD       1             Ix                                           CSD079
474700200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
474800200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CSD079
474900200604     C                   ENDIF                                                                CSD079
475000200604                                                                                              CSD079
475100200604      ** If Delete, Amend or Enquire                                                          CSD079
475200200604     C                   ELSE                                                                 CSD079
475300200604                                                                                              CSD079
475400200604      ** If Live Record not Found - Error                                                     CSD079
475500200604                                                                                              CSD079
475600200604     C     *IN54         IFEQ      *ON                                                        CSD079
475700200604     C                   MOVEL     'N'           OKCUST                                       CSD079
475800200604     C                   ADD       1             Ix                                           CSD079
475900200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
476000200604     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)                                 CSD079
476100200604     C                   ENDIF                                                                CSD079
476200200604     C                   ENDIF                                                                CSD079
476300200604     C                   ENDSR                                                                CSD079
476400200604                                                                                              CSD079
476500200604      *****************************************************************                       CSD079
476600200604      /EJECT                                                                                  CSD079
476700200604      *****************************************************************                       CSD079
476800200604      *                                                               *                       CSD079
476900200604      *  RTVCULX1 - RETRIEVE Lux(IBLC - Extended Information) file    *                       CSD079
477000200604      *                                                               *                       CSD079
477100200604      *****************************************************************                       CSD079
477200200604     C     RTVCULX1      BEGSR                                                                CSD079
477300200604                                                                                              CSD079
477400200604      ** Access Customer Portfolio Management Details                                         CSD079
477500200604                                                                                              CSD079
477600200604     C                   MOVEL     DDCUSN        CUCNUM                                       CSD079
477700200604     C     CUCNUM        CHAIN     SDCUX1LR                           55                      CSD079
477800200604                                                                                              CSD079
477900200604      ** If Insert Record Found - Error                                                       CSD079
478000200604                                                                                              CSD079
478100200604     C     DDACTN        IFEQ      'I'                                                        CSD079
478200200604     C     *IN55         IFEQ      *OFF                                                       CSD079
478300200604     C                   MOVEL     'N'           OKCUST                                       CSD079
478400200604     C                   ADD       1             Ix                                           CSD079
478500200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
478600200604     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CSD079
478700200604     C                   ENDIF                                                                CSD079
478800200604                                                                                              CSD079
478900200604      ** If Delete, Amend or Enquire                                                          CSD079
479000200604                                                                                              CSD079
479100200604     C                   ELSE                                                                 CSD079
479200200604                                                                                              CSD079
479300200604      ** If Live Record not Found - Error                                                     CSD079
479400200604                                                                                              CSD079
479500200604     C     *IN55         IFEQ      *ON                                                        CSD079
479600200604     C                   MOVEL     'N'           OKCUST                                       CSD079
479700200604     C                   ADD       1             Ix                                           CSD079
479800200604     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
479900200604     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)                                 CSD079
480000200604     C                   ENDIF                                                                CSD079
480100200604     C                   ENDIF                                                                CSD079
480200200604     C                   ENDSR                                                                CSD079
480300200604                                                                                              CSD079
480400200604     ******************************************************************                       CSD079
480500200604      /EJECT                                                                                  CSD079
480600200604      *****************************************************************
480700200604      *                                                               *                    AR1086546
480800200604      * RTVCTNM - RETRIEVE Currency/Time of Netting Details           *                    AR1086546
480900200604      *                                                               *                    AR1086546
481000200604      *****************************************************************                    AR1086546
481100200604     C     RTVCTNM       BEGSR                                                             AR1086546
481200200604                                                                                           AR1086546
481300200604      ** Access Customer Risk Weighted Assets Details                                      AR1086546
481400200604                                                                                           AR1086546
481500200604     C                   CALLB     'SDCTNMRTV'                                             AR1086546
481600200604                                                                                           AR1086546
481700200604      ** Inputs                                                                            AR1086546
481800200604      ** Return code                                                                       AR1086546
481900200604                                                                                           AR1086546
482000200604     C                   PARM                    RetCodeIn                                 AR1086546
482100200604                                                                                           AR1086546
482200200604      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                              AR1086546
482300200604      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                          AR1086546
482400200604                                                                                           AR1086546
482500200604     C                   PARM                    ModeofOp                                  AR1086546
482600200604                                                                                           AR1086546
482700200604      ** Response mode                                                                     AR1086546
482800200604                                                                                           AR1086546
482900200604     C                   PARM                    RespMode                                  AR1086546
483000200604                                                                                           AR1086546
483100200604      ** Action Code                                                                       AR1086546
483200200604                                                                                           AR1086546
483300200604     C                   PARM                    DDACTN                                    AR1086546
483400200604                                                                                           AR1086546
483500200604      ** (Midas) Customer Number                                                           AR1086546
483600200604                                                                                           AR1086546
483700200604     C                   PARM                    DDCUSN                                    AR1086546
483800200604                                                                                           AR1086546
483900200604      ** From Customer Flag                                                                AR1086546
484000200604                                                                                           AR1086546
484100200604     C                   PARM      'Y'           From_Cust         1                       AR1086546
484200200604                                                                                           AR1086546
484300200604      ** Outputs                                                                           AR1086546
484400200604      ** Transaction Details in File Format                                                AR1086546
484500200604                                                                                           AR1086546
484600200604     C                   PARM                    CtnmFilFmt                                AR1086546
484700200604                                                                                           AR1086546
484800200604      ** OK - Action code                                                                  AR1086546
484900200604                                                                                           AR1086546
485000200604     C                   PARM                    OKACTN                                    AR1086546
485100200604                                                                                           AR1086546
485200200604      ** OK - Customer Number                                                              AR1086546
485300200604                                                                                           AR1086546
485400200604     C                   PARM                    OKCUST                                    AR1086546
485500200604                                                                                           AR1086546
485600200604      ** Error fields/message IDs/message data (arrays) from/to caller                     AR1086546
485700200604                                                                                           AR1086546
485800200604     C                   PARM                    FldNameArr                                AR1086546
485900200604     C                   PARM                    MsgIDArr                                  AR1086546
486000200604     C                   PARM                    MsgDtaArr                                 AR1086546
486100200604                                                                                           AR1086546
486200200604      ** Array index (3P0) from/to caller                                                  AR1086546
486300200604                                                                                           AR1086546
486400200604     C                   PARM                    Ix                                        AR1086546
486500200604     C                   ENDSR                                                             AR1086546
486600200604                                                                                           AR1086546
486700200604      *****************************************************************                    AR1086546
486800200604      /EJECT                                                                               AR1086546
486900200604      *****************************************************************                    AR1086546
487000200604      * *INZSR - INITIAL PROCESSING
487100200604      *****************************************************************
487200200604     C     *INZSR        BEGSR
487300200604      *
487400200604      * Parameters
487500200604      *
487600200604     C     *ENTRY        PLIST
487700200604      *
487800200604      * INPUTS
487900200604      *
488000200604      * Return code
488100200604     C                   PARM                    RetCodeIn
488200200604      *
488300200604      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
488400200604      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
488500200604      *
488600200604     C                   PARM                    ModeofOp          6
488700200604      *
488800200604      * Response mode
488900200604     C                   PARM                    RespMode          1
489000200604      *
489100200604      * Action Code
489200200604     C                   PARM                    DDACTN            1
489300200604      *
489400200604      * Front Office Transaction ID
489500200604     C                   PARM                    FOTRID           20
489600200604      *
489700200604      * (Midas) Customer number
489800200604     C                   PARM                    DDCUSN            6
489900200604      * Base Rate Auth Req                                                                    CSD012
490000200604     C                   PARM                    AUTHRQ            1                          CSD012
490100200604      * Authorisation Mode                                                                    CSD012
490200200604     C                   PARM                    AUTHMD            1                          CSD012
490300200604      *
490400200604      *  Base Rate Tax option feature is switched on
490500200604     C                   PARM                    S01383            1
490600200604      *
490700200604      *  Private Banking Customer details is switched on
490800200604     C                   PARM                    BGN4ST            1
490900200604      ** Global Data Layout                                                                   CGP001
491000200604     C                   PARM                    CGP001            1                          CGP001
491100200604      *
491200200604      ** Transaction Type                                                                     CSD028
491300200604     C                   PARM                    TransType                                    CSD028
491400200604      *                                                                                       CSD028
491500200604      *  Acceptance Mode                                                                      249593
491600200604     C                   PARM                    PAccMde           1                          249593
491700200604      *  Update (Y/N)                                                                         249593
491800200604     C                   PARM                    PUpdYN            1                          249593
491900200604      ** Acceptance Mode                                                                      CSD031
492000200604     C**********         PARM                    PAccMde                             CSD031 BUG13525
492100200604      ** Update (Y/N)                                                                         CSD031
492200200604     C**********         PARM                    PUpdYN                              CSD031 BUG13525
492300200604      * OUTPUTS
492400200604      *
492500200604      * (Current) Customer in file format
492600200604      * (Current) Customer Base Rate Tax in file format
492700200604      * (Current) Private Banking Customer in file format
492800200604      ** (Current) Customer Swift Details in file format                                      CSW207
492900200604      ** (Current) Global Customer X-Reference in file format                                 CGP001
493000200604     C                   PARM                    CustFilFmt
493100200604     C                   PARM                    CuBrFilFmt
493200200604     C                   PARM                    CuPbFilFmt
493300200604     C                   PARM                    CuTIFilFMt                                  BUG3362
493400200604     C                   PARM                    GCustFilFmt                                  CGP001
493500200604     C                   PARM                    SwftFilFmt                                   CSW207
493600200604     C                   PARM                    CuSW13                                       CFT050
493700200604     C                   PARM                    CuXcFilFmt                                   CGL132
493800200604     C                   PARM                    CuFaFilFmt                                   CGL132
493900200604     C                   PARM                    CrsdFilFmt                                   CGL157
494000200604     C                   PARM                    PCrsdF                                       CGL157
494100200604     C                   PARM                    CumiFilFmt                                   CSD079
494200200604     C                   PARM                    CuadFilFmt                                   CSD079
494300200604     C                   PARM                    SfeeFilFmt                                   CSD079
494400200604     C                   PARM                    ChecFilFmt                                   CSD079
494500200604     C                   PARM                    CusfFilFmt                                   CSD079
494600200604     C                   PARM                    RwanFilFmt                                   CSD079
494700200604     C                   PARM                    CufoFilFmt                                   CSD079
494800200604     C                   PARM                    CufnFilFmt                                   CSD079
494900200604     C                   PARM                    CupmFilFmt                                   CSD079
495000200604     C                   PARM                    CueuFilFmt                                   CSD079
495100200604     C                   PARM                    CuibfFilFmt                                  CSD079
495200200604     C                   PARM                    TranInCUAH                                   CER059
495300200604     C                   PARM                    TranInCCTX                                   CER059
495400200604     C                   PARM                    CtnmFilFmt                                AR1086546
495500200604     C                   PARM                    TranInPrim                                   CFT050
495600200604     C                   PARM                    TranInSeco                                   CFT050
495700200604     C                   PARM                    TranInMT3X                                   CFT050
495800200604      *
495900200604      * OK - Action code
496000200604     C                   PARM                    OKACTN            1
496100200604      *
496200200604      * OK - Customer Number
496300200604     C                   PARM                    OKCUST            1
496400200604      *
496500200604      * Error fields/message IDs/message data (arrays) from/to caller
496600200604     C                   PARM                    FldNameArr
496700200604     C                   PARM                    MsgIdArr
496800200604     C                   PARM                    MsgDtaArr
496900200604      *
497000200604      * Array index (3P0) from/to caller
497100200604     C                   PARM                    Ix
497200200604      *                                                                                     BUG23518
497300200604      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
497400200604      *                                                                                     BUG23518
497500200604     C                   PARM                    WFldNamArr                                 BUG23518
497600200604     C                   PARM                    WMsgIDArr                                  BUG23518
497700200604     C                   PARM                    WMsgDtaArr                                 BUG23518
497800200604      *                                                                                     BUG23518
497900200604      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
498000200604      *                                                                                     BUG23518
498100200604     C                   PARM                    WIx                                        BUG23518
498200200604     C/COPY WNCPYSRC,SDCUSDIC06
498300200604      *
498400200604      ** Parameter list for calling AOSVALR0                                                  CSD027
498500200604     C     P_AOSVALR0    PList                                                                CSD027
498600200604      * Return Code (Output)                                                                  CSD027
498700200604     C                   Parm                    PRetCode                                     CSD027
498800200604      * System Value to be retrieved (Input)                                                  CSD027
498900200604     C                   Parm                    PSysValK1                                    CSD027
499000200604      * Value returned (Output)                                                               CSD027
499100200604     C                   Parm                    PSysVal1                                     CSD027
499200200604     C                   Parm                    PSysValK2                                    CSD027
499300200604     C                   Parm                    PSysVal2                                     CSD027
499400200604     C                   Parm                    PSysValK3                                    CSD027
499500200604     C                   Parm                    PSysVal3                                     CSD027
499600200604     C                   Parm                    PSysValK4                                    CSD027
499700200604     C                   Parm                    PSysVal4                                     CSD027
499800200604     C                   Parm                    PSysValK5                                    CSD027
499900200604     C                   Parm                    PSysVal5                                     CSD027
500000200604     C                   Parm                    PSysValK6                                    CSD027
500100200604     C                   Parm                    PSysVal6                                     CSD027
500200200604     C                   Parm                    PSysValK7                                    CSD027
500300200604     C                   Parm                    PSysVal7                                     CSD027
500400200604     C                   Parm                    PSysValK8                                    CSD027
500500200604     C                   Parm                    PSysVal8                                     CSD027
500600200604     C                   Parm                    PSysValK9                                    CSD027
500700200604     C                   Parm                    PSysVal9                                     CSD027
500800200604     C                   Parm                    PSysValK10                                   CSD027
500900200604     C                   Parm                    PSysVal10                                    CSD027
501000200604      *                                                                                       CSD027
501100200604      ** Parameter list for calling SDCUSTISO                                                 CSD027
501200200604     C     P_SDCUSTISO   PList                                                                CSD027
501300200604      ** Customer Number (Input)                                                              CSD027
501400200604     C                   Parm                    PCust                                        CSD027
501500200604      ** Validity Flags (Output)                                                              CSD027
501600200604     C                   Parm                    PValid                                       CSD027
501700200604      ** Check Digit (Output)                                                                 CSD027
501800200604     C                   Parm                    PCheckDigit                                  CSD027
501900200604     C                   Parm                    @data             2                        BUG15872
502000200604      *
502100200604      ** Initialize program name
502200200604      *
502300200604     C                   MOVEL     'SDCUSDRTV'   DBPGM
502400200604      *                                                                                     BUG23518
502500200604      ** Key field definition for Country of Tax file SDACTXL0                              BUG23518
502600200604      *                                                                                     BUG23518
502700200604     C     KLActx        KLIST                                                              BUG23518
502800200604     C                   KFLD                    KFCusn                                     BUG23518
502900200604     C                   KFLD                    KFCTax                                     BUG23518
503000200604      *
503100200604      **  GET RUNDAT to access MULTI-BRANCHING flag.
503200200604      *
503300200604     C     *DTAARA       DEFINE                  RUNDAT
503400200604     C                   IN        RUNDAT
503500200604     C******DTAARA       DEFINE                  ZMUSER                              CSD031 BUG13525
503600200604     C**********         IN        ZMUSER                                            CSD031 BUG13525
503700200604      *
503800200604      ** ACCESS BANK DETAILS
503900200604      *
504000200604     C                   CALL      'AOBANKR0'
504100200604     C                   PARM      *BLANKS       @RTCD             7
504200200604     C                   PARM      '*FIRST '     @OPTN             7
504300200604     C     SDBANK        PARM      SDBANK        DSFDY
504400200604      *
504500200604      * DATABASE ERROR
504600200604      *
504700200604     C     @RTCD         IFNE      *BLANKS
504800200604     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
504900200604     C                   MOVEL     '901'         DBASE                          * DBERR 901*
505000200604     C                   MOVEL     @OPTN         DBKEY                          ************
505100200604     C                   EXSR      *PSSR
505200200604     C                   END
505300200604                                                                                              CSD079
505400200604      ** Access Module Details                                                                CSD079
505500200604                                                                                              CSD079
505600200604     C                   CALL      'AOMMODR0'                                                 CSD079
505700200604     C                   PARM      '*DBERR '     @RTCD                                        CSD079
505800200604     C                   PARM      '*FIRST '     @OPTN                                        CSD079
505900200604     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSD079
506000200604                                                                                              CSD021
506100200604      ** Access SAR details file to determine if CSD021                                       CSD021
506200200604      ** (System Generated Customer Number) is on.                                            CSD021
506300200604      *                                                                                       CSD021
506400200604     C                   CALLB     'AOSARDR0'                                                 CSD021
506500200604     C                   PARM      *BLANKS       @RTCD                                        CSD021
506600200604     C                   PARM      '*VERIFY'     @OPTN                                        CSD021
506700200604     C                   PARM      'CSD021'      @SARD             6                          CSD021
506800200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
506900200604      *                                                                                       CSD021
507000200604      * DATABASE ERROR                                                                        CSD021
507100200604      *                                                                                       CSD021
507200200604     C     @RTCD         IFNE      *BLANKS                                                    CSD021
507300200604     C     @RTCD         ANDNE     '*NRF   '                                                  CSD021
507400200604     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD021
507500200604     C                   MOVEL     '902'         DBASE                                        CSD021
507600200604     C                   MOVEL     'CSD021'      DBKEY                                        CSD021
507700200604     C                   EXSR      *PSSR                                                      CSD021
507800200604     C                   ENDIF                                                                CSD021
507900200604      *                                                                                       CSD021
508000200604     C     @RTCD         IFEQ      *BLANK                                                     CSD021
508100200604     C                   MOVEL     'Y'           CSD021            1                          CSD021
508200200604     C                   ELSE                                                                 CSD021
508300200604     C                   MOVEL     'N'           CSD021                                       CSD021
508400200604     C                   ENDIF                                                                CSD021
508500200604      *                                                                                      BUG7233
508600200604      ** Access SAR details file to determine if CSD023                                      BUG7233
508700200604      *                                                                                      BUG7233
508800200604     C                   CALLB     'AOSARDR0'                                                BUG7233
508900200604     C                   PARM      *BLANKS       @RTCD                                       BUG7233
509000200604     C                   PARM      '*VERIFY'     @OPTN                                       BUG7233
509100200604     C                   PARM      'CSD023'      @SARD             6                         BUG7233
509200200604     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG7233
509300200604      *                                                                                      BUG7233
509400200604      * DATABASE ERROR                                                                       BUG7233
509500200604      *                                                                                      BUG7233
509600200604     C     @RTCD         IFNE      *BLANKS                                                   BUG7233
509700200604     C     @RTCD         ANDNE     '*NRF   '                                                 BUG7233
509800200604     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG7233
509900200604     C                   MOVEL     '912'         DBASE                                       BUG7233
510000200604     C                   MOVEL     'CSD023'      DBKEY                                       BUG7233
510100200604     C                   EXSR      *PSSR                                                     BUG7233
510200200604     C                   ENDIF                                                               BUG7233
510300200604      *                                                                                      BUG7233
510400200604     C     @RTCD         IFEQ      *BLANK                                                    BUG7233
510500200604     C                   MOVEL     'Y'           CSD023            1                         BUG7233
510600200604     C                   ELSE                                                                BUG7233
510700200604     C                   MOVEL     'N'           CSD023                                      BUG7233
510800200604     C                   ENDIF                                                               BUG7233
510900200604                                                                                              CSD028
511000200604      ** Check if feature CSD028 is switched on                                               CSD028
511100200604                                                                                              CSD028
511200200604     C                   CALLB     'AOSARDR0'                                                 CSD028
511300200604     C                   PARM      *BLANKS       P@Rtcd                                       CSD028
511400200604     C                   PARM      '*VERIFY'     P@Optn                                       CSD028
511500200604     C                   PARM      'CSD028'      P@Sard                                       CSD028
511600200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
511700200604                                                                                              CSD028
511800200604      ** Database Error                                                                       CSD028
511900200604                                                                                              CSD028
512000200604     C                   IF        P@Rtcd <> *BLANKS AND P@Rtcd <> '*NRF   '                  CSD028
512100200604     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD028
512200200604     C                   MOVEL     '913'         DBASE                                        CSD028
512300200604     C                   MOVEL     'CSD028'      DBKEY                                        CSD028
512400200604     C                   EXSR      *PSSR                                                      CSD028
512500200604     C                   ENDIF                                                                CSD028
512600200604                                                                                              CSD028
512700200604     C                   IF        P@Rtcd = *BLANK                                            CSD028
512800200604     C                   EVAL      CSD028 = 'Y'                                               CSD028
512900200604     C                   ELSE                                                                 CSD028
513000200604     C                   EVAL      CSD028 = 'N'                                               CSD028
513100200604     C                   ENDIF                                                                CSD028
513200200604                                                                                              CSD079
513300200604      ** Check if enhancement S01425 is on                                                    CSD079
513400200604                                                                                              CSD079
513500200604     C                   CALLB     'AOSARDR0'                                                 CSD079
513600200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
513700200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
513800200604     C                   PARM      'S01425'      PSARD                                        CSD079
513900200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
514000200604                                                                                              CSD079
514100200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
514200200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
514300200604     C                   EVAL      DBKEY  = 'S01425'                                          CSD079
514400200604     C                   EVAL      DBASE  = 921                                               CSD079
514500200604     C                   EXSR      *PSSR                                                      CSD079
514600200604     C                   ENDIF                                                                CSD079
514700200604      *                                                                                       CSD079
514800200604     C                   IF        PRTCD = *BLANKS                                            CSD079
514900200604     C                   EVAL      S01425 = 'Y'                                               CSD079
515000200604     C                   ELSE                                                                 CSD079
515100200604     C                   EVAL      S01425 = 'N'                                               CSD079
515200200604     C                   ENDIF                                                                CSD079
515300200604                                                                                              CSD079
515400200604      ** Check if enhancement CSD008 is on                                                    CSD079
515500200604                                                                                              CSD079
515600200604     C                   CALLB     'AOSARDR0'                                                 CSD079
515700200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
515800200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
515900200604     C                   PARM      'CSD008'      PSARD                                        CSD079
516000200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
516100200604                                                                                              CSD079
516200200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
516300200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
516400200604     C                   EVAL      DBKEY  = 'CSD008'                                          CSD079
516500200604     C                   EVAL      DBASE  = 922                                               CSD079
516600200604     C                   EXSR      *PSSR                                                      CSD079
516700200604     C                   ENDIF                                                                CSD079
516800200604      *                                                                                       CSD079
516900200604     C                   IF        PRTCD = *BLANKS                                            CSD079
517000200604     C                   EVAL      CSD008 = 'Y'                                               CSD079
517100200604     C                   ELSE                                                                 CSD079
517200200604     C                   EVAL      CSD008 = 'N'                                               CSD079
517300200604     C                   ENDIF                                                                CSD079
517400200604                                                                                              CSD079
517500200604      ** Check if enhancement CDL002 is on                                                    CSD079
517600200604                                                                                              CSD079
517700200604     C                   CALLB     'AOSARDR0'                                                 CSD079
517800200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
517900200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
518000200604     C                   PARM      'CDL002'      PSARD                                        CSD079
518100200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
518200200604                                                                                              CSD079
518300200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
518400200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
518500200604     C                   EVAL      DBKEY  = 'CDL002'                                          CSD079
518600200604     C                   EVAL      DBASE  = 916                                               CSD079
518700200604     C                   EXSR      *PSSR                                                      CSD079
518800200604     C                   ENDIF                                                                CSD079
518900200604      *                                                                                       CSD079
519000200604     C                   IF        PRTCD = *BLANKS                                            CSD079
519100200604     C                   EVAL      CDL002 = 'Y'                                               CSD079
519200200604     C                   ELSE                                                                 CSD079
519300200604     C                   EVAL      CDL002 = 'N'                                               CSD079
519400200604     C                   ENDIF                                                                CSD079
519500200604                                                                                              CSD079
519600200604      ** Check if enhancement CDL006 is on                                                    CSD079
519700200604                                                                                              CSD079
519800200604     C                   CALLB     'AOSARDR0'                                                 CSD079
519900200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
520000200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
520100200604     C                   PARM      'CDL006'      PSARD                                        CSD079
520200200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
520300200604                                                                                              CSD079
520400200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
520500200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
520600200604     C                   EVAL      DBKEY  = 'CDL006'                                          CSD079
520700200604     C                   EVAL      DBASE  = 917                                               CSD079
520800200604     C                   EXSR      *PSSR                                                      CSD079
520900200604     C                   ENDIF                                                                CSD079
521000200604      *                                                                                       CSD079
521100200604     C                   IF        PRTCD = *BLANKS                                            CSD079
521200200604     C                   EVAL      CDL006 = 'Y'                                               CSD079
521300200604     C                   ELSE                                                                 CSD079
521400200604     C                   EVAL      CDL006 = 'N'                                               CSD079
521500200604     C                   ENDIF                                                                CSD079
521600200604                                                                                              CSD079
521700200604      ** Check if enhancement CGL018 is on                                                    CSD079
521800200604                                                                                              CSD079
521900200604     C                   CALLB     'AOSARDR0'                                                 CSD079
522000200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
522100200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
522200200604     C                   PARM      'CGL018'      PSARD                                        CSD079
522300200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
522400200604                                                                                              CSD079
522500200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
522600200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
522700200604     C                   EVAL      DBKEY  = 'CGL018'                                          CSD079
522800200604     C                   EVAL      DBASE  = 918                                               CSD079
522900200604     C                   EXSR      *PSSR                                                      CSD079
523000200604     C                   ENDIF                                                                CSD079
523100200604      *                                                                                       CSD079
523200200604     C                   IF        PRTCD = *BLANKS                                            CSD079
523300200604     C                   EVAL      CGL018 = 'Y'                                               CSD079
523400200604     C                   ELSE                                                                 CSD079
523500200604     C                   EVAL      CGL018 = 'N'                                               CSD079
523600200604     C                   ENDIF                                                                CSD079
523700200604                                                                                              CSD079
523800200604     ** Check if enhancement CSD079 is on                                                     CSD079
523900200604                                                                                              CSD079
524000200604     C                   CALLB     'AOSARDR0'                                                 CSD079
524100200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
524200200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
524300200604     C                   PARM      'CSD079'      PSARD                                        CSD079
524400200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
524500200604                                                                                              CSD079
524600200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
524700200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
524800200604     C                   EVAL      DBKEY  = 'CSD079'                                          CSD079
524900200604     C                   EVAL      DBASE  = 919                                               CSD079
525000200604     C                   EXSR      *PSSR                                                      CSD079
525100200604     C                   ENDIF                                                                CSD079
525200200604      *                                                                                       CSD079
525300200604     C                   IF        PRTCD = *BLANKS                                            CSD079
525400200604     C                   EVAL      CSD079 = 'Y'                                               CSD079
525500200604     C                   ELSE                                                                 CSD079
525600200604     C                   EVAL      CSD079 = 'N'                                               CSD079
525700200604     C                   ENDIF                                                                CSD079
525800200604                                                                                              CSD079
525900200604      ** Check if enhancement ULX004 is on                                                    CSD079
526000200604                                                                                              CSD079
526100200604     C                   CALLB     'AOSARDR0'                                                 CSD079
526200200604     C                   PARM      *BLANKS       @RTCD                                        CSD079
526300200604     C                   PARM      '*VERIFY'     @OPTN                                        CSD079
526400200604     C                   PARM      'ULX004'      @SARD                                        CSD079
526500200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
526600200604                                                                                              CSD079
526700200604      ** Database Error                                                                       CSD079
526800200604                                                                                              CSD079
526900200604     C     @RTCD         IFNE      *BLANKS                                                    CSD079
527000200604     C     @RTCD         ANDNE     '*NRF   '                                                  CSD079
527100200604     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD079
527200200604     C                   MOVEL     903           DBASE                                        CSD079
527300200604     C                   MOVEL     'ULX004'      DBKEY                                        CSD079
527400200604     C                   EXSR      *PSSR                                                      CSD079
527500200604     C                   ENDIF                                                                CSD079
527600200604      *                                                                                       CSD079
527700200604     C     @RTCD         IFEQ      *BLANK                                                     CSD079
527800200604     C                   MOVEL     'Y'           ULX004                                       CSD079
527900200604     C                   ELSE                                                                 CSD079
528000200604     C                   MOVEL     'N'           ULX004                                       CSD079
528100200604     C                   ENDIF                                                                CSD079
528200200604                                                                                              CSD079
528300200604      ** Check if enhancement ULX609 is on                                                    CSD079
528400200604                                                                                              CSD079
528500200604     C                   CALLB     'AOSARDR0'                                                 CSD079
528600200604     C                   PARM      *BLANKS       @RTCD                                        CSD079
528700200604     C                   PARM      '*VERIFY'     @OPTN                                        CSD079
528800200604     C                   PARM      'ULX609'      @SARD                                        CSD079
528900200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
529000200604                                                                                              CSD079
529100200604      ** Database Error                                                                       CSD079
529200200604                                                                                              CSD079
529300200604     C     @RTCD         IFNE      *BLANKS                                                    CSD079
529400200604     C     @RTCD         ANDNE     '*NRF   '                                                  CSD079
529500200604     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD079
529600200604     C                   MOVEL     925           DBASE                                        CSD079
529700200604     C                   MOVEL     'ULX609'      DBKEY                                        CSD079
529800200604     C                   EXSR      *PSSR                                                      CSD079
529900200604     C                   ENDIF                                                                CSD079
530000200604      *                                                                                       CSD079
530100200604     C     @RTCD         IFEQ      *BLANK                                                     CSD079
530200200604     C                   MOVEL     'Y'           ULX609                                       CSD079
530300200604     C                   ELSE                                                                 CSD079
530400200604     C                   MOVEL     'N'           ULX609                                       CSD079
530500200604     C                   ENDIF                                                                CSD079
530600200604                                                                                              CSD079
530700200604      ** Check if enhancement ULX043 is on                                                    CSD079
530800200604                                                                                              CSD079
530900200604     C                   CALLB     'AOSARDR0'                                                 CSD079
531000200604     C                   PARM      *BLANKS       PRTCD                                        CSD079
531100200604     C                   PARM      '*VERIFY'     POPTN                                        CSD079
531200200604     C                   PARM      'ULX043'      PSARD                                        CSD079
531300200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
531400200604                                                                                              CSD079
531500200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
531600200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
531700200604     C                   EVAL      DBKEY  = 'ULX043'                                          CSD079
531800200604     C                   EVAL      DBASE  = 924                                               CSD079
531900200604     C                   EXSR      *PSSR                                                      CSD079
532000200604     C                   ENDIF                                                                CSD079
532100200604      *                                                                                       CSD079
532200200604     C                   IF        PRTCD = *BLANKS                                            CSD079
532300200604     C                   EVAL      ULX043 = 'Y'                                               CSD079
532400200604     C                   ELSE                                                                 CSD079
532500200604     C                   EVAL      ULX043 = 'N'                                               CSD079
532600200604     C                   ENDIF                                                                CSD079
532700200604                                                                                           AR1086546
532800200604      ** Check if enhancement CDL025 is on                                                 AR1086546
532900200604                                                                                           AR1086546
533000200604     C                   CALLB     'AOSARDR0'                                              AR1086546
533100200604     C                   PARM      *BLANKS       PRTCD                                     AR1086546
533200200604     C                   PARM      '*VERIFY'     POPTN                                     AR1086546
533300200604     C                   PARM      'CDL025'      PSARD                                     AR1086546
533400200604     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1086546
533500200604                                                                                           AR1086546
533600200604     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '               AR1086546
533700200604     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR1086546
533800200604     C                   EVAL      DBKEY  = 'CDL025'                                       AR1086546
533900200604     C                   EVAL      DBASE  = 926                                            AR1086546
534000200604     C                   EXSR      *PSSR                                                   AR1086546
534100200604     C                   ENDIF                                                             AR1086546
534200200604      *                                                                                    AR1086546
534300200604     C                   IF        PRTCD = *BLANKS                                         AR1086546
534400200604     C                   EVAL      CDL025 = 'Y'                                            AR1086546
534500200604     C                   ELSE                                                              AR1086546
534600200604     C                   EVAL      CDL025 = 'N'                                            AR1086546
534700200604     C                   ENDIF                                                             AR1086546
534800200604                                                                                              CSD079
534900200604      ** Portfolios Supported is Customer                                                     CSD079
535000200604                                                                                              CSD079
535100200604      ** Check if Portfolio Management Enhancement is on                                      CSD079
535200200604                                                                                              CSD079
535300200604     C     BGPFMG        IFEQ      'Y'                                                        CSD079
535400200604     C                   CALLB     'AOPORTR0'                                                 CSD079
535500200604     C                   PARM      '*MSG    '    @RTCD                                        CSD079
535600200604     C                   PARM      '*FIRST  '    @OPTN                                        CSD079
535700200604     C     SDPORT        PARM      SDPORT        DSSDY                                        CSD079
535800200604      *                                                                                       CSD079
535900200604      * DATABASE ERROR                                                                        CSD079
536000200604      *                                                                                       CSD079
536100200604     C     @RTCD         IFNE      *BLANK                                                     CSD079
536200200604     C                   MOVEL     @OPTN         DBKEY                                        CSD079
536300200604     C                   MOVEL     'SDPORTPD'    DBFILE                                       CSD079
536400200604     C                   MOVEL     920           DBASE                                        CSD079
536500200604     C                   EXSR      *PSSR                                                      CSD079
536600200604     C                   ENDIF                                                                CSD079
536700200604                                                                                              CSD079
536800200604     C     FCPORS        IFEQ      'C'                                                        CSD079
536900200604     C                   MOVEL     'Y'           WUPMSC                                       CSD079
537000200604     C                   ELSE                                                                 CSD079
537100200604                                                                                              CSD079
537200200604      ** Retrieve Int Cust Branch - Branch Codes                                              CSD079
537300200604                                                                                              CSD079
537400200604     C                   EXSR      TWRVGN                                                     CSD079
537500200604                                                                                              CSD079
537600200604      ** Return code is Customer on branch codes                                              CSD079
537700200604                                                                                              CSD079
537800200604     C     W0RTN         IFEQ      'BRANCH'                                                   CSD079
537900200604     C                   MOVEL     'Y'           WUPMSC                                       CSD079
538000200604     C                   ELSE                                                                 CSD079
538100200604     C                   MOVEL     'N'           WUPMSC                                       CSD079
538200200604     C                   ENDIF                                                                CSD079
538300200604     C                   ENDIF                                                                CSD079
538400200604     C                   ELSE                                                                 CSD079
538500200604     C                   MOVEL     'N'           WUPMSC                                       CSD079
538600200604     C                   ENDIF                                                                CSD079
538700200604                                                                                              CSD031
538800200604      ** Check if CSD037 is enabled.                                                          CSD031
538900200604                                                                                              CSD031
539000200604     C**********         CALLB     'AOSARDR0'                                        CSD031 BUG13525
539100200604     C**********         PARM      *BLANKS       PRtCd                               CSD031 BUG13525
539200200604     C**********         PARM      '*VERIFY'     POptn                               CSD031 BUG13525
539300200604     C**********         PARM      'CSD037'      PSARD                               CSD031 BUG13525
539400200604     C*****SCSARD        PARM      SCSARD        DSFDY                               CSD031 BUG13525
539500200604                                                                                              CSD031
539600200604     C**********         IF        PRtCd = *BLANKS                                   CSD031 BUG13525
539700200604     C**********         EVAL      CSD037 = 'Y'                                      CSD031 BUG13525
539800200604     C**********         ELSE                                                        CSD031 BUG13525
539900200604                                                                                              CSD031
540000200604     C**********         IF        PRtCd <> '*NRF   '                                CSD031 BUG13525
540100200604     C******LOCK         IN        LDA                                               CSD031 BUG13525
540200200604     C**********         EVAL      DBFile = 'SCSARDPD'                               CSD031 BUG13525
540300200604     C*
540400200604     C**********         EVAL      DBase = 101                                       CSD031 BUG13525
540500200604     C**********         OUT       LDA                                               CSD031 BUG13525
540600200604     C**********         EXSR      *PSSR                                             CSD031 BUG13525
540700200604     C**********         ENDIF                                                       CSD031 BUG13525
540800200604                                                                                              CSD031
540900200604     C**********         ENDIF                                                       CSD031 BUG13525
541000200604      *                                                                                       CSD031
541100200604      *                                                                                     BUG23518
541200200604      ** Call AOSARDR0 to check for CER048                                                  BUG23518
541300200604      *                                                                                     BUG23518
541400200604     C                   CALLB     'AOSARDR0'                                               BUG23518
541500200604     C                   PARM      *BLANKS       P@Rtcd                                     BUG23518
541600200604     C                   PARM      '*VERIFY'     P@Optn                                     BUG23518
541700200604     C                   PARM      'CER048'      P@Sard                                     BUG23518
541800200604     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23518
541900200604      *                                                                                     BUG23518
542000200604     C                   IF        P@Rtcd = *BLANKS                                         BUG23518
542100200604     C                   EVAL      CER048 = 'Y'                                             BUG23518
542200200604     C                   ELSE                                                               BUG23518
542300200604     C                   EVAL      CER048 = 'N'                                             BUG23518
542400200604     C                   ENDIF                                                              BUG23518
542500200604      *                                                                                     BUG23518
542600200604     C                   IF        P@Rtcd <> '*NRF' AND                                     BUG23518
542700200604     C                             P@Rtcd <> *BLANKS                                        BUG23518
542800200604      *                                                                                     BUG23518
542900200604     C     *LOCK         IN        LDA                                                      BUG23518
543000200604     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG23518
543100200604     C                   EVAL      DBKEY = 'CER048'                                         BUG23518
543200200604     C                   EVAL      DBASE = 914                                              BUG23518
543300200604     C                   OUT       LDA                                                      BUG23518
543400200604     C                   EXSR      *PSSR                                                    BUG23518
543500200604      *                                                                                     BUG23518
543600200604     C                   ENDIF                                                              BUG23518
543700200604      *                                                                                     BUG23518
543800200604      ** Call AOSARDR0 to check for CER034                                                    CER059
543900200604                                                                                              CER059
544000200604     C                   CALLB     'AOSARDR0'                                                 CER059
544100200604     C                   PARM      *BLANKS       P@Rtcd                                       CER059
544200200604     C                   PARM      '*VERIFY'     P@Optn                                       CER059
544300200604     C                   PARM      'CER034'      P@Sard                                       CER059
544400200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
544500200604                                                                                              CER059
544600200604     C                   IF        P@Rtcd = *BLANKS                                           CER059
544700200604     C                   EVAL      CER034 = 'Y'                                               CER059
544800200604     C                   ELSE                                                                 CER059
544900200604     C                   EVAL      CER034 = 'N'                                               CER059
545000200604     C                   ENDIF                                                                CER059
545100200604                                                                                              CER059
545200200604     C                   IF        P@Rtcd <> '*NRF' AND                                       CER059
545300200604     C                             P@Rtcd <> *BLANKS                                          CER059
545400200604     C     *LOCK         IN        LDA                                                        CER059
545500200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
545600200604     C                   EVAL      DBKEY = 'CER034'                                           CER059
545700200604     C                   EVAL      DBASE = 910                                                CER059
545800200604     C                   OUT       LDA                                                        CER059
545900200604     C                   EXSR      *PSSR                                                      CER059
546000200604     C                   ENDIF                                                                CER059
546100200604                                                                                              CER059
546200200604      ** Call AOSARDR0 to check for CGL032                                                    CER059
546300200604                                                                                              CER059
546400200604     C                   CALLB     'AOSARDR0'                                                 CER059
546500200604     C                   PARM      *BLANKS       P@Rtcd                                       CER059
546600200604     C                   PARM      '*VERIFY'     P@Optn                                       CER059
546700200604     C                   PARM      'CGL032'      P@Sard                                       CER059
546800200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
546900200604                                                                                              CER059
547000200604     C                   IF        P@Rtcd = *BLANKS                                           CER059
547100200604     C                   EVAL      CGL032 = 'Y'                                               CER059
547200200604     C                   ELSE                                                                 CER059
547300200604     C                   EVAL      CGL032 = 'N'                                               CER059
547400200604     C                   ENDIF                                                                CER059
547500200604                                                                                              CER059
547600200604     C                   IF        P@Rtcd <> '*NRF' AND                                       CER059
547700200604     C                             P@Rtcd <> *BLANKS                                          CER059
547800200604     C     *LOCK         IN        LDA                                                        CER059
547900200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
548000200604     C                   EVAL      DBKEY = 'CGL032'                                           CER059
548100200604     C                   EVAL      DBASE = 911                                                CER059
548200200604     C                   OUT       LDA                                                        CER059
548300200604     C                   EXSR      *PSSR                                                      CER059
548400200604     C                   ENDIF                                                                CER059
548500200604     C/COPY WNCPYSRC,SDH00484
548600200604                                                                                              CER059
548700200604      ** Define Keylist                                                                       CSD012
548800200604     C     KAULG         KLIST                                                                CSD012
548900200604     C                   KFLD                    @FUNC            21                          CSD012
549000200604     C**********         KFLD                    @KEY             20                   CSD012 CGL029
549100200604     C                   KFLD                    @KEY                                         CGL029
549200200604      *                                                                                       CSD012
549300200604     C                   MOVEL     FUNCD         @FUNC                                        CSD012
549400200604      *                                                                                       CSW207
549500200604      ** Check if SWIFT 2007 is installed                                                     CSW207
549600200604      *                                                                                       CSW207
549700200604     C                   CALL      'SWIF2007'                                                 CSW207
549800200604     C                   PARM      *BLANKS       P@RtCd                                       CSW207
549900200604                                                                                              CSW207
550000200604     C                   IF        P@RtCd = 'CSW2007'                                         CSW207
550100200604     C                   EVAL      CSW207 = 'Y'                                               CSW207
550200200604     C                   ELSE                                                                 CSW207
550300200604     C                   EVAL      CSW207 = 'N'                                               CSW207
550400200604     C                   ENDIF                                                                CSW207
550500200604                                                                                              CGL157
550600200604      ** Check if enhancement CGL157 is on                                                    CGL157
550700200604                                                                                              CGL157
550800200604     C                   CALLB     'AOSARDR0'                                                 CGL157
550900200604     C                   PARM      *BLANKS       @RTCD                                        CGL157
551000200604     C                   PARM      '*VERIFY'     @OPTN                                        CGL157
551100200604     C                   PARM      'CGL157'      PSARD                                        CGL157
551200200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
551300200604                                                                                              CGL157
551400200604     C                   IF        @RTCD <> *BLANKS AND                                       CGL157
551500200604     C                             @RTCD <> '*NRF   '                                         CGL157
551600200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
551700200604     C                   EVAL      DBKEY  = 'CGL157'                                          CGL157
551800200604     C                   EVAL      DBASE  = 923                                               CGL157
551900200604     C                   EXSR      *PSSR                                                      CGL157
552000200604     C                   ENDIF                                                                CGL157
552100200604                                                                                              CGL157
552200200604     C                   IF        @RTCD = *BLANKS                                            CGL157
552300200604     C                   EVAL      CGL157 = 'Y'                                               CGL157
552400200604     C                   ELSE                                                                 CGL157
552500200604     C                   EVAL      CGL157 = 'N'                                               CGL157
552600200604     C                   ENDIF                                                                CGL157
552700200604     C                   EVAL      CGL157 = 'Y'                                               CGL157
552800200604                                                                                              CGL132
552900200604      ** Check if enhancement CGL132 is on                                                    CGL132
553000200604                                                                                              CGL132
553100200604     C                   CALLB     'AOSARDR0'                                                 CGL132
553200200604     C                   PARM      *BLANKS       @RTCD                                        CGL132
553300200604     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
553400200604     C                   PARM      'CGL132'      PSARD                                        CGL132
553500200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
553600200604                                                                                              CGL132
553700200604     C                   IF        @RTCD <> *BLANKS AND                                       CGL132
553800200604     C                             @RTCD <> '*NRF   '                                         CGL132
553900200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
554000200604     C                   EVAL      DBKEY  = 'CGL132'                                          CGL132
554100200604     C                   EVAL      DBASE  = 920                                               CGL132
554200200604     C                   EXSR      *PSSR                                                      CGL132
554300200604     C                   ENDIF                                                                CGL132
554400200604                                                                                              CGL132
554500200604     C                   IF        @RTCD = *BLANKS                                            CGL132
554600200604     C                   EVAL      CGL132 = 'Y'                                               CGL132
554700200604     C                   ELSE                                                                 CGL132
554800200604     C                   EVAL      CGL132 = 'N'                                               CGL132
554900200604     C                   ENDIF                                                                CGL132
555000200604                                                                                              CGL132
555100200604     C                   IF        CGL132 = 'Y'                                               CGL132
555200200604                                                                                              CGL132
555300200604     C                   CALL      'AOSVALR0'                                                 CGL132
555400200604     C                   PARM      *BLANKS       PRtcd                                        CGL132
555500200604     C                   PARM      SysVal1       SValK1                                       CGL132
555600200604     C                   PARM                    SVal1                                        CGL132
555700200604     C                   PARM      SysVal2       SValK2                                       CGL132
555800200604     C                   PARM                    SVal2                                        CGL132
555900200604     C                   PARM                    SValK3                                       CGL132
556000200604     C                   PARM                    SVal3                                        CGL132
556100200604     C                   PARM                    SValK4                                       CGL132
556200200604     C                   PARM                    SVal4                                        CGL132
556300200604     C                   PARM                    SValK5                                       CGL132
556400200604     C                   PARM                    SVal5                                        CGL132
556500200604     C                   PARM                    SValK6                                       CGL132
556600200604     C                   PARM                    SVal6                                        CGL132
556700200604     C                   PARM                    SValK7                                       CGL132
556800200604     C                   PARM                    SVal7                                        CGL132
556900200604     C                   PARM                    SValK8                                       CGL132
557000200604     C                   PARM                    SVal8                                        CGL132
557100200604     C                   PARM                    SValK9                                       CGL132
557200200604     C                   PARM                    SVal9                                        CGL132
557300200604     C                   PARM                    SValK0                                       CGL132
557400200604     C                   PARM                    SVal10                                       CGL132
557500200604                                                                                              CGL132
557600200604     C                   IF        PRtcd <> *Blanks  AND                                      CGL132
557700200604     C                             PRtcd <> '*NRF   '                                         CGL132
557800200604     C                   EVAL      DBFILE = 'SDSVALPD'                                        CGL132
557900200604     C                   EVAL      DBKEY = SValK1                                             CGL132
558000200604     C                   EVAL      DBASE = 902                                                CGL132
558100200604     C                   EVAL      DBPGM = 'SDCUSDRTV'                                        CGL132
558200200604     C                   EXSR      *PSSR                                                      CGL132
558300200604     C                   ELSE                                                                 CGL132
558400200604     C                   EVAL      WWCLAC = SVal1                                             CGL132
558500200604     C                   EVAL      WCTAX = SVal2                                              CGL132
558600200604     C                   ENDIF                                                                CGL132
558700200604     C                   ENDIF                                                                CGL132
558800200604                                                                                              CGL132
558900200604      ** Check if enhancement CGL133 is on                                                    CGL132
559000200604                                                                                              CGL132
559100200604     C                   CALLB     'AOSARDR0'                                                 CGL132
559200200604     C                   PARM      *BLANKS       @RTCD                                        CGL132
559300200604     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
559400200604     C                   PARM      'CGL133'      PSARD                                        CGL132
559500200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
559600200604                                                                                              CGL132
559700200604     C                   IF        @RTCD <> *BLANKS AND                                       CGL132
559800200604     C                             @RTCD <> '*NRF   '                                         CGL132
559900200604     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
560000200604     C                   EVAL      DBKEY  = 'CGL133'                                          CGL132
560100200604     C                   EVAL      DBASE  = 921                                               CGL132
560200200604     C                   EXSR      *PSSR                                                      CGL132
560300200604     C                   ENDIF                                                                CGL132
560400200604                                                                                              CGL132
560500200604     C                   IF        @RTCD = *BLANKS                                            CGL132
560600200604     C                   EVAL      CGL133 = 'Y'                                               CGL132
560700200604     C                   ELSE                                                                 CGL132
560800200604     C                   EVAL      CGL133 = 'N'                                               CGL132
560900200604     C                   ENDIF                                                                CGL132
561000200604      *                                                                                       CFT050
561100200604      ** Check if SWIFT 2013 is installed                                                     CFT050
561200200604      *                                                                                       CFT050
561300200604     C                   CALL      'SWIF2013'                                                 CFT050
561400200604     C                   PARM      *BLANKS       P@RtCd                                       CFT050
561500200604                                                                                              CFT050
561600200604     C                   IF        P@RtCd = 'CSW2013'                                         CFT050
561700200604     C                   EVAL      CSW213 = 'Y'                                               CFT050
561800200604     C                   ELSE                                                                 CFT050
561900200604     C                   EVAL      CSW213 = 'N'                                               CFT050
562000200604     C                   ENDIF                                                                CFT050
562100200604     C*                  IF        CSW213 = 'Y'                                               CFT050
562200200604     C*                  EVAL      SVDDBDRK2 = *BLANKS                                        CFT050
562300200604     C*                  ENDIF                                                                CFT050
562400200604      *                                                                                       CFT050
562500200604      ** Access SAR Details file to determine if CSW204 is switched on                        CFT050
562600200604      *                                                                                       CFT050
562700200604     C                   CALLB     'AOSARDR0'                                                 CFT050
562800200604     C                   PARM      *BLANKS       @RTCD                                        CFT050
562900200604     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
563000200604     C**********         PARM      'CSW204'      @SARD                               CFT050 MD022463
563100200604     C                   PARM      'CSW024'      @SARD                                      MD022463
563200200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
563300200604                                                                                              CFT050
563400200604      ** Database Error                                                                       CFT050
563500200604                                                                                              CFT050
563600200604     C     @RTCD         IFNE      *BLANKS                                                    CFT050
563700200604     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
563800200604     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
563900200604     C                   MOVEL     '912'         DBASE                                        CFT050
564000200604     C**********         MOVEL     'CSW204'      DBKEY                               CFT050 MD022463
564100200604     C                   MOVEL     'CSW024'      DBKEY                                      MD022463
564200200604     C                   EXSR      *PSSR                                                      CFT050
564300200604     C                   ENDIF                                                                CFT050
564400200604      *                                                                                       CFT050
564500200604     C     @RTCD         IFEQ      *BLANK                                                     CFT050
564600200604     C**********         MOVEL     'Y'           CSW204                              CFT050 MD022463
564700200604     C                   MOVEL     'Y'           CSW024                                     MD022463
564800200604     C                   ELSE                                                                 CFT050
564900200604     C**********         MOVEL     'N'           CSW204                              CFT050 MD022463
565000200604     C                   MOVEL     'N'           CSW024                                     MD022463
565100200604     C                   ENDIF                                                                CFT050
565200200604                                                                                              CFT050
565300200604      *                                                                                     MD022463
565400200604      ** Access SAR Details file to determine if CFT050 is switched on                      MD022463
565500200604      *                                                                                     MD022463
565600200604     C                   CALLB     'AOSARDR0'                                               MD022463
565700200604     C                   PARM      *BLANKS       @RTCD                                      MD022463
565800200604     C                   PARM      '*VERIFY'     @OPTN                                      MD022463
565900200604     C                   PARM      'CFT050'      @SARD                                      MD022463
566000200604     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022463
566100200604                                                                                            MD022463
566200200604      ** Database Error                                                                     MD022463
566300200604                                                                                            MD022463
566400200604     C     @RTCD         IFNE      *BLANKS                                                  MD022463
566500200604     C     @RTCD         ANDNE     '*NRF   '                                                MD022463
566600200604     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD022463
566700200604     C                   MOVEL     '913'         DBASE                                      MD022463
566800200604     C                   MOVEL     'CFT050'      DBKEY                                      MD022463
566900200604     C                   EXSR      *PSSR                                                    MD022463
567000200604     C                   ENDIF                                                              MD022463
567100200604      *                                                                                     MD022463
567200200604     C     @RTCD         IFEQ      *BLANK                                                   MD022463
567300200604     C                   MOVEL     'Y'           CFT050                                     MD022463
567400200604     C                   ELSE                                                               MD022463
567500200604     C                   MOVEL     'N'           CFT050                                     MD022463
567600200604     C                   ENDIF                                                              MD022463
567700200604                                                                                            MD022463
567800200604                                                                                              CER069
567900200604      ** Access SAR Details file to determine if CER069 is switched on                        CER069
568000200604                                                                                              CER069
568100200604     C                   CALLB     'AOSARDR0'                                                 CER069
568200200604     C                   PARM      *BLANKS       @RTCD                                        CER069
568300200604     C                   PARM      '*VERIFY'     @OPTN                                        CER069
568400200604     C                   PARM      'CER069'      @SARD                                        CER069
568500200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
568600200604                                                                                              CER069
568700200604      ** Database Error                                                                       CER069
568800200604                                                                                              CER069
568900200604     C     @RTCD         IFNE      *BLANKS                                                    CER069
569000200604     C     @RTCD         ANDNE     '*NRF   '                                                  CER069
569100200604     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER069
569200200604     C                   MOVEL     '927'         DBASE                                        CER069
569300200604     C                   MOVEL     'CER069'      DBKEY                                        CER069
569400200604     C                   EXSR      *PSSR                                                      CER069
569500200604     C                   ENDIF                                                                CER069
569600200604      *                                                                                       CER069
569700200604     C     @RTCD         IFEQ      *BLANK                                                     CER069
569800200604     C                   MOVEL     'Y'           CER069                                       CER069
569900200604     C                   ELSE                                                                 CER069
570000200604     C                   MOVEL     'N'           CER069                                       CER069
570100200604     C                   ENDIF                                                                CER069
570200200604                                                                                              CER069
570300200604      *                                                                                     MD030956
570400200604      ** Check if feature CTI006 is switched on.                                            MD030956
570500200604      *                                                                                     MD030956
570600200604     C                   CALLB     'AOSARDR0'                                               MD030956
570700200604     C                   PARM      *BLANKS       @RTCD                                      MD030956
570800200604     C                   PARM      '*VERIFY'     @OPTN                                      MD030956
570900200604     C                   PARM      'CTI006'      @SARD                                      MD030956
571000200604     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
571100200604                                                                                            MD030956
571200200604     C                   IF        @RTCD  <> *BLANKS AND                                    MD030956
571300200604     C                             @RTCD  <> '*NRF   '                                      MD030956
571400200604     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD030956
571500200604     C                   EVAL      DBKEY  = 'CTI006'                                        MD030956
571600200604     C                   EVAL      DBASE  = 928                                             MD030956
571700200604     C                   EXSR      *PSSR                                                    MD030956
571800200604     C                   ENDIF                                                              MD030956
571900200604      *                                                                                     MD030956
572000200604     C                   IF        @RTCD  = *BLANKS                                         MD030956
572100200604     C                   EVAL      CTI006 = 'Y'                                             MD030956
572200200604     C                   ELSE                                                               MD030956
572300200604     C                   EVAL      CTI006 = 'N'                                             MD030956
572400200604     C                   ENDIF                                                              MD030956
572500200604      *                                                                                     MD030956
572600200604     C/COPY WNCPYSRC,SDCUSDIC05
572700200604      *
572800200604      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric' &                      CSD027
572900200604      *                       'CustAlphaChecksum'                                             CSD027
573000200604     C                   Eval      PRetCode = *BLANKS                                         CSD027
573100200604     C                   Eval      PSysValK1 = 'CustAlphaAllow'                               CSD027
573200200604     C                   Eval      PSysVal1 = *BLANKS                                         CSD027
573300200604     C                   Eval      PSysValK2 = 'CustAlphaChecksum'                            CSD027
573400200604     C                   Eval      PSysVal2 = *BLANKS                                         CSD027
573500200604     C                   Eval      PSysValK3 = 'CustAlphaSupNumeric'                          CSD027
573600200604     C                   Eval      PSysVal3 = *BLANKS                                         CSD027
573700200604     C**********         CallB(E)  'AOSVALR0'    P_AOSVALR0                          CSD027 BUG11828
573800200604                                                                                            BUG11828
573900200604     C**********         IF        CSD037 = 'Y'                                    BUG11828 BUG13525
574000200604     C**********         CALL (E)  'GPAOSVALR0'  P_AOSVALR0                        BUG11828 BUG13525
574100200604     C**********         ELSE                                                      BUG11828 BUG13525
574200200604     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
574300200604     C**********         ENDIF                                                     BUG11828 BUG13525
574400200604      *                                                                                       CSD027
574500200604      * If Error retrieving the System value                                                  CSD027
574600200604     C                   If        %Error Or PRetCode <> *BLANKS                              CSD027
574700200604     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CSD027
574800200604     C                   Eval      DBFILE = 'SDSVALPD'                                        CSD027
574900200604     C                   Eval      DBASE = 914                                                CSD027
575000200604     C                   Eval      DBKEY = 'CustAlpha(Allow/Chk/SupNum)'                      CSD027
575100200604     C                   ExSr      *PSSR                                                      CSD027
575200200604     C                   EndIf                                                                CSD027
575300200604      *                                                                                       CSD027
575400200604     C                   Eval      WCusAlphaAllow  = PSysVal1                                 CSD027
575500200604     C                   Eval      WCusAlphChksum  = PSysVal2                                 CSD027
575600200604     C                   Eval      WCusAlphaSupNum = PSysVal3                                 CSD027
575700200604      *                                                                                       CSD027
575800200604     C                   ENDSR
575900200604      *****************************************************************
576000200604      /EJECT
576100200604      ********************************************************************
576200200604      *                                                               *                       CSD079
576300200604      * Retrieve Int Cust Branch - Branch Codes                       *                       CSD079
576400200604      *                                                               *                       CSD079
576500200604      *****************************************************************                       CSD079
576600200604     CSR   TWRVGN        BEGSR                                                                CSD079
576700200604     C                   MOVEL     *BLANK        W0RTN                                        CSD079
576800200604     C     DDCUSN        SETLL     @BRCHFM                                                    CSD079
576900200604     C     DDCUSN        READE     @BRCHFM                                90                  CSD079
577000200604     C     *IN90         IFEQ      *ON                                                        CSD079
577100200604                                                                                              CSD079
577200200604      ** Data record not found                                                                CSD079
577300200604                                                                                              CSD079
577400200604     C                   MOVEL     *BLANK        W0RTN                                        CSD079
577500200604     C                   LEAVESR                                                              CSD079
577600200604     C                   ENDIF                                                                CSD079
577700200604      *                                                                                       CSD079
577800200604     C     *IN90         DOWEQ     *OFF                                                       CSD079
577900200604                                                                                              CSD079
578000200604      ** USER: Process Data record                                                            CSD079
578100200604                                                                                              CSD079
578200200604     C                   MOVEL     *BLANK        W0RTN                                        CSD079
578300200604     C                   MOVEL     'BRANCH'      W0RTN                                        CSD079
578400200604     C     DDCUSN        READE     @BRCHFM                                90                  CSD079
578500200604     C                   ENDDO                                                                CSD079
578600200604     C                   ENDSR                                                                CSD079
578700200604      *****************************************************************                       CSD079
578800200604      /EJECT                                                                                  CSD079
578900200604      *****************************************************************                       CSD079
579000200604      *                                                               *                       CER059
579100200604      * ZDATE2 - Format a date for output                             *                       CER059
579200200604      *                                                               *                       CER059
579300200604      *****************************************************************                       CER059
579400200604     C     ZDATE2        BEGSR                                                                CER059
579500200604                                                                                              CER059
579600200604     C                   CALLB     'ZDATE2'                                                   CER059
579700200604     C                   PARM                    ZDAYNO                                       CER059
579800200604     C                   PARM                    BJDFIN                                       CER059
579900200604     C                   PARM                    ZDATE                                        CER059
580000200604     C                   PARM                    ZADATE                                       CER059
580100200604                                                                                              CER059
580200200604     C                   ENDSR                                                                CER059
580300200604      /EJECT                                                                                  CER059
580400200604      *****************************************************************                       CER059
580500200604      ** Program, module and procedure names for database error processing.
580600200604      ** =================================================================
580700200604      ** The following /COPY sets these values, and also defines LDA as
580800200604      ** an external data area
580900200604      ********************************************************************
581000200604     C/COPY ZACPYSRC,PSSR_ILE
581100200604      ********************************************************************
581200200604**  CPY@
581300200604(c) Finastra International Limited 2001
