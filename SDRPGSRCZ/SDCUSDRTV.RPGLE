     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*: OVRDBF FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)          : *
/*XBIB*: OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)          : *
/*XBIC*: OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)          : *
/*XBID*: OVRDBF FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)          : *                      BUG3362
/*XBIE*: OVRDBF FILE(SDCMRKLR) TOFILE(SDCMRKL1) SHARE(*NO)          : *                       CSD079
/*XBIF*: OVRDBF FILE(SDACUSLR) TOFILE(SDACUSL1) SHARE(*NO)          : *                       CSD079
/*XBIG*: OVRDBF FILE(SDCFCDLR) TOFILE(SDCFCDL1) SHARE(*NO)          : *                       CSD079
/*XBIH*: OVRDBF FILE(SDCHEQLR) TOFILE(SDCHEQL1) SHARE(*NO)          : *                       CSD079
/*XBII*: OVRDBF FILE(SDCRWALR) TOFILE(SDCRWAL1) SHARE(*NO)          : *                       CSD079
/*XBIJ*: OVRDBF FILE(SDFOCSLR) TOFILE(SDFOCSL1) SHARE(*NO)          : *                       CSD079
/*XBIK*: OVRDBF FILE(SDPLCSLR) TOFILE(SDPLCSL0) SHARE(*NO)          : *                       CSD079
/*XBIL*: OVRDBF FILE(SDFOX1LR) TOFILE(SDFOX1L0) SHARE(*NO)          : *                       CSD079
/*XBIM*: OVRDBF FILE(SDCUX2LR) TOFILE(SDCUX2L0) SHARE(*NO)          : *                       CSD079
/*XBIN*: OVRDBF FILE(SDCUX1LR) TOFILE(SDCUX1L0) SHARE(*NO)          : *                       CSD079
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust details retrieve + act/cust val')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDRTV - CUSTOMER DETAILS RETRIEVE                        *
      *              (WITH ACTION CODE VERSUS CUSTOMER NO VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves a customer from             *
      *             the database. As it does so, it validates the     *
      *             action code and Customer number.                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 254109             Date 01Jun20               *
      *  Prev Amend No. MD048748           Date 16Dec19               *
      *                 MD052297           Date 14Nov19               *
      *                 MD053634           Date 21Oct19               *
      *                 CER050             Date 16Jun19               *
      *                 MD052425           Date 22Aug19               *
      *                 MD050457           Date 06Mar19               *
      *                 MD050212           Date 02Apr18               *
      *                 MD041527           Date 22Sep16               *
      *                 MD041337           Date 16Sep16               *
      *                 MD039670           Date 26Jul16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042652           Date 06Feb17               *
      *                 CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 03Dec14               *
      *                 CSW214             Date 03Dec14               *
      *                 MD030956           Date 09Oct14               *
      *                 CER069             Date 03Jul14               *
      *                 MD025006           Date 19Aug14               *
      *                 MD022997           Date 24Apr14               *
      *                 MD026780           Date 08May14               *
      *                 MD026253           Date 09May14               *
      *                 CGL132             Date 01May13               *
      *                 AR1086546          Date 18Jun13               *
      *                 MD023955           Date 05Dec13               *
      *                 MD022766           Date 09Oct13               *
      *                 MD023115           Date 03Nov13               *
      *                 MD022861           Date 15Oct13               *
      *                 MD022587           Date 27Sep13               *
      *                 MD022557A          Date 03Oct13               *
      *                 MD022557           Date 02Oct13               *
      *                 MD022463           Date 27Sep13               *
      *                 MD022520           Date 24Sep13               *
      *                 MD022408           Date 16Sep13               *
      *                 MD022395           Date 15Sep13               *
      *                 CFT050             Date 03Jun13               *
      *                 CSW213             Date 03Jun13               *
      *                 AR725233           Date 20May13               *
      *                 MD000091           Date 03May13               *
      *                 MD019261           Date 12Apr13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR855391           Date 27Oct11               *
      *                 CSD090             Date 06Dec10               *
      *                 CSD091             Date 04Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG23513           Date 20Mar09               *
      *                 BUG27866           Date 05Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 258838             Date 20Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 253344 (BUG16825)  Date 13Mar08               *
      *                 253211             Date 05Mar08               *
      *                 BUG15872           Date 12Feb08               *
      *                 BUG15138           Date 25Oct07               *
      *                 CSW207A            Date 23Jul07               *
      *                 CSW207             Date 06Jul07               *
      *                 246639             Date 05Jun07               *
      *                 249593             Date 22Aug07               *
      *                 249322             Date 03Aug07               *
      *                 249029             Date 11Jul07               *
      *                 246639             Date 05Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 241040             Date 07Feb07               *
      *                 BUG13525           Date 05Mar07               *
      *                 CSD079             Date 05Feb07               *
      *                 BG12238            Date 24Oct06               *
      *                 BG12033            Date 19Sep06               *
      *                 CRE026             Date 06Jun06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11935           Date 22Aug06               *
      *                 BUG11932           Daet 23Aug06               *
      *                 BUG11934           Date 21Aug06               *
      *                 BUG11917           Daet 18Aug06               *
      *                 BUG11886           Date 17Aug06               *
      *                 BUG11828           Date 13Aug06               *
      *                 BUG11888           Date 11Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 CRN001             Date 04Nov05               *
      *                 CSD028             Date 22Aug05               *
      *                 BUG8169            Date 06Sep05               *
      *                 BUG7233            Date 20May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD023             Date 18Nov04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3362            Date 28Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2653            Date 15May04               *
      *                 BUG2313            Date 28Apr04               *
      *                 CSD021             Date 10Jul03               *
      *                 CGL029             Date 03Sep01               *
      *                 CGP001             Date 23May03               *
      *                 215524             Date 19Jun03               *
      *                 214144             Date 11Feb03               *
      *                 CGL013             Date 29Mar02               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 198304             Date 18Feb02               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 27Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  254109 - Introduce new err msgs; one for the 'D' action code *
      *           and another one for 'C' and 'R' action codes ( when *
      *           CSD007 feauture is switched on) just to indicate the*
      *           reason why action code is invalid.                  *
      *  MD048748 - Error Authorising Release of a Closed Customer    *
      *             with Parent Defined                               *
      *  MD052297 - Meaningless error message displayed when closing  *
      *             customer.                                         *
      *  MD053634 - Requested Customer Authority Holders Link Report  *
      *             for KWG$24c  not generated.                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD052425 - COB Failure re New Customer Closure feature CSD007*
      *  MD050457 - Customer deletion: Issue detailed error message   *
      *             Patterned fix from 261272.                        *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  MD041527 - Customer cannot be amended after deleting         *
      *             Additional Customer Details                       *
      *  MD041337 - Customer cannot be enquired after deleting        *
      *             Additional Customer Details                       *
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD033588 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042652 - FFC0800 FAILED IN COB                             *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CER069 - German Tax Enhancement                              *
      *  MD025006 - Incorrect error message displayed when amending   *
      *             an already deleted customer                       *
      *  MD022997 - Customer being filtered was not displayed on the  *
      *             main list view of CUSD maintenance                *
      *  MD026780 - Issues on Authority Holders                       *
      *  MD026253 - Added Authority Holder is not displayed after     *
      *              Amendment Authorisation                          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813                             *
      *  MD023955 - Invalid value on Clearing ID is reflected to      *
      *             other transactions with blank Clearing ID         *
      *  MD022766 - Value of fields are cleared when transaction is   *
      *             authorized                                        *
      *  MD023115 - Cannot Complete CUAP for Fedwire, Bankleitzahl,   *
      *             BOJ Financial Institution, Chaps  Sort Code De-   *
      *             faulting                                          *
      *  MD022861 - 1st and 2nd line of MT3xx Receiver Party Infor-   *
      *             mation fields were not defaulted.                 *
      *  MD022587 - Clearing System incorrect defaulting for ISO      *
      *             Country code CA  and CH                           *
      *  MD022557A - Incorrect validation in MT3xx receiver party     *
      *             information and LEI (Reopen)                      *
      *  MD022557 - Incorrect validation in MT3xx receiver party      *
      *             information and LEI                               *
      *  MD022463 - No screen is displayed to show Bank Directory     *
      *             Plus Detail Screen on Linked Customers during     *
      *             Amend and Enquire                                 *
      *  MD022520 - National ID with ISO Country Code DE not defaulted*
      *             to Bankleitzahl.                                  *
      *  MD022408 - Institution status from Bank Directory plus is not*
      *             defaulted not defaulted in Bank field in customer *
      *             details after pressing complete button            *
      *  MD022395 - Value of Clearing System on previously checked    *
      *             customer is copied into another customer when     *
      *             amending it                                       *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  AR725233 - Deleted customer shows blank fields. Prevent      *
      *             error message for deleted customer during enquiry *
      *             so system will still retrieve available details.  *
      *             (Child: AR725234)                                 *
      *  MD000091 - Event Codes Substitution                          *
      *  MD019261 - Incorrect error message displayed upon closing    *
      *             customer attached to facility.                    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *  CSD090 - Customer Segmentation (Recompile)                   *
      *  CSD091 - Overrideable Errors Configurability Enabler Phase 2 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG23513 - Add missing parameter due to changes made to      *
      *             SD0010U. Apply GEMS fix 253823                    *
      *  BUG27866 - Timeout happens during delete                     *
      *  258838 - Create new system values to check the branch/user   *
      *           authority.                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  253344 - Misleading error msg USR9834 when closing customer. *
      *           Amend message to explain cause of the problem.      *
      *           (BUG16825)                                          *
      *  253211 - Add missing parameter to prevent parameter not      *
      *           passed error. Apply fix 248959A.                    *
      *  BUG15872 - Parameter mismatch.                               *
      *  BUG15138 - IBEI is not updated when CSW207 is off            *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  246639 - FOOB in LEC08 pgm LE0710 happens due to access to a *
      *           parent customer which is closed. Pattern fix after  *
      *           230157.                                             *
      *  249593 - Reverse 249322 and add parameters to SDCUSDVU       *
      *           instead of removing them in SDCUSDRTV.              *
      *  249322 - Comment out added *ENTRY parms for CSD031.          *
      *           Applied partial fix of 13525.                       *
      *  249029 - Correct S270006 message.                            *
      *  246639 - FOOB in LEC08 pgm LE0710 happens due to access to a *
      *           parent customer which is closed. Pattern fix after  *
      *           230157.                                             *
      *  241040 - Allow enquiry on deleted cutomers.                  *
      *  BUG13525 - ECSD Mismatch between XML and RPG                 *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  BG12238 - Conditional writes to files within wholesale/      *
      *            universal customer input                           *
      *  BG12033 - Error in Universal Customer Maintenance in         *
      *            Consumer Banking                                   *
      *  CRE026 - Consumer Banking                                    *
      *  BUG11935 - Record in zonal not updated when amendment was    *
      *             globally                                          *
      *  BUG11932 - When Alphanumeric customer number set to 'Y',     *
      *             program should not use Modulus 10 check at all.   *
      *  BUG11934 - Screen did not move when pressing F8              *
      *  BUG11917 - Different error message appear when enquiring/    *
      *             accepting/deleting a record in zonal acceptance   *
      *  BUG11886 - Record inserted in Singapore Global not found     *
      *             in England Zone                                   *
      *  BUG11828 - If CSD031 is on, System Values are defined        *
      *             centrally.                                        *
      *  BUG11888 - Wrong validation error message displayed          *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *            (code fix similar to CSD031)                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  BUG8169 - Option/Action code field should be validated       *
      *            accordingly.                                       *
      *  BUG7233- Error message insufficient for CSD023               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3362 - Added TI details for SD authorisation.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2653 - Check allowed action codes against correct branch  *
      *            instead of the default branch defined in ZMUSER.   *
      *  BUG2313 - Numerous errors concerning global customer id      *
      *  CSD021 - System Generated Customer Number.                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *  215524 - Amendment possible to closed customers. Added       *
      *           validation not to allow amendment when customer     *
      *           closure flag is 'Y'.                                *
      *  214144 - Customer Maintenance. We are unable to Amend or     *
      *           Enquire on customers that fail the Modulus 10 check.*
      *           Fix is to amend this module so that Modulus 10      *
      *           checking would only be done on 'I'nsert.            *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *  CSD012 - Standing Data Authorisation                         *
      *  198304 - Amend so that customer deletion is not allowed if   *
      *           customer is a syndication agent of a branch.        *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CRE007 - Base Rate Tax 2001 - Recompiled.                    *
      *  CSD007 - Customer Closing:                                   *
      *           Allow for action codes 'C' (closure) and 'R'        *
      *           (release).                                          *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCUSTLR  IF   E           K DISK    INFSR(*PSSR)

     FSDCMRKLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Marketing Information   Retrieval index                                              CSD079
                                                                                              CSD079
     FSDACUSLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Additional Customer Details Retrieval index                                          CSD079
                                                                                              CSD079
     FSDCFCDLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Service Fees Retrieval index                                                         CSD079
                                                                                              CSD079
     FSDCHEQLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Cheques and Cards Details Retrieval index                                            CSD079
                                                                                              CSD079
     FSDSAFEL1  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Safe Details Retrieval index                                                         CSD079
                                                                                              CSD079
     FSDCRWALR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Risk Weighted Assets Details Retrieval index                                         CSD079
                                                                                              CSD079
     FSDFOCSLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Midas SD Futures and Options client retrieval                                        CSD079
                                                                                              CSD079
     FSDFOX1LR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Valid Futures & options European Reporting layout                                    CSD079
                                                                                              CSD079
     FSDPLCSLR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Portfolio Management Retrieval index                                                 CSD079
                                                                                              CSD079
     FSDBRCHL5  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** RSQ : Midas SD Branch codes by customer number                                       CSD079
                                                                                              CSD079
     FSDCUX2LR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Lux(European Reporting) file by customer Number                                      CSD079
                                                                                              CSD079
     FSDCUX1LR  IF   E           K DISK    INFSR (*PSSR)                                      CSD079
      ** Lux(IBLC - Extended Information)file by customer Number                              CSD079
                                                                                              CSD079
     FSDCUSDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTD0:SDCUSFOI)

     FSDCBRTLR  IF   E           K DISK    INFSR(*PSSR)

     FSDPBDSLR  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A_)
     FSDTICSLR  IF   E           K DISK    INFSR(*PSSR)                                      BUG3362
     F                                     PREFIX(A_)                                        BUG3362

      ** Global Customers X-Reference Retrieval index                                         CGP001
     FGPCUSTXL1 IF   E           K DISK    INFSR(*PSSR)                                       CGP001
                                                                                              CGP001
      * RTV : Customer Risk Weight Code Retrieval index
     FSDCRWCL1  IF   E           K DISK    INFSR(*PSSR)

      * RTV : Midas SD Message type descriptions retrieval
     FSDMTPYL1  IF   E           K DISK    INFSR(*PSSR)

      * RTV : Message Network Details   Retrieval index
     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
                                                                                              CSD012
      * RTV : Authorisation Log - by Function                                                 CSD012
     FSDAULGL2  IF   E           K DISK    INFSR(*PSSR)                                       CSD012
      *                                                                                       CSD028
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
      ** RTV: Customer Details Shadow File                                                    CSD028
                                                                                              CSD028
     FSDCBSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
     F                                     RENAME(SDCBRTD0:@BRTRF)                            CSD028
      ** RTV: BRT Customer Details Shadow File                                                CSD028
                                                                                              CSD028
     FSDPBSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
     F                                     RENAME(SDPBDSD0:@CPBRF)                            CSD028
      ** RTV: SD API Cust Private Banking Shadow File                                         CSD028
                                                                                              CSD028
     FSDTDSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD028
      ** RTV: TI Customer Details Shadow File                                                 CSD028
                                                                                              CSD028
     FSDCSSWL1  IF   E           K DISK    INFSR(*PSSR)                                       CSW207
      *                                                                                       CSW207
      ** RTV : Midas SD Customer Swift extension file                                         CSW207
      *                                                                                       CSW207
      ** FATCA Customer details file                                                          CGL132
     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
                                                                                              CGL132
      ** FATCA Customer details file by Front office ID                                       CGL132
     FSDFTCSL2  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
     F                                     PREFIX(A_)                                         CGL132
     F                                     RENAME(SDFTCSD0:SDFTCSD1)                          CGL132
                                                                                              CGL132
      *                                                                                       CGL132
      ** RTV : Midas SD Customer Extension - C                                                CGL132
      *                                                                                       CGL132
     FSDCUSXL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
     F                                     RENAME(SDCUSTX0:SDCUSTX1)                          CGL132
                                                                                              CGL132
      ** Midas SD CRS Customer Details Retrieval                                              CGL157
     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
                                                                                              CGL157
      * Midas SD CRS Details File                                                             CGL157
     FSDCRSDL0  IF   E           K DISK    INFSR(*PSSR)                                       CGL157
                                                                                              CSD031
      ** Customer Details Acceptance - Retrieve Index                                         CSD031
     F***SDACSTL1  IF   E           K DISK    INFSR(*PSSR)                           CSD031 BUG13525
     F**********                           RENAME(SDCUSTD0:SDACSTD1)                 CSD031 BUG13525
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23518
      *                                                                                     BUG23518
      ** RTV : Midas SD Customer by Country of Tax File                                     BUG23518
      *                                                                                     BUG23518
     FSDACTXL4  IF   E           K DISK    INFSR(*PSSR)                                       CER059
     F                                     RENAME(SDACTXD0:SDACTXD4)                          CER059
      ** RTV : Midas SD Customer by Country of Tax File                                       CER059
                                                                                              CER059
     FSDCUAHLA  IF   E           K DISK    INFSR(*PSSR)                                       CER059
      ** RTV : Midas SD Customer Authority Holder File                                        CER059
                                                                                              CSD031
     F/COPY WNCPYSRC,SDCUSDIF01
                                                                                              CSD027
      * Customer Details Sorted By Shortname                                                  CSD027
     FSDCUSTLH  IF   E           K DISK    INFSR(*PSSR)                                       CSD027
     FMEBIB3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
      *                                                                                       CFT050
      ** RTV : SWIFTRef BANK DIRECTORY Plus                                                   CFT050
      *                                                                                       CFT050
     FMEIBN3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
      *                                                                                       CFT050
      ** RTV : SWIFTRef IBAN Plus                                                             CFT050
      *                                                                                       CFT050
      ** Country codes                                                                        CFT050
     FSDCTRYL3  IF   E           K DISK    INFSR(*PSSR)                                       CFT050

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
                                                                                              CGL132
     D SysVal1         C                   'FATCADftCLsNewCustNH'                             CGL132
     D SysVal2         C                   'FATCACountryofTax'                                CGL132

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS ICD retrieval
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CGL132

     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  CSD079
      ** Data Structure for Portfolio Management Details                                      CSD079

      ** External DS for Customer Details                                                   BUG23518
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23518
     D                                     PREFIX(A)                                        BUG23518
      ** Customer in File Format
     D CustFilFmt    E DS                  EXTNAME(SDCUSTPD)
      ** Customer Ext in File Format                                                          CGL132
     D CuXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                  CGL132
      ** SWIFT Details in File Format                                                         CSW207
     D SwftFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
      ** Customer Base Rate Tax in File Format
     D CubrFilFmt    E DS                  EXTNAME(SDCBRTPD)
      ** Customer Private Banking in File Format
     D CuPbFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(A_)
      ** TI Customer Details in File Format                                                  BUG3362
     D CuTIFilFmt    E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(A_)                                        BUG3362
      ** Global Customer X-Reference in File Format                                           CGP001
     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
      ** FATCA Customer Details in file format                                                CGL132
     D CuFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                  CGL132
                                                                                              CGL132
      ** Midas FATCA Classification Code                                                      CGL132
     D SDFATC        E DS                  EXTNAME(SDFATCPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132
                                                                                              CSD079
      ** Marketing Information Details in File Format                                         CSD079
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
                                                                                              CSD079
      ** Additional Customer details in File Format                                           CSD079
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
                                                                                              CSD079
      ** Service Fees Details in File Format                                                  CSD079
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079
     D Q_QQSMAC      E                     EXTFLD(QQSMAC)                                     CSD079
                                                                                              CSD079
      ** Cheques and Cards Details in File Format                                             CSD079
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
                                                                                              CSD079
      ** Safe details in File Format                                                          CSD079
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
                                                                                              CSD079
      ** Risk weighted assets in Valid File Format                                            CSD079
     D RwanFilFmt    E DS                  EXTNAME(SDVRWANPD)                                 CSD079
                                                                                              CSD079
      ** Future and option Detail in File Format                                              CSD079
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
                                                                                              CSD079
      ** Future & options European reporting in File Format                                   CSD079
     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CSD079
                                                                                              CSD079
      ** Fiduciary Details in File Format                                                     CSD079
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
                                                                                              CSD079
     ** Lux(European Reporting) in file format                                                CSD079
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CSD079
                                                                                              CSD079
     ** Lux(IBLC - Extended Information) in file format                                       CSD079
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CSD079
                                                                                              CSD079
      ** Customer Acceptance Details Data Structure                                           CSD031
     D*SDACST***     E DS                  EXTNAME(SDACSTPD)                         CSD031 BUG13525
     D**********                           PREFIX(B_)                                CSD031 BUG13525
      ** Currency/Time of Netting Details File Format                                      AR1086546
     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)                              AR1086546
                                                                                           AR1086546
      ** Customer dtls Bank directory plus detail                                             CFT050
     D CuSW13        E DS                  EXTNAME(SDSW13PD)                                  CFT050
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
     ** Business Entity Identifier                                                            CFT050
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CFT050
     D TranInMT3X    E DS                  EXTNAME(SDCUMTPD)                                  CFT050
     D TranInPrim    E DS                  EXTNAME(SDCUPRPD)                                  CFT050
     D                                     PREFIX(D)                                          CFT050
     D TranInSeco    E DS                  EXTNAME(SDCUSEPD)                                  CFT050

     D RUNDAT          DS
     D  @MBIN                 13     13
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
                                                                                              CSD079
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSD079
     D BGN4STC       E                     EXTFLD(BGN4ST)                                     CSD079
      ** External DS for MIDAS modules details                                                CSD079
                                                                                              CSD021
      ** Data Structure for SAR Details                                                       CSD021
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD021
                                                                                              CSD012
      ** External DS for CRS Details                                                          CGL157
     D SDVCRSD       E DS                  EXTNAME(SDVCRSDPD)                                 CGL157
                                                                                              CGL157
      ** External DS for Country of Tax Codes                                                 CGL157
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  CGL157
                                                                                              CGL157
     D***@KEY***         DS            20                                              CSD012 CGL029
     D @KEY            DS            26                                                       CGL029
     D @DDCUSN                 1      6                                                       CSD012
     D FUNCD           C                   CONST('CUSTOMER DETAILS')                          CSD012
                                                                                              CER059
     D CUAHArrDS       DS                                                                     CER059
     D***CUAHArr                      22A   DIM(50)                                  CER059 MD026780
     D  CUAHArr                      26A   DIM(50)                                          MD026780
                                                                                              CER059
     D CCTXArrDS       DS                                                                     CER059
     D  CCTXArr                      51A   DIM(50)                                            CER059
                                                                                              CER059
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX(TX)                                         CER059
     D*TranInCUAH1     DS            22                                              CER059 MD026780
     D TranInCUAH1     DS            26                                                     MD026780
     D  AHAUTH                 1     10                                                       CER059
     D  AHLTYP                11     12                                                       CER059
     D  AHPRG1                13     14                                                       CER059
     D  AHPRG2                15     16                                                       CER059
     D  AHPRG3                17     18                                                       CER059
     D  AHPRG4                19     20                                                       CER059
     D  AHTYPA                21     22                                                       CER059
     D  AHCINT                23     23                                                     MD026780
     D  AHPCNT                24     26                                                     MD026780
     D TranInCCTX1   E DS                  EXTNAME (SDCCTXPD)                                 CER059
     D                                     PREFIX(TX:2)                                       CER059
                                                                                              CGL157
      ** Transaction Details in File Format                                                   CGL157
     D CrsdFilFmt    E DS                  EXTNAME(SDCRSHPD)                                  CGL157
     D PCrsdF          S            219A   DIM(30)                                            CGL177
                                                                                              CGL157

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CGL132
      ** Parameter variables for AOSVALR0 string                                              CGL132
     D SValK1          S             20                                                       CGL132
     D SVal1           S            200                                                       CGL132
     D SValK2          S             20                                                       CGL132
     D SVal2           S            200                                                       CGL132
     D SValK3          S             20                                                       CGL132
     D SVal3           S            200                                                       CGL132
     D SValK4          S             20                                                       CGL132
     D SVal4           S            200                                                       CGL132
     D SValK5          S             20                                                       CGL132
     D SVal5           S            200                                                       CGL132
     D SValK6          S             20                                                       CGL132
     D SVal6           S            200                                                       CGL132
     D SValK7          S             20                                                       CGL132
     D SVal7           S            200                                                       CGL132
     D SValK8          S             20                                                       CGL132
     D SVal8           S            200                                                       CGL132
     D SValK9          S             20                                                       CGL132
     D SVal9           S            200                                                       CGL132
     D SValK0          S             20                                                       CGL132
     D SVal10          S            200                                                       CGL132

      ** For QUSRJOBI                                                                       BUG27866
     D WWRTRN          DS           187                                                     BUG27866
     D  WWJOB                  9     18                                                     BUG27866
     D  WJOBTP                61     61                                                     BUG27866
                                                                                            BUG27866
      ** For date conversion                                                                  CSD079
     D ##DOB           DS                                                                     CSD079
     D ##DAT1                  1      4                                                       CSD079
     D ##CC                    5      6                                                       CSD079
     D ##YY                    7      8                                                       CSD079
                                                                                              CSD079
     D CSD079          S              1A    inz('N')                                          CSD079
     D S01425          S              1A    inz('N')                                          CSD079
     D CSD008          S              1A    inz('N')                                          CSD079
     D CDL002          S              1A    inz('N')                                          CSD079
     D CDL006          S              1A    inz('N')                                          CSD079
     D CGL018          S              1A    inz('N')                                          CSD079
     D ULX004          S              1A    inz('N')                                          CSD079
     D ULX609          S              1A    inz('N')                                          CSD079
     D ULX043          S              1A    inz('N')                                          CSD079
     D CGL157          S              1A    INZ('N')                                          CGL157
                                                                                              CSD079
     D PMODE           S              1                                                       CSD079
     D CDL018          S              1                                                       CSD079
                                                                                              CSD079
     D CDL025          S              1A    inz('N')                                       AR1086546
                                                                                           AR1086546
     D X               S              2S 0                                                    CGL157
     D WCNCD           S              2A                                                      CGL157
     D WCOLC           S              2A                                                      CGL157
     D @PCTRT          S              2A                                                      CGL157
     D @PCTRR          S              2A                                                      CGL157
     D @WCDS1          DS           200
     D   WDS1000               1    200
     D   WDS1001               1      1
     D   WDS1002               2      2
     D   WDS1003               3      3
     D   WDS1004               4      4
     D   WDS1005               5      5
     D   WDS1006               6      6
     D   WDS1007               7      7
     D   WDS1008               8      8
     D   WDS1009               9      9
     D   WDS1010              10     10
     D   WDS1011              11     11
     D   WDS1012              12     12
     D   WDS1013              13     13
     D   WDS1014              14     14
     D   WDS1015              15     15
     D   WDS1016              16     16
     D   WDS1017              17     17
     D   WDS1018              18     18
     D   WDS1019              19     19
     D   WDS1020              20     20
     D   WDS1021              21     21
     D   WDS1022              22     22
     D   WDS1023              23     23
     D   WDS1024              24     24
     D   WDS1025              25     25
     D   WDS1026              26     26
     D   WDS1027              27     27
     D   WDS1028              28     28
     D   WDS1029              29     29
     D   WDS1030              30     30
     D   WDS1031              31     31
     D   WDS1032              32     32
     D   WDS1033              33     33
     D   WDS1034              34     34
     D   WDS1035              35     35
     D   WDS1036              36     36
     D   WDS1037              37     37
     D   WDS1038              38     38
     D   WDS1039              39     39
     D   WDS1040              40     40
     D   WDS1041              41     41
     D   WDS1042              42     42
     D   WDS1043              43     43
     D   WDS1044              44     44
     D   WDS1045              45     45
     D   WDS1046              46     46
     D   WDS1047              47     47
     D   WDS1048              48     48
     D   WDS1049              49     49
     D   WDS1050              50     50

     D @WCDS2          DS           200
     D   WDS2000               1    200
     D   WDS2001               1      1
     D   WDS2002               2      2
     D   WDS2003               3      3
     D   WDS2004               4      4
     D   WDS2005               5      5
     D   WDS2006               6      6
     D   WDS2007               7      7
     D   WDS2008               8      8
     D   WDS2009               9      9
     D   WDS2010              10     10
     D   WDS2011              11     11
     D   WDS2012              12     12
     D   WDS2013              13     13
     D   WDS2014              14     14
     D   WDS2015              15     15
     D   WDS2016              16     16
     D   WDS2017              17     17
     D   WDS2018              18     18
     D   WDS2019              19     19
     D   WDS2020              20     20
     D   WDS2021              21     21
     D   WDS2022              22     22
     D   WDS2023              23     23
     D   WDS2024              24     24
     D   WDS2025              25     25
     D   WDS2026              26     26
     D   WDS2027              27     27
     D   WDS2028              28     28
     D   WDS2029              29     29
     D   WDS2030              30     30
     D   WDS2031              31     31
     D   WDS2032              32     32
     D   WDS2033              33     33
     D   WDS2034              34     34
     D   WDS2035              35     35
     D   WDS2036              36     36
     D   WDS2037              37     37
     D   WDS2038              38     38
     D   WDS2039              39     39
     D   WDS2040              40     40
     D   WDS2041              41     41
     D   WDS2042              42     42
     D   WDS2043              43     43
     D   WDS2044              44     44
     D   WDS2045              45     45
     D   WDS2046              46     46
     D   WDS2047              47     47
     D   WDS2048              48     48
     D   WDS2049              49     49
     D   WDS2050              50     50

     D @WCDS3          DS           200
     D   WDS3000               1    200
     D   WDS3001               1      1
     D   WDS3002               2      2
     D   WDS3003               3      3
     D   WDS3004               4      4
     D   WDS3005               5      5
     D   WDS3006               6      6
     D   WDS3007               7      7
     D   WDS3008               8      8
     D   WDS3009               9      9
     D   WDS3010              10     10
     D   WDS3011              11     11
     D   WDS3012              12     12
     D   WDS3013              13     13
     D   WDS3014              14     14
     D   WDS3015              15     15
     D   WDS3016              16     16
     D   WDS3017              17     17
     D   WDS3018              18     18
     D   WDS3019              19     19
     D   WDS3020              20     20
     D   WDS3021              21     21
     D   WDS3022              22     22
     D   WDS3023              23     23
     D   WDS3024              24     24
     D   WDS3025              25     25
     D   WDS3026              26     26
     D   WDS3027              27     27
     D   WDS3028              28     28
     D   WDS3029              29     29
     D   WDS3030              30     30
     D   WDS3031              31     31
     D   WDS3032              32     32
     D   WDS3033              33     33
     D   WDS3034              34     34
     D   WDS3035              35     35
     D   WDS3036              36     36
     D   WDS3037              37     37
     D   WDS3038              38     38
     D   WDS3039              39     39
     D   WDS3040              40     40
     D   WDS3041              41     41
     D   WDS3042              42     42
     D   WDS3043              43     43
     D   WDS3044              44     44
     D   WDS3045              45     45
     D   WDS3046              46     46
     D   WDS3047              47     47
     D   WDS3048              48     48
     D   WDS3049              49     49
     D   WDS3050              50     50

     D @WCDS4          DS           200
     D   WDS4000               1    200
     D   WDS4001               1      1
     D   WDS4002               2      2
     D   WDS4003               3      3
     D   WDS4004               4      4
     D   WDS4005               5      5
     D   WDS4006               6      6
     D   WDS4007               7      7
     D   WDS4008               8      8
     D   WDS4009               9      9
     D   WDS4010              10     10
     D   WDS4011              11     11
     D   WDS4012              12     12
     D   WDS4013              13     13
     D   WDS4014              14     14
     D   WDS4015              15     15
     D   WDS4016              16     16
     D   WDS4017              17     17
     D   WDS4018              18     18
     D   WDS4019              19     19
     D   WDS4020              20     20
     D   WDS4021              21     21
     D   WDS4022              22     22
     D   WDS4023              23     23
     D   WDS4024              24     24
     D   WDS4025              25     25
     D   WDS4026              26     26
     D   WDS4027              27     27
     D   WDS4028              28     28
     D   WDS4029              29     29
     D   WDS4030              30     30
     D   WDS4031              31     31
     D   WDS4032              32     32
     D   WDS4033              33     33
     D   WDS4034              34     34
     D   WDS4035              35     35
     D   WDS4036              36     36
     D   WDS4037              37     37
     D   WDS4038              38     38
     D   WDS4039              39     39
     D   WDS4040              40     40
     D   WDS4041              41     41
     D   WDS4042              42     42
     D   WDS4043              43     43
     D   WDS4044              44     44
     D   WDS4045              45     45
     D   WDS4046              46     46
     D   WDS4047              47     47
     D   WDS4048              48     48
     D   WDS4049              49     49
     D   WDS4050              50     50

     D @WCDS5          DS           200
     D   WDS5000               1    200
     D   WDS5001               1      1
     D   WDS5002               2      2
     D   WDS5003               3      3
     D   WDS5004               4      4
     D   WDS5005               5      5
     D   WDS5006               6      6
     D   WDS5007               7      7
     D   WDS5008               8      8
     D   WDS5009               9      9
     D   WDS5010              10     10
     D   WDS5011              11     11
     D   WDS5012              12     12
     D   WDS5013              13     13
     D   WDS5014              14     14
     D   WDS5015              15     15
     D   WDS5016              16     16
     D   WDS5017              17     17
     D   WDS5018              18     18
     D   WDS5019              19     19
     D   WDS5020              20     20
     D   WDS5021              21     21
     D   WDS5022              22     22
     D   WDS5023              23     23
     D   WDS5024              24     24
     D   WDS5025              25     25
     D   WDS5026              26     26
     D   WDS5027              27     27
     D   WDS5028              28     28
     D   WDS5029              29     29
     D   WDS5030              30     30
     D   WDS5031              31     31
     D   WDS5032              32     32
     D   WDS5033              33     33
     D   WDS5034              34     34
     D   WDS5035              35     35
     D   WDS5036              36     36
     D   WDS5037              37     37
     D   WDS5038              38     38
     D   WDS5039              39     39
     D   WDS5040              40     40
     D   WDS5041              41     41
     D   WDS5042              42     42
     D   WDS5043              43     43
     D   WDS5044              44     44
     D   WDS5045              45     45
     D   WDS5046              46     46
     D   WDS5047              47     47
     D   WDS5048              48     48
     D   WDS5049              49     49
     D   WDS5050              50     50

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
     D Idy             S              3P 0                                                    CER059
                                                                                              CSD028
     D CSD028          S              1                                                       CSD028
     D P@Rtcd          S              7                                                       CSD028
     D P@Optn          S              7                                                       CSD028
     D P@Sard          S              6                                                       CSD028
                                                                                              CSD028
      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1A                                                      CSW207
     D KFCusn          S              6A                                                    BUG23518
     D KFCTax          S              2A                                                    BUG23518
     D PCusn           S             10A                                                    BUG23518
     D PKySt           S              7A                                                    BUG23518
     D CER048          S              1A                                                    BUG23518
     D CER034          S              1A                                                      CER059
     D CER069          S              1A                                                      CER069
     D CGL032          S              1A                                                      CER059
     D WIx             S              3P 0                                                  BUG23518
      *                                                                                     BUG23518
     D/COPY WNCPYSRC,SDCUSDID01
                                                                                              CSD031
     D*PAccMde**       S              1A                                             CSD031 BUG13525
     D*PUpdYN***       S              1A                                             CSD031 BUG13525
     D PRtCd           S              7A                                                      CSD031
     D POptn           S              7A                                                      CSD031
     D PSARD           S              6A                                                      CSD031
     D*CSD037***       S              1A   INZ('N')                                  CSD031 BUG13525
     D*WCustLR**       S              1A                                             CSD031 BUG13525
     D*WTyLC****       S              1A                                             CSD031 BUG13525

      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                   CSD027
     D PRetCode        S              7A                                                      CSD027
     D PSysValK1       S             20A                                                      CSD027
     D PSysVal1        S            200A                                                      CSD027
     D PSysValK2       S             20A                                                      CSD027
     D PSysVal2        S            200A                                                      CSD027
     D PSysValK3       S             20A                                                      CSD027
     D PSysVal3        S            200A                                                      CSD027
     D PSysValK4       S             20A                                                      CSD027
     D PSysVal4        S            200A                                                      CSD027
     D PSysValK5       S             20A                                                      CSD027
     D PSysVal5        S            200A                                                      CSD027
     D PSysValK6       S             20A                                                      CSD027
     D PSysVal6        S            200A                                                      CSD027
     D PSysValK7       S             20A                                                      CSD027
     D PSysVal7        S            200A                                                      CSD027
     D PSysValK8       S             20A                                                      CSD027
     D PSysVal8        S            200A                                                      CSD027
     D PSysValK9       S             20A                                                      CSD027
     D PSysVal9        S            200A                                                      CSD027
     D PSysValK10      S             20A                                                      CSD027
     D PSysVal10       S            200A                                                      CSD027
      *                                                                                       CSD027
      * For holding the system values                                                         CSD027
     DWCusAlphaAllow   S            200A                                                      CSD027
     DWCusAlphChksum   S            200A                                                      CSD027
     DWCusAlphaSupNum  S            200A                                                      CSD027
      *                                                                                       CSD027
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                          CSD027
     D PCust           S              6A                                                      CSD027
     D PValid          S              6A                                                      CSD027
     D PCheckDigit     S              1A                                                      CSD027
     D W_SkipFlag      S              1A                                                    BUG11886

      ** Work Variables for CSD079                                                            CSD079
     D ModeofOp        S              6A                                                      CSD079
     D RespMode        S              1A                                                      CSD079
     D From_Cust       S              1A                                                      CSD079
     D WUPMSC          S              1A                                                      CSD079
     D W0RTN           S              7A                                                      CSD079
                                                                                              CSD079
     D WWLENG          S              4B 0                                                  BUG27866
     D WWINPT          S              8A                                                    BUG27866
     D WWQUAL          S             26A                                                    BUG27866
     D WWINTR          S             16A                                                    BUG27866
                                                                                            BUG27866
      ** Constant paramater for AOSVALR0                                                      258838
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      258838
     D CurSysVal       DS           200                                                       258838
     D CurVal                  1      1                                                       258838
                                                                                              CER059
     D ZDAYNO          S              5  0                                                    CER059
     D ZDATE           S              6  0                                                    CER059
     D ZADATE          S              7A                                                      CER059
                                                                                              CER059
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D CSW213          S              1A                                                      CSW213
     D***CSW204*         S              1                                            CFT050 MD022463
     D CSW024          S              1                                                     MD022463
     D SvDDLEIC        S                   LIKE(DDLEIC)                                       CFT050
     D SvDDCLSY        S                   LIKE(DDCLSY)                                       CFT050
     D SvDDCLID        S                   LIKE(DDCLID)                                       CFT050
     D SvDDBDRK        S                   LIKE(DDBDRK)                                       CFT050
     D SvDDBDRK2       S                   LIKE(DDBDRK)                                       CFT050
     D SVCNCZ          S              2A                                                      CFT050
     D SVCOLC          S              2A                                                      CFT050
     D SVCLSY          S              2A                                                      CFT050
     D PBICD           S              4A                                                      CFT050
     D CFT050          S              1A                                                    MD022463
     D CGL132          S              1A                                                      CGL132
     D CGL133          S              1A                                                      CGL132
     D DDDATE          S              5P 0                                                    CGL132
     D DDSEQN          S              3S 0                                                    CGL132
     D @CLAC           S              5A                                                      CGL132
     D PCustNo         S              6A                                                      CGL132
     D DDCRTT          S              2A                                                      CGL132
     D WWTINO          S             25A                                                      CGL132
     D WCTAX           S              2A                                                      CGL132
     D WWCLAC          S              5A                                                      CGL132
     D CTI006          S              1A                                                    MD030956
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
      ** Retrive ZMUSER if not job update                                                   BUG11935
     C**********         If        PAccMde <> 'J' and CSD037 = 'Y'                 BUG11935 BUG13525
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C**********         EndIf                                                     BUG11935 BUG13525
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCUST        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE & CUSTOMER NUMBER
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCUST        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EVAL      ZACTN=DDACTN
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        ANDNE     'I'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSEM
     C                   END
     C                   END
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   RETURN
     C                   END
                                                                                              CSD031
      ** Get customer acceptance details if required.                                         CSD031
                                                                                              CSD031
     C**********         IF        PAccMde = 'A'                                     CSD031 BUG13525
     C**********         EXSR      SRGetACst                                         CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the Customer number is not to be generated.)
      *
     C     DDACTN        IFEQ      'I'
     C     DDCUSN        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      RTVCUS
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      RTVCUS
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      RTVCUS
     C                   EXSR      VALACD
     C                   END
      *                                                                                       CSD007
      *  *--------------------------------*                                                   CSD007
      *  * Validation for Action Code 'C' *                                                   CSD007
      *  *--------------------------------*                                                   CSD007
      *                                                                                       CSD007
     C     DDACTN        IFEQ      'C'                                                        CSD007
     C                   EXSR      RTVCUS                                                     CSD007
     C                   EXSR      VALACC                                                     CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD007
      *  *--------------------------------*                                                   CSD007
      *  * Validation for Action Code 'R' *                                                   CSD007
      *  *--------------------------------*                                                   CSD007
      *                                                                                       CSD007
     C     DDACTN        IFEQ      'R'                                                        CSD007
     C                   EXSR      RTVCUS                                                     CSD007
     C                   EXSR      VALACR                                                     CSD007
     C                   ENDIF                                                                CSD007
      *
      **  Carry out no further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCUST        OREQ      'N'
     C                   RETURN
     C                   END

     C     S01383        IFEQ      'Y'
      *
      * SET UP SDCBRTPD DETAILS IF BASE RATE TAX IS ON
      *
     C                   EXSR      RTVBRT

     C                   ENDIF
      *
     C     BGN4ST        IFEQ      'Y'
      *
      * SET UP SDPBDSPD DETAILS IF PRIVATE BANKING IS ON
      *
     C                   EXSR      RTVPRV

     C                   ENDIF
      *                                                                                      BUG3362
      ** Retrieve Details for TI if CSD012 is ON                                             BUG3362
      *                                                                                      BUG3362
     C     BBTICS        IFEQ      'Y'                                                       BUG3362
     C     BGN3ST        ANDEQ     'Y'                                                       BG12033
     C     BBTICS        OREQ      'Y'                                                      MD030956
     C     CTI006        ANDEQ     'Y'                                                      MD030956
      *                                                                                      BUG3362
     C                   EXSR      RTVTID                                                    BUG3362
     C                   ENDIF                                                               BUG3362
                                                                                              CGP001
     C     CGP001        IFEQ      'Y'                                                        CGP001
                                                                                              CGP001
      ** Set up GPCUSTXPD details if Global Data Layout is on                                 CGP001
                                                                                              CGP001
     C                   EXSR      RTVGLB                                                     CGP001
                                                                                              CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   IF         CSD079 = 'Y'                                              CSD079
                                                                                              CSD079
      ** Retrieve Marketing Information                                                       CSD079
                                                                                              CSD079
     C                   EXSR      RtvCumi                                                    CSD079
                                                                                              CSD079
      ** Retrieve Additional Customer Details                                                 CSD079
                                                                                              CSD079
     C     S01425        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvCuad                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Service Fees                                                                CSD079
                                                                                              CSD079
     C     CSD008        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvSfee                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Cheques and Card Details                                                    CSD079
                                                                                              CSD079
     C     BGNXST        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvChec                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Safe Details                                                                CSD079
                                                                                              CSD079
     C                   EXSR      RtvCusf                                                    CSD079
                                                                                              CSD079
      ** Retrieve Risk weighted assets                                                        CSD079
                                                                                              CSD079
     C     CGL018        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvRwan                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CER059
      ** Retrieve Customer Authority Holder                                                   CER059
                                                                                              CER059
     C**********         IF        CER034 = 'Y'                                      CER059 MD026253
     C**********                   AND DDACTN <> 'I'                                 CER059 MD026253
     C                   IF        DDACTN <> 'I'                                            MD026253
     C                             AND DDACTN <> 'A'                                          CER059
     C                   EXSR      RtvCUAH                                                    CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Retrieve Customer by Country of Tax                                                  CER059
                                                                                              CER059
     C                   IF        CGL032 = 'Y'                                               CER059
     C                             AND DDACTN <> 'I'                                          CER059
     C                             AND DDACTN <> 'A'                                          CER059
     C                   EXSR      RtvCCTX                                                    CER059
     C                   ENDIF                                                                CER059
                                                                                              CSD079
      ** Retrieve Futures and Option                                                          CSD079
                                                                                              CSD079
     C     BGFUOP        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvCufo                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Future and Option European Reporting                                        CSD079
                                                                                              CSD079
     C     ULX004        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvCufn                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Portfolio Management                                                        CSD079
                                                                                              CSD079
     C     WUPMSC        IFEQ      'Y'                                                        CSD079
     C                   EXSR      RtvCupm                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Lux(European Reporting)                                                     CSD079
                                                                                              CSD079
     C     ULX609        IFEQ      'Y'                                                        CSD079
     C     BGLRIN        ANDEQ     'Y'                                                        CSD079
     C                   EXSR      RtvCulx2                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Retrieve Lux(IBLC - Extended Information)                                            CSD079
                                                                                              CSD079
     C     ULX043        IFEQ      'Y'                                                        CSD079
     C     BGNWST        ANDEQ     'Y'                                                        CSD079
     C                   EXSR      RtvCulx1                                                   CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   EXSR      RTVFTC                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EXSR      RTVCRS                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                           AR1086546
      ** Retrieve Currency/Time of Netting Details                                         AR1086546
                                                                                           AR1086546
     C     CDL025        IFEQ      'Y'                                                     AR1086546
     C                   EXSR      RTVCTNM                                                 AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
     C**********         IF        PAccMde = 'A'                                     CSD031 BUG13525
     C**********         EXSR      SROvrFlds                                         CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
     C/COPY WNCPYSRC,SDCUSDIC07
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='C'                                                 CSD007
     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                                 CSD007
     C                   WHEN      DDACTN='R'                                                 CSD007
     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                                 CSD007
     C**********         WHEN      DDACTN='X'                                        CSD031 BUG13525
     C**********         MOVEL     'CSF9008'     MsgIdArr(Ix)                        CSD031 BUG13525
     C/COPY WNCPYSRC,SDH00481
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
     C                   Eval      W_SkipFlag = 'N'                                         BUG11886
      *                                                                                      BUG2653
      ** Access customer's file to check on the branch code of the customer.                 BUG2653
      ** Use this to check the valid user branch/combination instead of default              BUG2653
      ** branch DBRN.                                                                        BUG2653
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C     DDCUSN        CHAIN     SDCDSHL1                           44                      CSD028
     C                   ELSE                                                                 CSD028
     C     DDCUSN        CHAIN     SDCUSTLR                           44                     BUG2653
     C                   ENDIF                                                                CSD028
     C                   MOVE      BBBRCD        ZBR                                         BUG2653
                                                                                              CSD031
     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
     C**********                   AND PaccMde = 'A'                                 CSD031 BUG13525
     C*****DDCUSN        CHAIN     SDACSTL1                           44             CSD031 BUG13525
     C**********         EVAL      ZBR = BBBRCD                                      CSD031 BUG13525
      *                                                                                     BUG11886
      ** Skip Security Checking if Branch code is blanks                                    BUG11886
      *                                                                                     BUG11886
     C                   If        ZBR =  *Blanks                                           BUG11886
     C                   Eval      W_SkipFlag = 'Y'                                         BUG11886
     C                   EndIf                                                              BUG11886
     C**********         ENDIF                                                       CSD031 BUG13525
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALLB     'AOSVALR0'                                                 258838
     C                   PARM                    @RTCD             7                          258838
     C                   PARM      BRCUSR        @OP01            20                          258838
     C     CurSysVal     PARM                    @VL01           200                          258838
     C                   PARM                    @OP02            20                          258838
     C                   PARM                    @VL02           200                          258838
     C                   PARM                    @OP03            20                          258838
     C                   PARM                    @VL03           200                          258838
     C                   PARM                    @OP04            20                          258838
     C                   PARM                    @VL04           200                          258838
     C                   PARM                    @OP05            20                          258838
     C                   PARM                    @VL05           200                          258838
     C                   PARM                    @OP06            20                          258838
     C                   PARM                    @VL06           200                          258838
     C                   PARM                    @OP07            20                          258838
     C                   PARM                    @VL07           200                          258838
     C                   PARM                    @OP08            20                          258838
     C                   PARM                    @VL08           200                          258838
     C                   PARM                    @OP09            20                          258838
     C                   PARM                    @VL09           200                          258838
     C                   PARM                    @OP10            20                          258838
     C                   PARM                    @VL10           200                          258838
      *                                                                                       258838
     C**********         If        W_SkipFlag = 'Y'                                BUG11886 BUG11917
     C                   If        W_SkipFlag = 'N'                                         BUG11917
     C                   If        CurVal = 'N'                                               258838
     C**********         CALL      'ZVACTBU'                                         258838 MD022997
     C**********         PARM                    ZACTN             1                 258838 MD022997
     C**********         PARM      DBRN          ZBR               3                 258838 MD022997
     C**********         PARM                    ERR               1 0               258838 MD022997
     C                   CALL      'ZVACTBU01'                                              MD022997
     C                   PARM                    ZACTN                                      MD022997
     C                   PARM                    ERR                                        MD022997
     C                   Else                                                                 258838
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C**********         PARM      DBRN          ZBR               3                         BUG2653
     C                   PARM                    ZBR               3                         BUG2653
     C                   PARM                    ERR               1 0
     C**********         EndIf                                                     BUG11886 BUG11917
     C                   Endif                                                                258838
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='C'                                                 CSD007
     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                                 CSD007
     C                   WHEN      DDACTN='R'                                                 CSD007
     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                                 CSD007
     C**********         WHEN      DDACTN='X'                                        CSD031 BUG13525
     C**********         MOVEL     'CSF9008'     MsgIdArr(Ix)                        CSD031 BUG13525
     C/COPY WNCPYSRC,SDH00482
     C                   ENDSL
     C                   END
     C                   END
     C                   EndIf                                                              BUG11917
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVCUS - RETRIEVE CUSTOMER IF ACTION CODE 'A', 'E' OR 'D'
      *****************************************************************
     C     RTVCUS        BEGSR
      *
      * Access Customer from the Customers file
      *
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C     DDCUSN        CHAIN     SDCDSHL1                           44                      CSD028
     C                   ELSE                                                                 CSD028
     C     DDCUSN        CHAIN     SDCUSTLR                           44
     C                   ENDIF                                                                CSD028
      *
      * Customer details not found
      *
      ** Skip validation if the customer came from the acceptance file.                       CSD031
                                                                                              CSD031
     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
     C     *IN44         IFEQ      '1'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0081'     MsgIdArr(Ix)
      * Customer must reference an active Customer
     C                   ELSE
                                                                                              CGL132
     C     DDCUSN        CHAIN     SDCUSTX1                                                   CGL132
                                                                                              CSW207
     C**********         IF        CSW207 = 'Y' OR BGN4ST = 'Y'                     CSW207A BUG15138
     C     DDCUSN        CHAIN     SDCSSWL1                                                   CSW207
     C**********         IF        DDACTN <> 'A'                                     CFT050 MD022395
     C**********         EVAL      DDLEIC = CSLEIC                                   CFT050 MD022395
     C**********         EVAL      DDCLSY = CSCLSY                                   CFT050 MD022395
     C**********         EVAL      DDCLID = CSCLID                                   CFT050 MD022395
     C**********         EVAL      DDBDRK = CSBDRK                                   CFT050 MD022395
     C**********         ENDIF                                                       CFT050 MD022395
     C**********         IF        CSBDRK <> *BLANKS                                 CFT050 MD022766
     C**********                   AND CSW213 = 'Y'                                  CFT050 MD022463
     C**********         EXSR      Pop_SW13                                          CFT050 MD022463
     C**********                   AND CFT050 = 'Y'                                MD022463 MD022766
     C                   EXSR      Pop_SW13Scrn                                             MD022463
     C**********         ENDIF                                                       CFT050 MD022766
     C**********         ENDIF                                                       CSW207 BUG15138
                                                                                              CSW207
     C     BBDTDL        IFNE      *ZERO
     C     DDACTN        ANDNE     'E'                                                        CSW024
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   IF        DDACTN = 'I'                                             MD025006
     C                   MOVEL     'USR0342'     MsgIdArr(Ix)
     C                   ELSEIF    DDACTN = 'A' OR DDACTN = 'D'                             MD025006
     C                   MOVEL     '5046257'     MsgIdArr(Ix)                               MD025006
     C                   ENDIF                                                              MD025006
     C                   ELSE                                                                 215524
     C     BBCLST        IFEQ      'Y'                                                        215524
     C     DDACTN        ANDEQ     'A'                                                        215524
     C                   MOVEL     'N'           OKCUST                                       215524
     C                   ADD       1             Ix                                           215524
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               215524
     C                   MOVEL     'USR9236'     MsgIdArr(Ix)                                 215524
     C                   END                                                                  215524
     C                   END
     C                   END
     C**********         ENDIF                                                       CSD031 BUG13525

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVBRT - RETRIEVE CUSTOMER BASE RATE TAX DETAILS IF S01383 = 'Y'
      *****************************************************************
     C     RTVBRT        BEGSR
      *
      * Access Customer Base Rate Tax details from the BRT file
      *
     C                   MOVEL     DDCUSN        XCNUM
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C     XCNUM         CHAIN     @BRTRF                             45                      CSD028
     C                   ELSE                                                                 CSD028
     C     XCNUM         CHAIN     SDCBRTLR                           45
     C                   ENDIF                                                                CSD028
      *
     C**  IF INSERT AND LIVE RECORD FOUND - ERROR
      *
      ** Skip validation if the customer came from the acceptance file.                       CSD031
                                                                                              CSD031
     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
     C     DDACTN        IFEQ      'I'

     C     *IN45         IFEQ      '0'
     C     XRECI         ANDEQ     'D'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)
     C                   END
      *
     C**  IF DELETE, AMEND OR ENQUIRE
     C                   ELSE
     C*
     C**  IF LIVE RECORD NOT FOUND - ERROR
     C*
     C     *IN45         IFEQ      '1'
     C     XRECI         ORNE      'D'
     C     DDACTN        ANDNE     'E'                                                        241040
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3855'     MsgIdArr(Ix)
     C                   END

     C                   ENDIF
     C**********         ENDIF                                                       CSD031 BUG13525

     C                   ENDSR
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * RTVFTC - Retrieve FATCA customer details if CGL132 = 'Y'                              CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     RTVFTC        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Access FATCA customer details                                                        CGL132
                                                                                              CGL132
     C     DDCUSN        CHAIN     SDFTCSL1                           45                      CGL132
                                                                                              CGL132
      **  If insert and live record found - error                                             CGL132
                                                                                              CGL132
     C     DDACTN        IFEQ      'I'                                                        CGL132
                                                                                              CGL132
     C     *IN45         IFEQ      '0'                                                        CGL132
     C                   MOVEL     'N'           OKCUST                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CLEAR                   CuFaFilFmt                                   CGL132
     C                   EVAL      FACUST = DDCUSN                                            CGL132
     C                   EVAL      FACLAC = WWCLAC                                            CGL132
                                                                                              CGL132
      ** Retrieve classification description                                                  CGL132
                                                                                              CGL132
     C                   CALL      'AOFATCR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*KEY    '    @OPTN                                        CGL132
     C                   PARM      FACLAC        @CLAC                                        CGL132
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
                                                                                              CGL132
      ** If value entered by user is not found on the FATCA                                   CGL132
      ** classification code file then return an error                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD = '*NRF' OR                                          CGL132
     C                             @RTCD <> *BLANKS                                           CGL132
     C                   MOVEL     'N'           OKCUST                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      **  If delete, amend or enquire                                                         CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
      **  If record not found - ERROR                                                         CGL132
                                                                                              CGL132
     C     DDACTN        IFNE      'D'                                                      MD039670
     C     DDACTN        ANDNE     'E'                                                      MD041337
     C     DDACTN        ANDNE     'A'                                                      MD041527
     C     *IN45         IFEQ      '1'                                                        CGL132
     C                   MOVEL     'N'           OKCUST                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0172'     MsgIdArr(Ix)                                 CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
     C                   IF        FACLAC <> *BLANKS                                          CGL132
      ** Retrieve classification description                                                  CGL132
                                                                                              CGL132
     C                   CALL      'AOFATCR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*KEY    '    @OPTN                                        CGL132
     C                   PARM      FACLAC        @CLAC                                        CGL132
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
                                                                                              CGL132
      ** If value entered by user is not found on the FATCA                                   CGL132
      ** classification code file then return an error                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD = '*NRF' OR                                          CGL132
     C                             @RTCD <> *BLANKS                                           CGL132
     C                   MOVEL     'N'           OKCUST                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAPCLA <> *BLANKS                                          CGL132
      ** Retrieve classification description                                                  CGL132
                                                                                              CGL132
     C                   CALL      'AOFATCR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*KEY    '    @OPTN                                        CGL132
     C                   PARM      FAPCLA        @CLAC                                        CGL132
     C     SDFATC        PARM      SDFATC        DSFDY                                        CGL132
                                                                                              CGL132
      ** If value entered by user is not found on the FATCA                                   CGL132
      ** classification code file then return an error                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD = '*NRF' OR                                          CGL132
     C                             @RTCD <> *BLANKS                                           CGL132
     C                   MOVEL     'N'           OKCUST                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'USS0173'     MsgIdArr(Ix)                                 CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CGL133 = 'N'                                               CGL132
     C                   MOVE      *BLANKS       WWTINO                                       CGL132
     C                   IF        E5TNC5 = WCTAX                                             CGL132
     C                   MOVE      *BLANKS       WWTINO                                       CGL132
     C                   MOVEL     E5TIN5        WWTINO                                       CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC4 = WCTAX                                             CGL132
     C                   MOVE      *BLANKS       WWTINO                                       CGL132
     C                   MOVEL     E5TIN4        WWTINO                                       CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC3 = WCTAX                                             CGL132
     C                   MOVE      *BLANKS       WWTINO                                       CGL132
     C                   MOVEL     E5TIN3        WWTINO                                       CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        E5TNC2 = WCTAX                                             CGL132
     C                   MOVE      *BLANKS       WWTINO                                       CGL132
     C                   MOVEL     E5TIN2        WWTINO                                       CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        BBCOLC = WCTAX                                             CGL132
     C                   MOVE      *BLANKS       WWTINO                                       CGL132
     C                   MOVEL     E5TINO        WWTINO                                       CGL132
     C                   ENDIF                                                                CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      WWTINO = FAUTIN                                            CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAUTIN = WWTINO                                            CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVPRV - RETRIEVE PRIVATE BANKING CUS DETAILS IF PBSwtc = 'Y'  '
      *****************************************************************
     C     RTVPRV        BEGSR
      *
      * Access Customer Private Banking details from the PB file
      *
     C                   MOVEL     DDCUSN        A_PBCNUM
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C     A_PBCNUM      CHAIN     @CPBRF                             45                      CSD028
     C                   ELSE                                                                 CSD028
     C     A_PBCNUM      CHAIN     SDPBDSLR                           45
     C                   ENDIF                                                                CSD028
      *
     C**  IF INSERT AND LIVE RECORD FOUND - ERROR
      *
      ** Skip validation if the customer came from the acceptance file.                       CSD031
                                                                                              CSD031
     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
     C     DDACTN        IFEQ      'I'

     C     *IN45         IFEQ      '0'
     C     A_PBRECI      ANDEQ     'D'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)
     C                   END
      *
     C**  IF DELETE, AMEND OR ENQUIRE
     C                   ELSE
     C*
     C**  IF LIVE RECORD NOT FOUND - ERROR
     C*
     C     *IN45         IFEQ      '1'
     C     A_PBRECI      ORNE      'D'
     C     DDACTN        ANDNE     'E'                                                        CSW024
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3865'     MsgIdArr(Ix)
     C                   END

     C                   ENDIF
     C**********         ENDIF                                                       CSD031 BUG13525

     C                   ENDSR
      *****************************************************************
      * RTVTID - Retrieve TI Customer Details                                                BUG3362
      *****************************************************************                      BUG3362
     C     RTVTID        BEGSR                                                               BUG3362
      *                                                                                      BUG3362
      * Access TI Customer Details from PF/SDICSPD                                           BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     DDCUSN        A_TCCUST          6                         BUG3362
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C     A_TCCUST      CHAIN     SDTICSD0                           45                      CSD028
     C                   ELSE                                                                 CSD028
     C     A_TCCUST      CHAIN     SDTICSLR                           45                     BUG3362
     C                   ENDIF                                                               CSD028
      *                                                                                      BUG3362
      ** If Insert and live record found - ERROR                                             BUG3362
      *                                                                                      BUG3362
     C     DDACTN        IFEQ      'I'                                                       BUG3362
                                                                                             BUG3362
     C     *IN45         IFEQ      '0'                                                       BUG3362
     C                   MOVEL     'N'           OKCUST                                      BUG3362
     C                   ADD       1             Ix                                          BUG3362
     C                   MOVEL     'A_TCCUST'    FldNameArr(Ix)                              BUG3362
      ** need to check for proper error message ID                                           BUG3362
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
      ****If*Delete, Amend Or Enquire                                                BUG3362 BG12238
     C**********         ELSE                                                        BUG3362 BG12238
      **********                                                                     BUG3362 BG12238
      ****If*live record not found - ERROR                                           BUG3362 BG12238
      **********                                                                     BUG3362 BG12238
     C******IN45         IFEQ      '1'                                               BUG3362 BG12238
     C*****DDACTN        ANDNE     'E'                                               BUG3362 BG12238
     C**********         MOVEL     'N'           OKCUST                              BUG3362 BG12238
     C**********         ADD       1             Ix                                  BUG3362 BG12238
     C**********         MOVEL     'A_TCCUST'    FldNameArr(Ix)                      BUG3362 BG12238
      ***DBerror, details not found                                                  BUG3362 BG12238
     C**********         MOVEL     'USR4181'     MsgIdArr(Ix)                        BUG3362 BG12238
     C**********         ENDIF                                                       BUG3362 BG12238
                                                                                             BUG3362
     C                   ENDIF                                                               BUG3362
                                                                                             BUG3362
     C                   ENDSR                                                               BUG3362
      *****************************************************************                      BUG3362
      /EJECT                                                                                  CGP001
      *****************************************************************                       CGP001
      * RTVGLB - Retrieve Global Customers X-Reference details                                CGP001
      *          if CGP001 = 'Y'                                                              CGP001
      *****************************************************************                       CGP001
     C     RTVGLB        BEGSR                                                                CGP001
                                                                                              CGP001
     C     KRTVG         KLIST                                                                CGP001
     C                   KFLD                    BBBRCD                                       CGP001
     C                   KFLD                    DDCUSN                                       CGP001
                                                                                              CGP001
      ** Access Global Customer X-Reference Details                                           CGP001
                                                                                              CGP001
     C                   CLEAR                   GCustFilFmt                                 BUG2313
     C     KRTVG         CHAIN     GPCUSTXL1                          45                      CGP001
                                                                                              CGP001
      ** If insert and exist in file, error                                                   CGP001
                                                                                              CGP001
     C     DDACTN        IFEQ      'I'                                                        CGP001
                                                                                              CGP001
     C                   IF        *IN45 = '0'                                                CGP001
     C                   EVAL      OKCUST = 'N'                                               CGP001
     C                   EVAL      Ix = Ix + 1                                                CGP001
     C                   EVAL      FldNameArr(Ix) = 'DDCUSN'                                  CGP001
     C                   EVAL      MsgIdArr(Ix) = 'Y2U0003'                                   CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   ENDSR                                                                CGP001
      *****************************************************************                       CGP001
      /EJECT
     C/COPY WNCPYSRC,SDCUSDIC08
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'D'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS CUSTOMER WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     SDCUSFOI                           99
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE MIDAS CUSTOMER NUMBER
      *
     C                   MOVEL     BBCUST        DDCUSN

     C                   END
                                                                                              CGL132
      ** Access FATCA customer with Front office transaction ID                               CGL132
                                                                                              CGL132
     C     FOTRID        CHAIN     SDFTCSL2                           99                      CGL132
                                                                                              CGL132
      ** if insert                                                                            CGL132
                                                                                              CGL132
     C     DDACTN        IFEQ      'I'                                                        CGL132
                                                                                              CGL132
      ** Front office transaction ID can't be present already                                 CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '0'                                                        CGL132
     C                   MOVE      'N'           OKACTN                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)                                 CGL132
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CGL132
     C                   GOTO      EVFRNT                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
      ** If not insert, Front office transaction ID must be present                           CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '1'                                                        CGL132
     C                   MOVE      'N'           OKACTN                                       CGL132
     C                   ADD       1             Ix                                           CGL132
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CGL132
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)                                 CGL132
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)                                CGL132
     C                   GOTO      EVFRNT                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If not insert, update Midas customer number                                          CGL132
                                                                                              CGL132
     C                   MOVEL     FACUST        DDCUSN                                       CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND CUSTOMER NUMBER
      *****************************************************************
     C     VAL           BEGSR
      *
      * Action Code
      *
      *  .. must be 'I','A','D' or 'E'
      *  .. or 'C' or 'R'                                                                     CSD007
      *
     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
                                                                                              CSD031
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'C'                                                        CSD007
     C     DDACTN        ANDNE     'R'                                                        CSD007
     C/COPY WNCPYSRC,SDH00483
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
     C**********         MOVEL     'SDA0006'     MsgIdArr(Ix)                        CSD031 BUG13525
     C**********         ELSE                                                        CSD031 BUG13525
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C**********         ENDIF                                                       CSD031 BUG13525
     C                   GOTO      EVAL                                                      BUG8169
     C                   END
                                                                                              CSD031
     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
     C*****DDCUSN        CHAIN     SDACSTL1                                          CSD031 BUG13525
     C**********         IF        %FOUND AND                                        CSD031 BUG13525
     C**********                   DDACTN <> 'I' AND                                 CSD031 BUG13525
     C**********                   DDACTN <> 'E'                                     CSD031 BUG13525
     C**********         MOVEL     'N'           OKACTN                              CSD031 BUG13525
     C**********         ADD       1             Ix                                  CSD031 BUG13525
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                      CSD031 BUG13525
     C**********         MOVEL     'CSD0002'     MsgIdArr(Ix)                        CSD031 BUG13525
     C**********         GOTO      EVAL                                              CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ELSE                                                        CSD031 BUG13525
                                                                                              CSD031
     C*****DDACTN        IFNE      'I'                                               CSD031 BUG13525
     C*****DDACTN        ANDNE     'A'                                               CSD031 BUG13525
     C*****DDACTN        ANDNE     'D'                                               CSD031 BUG13525
     C*****DDACTN        ANDNE     'E'                                               CSD031 BUG13525
     C*****DDACTN        ANDNE     'X'                                               CSD031 BUG13525
     C**********         MOVEL     'N'           OKACTN                              CSD031 BUG13525
     C**********         ADD       1             Ix                                  CSD031 BUG13525
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                      CSD031 BUG13525
     C**********         MOVEL     'SDA0013'     MsgIdArr(Ix)                        CSD031 BUCSD031
     C**********         MOVEL     'CSF9094'     MsgIdArr(Ix)                      BUG11888 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
      ** Skip further validation if the customer came from the acceptance file.               CSD031
                                                                                              CSD031
     C**********         LEAVESR                                                     CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
      *
      * Customer Number
      *
      *  If the Customer Number is not blank, check that it is numeric.
      *
     C                   TESTN                   DDCUSN               98
     C                   MOVE      DDCUSN        @1CUST            1
     C                   TESTZ                   @1CUST                   99
      *
      ** If Alphanumeric Customer Numbers are enabled                                         CSD027
     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
     C                   Eval      PCust = DDCUSN                                             CSD027
     C                   Eval      PValid = *BLANKS                                           CSD027
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
      * If Error                                                                              CSD027
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
     C                   Eval      DBASE = 913                                                CSD027
     C                   Eval      DBKEY = PCust                                              CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C*****DDCUSN        IFNE      *BLANKS                                                    CSD027
     C******IN98         ANDEQ     '0'                                                        CSD027
     C*****DDCUSN        ORNE      *BLANKS                                                    CSD027
     C******IN99         ANDEQ     '0'                                                        CSD027
     C**********         MOVEL     'N'           OKCUST                                       CSD027
     C**********         ADD       1             Ix                                           CSD027
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD027
     C**********         MOVEL     'USR0822'     MsgIdArr(Ix)                                 CSD027
     C**********         GOTO      EVAL                                                       CSD027
     C**********         END                                                                  CSD027
      *                                                                                       CSD027
      * Check if Customer# is valid                                                           CSD027
     C                   If        DDCUSN = *BLANKS                                           CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'N' And                                  CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (DDACTN <> 'I' And                                         CSD027
     C                              WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'Y' And                                 CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              PValid = *BLANKS)                                         CSD027
     C                             Or                                                       BUG11934
     C                             (WCusAlphaAllow = 'Y' And                                BUG11934
     C                              WCusAlphaSupNum = 'Y' And                               BUG11934
     C                              PValid = *BLANKS)                                       BUG11934
      *                                                                                       CSD027
     C                   Else                                                                 CSD027
      * If invalid Customer#                                                                  CSD027
     C                   Eval      OKCUST = 'N'                                               CSD027
     C                   Add       1             Ix                                           CSD027
     C                   Eval      FldNameArr(Ix) = 'DDCUSN'                                  CSD027
     C                   If        WCusAlphaAllow = 'N'                                       CSD027
     C                   Eval      MsgIdArr(Ix) = 'S270003'                                   CSD027
     C                   Else                                                                 CSD027
     C                   Eval      MsgIdArr(Ix) = 'S270004'                                   CSD027
     C                   EndIf                                                                CSD027
     C                   Goto      EVAL                                                       CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD021
      ** Customer Number mandatory if DDACTN = 'I' and CSD021 is off                          CSD021
      **                           OR DDACTN <> 'I'                                           CSD021
     C     CSD021        IFNE      'Y'                                                        CSD021
     C     DDACTN        ANDEQ     'I'                                                        CSD021
     C     DDACTN        ORNE      'I'                                                        CSD021
      *
      *  Customer number required
      *
     C     DDCUSN        IFEQ      *BLANKS
     C     DDCUSN        OREQ      *ZEROS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0246'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C/COPY WNCPYSRC,SDCUSDIC04
      *                                                                                       CSD021
     C                   ENDIF                                                                CSD021
      *                                                                                       CSD021
      ** Call SD0011U only if DDCUSN is not blank                                             CSD021
     C     DDCUSN        IFNE      *BLANK                                                     CSD021
      *
     C                   Eval      @RTCD = *BLANKS                                            CSD027
     C                   Eval      PValid = *BLANKS                                           CSD027
      *
      *  Modulus 10 Validation if Apply Modulus 10 Check
      *
     C     BJMODT        IFEQ      'Y'
     C     DDACTN        ANDEQ     'I'                                                        214144
     C*****WCusAlphChksumANDEQ     'N'                                               CSD027 BUG11932
     C     WCusAlphaAllowANDEQ     'N'                                                      BUG11932
      *
     C/COPY WNCPYSRC,SDCUSDIC01
     C                   CALL      'SD0011U'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      DDCUSN        @CUST             6
      *
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   If        DDACTN = 'I' And WCusAlphChksum = 'Y'                      CSD027
     C                             And  WCusAlphaAllow = 'Y'                                BUG11932
     C                   Eval      PCust = DDCUSN                                             CSD027
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
      * If Error                                                                              CSD027
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
     C                   Eval      DBASE = 915                                                CSD027
     C                   Eval      DBKEY = PCust                                              CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
      *  ERROR DETECTED ?
      *
     C     @RTCD         IFNE      *BLANKS
     C     PValid        ORNE      *BLANKS                                                    CSD027
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C**********         If        WCusAlphChksum = 'N'                              CSD027 BUG11932
     C                   If        WCusAlphaAllow = 'N'                                     BUG11932
     C                   MOVEL     'USR0986'     MsgIdArr(Ix)
     C                   Else                                                                 CSD027
     C                   Eval      MsgIdArr(Ix) = 'S270005'                                   CSD027
     C                   EndIf                                                                CSD027
     C                   GOTO      EVAL
     C                   END
      *
     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
     C                   MoveL(P)  DDCUSN        @CSSN            10                          CSD027
      *                                                                                       CSD027
      * Check if customer# is same as any other customer's shortname                          CSD027
     C     @CSSN         Chain     SDCUSTLH                                                   CSD027
      *                                                                                       CSD027
      * If record found, send error message                                                   CSD027
     C                   If        %Found(SDCUSTLH)                                           CSD027
     C     BBCUST        Ifne      @CSSN                                                      CSD027
     C**********         Eval      OKCUST = 'N'                                        CSD027 CSD091
     C**********         Add       1             Ix                                    CSD027 CSD091
     C**********         Eval      FldNameArr(Ix) = 'DDCUSN'                           CSD027 CSD091
     C**********         Eval      MsgIdArr(Ix) = 'S270006'                            CSD027 249029
     C**********         Eval      MsgIdArr(Ix) = 'S270013'                            249029 CSD091
                                                                                              CSD091
     C**********         EVAL      OKCUST = 'W'                                      CSD091 AR855391
     C**********         EVAL      WIx = WIx + 1                                     CSD091 AR855391
     C**********         EVAL      WFldNamArr(WIx) = 'DDCUSN'                        CSD091 AR855391
     C**********         EVAL      WMsgIDArr(WIx) = 'S270013'                        CSD091 AR855391
                                                                                              CSD091
     C                   Eval      OKCUST = 'N'                                             AR855391
     C                   Add       1             Ix                                         AR855391
     C                   Eval      FldNameArr(Ix) = 'DDCUSN'                                AR855391
     C                   Eval      MsgIdArr(Ix) = 'S270013'                                 AR855391
     C                   Goto      EVAL                                                       CSD027
     C                   EndIf                                                                CSD027
     C                   EndIf                                                                CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C/COPY WNCPYSRC,SDCUSDIC02
     C**********         ENDIF                                                                CSD027
      *                                                                                       CSD021
     C                   ENDIF                                                                CSD021
      *
      *  If manual deletion of customers is not allowed
      *  then action code 'D' delete is not valid
      *  and action codes 'C' closure and 'R' release are also not valid                      CSD007
      *
     C     BJMDEL        IFEQ      'N'
     C*****DDACTN        ANDEQ     'D'                                                        CSD007
     C     DDACTN        IFEQ      'C'                                                        CSD007
     C     DDACTN        OREQ      'R'                                                        CSD007
     C*****DDACTN        OREQ      'D'                                                 CSD007 254109
      ***Delete*Action*is*not*allowed**********************************                       254109
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'USR0553'     MsgIdArr(Ix)                                 254109
     C                   MOVEL     '5049396'     MsgIdArr(Ix)                                 254109
     C                   GOTO      EVAL
      *
     C                   ENDIF
      *                                                                                       CSD007
     C     DDACTN        IFEQ      'D'                                                        254109
      *                                                                                       254109
     C                   MOVEL     'N'           OKACTN                                       254109
     C                   ADD       1             Ix                                           254109
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               254109
     C                   MOVEL     '5049395'     MsgIdArr(Ix)                                 254109
     C                   GOTO      EVAL                                                       254109
      *                                                                                       254109
     C                   ENDIF                                                                254109
      *                                                                                       254109
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD012
      * If Authorisation check is on,                                                         CSD012
      * check if unathorised record exists on Authorisation Log.                              CSD012
     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
     C     DDACTN        ANDNE     'E'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     DDCUSN        @DDCUSN                                      CSD012
     C     KAULG         CHAIN     SDAULGL2                           90                      CSD012
      *                                                                                       CSD012
      * If record exists then prevent amendment                                               CSD012
     C     *IN90         IFEQ      *OFF                                                       CSD012
     C     TransType     ANDNE     'AUTH'                                                     CSD028
      *                                                                                       CSD012
     C                   MOVEL     'N'           OKCUST                                       CSD012
     C                   MOVEL     'N'           OKACTN                                       CSD012
     C                   MOVE      1             Ix                                           CSD012
     C                   MOVEL     @KEY          FldNameArr(Ix)                               CSD012
     C                   MOVEL     'USR9265'     MsgIdArr(Ix)                                 CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG23518
      *                                                               *                     BUG23518
      *  SRChkSts - Check if Customer is Taxable when Action is Close *                     BUG23518
      *                                                               *                     BUG23518
      *  Called By: VAL                                               *                     BUG23518
      *                                                               *                     BUG23518
      *  Calls: None                                                  *                     BUG23518
      *                                                               *                     BUG23518
      *****************************************************************                     BUG23518
     C     SRChkSts      BEGSR                                                              BUG23518
      *                                                                                     BUG23518
     C                   EVAL      PCusn = DDCUSN                                           BUG23518
      *                                                                                     BUG23518
      ** Retrieve Taxable Flag value from Customer Details                                  BUG23518
      *                                                                                     BUG23518
     C                   CALLB     'AOCUSTR0'                                               BUG23518
     C                   PARM      *Blanks       P@Rtcd                                     BUG23518
     C                   PARM      '*KEY'        P@Optn                                     BUG23518
     C                   PARM                    PCusn                                      BUG23518
     C                   PARM                    PKySt                                      BUG23518
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23518
      *                                                                                     BUG23518
     C                   IF        P@Rtcd <> *BLANKS                                        BUG23518
      *                                                                                     BUG23518
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG23518
     C                   EVAL      DBASE = 903                                              BUG23518
     C                   EVAL      DBKEY = P@Optn                                           BUG23518
     C                   EXSR      *PSSR                                                    BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** Retrieve European Tax Status                                                       BUG23518
      *                                                                                     BUG23518
     C                   EVAL      KFCusn = DDCUSN                                          BUG23518
     C                   EVAL      KFCTax = ABBCOLC                                         BUG23518
      *                                                                                     BUG23518
     C     KLActx        CHAIN     SDACTXL1                                                 BUG23518
      *                                                                                     BUG23518
      ** If Customer found and is Taxable, display warning                                  BUG23518
      *                                                                                     BUG23518
     C                   IF        %FOUND(SDACTXL1)                                         BUG23518
      *                                                                                     BUG23518
     C                   IF        AXETXS = 'T'                                             BUG23518
     C                             OR (AXETXS = 'Y' AND CER069 = 'Y')                         CER069
      *                                                                                     BUG23518
     C                   EVAL      OKCUST = 'W'                                             BUG23518
     C                   EVAL      WIx = WIx + 1                                            BUG23518
     C                   EVAL      WFldNamArr(WIx) = 'DDCUSN'                               BUG23518
     C                   EVAL      WMsgIDArr(WIx)  = 'USR6501'                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDSR                                                              BUG23518
      *****************************************************************                     BUG23518
      /EJECT                                                                                BUG23518
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      * Access Customer from the Customers file
      *
     C     DDCUSN        CHAIN     SDCUSTLR                           44
      *
      * Error if present already
      *
     C     *IN44         IFEQ      '0'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
      *                                                                                       CFT050
      ** Get customer swift details                                                           CFT050
      *                                                                                       CFT050
     C                   ELSE                                                                 CFT050
     C**********         IF        CSW213 = 'Y'                                      CFT050 MD022463
     C**********                   AND DDBDRK <> *BLANKS                             CFT050 MD022463
     C**********         IF        CFT050 = 'Y'                                    MD022463 MD022766
     C                   EXSR      Pop_SW13                                                   CFT050
     C**********         ENDIF                                                       CFT050 MD022766
     C                   END
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
     C                   MOVEL     'N'           WUERCD            1
                                                                                            BUG27866
     C                   EVAL      WWRTRN = *BLANKS                                         BUG27866
     C                   Z-ADD     187           WWLENG                                     BUG27866
     C                   EVAL      WWINPT = 'JOBI0300'                                      BUG27866
     C                   EVAL      WWQUAL = *BLANKS                                         BUG27866
     C                   EVAL      WWINTR = *BLANKS                                         BUG27866
     C                   EVAL      @WQUTP = 'Y'                                             BUG27866
                                                                                            BUG27866
     C                   CALL      'QUSRJOBI'                                               BUG27866
     C                   PARM                    WWRTRN                                     BUG27866
     C                   PARM                    WWLENG                                     BUG27866
     C                   PARM                    WWINPT                                     BUG27866
     C                   PARM      '*'           WWQUAL                                     BUG27866
     C                   PARM                    WWINTR                                     BUG27866
                                                                                            BUG27866
     C                   IF        WJOBTP = 'I' AND                                         BUG27866
     C                             WWJOB <> 'QZDASOINIT'                                    BUG27866
     C                   EVAL      @WQUTP = 'N'                                             BUG27866
     C                   ENDIF                                                              BUG27866
      *
      *  Customer Deletion Pre-checks - Client Details
      *
     C                   CALL      'SD0011X'                            90
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      DDCUSN        @CUST             6
      * Customer Delete Status
     C                   PARM      WUDELS        @WDELS            7
      * Customer Deln String 1
     C                   PARM      WDS1000       @WCDS1          200
      * Customer Deln String 2
     C                   PARM      WDS2000       @WCDS2          200
      * Customer Deln String 3
     C                   PARM      WDS3000       @WCDS3          200
      * Customer Deln String 4
     C                   PARM      WDS4000       @WCDS4          200
      * Customer Deln String 5
     C                   PARM      WDS5000       @WCDS5          200
      * Quit program
     C**********         PARM      'N'           @WQUTP            1                        BUG27866
     C                   PARM                    @WQUTP                                     BUG27866
      *
      *  Call to program ended in error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'Y2U0032'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      *
      *  ERROR DETECTED ?
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2209'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C     @WDELS        IFNE      'DELETE'
     C                   MOVEL     'Y'           WUERCD
      * CUSTOMER SPECIFIC CHECKS:
      * Customer delete rejected by Bank specific check number 1.
      * CASE: WRK.Customer Deln Flag 801 is Do not delete
     C     WDS5001       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2209'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 2.
      * CASE: WRK.Customer Deln Flag 802 is Do not delete
     C     WDS5002       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2210'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 3.
      * CASE: WRK.Customer Deln Flag 803 is Do not delete
     C     WDS5003       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2211'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 4.
      * CASE: WRK.Customer Deln Flag 804 is Do not delete
     C     WDS5004       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2212'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 5.
      * CASE: WRK.Customer Deln Flag 805 is Do not delete
     C     WDS5005       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2213'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 6.
      * CASE: WRK.Customer Deln Flag 806 is Do not delete
     C     WDS5006       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2214'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 7.
      * CASE: WRK.Customer Deln Flag 807 is Do not delete
     C     WDS5007       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2215'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 8.
      * CASE: WRK.Customer Deln Flag 808 is Do not delete
     C     WDS5008       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2216'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 9.
      * CASE: WRK.Customer Deln Flag 809 is Do not delete
     C     WDS5009       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2217'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer delete rejected by Bank specific check number 10.
      * CASE: WRK.Customer Deln Flag 810 is Do not delete
     C     WDS5010       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2218'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * GENERAL LEDGER CHECKS:
      * Customer defined on ACCNT.
      * CASE: WRK.Customer Deln Flag 201 is Do not delete
     C     WDS2001       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1119'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * SECURITIES TRADING CHECKS:
      * Customer defined on CDEPPD.
      * CASE: WRK.Customer Deln Flag 213 is Do not delete
     C     WDS2013       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2078'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Depot customer has a live depot movement defined on DPTMVD.
      * CASE: WRK.Customer Deln Flag 214 is Do not delete
     C     WDS2014       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2224'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a live depot movement defined on DPTMVD.
      * CASE: WRK.Customer Deln Flag 215 is Do not delete
     C     WDS2015       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2225'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Depot customer has a reversed depot movement defined on DPTMVD.
      * CASE: WRK.Customer Deln Flag 216 is Do not delete
     C     WDS2016       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2226'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a reversed depot movement defined on DPTMVD.
      * CASE: WRK.Customer Deln Flag 217 is Do not delete
     C     WDS2017       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2227'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on SECTYD.
      * CASE: WRK.Customer Deln Flag 225 is Do not delete
     C     WDS2025       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2077'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on TRADSD.
      * CASE: WRK.Customer Deln Flag 221 is Do not delete
     C     WDS2021       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2076'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Depot customer defined on TRADSD.
      * CASE: WRK.Customer Deln Flag 222 is Do not delete
     C     WDS2022       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2219'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on HSTTRD.
      * CASE: WRK.Customer Deln Flag 219 is Do not delete
     C     WDS2019       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2228'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Depot customer defined on HSTTRD.
      * CASE: WRK.Customer Deln Flag 220 is Do not delete
     C     WDS2020       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2229'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on investment type INVTPD.
      * CASE: WRK.Customer Deln Flag 223 is Do not delete
     C     WDS2023       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2230'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a position settlement on POSETD.
      * CASE: WRK.Customer Deln Flag 224 is Do not delete
     C     WDS2024       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2231'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a security limit on SLIMH.
      * CASE: WRK.Customer Deln Flag 226 is Do not delete
     C     WDS2026       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2232'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a standard settlement defined on STDSED.
      * CASE: WRK.Customer Deln Flag 227 is Do not delete
     C     WDS2027       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2233'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Depot customer defined on a standard settlement on STDSED.
      * CASE: WRK.Customer Deln Flag 228 is Do not delete
     C     WDS2028       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2234'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has user positions defined on UDEPPD.
      * CASE: WRK.Customer Deln Flag 229 is Do not delete
     C     WDS2029       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2235'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * DEALING CHECKS:
      * Customer defined on CUSDL.
      * CASE: WRK.Customer Deln Flag 202 is Do not delete
     C     WDS2002       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1878'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * CUSTOMER LENDING CHECKS:
      * Customer defined on FACIL.
      * CASE: WRK.Customer Deln Flag 203 is Do not delete
     C     WDS2003       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1116'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a live facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 204 is Do not delete
      * Customer has a reversed facility defined on FCLTY.
     C     WDS2004       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1118'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a reversed facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 207 is Do not delete
     C     WDS2007       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2220'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has a closed facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 208 is Do not delete
     C     WDS2008       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2221'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has an expired facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 209 is Do not delete
     C     WDS2009       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2222'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on GTEES.
      * CASE: WRK.Customer Deln Flag 205 is Do not delete
      * Customer defined on LEREF.
     C     WDS2005       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1124'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on LEREF.
      * CASE: WRK.Customer Deln Flag 206 is Do not delete
     C     WDS2006       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1122'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on CLOANCL.
      * CASE: WRK.Customer Deln Flag 230 is Do not delete
     C     WDS2030       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2237'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * EXPOSURE MANAGEMENT CHECKS:
      * Customer defined on EMLIML2.
      * CASE: WRK.Customer Deln Flag 212 is Do not delete
     C     WDS2012       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2238'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * STANDING DATA CHECKS:
      * Customer defined on SDBANKPD.
      * CASE: WRK.Customer Deln Flag 002 is Do not delete
     C     WDS1002       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1110'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on SDBRCHPD.
      * CASE: WRK.Customer Deln Flag 003 is Do not delete
     C     WDS1003       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1115'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      *                                                                                       198304
      ** CASE: WRK.Customer Deln Flag 043 is Do not delete                                    198304
      *                                                                                       198304
     C     WDS1043       IFEQ      'F'                                                        198304
     C                   MOVEL     'N'           OKCUST                                       198304
     C                   ADD       1             Ix                                           198304
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               198304
     C                   MOVEL     'USR3966'     MsgIdArr(Ix)                                 198304
     C                   GOTO      EVALAD                                                     198304
     C                   ENDIF                                                                198304
      *                                                                                       198304
      * Customer defined on SDCLLMPD.
      * CASE: WRK.Customer Deln Flag 027 is Do not delete
     C     WDS1027       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2223'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined as a parent on SDCUSTPD.
      * CASE: WRK.Customer Deln Flag 006 is Do not delete
     C     WDS1006       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1114'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on SDDEALPD.
      * CASE: WRK.Customer Deln Flag 007 is Do not delete
     C     WDS1007       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1111'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has extended settlements defined on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 008 is Do not delete
     C     WDS1008       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1125'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is receipt ordering customer on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 009 is Do not delete
     C     WDS1009       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1127'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is receipt ordering bank on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 010 is Do not delete
     C     WDS1010       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1126'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is receipt intermediary bank on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 011 is Do not delete
     C     WDS1011       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1128'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is pay ordering customer on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 012 is Do not delete
     C     WDS1012       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1130'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is pay ordering bank on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 013 is Do not delete
     C     WDS1013       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1129'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is pay intermediary bank on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 014 is Do not delete
     C     WDS1014       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1131'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is receiver correspondant on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 015 is Do not delete
     C     WDS1015       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1132'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is receiver number on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 016 is Do not delete
     C     WDS1016       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1133'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is an account with Bank on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 017 is Do not delete
     C     WDS1017       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1134'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is a beneficiary number on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 018 is Do not delete
     C     WDS1018       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1135'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is our receive nostro on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 019 is Do not delete
     C     WDS1019       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1531'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is our payment nostro on SDEXSTPD.
      * CASE: WRK.Customer Deln Flag 020 is Do not delete
     C     WDS1020       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1532'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the EUROCLEAR customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 023 is Do not delete
     C     WDS1023       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1100'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the CEDEL customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 024 is Do not delete
     C     WDS1024       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1101'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the KASSENVEREIN customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 025 is Do not delete
     C     WDS1025       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1102'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 4 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 026 is Do not delete
     C     WDS1026       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1103'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 5 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 028 is Do not delete
     C     WDS1028       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1104'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 6 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 029 is Do not delete
     C     WDS1029       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1105'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 7 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 030 is Do not delete
     C     WDS1030       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1106'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 8 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 031 is Do not delete
     C     WDS1031       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1107'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 9 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 032 is Do not delete
     C     WDS1032       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1108'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is the Depot 10 customer on SDSTRDPD.
      * CASE: WRK.Customer Deln Flag 033 is Do not delete
     C     WDS1033       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1109'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is a Leo customer on SDCLEOPD.
      * CASE: WRK.Customer Deln Flag 036 is Do not delete
     C     WDS1036       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2371'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * F8 FUNCTION CHECKS:
      * Customer defined on SDACUSPD.
      * CASE: WRK.Customer Deln Flag 001 is Do not delete
     C     WDS1001       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1939'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on SDCFCDPD.
      * CASE: WRK.Customer Deln Flag 004 is Do not delete
     C     WDS1004       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1940'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on SDCMRKPD.
      * CASE: WRK.Customer Deln Flag 005 is Do not delete
     C     WDS1005       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1563'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer defined on SDFOCSPD.
      * CASE: WRK.Customer Deln Flag 021 is Do not delete
     C     WDS1021       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1113'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
                                                                                            MD042652
      ** Customer is attached to an instrument type.                                        MD042652
     C     WDS1045       IFEQ      'F'                                                      MD042652
     C                   MOVEL     'N'           OKCUST                                     MD042652
     C                   ADD       1             Ix                                         MD042652
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                             MD042652
     C                   MOVEL     'USS0568'     MsgIDArr(Ix)                               MD042652
     C                   GOTO      EVALAD                                                   MD042652
     C                   ENDIF                                                              MD042652
                                                                                              CRN001
      * Regulatory Reporting checks:                                                          CRN001
      * Record exists on sdcustxb.                                                            CRN001
     C     WDS1044       IFEQ      'F'                                                        CRN001
     C                   MOVEL     'N'           OKCUST                                       CRN001
     C                   ADD       1             Ix                                           CRN001
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CRN001
     C                   MOVEL     'USR4050'     MsgIdArr(Ix)                                 CRN001
     C                   GOTO      EVALAD                                                     CRN001
     C                   END                                                                  CRN001
                                                                                              CRN001
      * Customer defined on SDSECSPD.
      * CASE: WRK.Customer Deln Flag 022 is Do not delete
     C     WDS1022       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR1112'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is a Portfolio Lending customer on SDLBCSPD.
      * CASE: WRK.Customer Deln Flag 035 is Do not delete
     C     WDS1035       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2373'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer is a Portfolio Management customer on SDPLCSPD.
      * CASE: WRK.Customer Deln Flag 034 is Do not delete
     C     WDS1034       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2372'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * User Defined Correspondence
      * CASE: WRK.Customer Deln Flag 218 is Do not delete
     C     WDS2018       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR2618'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has Credit Card details defined on SDCCRDPD.
      * CASE: WRK.Customer Deln Flag 037 is Do not delete
     C     WDS1037       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3043'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has Power of Attorney details defined on SDPATTPD.
      * CASE: WRK.Customer Deln Flag 038 is Do not delete
     C     WDS1038       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3044'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has Joint A/c Holder details defined on SDJUSRPD.
      * CASE: WRK.Customer Deln Flag 039 is Do not delete
     C     WDS1039       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3045'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Customer has Related Customer Number details defined on SDRELCPD.
      * CASE: WRK.Customer Deln Flag 040 is Do not delete
     C     WDS1040       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3046'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
      * Trade Innovation customers on SDTICSPD
      * CASE: WRK.Customer Deln Flag 041 is Do not delete
     C     WDS1041       IFEQ      'F'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR3538'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C/COPY WNCPYSRC,SDCUSDIC09
      * End of change S01424 - Customer Deletion in COB.
      * Check to see if all the checks have been successfully completed.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0152'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C                   END

     C     EVALAD        ENDSR
      *****************************************************************                       CSD007
      * VALACC - VALIDATION OF ACTION CODE 'C'                                                CSD007
      *****************************************************************                       CSD007
     C     VALACC        BEGSR                                                                CSD007
      *                                                                                       CSD007
     C     BBDTDL        IFNE      0                                                          CSD007
     C     BBCLST        OREQ      'Y'                                                        CSD007
     C                   MOVEL     'N'           OKACTN                                       CSD007
     C                   ADD       1             Ix                                           CSD007
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CSD007
     C                   MOVEL     'USR0568'     MsgIdArr(Ix)                                 CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD007
     C     BBCLST        IFNE      'Y'                                                        215524
     C                   CALL      'SD0010U'                                  Check for delet CSD007
     C                   PARM      DDCUSN        @CUST             6          Customer Number CSD007
     C                   PARM      *BLANK        @RTCD             7          *Return code    CSD007
     C                   PARM      *BLANK        @WCDS1          200          Customer Deln S CSD007
     C                   PARM      *BLANK        @WCDS2          200          Customer Deln S CSD007
     C                   PARM      *BLANK        @WCDS3          200                          253211
     C                   PARM      'N'           @WQUTP            1          Quit program on CSD007
     C                   PARM      'C'           @ACTN             1          Action Code     CSD007
      *                                                                                       CSD007
     C     @RTCD         IFNE      'DELETE'                                                   CSD007
     C                   MOVEL     'N'           OKCUST                                       CSD007
     C                   ADD       1             Ix                                           CSD007
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD007
     C*****              MOVEL     'USR0152'     MsgIdArr(Ix)                          CSD007 CSD023
     C*****WDS1001       IFEQ      'F'                                              BUG7233 MD052297
     C*****WDS2001       OREQ      'F'                                               253344 MD052297
     C*****CSD023        ANDEQ     'Y'                                                BUG7233 253344
     C*****CSD023        IFEQ      'Y'                                               253344 MD052297
     C**********         MOVEL     'USR9836'     MsgIdArr(Ix)                       BUG7233 MD052297
     C**********         ELSE                                                       BUG7233 MD052297
     C**********         MOVEL     'USR9834'     MsgIdArr(Ix)                        CSD023 MD052297
     C**********         ENDIF                                                      BUG7233 MD052297
     C**********         GOTO      EVALAC                                          MD019261 MD052297
     C**********         ENDIF                                                       253344 MD052297
      *                                                                                     MD052297
      ** GENERAL LEDGER CHECKS:                                                             MD052297
      ** Customer defined on ACCNT.                                                         MD052297
      ** CASE: WRK.Customer Deln Flag 201 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2001       IFEQ      'F'                                                      MD052297
     C     CSD023        IFEQ      'Y'                                                      MD052297
     C                   MOVEL     'USR9836'     MsgIdArr(Ix)                               MD052297
     C                   ELSE                                                               MD052297
     C                   MOVEL     '5049318'     MsgIdArr(Ix)                               MD052297
     C                   ENDIF                                                              MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer has a retail account closed today.                                        MD052297
      ** CASE: WRK.Customer Deln Flag 211 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2011       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049332'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** SECURITIES TRADING CHECKS:                                                         MD052297
      ** Customer defined on CDEPPD.                                                        MD052297
      ** CASE: WRK.Customer Deln Flag 213 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2013       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049319'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Depot customer has a live depot movement defined on DPTMVD.                        MD052297
      ** CASE: WRK.Customer Deln Flag 214 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2014       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049320'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer has a live depot movement defined on DPTMVD.                              MD052297
      ** CASE: WRK.Customer Deln Flag 215 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2015       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049321'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Depot customer has a reversed depot movement defined on                            MD052297
      ** DPTMVD.                                                                            MD052297
      ** CASE: WRK.Customer Deln Flag 216 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2016       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049322'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer has a reversed depot movement defined on DPTMVD.                          MD052297
      ** CASE: WRK.Customer Deln Flag 217 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2017       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049323'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer defined on SECTYD.                                                        MD052297
      ** CASE: WRK.Customer Deln Flag 225 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2025       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049324'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer has user positions defined on UDEPPD.                                     MD052297
      ** CASE: WRK.Customer Deln Flag 229 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2029       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049328'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** DEALING CHECKS:                                                                    MD052297
      ** Customer defined on CUSDL.                                                         MD052297
      ** CASE: WRK.Customer Deln Flag 202 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2002       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049329'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer defined on TRADSD.                                                        MD052297
      ** CASE: WRK.Customer Deln Flag 221 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2021       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049325'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Depot customer defined on TRADSD.                                                  MD052297
      ** CASE: WRK.Customer Deln Flag 222 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2022       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049326'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer has a position settlement on POSETD.                                      MD052297
      ** CASE: WRK.Customer Deln Flag 224 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2024       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049327'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD019261
      ** Customer has at least one live facility defined.                                   MD019261
      *                                                                                     MD019261
     C     WDS2004       IFEQ      'F'                                                      MD019261
     C                   MOVEL     '5045920'     MsgIdArr(Ix)                               MD019261
     C                   GOTO      EVALAC                                                   MD019261
     C                   ENDIF                                                              MD019261
      *                                                                                     MD019261
      ** Customer has at least one reversed facility.                                       MD019261
      *                                                                                     MD019261
     C     WDS2007       IFEQ      'F'                                                      MD019261
     C                   MOVEL     '5045921'     MsgIdArr(Ix)                               MD019261
     C                   GOTO      EVALAC                                                   MD019261
     C                   ENDIF                                                              MD019261
      *                                                                                     MD019261
      ** Customer has at least one closed facility.                                         MD019261
      *                                                                                     MD019261
     C     WDS2008       IFEQ      'F'                                                      MD019261
     C                   MOVEL     '5045922'     MsgIdArr(Ix)                               MD019261
     C                   GOTO      EVALAC                                                   MD019261
     C                   ENDIF                                                              MD019261
      *                                                                                     MD019261
      ** Customer has at least one expired facility.                                        MD019261
      *                                                                                     MD019261
     C     WDS2009       IFEQ      'F'                                                      MD019261
     C                   MOVEL     '5045923'     MsgIdArr(Ix)                               MD019261
     C                   GOTO      EVALAC                                                   MD019261
     C                   ENDIF                                                              MD019261
      *                                                                                     MD050457
      ** Customer has a facility closed today.                                              MD050457
      ** CASE: WRK.Customer Deln Flag 210 is Do not close                                   MD050457
      *                                                                                     MD050457
     C     WDS2010       IFEQ      'F'                                                      MD050457
     C                   MOVEL     '5049259'     MsgIdArr(Ix)                               MD050457
     C                   GOTO      EVALAC                                                   MD050457
     C                   ENDIF                                                              MD050457
      *                                                                                     MD050457
      ** Customer defined on GTEES.                                                         MD050457
      ** CASE: WRK.Customer Deln Flag 205 is Do not delete                                  MD050457
      ** Customer defined on LEREF.                                                         MD050457
      *                                                                                     MD050457
     C     WDS2005       IFEQ      'F'                                                      MD050457
     C**********         MOVEL     'USR1124'     MsgIdArr(Ix)                      MD050457 MD052297
     C                   MOVEL     '5049330'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD050457
     C                   ENDIF                                                              MD050457
      *                                                                                     MD050457
      ** Customer defined on LEREF.                                                         MD050457
      ** CASE: WRK.Customer Deln Flag 206 is Do not delete                                  MD050457
      *                                                                                     MD050457
     C     WDS2006       IFEQ      'F'                                                      MD050457
     C                   MOVEL     '5049260'     MsgIdArr(Ix)                               MD050457
     C                   GOTO      EVALAC                                                   MD050457
     C                   ENDIF                                                              MD050457
      *                                                                                     MD050457
      ** Customer defined on CLOANCL.                                                       MD050457
      ** CASE: WRK.Customer Deln Flag 230 is Do not delete                                  MD050457
      *                                                                                     MD050457
     C     WDS2030       IFEQ      'F'                                                      MD050457
     C                   MOVEL     '5049261'     MsgIdArr(Ix)                               MD050457
     C                   GOTO      EVALAC                                                   MD050457
     C                   ENDIF                                                              MD050457
      *                                                                                     MD052425
      ** Customer defined on CLOANCL.OLNO                                                   MD052425
      *                                                                                     MD052425
     C     WDS2031       IFEQ      'F'                                                      MD052425
     C                   MOVEL     '5049228'     MsgIdArr(Ix)                               MD052425
     C                   GOTO      EVALAC                                                   MD052425
     C                   ENDIF                                                              MD052425
      *                                                                                     MD050457
      ** Customer defined on LEFEEDL1                                                       MD050457
      ** CASE: WRK.Customer Deln Flag 240 is Do not delete                                  MD050457
      *                                                                                     MD050457
     C     WDS2041       IFEQ      'F'                                                      MD050457
     C                   MOVEL     '5049262'     MsgIdArr(Ix)                               MD050457
     C                   GOTO      EVALAC                                                   MD050457
     C                   ENDIF                                                              MD050457
      *                                                                                     MD052297
      ** EXPOSURE MANAGEMENT CHECKS:                                                        MD052297
      ** Customer defined on EMLIML2.                                                       MD052297
      ** CASE: WRK.Customer Deln Flag 212 is Do not close                                   MD052297
      *                                                                                     MD052297
     C     WDS2012       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049331'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                       246639
      ** Customer defined as a parent on SDCUSTPD.                                            246639
      ** CASE: WRK.Customer Deln Flag 006 is Do not delete                                    246639
      *                                                                                       246639
     C     WDS1006       IFEQ      'F'                                                        246639
     C                   MOVEL     'USR9472'     MsgIdArr(Ix)                                 246639
     C                   GOTO      EVALAC                                                     246639
     C                   ENDIF                                                                246639
     C                   ENDIF                                                                CSD007
     C                   ENDIF                                                                215524
      *                                                                                     MD052297
      ** Customer defined as an internal customer in SDBRCHPD                               MD052297
      ** CASE: If Customer Flag 045 is flagged, do not close.                               MD052297
      *                                                                                     MD052297
     C     WDS1045       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049333'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                     MD052297
      ** Customer defined as a Syndicated Agent in SDBRCHPD                                 MD052297
      ** CASE: If Customer Flag 044 is flagged, do not close.                               MD052297
      *                                                                                     MD052297
     C     WDS1044       IFEQ      'F'                                                      MD052297
     C                   MOVEL     '5049334'     MsgIdArr(Ix)                               MD052297
     C                   GOTO      EVALAC                                                   MD052297
     C                   ENDIF                                                              MD052297
      *                                                                                       CSD007
      ** Issue Warning when a 'T'axable Customer is Closed                                  BUG23518
      *                                                                                     BUG23518
     C                   IF        WUERCD <> 'Y'                                            BUG23518
      *                                                                                     BUG23518
     C                   IF        CER048 = 'Y' AND DDACTN = 'C'                            BUG23518
     C                   EXSR      SRChkSts                                                 BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C     EVALAC        ENDSR                                                                CSD007
      *****************************************************************                       CSD007
      * VALACR - VALIDATION OF ACTION CODE 'R'                                                CSD007
      *****************************************************************                       CSD007
     C     VALACR        BEGSR                                                                CSD007
      *                                                                                       CSD007
     C     BBDTDL        IFNE      0                                                          CSD007
     C     BBCLST        ORNE      'Y'                                                        CSD007
     C                   MOVEL     'N'           OKACTN                                       CSD007
     C                   ADD       1             Ix                                           CSD007
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CSD007
     C                   MOVEL     'USR0569'     MsgIdArr(Ix)                                 CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       246639
      ** Check if the customer is attached to a closed parent                                 246639
      *                                                                                       246639
     C     Ix            IFEQ      0                                                          246639
     C     BBPCNB        ANDNE     *BLANKS                                                    246639
     C     BBPCNB        CHAIN     SDCUSTLR                           44                      246639
     C     *IN44         IFEQ      '0'                                                        246639
     C     BBCLST        ANDEQ     'Y'                                                        246639
     C                   MOVEL     'N'           OKCUST                                       246639
     C                   ADD       1             Ix                                           246639
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               246639
     C                   MOVEL     'USR9474'     MsgIdArr(Ix)                                 246639
     C                   ENDIF                                                                246639
     C                   ENDIF                                                                246639
      ** If parent customer defined and found, re access SDCUSTLR using the                 MD048748
      ** customer number to ensure it is these customer details returned to                 MD048748
      ** SDCUSDUPD                                                                          MD048748
     C     *IN44         IFEQ      '0'                                                      MD048748
     C     DDCUSN        CHAIN     SDCUSTLR                           44                    MD048748
     C                   ENDIF                                                              MD048748
      *                                                                                       CSD007
     C                   ENDSR                                                                CSD007
      *****************************************************************                       CSD031
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      *  SRGetACst - Gets customer acceptance details.                *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
     C*****SRGetACst     BEGSR                                                       CSD031 BUG13525
                                                                                              CSD031
     C*****DDCUSN        CHAIN     SDCUSTLR                                          CSD031 BUG13525
                                                                                              CSD031
     C**********         EVAL      WCustLR = 'N'                                     CSD031 BUG13525
     C**********         EVAL      WTyLC = *BLANK                                    CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        %FOUND(SDCUSTLR)                                  CSD031 BUG13525
     C**********         EVAL      WCustLR = 'Y'                                     CSD031 BUG13525
     C**********         EVAL      WTyLC = BBTYLC                                    CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C*****DDCUSN        CHAIN     SDACSTL1                                          CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        %FOUND(SDACSTL1)                                  CSD031 BUG13525
                                                                                              CSD031
      ** Don't update master files if delete was taken from the acceptance subfile.           CSD031
                                                                                              CSD031
     C**********         IF        DDACTN = 'D'                                      CSD031 BUG13525
     C**********         EVAL      PUpdYN = 'N'                                      CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        DDACTN = 'X'                                      CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        WCustLR = 'Y'                                     CSD031 BUG13525
                                                                                              CSD031
     C**********         SELECT                                                      CSD031 BUG13525
                                                                                              CSD031
     C**********         WHEN      BBTYLC = 'I'                                      CSD031 BUG13525
     C**********         EVAL      DDACTN = 'A'                                      CSD031 BUG13525
     C**********         EVAL      BBTYLC = 'A'                                      CSD031 BUG13525
                                                                                              CSD031
     C**********         WHEN      BBTYLC = 'D'                                      CSD031 BUG13525
     C**********         EVAL      DDACTN = 'D'                                      CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        WTyLC = 'D'                                       CSD031 BUG13525
     C**********         EVAL      PUpdYN = 'N'                                      CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         OTHER                                                       CSD031 BUG13525
     C**********         EVAL      DDACTN = BBTYLC                                   CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDSL                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ELSE                                                        CSD031 BUG13525
                                                                                              CSD031
     C**********         SELECT                                                      CSD031 BUG13525
                                                                                              CSD031
     C**********         WHEN      BBTYLC = 'A'                                      CSD031 BUG13525
     C**********         EVAL      DDACTN = 'I'                                      CSD031 BUG13525
     C**********         EVAL      BBTYLC = 'I'                                      CSD031 BUG13525
                                                                                              CSD031
      ** Don't update master files if delete was accepted for a non-existing record.          CSD031
                                                                                              CSD031
     C**********         WHEN      BBTYLC = 'D'                                      CSD031 BUG13525
     C**********         EVAL      DDACTN = 'D'                                      CSD031 BUG13525
     C**********         EVAL      PUpdYN = 'N'                                      CSD031 BUG13525
                                                                                              CSD031
     C**********         OTHER                                                       CSD031 BUG13525
     C**********         EVAL      DDACTN = BBTYLC                                   CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDSL                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         MOVE      CustFilFmt    SDACST                              CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDSR                                                       CSD031 BUG13525
      *****************************************************************                       CSD031
      /EJECT                                                                                  CSD031
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      *  SROvrFlds - Overrides customer details with acceptance       *                       CSD031
      *              details.                                         *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
     C*****SROvrFlds     BEGSR                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        DDACTN = 'I' OR                                   CSD031 BUG13525
     C**********                   DDACTN = 'D' OR                                   CSD031 BUG13525
     C**********                   DDACTN = 'E'                                      CSD031 BUG13525
     C**********         MOVE      SDACST        CustFilFmt                          CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        DDACTN = 'A'                                      CSD031 BUG13525
     C**********         EVAL      BBCSSN = B_BBCSSN                                 CSD031 BUG13525
     C**********         EVAL      BBCNA1 = B_BBCNA1                                 CSD031 BUG13525
     C**********         EVAL      BBCNA2 = B_BBCNA2                                 CSD031 BUG13525
     C**********         EVAL      BBCNA3 = B_BBCNA3                                 CSD031 BUG13525
     C**********         EVAL      BBCNA4 = B_BBCNA4                                 CSD031 BUG13525
     C**********         EVAL      BBCRTN = B_BBCRTN                                 CSD031 BUG13525
     C**********         EVAL      BBCRNM = B_BBCRNM                                 CSD031 BUG13525
     C**********         EVAL      BBACOC = B_BBACOC                                 CSD031 BUG13525
     C**********         EVAL      BBCGRP = B_BBCGRP                                 CSD031 BUG13525
     C**********         EVAL      BBBRCD = B_BBBRCD                                 CSD031 BUG13525
     C**********         EVAL      BBCNCZ = B_BBCNCZ                                 CSD031 BUG13525
     C**********         EVAL      BBCOLC = B_BBCOLC                                 CSD031 BUG13525
     C**********         EVAL      BBPCNB = B_BBPCNB                                 CSD031 BUG13525
     C**********         EVAL      BBLCCD = B_BBLCCD                                 CSD031 BUG13525
     C**********         EVAL      BBDINC = B_BBDINC                                 CSD031 BUG13525
     C**********         EVAL      BBDTDL = B_BBDTDL                                 CSD031 BUG13525
     C**********         EVAL      BBCLST = B_BBCLST                                 CSD031 BUG13525
     C**********         EVAL      BBCLDT = B_BBCLDT                                 CSD031 BUG13525
     C**********         EVAL      BBTMST = B_BBTMST                                 CSD031 BUG13525
     C**********         EVAL      BBAACC = B_BBAACC                                 CSD031 BUG13525
     C**********         EVAL      BBEACC = B_BBEACC                                 CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDSR                                                       CSD031 BUG13525
      *****************************************************************                       CFT050
      ** Pop_SW13 - Set SWIFTRef Bank Direcotry Plus screen fields                            CFT050
      *****************************************************************                       CFT050
     C     Pop_SW13      BEGSR                                                                CFT050
      *                                                                                       CFT050
     C                   IF        CSW213   = 'Y'                                           MD022463
     C                   EVAL      SvDDLEIC = DDLEIC                                          CFT050
     C                   EVAL      SvDDCLSY = DDCLSY                                          CFT050
     C                   EVAL      SvDDCLID = DDCLID                                          CFT050
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022766
     C                   IF        CFT050   = 'Y'                                           MD022766
     C                   EVAL      SvDDBDRK = DDBDRK                                          CFT050
     C                   ENDIF                                                              MD022766
                                                                                              CFT050
     C                   CLEAR                   CuSW13                                       CFT050
     C                   CLEAR                   MEBIB3D0                                     CFT050
     C                   CLEAR                   MEIBN3D0                                     CFT050
                                                                                              CFT050
     C                   IF        CSW213   = 'Y'                                           MD022463
     C                   EVAL      DDLEIC = SvDDLEIC                                          CFT050
     C                   EVAL      DDCLSY = SvDDCLSY                                          CFT050
     C                   EVAL      DDCLID = SvDDCLID                                          CFT050
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022766
     C                   IF        CFT050   = 'Y'                                           MD022766
     C                   EVAL      DDBDRK = SvDDBDRK                                          CFT050
                                                                                              CFT050
     C     DDBDRK        CHAIN     MEBIB3L0                                                   CFT050
     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
     C                   EVAL      DDFLAG = B3FLAG                                            CFT050
     C                   EVAL      DDOFTP = B3OFTP                                            CFT050
     C                   EVAL      DDPOKY = B3POKY                                            CFT050
     C                   EVAL      DDHOKY = B3HOKY                                            CFT050
     C                   EVAL      DDLGTP = B3LGTP                                            CFT050
     C                   EVAL      DDLGPK = B3LGPK                                            CFT050
     C                   EVAL      DDGRTP = B3GRTP                                            CFT050
     C                   EVAL      DDGPKY = B3GPKY                                            CFT050
     C                   EVAL      DDISST = B3ISST                                            CFT050
     C                   EVAL      DDCGKY = B3CGKY                                            CFT050
     C                   EVAL      DDILEI = B3LEIC                                            CFT050
     C                   EVAL      DDBICC = B3BICC                                            CFT050
     C                   EVAL      S13DDBRCD = B3BRCD                                         CFT050
     C                   EVAL      DDBICC = B3UBIC                                            CFT050
     C                   EVAL      DDCHIP = B3CHIP                                            CFT050
     C                   EVAL      DDNATI = B3NATI                                            CFT050
     C                   EVAL      DDCBIC = B3CBIC                                            CFT050
     C                   EVAL      DDINS1 = B3INS1                                            CFT050
     C                   EVAL      DDINS2 = B3INS2                                            CFT050
     C                   EVAL      DDINS3 = B3INS3                                            CFT050
     C                   EVAL      DDBIN1 = B3BIN1                                            CFT050
     C                   EVAL      DDBIN2 = B3BIN2                                            CFT050
     C                   EVAL      DDPOBN = B3POBN                                            CFT050
     C                   EVAL      DDADD1 = B3ADD1                                            CFT050
     C                   EVAL      DDADD2 = B3ADD2                                            CFT050
     C                   EVAL      DDADD3 = B3ADD3                                            CFT050
     C                   EVAL      DDADD4 = B3ADD4                                            CFT050
     C                   EVAL      DDCITY = B3CITY                                            CFT050
     C                   EVAL      DDCPS1 = B3CPS1                                            CFT050
     C                   EVAL      DDCPS2 = B3CPS2                                            CFT050
     C                   EVAL      DDCPS3 = B3CPS3                                            CFT050
     C                   EVAL      DDZIP  = B3ZIP                                             CFT050
     C                   EVAL      DDCNT1 = B3CNT1                                            CFT050
     C                   EVAL      DDCNT2 = B3CNT2                                            CFT050
     C                   EVAL      DDISOC = B3ISOC                                            CFT050
     C                   EVAL      DDTMZN = B3TMZN                                            CFT050
     C                   EVAL      DDSTYP = B3STYP                                            CFT050
     C                   EVAL      DDNWCY = B3NWCY                                            CFT050
     C                   EVAL      DDBRQA = B3BRQA                                            CFT050
     C                   EVAL      DDSER1 = B3SER1                                            CFT050
     C                   EVAL      DDSER2 = B3SER2                                            CFT050
     C                   EVAL      DDSSIC = B3SSIC                                            CFT050
     C                   EVAL      DDIBNK = B3IBNK                                            CFT050
     C                   EVAL      DDFILA = B3FILA                                            CFT050
     C                   EVAL      DDFLB1 = B3FLB1                                            CFT050
     C                   EVAL      DDFLB2 = B3FLB2                                            CFT050
                                                                                              CFT050
     C     B3IBNK        CHAIN     MEIBN3L0                                                   CFT050
     C                   IF        %FOUND(MEIBN3L0)                                           CFT050
     C                   EVAL      DDIBNC = N3IBNC                                            CFT050
     C                   EVAL      DDIBIC = N3IBIC                                            CFT050
     C                   EVAL      DDRBIC = N3RBIC                                            CFT050
     C                   EVAL      DDINAT = N3INAT                                            CFT050
     C                   EVAL      DDSCTX = N3SCTX                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   IF        DDACTN = 'I'                                               CFT050
     C**********                   AND SVDDBDRK2 <> DDBDRK                           CFT050 MD022463
                                                                                              CFT050
     C                   EVAL      PCusn = DDCUSN                                             CFT050
      *                                                                                       CFT050
      ** Get parent key from customer file                                                    CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOCUSTR0'                                                 CFT050
     C                   PARM      *Blanks       P@Rtcd                                       CFT050
     C                   PARM      '*KEY'        P@Optn                                       CFT050
     C                   PARM                    PCusn                                        CFT050
     C                   PARM                    PKySt                                        CFT050
     C     SDCUST        PARM      SDCUST        DSSDY                                        CFT050
     C                   IF        P@Rtcd =  *BLANKS                                          CFT050
     C                   IF        DDDPCNB = *BLANKS                                          CFT050
     C                   EVAL      DDDPCNB = BBPCNB                                           CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
      **                                                                                      CFT050
     C                   IF        DDDBNBI = *BLANKS                                          CFT050
     C                             OR DDDBNBI = 'N'                                         MD022408
     C                   IF        B3ISST = 'BANK'                                            CFT050
     C                             OR B3ISST = 'COOP'                                         CFT050
     C                             OR B3ISST = 'CBMA'                                         CFT050
     C                   EVAL      DDDBNBI = 'Y'                                              CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCNA1 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA1 = B3INS1                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCRNM = *BLANKS                                          CFT050
     C                   EVAL      DDDCRNM = B3INS1                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCNA2 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA2 = B3ADD1                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCNA3 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA3 = B3ADD2                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCRTN = *BLANKS                                          CFT050
     C                   EVAL      DDDCRTN = B3CITY                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDDCNA1 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA1 = B3CPS1                                           CFT050
     C                   WHEN      DDDCNA2 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA2 = B3CPS1                                           CFT050
     C                   WHEN      DDDCNA3 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA3 = B3CPS1                                           CFT050
     C                   WHEN      DDDCNA4 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA4 = B3CPS1                                           CFT050
     C                   ENDSL                                                                CFT050
      **                                                                                      CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDDCNA1 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA1 = B3CNT1                                           CFT050
     C                   WHEN      DDDCNA2 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA2 = B3CNT1                                           CFT050
     C                   WHEN      DDDCNA3 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA3 = B3CNT1                                           CFT050
     C                   WHEN      DDDCNA4 = *BLANKS                                          CFT050
     C                   EVAL      DDDCNA4 = B3CNT1                                           CFT050
     C                   ENDSL                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCNCZ = *BLANKS                                          CFT050
     C                   EVAL      DDDCNCZ = B3ISOC                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDDCNCZ = *BLANKS                                          CFT050
     C                   EVAL      DDDCOLC = B3ISOC                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   EVAL      SVCNCZ = *BLANKS                                           CFT050
     C                   EVAL      SVCOLC = *BLANKS                                           CFT050
     C     B3ISOC        SETLL     SDCTRYL3                                                   CFT050
     C                   IF        %EQUAL                                                     CFT050
     C     B3ISOC        CHAIN     SDCTRYL3                                                   CFT050
     C                   DOW       %FOUND(SDCTRYL3)                                           CFT050
     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
     C                   IF        B3ISOC = A4CNCD                                            CFT050
     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
     C                   LEAVE                                                                CFT050
     C                   ENDIF                                                                CFT050
     C     B3ISOC        READE     SDCTRYL3                                                   CFT050
      ** SDCTRYL3 dow                                                                         CFT050
     C                   ENDDO                                                                CFT050
      **                                                                                      CFT050
     C                   IF        SVCNCZ <> *BLANKS                                          CFT050
     C                             AND DDDCNCZ = *BLANK                                       CFT050
     C                   EVAL      DDDCNCZ = SVCNCZ                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        SVCOLC <> *BLANKS                                          CFT050
     C                             AND DDDCOLC = *BLANK                                       CFT050
     C                   EVAL      DDDCOLC = SVCOLC                                           CFT050
     C                   ENDIF                                                                CFT050
      ** SDCTRYL3 equal                                                                       CFT050
     C                   ENDIF                                                                CFT050
     C**********         ENDIF                                                       CFT050 MD023955
                                                                                              CFT050
      ** 3rd screen                                                                           CFT050
     C                   IF        DDCSID = *BLANKS                                           CFT050
     C                   EVAL      DDCSID = B3UBIC                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCIDA = *BLANKS                                           CFT050
     C                   EVAL      DDCIDA = B3CHIP                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'US'                                              CFT050
     C                   IF        DDFWCA = *BLANKS                                           CFT050
     C                   EVAL      DDFWCA = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'DE'                                              CFT050
     C**********         IF        DDFWCA = *BLANKS                                  CFT050 MD022520
     C**********         EVAL      DDFWCA = B3NATI                                   CFT050 MD022520
     C                   IF        DDBLCD = *BLANKS                                         MD022520
     C                   EVAL      DDBLCD = B3NATI                                          MD022520
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'JP'                                              CFT050
     C                   IF        DDBFIC = *BLANKS                                           CFT050
     C                   EVAL      DDBFIC = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'GB'                                              CFT050
     C                   IF        DDCSCA = *BLANKS                                           CFT050
     C                   EVAL      DDCSCA = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   EVAL      SVCLSY = *BLANKS                                         MD022587
     C                   IF        CSW213 = 'Y'                                               CSW213
      *                                                                                       CSW213
     C                   IF        DDCLID = *BLANKS                                           CSW213
      ** Do not defaul if equal to the following ISO codes                                  MD023115
     C                             AND B3ISOC <> 'US'                                       MD023115
     C                             AND B3ISOC <> 'DE'                                       MD023115
     C                             AND B3ISOC <> 'JP'                                       MD023115
     C                             AND B3ISOC <> 'GB'                                       MD023115
     C                   EVAL      DDCLID = B3NATI                                            CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   IF        DDCLSY = *BLANKS                                           CSW213
     C**********         EVAL      DDCLSY = B3ISOC                                   CSW213 MD022587
     C                   EVAL      SVCLSY = B3ISOC                                          MD022587
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C**********         EVAL      SVCLSY = *BLANKS                                  CSW213 MD022587
     C                   SELECT                                                               CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'AT'                                              CSW213
     C                   EVAL      SVCLSY = 'AT'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'AU'                                              CSW213
     C                   EVAL      SVCLSY = 'AU'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'CA'                                              CSW213
     C                   EVAL      SVCLSY = 'CC'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'ES'                                              CSW213
     C                   EVAL      SVCLSY = 'ES'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'GR'                                              CSW213
     C                   EVAL      SVCLSY = 'GR'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'HK'                                              CSW213
     C                   EVAL      SVCLSY = 'HK'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'IE'                                              CSW213
     C                   EVAL      SVCLSY = 'IE'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'IN'                                              CSW213
     C                   EVAL      SVCLSY = 'IN'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'IT'                                              CSW213
     C                   EVAL      SVCLSY = 'IT'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'NZ'                                              CSW213
     C                   EVAL      SVCLSY = 'NZ'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'PL'                                              CSW213
     C                   EVAL      SVCLSY = 'PL'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'PT'                                              CSW213
     C                   EVAL      SVCLSY = 'PT'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'RU'                                              CSW213
     C                   EVAL      SVCLSY = 'RU'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'CH'                                              CSW213
     C                   EVAL      SVCLSY = 'SW'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'SW'                                              CSW213
     C                   EVAL      SVCLSY = 'SW'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'ZA'                                              CSW213
     C                   EVAL      SVCLSY = 'ZA'                                              CSW213
      *                                                                                       CSW213
     C                   OTHER                                                                CSW213
     C**********         EVAL      DDCLID = *BLANKS                                  CSW213 MD022557
     C**********         EVAL      DDCLSY = *BLANKS                                  CSW213 MD022557
      *                                                                                       CSW213
     C                   ENDSL                                                                CSW213
      *                                                                                       CSW213
     C                   IF        SVCLSY <> *BLANKS                                          CSW213
     C                             AND DDCLSY = *BLANKS                                       CSW213
      ** Do not defaul if equal to the following ISO codes                                  MD023115
     C                             AND B3ISOC <> 'US'                                       MD023115
     C                             AND B3ISOC <> 'DE'                                       MD023115
     C                             AND B3ISOC <> 'JP'                                       MD023115
     C                             AND B3ISOC <> 'GB'                                       MD023115
     C                   EVAL      DDCLSY = SVCLSY                                            CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   IF        DDLEIC = *BLANKS                                           CSW213
     C                   EVAL      DDLEIC = B3LEIC                                            CSW213
     C                   ENDIF                                                                CSW213
      ** CSW213                                                                               CSW213
     C                   ENDIF                                                                CSW213
      **                                                                                      CFT050
     C                   IF        B3CBIC <> *BLANKS                                          CFT050
     C                   IF        DDCSID =  *BLANKS                                        MD022463
     C                   EVAL      DDCSID =  B3CBIC                                           CFT050
     C                   ENDIF                                                              MD022463
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   CALLB     'AOBEISR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      B3STYP        PBICD                                        CFT050
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CFT050
     C                   IF        @RTCD <> *BLANKS                                           CFT050
     C                   IF        DDSWFI = *BLANKS                                           CFT050
     C                   EVAL      DDSWFI = 'Y'                                               CFT050
     C                   ENDIF                                                                CFT050
     C                   ELSE                                                                 CFT050
     C                   IF        DDSWFI = *BLANKS                                           CFT050
     C                   EVAL      DDSWFI = 'N'                                               CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C**********         IF        CSW204 = 'Y'                                      CFT050 MD022463
     C                   IF        CSW024 = 'Y'                                             MD022463
     C                             AND B3STYP = 'CORP'                                        CFT050
     C**********         IF        DDCRPC = *BLANKS                                  CFT050 MD022463
     C**********         EVAL      DDCRPC = 'Y'                                      CFT050 MD022463
     C                   IF        DDCORP = *BLANKS                                         MD022463
     C                             OR DDCORP = 'N'                                          MD022463
     C                   EVAL      DDCORP = 'Y'                                             MD022463
     C                   ENDIF                                                                CFT050
      ***CSW204*                                                                     CFT050 MD022463
     C**********         ENDIF                                                       CFT050 MD022463
      ** 8th screen                                                                           CFT050
     C                   IF        B3BICC <>*BLANKS                                         MD022463
                                                                                            MD022463
     C                   IF        DDCBEI = *BLANKS                                           CFT050
     C**********         EVAL      DDCBEI = B3BICC                                  CFT050 MD022557A
     C                   EVAL      DDCBEI = B3UBIC                                         MD022557A
     C                   ENDIF                                                                CFT050
                                                                                            MD022463
     C                   ELSE                                                               MD022463
      **                                                                                      CFT050
     C                   IF        DDRI01 = *BLANKS                                           CFT050
     C                   IF        B3BICC <> *BLANKS                                          CFT050
     C                   EVAL      DDRI01 = '/ABIC/' + B3BICC                                 CFT050
     C                   ELSE                                                                 CFT050
     C**********         EVAL      DDRI01 = '/ABIC/UKNW'                             CFT050 MD022861
     C                   EVAL      DDRI01 = '/ABIC/UKWN'                                    MD022861
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDRI02 = *BLANKS                                           CFT050
     C                   EVAL      DDRI02 = '/NAME/' + B3INS1                                 CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        CSW213 = 'Y'                                               CFT050
     C                             AND B3LEIC <> *BLANKS                                      CFT050
     C                   IF        DDRI03 = *BLANKS                                           CFT050
     C                   EVAL      DDRI03 = '/LEIC/' + B3LEIC                                 CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      ** B3BICC                                                                             MD022463
     C                   ENDIF                                                              MD022463
      ** CSW024                                                                             MD022463
     C                   ENDIF                                                              MD022463
                                                                                              CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                              MD022766
     C                   ENDIF                                                              MD023955
     C**********         EVAL      SVDDBDRK2 = DDBDRK                                CFT050 MD022463
                                                                                              CFT050
     C                   ENDSR                                                                CFT050
      *****************************************************************                     MD022463
      ** Pop_SW13Scrn - Set SWIFTRef Bank Directory Plus screen fields                      MD022463
      *****************************************************************                     MD022463
     C     Pop_SW13Scrn  BEGSR                                                              MD022463
      *                                                                                     MD022463
     C                   IF        DDACTN = 'E'                                             MD022463
     C                   IF        CSW213 = 'Y'                                             MD022463
     C                   EVAL      DDLEIC = CSLEIC                                          MD022463
     C                   EVAL      DDCLSY = CSCLSY                                          MD022463
     C                   EVAL      DDCLID = CSCLID                                          MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022766
     C                   IF        CFT050 = 'Y'                                             MD022766
     C                   EVAL      DDBDRK = CSBDRK                                          MD022463
     C                   ENDIF                                                              MD022766
      *                                                                                     MD022766
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022463
     C                   IF        CSW213 = 'Y'                                             MD022463
     C                   EVAL      SvDDLEIC = DDLEIC                                        MD022463
     C                   EVAL      SvDDCLSY = DDCLSY                                        MD022463
     C                   EVAL      SvDDCLID = DDCLID                                        MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022766
     C                   IF        CFT050 = 'Y'                                             MD022766
     C                   EVAL      SvDDBDRK = DDBDRK                                        MD022463
     C                   ENDIF                                                              MD022766
                                                                                            MD022463
     C                   CLEAR                   CuSW13                                     MD022463
     C                   CLEAR                   MEBIB3D0                                   MD022463
     C                   CLEAR                   MEIBN3D0                                   MD022463
                                                                                            MD022463
     C                   IF        CSW213 = 'Y'                                             MD022463
     C                   EVAL      DDLEIC = SvDDLEIC                                        MD022463
     C                   EVAL      DDCLSY = SvDDCLSY                                        MD022463
     C                   EVAL      DDCLID = SvDDCLID                                        MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022766
     C                   IF        CFT050 = 'Y'                                             MD022766
     C                   EVAL      DDBDRK = SvDDBDRK                                        MD022463
                                                                                            MD022463
     C     DDBDRK        CHAIN     MEBIB3L0                                                 MD022463
     C                   IF        %FOUND(MEBIB3L0)                                         MD022463
     C                   EVAL      DDFLAG = B3FLAG                                          MD022463
     C                   EVAL      DDOFTP = B3OFTP                                          MD022463
     C                   EVAL      DDPOKY = B3POKY                                          MD022463
     C                   EVAL      DDHOKY = B3HOKY                                          MD022463
     C                   EVAL      DDLGTP = B3LGTP                                          MD022463
     C                   EVAL      DDLGPK = B3LGPK                                          MD022463
     C                   EVAL      DDGRTP = B3GRTP                                          MD022463
     C                   EVAL      DDGPKY = B3GPKY                                          MD022463
     C                   EVAL      DDISST = B3ISST                                          MD022463
     C                   EVAL      DDCGKY = B3CGKY                                          MD022463
     C                   EVAL      DDILEI = B3LEIC                                          MD022463
     C                   EVAL      DDBICC = B3BICC                                          MD022463
     C                   EVAL      S13DDBRCD = B3BRCD                                       MD022463
     C                   EVAL      DDBICC = B3UBIC                                          MD022463
     C                   EVAL      DDCHIP = B3CHIP                                          MD022463
     C                   EVAL      DDNATI = B3NATI                                          MD022463
     C                   EVAL      DDCBIC = B3CBIC                                          MD022463
     C                   EVAL      DDINS1 = B3INS1                                          MD022463
     C                   EVAL      DDINS2 = B3INS2                                          MD022463
     C                   EVAL      DDINS3 = B3INS3                                          MD022463
     C                   EVAL      DDBIN1 = B3BIN1                                          MD022463
     C                   EVAL      DDBIN2 = B3BIN2                                          MD022463
     C                   EVAL      DDPOBN = B3POBN                                          MD022463
     C                   EVAL      DDADD1 = B3ADD1                                          MD022463
     C                   EVAL      DDADD2 = B3ADD2                                          MD022463
     C                   EVAL      DDADD3 = B3ADD3                                          MD022463
     C                   EVAL      DDADD4 = B3ADD4                                          MD022463
     C                   EVAL      DDCITY = B3CITY                                          MD022463
     C                   EVAL      DDCPS1 = B3CPS1                                          MD022463
     C                   EVAL      DDCPS2 = B3CPS2                                          MD022463
     C                   EVAL      DDCPS3 = B3CPS3                                          MD022463
     C                   EVAL      DDZIP  = B3ZIP                                           MD022463
     C                   EVAL      DDCNT1 = B3CNT1                                          MD022463
     C                   EVAL      DDCNT2 = B3CNT2                                          MD022463
     C                   EVAL      DDISOC = B3ISOC                                          MD022463
     C                   EVAL      DDTMZN = B3TMZN                                          MD022463
     C                   EVAL      DDSTYP = B3STYP                                          MD022463
     C                   EVAL      DDNWCY = B3NWCY                                          MD022463
     C                   EVAL      DDBRQA = B3BRQA                                          MD022463
     C                   EVAL      DDSER1 = B3SER1                                          MD022463
     C                   EVAL      DDSER2 = B3SER2                                          MD022463
     C                   EVAL      DDSSIC = B3SSIC                                          MD022463
     C                   EVAL      DDIBNK = B3IBNK                                          MD022463
     C                   EVAL      DDFILA = B3FILA                                          MD022463
     C                   EVAL      DDFLB1 = B3FLB1                                          MD022463
     C                   EVAL      DDFLB2 = B3FLB2                                          MD022463
                                                                                            MD022463
     C     B3IBNK        CHAIN     MEIBN3L0                                                 MD022463
     C                   IF        %FOUND(MEIBN3L0)                                         MD022463
     C                   EVAL      DDIBNC = N3IBNC                                          MD022463
     C                   EVAL      DDIBIC = N3IBIC                                          MD022463
     C                   EVAL      DDRBIC = N3RBIC                                          MD022463
     C                   EVAL      DDINAT = N3INAT                                          MD022463
     C                   EVAL      DDSCTX = N3SCTX                                          MD022463
     C                   ENDIF                                                              MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022766
     C                   ENDIF                                                              MD022766
                                                                                            MD022463
                                                                                            MD022463
     C                   ENDSR                                                              MD022463
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   CustFilFmt
     C                   CLEAR                   CuBrFilFmt
     C                   CLEAR                   CuPbFilFmt
     C                   CLEAR                   CuTIFilFmt                                  BUG3362
     C                   CLEAR                   CuFaFilFmt                                   CGL132
     C                   CLEAR                   CuXCFilFmt                                   CGL132
     C                   CLEAR                   CrsdFilFmt                                   CGL157
     C                   CLEAR                   PCrsdF                                       CGL157
     C                   CLEAR                   CumiFilFmt                                   CSD079
     C                   CLEAR                   CuadFilFmt                                   CSD079
     C                   CLEAR                   SfeeFilFmt                                   CSD079
     C                   CLEAR                   ChecFilFmt                                   CSD079
     C                   CLEAR                   CusfFilFmt                                   CSD079
     C                   CLEAR                   RwanFilFmt                                   CSD079
     C                   CLEAR                   CufoFilFmt                                   CSD079
     C                   CLEAR                   CufnFilFmt                                   CSD079
     C                   CLEAR                   CupmFilFmt                                   CSD079
     C                   CLEAR                   CueuFilFmt                                   CSD079
     C                   CLEAR                   CuibfFilFmt                                  CSD079
     C                   CLEAR                   CtnmFilFmt                                AR1086546
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKCUST
     C**********         MOVEL     'Y'           PUpdYN                              CSD031 BUG13525
      *
     C                   MOVEL     *BLANK        WUDELS            7
     C                   MOVEL     *BLANK        WDS1000
     C                   MOVEL     *BLANK        WDS2000
     C                   MOVEL     *BLANK        WDS3000
     C                   MOVEL     *BLANK        WDS4000
     C                   MOVEL     *BLANK        WDS5000
      *
     C/COPY WNCPYSRC,SDCUSDIC03
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCUMI - RETRIEVE Customer Marketing Information            *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCUMI       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Marketing Information                                                CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDCMRKLR                           45                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN45         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'USR1479'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Delete, Amend or Enquire                                                          CSD079
                                                                                              CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Live Record Not Found - Error                                                     CSD079
                                                                                              CSD079
     C     *IN45         IFEQ      *ON                                                        CSD079
     C     DDACTN        IFNE      'E'                                                      AR725233
     C     BBDTDL        OREQ      *ZERO                                                    AR725233
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'USR1478'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                              AR725233
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCUAD - RETRIEVE Customer Additional Details               *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCUAD       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Additional Details                                                   CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDACUSLR                           46                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN46         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'USR1915'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Delete, Amend or Enquire                                                          CSD079
                                                                                              CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Live Record not Found - Error                                                     CSD079
                                                                                              CSD079
     C     *IN46         IFEQ      *ON                                                        CSD079
     C     DDACTN        IFNE      'E'                                                      AR725233
     C     BBDTDL        OREQ      *ZERO                                                    AR725233
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'USR1914'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                              AR725233
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVSFEE - RETRIEVE Customer Service Fees Details             *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVSFEE       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Service Fees Details                                                 CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDCFCDLR                           47                      CSD079
                                                                                              CSD079
      **  If Insert Record Found - Error                                                      CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN47         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'USR1919'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
     C**********         ELSE                                                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C******IN47         IFEQ      '1'                                                CRE026 BG12238
     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
     C**********         ADD       1             Ix                                   CRE026 BG12238
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
     C**********         MOVEL     'USR1918'     MsgIdArr(Ix)                         CRE026 BG12238
     C**********         ENDIF                                                        CRE026 BG12238
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCHEC - RETRIEVE Cheque and Card Details                   *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCHEC       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Cheque and Card Details                                                       CSD079
                                                                                              CSD079
     C                   MOVEL     DDCUSN        SCCUST                                       CSD079
     C     SCCUST        CHAIN     SDCHEQLR                           48                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN48         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'MX00517'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Delete, Amend or Enquire                                                          CSD079
                                                                                              CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Live Record Not Found - Error                                                     CSD079
                                                                                              CSD079
     C     *IN48         IFEQ      *ON                                                        CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'SD99908'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCUSF - RETRIEVE Safe Details                              *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCUSF       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Safe Details                                                         CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDSAFEL1                           49                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN49         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'MX00517'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Delete, Amend or Enquire                                                          CSD079
                                                                                              CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Live Record Not Found - Error                                                     CSD079
                                                                                              CSD079
     C     *IN49         IFEQ      *ON                                                        CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'SD99908'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * RTVRWAN - RETRIEVE Risk Weighted Assets Details               *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVRWAN       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Risk Weighted Assets Details                                         CSD079
                                                                                              CSD079
     C                   CALLB     'SDRWANRTV'                                                CSD079
                                                                                              CSD079
      ** Inputs                                                                               CSD079
      ** Return code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    RetCodeIn                                    CSD079
                                                                                              CSD079
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                 CSD079
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                             CSD079
                                                                                              CSD079
     C                   PARM                    ModeofOp                                     CSD079
                                                                                              CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM                    RespMode                                     CSD079
                                                                                              CSD079
      ** Action Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    DDACTN                                       CSD079
                                                                                              CSD079
      ** (Midas) Customer Number                                                              CSD079
                                                                                              CSD079
     C                   PARM                    DDCUSN                                       CSD079
                                                                                              CSD079
      ** From Customer Flag                                                                   CSD079
                                                                                              CSD079
     C                   PARM      'Y'           From_Cust         1                          CSD079
                                                                                              CSD079
      ** Outputs                                                                              CSD079
      ** Transaction Details in File Format                                                   CSD079
                                                                                              CSD079
     C                   PARM                    RwanFilFmt                                   CSD079
                                                                                              CSD079
      ** OK - Action code                                                                     CSD079
                                                                                              CSD079
     C                   PARM                    OKACTN                                       CSD079
                                                                                              CSD079
      ** OK - Customer Number                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    OKCUST                                       CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Ix                                           CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      *  RtvCUAH - Retrieve Customer Authority Holder Details         *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     RtvCUAH       BEGSR                                                                CER059
                                                                                              CER059
     C                   EVAL      Idy = 1                                                    CER059
     C     DDCUSN        SETLL     SDCUAHLA                                                   CER059
     C                   READ      SDCUAHLA                                                   CER059
     C                   DOW       NOT %EOF(SDCUAHLA)                                         CER059
     C                             AND DDCUSN = CACUST                                        CER059
     C                   IF        CATYLC <> 'D'                                            MD053634
     C                   EVAL      AHAUTH  = CAAUTH                                           CER059
     C                   EVAL      AHLTYP  = CALTYP                                           CER059
     C                   EVAL      AHPRG1  = CAPRG1                                           CER059
     C                   EVAL      AHPRG2  = CAPRG2                                           CER059
     C                   EVAL      AHPRG3  = CAPRG3                                           CER059
     C                   EVAL      AHPRG4  = CAPRG4                                           CER059
     C                   EVAL      AHTYPA  = CATYPA                                           CER059
     C                   EVAL      AHCINT  = CACINT                                         MD026780
     C                   EVAL      AHPCNT  = CAPCNT                                         MD026780
     C                   EVAL      CUAHArr(Idy) = TranInCUAH1                                 CER059
     C                   EVAL      Idy =Idy + 1                                               CER059
     C                   ENDIF                                                              MD053634
     C                   READ      SDCUAHLA                                                   CER059
     C                   ENDDO                                                                CER059
     C                   EVAL      TranInCUAH = CUAHArrDS                                     CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      *  RtvCCTX - Retrieve Customer by Country of Tax Details        *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     RtvCCTX       BEGSR                                                                CER059
                                                                                              CER059
     C                   EVAL      Idy = 1                                                    CER059
     C     DDCUSN        SETLL     SDACTXL4                                                   CER059
     C                   READ      SDACTXL4                                                   CER059
     C                   DOW       NOT %EOF(SDACTXL4)                                         CER059
     C                             AND DDCUSN = AXCUST                                        CER059
     C                   EVAL      TXACTN  = *BLANK                                           CER059
     C                   EVAL      TXCUST  = AXCUST                                           CER059
     C                   EVAL      TXCTTX  = AXCTTX                                           CER059
     C                   EVAL      TXETXS  = AXETXS                                           CER059
     C                   EVAL      TXCERF  = AXCERF                                           CER059
     C                   EVAL      TXCSTS  = AXCSTS                                           CER059
     C                   EVAL      TXCRTP  = AXCRTP                                           CER059
                                                                                              CER059
     C                   EVAL      TXCEEX  = *BLANK                                           CER059
     C                   IF        AXCEEX <> *ZERO                                            CER059
     C                   EVAL      ZDAYNO = AXCEEX                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   MOVEL     ZDATE         TXCEEX                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   EVAL      TXCADT  = *BLANK                                           CER059
     C                   IF        AXCADT <> *ZERO                                            CER059
     C                   EVAL      ZDAYNO = AXCADT                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   MOVEL     ZDATE         TXCADT                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   EVAL      TXCVDT  = *BLANK                                           CER059
     C                   IF        AXCVDT <> *ZERO                                            CER059
     C                   EVAL      ZDAYNO = AXCVDT                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   MOVEL     ZDATE         TXCVDT                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   EVAL      CCTXArr(Idy) = TranInCCTX1                                 CER059
     C                   EVAL      Idy =Idy + 1                                               CER059
     C                   READ      SDACTXL4                                                   CER059
     C                   ENDDO                                                                CER059
     C                   EVAL      TranInCCTX = CCTXArrDS                                     CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      *  RTVCRS - Retrieve CRS Customer Details                       *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     RTVCRS        BEGSR                                                                CGL157
                                                                                              CGL157
      ** Retrieve CRS Customer Details if CGL157 is ON                                        CGL157
                                                                                              CGL157
     C     DDCUSN        CHAIN     SDCRSHL1                           96                    MD036311
     C     *IN96         IFEQ      '0'                                                        CGL157
     C     DDACTN        ANDEQ     'I'                                                        CGL157
     C                   MOVEL     'N'           OKCUST                                       CGL157
     C                   ADD       1             Ix                                           CGL157
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CGL157
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)                                 CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      X = 1                                                      CGL157
     C     DDCUSN        SETLL     SDCRSDL0                                                   CGL157
     C     DDCUSN        READE     SDCRSDL0                                                   CGL157
     C                   DOW       NOT %EOF(SDCRSDL0)                                         CGL157
     C                             AND DDCUSN = CDCUST                                        CGL157
     C                             AND X < 31                                                 CGL157
     C                   EVAL      CVCTRY = CDCTRY                                            CGL157
     C                   EVAL      CVREPT = CDREPT                                            CGL157
     C                   EVAL      CVREPR = CDREPR                                            CGL157
     C                   EVAL      CVREPD = CDREPD                                            CGL157
     C                   EVAL      CVREPM = CDREPM                                            CGL157
     C                   EVAL      CVREPU = CDREPU                                            CGL157
     C                   EVAL      CVEVE1 = CDEVE1                                            CGL157
     C                   EVAL      CVEVS1 = CDEVS1                                            CGL157
     C                   EVAL      CVEVE2 = CDEVE2                                            CGL157
     C                   EVAL      CVEVS2 = CDEVS2                                            CGL157
     C                   EVAL      CVEVE3 = CDEVE3                                            CGL157
     C                   EVAL      CVEVS3 = CDEVS3                                            CGL157
     C                   EVAL      CVEVE4 = CDEVE4                                            CGL157
     C                   EVAL      CVEVS4 = CDEVS4                                            CGL157
     C                   EVAL      CVEVE5 = CDEVE5                                            CGL157
     C                   EVAL      CVEVS5 = CDEVS5                                            CGL157
     C                   EVAL      CVTINN = CDTINN                                            CGL157
     C                   EVAL      CVEFFD = CDEFFD                                            CGL157
     C                   EVAL      CVEXPD = CDEXPD                                            CGL157
     C                   EVAL      CVCODO = CDCODO                                            CGL157
     C                   EVAL      CVJACM = CDJACM                                            CGL157
     C                   EVAL      CVMAIL = CDMAIL                                            CGL157
     C                   EVAL      CVPHON = CDPHON                                            CGL157
     C                   EVAL      CVRPAY = CDRPAY                                            CGL157
     C                   EVAL      CVTINS = CDTINS                                            CGL177
                                                                                              CGL157
     C                   IF        CDCTRY = BBCOLC                                            CGL157
     C                   EVAL      CVCODO = 'Y'                                               CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      PCrsdF(X) = SDVCRSD                                        CGL157
     C                   EVAL      X = X + 1                                                  CGL157
     C     DDCUSN        READE     SDCRSDL0                                                   CGL157
     C                   ENDDO                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCUFO - RETRIEVE Customer Future and Options Details       *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCUFO       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Future and Options Details                                           CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDFOCSLR                           51                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN51         IFEQ      *OFF                                                       CSD079
     C**********         MOVEL     'N'           OKCUST                                CSD079 CSD091
     C**********         ADD       1             Ix                                    CSD079 CSD091
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                        CSD079 CSD091
     C**********         MOVEL     'USR0175'     MsgIdArr(Ix)                          CSD079 CSD091
                                                                                              CSD091
     C**********         EVAL      OKCUST = 'W'                                      CSD091 AR855391
     C**********         EVAL      WIx = WIx + 1                                     CSD091 AR855391
     C**********         EVAL      WFldNamArr(WIx) = 'DDCUSN'                        CSD091 AR855391
     C**********         EVAL      WMsgIDArr(WIx) = 'USR0175'                        CSD091 AR855391
                                                                                            AR855391
     C                   MOVEL     'N'           OKCUST                                     AR855391
     C                   ADD       1             Ix                                         AR855391
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                             AR855391
     C                   MOVEL     'USR0175'     MsgIdArr(Ix)                               AR855391
                                                                                              CSD091
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
     C**********         ELSE                                                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C******IN51         IFEQ      '1'                                                CRE026 BG12238
     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
     C**********         ADD       1             Ix                                   CRE026 BG12238
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
     C**********         MOVEL     'USR0174'     MsgIdArr(Ix)                         CRE026 BG12238
     C**********         ENDIF                                                        CRE026 BG12238
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCUFN - RETRIEVE Customer Futures & options European       *                       CSD079
      *            Reporting                                          *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCUFN       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Future and Options European Reporting details                        CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDFOX1LR                           53                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN53         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
     C**********         ELSE                                                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C******IN53         IFEQ      '1'                                                CRE026 BG12238
     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
     C**********         ADD       1             Ix                                   CRE026 BG12238
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
     C**********         MOVEL     'Y2U0009'     MsgIdArr(Ix)                         CRE026 BG12238
     C**********         ENDIF                                                        CRE026 BG12238
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCUPM - RETRIEVE Customer Portfolio Management Details     *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCUPM       BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Portfolio Management Details                                         CSD079
                                                                                              CSD079
     C     DDCUSN        CHAIN     SDPLCSLR                           52                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN52         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'USR2323'     MsgIdArr(Ix)                                 CSD079
     C                   END                                                                  CSD079
      *                                                                                       CSD079
      ****IF*DELETE, AMEND OR ENQUIRE                                                 CRE026 BG12238
     C**********         ELSE                                                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
      ****IF*LIVE RECORD NOT FOUND - ERROR                                            CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C******IN52         IFEQ      '1'                                                CRE026 BG12238
     C**********         MOVEL     'N'           OKCUST                               CRE026 BG12238
     C**********         ADD       1             Ix                                   CRE026 BG12238
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                       CRE026 BG12238
     C**********         MOVEL     'USR2322'     MsgIdArr(Ix)                         CRE026 BG12238
     C**********         ENDIF                                                        CRE026 BG12238
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCULX2 - RETRIEVE Lux(European Reporting) file             *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCULX2      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Lux(European Reporting) file                                                  CSD079
                                                                                              CSD079
     C                   MOVEL     DDCUSN        VFCUST                                       CSD079
     C     VFCUST        CHAIN     SDCUX2LR                           54                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN54         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Delete, Amend or Enquire                                                          CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Live Record not Found - Error                                                     CSD079
                                                                                              CSD079
     C     *IN54         IFEQ      *ON                                                        CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  RTVCULX1 - RETRIEVE Lux(IBLC - Extended Information) file    *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     RTVCULX1      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Portfolio Management Details                                         CSD079
                                                                                              CSD079
     C                   MOVEL     DDCUSN        CUCNUM                                       CSD079
     C     CUCNUM        CHAIN     SDCUX1LR                           55                      CSD079
                                                                                              CSD079
      ** If Insert Record Found - Error                                                       CSD079
                                                                                              CSD079
     C     DDACTN        IFEQ      'I'                                                        CSD079
     C     *IN55         IFEQ      *OFF                                                       CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'Y2U0003'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Delete, Amend or Enquire                                                          CSD079
                                                                                              CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Live Record not Found - Error                                                     CSD079
                                                                                              CSD079
     C     *IN55         IFEQ      *ON                                                        CSD079
     C                   MOVEL     'N'           OKCUST                                       CSD079
     C                   ADD       1             Ix                                           CSD079
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD079
     C                   MOVEL     'Y2U0009'     MsgIdArr(Ix)                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
     ******************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************
      *                                                               *                    AR1086546
      * RTVCTNM - RETRIEVE Currency/Time of Netting Details           *                    AR1086546
      *                                                               *                    AR1086546
      *****************************************************************                    AR1086546
     C     RTVCTNM       BEGSR                                                             AR1086546
                                                                                           AR1086546
      ** Access Customer Risk Weighted Assets Details                                      AR1086546
                                                                                           AR1086546
     C                   CALLB     'SDCTNMRTV'                                             AR1086546
                                                                                           AR1086546
      ** Inputs                                                                            AR1086546
      ** Return code                                                                       AR1086546
                                                                                           AR1086546
     C                   PARM                    RetCodeIn                                 AR1086546
                                                                                           AR1086546
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                              AR1086546
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                          AR1086546
                                                                                           AR1086546
     C                   PARM                    ModeofOp                                  AR1086546
                                                                                           AR1086546
      ** Response mode                                                                     AR1086546
                                                                                           AR1086546
     C                   PARM                    RespMode                                  AR1086546
                                                                                           AR1086546
      ** Action Code                                                                       AR1086546
                                                                                           AR1086546
     C                   PARM                    DDACTN                                    AR1086546
                                                                                           AR1086546
      ** (Midas) Customer Number                                                           AR1086546
                                                                                           AR1086546
     C                   PARM                    DDCUSN                                    AR1086546
                                                                                           AR1086546
      ** From Customer Flag                                                                AR1086546
                                                                                           AR1086546
     C                   PARM      'Y'           From_Cust         1                       AR1086546
                                                                                           AR1086546
      ** Outputs                                                                           AR1086546
      ** Transaction Details in File Format                                                AR1086546
                                                                                           AR1086546
     C                   PARM                    CtnmFilFmt                                AR1086546
                                                                                           AR1086546
      ** OK - Action code                                                                  AR1086546
                                                                                           AR1086546
     C                   PARM                    OKACTN                                    AR1086546
                                                                                           AR1086546
      ** OK - Customer Number                                                              AR1086546
                                                                                           AR1086546
     C                   PARM                    OKCUST                                    AR1086546
                                                                                           AR1086546
      ** Error fields/message IDs/message data (arrays) from/to caller                     AR1086546
                                                                                           AR1086546
     C                   PARM                    FldNameArr                                AR1086546
     C                   PARM                    MsgIDArr                                  AR1086546
     C                   PARM                    MsgDtaArr                                 AR1086546
                                                                                           AR1086546
      ** Array index (3P0) from/to caller                                                  AR1086546
                                                                                           AR1086546
     C                   PARM                    Ix                                        AR1086546
     C                   ENDSR                                                             AR1086546
                                                                                           AR1086546
      *****************************************************************                    AR1086546
      /EJECT                                                                               AR1086546
      *****************************************************************                    AR1086546
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Customer number
     C                   PARM                    DDCUSN            6
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      *  Base Rate Tax option feature is switched on
     C                   PARM                    S01383            1
      *
      *  Private Banking Customer details is switched on
     C                   PARM                    BGN4ST            1
      ** Global Data Layout                                                                   CGP001
     C                   PARM                    CGP001            1                          CGP001
      *
      ** Transaction Type                                                                     CSD028
     C                   PARM                    TransType                                    CSD028
      *                                                                                       CSD028
      *  Acceptance Mode                                                                      249593
     C                   PARM                    PAccMde           1                          249593
      *  Update (Y/N)                                                                         249593
     C                   PARM                    PUpdYN            1                          249593
      ** Acceptance Mode                                                                      CSD031
     C**********         PARM                    PAccMde                             CSD031 BUG13525
      ** Update (Y/N)                                                                         CSD031
     C**********         PARM                    PUpdYN                              CSD031 BUG13525
      * OUTPUTS
      *
      * (Current) Customer in file format
      * (Current) Customer Base Rate Tax in file format
      * (Current) Private Banking Customer in file format
      ** (Current) Customer Swift Details in file format                                      CSW207
      ** (Current) Global Customer X-Reference in file format                                 CGP001
     C                   PARM                    CustFilFmt
     C                   PARM                    CuBrFilFmt
     C                   PARM                    CuPbFilFmt
     C                   PARM                    CuTIFilFMt                                  BUG3362
     C                   PARM                    GCustFilFmt                                  CGP001
     C                   PARM                    SwftFilFmt                                   CSW207
     C                   PARM                    CuSW13                                       CFT050
     C                   PARM                    CuXcFilFmt                                   CGL132
     C                   PARM                    CuFaFilFmt                                   CGL132
     C                   PARM                    CrsdFilFmt                                   CGL157
     C                   PARM                    PCrsdF                                       CGL157
     C                   PARM                    CumiFilFmt                                   CSD079
     C                   PARM                    CuadFilFmt                                   CSD079
     C                   PARM                    SfeeFilFmt                                   CSD079
     C                   PARM                    ChecFilFmt                                   CSD079
     C                   PARM                    CusfFilFmt                                   CSD079
     C                   PARM                    RwanFilFmt                                   CSD079
     C                   PARM                    CufoFilFmt                                   CSD079
     C                   PARM                    CufnFilFmt                                   CSD079
     C                   PARM                    CupmFilFmt                                   CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
     C                   PARM                    TranInCUAH                                   CER059
     C                   PARM                    TranInCCTX                                   CER059
     C                   PARM                    CtnmFilFmt                                AR1086546
     C                   PARM                    TranInPrim                                   CFT050
     C                   PARM                    TranInSeco                                   CFT050
     C                   PARM                    TranInMT3X                                   CFT050
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Customer Number
     C                   PARM                    OKCUST            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *                                                                                     BUG23518
      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIDArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      *                                                                                     BUG23518
      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WIx                                        BUG23518
     C/COPY WNCPYSRC,SDCUSDIC06
      *
      ** Parameter list for calling AOSVALR0                                                  CSD027
     C     P_AOSVALR0    PList                                                                CSD027
      * Return Code (Output)                                                                  CSD027
     C                   Parm                    PRetCode                                     CSD027
      * System Value to be retrieved (Input)                                                  CSD027
     C                   Parm                    PSysValK1                                    CSD027
      * Value returned (Output)                                                               CSD027
     C                   Parm                    PSysVal1                                     CSD027
     C                   Parm                    PSysValK2                                    CSD027
     C                   Parm                    PSysVal2                                     CSD027
     C                   Parm                    PSysValK3                                    CSD027
     C                   Parm                    PSysVal3                                     CSD027
     C                   Parm                    PSysValK4                                    CSD027
     C                   Parm                    PSysVal4                                     CSD027
     C                   Parm                    PSysValK5                                    CSD027
     C                   Parm                    PSysVal5                                     CSD027
     C                   Parm                    PSysValK6                                    CSD027
     C                   Parm                    PSysVal6                                     CSD027
     C                   Parm                    PSysValK7                                    CSD027
     C                   Parm                    PSysVal7                                     CSD027
     C                   Parm                    PSysValK8                                    CSD027
     C                   Parm                    PSysVal8                                     CSD027
     C                   Parm                    PSysValK9                                    CSD027
     C                   Parm                    PSysVal9                                     CSD027
     C                   Parm                    PSysValK10                                   CSD027
     C                   Parm                    PSysVal10                                    CSD027
      *                                                                                       CSD027
      ** Parameter list for calling SDCUSTISO                                                 CSD027
     C     P_SDCUSTISO   PList                                                                CSD027
      ** Customer Number (Input)                                                              CSD027
     C                   Parm                    PCust                                        CSD027
      ** Validity Flags (Output)                                                              CSD027
     C                   Parm                    PValid                                       CSD027
      ** Check Digit (Output)                                                                 CSD027
     C                   Parm                    PCheckDigit                                  CSD027
     C                   Parm                    @data             2                        BUG15872
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDRTV'   DBPGM
      *                                                                                     BUG23518
      ** Key field definition for Country of Tax file SDACTXL0                              BUG23518
      *                                                                                     BUG23518
     C     KLActx        KLIST                                                              BUG23518
     C                   KFLD                    KFCusn                                     BUG23518
     C                   KFLD                    KFCTax                                     BUG23518
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C******DTAARA       DEFINE                  ZMUSER                              CSD031 BUG13525
     C**********         IN        ZMUSER                                            CSD031 BUG13525
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CSD079
      ** Access Module Details                                                                CSD079
                                                                                              CSD079
     C                   CALL      'AOMMODR0'                                                 CSD079
     C                   PARM      '*DBERR '     @RTCD                                        CSD079
     C                   PARM      '*FIRST '     @OPTN                                        CSD079
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSD079
                                                                                              CSD021
      ** Access SAR details file to determine if CSD021                                       CSD021
      ** (System Generated Customer Number) is on.                                            CSD021
      *                                                                                       CSD021
     C                   CALLB     'AOSARDR0'                                                 CSD021
     C                   PARM      *BLANKS       @RTCD                                        CSD021
     C                   PARM      '*VERIFY'     @OPTN                                        CSD021
     C                   PARM      'CSD021'      @SARD             6                          CSD021
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
      *                                                                                       CSD021
      * DATABASE ERROR                                                                        CSD021
      *                                                                                       CSD021
     C     @RTCD         IFNE      *BLANKS                                                    CSD021
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD021
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD021
     C                   MOVEL     '902'         DBASE                                        CSD021
     C                   MOVEL     'CSD021'      DBKEY                                        CSD021
     C                   EXSR      *PSSR                                                      CSD021
     C                   ENDIF                                                                CSD021
      *                                                                                       CSD021
     C     @RTCD         IFEQ      *BLANK                                                     CSD021
     C                   MOVEL     'Y'           CSD021            1                          CSD021
     C                   ELSE                                                                 CSD021
     C                   MOVEL     'N'           CSD021                                       CSD021
     C                   ENDIF                                                                CSD021
      *                                                                                      BUG7233
      ** Access SAR details file to determine if CSD023                                      BUG7233
      *                                                                                      BUG7233
     C                   CALLB     'AOSARDR0'                                                BUG7233
     C                   PARM      *BLANKS       @RTCD                                       BUG7233
     C                   PARM      '*VERIFY'     @OPTN                                       BUG7233
     C                   PARM      'CSD023'      @SARD             6                         BUG7233
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG7233
      *                                                                                      BUG7233
      * DATABASE ERROR                                                                       BUG7233
      *                                                                                      BUG7233
     C     @RTCD         IFNE      *BLANKS                                                   BUG7233
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG7233
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG7233
     C                   MOVEL     '912'         DBASE                                       BUG7233
     C                   MOVEL     'CSD023'      DBKEY                                       BUG7233
     C                   EXSR      *PSSR                                                     BUG7233
     C                   ENDIF                                                               BUG7233
      *                                                                                      BUG7233
     C     @RTCD         IFEQ      *BLANK                                                    BUG7233
     C                   MOVEL     'Y'           CSD023            1                         BUG7233
     C                   ELSE                                                                BUG7233
     C                   MOVEL     'N'           CSD023                                      BUG7233
     C                   ENDIF                                                               BUG7233
                                                                                              CSD028
      ** Check if feature CSD028 is switched on                                               CSD028
                                                                                              CSD028
     C                   CALLB     'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       P@Rtcd                                       CSD028
     C                   PARM      '*VERIFY'     P@Optn                                       CSD028
     C                   PARM      'CSD028'      P@Sard                                       CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
                                                                                              CSD028
      ** Database Error                                                                       CSD028
                                                                                              CSD028
     C                   IF        P@Rtcd <> *BLANKS AND P@Rtcd <> '*NRF   '                  CSD028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD028
     C                   MOVEL     '913'         DBASE                                        CSD028
     C                   MOVEL     'CSD028'      DBKEY                                        CSD028
     C                   EXSR      *PSSR                                                      CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        P@Rtcd = *BLANK                                            CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   ELSE                                                                 CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD079
      ** Check if enhancement S01425 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'S01425'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'S01425'                                          CSD079
     C                   EVAL      DBASE  = 921                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      S01425 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      S01425 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CSD008 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CSD008'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CSD008'                                          CSD079
     C                   EVAL      DBASE  = 922                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD008 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD008 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CDL002 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CDL002'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CDL002'                                          CSD079
     C                   EVAL      DBASE  = 916                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CDL002 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CDL002 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CDL006 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CDL006'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CDL006'                                          CSD079
     C                   EVAL      DBASE  = 917                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CDL006 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CDL006 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CGL018 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CGL018'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CGL018'                                          CSD079
     C                   EVAL      DBASE  = 918                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CGL018 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CGL018 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     ** Check if enhancement CSD079 is on                                                     CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CSD079'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CSD079'                                          CSD079
     C                   EVAL      DBASE  = 919                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD079 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD079 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX004 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       @RTCD                                        CSD079
     C                   PARM      '*VERIFY'     @OPTN                                        CSD079
     C                   PARM      'ULX004'      @SARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
      ** Database Error                                                                       CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANKS                                                    CSD079
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD079
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD079
     C                   MOVEL     903           DBASE                                        CSD079
     C                   MOVEL     'ULX004'      DBKEY                                        CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C     @RTCD         IFEQ      *BLANK                                                     CSD079
     C                   MOVEL     'Y'           ULX004                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           ULX004                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX609 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       @RTCD                                        CSD079
     C                   PARM      '*VERIFY'     @OPTN                                        CSD079
     C                   PARM      'ULX609'      @SARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
      ** Database Error                                                                       CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANKS                                                    CSD079
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD079
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD079
     C                   MOVEL     925           DBASE                                        CSD079
     C                   MOVEL     'ULX609'      DBKEY                                        CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C     @RTCD         IFEQ      *BLANK                                                     CSD079
     C                   MOVEL     'Y'           ULX609                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           ULX609                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX043 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX043'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX043'                                          CSD079
     C                   EVAL      DBASE  = 924                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX043 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX043 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                           AR1086546
      ** Check if enhancement CDL025 is on                                                 AR1086546
                                                                                           AR1086546
     C                   CALLB     'AOSARDR0'                                              AR1086546
     C                   PARM      *BLANKS       PRTCD                                     AR1086546
     C                   PARM      '*VERIFY'     POPTN                                     AR1086546
     C                   PARM      'CDL025'      PSARD                                     AR1086546
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1086546
                                                                                           AR1086546
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '               AR1086546
     C                   EVAL      DBFILE = 'SCSARDPD'                                     AR1086546
     C                   EVAL      DBKEY  = 'CDL025'                                       AR1086546
     C                   EVAL      DBASE  = 926                                            AR1086546
     C                   EXSR      *PSSR                                                   AR1086546
     C                   ENDIF                                                             AR1086546
      *                                                                                    AR1086546
     C                   IF        PRTCD = *BLANKS                                         AR1086546
     C                   EVAL      CDL025 = 'Y'                                            AR1086546
     C                   ELSE                                                              AR1086546
     C                   EVAL      CDL025 = 'N'                                            AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                              CSD079
      ** Portfolios Supported is Customer                                                     CSD079
                                                                                              CSD079
      ** Check if Portfolio Management Enhancement is on                                      CSD079
                                                                                              CSD079
     C     BGPFMG        IFEQ      'Y'                                                        CSD079
     C                   CALLB     'AOPORTR0'                                                 CSD079
     C                   PARM      '*MSG    '    @RTCD                                        CSD079
     C                   PARM      '*FIRST  '    @OPTN                                        CSD079
     C     SDPORT        PARM      SDPORT        DSSDY                                        CSD079
      *                                                                                       CSD079
      * DATABASE ERROR                                                                        CSD079
      *                                                                                       CSD079
     C     @RTCD         IFNE      *BLANK                                                     CSD079
     C                   MOVEL     @OPTN         DBKEY                                        CSD079
     C                   MOVEL     'SDPORTPD'    DBFILE                                       CSD079
     C                   MOVEL     920           DBASE                                        CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C     FCPORS        IFEQ      'C'                                                        CSD079
     C                   MOVEL     'Y'           WUPMSC                                       CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** Retrieve Int Cust Branch - Branch Codes                                              CSD079
                                                                                              CSD079
     C                   EXSR      TWRVGN                                                     CSD079
                                                                                              CSD079
      ** Return code is Customer on branch codes                                              CSD079
                                                                                              CSD079
     C     W0RTN         IFEQ      'BRANCH'                                                   CSD079
     C                   MOVEL     'Y'           WUPMSC                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           WUPMSC                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           WUPMSC                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD031
      ** Check if CSD037 is enabled.                                                          CSD031
                                                                                              CSD031
     C**********         CALLB     'AOSARDR0'                                        CSD031 BUG13525
     C**********         PARM      *BLANKS       PRtCd                               CSD031 BUG13525
     C**********         PARM      '*VERIFY'     POptn                               CSD031 BUG13525
     C**********         PARM      'CSD037'      PSARD                               CSD031 BUG13525
     C*****SCSARD        PARM      SCSARD        DSFDY                               CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        PRtCd = *BLANKS                                   CSD031 BUG13525
     C**********         EVAL      CSD037 = 'Y'                                      CSD031 BUG13525
     C**********         ELSE                                                        CSD031 BUG13525
                                                                                              CSD031
     C**********         IF        PRtCd <> '*NRF   '                                CSD031 BUG13525
     C******LOCK         IN        LDA                                               CSD031 BUG13525
     C**********         EVAL      DBFile = 'SCSARDPD'                               CSD031 BUG13525
     C*
     C**********         EVAL      DBase = 101                                       CSD031 BUG13525
     C**********         OUT       LDA                                               CSD031 BUG13525
     C**********         EXSR      *PSSR                                             CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDIF                                                       CSD031 BUG13525
      *                                                                                       CSD031
      *                                                                                     BUG23518
      ** Call AOSARDR0 to check for CER048                                                  BUG23518
      *                                                                                     BUG23518
     C                   CALLB     'AOSARDR0'                                               BUG23518
     C                   PARM      *BLANKS       P@Rtcd                                     BUG23518
     C                   PARM      '*VERIFY'     P@Optn                                     BUG23518
     C                   PARM      'CER048'      P@Sard                                     BUG23518
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23518
      *                                                                                     BUG23518
     C                   IF        P@Rtcd = *BLANKS                                         BUG23518
     C                   EVAL      CER048 = 'Y'                                             BUG23518
     C                   ELSE                                                               BUG23518
     C                   EVAL      CER048 = 'N'                                             BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   IF        P@Rtcd <> '*NRF' AND                                     BUG23518
     C                             P@Rtcd <> *BLANKS                                        BUG23518
      *                                                                                     BUG23518
     C     *LOCK         IN        LDA                                                      BUG23518
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG23518
     C                   EVAL      DBKEY = 'CER048'                                         BUG23518
     C                   EVAL      DBASE = 914                                              BUG23518
     C                   OUT       LDA                                                      BUG23518
     C                   EXSR      *PSSR                                                    BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** Call AOSARDR0 to check for CER034                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       P@Rtcd                                       CER059
     C                   PARM      '*VERIFY'     P@Optn                                       CER059
     C                   PARM      'CER034'      P@Sard                                       CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        P@Rtcd = *BLANKS                                           CER059
     C                   EVAL      CER034 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER034 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        P@Rtcd <> '*NRF' AND                                       CER059
     C                             P@Rtcd <> *BLANKS                                          CER059
     C     *LOCK         IN        LDA                                                        CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY = 'CER034'                                           CER059
     C                   EVAL      DBASE = 910                                                CER059
     C                   OUT       LDA                                                        CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Call AOSARDR0 to check for CGL032                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       P@Rtcd                                       CER059
     C                   PARM      '*VERIFY'     P@Optn                                       CER059
     C                   PARM      'CGL032'      P@Sard                                       CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        P@Rtcd = *BLANKS                                           CER059
     C                   EVAL      CGL032 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CGL032 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        P@Rtcd <> '*NRF' AND                                       CER059
     C                             P@Rtcd <> *BLANKS                                          CER059
     C     *LOCK         IN        LDA                                                        CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY = 'CGL032'                                           CER059
     C                   EVAL      DBASE = 911                                                CER059
     C                   OUT       LDA                                                        CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
     C/COPY WNCPYSRC,SDH00484
                                                                                              CER059
      ** Define Keylist                                                                       CSD012
     C     KAULG         KLIST                                                                CSD012
     C                   KFLD                    @FUNC            21                          CSD012
     C**********         KFLD                    @KEY             20                   CSD012 CGL029
     C                   KFLD                    @KEY                                         CGL029
      *                                                                                       CSD012
     C                   MOVEL     FUNCD         @FUNC                                        CSD012
      *                                                                                       CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       P@RtCd                                       CSW207
                                                                                              CSW207
     C                   IF        P@RtCd = 'CSW2007'                                         CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CGL157
      ** Check if enhancement CGL157 is on                                                    CGL157
                                                                                              CGL157
     C                   CALLB     'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       @RTCD                                        CGL157
     C                   PARM      '*VERIFY'     @OPTN                                        CGL157
     C                   PARM      'CGL157'      PSARD                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        @RTCD <> *BLANKS AND                                       CGL157
     C                             @RTCD <> '*NRF   '                                         CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBKEY  = 'CGL157'                                          CGL157
     C                   EVAL      DBASE  = 923                                               CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        @RTCD = *BLANKS                                            CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CGL157 = 'N'                                               CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
                                                                                              CGL132
      ** Check if enhancement CGL132 is on                                                    CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD <> *BLANKS AND                                       CGL132
     C                             @RTCD <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBKEY  = 'CGL132'                                          CGL132
     C                   EVAL      DBASE  = 920                                               CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        @RTCD = *BLANKS                                            CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
     C                   CALL      'AOSVALR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtcd                                        CGL132
     C                   PARM      SysVal1       SValK1                                       CGL132
     C                   PARM                    SVal1                                        CGL132
     C                   PARM      SysVal2       SValK2                                       CGL132
     C                   PARM                    SVal2                                        CGL132
     C                   PARM                    SValK3                                       CGL132
     C                   PARM                    SVal3                                        CGL132
     C                   PARM                    SValK4                                       CGL132
     C                   PARM                    SVal4                                        CGL132
     C                   PARM                    SValK5                                       CGL132
     C                   PARM                    SVal5                                        CGL132
     C                   PARM                    SValK6                                       CGL132
     C                   PARM                    SVal6                                        CGL132
     C                   PARM                    SValK7                                       CGL132
     C                   PARM                    SVal7                                        CGL132
     C                   PARM                    SValK8                                       CGL132
     C                   PARM                    SVal8                                        CGL132
     C                   PARM                    SValK9                                       CGL132
     C                   PARM                    SVal9                                        CGL132
     C                   PARM                    SValK0                                       CGL132
     C                   PARM                    SVal10                                       CGL132
                                                                                              CGL132
     C                   IF        PRtcd <> *Blanks  AND                                      CGL132
     C                             PRtcd <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CGL132
     C                   EVAL      DBKEY = SValK1                                             CGL132
     C                   EVAL      DBASE = 902                                                CGL132
     C                   EVAL      DBPGM = 'SDCUSDRTV'                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      WWCLAC = SVal1                                             CGL132
     C                   EVAL      WCTAX = SVal2                                              CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if enhancement CGL133 is on                                                    CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
     C                   PARM      'CGL133'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        @RTCD <> *BLANKS AND                                       CGL132
     C                             @RTCD <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBKEY  = 'CGL133'                                          CGL132
     C                   EVAL      DBASE  = 921                                               CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        @RTCD = *BLANKS                                            CGL132
     C                   EVAL      CGL133 = 'Y'                                               CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL133 = 'N'                                               CGL132
     C                   ENDIF                                                                CGL132
      *                                                                                       CFT050
      ** Check if SWIFT 2013 is installed                                                     CFT050
      *                                                                                       CFT050
     C                   CALL      'SWIF2013'                                                 CFT050
     C                   PARM      *BLANKS       P@RtCd                                       CFT050
                                                                                              CFT050
     C                   IF        P@RtCd = 'CSW2013'                                         CFT050
     C                   EVAL      CSW213 = 'Y'                                               CFT050
     C                   ELSE                                                                 CFT050
     C                   EVAL      CSW213 = 'N'                                               CFT050
     C                   ENDIF                                                                CFT050
     C*                  IF        CSW213 = 'Y'                                               CFT050
     C*                  EVAL      SVDDBDRK2 = *BLANKS                                        CFT050
     C*                  ENDIF                                                                CFT050
      *                                                                                       CFT050
      ** Access SAR Details file to determine if CSW204 is switched on                        CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C**********         PARM      'CSW204'      @SARD                               CFT050 MD022463
     C                   PARM      'CSW024'      @SARD                                      MD022463
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
      ** Database Error                                                                       CFT050
                                                                                              CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '912'         DBASE                                        CFT050
     C**********         MOVEL     'CSW204'      DBKEY                               CFT050 MD022463
     C                   MOVEL     'CSW024'      DBKEY                                      MD022463
     C                   EXSR      *PSSR                                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C     @RTCD         IFEQ      *BLANK                                                     CFT050
     C**********         MOVEL     'Y'           CSW204                              CFT050 MD022463
     C                   MOVEL     'Y'           CSW024                                     MD022463
     C                   ELSE                                                                 CFT050
     C**********         MOVEL     'N'           CSW204                              CFT050 MD022463
     C                   MOVEL     'N'           CSW024                                     MD022463
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
      *                                                                                     MD022463
      ** Access SAR Details file to determine if CFT050 is switched on                      MD022463
      *                                                                                     MD022463
     C                   CALLB     'AOSARDR0'                                               MD022463
     C                   PARM      *BLANKS       @RTCD                                      MD022463
     C                   PARM      '*VERIFY'     @OPTN                                      MD022463
     C                   PARM      'CFT050'      @SARD                                      MD022463
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022463
                                                                                            MD022463
      ** Database Error                                                                     MD022463
                                                                                            MD022463
     C     @RTCD         IFNE      *BLANKS                                                  MD022463
     C     @RTCD         ANDNE     '*NRF   '                                                MD022463
     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD022463
     C                   MOVEL     '913'         DBASE                                      MD022463
     C                   MOVEL     'CFT050'      DBKEY                                      MD022463
     C                   EXSR      *PSSR                                                    MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022463
     C     @RTCD         IFEQ      *BLANK                                                   MD022463
     C                   MOVEL     'Y'           CFT050                                     MD022463
     C                   ELSE                                                               MD022463
     C                   MOVEL     'N'           CFT050                                     MD022463
     C                   ENDIF                                                              MD022463
                                                                                            MD022463
                                                                                              CER069
      ** Access SAR Details file to determine if CER069 is switched on                        CER069
                                                                                              CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       @RTCD                                        CER069
     C                   PARM      '*VERIFY'     @OPTN                                        CER069
     C                   PARM      'CER069'      @SARD                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
                                                                                              CER069
      ** Database Error                                                                       CER069
                                                                                              CER069
     C     @RTCD         IFNE      *BLANKS                                                    CER069
     C     @RTCD         ANDNE     '*NRF   '                                                  CER069
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER069
     C                   MOVEL     '927'         DBASE                                        CER069
     C                   MOVEL     'CER069'      DBKEY                                        CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C     @RTCD         IFEQ      *BLANK                                                     CER069
     C                   MOVEL     'Y'           CER069                                       CER069
     C                   ELSE                                                                 CER069
     C                   MOVEL     'N'           CER069                                       CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
      *                                                                                     MD030956
      ** Check if feature CTI006 is switched on.                                            MD030956
      *                                                                                     MD030956
     C                   CALLB     'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       @RTCD                                      MD030956
     C                   PARM      '*VERIFY'     @OPTN                                      MD030956
     C                   PARM      'CTI006'      @SARD                                      MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
                                                                                            MD030956
     C                   IF        @RTCD  <> *BLANKS AND                                    MD030956
     C                             @RTCD  <> '*NRF   '                                      MD030956
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD030956
     C                   EVAL      DBKEY  = 'CTI006'                                        MD030956
     C                   EVAL      DBASE  = 928                                             MD030956
     C                   EXSR      *PSSR                                                    MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
     C                   IF        @RTCD  = *BLANKS                                         MD030956
     C                   EVAL      CTI006 = 'Y'                                             MD030956
     C                   ELSE                                                               MD030956
     C                   EVAL      CTI006 = 'N'                                             MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
     C/COPY WNCPYSRC,SDCUSDIC05
      *
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric' &                      CSD027
      *                       'CustAlphaChecksum'                                             CSD027
     C                   Eval      PRetCode = *BLANKS                                         CSD027
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                               CSD027
     C                   Eval      PSysVal1 = *BLANKS                                         CSD027
     C                   Eval      PSysValK2 = 'CustAlphaChecksum'                            CSD027
     C                   Eval      PSysVal2 = *BLANKS                                         CSD027
     C                   Eval      PSysValK3 = 'CustAlphaSupNumeric'                          CSD027
     C                   Eval      PSysVal3 = *BLANKS                                         CSD027
     C**********         CallB(E)  'AOSVALR0'    P_AOSVALR0                          CSD027 BUG11828
                                                                                            BUG11828
     C**********         IF        CSD037 = 'Y'                                    BUG11828 BUG13525
     C**********         CALL (E)  'GPAOSVALR0'  P_AOSVALR0                        BUG11828 BUG13525
     C**********         ELSE                                                      BUG11828 BUG13525
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C**********         ENDIF                                                     BUG11828 BUG13525
      *                                                                                       CSD027
      * If Error retrieving the System value                                                  CSD027
     C                   If        %Error Or PRetCode <> *BLANKS                              CSD027
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CSD027
     C                   Eval      DBFILE = 'SDSVALPD'                                        CSD027
     C                   Eval      DBASE = 914                                                CSD027
     C                   Eval      DBKEY = 'CustAlpha(Allow/Chk/SupNum)'                      CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Eval      WCusAlphaAllow  = PSysVal1                                 CSD027
     C                   Eval      WCusAlphChksum  = PSysVal2                                 CSD027
     C                   Eval      WCusAlphaSupNum = PSysVal3                                 CSD027
      *                                                                                       CSD027
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      *                                                               *                       CSD079
      * Retrieve Int Cust Branch - Branch Codes                       *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     CSR   TWRVGN        BEGSR                                                                CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C     DDCUSN        SETLL     @BRCHFM                                                    CSD079
     C     DDCUSN        READE     @BRCHFM                                90                  CSD079
     C     *IN90         IFEQ      *ON                                                        CSD079
                                                                                              CSD079
      ** Data record not found                                                                CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C                   LEAVESR                                                              CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C     *IN90         DOWEQ     *OFF                                                       CSD079
                                                                                              CSD079
      ** USER: Process Data record                                                            CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C                   MOVEL     'BRANCH'      W0RTN                                        CSD079
     C     DDCUSN        READE     @BRCHFM                                90                  CSD079
     C                   ENDDO                                                                CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CER059
      * ZDATE2 - Format a date for output                             *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     ZDATE2        BEGSR                                                                CER059
                                                                                              CER059
     C                   CALLB     'ZDATE2'                                                   CER059
     C                   PARM                    ZDAYNO                                       CER059
     C                   PARM                    BJDFIN                                       CER059
     C                   PARM                    ZDATE                                        CER059
     C                   PARM                    ZADATE                                       CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
