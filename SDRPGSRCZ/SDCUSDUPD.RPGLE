     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details database update')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *
      *  SDCUSDUPD - STANDING DATA CUSTOMERS DATABASE UPDATE          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055373           Date 14Jul20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD031234           Date 16May19               *
      *                 MD020755           Date 16May19               *
      *                 MD050212           Date 02Apr18               *
      *                 MD051563           Date 19Jul18               *
      *                 MD051393           Date 29Jun18               *
      *                 MD051206           Date 11Jun18               *
      *                 MD051230           Date 08Jun18               *
      *                 MD041429           Date 22Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD045218           Date 17Apr17               *
      *                 MD043029           Date 05Dec16               *
      *                 MD042407           Date 08Nov16               *
      *                 MD038401B          Date 05Oct16               *
      *                 CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 MD030958           Date 17Jul15               *
      *                 CER070             Date 29Oct14               *
      *                 CSW214             Date 29Oct14               *
      *                 MD030956           Date 09Oct14               *
      *                 MD028198           Date 08Sep14               *
      *                 MD029836           Date 22Aug14               *
      *                 MD027606           Date 01Jul14               *
      *                 MD027492A          Date 12Jun14               *
      *                 MD027492           Date 12Jun14               *
      *                 MD027115           Date 22May14               *
      *                 MD026957B          Date 29May14               *
      *                 MD026957           Date 29May13               *
      *                 MD026854           Date 29May14               *
      *                 MD026835A          Date 22May14               *
      *                 MD026835           Date 22May14               *
      *                 MD026550           Date 22May14               *
      *                 MD026755           Date 16May14               *
      *                 MD026502           Date 01May14               *
      *                 MD026499A          Date 30Apr14               *
      *                 MD026499           Date 29Apr14               *
      *                 MD026518           Date 30Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 MD026368           Date 16Apr14               *
      *                 CFT050             Date 03Jun13               *
      *                 AR1086546          Date 27Jun13               *
      *                 AR679445           Date 12Jun13               *
      *                 AR1049708          Date 07Feb13               *
      *                 AR1081787          Date 30Jan13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR971184           Date 28May12               *
      *                 AR830675           Date 16Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CSD090             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG23518           Date 30Mar09               *
      *                 CER047             Date 19May08               *
      *                 BUG27943           Date 29Jul10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16705           Date 04Mar08               *
      *                 BUG15872           Date 12Feb08               *
      *                 BUG15138           Date 25Oct07               *
      *                 BUG14969           Date 09Oct07               *
      *                 BUG14929           Date 04Oct07               *
      *                 CSW207             Date 08Jun07               *
      *                 249593             Date 22Aug07               *
      *                 BUG14009           Date 05Jul07               *
      *                 BUG14104           Date 06Jun07               *
      *                 BUG13594           Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13525           Date 05Mar07               *
      *                 CSD079             Date 05Feb07               *
      *                 BG12238            Date 24Oct06               *
      *                 CRE026             Date 06Jun06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12406           Date 05Nov06               *
      *                 BUG12342           Date 27Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG10651           Date 22Feb06               *
      *                 CSD028             Date 22Aug05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6444            Date 05Apr05               *
      *                 217230             Date 02Sep03               *
      *                 CSW037A            Date 02May05               *
      *                 CSD023             Date 18Nov04               *
      *                 BUG6552            Date 10Apr05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4810            Date 27Jan05               *
      *                 BUG5409            Date 11Jan05               *
      *                 CSW036             Date 15Dec04               *
      *                 CSW037             Date 14Dec04               *
      *                 BUG4967            Date 10Dec04               *
      *                 BUG4668            Date 23Dec04               *
      *                 BUG4732            Date 06Nov04               *
      *                 BUG4692            Date 02Nov04               *
      *                 BUG4201            Date 09Sep04               *
      *                 BUG3362            Date 30Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2313            Date 28Apr04               *
      *                 BUG1986            Date 28Apr04               *
      *                 CSD021             Date 10Jul03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 23May03               *
      *                 CSD015             Date 14Oct02               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210006             Date 23Oct01               *
      *                 202380             Date 28May02               *
      *                 202931             Date 09May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201011             Date 28Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 185595             Date 13Nov00               *
      *                 175680             Date 08Mar00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP013             Date 22Nov99               *
      *                 CAP034  *CREATE    Date 20May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055373 - Audit trail not available                         *
      *           - Receive and process the DDIUSR and DDAUSR fields  *
      *             from SDCUSDVU.                                    *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD031234 - Marketing information not updated on CLINTCB      *
      *             when inserting customer.                          *
      *           - Applied for MD-52640.                             *
      *  MD020755 - CLINTCB not updated for SDCRMKPD.                 *
      *           - Applied for MD-52640.                             *
      *  MD050212 - Replication processing for PF/SDCUSTXC            *
      *  MD051563 - On COB run, Component GOC0100 failed due to       *
      *             Customer Related Duplicate Key Error              *
      *  MD051393 - Serious midas error                               *
      *  MD051206 - Time field in FATCA Information tab changes to    *
      *             asterisks after amendment authorisation           *
      *  MD051230 - Authorise of customer record in CUSD gets serious *
      *             midas error message                               *
      *  MD041429 - History of Customer Information does not reflect  *
      *             US Indicia Changed upon Insert and Miscellaneous  *
      *             Change to log Additional Customer Details upon    *
      *             Insert and Amend.                                 *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045218 - Account Review is not displayed in listview       *
      *  MD043029 - Serious Midas Error encountered during            *
      *             authorisation of CUSD amend                       *
      *  MD042407 - Creation Date field is missing when CGL132 is     *
      *             switched off ; reversed MD030958 fix              *
      *  MD038401B - Corrected parameters when calling SDCUSDRTV.     *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field                             *
      *  MD030958 - Condition SDCUSTXC updates on CGL132 feature.     *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD028198 - Bank Directory Record Key field should be         *
      *             dependent on CFT050                               *
      *  MD029836 - OCBC FATCA - US Indicia Comments History          *
      *           - Apply fix MD027525                                *
      *  MD027606 - Override Date and Time remains blank after        *
      *             Defining a value in Override during Insert        *
      *  MD027492A - Override Details in US Indicia screen is         *
      *              incorrect                                        *
      *  MD027492 - Override Details in US Indicia screen is incorrect*
      *  MD027115 - Joint Account Exception updates                   *
      *  MD026957B - History of customer information issues           *
      *  MD026957 - History of customer information issues            *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD026835A - Override user and override time are wrong        *
      *  MD026835 - Override user and override time are wrong         *
      *  MD026550 - US TIN Update in FATCA Customer Details           *
      *             changed                                           *
      *  MD026755 - Unable to create customer Serious Midas Error on  *
      *             confirm authorised                                *
      *  MD026502 - Account review generated when a customer is       *
      *             tagged as high value account have incorrect       *
      *             scheduled date                                    *
      *  MD026499A - Unexpected error appears in auto generated       *
      *              account reviews by high value indicator          *
      *  MD026499 - Unexpected error appears in auto generated        *
      *             account reviews by high value indicator           *
      *  MD026518 - Incorrect drop down selection in US indicia       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  MD026368 - Serious Midas error has occured when authorising  *
      *             a customer.                                       *
      *           - Condition the update to extension file SDCTNMPD   *
      *             if the customer number is not blank.              *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813                             *
      *  AR679445 - Blanks BBIUSR and BBAUSR. Populate these fields   *
      *             using the profile on ZMUSER. (Child: AR679446)    *
      *  AR1049708 - WIP problem for customer: record written into    *
      *              PF/SDPLCSPD (Child:AR1049709)                    *
      *  AR1081787 - A Serious midas error has occurred upon hitting  *
      *              complete button using new inserted CUAP, Curren- *
      *              cy saved at PMPORTPD is wrong.                   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  AR830675 - GF - Maintain Customers - Add. Cust. Inf. 2 -     *
      *             entered lang. ID not defaulted                    *
      *             (Child: AR830676)                                 *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD090 - Customer Segmentation                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG27943 - Unable to authorise amendment                     *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16705 - The system should automatically generate customer *
      *             number if field is blank                          *
      *  BUG15872 - Parameter mismatch. Applied fix BUG14992          *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *  BUG15138 - IBEI is not updated when CSW207 is off            *
      *  BUG14969 - Cannot authorise amendments to Customer details   *
      *             SWIFT additional fields.                          *
      *  BUG14929 - Error in Customer Details update                  *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  249593 - Correct mismatch parameters on second SDCUSDRTV call*
      *  BUG14009 - To implement Close and Release functionality in   *
      *             Customer API                                      *
      *  BUG14104 - MidasPlus error encountered when authorising a    *
      *             new Wholesale Customer                            *
      *  BUG13594 - MidasPlus error encountered when authorising a    *
      *             new Wholesale Customer                            *
      *  BUG13525 - ECSD Mismatch between XML and RPG                 *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  BG12238 - Conditional writes to files within wholesale/      *
      *            universal customer input                           *
      *  CRE026  - Consumer Banking                                   *
      *  BUG12406 - Customer Account Details DBase error              *
      *  BUG12342 - Database error when accepting Customer            *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG10651 - Fiduciary Customer details blanks out during      *
      *             Standing Data Authorisation.                      *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6444- Unable to amend field 71a on the counterparty record*
      *  217230 - Change to Tax/Non-tax indicator should also be      *
      *           send to TOF.                                        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  BUG6552- CSW037 Field 83 (recompile).                        *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4810 - Decimal data error when authorising a customer.    *
      *  BUG5409 - Authorisation of customer closure do not update    *
      *            closure detail on file.                            *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSW037 - AdditionaField Data on MT300/MT320                  *
      *  BUG4967 - Pass TI Customer Details on call to SDCUSDRTV.     *
      *  BUG4668 - Complete bug fix 4692 for another TI file          *
      *  BUG4732 - Database error on SDTICSL0                         *
      *  BUG4692 - Should not access SDTICSL0 when TI module is OFF.  *
      *  BUG4201 - Difference TI Customer Details Audit report        *
      *  BUG3362 - Added processing for TI details changes            *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  BUG2313 - Numerous errors concerning global customer id      *
      *  BUG1986 - System Generated Customer Number.  Parameter mis-  *
      *            match when calling SDCUSDRTV.                      *
      *  CSD021 - System Generated Customer Number.                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSD012 - Standing Data Authorisation                         *
      *  210006 - Add parameter @CNUM for customer before calling     *
      *           SD0012U to prevent program from ending in PGM DUMP. *
      *  202380 - Avoid dump due missing SE module                    *
      *  202931 - In case of more than one amend in a day, no         *
      *           acknowledge is replicated.                          *
      *  201011 - Amended customer details coming from CTL are not    *
      *           processed. Also, no update to BRT participator      *
      *           history details should be done for account holder   *
      *           type R.                                             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - PB Customer Maintenance - Complete fix 175680.      *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  185595 - In case of change of the branch, SDPBDSPD needs to  *
      *           be updated to be reflected to Tof                   *
      *  175680 - PB Customer Maintenance - Fields protection         *
      *  CSD007 - Customer Closing:                                   *
      *           Allow Closure and Release of Customer Records.      *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP034 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************

     FSDALTNL1  IF   E           K DISK
      * Interest Payment File 6
     FINTPSL6   IF   E           K DISK    RENAME(INTPSDDF:INTPSLF6)
     F                                     PREFIX(A_)
      * Interest Payment File 7
     FINTPSL7   IF   E           K DISK    RENAME(INTPSDDF:INTPSLF7)
     F                                     PREFIX(B_)
      * Interest Payment File 8
     FINTPSL8   IF   E           K DISK    RENAME(INTPSDDF:INTPSLF8)
     F                                     PREFIX(C_)
      * RTV : Midas SD Customer marketing groups retrieval
     FSDCMRKL1  IF   E           K DISK

      * UPD : Midas SD Customer Details Master File
     FSDCUSTL0  UF A E           K DISK    COMMIT
     F/COPY WNCPYSRC,SDH00749

      ** UPD : Midas SD Customer Ext Details File                                             CGL132
     FSDCUSXL0  UF A E           K DISK    COMMIT                                             CGL132
     F                                     RENAME(SDCUSTX0:SDCUSTX1)                          CGL132
                                                                                              CGL132
      * UPD : Midas SD Standing Data Controls index
     FSDFCTLL0  UF A E           K DISK    COMMIT
                                                                                              CGL132
      ** FATCA Customer details file                                                          CGL132
     FSDFTCSL0  UF A E           K DISK    COMMIT                                             CGL132
                                                                                              CGL132
      ** Account review details file                                                          CGL132
     FSDACRVL0  UF A E           K DISK    COMMIT                                             CGL132
                                                                                              CGL132
      ** US Indicia Comment History                                                           CGL132
     FSDINCHL0  UF A E           K DISK    COMMIT                                             CGL132

      * UPD : Midas SD Alternate names and address
     FSDALTNL0  UF   E           K DISK    COMMIT

      * UPD : Midas SD Trade Innovation Customer Details
     FSDTICSL0  UF A E           K DISK    COMMIT
     F                                     USROPN

      * UPD : Midas SD Base Rate Tax Details
     FSDCBRTL1  UF A E           K DISK    COMMIT
     F                                     USROPN
     FPTYHSTPD  UF A E           K DISK    COMMIT
     F                                     USROPN

     F**LSDVEBRPTPDO    E             DISK
     F**L                                  RENAME(SDVBRPTPD0:SDVBRPTERR)

      * UPD : Midas SD Private Banking Details
     FSDPBDSL0  UF A E           K DISK    COMMIT
     F                                     PREFIX(D_)
      *                                                                                       CSD012
     FSDAULGL3  UF A E           K DISK    COMMIT                                             CSD012
     F                                     RENAME(SDAULGD0:SDAULGD3)                          CSD012
      * UPD : Authorisation Log - by Function                                                 CSD012
      *                                                                                       CSD012
     FSDCDSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     PREFIX(T_)                                         CSD012
     F                                     RENAME(@BBREBG:SDCDSHD0)                           CSD012
      * UPD : Customer Details Shadow file by key                                             CSD012
      *                                                                                       CSD012
     FSDCBSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     PREFIX(T_)                                         CSD012
     F                                     RENAME(SDCBRTD0:SDCBSHD0)                          CSD012
      * UPD : BRT Customer details Shadow file by key                                         CSD012
      *                                                                                       CSD012
     FSDPBSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     PREFIX(T_)                                         CSD012
     F                                     RENAME(SDPBDSD0:SDPBSHD0)                          CSD012
      * UPD : Private Banking Customer deatails Shadow file by key                            CSD012
     FSDTDSHL0  UF A E           K DISK    COMMIT                                            BUG3362
     F                                     PREFIX(T_)                                        BUG3362
     F                                     RENAME(SDTICSD0:SDTDSHD0)                         BUG3362
      * UPD : Trade Innovation Customer Details shadow file by key                           BUG3362
     FSDSWSHL0  UF A E           K DISK    COMMIT                                           BUG14969
     F                                     PREFIX(T_)                                       BUG14969
     F                                     RENAME(SDSWSHD0:SDSWSHD1)                        BUG14969
      * UPD : Customer Extension SWIFT Details shadow file by key                           BUG14969
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015

      ** UPD : Midas SD Global Customer X-Reference                                           CGP001
     FGPCUSTXL0 UF A E           K DISK    COMMIT                                             CGP001
     F                                     PREFIX(G_)                                         CGP001
                                                                                              CGP001
      ** IDX : Midas GL Accounts                                                              CSD023
     FACCNT     UF   E           K DISK    USROPN                                             CSD023
     F                                     IGNORE(ACCNTAAF)                                   CSD023
     F                                     IGNORE(ACCNTACF)                                   CSD023
                                                                                              CSD023
      ** Midas SD Customer Details Acceptance - Update Index                                  CSD031
     F***SDACSTL0  UF   E           K DISK    COMMIT                                 CSD031 BUG13525
     F**********                           USROPN                                    CSD031 BUG13525
     F**********                           RENAME(SDCUSTD0: SDACSTD0)                CSD031 BUG13525
                                                                                              CSD031
      ** UPD : Midas SD Customer marketing groups update                                      CSD079
     FSDCMRKL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : Midas SD Additional Customer Details update                                    CSD079
     FSDACUSL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : Midas SD Customer Service Fees Details update                                  CSD079
     FSDCFCDL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : Midas SD Customer Cheque Handling Details update                               CSD079
     FSDCHEQL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : Midas SD Customer Safes Details update                                         CSD079
     FSDSAFEL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : Midas SD Future & Options Client update                                        CSD079
     FSDFOCSL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : MIDAS/ABS FF Customers Maintenance- CAD Rtv.                                   CSD079
     FSDFOX1L0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** UPD : Midas SD Portfolio management cust dtls update                                 CSD079
     FSDPLCSL0  UF A E           K DISK    COMMIT    USROPN                                   CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** PM LIVE PORTFOLIOS WITH PERFORMANCE                                                  CSD079
     FPMPORTL1  IF A E           K DISK    COMMIT                                             CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** PM PORTFOLIO DEFINITION AUDIT                                                        CSD079
     FPMPORTPA  UF A E             DISK    COMMIT                                             CSD079
     F                                     INFSR(SRERR)                                       CSD079
                                                                                              CSD079
      ** RSQ : Midas SD Branch codes by customer number                                       CSD079
     FSDBRCHL5  IF   E           K DISK                                                       CSD079
                                                                                              CSD079
      ** Midas PB Template Portfolio                                                          CSD079
     FPBTMPDLL  IF   E           K DISK                                                       CSD079
      *                                                                                       CSW207
      ** UPD : Midas SD Customer Details Swift extension file                                 CSW207
      *                                                                                       CSW207
     FSDCSSWL0  UF A E           K DISK    COMMIT                                             CSW207
                                                                                              CSD079
     FSDACEXL0  O    E             DISK    INFSR(SRERR)                                     MD026499
     F                                     PREFIX(EX)                                       MD026499
                                                                                            MD027115
     FSDJACCL4  IF   E           K DISK    INFSR(SRERR)                                     MD027115
     F                                                                                      MD027115
                                                                                              CGL157
      ** Midas SD CRS Customer Details File                                                   CGL157
     FSDCRSHL0  UF A E           K DISK    COMMIT                                             CGL157
                                                                                              CGL157
      * Midas SD CRS Details File                                                             CGL157
     FSDCRSDL1  UF A E           K DISK    COMMIT                                             CGL157
                                                                                              CGL177
      * Midas SD CRS Details File                                                             CGL177
     FSDCRSDL3  UF A E           K DISK    COMMIT                                             CGL177
     F                                     RENAME(SDCRSDD0:SDCRSDD1)                          CGL177
     F                                     PREFIX(D_)                                         CGL177
                                                                                            MD026499
     F/COPY WNCPYSRC,SDCUSDDF01
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** CSD023 fileds                                                                        CSD023
     D CSD023          S              1                                                       CSD023
     D CSD028          S              1                                                       CSD028
     D PTransType      S              4                                                       CSD028
     D WNewCust        S              1                                                       CSD028
     D PAction         S              1                                                       CSD028
     D PCustNumber     S              6                                                       CSD028
     D ALSTAT          S              1                                                       CSD028
     D APIRetc         S              1                                                       CSD023
                                                                                              CSD023
     D WURDNB          S                   like(BJRDNB)                                       CSD079
     D CSD079          S              1A   inz('N')                                           CSD079
     D S01425          S              1A   inz('N')                                           CSD079
     D CSD008          S              1A   inz('N')                                           CSD079
     D CDL002          S              1A   inz('N')                                           CSD079
     D CDL006          S              1A   inz('N')                                           CSD079
     D CLE134          S              1A   inz('N')                                           CLE134
     D ULX609          S              1A   inz('N')                                           CSD079
     D ULX043          S              1A   inz('N')                                           CSD079
     D CGL018          S              1A                                                      CSD079
     D ULX004          S              1A   inz('N')                                           CSD079
     D CDL025          S              1A   inz('N')                                        AR1086546
     D PMODE           S              1A                                                      CSD079
                                                                                              CSD079
      *Run date DS                                                                            CSD079
     DRUNDAT           DS                                                                     CSD079
     D MRDT                    1      7                                                       CSD079
     D RDNB                    8     10P 0                                                    CSD079
     D W_DLUP                  1      2  0                                                    CSD079
     D W_MLUP                  3      5                                                       CSD079
     D W_YLUP                  6      7  0                                                    CSD079
     D SUC                    11     11                                                       CSD079
     D DFF                    12     12                                                       CSD079
     D MBIN                   13     13                                                       CSD079
     DWUMRDT           DS                                                                     CSD079
     D WUDLUP                  1      2  0                                                    CSD079
     D WUMLUP                  3      5                                                       CSD079
     D WUYLUP                  6      7  0                                                    CSD079
                                                                                              CSD079
      ** Return Code work field                                                               CSD079
     D WURTCD          S              7                                                       CSD079
                                                                                              CSD079
      ** PM-action                                                                            CSD079
     D WUPMAC          S              8                                                       CSD079
                                                                                              CSD079
      ** Book Code                                                                            CSD079
     D WUBKCD          S              2                                                       CSD079
                                                                                              CSD079
      ** Portfolio Reference                                                                  CSD079
     D WUPTRF          S              4                                                       CSD079
                                                                                              CSD079
      ** Portfolio Ref                                                                        CSD079
     D WUSCPF          S              4                                                       CSD079
                                                                                              CSD079
      ** Portfolio Ref                                                                        CSD079
     D WUSCPT          S              4                                                       CSD079
                                                                                              CSD079
      ** Program name                                                                         CSD079
     D WUPGMN          S             10                                                       CSD079
                                                                                              CSD079
      ** Customer Number                                                                      CSD079
     D WUCUST          S              6                                                       CSD079
                                                                                              CSD079
      ** Timestamp for the transaction
     D TimeStamp       S               Z
                                                                                              CGL132
     D SysVal1         C                   'FATCADftCLsNewCustNH'                             CGL132
     D SysVal2         C                   'AcRevDftFreq'                                     CGL132
     D SysVal3         C                   'FATCACountryofTax'                                CGL132

     D ChkCusdFmt    E DS                  EXTNAME(SDCUSTPD)
      ** Rename fields for Timestamp checking
     D                                     PREFIX(CH)
     D/COPY WNCPYSRC,SDH00750
      * Current Customer in File Format (Base Rate Tax Details)
     D CBrtFilFmt    E DS                  EXTNAME(SDCBRTPD)
     D                                     PREFIX(CB_)
      * Current Customer in File Format (Private Banking Details)
     D CPrbFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(CP_)

      ** TI Customer Details in File Format                                                  BUG4967
     D CuTIFilFmt    E DS                  EXTNAME(SDTICSPD)                                 BUG4967
     D                                     PREFIX(Z_)                                        BUG4967
                                                                                             BUG4967
      ** Current Global Customer X-Reference in File Format                                   CGP001
     D CGCuFilFmt    E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
     D                                     PREFIX(CG_)                                        CGP001
     D CrXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID CUSTOMER
     D SDVCUSD       E DS                  EXTNAME(SDVCUSDPD)
     D                                     PREFIX(A_)
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID CUSTOMER - EXT                        CGL132
     D SDVCUXC       E DS                  EXTNAME(SDVCUXCPD)                                 CGL132
     D                                     PREFIX(A_)                                         CGL132
                                                                                              CGL157
      ** Externally desc'd DS for valid CRS detail                                            CGL157
     D SDVCRSD       E DS                  EXTNAME(SDVCRSDPD)                                 CGL157
     D                                     PREFIX(D_)                                         CGL157
                                                                                              CGL157
      ** Externally desc'd DS for valid transactions Detail                                   CGL157
     D SDVCRSH       E DS                  EXTNAME(SDVCRSHPD)                                 CGL157
     D                                     PREFIX(C_)                                         CGL157
     D SDCRSDA       E DS                  EXTNAME(SDCRSDPD)                                  CGL177
     D                                     PREFIX(D_)                                         CGL177
     D SDCRSDB       E DS                  EXTNAME(SDCRSDPD)                                  CGL177
     D                                     PREFIX(E_)                                         CGL177
                                                                                              CGL157
      **  Transaction Details File                                                            CGL157
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)                                  CGL157
                                                                                              CGL157
      **  Transaction Details File                                                            CGL157
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)                                  CGL157
                                                                                              CGL157
      ** Current CRS Transaction Detail in File Format                                        CGL157
     D CrCrsFlFmt    E DS                  EXTNAME(SDCRSHPD)                                  CGL157
     D                                     PREFIX(C_)                                         CGL157
      *                                                                                       CSW207
      **  Externally descrived data structure for valid customer extension                    CSW207
      *                                                                                       CSW207
     D SDVSWSD       E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
     D                                     PREFIX(A_)                                         CSW207
                                                                                            BUG14929
      ** SWIFT Details in File Format                                                       BUG14929
     D SwftFilFmt    E DS                  EXTNAME(SDCSSWPD)                                BUG14929
                                                                                              CGL132
      ** Account Review details                                                               CGL132
     D SDACRVDF      E DS                  EXTNAME(SDACRVPD)                                  CGL132
                                                                                              CGL132
      ** FATCA Customer Details in file format                                                CGL132
     D CuFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132

     D SDECUSD       E DS                  EXTNAME(SDECUPRPD)
      * Error indicators

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR 'BEFORE UPDATE' CUSTOMER
     D B_CUSTD       E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(B_)

      **  CUSTOMERS FILE
     D CUSTDF        E DS                  EXTNAME(SDCUSTPD)
     D CUSTDF2       E DS                  EXTNAME(SDCUSTPD)                                  CGL132
     D                                     PREFIX(N_)                                         CGL132


      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID BASE RATE TAX
     D SDVCUBR       E DS                  EXTNAME(SDVCUBRPD)
     D SDVCUBRsh               1    717                                                       CSD012

     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)                                  CGL132
     D SDFTCS2       E DS                  EXTNAME(SDFTCSPD)                                  CGL132
     D                                     PREFIX(N_)                                         CGL132
     D SDCUXC        E DS                  EXTNAME(SDCUSTXC)                                MD026854
     D SDCUXC2       E DS                  EXTNAME(SDCUSTXC)                                MD026854
     D                                     PREFIX(N_)                                       MD026854
                                                                                            MD026854
      ** Externally described data structure for valid                                        CGL132
      ** FATCA customer details file                                                          CGL132
     D SDVFTCS       E DS                  EXTNAME(SDVFTCSPD)                                 CGL132
     D                                     PREFIX(A_)                                         CGL132
                                                                                              CGL132
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CGL132
                                                                                              CGL132
      ** Transaction Details in File Format                                                   CGL157
     D CrsdFilFmt    E DS                  EXTNAME(SDCRSHPD)                                  CGL157
     D                                     PREFIX(A_)                                         CGL157
      **  BASE RATE TAX DETAILS FILE
     D SDCBRTF       E DS                  EXTNAME(SDCBRTPD)

      **  BRT PARTICIPATOR HISTORY FILE
     D SDPTYHSF      E DS                  EXTNAME(PTYHSTPD)
     D PTY_RECI      E                     EXTFLD(XRECI)
     D PTY_CNUM      E                     EXTFLD(XCNUM)
     D PTY_LCD       E                     EXTFLD(XLCD)
     D PTY_CHTP      E                     EXTFLD(XCHTP)
     D PTY_TNLU      E                     EXTFLD(XTNLU)


      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID PRIVATE BANKING DET
     D SDVCUPB       E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(A_)
      **  Externally Described Data Structure For Valid TI details                           BUG3362
     D SDVTID        E DS                  EXTNAME(SDVTICDPD)                                BUG3362
     D                                     PREFIX(A_)                                        BUG3362
      **  TI Customer Details file                                                           BUG3362
     D SDTICDF       E DS                  EXTNAME(SDTICSPD)                                 BUG3362
      **  Customer Extension SWIFT Details File                                             BUG14969
     D SDCSSWDF      E DS                  EXTNAME(SDCSSWPD)                                BUG14969
     D                                     PREFIX(R_)                                       BUG14969
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID Shadow CUSTOMER                       CSD012
     D SDVCDSH       E DS                  EXTNAME(SDCDSHPD)                                  CSD012
     D                                     PREFIX(T_)                                         CSD012
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID Shadaow BRT CUSTOMER                  CSD012
     D SDVCBSH       E DS                  EXTNAME(SDCBSHPD)                                  CSD012
     D                                     PREFIX(T_)                                         CSD012
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID Shadow PB CUSTOMER                    CSD012
     D SDVPBSH       E DS                  EXTNAME(SDPBSHPD)                                  CSD012
     D                                     PREFIX(T_)                                         CSD012
      **  Externally Described Data Structure for Valid TI shadow files                      BUG3362
     D SDVTDSH       E DS                  EXTNAME(SDTDSHPD)                                 BUG3362
     D                                     PREFIX(T_)                                        BUG3362
      **  Externally Described Data Structure for Valid Customer Extension                  BUG14969
      **  SWIFT Details shadow files                                                        BUG14969
     D SDVSWSH       E DS                  EXTNAME(SDSWSHPD)                                BUG14969
     D                                     PREFIX(T_)                                       BUG14969

      **  PRIVATE BANKING DETAILS FILE
     D*SDCPRBF       E DS                  EXTNAME(SDPBDSPD)

      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      * DATA STRUCTURE FOR General Ledger Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR Midas Modules Details

     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      * DATA STRUCTURE FOR SECURITIES TRADING DETAILS

     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      * DATA STRUCTURE FOR PORTOLIO MANAGEMENT DETAILS

     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      * DATA STRUCTURE FOR SECURITIES CUSTOMER DETAILS
     D  OldAcntCode  E                     EXTFLD(QQACCD)                                     CGL029

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * DATA STRUCTURE FOR CURRENCY DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Midas API Message Header Format Definition                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** Data Structure for SAR Details                                                       CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** Private Banking Details File                                                         CSC011
     D SDPBDF        E DS                  EXTNAME(SDPBDSPD)                                  CSC011
     D                                     PREFIX(W_)                                         CSC011
                                                                                              CSC011
      ** Private Banking Details File                                                         CSD012
     D SDPBDSDF      E DS                  EXTNAME(SDPBDSPD)                                  CSD012
     D                                     PREFIX(D_)                                         CSD012
                                                                                              CSD012
                                                                                              CSD015
      ** Data Structure for Watch List Checking Details                                       CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Data Structure used as first parameter for the Compliance Engine                     CSD015
     D PDSWLTD       E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** Data Structure used as second parameter for the Compliance Engine                    CSD015
     D PDSXML          DS         30000                                                       CSD015
                                                                                              CSD015
      ** Data structure for Private Customer Industry Code                                    CSD015
     D WDSCWCD       E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** Ext. DS for Customer Marketing Info. Details in File Format                          CSD079
     D CUMIFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
     D                                     PREFIX(B1_)                                        CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Marketing Information                                     CSD079
     D SDVCUMI       E DS                  EXTNAME(SDVCUMIPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Marketing Information                          CSD079
     D B_CUMIF       E DS                  EXTNAME(SDCMRKPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Customer Marketing Information File                                                  CSD079
     D CUMIF         E DS                  EXTNAME(SDCMRKPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Additional Details in File Format                               CSD079
     D CUADFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
     D                                     PREFIX(B3_)                                        CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Additional Details                                        CSD079
     D SDVCUAD       E DS                  EXTNAME(SDVCUADPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Additional Details                             CSD079
     D B_CUADF       E DS                  EXTNAME(SDACUSPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Customer Additional Details File                                                     CSD079
     D CUADF         E DS                  EXTNAME(SDACUSPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Service Fees Details in File Format                             CSD079
     D CUFEFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079
     D                                     PREFIX(B5_)                                        CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Service Fees Details                                      CSD079
     D SDVCUFE       E DS                  EXTNAME(SDVSFEEPD)                                 CSD079
     D                                     PREFIX(F_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Service Fees Details                           CSD079
     D B_CUFEF       E DS                  EXTNAME(SDCFCDPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Customer Service Fees Details File                                                   CSD079
     D CUFEF         E DS                  EXTNAME(SDCFCDPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Cheques & Cards Details in File Format                          CSD079
     D CUCQFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
     D                                     PREFIX(B7_)                                        CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Cheques & Cards Details                                   CSD079
     D SDVCUCQ       E DS                  EXTNAME(SDVCHECPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Cheques & Cards Details                        CSD079
     D B_CUCQF       E DS                  EXTNAME(SDCHEQPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Customer Cheques & Cards Details File                                                CSD079
     D CUCQF         E DS                  EXTNAME(SDCHEQPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Safes Details in File Format                                    CSD079
     D CUSFFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
     D                                     PREFIX(B9_)                                        CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Safes Details                                             CSD079
     D SDVCUSF       E DS                  EXTNAME(SDVCUSFPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Safes Details                                  CSD079
     D B_CUSFF       E DS                  EXTNAME(SDSAFEPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Customer Safes Details File                                                          CSD079
     D CUSFF         E DS                  EXTNAME(SDSAFEPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Risk Weighted Assets Details in File Format                     CSD079
     D CURWFilFmt    E DS                  EXTNAME(SDCRWAPD)                                  CSD079
     D                                     PREFIX(B11_)                                       CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Risk Weighted Assets Details                              CSD079
     D SDVCURW       E DS                  EXTNAME(SDVRWANPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Risk Weighted Assets Details                   CSD079
     D B_CURWF       E DS                  EXTNAME(SDCRWAPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Customer Risk Weighted Assets Details File                                           CSD079
     D CURWF         E DS                  EXTNAME(SDCRWAPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Futures & Option Details in File Format                         CSD079
     D CUFOFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D                                     PREFIX(B13_)                                       CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Futures & Option Details                                  CSD079
     D SDVCUFO       E DS                  EXTNAME(SDVCUFOPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Futures & Option Details                       CSD079
     D B_CUFOF       E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
     D  B_QQQMAC     E                     EXTFLD(QQSMAC)                                     CSD079
                                                                                              CSD079
      ** Customer Futures & Option Details File                                               CSD079
     D CUFOF         E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D    QQQMAC     E                     EXTFLD(QQSMAC)                                     CSD079
                                                                                              CSD079
      ** Ext. DS for MIDAS/ABS FF Customers Maintenance in File Format                        CSD079
     D CUFFFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Valid MIDAS/ABS FF Customers Maintenance Details                         CSD079
     D SDVCUFF       E DS                  EXTNAME(SDVFOX1PD)                                 CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of MIDAS/ABS FF Customers Maintenance Details              CSD079
     D B_CUFF        E DS                  EXTNAME(SDFOX1PD)                                  CSD079
     D                                     PREFIX(B21_)                                       CSD079
                                                                                              CSD079
     ** MIDAS/ABS FF Customers Maintenance Details File                                       CSD079
     D CUFF          E DS                  EXTNAME(SDFOX1PD)                                  CSD079
     D                                     PREFIX(B22_)                                       CSD079
                                                                                              CSD079
      ** Ext. DS for Customer Portfolio Mgmt. Details in File Format                          CSD079
     D CUPMFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
     D                                     PREFIX(B15_)                                       CSD079
                                                                                              CSD079
      ** Ext. DS for Valid Customer Portfolio Mgmt. Details                                   CSD079
     D SDVCUPM       E DS                  EXTNAME(SDVCUPMPD)                                 CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Customer Portfolio Mgmt. Details                        CSD079
     D B_CUPMF       E DS                  EXTNAME(SDPLCSPD)                                  CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Customer Portfolio Mgmt. Details File                                                CSD079
     D CUPMF         E DS                  EXTNAME(SDPLCSPD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Lux(European Reporting)Customer Details in File Format                   CSD079
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Lux(European Reporting)Customer Details in valid format                  CSD079
     D SDVCUEU       E DS                  EXTNAME(SDVCULX2PD)                                CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
      ** Lux(European Reporting)Customer Details File format                                  CSD079
     D CUEUF         E DS                  EXTNAME(SDCUX2PD)                                  CSD079
     D                                     PREFIX(R_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Lux(European Reporting) File format                     CSD079
     D B_CUEUF       E DS                  EXTNAME(SDCUX2PD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Lux(IBLC - Extended Information) in File Format                          CSD079
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CSD079
                                                                                              CSD079
      ** Ext. DS for Lux(IBLC - Extended Information)Details in valid format                  CSD079
     D SDVCUIB       E DS                  EXTNAME(SDVCULX1PD)                                CSD079
     D                                     PREFIX(A_)                                         CSD079
                                                                                              CSD079
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX(TX)                                         CER059
                                                                                              CER059
      ** Lux(IBLC - Extended Information)Customer Details File format                         CSD079
     D CUIBF         E DS                  EXTNAME(SDCUX1PD)                                  CSD079
     D                                     PREFIX(S_)                                         CSD079
                                                                                              CSD079
      ** Ext. DS for Before Update of Lux(IBLC - Extended Information) File format            CSD079
     D B_CUIBF       E DS                  EXTNAME(SDCUX1PD)                                  CSD079
     D                                     PREFIX(B_)                                         CSD079
                                                                                              CSD079
     D SDVSW13       E DS                  EXTNAME(SDSW13PD)                                  CFT050
     D                                     PREFIX(S13)                                        CFT050
     D TranInPrim    E DS                  EXTNAME(SDCUPRPD)                                  CFT050
     D TranInSeco    E DS                  EXTNAME(SDCUSEPD)                                  CFT050
     D TranInMT3X    E DS                  EXTNAME(SDCUMTPD)                                  CFT050
     D***ZMUSER*       DS            17                                            MD026835 MD027492
     D**WUSRID**               1     10                                            MD026835 MD027492
     D/COPY WNCPYSRC,SDCUSDDD02
      ** Ext. DS for Curency/Time of Netting Details in File Format                        AR1086546
     D*CTNMFilFmt    E DS                  EXTNAME(SDCTNMPD)                     AR1086546 MD038401B
     D CTNMFilFmt    E DS                  EXTNAME(SDVCTNMPD)                              MD038401B
     D                                     PREFIX(NF_)                                     AR1086546
                                                                                           AR1086546
      ** Ext. DS for Valid Curency/Time of Netting Details                                 AR1086546
     D SDVCTNM       E DS                  EXTNAME(SDVCTNMPD)                              AR1086546
     D                                     PREFIX(NV_)                                     AR1086546
                                                                                           AR1086546
      ** Ext. DS for Before Update of Valid Curency/Time of Netting Details                AR1086546
     D B_CTNMF       E DS                  EXTNAME(SDCTNMPD)                               AR1086546
     D                                     PREFIX(NB_)                                     AR1086546
                                                                                           AR1086546
      ** Valid Curency/Time of Netting Details File                                        AR1086546
     D CTNMF         E DS                  EXTNAME(SDCTNMPD)                               AR1086546
                                                                                           AR1086546
      *                                                                                     MD055373
      ** Insert User (DDIUSR) and Amend User (DDAUSR) details layout                        MD055373
     D SDVTransUser    DS                                                                   MD055373
     D  SDIUSER                      10A                                                    MD055373
     D  SDAUSER                      10A                                                    MD055373
      *                                                                                     MD055373
     D  SDAAUTH        S              1A                                                    MD055373
      *                                                                                     MD055373
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      * I :  File name
     D    PBFNME               1     10
      * I :  Long Key
     D    PBLKEY              11     60
      * I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      * I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      * I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      * I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      * I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      * I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      * I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      * I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      * I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      * I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      * I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      * I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      * I :  Last Change Date
     D    PBLCD             3061   3063P 0
      * I :  Type of Last Change
     D    PBTYLC            3064   3064

     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000

     D @Timestamp      S             26Z


     D                 DS
     D TDATE                   1      6
     D TDAY                    1      2
     D TMONTH                  3      4
     D TYEAR                   5      6

     D                 DS
     D  DATE                   1      6
     D  DAY                    1      2  0
     D  MONTH                  3      4  0
     D  YEAR                   5      6  0

     D LFLG            S              1    DIM(10)
      ** Liable Flag Array

     D                 DS
      ** Effective dates array and DS
     D  EFFLDA                 1     30
     D  EFLD                   1     30P 0 INZ(0)
     D                                     DIM(10)                              EFFECT. DATE ARR

     D                 DS
      ** Liability change dates array and DS
     D  LCHGDA                 1     30
     D  LCHD                   1     30P 0 INZ(0)
     D                                     DIM(10)                              LIAB.CHG. DTE ARR
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
     D KCUST           S              6A                                                      CGL132
     D KSCDT           S              5P 0                                                    CGL132
     D KSEQN           S              3S 0                                                    CGL132
     D AVSEQN          S              3S 0                                                    CGL132
     D WWTMST          S             26Z                                                      CGL132
     D XBefCRSD        S           5000A                                                    MD041429
     D XAftCRSD        S           5000A                                                    MD041429
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D***PCustNum        S             18A                                             CSC011 CGL029
     D***PACustNo        S             18A                                             CSC011 CGL029
     D PCustNum        S             24A                                                      CGL029
     D PACustNo        S             24A                                                      CGL029
     D PTimestamp      S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WCust           S              6A                                                      CSC011
                                                                                              CSD021
     D CSD021          S              1A                                                      CSD021
     D CSD090          S              1A                                                      CSD090
     D*New_CNUM*****   S              6  0                                             CSD021 CSD027
     D New_CNUM        S              6A                                                      CSD027
     D New_CNUMOK      S              1A                                                      CSD021
     D CGL132          S              1A                                                      CGL132
     D CGL133          S              1A                                                      CGL132
     D WWHVAC          S              1A                                                      CGL132

      ** Fields defined for Enhancement CSD012 used for SDAULGL3                              CSC011
     D FUNCD           C                   CONST('CUSTOMER DETAILS')                          CSD012
      ***Override*SDCDSHL0,*SDCBSHL0*&*SDPBSHL0****************************           CSD012 BUG3362
      ** Override SDCDSHL0, SDCBSHL0, SDPBSHL0 and SDTDSHL0                                  BUG3362
     D CMD1            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CMD2            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CMD3            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CMD4            S              1    DIM(50) CTDATA PERRCD(50)                         BUG3362
     D CMD5            S              1    DIM(50) CTDATA PERRCD(50)                        BUG14969
     D CMDXC           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D CMDNH           S             50    DIM(1) CTDATA PERRCD(1)                          MD027115
     D CMDCS           S             50    DIM(1) CTDATA PERRCD(1)                          MD027115
     D CMDCR           S             50    DIM(1) CTDATA PERRCD(1)                          MD051230
                                                                                              CSD015
      ** Array containing the tags for the XML format parameter                               CSD015
     D****ARRTAG       S             40    DIM(10) CTDATA                              CSD015 CSD079
     D ARRTAG          S             40    DIM(14) CTDATA                                     CSD079
                                                                                              CSD027
      ** Array for "Adding" 1 to the Alphanumeric customer number                             CSD027
                                                                                              CSD027
     D #@VC            S              1    DIM(36) CTDATA PERRCD(36)                          CSD027
     D #@CN            S              1    DIM(6)                                             CSD027
                                                                                              CSD015
      ** Fields defined for Enhancement CSD015                                                CSD015
                                                                                              CSD015
     D PFNCCD          S              8A                                                      CSD015
     D WFUNCTYPE       S              8A                                                      CSD015
     D WIDNTIFIER      S             40A                                                      CSD015
     D WBRANCH         S              3A                                                      CSD015
     D CCF001          S              1A                                                      CSD015
     D CSD015          S              1A                                                      CSD015
     D PINDATE         S              5A                                                      CSD015
     D POUTDATE        S               D                                                      CSD015
     D PCVTDDATE       S             10A                                                      CSD015
     D WADDAL          S            100A                                                      CSD015
     D WUNCF1          S              1A                                                      CSD015
                                                                                              CGP001
     D K_BRCD          S              3A                                                      CGP001
     D K_CUST          S              6A                                                      CGP001
                                                                                              CGP001
     D CFX001          S              1                                                       CFX001
     D CLE025          S              1                                                       CLE025
                                                                                              CLE025
     D                 DS                                                                     CSD023
     D**w0cnum***              1      6  0                                             CSD023 CSD027
     D  w0cnum                 1      6                                                       CSD027
     D  w0ccy                  7      9                                                       CSD023
     D  w0acod                10     19  0                                                    CSD023
     D  w0acsq                20     21  0                                                    CSD023
     D  w0brca                22     24                                                       CSD023
                                                                                              CSD023
     D                 DS                                                                     CSD023
     D w1accn                  1     24                                                       CSD023
     D  w1brca                 1      3                                                       CSD023
     D**w1cnum****             4      9  0                                             CSD023 CSD027
     D  w1cnum                 4      9                                                       CSD027
     D  w1ccy                 10     12                                                       CSD023
     D  w1acod                13     22  0                                                    CSD023
     D  w1acsq                23     24  0                                                    CSD023
                                                                                              CSD023
     D***PAccMde       S              1A                                             CSD031 BUG13525
     D***PUpdYN*       S              1A                                             CSD031 BUG13525
     D***PChkAccMde    S              1A                                             CSD031 BUG13525
     D***PChkUpdYN     S              1A                                             CSD031 BUG13525
     D PAccMde         S              1A                                                    BUG15872
     D PUpdYN          S              1A                                                    BUG15872
     D PChkAccMde      S              1A                                                    BUG15872
     D PChkUpdYN       S              1A                                                    BUG15872
     D***CSD037*       S              1A   INZ('N')                  C                SD031 BUG13525
                                                                                              CSD031
      ** Variables used by CSD079                                                             CSD079
     D WUPMSC          S              1A                                                      CSD079
     D WQ0035          S              7A                                                      CSD079
     D WQ0036          S              8A                                                      CSD079
     D WQ0037          S              6A                                                      CSD079
     D WQ0038          S              2A                                                      CSD079
     D WQ0039          S              4A                                                      CSD079
     D WQ0040          S              4A                                                      CSD079
     D WQ0041          S              4A                                                      CSD079
     D WQ0042          S             10A                                                      CSD079
     D WQ0086          S              7A                                                      CSD079
     D WQ0087          S              6A                                                      CSD079
     D WQ0088          S              3A                                                      CSD079
     D WQ0089          S              1A                                                      CSD079
     D WQ0090          S              2P 0                                                    CSD079
     D WQ0091          S              5P 0                                                    CSD079
     D WQ0092          S             10A                                                      CSD079
     D WQ0093          S              1A                                                      CSD079
     D WQ0094          S              2A                                                      CSD079
     D WQ0095          S             18A                                                      CSD079
     D WQ0096          S              8A                                                      CSD079
     D WQ0097          S              1A                                                      CSD079
     D WQ0098          S             20A                                                      CSD079
     D WQ0099          S              1A                                                      CSD079
     D WQ0100          S              5P 0                                                    CSD079
     D WQ0101          S              1A                                                      CSD079
     D WQ0102          S              2P 0                                                    CSD079
     D WQ0103          S              5P 0                                                    CSD079
     D WQ0104          S              1A                                                      CSD079
     D WQ0105          S              1A                                                      CSD079
     D WQ0106          S             20A                                                      CSD079
     D WQ0107          S              2P 0                                                    CSD079
     D WQ0108          S              3A                                                      CSD079
     D WQ0109          S              1A                                                      CSD079
     D WQ0110          S              5P 0                                                    CSD079
     D #1DFPO          S              4A                                                      CSD079
     D WURITD          S              1A                                                      CSD079
     D From_Cust       S              1A                                                      CSD079
     D WFIND           S              1A                                                      CSD079
     D ZDATE           S              6P 0                                                    CSD079

      *
     D/COPY WNCPYSRC,SDCUSDDD01


      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1A                                                      CSW207
     D CFT050          S              1A                                                      CFT050
     D CSW213          S              1A                                                    MD028198
                                                                                              CSD092
     D CSD092          S              1A   INZ('N')                                           CSD092
     D PCUST           S              6A                                                      CSD092
     D PCustNo         S              6A                                                      CGL132
     D WCTAX           S              2A                                                      CGL132
     D PBefCUST        S           5000A                                                      CSD092
     D PAftCUST        S           5000A                                                      CSD092
     D PBefACUS        S           5000A                                                      CSD092
     D PAftACUS        S           5000A                                                      CSD092
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefJACC        S           5000A                                                      CSD092
     D PAftJACC        S           5000A                                                      CSD092
     D PBefCUAH        S           5000A                                                      CSD092
     D PAftCUAH        S           5000A                                                      CSD092
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D PBefCRSH        S           5000A                                                      CGL177
     D PAftCRSH        S           5000A                                                      CGL177
     D PBefCRSD        S           5000A                                                      CGL177
     D PAftCRSD        S           5000A                                                      CGL177
     D PACRV           S              1A                                                      CSD092
     D PELEC           S              1A                                                      CGL132
     D WTime           S               T                                                      CGL132
     D WWTIME          S              6A                                                      CGL132
     D***WKUSER*       S             10A                                           MD026835 MD027492
     D WLUSER          S             10A                                                   MD026835A
     D CTI006          S              1A                                                    MD030956
     D PCommitCUSD     S              1A                                                    MD043029
     D PCommitNAHL     S              1A                                                    MD043029
     D PCrsdF          S            219A   DIM(30)                                            CGL177
     D PCrsdX          S            219A   DIM(30)                                            CGL177
     D PCrsdZ          S            219A                                                      CGL177
     D CGL157          S              1A                                                      CGL157
     D KCTRY           S              2A                                                      CGL157
     D X               S              2S 0                                                    CGL157
     D A               S              4S 0                                                    CGL177

      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD

     C     @@RTCD        IFNE      *BLANKS
     C                   GOTO      EXIT
     C                   END
      *                                                                                     AR679445
      ** Get User profile to populate Insert or Amend User                                  AR679445
      *                                                                                     AR679445
     C                   CALL      'SFC000026'                                              AR679445
     C                   PARM      *BLANKS       USER             10                        AR679445
      *                                                                                     AR679445
     C     *BLANKS       IFNE      USER                                                     AR679445
     C                   MOVE      USER          WKUSER           10                        AR679445
     C                   ELSE                                                               AR679445
     C                   MOVE      PSUSER        WKUSER                                     AR679445
     C                   ENDIF                                                              AR679445
      *                                                                                       CSD012
      * Auth Req is ON and Auth Mode is not 'X' .                                             CSD012
     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     'N'           YESUPDAT          1                          CSD012
     C                   MOVEL     'N'           WNewCust                                     CSD028
      *                                                                                       CSD012
     C                   MOVEL     A_CUTYLC      WorkCHTP          1                          CSD012
     C                   Z-ADD     A_CULCD       WorkLCD           5 0                        CSD012
     C                   MOVEL     *BLANK        A_CUTYLC                                     CSD012
     C                   Z-ADD     *ZERO         A_CULCD                                      CSD012
      *                                                                                       CSD012
     C     A_CUCUST      CHAIN     SDCUSTL0                           99                      CSD012
      *                                                                                       CSD012
     C     *IN99         IFEQ      *OFF                                                       CSD012
     C                   MOVEL     *BLANK        BBTYLC                                       CSD012
     C                   Z-ADD     *ZERO         BBLCD                                        CSD012
      *                                                                                       CSD012
     C     CUSTDF        IFEQ      SDVCUSD                                                    CSD012
     C     WorkCHTP      ANDEQ     'A'                                                        CSD012
     C                   MOVEL     'N'           YESUPDAT                                     CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
      *                                                                                       CSD028
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   EVAL      WNewCust = 'Y'                                             CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     WorkCHTP      A_CUTYLC                                     CSD012
     C                   Z-ADD     WorkLCD       A_CULCD                                      CSD012
      *                                                                                       CSD012
     C     S01383        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     BRCHTP        WorkCHTP                                     CSD012
     C                   Z-ADD     BRXLCD        WorkLCD                                      CSD012
     C                   MOVEL     *BLANK        BRCHTP                                       CSD012
     C                   Z-ADD     *ZERO         BRXLCD                                       CSD012
      *                                                                                       CSD012
     C     BRCNUM        CHAIN     SDCBRTL1                           98                      CSD012
      *                                                                                       CSD012
     C     *IN98         IFEQ      *OFF                                                       CSD012
     C                   MOVEL     *BLANK        XCHTP                                        CSD012
     C                   Z-ADD     *ZERO         XLCD                                         CSD012
      *                                                                                       CSD012
     C     SDCBRTF       IFEQ      SDVCUBRsh                                                  CSD012
     C     WorkCHTP      ANDEQ     'A'                                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     WorkCHTP      BRCHTP                                       CSD012
     C                   Z-ADD     WorkLCD       BRXLCD                                       CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     BGN4ST        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVE      A_CUTYLC      A_PBCHTP                                     CSD012
     C                   MOVE      A_PBCHTP      WorkCHTP                                     CSD012
     C                   MOVE      A_CUCUST      A_PBCNUM                                     CSD012
      *                                                                                       CSD012
     C     WorkCHTP      IFEQ      'I'                                                        CSD012
     C                   MOVE      BJRDNB        A_PBLCHD                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   Z-ADD     A_PBLCHD      WorkLCD                                      CSD012
     C                   MOVEL     *BLANK        A_PBCHTP                                     CSD012
     C                   Z-ADD     *ZERO         A_PBLCHD                                     CSD012
      *                                                                                       CSD012
     C     A_PBCNUM      CHAIN     SDPBDSL0                           98                      CSD012
      *                                                                                       CSD012
     C     *IN98         IFEQ      *OFF                                                       CSD012
     C                   MOVEL     *BLANK        D_PBCHTP                                     CSD012
     C                   Z-ADD     *ZERO         D_PBLCHD                                     CSD012
      *                                                                                       CSD012
     C     SDPBDSDF      IFEQ      SDVCUPB                                                    CSD012
     C     WorkCHTP      ANDEQ     'A'                                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     WorkCHTP      A_PBCHTP                                     CSD012
     C                   Z-ADD     WorkLCD       A_PBLCHD                                     CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                            BUG14969
      ** Process Customer Extension SWIFT Details                                           BUG14969
                                                                                            BUG14969
     C                   EVAL      A_CUCUSD = A_CUCUST                                      BUG14969
     C     A_CUCUSD      CHAIN     SDCSSWL0                                                 BUG14969
     C                   IF        NOT %FOUND                                               BUG14969
     C                   EVAL      YESUPDAT = 'Y'                                           BUG14969
     C                   ELSE                                                               BUG14969
     C                   IF        SDCSSWDF = SDVSWSD AND WorkCHTP = 'A'                    BUG14969
     C                   ELSE                                                               BUG14969
     C                   EVAL      YESUPDAT = 'Y'                                           BUG14969
     C                   ENDIF                                                              BUG14969
     C                   ENDIF                                                              BUG14969
      *                                                                                      BUG3362
      ** Do processing to TI shadow files                                                    BUG3362
      *                                                                                      BUG3362
     C     BGN3ST        IFEQ      'Y'                                                       BUG4692
      *                  MOVE      A_CUCUST      A_TCCUST          6                         BUG3362
     C     BBTICS        ANDEQ     'Y'                                                       BUG4732
     C     BGN3ST        OREQ      'Y'                                                       BUG4732
     C     WBBTICS       ANDEQ     'D'                                                       BUG4732
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     BBTICS        ANDEQ     'Y'                                                      MD030956
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     WBBTICS       ANDEQ     'D'                                                      MD030956
     C     A_TCCUST      CHAIN     SDTICSL0                           77                     BUG3362
      *                                                                                      BUG3362
     C     *IN77         IFEQ      *OFF                                                      BUG3362
     C                   MOVEL     *BLANK        TCTYLC                                      BUG3362
     C                   Z-ADD     *ZERO         TCLCD                                       BUG3362
      *                                                                                      BUG3362
     C     SDTICDF       IFEQ      SDVTID                                                    BUG3362
     C     WorkCHTP      ANDEQ     'A'                                                       BUG3362
      *                                                                                      BUG3362
     C                   ELSE                                                                BUG3362
     C                   MOVEL     'Y'           YESUPDAT                                    BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ELSE                                                                BUG3362
     C                   MOVEL     'Y'           YESUPDAT                                    BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     WorkCHTP      TCTYLC                                      BUG3362
      *                                                                                      BUG3362
     C                   ENDIF                                                               BUG4732
      *                                                                                       CSD012
     C     YESUPDAT      IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
      * If record does not exist write details to customer shadow file                        CSD012
     C     A_CUCUST      CHAIN     SDCDSHL0                           93                      CSD012
     C******IN93         IFEQ      *ON                                               CSD012 BUG10651
     C     *IN93         IFEQ      *OFF                                                     BUG10651
     C                   EVAL      A_CUCOMG = T_BBCOMG                                      BUG10651
     C                   EVAL      A_CUCHRG = T_BBCHRG                                      BUG10651
     C                   EVAL      A_CUAGNT = T_BBAGNT                                      BUG10651
     C                   EVAL      A_CUAGNP = T_BBAGNP                                      BUG10651
     C                   EVAL      A_CUTRAS = T_BBTRAS                                      BUG10651
     C                   EVAL      A_CUNAR1 = T_BBNAR1                                      BUG10651
     C                   EVAL      A_CUNAR2 = T_BBNAR2                                      BUG10651
     C                   EVAL      A_CUNAR3 = T_BBNAR3                                      BUG10651
     C                   EVAL      A_CUNAR4 = T_BBNAR4                                      BUG10651
     C                   EVAL      A_CUDFAC = T_BBDFAC                                      BUG10651
     C                   EVAL      A_CUDFAS = T_BBDFAS                                      BUG10651
     C                   ENDIF                                                              BUG10651
                                                                                            BUG10651
     C                   MOVEL     SDVCUSD       SDVCDSH                                      CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C                   EVAL      T_BBSSDT=0                                                 CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBSSDT=A_CUSSDT                                          CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C                   EVAL      T_BBLCD=BJRDNB                                             CSD012
     C                   EVAL      T_BBTYLC='I'                                               CSD012
     C                   EVAL      T_BBLALD=0                                                 CSD012
     C                   EVAL      T_BBLDHD=0                                                 CSD012
     C                   EVAL      T_BBLRLD=0                                                 CSD012
     C                   EVAL      T_BBDTDL=0                                                 CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'A'                                                        CSD012
     C     A_CUTYLC      OREQ      'C'                                                        CSD012
     C     A_CUTYLC      OREQ      'R'                                                        CSD012
     C                   EVAL      T_BBLCD=BJRDNB                                             CSD012
     C     PTransType    IFNE      'AUTH'                                                     CSD028
     C                   EVAL      T_BBTYLC='A'                                               CSD012
     C                   ELSE                                                                 CSD028
     C                   EVAL      T_BBTYLC='I'                                               CSD028
     C                   ENDIF                                                                CSD028
     C                   EVAL      T_BBLALD=A_CULALD                                          CSD012
     C                   EVAL      T_BBLDHD=A_CULDHD                                          CSD012
     C                   EVAL      T_BBLRLD=A_CULRLD                                          CSD012
     C                   EVAL      T_BBDTDL=A_CUDTDL                                          CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'D'                                                        CSD012
     C                   EVAL      T_BBLCD=BJRDNB                                             CSD012
     C                   EVAL      T_BBTYLC='D'                                               CSD012
     C                   EVAL      T_BBLALD=A_CULALD                                          CSD012
     C                   EVAL      T_BBLDHD=A_CULDHD                                          CSD012
     C                   EVAL      T_BBLRLD=A_CULRLD                                          CSD012
     C                   EVAL      T_BBDTDL=BJRDNB                                            CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFNE      'I'                                                        CSD012
     C     A_CUTYLC      ANDNE     'A'                                                        CSD012
     C     A_CUTYLC      ANDNE     'D'                                                        CSD012
     C     A_CUTYLC      ANDNE     'C'                                                        CSD012
     C     A_CUTYLC      ANDNE     'R'                                                        CSD012
     C                   EVAL      T_BBLCD=A_CULCD                                            CSD012
     C                   EVAL      T_BBTYLC=A_CUTYLC                                          CSD012
     C                   EVAL      T_BBLALD=A_CULALD                                          CSD012
     C                   EVAL      T_BBLDHD=A_CULDHD                                          CSD012
     C                   EVAL      T_BBLRLD=A_CULRLD                                          CSD012
     C                   EVAL      T_BBDTDL=A_CUDTDL                                          CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C                   EVAL      T_BBORED=BJRDNB                                            CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBORED=A_CUORED                                          CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C                   EVAL      T_BBNET='N'                                                CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBNET=A_CUNET                                            CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C                   EVAL      T_BBNTCP='N'                                               CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBNTCP=A_CUNTCP                                          CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C                   EVAL      T_BBNTMM='N'                                               CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBNTMM=A_CUNTMM                                          CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If CSC011 is installed, supply a Front Office ID for the                             CSD012
      ** transaction even if it originated from SIN module.                                   CSD012
     C                   IF        (A_CUTYLC = 'I') AND (CSC011 = 'Y')                        CSD012
     C                   IF        T_BBFRNT = *BLANKS                                         CSD012
     C                   EVAL      T_BBFRNT = 'MD' + A_CUCUST                                 CSD012
     C                   ENDIF                                                                CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBFRNT =A_CUFRNT                                         CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'C'                                                        CSD012
     C                   EVAL      T_BBCLDT=BJRDNB                                            CSD012
     C                   EVAL      T_BBCLST='Y'                                               CSD012
      *                                                                                       CSD012
     C                   ELSE                                                                 CSD012
     C     A_CUTYLC      IFEQ      'R'                                                        CSD012
     C                   EVAL      T_BBCLDT=BJRDNB                                            CSD012
     C                   EVAL      T_BBCLST=' '                                               CSD012
      *                                                                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      T_BBCLDT=A_CUCLDT                                          CSD012
     C                   EVAL      T_BBCLST=A_CUCLST                                          CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'I'                                                        CSD012
     C     A_CUTYLC      OREQ      'A'                                                        CSD012
      *                                                                                       CSD012
     C     CSW024        IFEQ      'Y'                                                        CSD012
     C     BGMSDL        ANDEQ     'Y'                                                        CSD012
     C                   EVAL      T_BBCORP = A_CUCORP                                        CSD012
     C                   EVAL      T_BBCBEI = A_CUCBEI                                        CSD012
     C                   EVAL      T_BBRI01 = A_CURI01                                        CSD012
     C                   EVAL      T_BBRI02 = A_CURI02                                        CSD012
     C                   EVAL      T_BBRI03 = A_CURI03                                        CSD012
     C                   EVAL      T_BBRI04 = A_CURI04                                        CSD012
     C                   EVAL      T_BBRI05 = A_CURI05                                        CSD012
     C                   EVAL      T_BBFUND = A_CUFUND                                        CSD012
     C     CSW037        IFEQ      'Y'                                                        CSW037
     C                   EVAL      T_BBFNAC = A_CUFNAC                                        CSW037
     C                   ENDIF                                                                CSW037
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If a Front Office transaction set timestamp to that of                               CSD012
      ** original record's to prevent timestamp problems when authorising.                    CSD012
     C     @Type         IFEQ      '0'                                                        CSD012
     C     A_CUTYLC      ANDNE     'I'                                                        CSD012
     C                   MOVEL     CHBBTMST      T_BBTMST                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        *IN93 = *ON                                                CSD028
     C                   WRITE     SDCDSHD0                                                   CSD012
      *                                                                                       CSD028
      ** If record is found in the shadoe file, issue update instead of write                 CSD028
      *                                                                                       CSD028
     C                   ELSE                                                                 CSD028
     C**********         IF        CSD028 = 'Y' AND PTransType = 'AUTH'              CSD028 BUG10651
     C                   UPDATE    SDCDSHD0                                                   CSD028
     C**********         ENDIF                                                       CSD028 BUG10651
      *                                                                                       CSD028
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     S01383        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
      * If record does not exist write details BRT customer shadow file                       CSD012
     C     BRCNUM        CHAIN     SDCBSHL0                           93                      CSD012
      *                                                                                       CSD012
     C******IN93         IFEQ      *ON                                                 CSD012 CSD028
     C                   MOVEL     SDVCUBR       SDVCBSH                                      CSD012
     C                   IF        WNewCust = 'Y'                                             CSD028
     C                   EVAL      T_XCHTP = 'I'                                              CSD028
     C                   ENDIF                                                                CSD028
     C                   IF        *IN93 = *ON                                                CSD028
     C                   WRITE     SDCBSHD0                                                   CSD012
     C                   ELSE                                                                 CSD028
     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                       CSD028
     C                   UPDATE    SDCBSHD0                                                   CSD028
     C                   EVAL      ALSTAT = *BLANKS                                           CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     BGN4ST        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Private banking shadow file                 CSD012
     C     A_PBCNUM      CHAIN     SDPBSHL0                           93                      CSD012
      *                                                                                       CSD012
     C******IN93         IFEQ      *ON                                                 CSD012 CSD028
     C                   MOVEL     SDVCUPB       SDVPBSH                                      CSD012
      *                                                                                       CSD012
     C     A_CUTYLC      IFEQ      'D'                                                        CSD012
     C                   MOVEL     'C'           T_PBRECI                                     CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'D'           T_PBRECI                                     CSD012
     C                   ENDIF                                                                CSD012
     C                   EVAL      T_PBLCHD=BJRDNB                                            CSD012
     C                   EVAL      T_PBCHTP = A_CUTYLC                                        CSD012
     C                   EVAL      T_PBTMES = T_BBTMST                                        CSD012
      *                                                                                       CSD012
      ** If CSC011 is installed, supply a Front Office ID for the                             CSD012
      ** transaction even if it originated from SIN module.                                   CSD012
                                                                                              CSD012
     C                   IF        (CSC011 = 'Y') AND (A_CUTYLC = 'I')                        CSD012
     C                   IF        T_PBFRNT = *BLANKS                                         CSD012
     C                   EVAL      T_PBFRNT = BBFRNT                                          CSD012
     C                   ENDIF                                                                CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     A_PBFRNT      T_PBFRNT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        *IN93 = *ON                                                CSD028
     C                   WRITE     SDPBSHD0                                                   CSD012
     C                   ELSE                                                                 CSD028
     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                       CSD028
     C                   UPDATE    SDPBSHD0                                                   CSD028
     C                   EVAL      ALSTAT = *BLANKS                                           CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                            BUG14969
      ** For Customer Extension SWIFT Details: Write to corresponding shadow file           BUG14969
      ** if record does not exist.                                                          BUG14969
                                                                                            BUG14969
     C     A_CUCUSD      CHAIN     SDSWSHL0                                                 BUG14969
     C                   EVAL      SDVSWSH = SDVSWSD                                        BUG14969
     C                   IF        NOT %FOUND                                               BUG14969
     C                   EVAL      T_CSBRCA = A_CUBRCD                                      BUG14969
     C                   WRITE     SDSWSHD1                                                 BUG14969
     C                   ELSE                                                               BUG14969
     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                     BUG14969
     C                   UPDATE    SDSWSHD1                                                 BUG14969
     C                   EVAL      ALSTAT = *BLANKS                                         BUG14969
     C                   ENDIF                                                              BUG14969
     C                   ENDIF                                                              BUG14969
      *                                                                                      BUG3362
      ** FOR TI details                                                                      BUG3362
      *                                                                                      BUG3362
      * If record does not exist write details to TI Customer Details shadow file            BUG3362
     C     BGN3ST        IFEQ      'Y'                                                       BUG4668
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     A_TCCUST      IFNE      *BLANKS                                                   BUG3362
     C     A_TCCUST      CHAIN     SDTDSHL0                           76                     BUG3362
      *                                                                                      BUG3362
     C******IN76         IFEQ      *ON                                                BUG3362 CSD028
     C                   MOVEL     SDVTID        SDVTDSH                                     BUG3362
      *                                                                                      BUG3362
      ** EVAL the varaiables needed                                                          BUG3362
      *                                                                                      BUG3362
     C                   IF        *IN76 = *ON                                                CSD028
     C                   WRITE     SDTDSHD0                                                  BUG3362
     C                   ELSE                                                                 CSD028
     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                       CSD028
     C                   UPDATE    SDTDSHD0                                                   CSD028
     C                   EVAL      ALSTAT = *BLANKS                                           CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG4668
      *                                                                                      BUG3362
                                                                                              CSC015
      ** If CSD015 = 'Y' and watch list checking applied                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                             AND W1EWLC = 'Y'                                           CSD015
                                                                                              CSD015
      ** If user is in the main system                                                        CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y'                                              CSD015
     C                             OR CSC011 = 'Y' AND S1MAIN = LIBR                          CSD015
                                                                                              CSD015
     C                   IF        A_CUTYLC = 'A'                                             CSD015
                                                                                              CSD015
      ** Access SDCWHTPD using fucntion type 'SDCUSTPD', identifier                           CSD015
      ** BBCUST, and branch BBBCRD to verify Hit Unconfirmed Flag                             CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'SDCUSTPD'                                     CSD015
     C                   EVAL      WIdntifier = T_BBCUST                                      CSD015
     C                   EVAL      WBranch = T_BBBRCD                                         CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
     C                   IF        NOT %FOUND(SDCWHTL1)                                       CSD015
     C                   EVAL      WUNCF1 = 'N'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C                   EVAL      WUNCF1 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If any of the watch list fields has been entered                                     CSD015
                                                                                              CSD015
     C                   IF        T_BBCNA1 <> *BLANKS                                        CSD015
     C                             OR T_BBCNA2 <> *BLANKS                                     CSD015
     C                             OR T_BBCNA3 <> *BLANKS                                     CSD015
     C                             OR T_BBCNA4 <> *BLANKS                                     CSD015
     C                             OR T_BBCSID <> *BLANKS                                     CSD015
     C                             OR T_BBCNCZ <> *BLANKS                                     CSD015
     C                             OR T_BBCOLC <> *BLANKS                                     CSD015
     C                             OR WUNCF1 = 'Y' AND A_CUTYLC = 'A'                         CSD015
                                                                                              CSD015
     C                   EXSR      SRXWTCH                                                    CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD012
      ** Define Keylist                                                                       CSD012
     C     KAULG         KLIST                                                                CSD012
     C                   KFLD                    @FUNC            21                          CSD012
     C**********         KFLD                    @KEY             20                   CSD012 CGL029
     C                   KFLD                    @KEY             26                          CGL029
      *                                                                                       CSD012
     C                   MOVEL     FUNCD         @FUNC                                        CSD012
     C                   MOVEL     A_CUCUST      @KEY                                         CSD012
      *                                                                                       CSD012
      * If Authorisation check is on,                                                         CSD012
      * check if unathorised record exists on Authorisation Log.                              CSD012
     C     KAULG         CHAIN     SDAULGL3                           96                      CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN96         IFEQ      *ON                                                        CSD012
     C                   MOVEL     @KEY          ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      A_CUTYLC      ALACTN                                       CSD012
     C                   MOVE      PSUser        ALUSER                                       CSD012
      *                                                                                       CSD028
     C                   IF        WNewCust = 'Y'                                             CSD028
     C                   MOVE      'P'           ALSTAT                                       CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   WRITE     SDAULGD3                                                   CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** Send an amend message to compliance watch                                            CSD028
      *                                                                                       CSD028
     C                   IF        CSD028 = 'Y'                                               CSD028
     C                   IF        A_CUTYLC = 'A' AND PTransType = 'AUTH'                     CSD028
     C                   CALL      'SD000051'                                                 CSD028
     C                   PARM      'A'           PAction                                      CSD028
     C                   PARM      A_CUCUST      PCustNumber                                  CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   IF        A_CUTYLC = 'I' AND PTransType <> 'AUTH'                    CSD028
     C                   CALL      'SD000051'                                                 CSD028
     C                   PARM      'I'           PAction                                      CSD028
     C                   PARM      A_CUCUST      PCustNumber                                  CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   RETURN                                                               CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012

      ** INSERT, AMEND OR DELETE THE CUSTOMER
      ** OR CLOSE OR RELEASE THE CUSTOMER                                                     CSD007

     C                   IF        ALSTAT = ' ' AND                                           CSD028
     C                             AUTHMD = 'X'                                               CSD028
     C                   MOVE      DACTN         A_CUTYLC                                     CSD028
     C                   ENDIF                                                                CSD028
                                                                                            BUG12342
     C**********         IF        CSD037 = 'Y' AND                                BUG12342 BUG13525
     C**********                   PAccMde = 'A'                                   BUG12342 BUG13525
     C**********         OPEN      SDACSTL0                                        BUG12342 BUG12406
     C**********A_CUCUST      CHAIN     SDACSTL0                                   BUG12342 BUG12406
     C**********         EVAL      A_CUTYLC = BBTYLC                             BUG  12342 BUG12406
     C**********         CLOSE     SDACSTL0                                        BUG12342 BUG12406
      *                                                                                     BUG12406
      ** User zonal file when checking existing customer                                    BUG12406
      *                                                                                     BUG12406
     C*****A_CUCUST      CHAIN     SDCUSTL0                         99             BUG12406 BUG13525
     C**********         If        *IN99 = *Off                                    BUG12406 BUG13525
     C**********         Eval      A_CUTYLC = 'A'                                  BUG12406 BUG13525
     C**********         EndIf                                                     BUG12406 BUG13525
     C**********         ENDIF                                                     BUG12342 BUG13525
      *                                                                                       CSD028
     C**********         IF        PUpdYN = 'Y' OR                                   CSD031 BUG13525
     C**********                   PUpdYN = *BLANK                                   CSD031 BUG13525
                                                                                              CSD031
     C                   EVAL      WLUSER = *BLANKS                                        MD026835A
     C                   IF        A_FVLUSR <> *BLANKS                                     MD026835A
     C                   EVAL      WLUSER = A_FVLUSR                                       MD026835A
     C                   ENDIF                                                             MD026835A
     C     A_CUTYLC      CASEQ     'I'           INSERT
     C     A_CUTYLC      CASEQ     'A'           AMEND
     C     A_CUTYLC      CASEQ     'D'           DELETE
     C     A_CUTYLC      CASEQ     'C'           CLOSE                                        CSD007
     C     A_CUTYLC      CASEQ     'R'           RELEASE                                      CSD007
     C                   END
      *
                                                                                              CSD031
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
      ** Delete customer on the acceptance file.                                              CSD031
                                                                                              CSD031
     C**********         IF        CSD037 = 'Y' AND                                  CSD031 BUG13525
     C**********                   PAccMde = 'A' AND                                 CSD031 BUG13525
     C**********                   @@RTCD = *BLANKS                                  CSD031 BUG13525
     C**********                                                                              CSD031
     C**********         OPEN      SDACSTL0                                          CSD031 BUG13525
     C*****A_CUCUST      CHAIN     SDACSTL0                                          CSD031 BUG13525
     C**********         IF        %FOUND(SDACSTL0)                                  CSD031 BUG13525
     C**********         DELETE    SDACSTD0                                          CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
     C**********         CLOSE     SDACSTL0                                          CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
      *                                                                                       CSD031
      ** Skip further updates if required.                                                    CSD031
      *                                                                                       CSD031
     C**********         IF        PUpdYN = 'N'                                      CSD031 BUG13525
     C**********         RETURN                                                      CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525

      ** UPDATE BASE RATE TAX DETAILS FILE
      ** ONLY IF BRT OPTION FEATURE IS 'Y'
      **    AND IF A/C HOLDER TYPE IS 'I' OR 'J'

     C     A_CUTYLC      IFEQ      'I'
     C     A_CUTYLC      OREQ      'A'
     C     A_CUTYLC      OREQ      'D'
     C     A_CUTYLC      OREQ      'C'                                                        CSD007
     C     A_CUTYLC      OREQ      'R'                                                        CSD007

     C     S01383        IFEQ      'Y'
     C                   EXSR      UPDBRT
     C                   END

     C                   ENDIF

      ** UPDATE PRIVATE BANKING DETAILS FILE
      ** ONLY IF PRIVATE BANKING OPTION FEATURE IS 'Y'

     C     A_CUTYLC      IFEQ      'I'
     C     A_CUTYLC      OREQ      'A'
     C     A_CUTYLC      OREQ      'D'
     C     A_CUTYLC      OREQ      'C'                                                        CSD007
     C     A_CUTYLC      OREQ      'R'                                                        CSD007

     C     BGN4ST        IFEQ      'Y'
     C                   EXSR      UPDPRB
     C                   END

     C                   ENDIF

      ** UPDMID - Update Customer Marketing Details                                           CSD079
      ** ONLY IF CSD079 IS 'Y'                                                                CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C     CSD079        IFEQ      'Y'                                                        CSD079
     C                   EXSR      UPDMID                                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDADD - Update Customer Additional Details                                          CSD079
      ** ONLY IF CSD079 IS 'Y' and S01425 is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        S01425 = 'Y' AND CSD079 = 'Y'                              CSD079
     C                   EXSR      UPDADD                                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDSFD - Update Customer Service Fees Details                                        CSD079
      ** ONLY IF CSD079 IS 'Y' and CSD008 is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        CSD008 = 'Y' AND CSD079 = 'Y'                              CSD079
     C     F_SFSMAC      IFNE      *BLANKS                                                   BG12238
     C     F_SFHMIN      ORNE      *BLANKS                                                   BG12238
     C     F_SFNAIN      ORNE      *BLANKS                                                   BG12238
     C     F_SFSBCH      ORNE      *BLANKS                                                   BG12238
     C     F_SFSCCY      ORNE      *BLANKS                                                   BG12238
     C     F_SFPFCD      ORNE      *BLANKS                                                   BG12238
     C     F_SFPCAC      ORNE      *BLANKS                                                   BG12238
     C     F_SFPCHM      ORNE      *BLANKS                                                   BG12238
     C     F_SFTAIF      ORNE      *BLANKS                                                   BG12238
     C                   EXSR      UPDSFD                                                     CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDCQD - Update Customer Cheques and Cards Details                                   CSD079
      ** ONLY IF CSD079 IS 'Y' and BGNXST is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        BGNXST = 'Y' AND CSD079 = 'Y'                              CSD079
     C                   EXSR      UPDCQD                                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDSAD - Update Customer Safe Details                                                CSD079
      ** ONLY IF CSD079 IS 'Y'                                                                CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
     C                   EXSR      UPDSAD                                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDFOD - Update Customer Future and Option Details                                   CSD079
      ** ONLY IF CSD079 IS 'Y' and BGFUOP is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        BGFUOP = 'Y' AND CSD079 = 'Y'                              CSD079
     C     A_FOSTFQ      IFNE      *BLANKS                                                   BG12238
     C     A_FODMFS      ORNE      *ZEROS                                                    BG12238
     C     A_FONSDT      ORNE      *ZEROS                                                    BG12238
     C     A_FOFACO      ORNE      *BLANKS                                                   BG12238
     C     A_FOBKIN      ORNE      *BLANKS                                                   BG12238
     C     A_FOSTTY      ORNE      *BLANKS                                                   BG12238
     C     A_FOCPNO      ORNE      *BLANKS                                                   BG12238
     C     A_FOCOAD      ORNE      *BLANKS                                                   BG12238
     C     A_FOFTAO      ORNE      *BLANKS                                                   BG12238
     C     A_FOTXCI      ORNE      *BLANKS                                                   BG12238
     C     A_FOCTLM      ORNE      *ZEROS                                                    BG12238
     C     A_FORVFQ      ORNE      *BLANKS                                                   BG12238
     C     A_FORVBD      ORNE      *ZEROS                                                    BG12238
     C     A_FONRDT      ORNE      *ZEROS                                                    BG12238
     C     A_FOPCIN      ORNE      *BLANKS                                                   BG12238
     C     A_FOACIN      ORNE      *BLANKS                                                   BG12238
     C     A_FOCYCD      ORNE      *BLANKS                                                   BG12238
     C     A_FOCODE      ORNE      *BLANKS                                                   BG12238
     C     A_FOCOAM      ORNE      *ZEROS                                                    BG12238
     C     A_FOSEBR      ORNE      *BLANKS                                                   BG12238
     C     A_FOSMAC      ORNE      *BLANKS                                                   BG12238
     C     LXNETA        ORNE      *ZEROS                                                    BG12238
     C                   EXSR      UPDFOD                                                     CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDFFD - Update MIDAS/ABS FF Customers Maintenance details                           CSD079
      ** ONLY IF CSD079 IS 'Y' and ULX004 is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        ULX004 = 'Y' AND CSD079 = 'Y'                              CSD079
     C     A_FOSTFQ      IFNE      *BLANKS                                                   BG12238
     C     A_FODMFS      ORNE      *ZEROS                                                    BG12238
     C     A_FONSDT      ORNE      *ZEROS                                                    BG12238
     C     A_FOFACO      ORNE      *BLANKS                                                   BG12238
     C     A_FOBKIN      ORNE      *BLANKS                                                   BG12238
     C     A_FOSTTY      ORNE      *BLANKS                                                   BG12238
     C     A_FOCPNO      ORNE      *BLANKS                                                   BG12238
     C     A_FOCOAD      ORNE      *BLANKS                                                   BG12238
     C     A_FOFTAO      ORNE      *BLANKS                                                   BG12238
     C     A_FOTXCI      ORNE      *BLANKS                                                   BG12238
     C     A_FOCTLM      ORNE      *ZEROS                                                    BG12238
     C     A_FORVFQ      ORNE      *BLANKS                                                   BG12238
     C     A_FORVBD      ORNE      *ZEROS                                                    BG12238
     C     A_FONRDT      ORNE      *ZEROS                                                    BG12238
     C     A_FOPCIN      ORNE      *BLANKS                                                   BG12238
     C     A_FOACIN      ORNE      *BLANKS                                                   BG12238
     C     A_FOCYCD      ORNE      *BLANKS                                                   BG12238
     C     A_FOCODE      ORNE      *BLANKS                                                   BG12238
     C     A_FOCOAM      ORNE      *ZEROS                                                    BG12238
     C     A_FOSEBR      ORNE      *BLANKS                                                   BG12238
     C     A_FOSMAC      ORNE      *BLANKS                                                   BG12238
     C     LXNETA        ORNE      *ZEROS                                                    BG12238
     C                   EXSR      UPDFFD                                                     CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDPMD - Update Customer Portfolio Management Details                                CSD079
      ** ONLY IF CSD079 IS 'Y' and WUPMSC is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        WUPMSC = 'Y' AND CSD079 = 'Y'                              CSD079
     C     A_PMLANG      IFNE      *BLANKS                                                   BG12238
     C     A_PMBDAT      ORNE      *ZEROS                                                    BG12238
     C     A_PMCSBY      ORNE      *BLANKS                                                   BG12238
     C     A_PMSAFI      ORNE      *BLANKS                                                   BG12238
     C     A_PMSAFI      ANDNE     'N'                                                     AR1049708
     C     A_PMDCMS      ORNE      *BLANKS                                                   BG12238
     C     A_PMVLFQ      ORNE      *BLANKS                                                   BG12238
     C     A_PMVLDM      ORNE      *ZEROS                                                    BG12238
     C     A_PMVLND      ORNE      *ZEROS                                                    BG12238
     C     A_PMS1VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS1VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS2VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS2VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS3VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS3VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS4VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS4VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS5VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS5VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS6VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS6VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS7VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS7VR      ANDNE     'N'                                                     AR1049708
     C     A_PMS8VR      ORNE      *BLANKS                                                   BG12238
     C     A_PMS8VR      ANDNE     'N'                                                     AR1049708
     C     A_PMAPBC      ORNE      *BLANKS                                                   BG12238
     C     A_PMPPCS      ORNE      *BLANKS                                                   BG12238
     C     A_PMPPCS      ANDNE     'N'                                                     AR1049708
     C     A_PMDFPO      ORNE      *BLANKS                                                   BG12238
     C     A_PMINSU      ORNE      *BLANKS                                                   BG12238
     C     A_PMCYSU      ORNE      *BLANKS                                                   BG12238
     C     A_PMSECO      ORNE      *BLANKS                                                   BG12238
     C                   EXSR      UPDPMD                                                     CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDRWN - Update Customer Risk weighted Assets Details                                CSD079
      ** ONLY IF CSD079 IS 'Y' and CGL018 is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        CGL018 = 'Y' AND CSD079 = 'Y'                              CSD079
     C                   IF        %SUBST(SDVCURW:8:107) <> *BLANKS                          BG12238
     C                   EXSR      UPDRWN                                                     CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDCUX2 - Update Lux(European Reporting ) file                                       CSD079
      ** ONLY IF ULX609 is 'Y' and BGLRIN is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        ULX609 = 'Y' AND BGLRIN = 'Y'                              CSD079
     C                             AND CSD079 = 'Y'                                         BUG14104
     C                   EXSR      UPDCUX2                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** UPDCUX1 - Update Lux(IBLC - Extended Information) file                               CSD079
      ** ONLY IF ULX043 is 'Y' and BGNWST is 'Y'                                              CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     A_CUTYLC      OREQ      'A'                                                        CSD079
     C     A_CUTYLC      OREQ      'D'                                                        CSD079
     C*****A_CUTYLC      OREQ      'C'                                               CSD079 BUG14009
     C*****A_CUTYLC      OREQ      'R'                                               CSD079 BUG14009
                                                                                              CSD079
     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                              CSD079
     C                             AND CSD079 = 'Y'                                         BUG14104
     C                   EXSR      UPDCUX1                                                    CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                    AR1086546
     C     A_CUTYLC      IFEQ      'I'                                                     AR1086546
     C     A_CUTYLC      OREQ      'A'                                                     AR1086546
     C     A_CUTYLC      OREQ      'D'                                                     AR1086546
                                                                                           AR1086546
     C                   IF        CDL025 = 'Y' AND CSD079 = 'Y'                           AR1086546
     C                             AND CDL002 = 'Y' AND BBNET = 'Y'                        AR1086546
     C                             AND NV_TNCUST <> *BLANKS                                 MD026368
     C                   EXSR      UPDCTNM                                                 AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                              CSD079
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
      ** Move file fields to DS parameter used in SDCUSDLOG                                   CSC011
                                                                                              CSC011
     C                   EVAL      W_PBCNUM = D_PBCNUM                                        CSC011
     C                   EVAL      W_PBRECI = D_PBRECI                                        CSC011
     C                   EVAL      W_PBHOLD = D_PBHOLD                                        CSC011
     C                   EVAL      W_PBNUAC = D_PBNUAC                                        CSC011
     C                   EVAL      W_PBAGEN = D_PBAGEN                                        CSC011
     C                   EVAL      W_PBCOUN = D_PBCOUN                                        CSC011
     C                   EVAL      W_PBREPB = D_PBREPB                                        CSC011
     C                   EVAL      W_PBPBST = D_PBPBST                                        CSC011
     C                   EVAL      W_PBLCHD = D_PBLCHD                                        CSC011
     C                   EVAL      W_PBCHTP = D_PBCHTP                                        CSC011
     C                   EVAL      W_PBTMES = D_PBTMES                                        CSC011
                                                                                              CSC011
     C                   CALLB     'SDCUSDLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    CUSTDF                                       CSC011
     C                   PARM                    SDCBRTF                                      CSC011
     C                   PARM                    SDPBDF                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SDCUSD'                                       CSC011
     C                   EVAL      APFOTRANID = BBFRNT                                        CSC011
     C                   EVAL      APRPRLOCN  = BBREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   MOVEL     BBCUST        PCustNum                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PCustNum                                     CSC011
     C                   PARM      *BLANKS       PACustNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,SDCUSDDC01
      * EXIT FROM PROGRAM
     C     EXIT          TAG

     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CHKOTHUPD - Check for update by another workstation           *
     C*                                                               *
     C*****************************************************************
     C     CHKOTHUPD     BEGSR

      ** Retrieve current Customer details

     C                   MOVE      A_CUCUST      MidasTrNum        6

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @type             1
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C*****A_CUTYLC      IFne      'I'                                   CAP013 193883
     C**********         MOVEL     '1'           @TYPE                   CAP013 193883
     C**********         ENDIF                                           CAP013 193883
     C*****A_CUTYLC      IFne      'I'                                   CAP013 175680
     C**********         MOVEL     '1'           @TYPE                   CAP013 175680
     C**********         ENDIF                                           CAP013 175680
      *
     C     @Type         IFEQ      '1'                                                        201011
     C     A_CUTYLC      ANDEQ     'I'                                                        201011
     C     A_CUFRNT      ANDNE     *BLANKS                                                    201011
      *                                                                                       201011
     C                   MOVE      '*FRONT'      @@MODE                                       201011
      *                                                                                       201011
     C                   ELSE                                                                 201011
                                                                                              201011
     C     @Type         IFEQ      '0'
     C*****A_CUTYLC      IFeq      'I'                                                 175680 201011
     C     A_CUTYLC      ANDEQ     'I'                                                        201011
     C                   MOVE      '*FRONT'      @@MODE
     C                   ELSE                                                   175680
     C                   MOVE      *BLANKS       @@MODE                         175680
     C                   ENDIF                                                  175680
     C**********         ELSE                                                                 201011
     C**********         MOVE      *BLANKS       @@MODE                                       201011
     C                   END
      *                                                                                       CSD021
      ** Generate customer number if not supplied and CSD021 is installed                     CSD021
     C     CSD021        IFEQ      'Y'                                                        CSD021
     C     A_CUTYLC      ANDEQ     'I'                                                        CSD021
     C     A_CUCUST      ANDEQ     *BLANK                                                     CSD021
     C                   EXSR      SRGenCustNo                                                CSD021
     C                   MOVE      New_CNUM      A_CUCUST                                     CSD021
     C                   MOVE      New_CNUM      MidasTrNum                                   CSD021
     C                   MOVE      New_CNUM      BRCNUM                                      BUG1986
     C                   ENDIF                                                                CSD021

     C                   CALLB     'SDCUSDRTV'
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      ' '           @@RSMD            1
      *
      * Action Code
     C                   PARM      A_CUTYLC      ACTN              1
      *
      * Front Office Transaction ID
     C                   PARM      A_CUFRNT      FOTRID           20
      *
      * (Midas) Customer Reference
     C                   PARM                    MidasTrNum
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
      *  Base Rate Tax option feature is switched on
     C                   PARM                    S01383            1
      *
      *  Private Banking Customer Details is switched on
     C                   PARM                    BGN4ST            1
      ** Global Data Layout feature is switched on                                            CGP001
     C                   PARM                    CGP001                                       CGP001
      ** Transaction Type                                                                     CSD028
     C                   PARM                    PTransType                                   CSD028
      *                                                                                       CSD031
      ** Acceptance Mode                                                                      CSD031
     C**********         PARM      PAccMde       PChkAccMde                          CSD031 BUG13525
      ** Update (Y/N)                                                                         CSD031
     C**********         PARM                    PChkUpdYN                           CSD031 BUG13525
     C                   PARM      PAccMde       PChkAccMde                                 BUG15872
     C                   PARM                    PChkUpdYN                                  BUG15872
      *
      * OUTPUTS
      *
      * (Current) CUSTOMER in file format
     C                   PARM                    ChkCusdFmt
      *
      * (Current) Base Rate Tax details in file format
     C                   PARM                    CBrtFilFmt
      *
      * (Current) Private Banking Details in file format
     C                   PARM                    CPrbFilFmt
      * TI Customer Details in File Format                                                   BUG4967
     C                   PARM                    CuTIFilFMt                                  BUG4967
      ** (Current) Global Customer X-Reference in file format                                 CGP001
     C                   PARM                    CGCuFilFmt                                   CGP001
     C                   PARM                    SwftFilFmt                                 BUG14929
     C                   PARM                    SDVSW13                                      CFT050
     C**********         PARM                    CuFaFilFmt                         CGL132 MD038401B
     C                   PARM                    CrXcFilFmt                                   CGL132
     C                   PARM                    CuFaFilFmt                                MD038401B
     C                   PARM                    CrsdFilFmt                                   CGL157
     C                   PARM                    PCrsdX                                       CGL157
                                                                                              CSD079
      ** (Current) Customer Marketing Information in file format                              CSD079
                                                                                              CSD079
     C                   PARM                    CuMiFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Additional Details in file format                                 CSD079
                                                                                              CSD079
     C                   PARM                    CuAdFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Service Fees Details in file format                               CSD079
                                                                                              CSD079
     C                   PARM                    CuFeFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Cheques & Cards Details in file format                            CSD079
                                                                                              CSD079
     C                   PARM                    CuCqFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Safes Details in file format                                      CSD079
                                                                                              CSD079
     C                   PARM                    CuSfFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Risk Weighted Assets Details in file format                       CSD079
                                                                                              CSD079
     C                   PARM                    CuRwFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Futures & Options Details in file format                          CSD079
                                                                                              CSD079
     C                   PARM                    CuFoFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) MIDAS/ABS FF Customers Maintenance in file format                          CSD079
                                                                                              CSD079
     C                   PARM                    CuFFFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Portfolio Mgmt. Details in file format                            CSD079
                                                                                              CSD079
     C                   PARM                    CuPmFilFmt                                   CSD079
                                                                                              CSD079
      ** (current) Lux(European Reporting ) Details in file format                            CSD079
                                                                                              CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Lux(IBLC - Extended Information)details in file                            CSD079
      ** format                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
                                                                                              CER059
     C                   PARM                    TranInCUAH                                   CER059
     C                   PARM                    TranInCCTX                                   CER059
     C                   PARM                    CtnmFilFmt                                AR1086546
     C                   PARM                    TranInPrim                                   CFT050
     C                   PARM                    TranInSeco                                   CFT050
     C                   PARM                    TranInMT3X                                   CFT050
     C/COPY WNCPYSRC,SDH00751
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Customer Number
     C                   PARM                    DDCUSNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
      *                                                                                     BUG23518
     C                   PARM      *BLANKS       WFldNamArr                                 BUG23518
     C                   PARM      *BLANKS       WMsgIdArr                                  BUG23518
     C                   PARM      *BLANKS       WMsgDtaArr                                 BUG23518
     C                   PARM      *ZEROS        WIdx              3 0                      BUG23518
      *                                                                                     BUG23518
     C/COPY WNCPYSRC,SDCUSDDC10
      *
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C     @TYPE         IFEQ      '1'

     C     CHBBTMST      IFNE      A_CUTMST
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   END

      ** Batch mode:
     C                   ELSE
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   Z-ADD     1             C                 2 0

     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   END

     C                   END

     C                   END

     C                   ENDSR
      ****************************************************************                        CSD021
      /EJECT                                                                                  CSD021
      *****************************************************************                       CSD021
      *                                                               *                       CSD021
      * SRGenCustNo - Generate Customer Number                        *                       CSD021
      *                                                               *                       CSD021
      *****************************************************************                       CSD021
     C     SRGenCustNo   BEGSR                                                                CSD021
                                                                                              CSD021
     C     *LOCK         IN        CNLU                                                       CSD021
     C                   Eval      New_CNUM = CNLU                                            CSD021
                                                                                              CSD021
      ** Loop until a valid customer number is found                                          CSD021
     C                   Eval      New_CNUMOK = 'N'                                           CSD021
     C                   DoW       New_CNUMOK = 'N'                                           CSD021
                                                                                              CSD021
     C*********          Eval      New_CNUM = New_CNUM + 1                             CSD021 CSD027
     C                   Eval      #@NOA = New_CNUM                                           CSD027
     C                   EXSR      #@NUA                                                      CSD027
     C                   Eval      New_CNUM = #@NOA                                           CSD027
     C                   Move      New_CNUM      MidasTrNum                                   CSD021
                                                                                              CSD021
     C                   CallB     'SDCUSDRTV'                                                CSD021
      * INPUTS                                                                                CSD021
      *                                                                                       CSD021
      * Return code                                                                           CSD021
     C                   PARM      *BLANK        RetCodeOut                                   CSD021
      *                                                                                       CSD021
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  CSD021
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              CSD021
      *                                                                                       CSD021
     C                   PARM                    @@MODE            6                          CSD021
      *                                                                                       CSD021
      * Response mode                                                                         CSD021
     C                   PARM      ' '           @@RSMD            1                          CSD021
      *                                                                                       CSD021
      * Action Code                                                                           CSD021
     C                   PARM      A_CUTYLC      ACTN              1                          CSD021
      *                                                                                       CSD021
      * Front Office Transaction ID                                                           CSD021
     C                   PARM      A_CUFRNT      FOTRID           20                          CSD021
      *                                                                                       CSD021
      * (Midas) Customer Reference                                                            CSD021
     C                   PARM                    MidasTrNum        6                          CSD021
      * Base Rate Auth req                                                                   BUG1986
     C                   PARM                    AUTHRQ            1                         BUG1986
      * Authorisation Mode                                                                   BUG1986
     C                   PARM                    AUTHMD                                      BUG1986
      *                                                                                       CSD021
      *  Base Rate Tax option feature is switched on                                          CSD021
     C                   PARM                    S01383            1                          CSD021
      *                                                                                       CSD021
      *  Private Banking Customer Details is switched on                                      CSD021
     C                   PARM                    BGN4ST            1                          CSD021
      ** Global Data Layout feature is switched on                                           BUG1986
     C                   PARM                    CGP001                                      BUG1986
      ** Transaction Type                                                                     249593
     C                   PARM                    PTransType                                   249593
      ** Acceptance Mode                                                                      CSD031
     C**********         PARM      PAccMde       PChkAccMde                          CSD031 BUG13525
      ** Update (Y/N)                                                                         CSD031
     C**********         PARM                    PChkUpdYN                           CSD031 BUG13525
     C                   PARM      PAccMde       PChkAccMde                                 BUG15872
     C                   PARM                    PChkUpdYN                                  BUG15872
      *                                                                                       CSD021
      * OUTPUTS                                                                               CSD021
      *                                                                                       CSD021
      * (Current) CUSTOMER in file format                                                     CSD021
     C                   PARM                    ChkCusdFmt                                   CSD021
      *                                                                                       CSD021
      * (Current) Base Rate Tax details in file format                                        CSD021
     C                   PARM                    CBrtFilFmt                                   CSD021
      *                                                                                       CSD021
      * (Current) Private Banking Details in file format                                      CSD021
     C                   PARM                    CPrbFilFmt                                   CSD021
      * TI Customer Details in File Format                                                   BUG4967
     C                   PARM                    CuTIFilFMt                                  BUG4967
      ** (Current) Global Customer X-Reference in file format                                BUG1986
     C                   PARM                    CGCuFilFmt                                  BUG1986
     C                   PARM                    SwftFilFmt                                 BUG14929
     C                   PARM                    SDVSW13                                   MD038401B
     C                   PARM                    CrXcFilFmt                                MD038401B
     C                   PARM                    CuFaFilFmt                                MD038401B
     C                   PARM                    CrsdFilFmt                                   CGL157
     C                   PARM                    PCrsdF                                       CGL157
                                                                                              CSD079
      ** (Current) Customer Marketing Information in file format                              CSD079
                                                                                              CSD079
     C                   PARM                    CuMiFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Additional Details in file format                                 CSD079
                                                                                              CSD079
     C                   PARM                    CuAdFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Service Fees Details in file format                               CSD079
                                                                                              CSD079
     C                   PARM                    CuFeFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Cheques & Cards Details in file format                            CSD079
                                                                                              CSD079
     C                   PARM                    CuCqFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Safes Details in file format                                      CSD079
                                                                                              CSD079
     C                   PARM                    CuSfFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Risk Weighted Assets Details in file format                       CSD079
                                                                                              CSD079
     C                   PARM                    CuRwFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Futures & Options Details in file format                          CSD079
                                                                                              CSD079
     C                   PARM                    CuFoFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) MIDAS/ABS FF Customers Maintenance in file format                          CSD079
                                                                                              CSD079
     C                   PARM                    CuFFFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Customer Portfolio Mgmt. Details in file format                            CSD079
                                                                                              CSD079
     C                   PARM                    CuPmFilFmt                                   CSD079
                                                                                              CSD079
      ** (current) Lux(European Reporting ) Details in file format                            CSD079
                                                                                              CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
                                                                                              CSD079
      ** (Current) Lux(IBLC - Extended Information)details in file format                     CSD079
                                                                                              CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
      *                                                                                       CSD021
      ** (Current) Currency/Time of Netting Details in file format                         AR1086546
                                                                                           AR1086546
     C**********         PARM                    CtnmFilFmt                      AR1086546 MD038401B
     C                   PARM                    TranInCUAH                                   CFT050
     C                   PARM                    TranInCCTX                                   CFT050
     C                   PARM                    CtnmFilFmt                                MD038401B
     C                   PARM                    TranInPrim                                   CFT050
     C                   PARM                    TranInSeco                                   CFT050
     C                   PARM                    TranInMT3X                                   CFT050
      * OK - Action code                                                                      CSD021
     C                   PARM      *BLANK        DDACTNOK          1                          CSD021
      *                                                                                       CSD021
      * OK - Customer Number                                                                  CSD021
     C                   PARM      *BLANK        DDCUSNOK          1                          CSD021
      *                                                                                       CSD021
      * Error fields/message IDs/message data (arrays) from/to caller                         CSD021
     C                   PARM      *BLANK        FldNameArr                                   CSD021
     C                   PARM      *BLANK        MsgIdArr                                     CSD021
     C                   PARM      *BLANK        MsgDtaArr                                    CSD021
      *                                                                                       CSD021
      * Array index (3P0) from/to caller                                                      CSD021
     C                   PARM      *ZERO         Idx               3 0                        CSD021
      *                                                                                     BUG23518
     C                   PARM      *BLANKS       WFldNamArr                                 BUG23518
     C                   PARM      *BLANKS       WMsgIdArr                                  BUG23518
     C                   PARM      *BLANKS       WMsgDtaArr                                 BUG23518
     C                   PARM      *ZEROS        WIdx                                       BUG23518
                                                                                              CSD021
     C     DDACTNOK      IFNE      'N'                                                        CSD021
     C     DDCUSNOK      ANDNE     'N'                                                        CSD021
     C                   Eval      New_CNUMOK = 'Y'                                           CSD021
     C                   ENDIF                                                                CSD021
                                                                                              CSD021
     C                   EndDo                                                                CSD021
                                                                                              CSD021
     C                   Eval      CNLU = New_CNUM                                            CSD021
     C                   OUT       CNLU                                                       CSD021
                                                                                              CSD021
     C                   ENDSR                                                                CSD021
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INSERT - INSERT A CUSTOMER                                   *
     C*                                                              *
     C****************************************************************
     C     INSERT        BEGSR

      ** ACCESS CUSTOMER

     C     A_CUCUST      CHAIN     SDCUSTL0                           99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '0'
     C                   MOVEL     A_CUCUST      DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** INITIALIZE CUSTOMER

     C                   CLEAR                   CUSTDF

      ** Store Old fields for comparisons
     C                   MOVEL(P)  CUSTDF        B_CUSTD

      ** SET CUSTOMER FIELDS ON INSERT
     C                   EVAL      BBCUST=A_CUCUST
     C                   EVAL      BBCSSN=A_CUCSSN
     C                   EVAL      BBCNA1=A_CUCNA1
     C                   EVAL      BBCNA2=A_CUCNA2
     C                   EVAL      BBCNA3=A_CUCNA3
     C                   EVAL      BBCNA4=A_CUCNA4
     C                   EVAL      BBCRTN=A_CUCRTN
     C                   EVAL      BBPAIN=A_CUPAIN
     C                   EVAL      BBCRNM=A_CUCRNM
     C                   EVAL      BBDRCS=A_CUDRCS
     C                   EVAL      BBLCCD=A_CULCCD
     C                   EVAL      BBACOC=A_CUACOC
     C                   EVAL      BBCNCZ=A_CUCNCZ
     C                   EVAL      BBCOLC=A_CUCOLC
     C                   EVAL      BBSSDT=0
     C                   EVAL      BBDOIC=A_CUDOIC
     C                   EVAL      BBPCNB=A_CUPCNB
     C                   EVAL      BBCASC=A_CUCASC
     C                   EVAL      BBBRCD=A_CUBRCD
     C                   EVAL      BBBNBI=A_CUBNBI
     C                   EVAL      BBLINC=A_CULINC
     C                   EVAL      BBLICD=A_CULICD
     C                   EVAL      BBCTNB=A_CUCTNB
     C                   EVAL      BBREID=A_CUREID
     C                   EVAL      BBBSIN=A_CUBSIN
     C                   EVAL      BBCSTY=A_CUCSTY
     C                   EVAL      BBTAIN=A_CUTAIN
     C                   EVAL      BBCSID=A_CUCSID
     C     CSW036        IFEQ      'Y'                                                        CSW036
     C                   EVAL      BBCSI2 = A_CUCSI2                                          CSW036
     C                   ENDIF                                                                CSW036
     C                   EVAL      BBSTAD=A_CUSTAD
     C                   EVAL      BBTXA1=A_CUTXA1
     C                   EVAL      BBTXA2=A_CUTXA2
     C                   EVAL      BBTXA3=A_CUTXA3
     C                   EVAL      BBTXA4=A_CUTXA4
     C                   EVAL      BBTXA5=A_CUTXA5
     C                   EVAL      BBCHID=A_CUCHID
     C                   EVAL      BBCHSC=A_CUCHSC
     C                   EVAL      BBCABA=A_CUCABA
     C                   EVAL      BBBFIC=A_CUBFIC
     C                   EVAL      BBBLCD=A_CUBLCD
     C                   EVAL      BBFWCD=A_CUFWCD
     C                   EVAL      BBLCD=BJRDNB
     C                   EVAL      BBTYLC='I'
     C                   EVAL      BBLALD=0
     C                   EVAL      BBLDHD=0
     C                   EVAL      BBLRLD=0
     C                   EVAL      BBDTDL=0
     C                   EVAL      BBLETI=A_CULETI
     C                   EVAL      BBCMTI=A_CUCMTI
     C                   EVAL      BBGSFM=A_CUGSFM
     C                   EVAL      BBSTFG=A_CUSTFG
     C                   EVAL      BBRWCD=A_CURWCD
     C                   EVAL      BBNG01=A_CUNG01
     C                   EVAL      BBNG02=A_CUNG02
     C                   EVAL      BBNG03=A_CUNG03
     C                   EVAL      BBNG04=A_CUNG04
     C                   EVAL      BBNG05=A_CUNG05
     C                   EVAL      BBNG06=A_CUNG06
     C                   EVAL      BBNG07=A_CUNG07
     C                   EVAL      BBNG08=A_CUNG08
     C                   EVAL      BBNG09=A_CUNG09
     C                   EVAL      BBNG10=A_CUNG10
     C                   EVAL      BBNG11=A_CUNG11
     C                   EVAL      BBNG12=A_CUNG12
     C                   EVAL      BBNG13=A_CUNG13
     C                   EVAL      BBNG14=A_CUNG14
     C                   EVAL      BBNG15=A_CUNG15
     C                   EVAL      BBDS01=A_CUDS01
     C                   EVAL      BBDS02=A_CUDS02
     C                   EVAL      BBDS03=A_CUDS03
     C                   EVAL      BBDS04=A_CUDS04
     C                   EVAL      BBDS05=A_CUDS05
     C                   EVAL      BBDS06=A_CUDS06
     C                   EVAL      BBDS07=A_CUDS07
     C                   EVAL      BBDS08=A_CUDS08
     C                   EVAL      BBDS09=A_CUDS09
     C                   EVAL      BBDS10=A_CUDS10
     C                   EVAL      BBDS11=A_CUDS11
     C                   EVAL      BBDS12=A_CUDS12
     C                   EVAL      BBDS13=A_CUDS13
     C                   EVAL      BBDS14=A_CUDS14
     C                   EVAL      BBDS15=A_CUDS15
     C                   EVAL      BBDNW1=A_CUDNW1
     C                   EVAL      BBDNW2=A_CUDNW2
     C                   EVAL      BBDNW3=A_CUDNW3
     C                   EVAL      BBDNW4=A_CUDNW4
     C                   EVAL      BBDNW5=A_CUDNW5
     C                   EVAL      BBDNW6=A_CUDNW6
     C                   EVAL      BBDNW7=A_CUDNW7
     C                   EVAL      BBDNW8=A_CUDNW8
     C                   EVAL      BBDNW9=A_CUDNW9
     C                   EVAL      BBCGRP=A_CUCGRP
     C                   EVAL      BBCDEL=A_CUCDEL
     C                   EVAL      BBABA2=A_CUABA2
     C                   EVAL      BBOGID=A_CUOGID
     C                   EVAL      BBSSDL=A_CUSSDL
     C                   EVAL      BBORED=BJRDNB
     C                   EVAL      BBMCAC=A_CUMCAC
     C                   EVAL      BBCRPC=A_CUCRPC
     C                   EVAL      BBPSWC=A_CUPSWC
     C                   EVAL      BBMGTP=A_CUMGTP
     C                   EVAL      BBNET='N'
     C                   EVAL      BBNTGP=A_CUNTGP
     C                   EVAL      BBNTCP='N'
     C                   EVAL      BBNTND=A_CUNTND
     C                   EVAL      BBNTMM='N'
     C                   EVAL      BBTICS=A_CUTICS
     C                   EVAL      BBSWFI=A_CUSWFI
     C                   EVAL      BBDINC=A_CUDINC
     C                   EVAL      BBPRBA=A_CUPRBA
     C                   EVAL      BBCLSS=A_CUCLSS                                            CDL008
     C                   EVAL      BBEFDT=A_CUEFDT                                            CDL008
     C**********         IF        CGL132 = 'Y'                                    MD030958 MD042407
      ** Extension file - SDCUSTXC                                                            CGL132
     C                   EVAL      XCCUST = A_CUCUST                                          CGL132
     C                   EVAL      XCBRCH = A_CUBRCD                                        MD050212
      ** Alternative Country of Citizenship                                                   CGL132
     C                   EVAL      XCACCZ=A_XCACCZ                                            CGL132
      ** Creation Date                                                                        CGL132
     C                   EVAL      XCCRDT=A_XCCRDT                                            CGL132
      ** Dormant Indicator                                                                    CGL132
     C                   EVAL      XCDRMT=A_XCDRMT                                            CGL132
      ** Last Change User                                                                     CGL132
     C**********         EVAL      XCLCUS=PSUSER                                     CGL132 MD026835
     C**********         EVAL      XCLCUS=WKUSER                                  MD026835 MD027492A
     C                   EVAL      XCLCUS=WLUSER                                           MD027492A
     C**********         ENDIF                                                     MD030958 MD042407
                                                                                              CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
     C                   EVAL      BBCORP=A_CUCORP                                            CSW024
     C                   EVAL      BBCBEI=A_CUCBEI                                            CSW024
     C                   EVAL      BBRI01=A_CURI01                                            CSW024
     C                   EVAL      BBRI02=A_CURI02                                            CSW024
     C                   EVAL      BBRI03=A_CURI03                                            CSW024
     C                   EVAL      BBRI04=A_CURI04                                            CSW024
     C                   EVAL      BBRI05=A_CURI05                                            CSW024
     C                   EVAL      BBFUND=A_CUFUND                                            CSW024
     C     CSW037        IFEQ      'Y'                                                        CSW037
     C                   EVAL      BBFNAC=A_CUFNAC                                            CSW037
     C                   ENDIF                                                                CSW037
     C                   ENDIF                                                                CSW024
     C     CSD025        IFEQ      'Y'                                                        CSD025
     C                   EVAL      BBDEAC = A_CUDEAC                                          CSD025
     C                   EVAL      BBDEDT = A_CUDEDT                                          CSD025
     C                   ENDIF                                                                CSD025

      ** Front Office ID
     C                   EVAL      BBFRNT=A_CUFRNT
      ** Associated Front Office ID
     C                   EVAL      BBAFRT=A_CUAFRT
      ** Repair Location
     C                   EVAL      BBREPA=A_CUREPA
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      BBTMST  = TimeStamp

      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        BBFRNT = *BLANKS                                           CSC011
     C                   EVAL      BBFRNT = 'MD' + BBCUST                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If CSD015 = 'Y' and watch list checking applied                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                             AND W1EWLC = 'Y'                                           CSD015
                                                                                              CSD015
      ** If user is in the main system                                                        CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y'                                              CSD015
     C                             OR CSC011 = 'Y' AND S1MAIN = LIBR                          CSD015
                                                                                              CSD015
      ** If any of the watch list fields has been entered                                     CSD015
                                                                                              CSD015
     C                   IF        BBCNA1 <> *BLANKS                                          CSD015
     C                             OR BBCNA2 <> *BLANKS                                       CSD015
     C                             OR BBCNA3 <> *BLANKS                                       CSD015
     C                             OR BBCNA4 <> *BLANKS                                       CSD015
     C                             OR BBCSID <> *BLANKS                                       CSD015
     C                             OR BBCNCZ <> *BLANKS                                       CSD015
     C                             OR BBCOLC <> *BLANKS                                       CSD015
                                                                                              CSD015
     C                   EXSR      SRWTCH                                                     CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set Facility Mandatory, Include Offsets, and                                         CLE025
      ** FX Margin Types flags                                                                CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                             OR  CFX001 = 'Y'                                           CFX001
     C                   EVAL      BBFCMF = A_CUFCMF                                          CLE025
     C                   EVAL      BBINOF = A_CUINOF                                          CLE025
     C                   EVAL      BBMSTF = A_CUMSTF                                          CLE025
     C                   EVAL      BBIOPC = A_CUIOPC                                          CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CSD031
     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
     C**********         EVAL      BBAACC = A_CUAACC                                 CSD031 BUG13525
     C**********         EVAL      BBEACC = BJRDNB                                   CSD031 BUG13525
     C**********         EVAL      BBGPDT = A_CUGPDT                                 CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD079
      ** Set Fx netting Fields                                                                CSD079
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
     C                             AND CDL002 = 'Y'                                           CSD079
     C                   EVAL      BBNET = A_CUNET                                            CSD079
     C                   EVAL      BBNTGP = A_CUNTGP                                          CSD079
     C                   EVAL      BBNTCP = A_CUNTCP                                          CSD079
     C                   EVAL      BBNTND = A_CUNTND                                          CSD079
     C                   EVAL      BBNTMM = A_CUNTMM                                          CSD079
     C                   EVAL      BBTICS = A_CUTICS                                          CSD079
     C                   EVAL      BBSWFI = A_CUSWFI                                          CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Fiduciary Deposits Fields                                                        CSD079
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
     C                             AND CDL006 = 'Y'                                           CSD079
     C                   EVAL      BBCOMG = A_CUCOMG                                          CSD079
     C                   EVAL      BBCHRG = A_CUCHRG                                          CSD079
     C                   EVAL      BBAGNT = A_CUAGNT                                          CSD079
     C                   EVAL      BBAGNP = A_CUAGNP                                          CSD079
     C                   EVAL      BBTRAS = A_CUTRAS                                          CSD079
     C                   EVAL      BBNAR1 = A_CUNAR1                                          CSD079
     C                   EVAL      BBNAR2 = A_CUNAR2                                          CSD079
     C                   EVAL      BBNAR3 = A_CUNAR3                                          CSD079
     C                   EVAL      BBNAR4 = A_CUNAR4                                          CSD079
     C                   EVAL      BBDFAC = A_CUDFAC                                          CSD079
     C                   EVAL      BBDFAS = A_CUDFAS                                          CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
      **********                                                                  AR679445 MD027492A
     C**********         MOVE      WKUSER        BBIUSR                           AR679445 MD027492A
                                                                                           MD027492A
     C                   EVAL      BBIUSR = WLUSER                                         MD027492A
     C                   IF        SDAAUTH <> 'Y'                                           MD055373
     C                   EVAL      BBXUSR = WKUSER                                         MD027492A
     C                   ENDIF                                                              MD055373
      *
      ** Update the SWIFT 2007 field details when CSW207 is on                                CSW207
     C**********         IF        CSW207 = 'Y' OR BGN4ST = 'Y'                      CSW207 BUG15138
     C     A_CUCUST      CHAIN     SDCSSWL0                                                   CSW207
     C                   IF        NOT %FOUND(SDCSSWL0)                                       CSW207
     C                   EVAL      CSCUSD = A_CUCUST                                          CSW207
     C                   EVAL      CSBRCA = A_CUBRCD                                          CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG15138
     C                   EVAL      CSCICI = A_CUCICI                                          CSW207
     C                   EVAL      CSCPCI = A_CUCPCI                                          CSW207
     C                   ENDIF                                                              BUG15138
     C                   EVAL      CSIBEI = A_CUIBEI                                          CSW207
     C                   IF        CFT050 = 'Y'                                               CFT050
     C                   EVAL      CSLEIC = S13DDLEIC                                         CFT050
     C                   EVAL      CSCLSY = S13DDCLSY                                         CFT050
     C                   EVAL      CSCLID = S13DDCLID                                         CFT050
     C                   EVAL      CSBDRK = S13DDBDRK                                         CFT050
     C                   ENDIF                                                                CFT050
     C                   WRITE     SDCSSWD0                                                   CSW207
     C                   ENDIF                                                                CSW207
     C**********         ENDIF                                                       CSW207 BUG15138
      *                                                                                       CSW207
     C                   EVAL      BBIUSR = SDIUSER                                         MD055373
      *                                                                                     MD055373
      ** WRITE NEW CUSTOMER

     C                   WRITE     @BBREBG
     C**********         IF        CGL132 = 'Y'                                    MD030958 MD042407
      ** Write into extension file - SDCUSTXC                                                 CGL132
     C                                                                                        CGL132
     C                   WRITE     SDCUSTX1                                                   CGL132
     C**********         ENDIF                                                     MD030958 MD042407
                                                                                              CSD092
     C                   IF        CSD092 = 'Y' AND                                           CGL132
     C                             CGL132 = 'N'                                               CGL132
     C                   IF        S01425 = 'Y' AND                                           CSD092
     C                             CSD079 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   IF        S01425 <> 'Y' OR CSD079 <> 'Y'                           MD026957
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      BBCUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD026957
     C                   ENDIF                                                                CSD092
     C                   ENDIF                                                                CSD092

     C/COPY WNCPYSRC,SDH00752
      ** Update Global Customer X-Reference                                                   CGP001
                                                                                              CGP001
     C                   IF        CGP001 = 'Y'                                               CGP001
     C                   EXSR      SRUpdGlbID                                                 CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C/COPY WNCPYSRC,SDCUSDDC03
     C                   Z-ADD     1             WUNORC            5 0          No of records
     C                   Z-ADD     *ZERO         WUNOAM            5 0          No of Amend
     C                   Z-ADD     *ZERO         WUNODL            5 0          No of delete
     C                   Z-ADD     1             WUNOIN            5 0          No of Insert
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDCUSTPD'    WFLNAME           8            No of delete
     C                   EXSR      SNCHRC
      *                                                                                      BUG3362
     C                   EXSR      UPDTID                                                    BUG3362
      *
      * retrieve marketing groups to pass to SDCLINT for update of CLINTC
      * Customer marketing groups - Customer Marketing Groups  *
     C                   EXSR      SORVGN
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                            MD027606
     C                   MOVE      TimeStamp     WTime                                      MD027606
     C     *HMS0         MOVE      WTime         WWTIME                                     MD027606
                                                                                            MD027606
     C                   CLEAR                   SDFTCS                                       CGL132
     C                   EVAL      FACUST = BBCUST                                            CGL132
     C                   EVAL      FABRCH = BBBRCD                                          MD026518
     C                   EVAL      FACLAC = A_FVCLAC                                          CGL132
     C                   EVAL      FACLAD = A_FVCLAD                                          CGL132
     C                   EVAL      FAPCLA = A_FVPCLA                                          CGL132
     C                   EVAL      FAHMSV = A_FVHMSV                                          CGL132
     C                   EVAL      FAHMSD = A_FVHMSD                                          CGL132
     C                   EVAL      FAHMOV = A_FVHMOV                                          CGL132
     C                   IF        FAHMOV <> *BLANKS                                        MD027606
     C                   EVAL      FAHMON = WLUSER                                          MD027606
     C                   EVAL      FAHMOD = BJRDNB                                          MD027606
     C                   EVAL      FAHMOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FAHMD1 = A_FVHMD1                                          CGL132
     C                   EVAL      FAHMD2 = A_FVHMD2                                          CGL132
     C                   EVAL      FAHMD3 = A_FVHMD3                                          CGL132
     C                   EVAL      FAHMD4 = A_FVHMD4                                          CGL132
     C                   EVAL      FAHMD5 = A_FVHMD5                                          CGL132
     C                   EVAL      FAHMS1 = A_FVHMS1                                          CGL132
     C                   EVAL      FAHMS2 = A_FVHMS2                                          CGL132
     C                   EVAL      FAHMS3 = A_FVHMS3                                          CGL132
     C                   EVAL      FAHMS4 = A_FVHMS4                                          CGL132
     C                   EVAL      FAHMS5 = A_FVHMS5                                          CGL132
     C                   EVAL      FAHMCO = A_FVHMCO                                          CGL132
     C                   EVAL      FAMCSV = A_FVMCSV                                          CGL132
     C                   EVAL      FAMCSD = A_FVMCSD                                          CGL132
     C                   EVAL      FAMCOV = A_FVMCOV                                          CGL132
     C                   IF        FAMCOV <> *BLANKS                                        MD027606
     C                   EVAL      FAMCON = WLUSER                                          MD027606
     C                   EVAL      FAMCOD = BJRDNB                                          MD027606
     C                   EVAL      FAMCOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FAMCD1 = A_FVMCD1                                          CGL132
     C                   EVAL      FAMCD2 = A_FVMCD2                                          CGL132
     C                   EVAL      FAMCD3 = A_FVMCD3                                          CGL132
     C                   EVAL      FAMCD4 = A_FVMCD4                                          CGL132
     C                   EVAL      FAMCD5 = A_FVMCD5                                          CGL132
     C                   EVAL      FAMCS1 = A_FVMCS1                                          CGL132
     C                   EVAL      FAMCS2 = A_FVMCS2                                          CGL132
     C                   EVAL      FAMCS3 = A_FVMCS3                                          CGL132
     C                   EVAL      FAMCS4 = A_FVMCS4                                          CGL132
     C                   EVAL      FAMCS5 = A_FVMCS5                                          CGL132
     C                   EVAL      FAMCCO = A_FVMCCO                                          CGL132
     C                   EVAL      FARPSV = A_FVRPSV                                          CGL132
     C                   EVAL      FARPSD = A_FVRPSD                                          CGL132
     C                   EVAL      FARPOV = A_FVRPOV                                          CGL132
     C                   IF        FARPOV <> *BLANKS                                        MD027606
     C                   EVAL      FARPON = WLUSER                                          MD027606
     C                   EVAL      FARPOD = BJRDNB                                          MD027606
     C                   EVAL      FARPOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FARPD1 = A_FVRPD1                                          CGL132
     C                   EVAL      FARPD2 = A_FVRPD2                                          CGL132
     C                   EVAL      FARPD3 = A_FVRPD3                                          CGL132
     C                   EVAL      FARPD4 = A_FVRPD4                                          CGL132
     C                   EVAL      FARPD5 = A_FVRPD5                                          CGL132
     C                   EVAL      FARPS1 = A_FVRPS1                                          CGL132
     C                   EVAL      FARPS2 = A_FVRPS2                                          CGL132
     C                   EVAL      FARPS3 = A_FVRPS3                                          CGL132
     C                   EVAL      FARPS4 = A_FVRPS4                                          CGL132
     C                   EVAL      FARPS5 = A_FVRPS5                                          CGL132
     C                   EVAL      FARPCO = A_FVRPCO                                          CGL132
     C                   EVAL      FAAUSV = A_FVAUSV                                          CGL132
     C                   EVAL      FAAUSD = A_FVAUSD                                          CGL132
     C                   EVAL      FAAUOV = A_FVAUOV                                          CGL132
     C                   IF        FAAUOV <> *BLANKS                                        MD027606
     C                   EVAL      FAAUON = WLUSER                                          MD027606
     C                   EVAL      FAAUOD = BJRDNB                                          MD027606
     C                   EVAL      FAAUOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FAAUD1 = A_FVAUD1                                          CGL132
     C                   EVAL      FAAUD2 = A_FVAUD2                                          CGL132
     C                   EVAL      FAAUD3 = A_FVAUD3                                          CGL132
     C                   EVAL      FAAUD4 = A_FVAUD4                                          CGL132
     C                   EVAL      FAAUD5 = A_FVAUD5                                          CGL132
     C                   EVAL      FAAUS1 = A_FVAUS1                                          CGL132
     C                   EVAL      FAAUS2 = A_FVAUS2                                          CGL132
     C                   EVAL      FAAUS3 = A_FVAUS3                                          CGL132
     C                   EVAL      FAAUS4 = A_FVAUS4                                          CGL132
     C                   EVAL      FAAUS5 = A_FVAUS5                                          CGL132
     C                   EVAL      FAAUCO = A_FVAUCO                                          CGL132
     C                   EVAL      FACISV = A_FVCISV                                          CGL132
     C                   EVAL      FACISD = A_FVCISD                                          CGL132
     C                   EVAL      FACIOV = A_FVCIOV                                          CGL132
     C                   IF        FACIOV <> *BLANKS                                        MD027606
     C                   EVAL      FACION = WLUSER                                          MD027606
     C                   EVAL      FACIOD = BJRDNB                                          MD027606
     C                   EVAL      FACIOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FACID1 = A_FVCID1                                          CGL132
     C                   EVAL      FACID2 = A_FVCID2                                          CGL132
     C                   EVAL      FACID3 = A_FVCID3                                          CGL132
     C                   EVAL      FACID4 = A_FVCID4                                          CGL132
     C                   EVAL      FACID5 = A_FVCID5                                          CGL132
     C                   EVAL      FACIS1 = A_FVCIS1                                          CGL132
     C                   EVAL      FACIS2 = A_FVCIS2                                          CGL132
     C                   EVAL      FACIS3 = A_FVCIS3                                          CGL132
     C                   EVAL      FACIS4 = A_FVCIS4                                          CGL132
     C                   EVAL      FACIS5 = A_FVCIS5                                          CGL132
     C                   EVAL      FACICO = A_FVCICO                                          CGL132
     C                   EVAL      FACBSV = A_FVCBSV                                          CGL132
     C                   EVAL      FACBSD = A_FVCBSD                                          CGL132
     C                   EVAL      FACBOV = A_FVCBOV                                          CGL132
     C                   IF        FACBOV <> *BLANKS                                        MD027606
     C                   EVAL      FACBON = WLUSER                                          MD027606
     C                   EVAL      FACBOD = BJRDNB                                          MD027606
     C                   EVAL      FACBOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FACBD1 = A_FVCBD1                                          CGL132
     C                   EVAL      FACBD2 = A_FVCBD2                                          CGL132
     C                   EVAL      FACBD3 = A_FVCBD3                                          CGL132
     C                   EVAL      FACBD4 = A_FVCBD4                                          CGL132
     C                   EVAL      FACBD5 = A_FVCBD5                                          CGL132
     C                   EVAL      FACBS1 = A_FVCBS1                                          CGL132
     C                   EVAL      FACBS2 = A_FVCBS2                                          CGL132
     C                   EVAL      FACBS3 = A_FVCBS3                                          CGL132
     C                   EVAL      FACBS4 = A_FVCBS4                                          CGL132
     C                   EVAL      FACBS5 = A_FVCBS5                                          CGL132
     C                   EVAL      FACBCO = A_FVCBCO                                          CGL132
     C                   EVAL      FACDSV = A_FVCDSV                                          CGL132
     C                   EVAL      FACDSD = A_FVCDSD                                          CGL132
     C                   EVAL      FACDOV = A_FVCDOV                                          CGL132
     C                   IF        FACDOV <> *BLANKS                                        MD027606
     C                   EVAL      FACDON = WLUSER                                          MD027606
     C                   EVAL      FACDOD = BJRDNB                                          MD027606
     C                   EVAL      FACDOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FACDD1 = A_FVCDD1                                          CGL132
     C                   EVAL      FACDD2 = A_FVCDD2                                          CGL132
     C                   EVAL      FACDD3 = A_FVCDD3                                          CGL132
     C                   EVAL      FACDD4 = A_FVCDD4                                          CGL132
     C                   EVAL      FACDD5 = A_FVCDD5                                          CGL132
     C                   EVAL      FACDS1 = A_FVCDS1                                          CGL132
     C                   EVAL      FACDS2 = A_FVCDS2                                          CGL132
     C                   EVAL      FACDS3 = A_FVCDS3                                          CGL132
     C                   EVAL      FACDS4 = A_FVCDS4                                          CGL132
     C                   EVAL      FACDS5 = A_FVCDS5                                          CGL132
     C                   EVAL      FACDCO = A_FVCDCO                                          CGL132
     C                   EVAL      FAGCSV = A_FVGCSV                                          CGL132
     C                   EVAL      FAGCSD = A_FVGCSD                                          CGL132
     C                   EVAL      FAGCOV = A_FVGCOV                                          CGL132
     C                   IF        FAGCOV <> *BLANKS                                        MD027606
     C                   EVAL      FAGCON = WLUSER                                          MD027606
     C                   EVAL      FAGCOD = BJRDNB                                          MD027606
     C                   EVAL      FAGCOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FAGCD1 = A_FVGCD1                                          CGL132
     C                   EVAL      FAGCD2 = A_FVGCD2                                          CGL132
     C                   EVAL      FAGCD3 = A_FVGCD3                                          CGL132
     C                   EVAL      FAGCD4 = A_FVGCD4                                          CGL132
     C                   EVAL      FAGCD5 = A_FVGCD5                                          CGL132
     C                   EVAL      FAGCS1 = A_FVGCS1                                          CGL132
     C                   EVAL      FAGCS2 = A_FVGCS2                                          CGL132
     C                   EVAL      FAGCS3 = A_FVGCS3                                          CGL132
     C                   EVAL      FAGCS4 = A_FVGCS4                                          CGL132
     C                   EVAL      FAGCS5 = A_FVGCS5                                          CGL132
     C                   EVAL      FAGCCO = A_FVGCCO                                          CGL132
     C                   EVAL      FAIDSV = A_FVIDSV                                          CGL132
     C                   EVAL      FAIDSD = A_FVIDSD                                          CGL132
     C                   EVAL      FAIDOV = A_FVIDOV                                          CGL132
     C                   IF        FAIDOV <> *BLANKS                                        MD027606
     C                   EVAL      FAIDON = WLUSER                                          MD027606
     C                   EVAL      FAIDOD = BJRDNB                                          MD027606
     C                   EVAL      FAIDOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FAIDD1 = A_FVIDD1                                          CGL132
     C                   EVAL      FAIDD2 = A_FVIDD2                                          CGL132
     C                   EVAL      FAIDD3 = A_FVIDD3                                          CGL132
     C                   EVAL      FAIDD4 = A_FVIDD4                                          CGL132
     C                   EVAL      FAIDD5 = A_FVIDD5                                          CGL132
     C                   EVAL      FAIDS1 = A_FVIDS1                                          CGL132
     C                   EVAL      FAIDS2 = A_FVIDS2                                          CGL132
     C                   EVAL      FAIDS3 = A_FVIDS3                                          CGL132
     C                   EVAL      FAIDS4 = A_FVIDS4                                          CGL132
     C                   EVAL      FAIDS5 = A_FVIDS5                                          CGL132
     C                   EVAL      FAIDCO = A_FVIDCO                                          CGL132
     C                   EVAL      FAJASV = A_FVJASV                                          CGL132
     C                   EVAL      FAJASD = A_FVJASD                                          CGL132
     C                   EVAL      FAJAOV = A_FVJAOV                                          CGL132
     C                   IF        FAJAOV <> *BLANKS                                        MD027606
     C                   EVAL      FAJAON = WLUSER                                          MD027606
     C                   EVAL      FAJAOD = BJRDNB                                          MD027606
     C                   EVAL      FAJAOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FAJAD1 = A_FVJAD1                                          CGL132
     C                   EVAL      FAJAD2 = A_FVJAD2                                          CGL132
     C                   EVAL      FAJAD3 = A_FVJAD3                                          CGL132
     C                   EVAL      FAJAD4 = A_FVJAD4                                          CGL132
     C                   EVAL      FAJAD5 = A_FVJAD5                                          CGL132
     C                   EVAL      FAJAS1 = A_FVJAS1                                          CGL132
     C                   EVAL      FAJAS2 = A_FVJAS2                                          CGL132
     C                   EVAL      FAJAS3 = A_FVJAS3                                          CGL132
     C                   EVAL      FAJAS4 = A_FVJAS4                                          CGL132
     C                   EVAL      FAJAS5 = A_FVJAS5                                          CGL132
     C                   EVAL      FAJACO = A_FVJACO                                          CGL132
     C                   EVAL      FATESV = A_FVTESV                                          CGL132
     C                   EVAL      FATESD = A_FVTESD                                          CGL132
     C                   EVAL      FATEOV = A_FVTEOV                                          CGL132
     C                   IF        FATEOV <> *BLANKS                                        MD027606
     C                   EVAL      FATEON = WLUSER                                          MD027606
     C                   EVAL      FATEOD = BJRDNB                                          MD027606
     C                   EVAL      FATEOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FATED1 = A_FVTED1                                          CGL132
     C                   EVAL      FATED2 = A_FVTED2                                          CGL132
     C                   EVAL      FATED3 = A_FVTED3                                          CGL132
     C                   EVAL      FATED4 = A_FVTED4                                          CGL132
     C                   EVAL      FATED5 = A_FVTED5                                          CGL132
     C                   EVAL      FATES1 = A_FVTES1                                          CGL132
     C                   EVAL      FATES2 = A_FVTES2                                          CGL132
     C                   EVAL      FATES3 = A_FVTES3                                          CGL132
     C                   EVAL      FATES4 = A_FVTES4                                          CGL132
     C                   EVAL      FATES5 = A_FVTES5                                          CGL132
     C                   EVAL      FATECO = A_FVTECO                                          CGL132
     C                   EVAL      FATXSV = A_FVTXSV                                          CGL132
     C                   EVAL      FATXSD = A_FVTXSD                                          CGL132
     C                   EVAL      FATXOV = A_FVTXOV                                          CGL132
     C                   IF        FATXOV <> *BLANKS                                        MD027606
     C                   EVAL      FATXON = WLUSER                                          MD027606
     C                   EVAL      FATXOD = BJRDNB                                          MD027606
     C                   EVAL      FATXOT = WWTIME                                          MD027606
     C                   ENDIF                                                              MD027606
     C                   EVAL      FATXD1 = A_FVTXD1                                          CGL132
     C                   EVAL      FATXD2 = A_FVTXD2                                          CGL132
     C                   EVAL      FATXD3 = A_FVTXD3                                          CGL132
     C                   EVAL      FATXD4 = A_FVTXD4                                          CGL132
     C                   EVAL      FATXD5 = A_FVTXD5                                          CGL132
     C                   EVAL      FATXS1 = A_FVTXS1                                          CGL132
     C                   EVAL      FATXS2 = A_FVTXS2                                          CGL132
     C                   EVAL      FATXS3 = A_FVTXS3                                          CGL132
     C                   EVAL      FATXS4 = A_FVTXS4                                          CGL132
     C                   EVAL      FATXS5 = A_FVTXS5                                          CGL132
     C                   EVAL      FATXCO = A_FVTXCO                                          CGL132
     C                   EVAL      FAEXEM = A_FVEXEM                                          CGL132
     C                   EVAL      FAEXER = A_FVEXER                                          CGL132
     C                   EVAL      FAEXED = A_FVEXED                                          CGL132
     C                   EVAL      FAEXET = A_FVEXET                                          CGL132
     C                   EVAL      FAEXEU = A_FVEXEU                                          CGL132
     C                   EVAL      FAREPT = A_FVREPT                                          CGL132
     C                   EVAL      FAGIIN = A_FVGIIN                                          CGL132
     C                   EVAL      FAGIID = A_FVGIID                                          CGL132
     C                   EVAL      FAGIIO = A_FVGIIO                                          CGL132
     C                   EVAL      FAUTIN = A_FVUTIN                                          CGL132
     C                   EVAL      FAGREC = A_FVGREC                                          CGL132
     C                   EVAL      FAMAIL = A_FVMAIL                                          CGL132
     C                   EVAL      FAPHON = A_FVPHON                                          CGL132
     C                   EVAL      FACSTY = A_FVCSTY                                          CGL132
     C                   EVAL      FACSST = A_FVCSST                                          CGL132
     C                   EVAL      FARPTT = A_FVRPTT                                          CGL132
     C                   EVAL      FARPTR = A_FVRPTR                                          CGL132
     C                   EVAL      FARPTD = A_FVRPTD                                          CGL132
     C                   EVAL      FARPTM = A_FVRPTM                                          CGL132
     C                   IF        FARPTM = '******'                                        MD051206
     C                   MOVE      BBTMST        WTime                                      MD051206
     C     *HMS0         MOVE      WTime         FARPTM                                     MD051206
     C                   ENDIF                                                              MD051206
     C                   EVAL      FARPTU = A_FVRPTU                                          CGL132
     C                   EVAL      FAHVAC = A_FVHVAC                                          CGL132
     C                   EVAL      FAINFC = A_FVINFC                                          CGL132
     C                   EVAL      FAEXMA = A_FVEXMA                                          CGL132
     C                   EVAL      FAEXID = A_FVEXID                                          CGL132
     C                   EVAL      FALDAT = BJRDNB                                            CGL132
     C                   EVAL      FALCTP = 'I'                                               CGL132
     C**********         EVAL      FALUSR = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FALUSR = WKUSER                                 MD026835 MD027492
     C**********         EVAL      FALUSR = A_FVRPTU                              MD027492 MD027492A
     C                   EVAL      FALUSR = WLUSER                                         MD027492A
     C                   EVAL      FAREPA = A_FVREPA                                          CGL132
     C                   EVAL      FAFOID = A_FVFOID                                          CGL132
     C                   EVAL      FAREPI = A_FVREPI                                          CGL132
     C                   WRITE     SDFTCSD0                                                   CGL132
                                                                                              CGL132
     C                   IF        CSD092 = 'Y'                                               CGL132
     C                   EVAL      PAftFTCS = SDFTCS                                        MD026957
     C                   EVAL      PAftCUXC = SDCUXC                                        MD026957
     C                   IF        S01425 <> 'Y' OR CSD079 <> 'Y'                           MD026957
     C                   IF        CGL157 = 'N'                                               CGL157
     C                   CALL      'SD009696'                                                 CGL132
     C                   PARM      FACUST        PCUST                                        CGL132
     C                   PARM      *BLANKS       PBefCUST                                     CGL132
     C                   PARM      CUSTDF        PAftCUST                                     CGL132
     C                   PARM      *BLANKS       PBefACUS                                     CGL132
     C                   PARM      *BLANKS       PAftACUS                                     CGL132
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      SDFTCS        PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CGL132
     C                   PARM      *BLANKS       PAftJACC                                     CGL132
     C                   PARM      *BLANKS       PBefCUAH                                     CGL132
     C                   PARM      *BLANKS       PAftCUAH                                     CGL132
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      SDCUXC        PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CGL132
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                              MD026957
                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             FAHVAC = 'H'                                               CGL132
     C                   EVAL      KCUST = FACUST                                             CGL132
     C                   EVAL      KSCDT = BJRDNB                                             CGL132
     C                   EVAL      KSEQN = 999                                                CGL132
     C                   EVAL      ARSEQN = 0                                                 CGL132
     C     KACRV         SETGT     SDACRVL0                                                   CGL132
     C                   READP     SDACRVL0                                                   CGL132
                                                                                              CGL132
     C                   IF        ARCUST = KCUST AND                                         CGL132
     C                             ARSCDT = KSCDT                                             CGL132
     C                   EVAL      AVSEQN = ARSEQN + 1                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   CLEAR                   SDACRVDF                                   MD045218
     C                   EVAL      AVSEQN = 1                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C**********         CLEAR                   SDACRVDF                            CGL132 MD045218
                                                                                              CGL132
     C                   EVAL      ARCUST = FACUST                                            CGL132
     C                   EVAL      ARSEQN = AVSEQN                                            CGL132
     C                   EVAL      ARPURP = 'FATCA High Value +                               CGL132
     C                                      Account Review'                                   CGL132
     C**********         EVAL      ARSCDT = BJRDNB                                   CGL132 MD026502
     C                   EVAL      ARACRF = SVal2                                             CGL132
     C                   EVAL      ARCOMP = 'N'                                               CGL132
                                                                                            MD026502
      ** Calculate for Schedule Date                                                        MD026502
     C                   CALL      'SD000164'                                               MD026502
     C                   PARM      *BLANKS       RtCdScDt          7                        MD026502
     C                   PARM      ARACRF        AcRvFreq          1                        MD026502
     C                   PARM      ARCOMP        AcRvComp          1                        MD026502
     C                   PARM                    BJDFIN                                     MD026502
     C                   PARM                    BJCYCD                                     MD026502
     C                   PARM                    BJLCCY                                     MD026502
     C                   PARM                    BJSLCD                                     MD026502
     C                   PARM                    BJRDNB                                     MD026502
     C                   PARM      0             AcRvScDt          5 0                      MD026502
      ** Account Review Schedule Date                                                       MD026502
     C                   EVAL      ARSCDT = AcRvScDt                                        MD026502
                                                                                              CGL132
      ** Get timestamp.                                                                       CGL132
                                                                                              CGL132
     C                   CALLB     'ZAGENTMSTM'                                               CGL132
     C                   PARM                    WWTMST                                       CGL132
     C                   MOVE      WWTMST        ARTMST                                       CGL132
                                                                                              CGL132
     C                   EVAL      ARMAGE = 'G'                                               CGL132
     C                   EVAL      ARLTYP = 'I'                                               CGL132
     C**********         EVAL      ARLUSR = PSUSER                                   CGL132 MD026835
     C**********         EVAL      ARLUSR = WKUSER                                MD026835 MD027492A
     C                   EVAL      ARLUSR = WLUSER                                         MD027492A
     C                   EVAL      ARINDT = BJRDNB                                            CGL132
     C                   EVAL      ARFOID = *BLANKS                                           CGL132
                                                                                              CGL132
     C                   WRITE     SDACRVD0                                                   CGL132
     C**********         ENDIF                                                      CGL132 MD026499A
                                                                                              CGL132
     C                   EVAL      EXDDCUST = ARCUST                                        MD026499
     C                   EVAL      EXDDSCDF = *BLANKS                                       MD026499
     C                   MOVEL     ARSCDT        EXDDSCDF                                   MD026499
     C                   EVAL      EXDDSEQN = %TRIML(%CHAR(ARSEQN):'0')                     MD026499
     C                   EVAL      EXDDFOID = ARFOID                                        MD026499
     C                   WRITE     TSDACRVD0                                                MD026499
                                                                                            MD026499
     C                   ENDIF                                                             MD026499A
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL157
      ** Access CRS Transaction Details if CGL157 is *ON                                      CGL157
                                                                                              CGL157
     C                   EVAL      PBefCRSH = *BLANKS                                         CGL177
     C                   EVAL      PAftCRSH = *BLANKS                                         CGL177
     C                   IF        CGL157 = 'Y'                                               CGL157
                                                                                              CGL157
      ** Write new Transaction Detail                                                         CGL177
                                                                                              CGL177
     C                   EVAL      CRCUST = BBCUST                                            CGL177
     C                   EVAL      CRTYPE = C_CVTYPE                                          CGL177
     C                   EVAL      CRSTYP = C_CVSTYP                                          CGL177
     C                   EVAL      CRHVAL = C_CVHVAL                                          CGL177
     C                   EVAL      CREXMP = C_CVEXMP                                          CGL177
     C                   EVAL      CREXMR = C_CVEXMR                                          CGL177
     C                   EVAL      CREXMD = C_CVEXMD                                          CGL177
     C                   EVAL      CREXMT = C_CVEXMT                                          CGL177
     C                   EVAL      CREXMU = C_CVEXMU                                          CGL177
     C                   EVAL      CRINFO = C_CVINFO                                          CGL177
     C                   EVAL      CREXMG = C_CVEXMG                                          CGL177
     C                   EVAL      CREXMI = C_CVEXMI                                          CGL177
     C                   EVAL      CRLDAT = BJRDNB                                            CGL177
     C                   EVAL      CRLCTP = 'I'                                               CGL177
     C                   WRITE     SDCRSHD0                                                   CGL157
     C                   EVAL      PAftCRSH = SDCRSH                                          CGL177
                                                                                              CGL177
      ** CRS Country Details                                                                  CGL177
     C                   EVAL      A = 1                                                      CGL177
     C                   EVAL      X = 1                                                      CGL157
     C                   DOW       X < 31                                                     CGL157
     C                   EVAL      SDVCRSD =  PCrsdF(X)                                       CGL157
     C                   EVAL      PCrsdZ = PCrsdF(X)                                         CGL157
     C                   IF        D_CVCTRY <> *Blanks                                        CGL157
     C                   EVAL      KCUST = BBCUST                                             CGL177
     C                   EVAL      KCTRY = D_CVCTRY                                           CGL177
     C     KCRSD         CHAIN     SDCRSDL1                                                   CGL177
     C                   EVAL      SDCRSDB = SDCRSD                                           CGL177
     C                   EVAL      CDCUST = BBCUST                                            CGL157
     C                   EVAL      CDCTRY = D_CVCTRY                                          CGL157
     C                   EVAL      CDREPT = D_CVREPT                                          CGL157
     C                   EVAL      CDREPR = D_CVREPR                                          CGL157
                                                                                            MD036375
      ** Look for the US Country and use the TIN if provided                                MD036375
     C                   IF        CGL132 = 'Y' AND                                         MD036375
     C                             CGL133 = 'N'                                             MD036375
     C*****BBCUST        CHAIN     SDFTCSL0                             99         MD036375 MD051230
     C     BBCUST        CHAIN(N)  SDFTCSL0                             99                  MD051230
                                                                                            MD036375
      ** Database error                                                                     MD036375
     C                   IF        NOT %FOUND(SDFTCSL0)                                     MD036375
     C                   EVAL      DBKEY  = BBCUST                                          MD036375
     C                   EVAL      DBFILE = 'SDFTCSPD'                                      MD036375
     C                   EVAL      DBASE  =  801                                            MD036375
     C                   EXSR      SRErr                                                    MD036375
     C                   ENDIF                                                              MD036375
                                                                                            MD036375
     C                   EVAL      WCTAX = SVal1                                            MD036375
                                                                                            MD036375
     C                   IF        BBCOLC = WCTAX                                           MD036375
     C     BBCUST        CHAIN     SDFTCSL0                             99                  MD051230
     C                   EVAL      FAUTIN = E5TINO                                          MD036375
     C                   UPDATE    SDFTCSD0                                                 MD036375
     C                   ELSE                                                               MD036457
     C                   IF        D_CVCTRY = WCTAX                                         MD036457
     C     BBCUST        CHAIN     SDFTCSL0                             99                  MD051230
     C                   EVAL      FAUTIN = D_CVTINN                                        MD036457
     C                   UPDATE    SDFTCSD0                                                 MD036457
     C                   ENDIF                                                              MD036457
     C                   ENDIF                                                              MD036457
     C                   ENDIF                                                              MD036375
                                                                                            MD036375
     C                   IF        %SUBST(PCrsdZ:138:3) = *Blanks                             CGL157
     C                   EVAL      CDREPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_CVREPD      CDREPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CDREPM = D_CVREPM                                          CGL157
     C                   IF        CDREPM = '******'                                          CGL177
     C**********         MOVE      E5TMST        WTime                               CGL177 MD051230
     C                   MOVE      BBTMST        WTime                                      MD051230
     C     *HMS0         MOVE      WTime         CDREPM                                       CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      CDREPU = D_CVREPU                                          CGL157
     C                   EVAL      CDEVE1 = D_CVEVE1                                          CGL157
     C                   EVAL      CDEVS1 = D_CVEVS1                                          CGL157
     C                   EVAL      CDEVE2 = D_CVEVE2                                          CGL157
     C                   EVAL      CDEVS2 = D_CVEVS2                                          CGL157
     C                   EVAL      CDEVE3 = D_CVEVE3                                          CGL157
     C                   EVAL      CDEVS3 = D_CVEVS3                                          CGL157
     C                   EVAL      CDEVE4 = D_CVEVE4                                          CGL157
     C                   EVAL      CDEVS4 = D_CVEVS4                                          CGL157
     C                   EVAL      CDEVE5 = D_CVEVE5                                          CGL157
     C                   EVAL      CDEVS5 = D_CVEVS5                                          CGL157
     C                   EVAL      CDTINN = D_CVTINN                                          CGL157
     C                   EVAL      CDCODO = D_CVCODO                                          CGL157
     C                   EVAL      CDJACM = D_CVJACM                                          CGL157
     C                   EVAL      CDMAIL = D_CVMAIL                                          CGL157
     C                   EVAL      CDPHON = D_CVPHON                                          CGL157
     C                   EVAL      CDRPAY = D_CVRPAY                                          CGL157
     C                   EVAL      CDTINS = D_CVTINS                                          CGL177
     C                   IF        %SUBST(PCrsdZ:207:3) = *Blanks                             CGL157
     C                   EVAL      CDEFFD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_CVEFFD      CDEFFD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        %SUBST(PCrsdZ:210:3) = *Blanks                             CGL157
     C                   EVAL      CDEXPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_CVEXPD      CDEXPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        %FOUND(SDCRSDL1)                                           CGL177
     C                   IF        %SUBST(PCrsdZ:3:1) <> '*'                                  CGL177
     C                   EVAL      %SUBST(PBefCRSD:A:219) = SDCRSDB                           CGL177
     C                   EVAL      %SUBST(PAftCRSD:A:219) = SDCRSD                            CGL177
     C                   EVAL      A = A + 229                                                CGL177
     C                   UPDATE    SDCRSDD0                                                   CGL177
     C                   ELSE                                                                 CGL177
     C                   DELETE    SDCRSDD0                                                   CGL177
     C                   ENDIF                                                                CGL177
     C                   ELSE                                                                 CGL177
     C                   IF        %SUBST(PCrsdZ:3:1) <> '*'                                  CGL177
     C                   EVAL      %SUBST(PBefCRSD:A:219) = *Blanks                           CGL177
     C                   EVAL      %SUBST(PAftCRSD:A:219) = SDCRSD                            CGL177
     C                   EVAL      A = A + 229                                                CGL177
     C                   WRITE     SDCRSDD0                                                   CGL157
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL157
     C                   EVAL      X = X + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL177
     C                   IF        CSD092 = 'Y'                                               CGL177
     C                             AND NOT(S01425 = 'Y' AND CSD079 = 'Y')                     CGL177
     C                   IF        CGL132 = 'Y'                                               CGL177
     C                   EVAL      PBefFTCS = SDFTCS2                                         CGL177
     C                   EVAL      PAftFTCS = SDFTCS                                          CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      PBefFTCS = *BLANKS                                         CGL177
     C                   EVAL      PAftFTCS = *BLANKS                                         CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        CGL157 = 'N'                                               CGL177
     C                   EVAL      PBefCRSH = *BLANKS                                         CGL177
     C                   EVAL      PAftCRSH = *BLANKS                                         CGL177
     C                   EVAL      PBefCRSD = *BLANKS                                         CGL177
     C                   EVAL      PAftCRSD = *BLANKS                                         CGL177
     C                   ENDIF                                                                CGL177
                                                                                            MD041429
      ** Separate call of History of Customer Info program                                  MD041429
      ** for CRS Header (Miscellaneous Change)                                              MD041429
                                                                                            MD041429
     C                   IF        CGL132 = 'Y'                                               CGL157
     C                   CALL      'SD009696'                                                 CGL177
     C                   PARM      BBCUST        PCUST                                        CGL177
     C                   PARM      *BLANKS       PBefCUST                                     CGL177
     C                   PARM      CUSTDF        PAftCUST                                     CGL177
     C                   PARM      *BLANKS       PBefACUS                                     CGL177
     C                   PARM      *BLANKS       PAftACUS                                     CGL177
     C                   PARM                    PBefFTCS                                     CGL177
     C                   PARM                    PAftFTCS                                     CGL177
     C                   PARM      *BLANKS       PBefJACC                                     CGL177
     C                   PARM      *BLANKS       PAftJACC                                     CGL177
     C                   PARM      *BLANKS       PBefCUXC                                     CGL177
     C                   PARM      *BLANKS       PAftCUXC                                     CGL177
     C                   PARM      *BLANKS       PACRV                                        CGL177
     C                   PARM      *BLANKS       PELEC                                        CGL177
     C                   PARM                    PBefCRSH                                     CGL177
     C                   PARM                    PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       XBefCRSD                                     CGL177
     C                   PARM      *BLANKS       XAftCRSD                                     CGL177
                                                                                              CGL177
     C                   ELSE                                                                 CGL177
                                                                                              CGL177
     C                   CALL      'SD009696'                                                 CGL177
     C                   PARM      BBCUST        PCUST                                        CGL177
     C                   PARM      *BLANKS       PBefCUST                                     CGL177
     C                   PARM      CUSTDF        PAftCUST                                     CGL177
     C                   PARM      *BLANKS       PBefACUS                                     CGL177
     C                   PARM      *BLANKS       PAftACUS                                     CGL177
     C                   PARM      *BLANKS       PBefFTCS                                     CGL177
     C                   PARM      *BLANKS       PAftFTCS                                     CGL177
     C                   PARM      *BLANKS       PBefJACC                                     CGL177
     C                   PARM      *BLANKS       PAftJACC                                     CGL177
     C                   PARM      *BLANKS       PBefCUXC                                     CGL177
     C                   PARM      *BLANKS       PAftCUXC                                     CGL177
     C                   PARM      *BLANKS       PACRV                                        CGL177
     C                   PARM      *BLANKS       PELEC                                        CGL177
     C                   PARM                    PBefCRSH                                     CGL177
     C                   PARM                    PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       XBefCRSD                                   MD041429
     C                   PARM      *BLANKS       XAftCRSD                                   MD041429
     C                   ENDIF                                                              MD041429
                                                                                            MD041429
      ** and CRS Details (CRS Indicia Change)                                               MD041429
                                                                                            MD041429
     C                   CALL      'SD009696'                                               MD041429
     C                   PARM      BBCUST        PCUST                                      MD041429
     C                   PARM      *BLANKS       PBefCUST                                   MD041429
     C                   PARM      *BLANKS       PAftCUST                                   MD041429
     C                   PARM      *BLANKS       PBefACUS                                   MD041429
     C                   PARM      *BLANKS       PAftACUS                                   MD041429
     C                   PARM      *BLANKS       PBefFTCS                                   MD041429
     C                   PARM      *BLANKS       PAftFTCS                                   MD041429
     C                   PARM      *BLANKS       PBefJACC                                   MD041429
     C                   PARM      *BLANKS       PAftJACC                                   MD041429
     C                   PARM      *BLANKS       PBefCUXC                                   MD041429
     C                   PARM      *BLANKS       PAftCUXC                                   MD041429
     C                   PARM      *BLANKS       PACRV                                      MD041429
     C                   PARM      *BLANKS       PELEC                                      MD041429
     C                   PARM      *BLANKS       PBefCRSH                                   MD041429
     C                   PARM      *BLANKS       PAftCRSH                                   MD041429
     C                   PARM                    PBefCRSD                                   MD041429
     C                   PARM                    PAftCRSD                                   MD041429
     C                   ENDIF                                                              MD041429
                                                                                            MD041429

      * Update CLINTCB - Client Details  *
     C                   CALL      'SDCLINT'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      BBCUST        @CUST             6
     C                   PARM      BBCSSN        @CSSN            10
     C                   PARM      BBCRTN        @CRTN            10
     C                   PARM      BBPAIN        @PAIN             1
     C                   PARM      BBCRNM        @CRNM            20
     C                   PARM      BBACOC        @ACOC             2
     C                   PARM      BBCNCZ        @CNCZ             2
     C                   PARM      BBCOLC        @COLC             2
     C                   PARM      BBSSDT        @SSDT             5 0
     C                   PARM      BBDOIC        @DOIC             5 0
     C                   PARM      BBPCNB        @PCNB             6
     C                   PARM      BBCASC        @CASC             8
     C                   PARM      BBBRCD        @BRCD             3
     C                   PARM      BBBNBI        @BNBI             1
     C                   PARM      BBLINC        @LINC             2
     C                   PARM      BBLICD        @LICD             3
     C                   PARM      BBCTNB        @CTNB            12
     C                   PARM      BBREID        @REID             4
     C                   PARM      BBBSIN        @BSIN             1
     C                   PARM      BBCSTY        @CSTY             1
     C                   PARM      BBTAIN        @TAIN             1
     C                   PARM      BBCSID        @CSID            12
     C                   PARM      BBSTAD        @STAD            12
     C                   PARM      BBTXA1        @TXA1            10
     C                   PARM      BBCHID        @CHID             6 0
     C                   PARM      BBCHSC        @CHSC             6 0
     C                   PARM      BBCABA        @CABA             3 0
     C                   PARM      BBRWCD        @RWCD             4
     C                   PARM      BBCGRP        @CGRP             1
     C                   PARM      BBABA2        @ABA2             4 0
     C                   PARM      BBTYLC        @TYLC             1
     C                   PARM      BJRDNB        @RDNB             5 0
     C                   PARM      WUGPC1        @GPC1             4
     C                   PARM      WUGPC2        @GPC2             4
     C                   PARM      WUGPC3        @GPC3             4
     C                   PARM      WUGPC4        @GPC4             4
     C                   PARM      WUGPC5        @GPC5             4
     C                   PARM      A_ADLNID      @LNID             2                        AR830675
     C                   PARM      A_ADCTYP      @CTYP            10                        AR830675
     C/COPY WNCPYSRC,SDCUSDDC06
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'CLINTCB'     DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END

      * Update CLINTCC 2 - Client Details  *
     C                   CALL      'SDALTNA'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      BBCUST        @CUST             6
     C                   PARM      BBCNA1        @CNA1            35
     C                   PARM      BBCNA2        @CNA2            35
     C                   PARM      BBCNA3        @CNA3            35
     C                   PARM      BBCNA4        @CNA4            35
     C                   PARM      BBCRTN        @CRTN            10
     C                   PARM      BBTYLC        @TYLC             1
     C                   PARM      BJRDNB        @RDNB             5 0
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'CLINTCC'     DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
      *

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* AMEND  - AMEND A CUSTOMER                                    *
     C*                                                              *
     C****************************************************************
     C     AMEND         BEGSR

      ** ACCESS CUSTOMER DETAILS RECORD

     C     A_CUCUST      CHAIN     SDCUSTL0                           99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '1'
     C     CSD028        ANDEQ     'N'                                                        CSD028
     C     CSD028        OREQ      'Y'                                                        CSD028
     C     PTransType    ANDNE     'AUTH'                                                     CSD028
     C                   MOVEL     A_CUCUST      DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   CLEAR                   CUSTDF2                                      CGL132
     C                   MOVE      CUSTDF        CUSTDF2                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CSD028
     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                       CSD028
     C     A_CUCUST      CHAIN     SDCDSHD0                           99                      CSD028
     C     *IN99         IFEQ      '1'                                                        CSD028
     C                   MOVEL     A_CUCUST      DBKEY                                        CSD028
     C                   MOVEL     'SDCDSHPD'    DBFILE                         ************  CSD028
     C                   MOVEL     '024'         DBASE                          * DBERR 024*  CSD028
     C                   EXSR      SRERR                                        ************  CSD028
     C                   END                                                                  CSD028
     C                   EVAL      CUSTDF = SDVCDSH                                           CSD028
     C                   ENDIF                                                                CSD028

      ** UPDATE 'BEFORE' STATUS
                                                                                              CGL132
      ** DATABASE ERROR                                                                       CGL132
                                                                                              CGL132
     C     A_CUCUST      CHAIN     SDCUSTX1                           99                      CGL132
     C                   CLEAR                   SDCUXC2                                    MD026854
     C                   MOVE      SDCUXC        SDCUXC2                                    MD026854
     C     *IN99         IFEQ      '1'                                                        CGL132
     C*****CGL132        ANDEQ     'Y'                                             MD030958 MD042407
     C                   MOVEL     A_CUCUST      DBKEY                                        CGL132
     C                   MOVEL     'SDCUSTXC'    DBFILE                         ************  CGL132
     C                   MOVEL     '004'         DBASE                          * DBERR 004*  CGL132
     C                   EXSR      SRERR                                        ************  CGL132
     C                   ENDIF                                                                CGL132

     C                   MOVEL(P)  CUSTDF        B_CUSTD
                                                                                185595
      ** Check if change of customer branch                                     185595
                                                                                185595
     C     BBBRCD        IFNE      A_CUBRCD                                     185595
     C     BBTAIN        ORNE      A_CUTAIN                                                   217230
     C                   EVAL      *IN20='1'                                    185595
     C                   ELSE                                                   185595
     C                   EVAL      *IN20='0'                                    185595
     C                   END                                                    185595
     C/COPY WNCPYSRC,SDCUSDDC04

      ** SET CUSTOMER FIELDS ON AMEND

      * CASE: DB1.Customer Swift Id NE PAR.Customer Swift Id
     C     BBCSID        IFNE      A_CUCSID
     C                   CALL      'SD0012U'                            91
     C                   PARM      BBCSID        @CSIDO           12
     C                   PARM      A_CUCSID      @CSIDN           12
     C                   PARM      *BLANK        @SWBL             1
     C                   PARM      BBCUST        @CNUM             6                          210006
      * Call to program ended in error
     C     *IN91         IFEQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCSID        DBKEY
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
      * CASE: WRK.Swift Blank is True
     C     @SWBL         IFEQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCSID        DBKEY
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   END
      *                                                                                       CSW036
      * CASE: DB1.Customer Swift Id 2 NE PAR.Customer Swift Id 2                              CSW036
     C     CSW036        IFEQ      'Y'                                                        CSW036
     C     BBCSI2        ANDNE     A_CUCSI2                                                   CSW036
     C                   CALL      'SD0012U1'                           91                    CSW036
     C                   PARM      BBCSI2        @CSIDO           12                          CSW036
     C                   PARM      A_CUCSI2      @CSIDN           12                          CSW036
     C                   PARM      *BLANK        @SWBL             1                          CSW036
     C                   PARM      BBCUST        @CNUM             6                          CSW036
      * Call to program ended in error                                                        CSW036
     C     *IN91         IFEQ      '1'                                                        CSW036
     C                   MOVEL     *BLANK        DBKEY                                        CSW036
     C                   MOVEL     BBCSI2        DBKEY                                        CSW036
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************  CSW036
     C                   MOVEL     '025'         DBASE                          * DBERR 025*  CSW036
     C                   EXSR      SRERR                                        ************  CSW036
     C                   END                                                                  CSW036
      * CASE: WRK.Swift Blank is True                                                         CSW036
     C     @SWBL         IFEQ      '1'                                                        CSW036
     C                   MOVEL     *BLANK        DBKEY                                        CSW036
     C                   MOVEL     BBCSI2        DBKEY                                        CSW036
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************  CSW036
     C                   MOVEL     '026'         DBASE                          * DBERR 026*  CSW036
     C                   EXSR      SRERR                                        ************  CSW036
     C                   END                                                                  CSW036
     C                   END                                                                  CSW036
      *
      * CASE: DB1.Telex Address 1 NE PAR.Telex Address 1
     C     BBTXA1        IFNE      A_CUTXA1
     C                   CALL      'SD0013U'                            91
     C                   PARM      BBTXA1        @TXA1O           12
     C                   PARM      BBSTAD        @STADO           12
     C                   PARM      A_CUTXA1      @TAX1N           12
     C                   PARM      A_CUSTAD      @STADN           12
     C                   PARM      *BLANK        @TXBL             1
      * Call to program ended in error
     C     *IN91         IFEQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBTXA1        DBKEY
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************
     C                   MOVEL     '007'         DBASE                          * DBERR 007*
     C                   EXSR      SRERR                                        ************
     C                   END
      * CASE: WRK.Telex Blank is true
     C     @TXA1         IFEQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBTXA1        DBKEY
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************
     C                   MOVEL     '008'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DB1.STTX Address NE PAR.STTX Address
     C     BBSTAD        IFNE      A_CUSTAD
     C                   CALL      'SD0013U'                            91
     C                   PARM      BBTXA1        @TXA1O           12
     C                   PARM      BBSTAD        @STADO           12
     C                   PARM      A_CUTXA1      @TAX1N           12
     C                   PARM      A_CUSTAD      @STADN           12
     C                   PARM      @TXBL         @TXBL             1
      * Call to program ended in error
     C     *IN91         IFEQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBTXA1        DBKEY
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************
     C                   MOVEL     '009'         DBASE                          * DBERR 009*
     C                   EXSR      SRERR                                        ************
     C                   END
      * CASE: WRK.Telex Blank is true
     C     @TXA1         IFEQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBTXA1        DBKEY
     C                   MOVEL     'MOGREFLZ'    DBFILE                         ************
     C                   MOVEL     '010'         DBASE                          * DBERR 010*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** MOVE NON-KEY FIELDS
     C                   EVAL      BBCSSN=A_CUCSSN
     C                   EVAL      BBCNA1=A_CUCNA1
     C                   EVAL      BBCNA2=A_CUCNA2
     C                   EVAL      BBCNA3=A_CUCNA3
     C                   EVAL      BBCNA4=A_CUCNA4
     C                   EVAL      BBCRTN=A_CUCRTN
     C                   EVAL      BBPAIN=A_CUPAIN
     C                   EVAL      BBCRNM=A_CUCRNM
     C                   EVAL      BBDRCS=A_CUDRCS
     C                   EVAL      BBLCCD=A_CULCCD
     C                   EVAL      BBACOC=A_CUACOC
     C                   EVAL      BBCNCZ=A_CUCNCZ
     C                   EVAL      BBCOLC=A_CUCOLC
     C                   EVAL      BBSSDT=A_CUSSDT
     C                   EVAL      BBDOIC=A_CUDOIC
     C                   EVAL      BBPCNB=A_CUPCNB
     C                   EVAL      BBCASC=A_CUCASC
     C                   EVAL      BBBRCD=A_CUBRCD
     C                   EVAL      BBBNBI=A_CUBNBI
     C                   EVAL      BBLINC=A_CULINC
     C                   EVAL      BBLICD=A_CULICD
     C                   EVAL      BBCTNB=A_CUCTNB
     C                   EVAL      BBREID=A_CUREID
     C                   EVAL      BBBSIN=A_CUBSIN
     C                   EVAL      BBCSTY=A_CUCSTY
     C                   EVAL      BBTAIN=A_CUTAIN
     C                   EVAL      BBCSID=A_CUCSID
     C     CSW036        IFEQ      'Y'                                                        CSW036
     C                   EVAL      BBCSI2 = A_CUCSI2                                          CSW036
     C                   ENDIF                                                                CSW036
     C                   EVAL      BBSTAD=A_CUSTAD
     C                   EVAL      BBTXA1=A_CUTXA1
     C                   EVAL      BBTXA2=A_CUTXA2
     C                   EVAL      BBTXA3=A_CUTXA3
     C                   EVAL      BBTXA4=A_CUTXA4
     C                   EVAL      BBTXA5=A_CUTXA5
     C                   EVAL      BBCHID=A_CUCHID
     C                   EVAL      BBCHSC=A_CUCHSC
     C                   EVAL      BBCABA=A_CUCABA
     C                   EVAL      BBBFIC=A_CUBFIC
     C                   EVAL      BBBLCD=A_CUBLCD
     C                   EVAL      BBFWCD=A_CUFWCD
     C                   EVAL      BBLCD=BJRDNB
     C                   EVAL      BBTYLC='A'
     C                   EVAL      BBLALD=A_CULALD
     C                   EVAL      BBLDHD=A_CULDHD
     C                   EVAL      BBLRLD=A_CULRLD
     C                   EVAL      BBDTDL=A_CUDTDL
     C                   EVAL      BBLETI=A_CULETI
     C                   EVAL      BBCMTI=A_CUCMTI
     C                   EVAL      BBGSFM=A_CUGSFM
     C                   EVAL      BBSTFG=A_CUSTFG
     C                   EVAL      BBRWCD=A_CURWCD
     C                   EVAL      BBNG01=A_CUNG01
     C                   EVAL      BBNG02=A_CUNG02
     C                   EVAL      BBNG03=A_CUNG03
     C                   EVAL      BBNG04=A_CUNG04
     C                   EVAL      BBNG05=A_CUNG05
     C                   EVAL      BBNG06=A_CUNG06
     C                   EVAL      BBNG07=A_CUNG07
     C                   EVAL      BBNG08=A_CUNG08
     C                   EVAL      BBNG09=A_CUNG09
     C                   EVAL      BBNG10=A_CUNG10
     C                   EVAL      BBNG11=A_CUNG11
     C                   EVAL      BBNG12=A_CUNG12
     C                   EVAL      BBNG13=A_CUNG13
     C                   EVAL      BBNG14=A_CUNG14
     C                   EVAL      BBNG15=A_CUNG15
     C                   EVAL      BBDS01=A_CUDS01
     C                   EVAL      BBDS02=A_CUDS02
     C                   EVAL      BBDS03=A_CUDS03
     C                   EVAL      BBDS04=A_CUDS04
     C                   EVAL      BBDS05=A_CUDS05
     C                   EVAL      BBDS06=A_CUDS06
     C                   EVAL      BBDS07=A_CUDS07
     C                   EVAL      BBDS08=A_CUDS08
     C                   EVAL      BBDS09=A_CUDS09
     C                   EVAL      BBDS10=A_CUDS10
     C                   EVAL      BBDS11=A_CUDS11
     C                   EVAL      BBDS12=A_CUDS12
     C                   EVAL      BBDS13=A_CUDS13
     C                   EVAL      BBDS14=A_CUDS14
     C                   EVAL      BBDS15=A_CUDS15
     C                   EVAL      BBDNW1=A_CUDNW1
     C                   EVAL      BBDNW2=A_CUDNW2
     C                   EVAL      BBDNW3=A_CUDNW3
     C                   EVAL      BBDNW4=A_CUDNW4
     C                   EVAL      BBDNW5=A_CUDNW5
     C                   EVAL      BBDNW6=A_CUDNW6
     C                   EVAL      BBDNW7=A_CUDNW7
     C                   EVAL      BBDNW8=A_CUDNW8
     C                   EVAL      BBDNW9=A_CUDNW9
     C                   EVAL      BBCGRP=A_CUCGRP
     C                   EVAL      BBCDEL=A_CUCDEL
     C                   EVAL      BBABA2=A_CUABA2
     C                   EVAL      BBOGID=A_CUOGID
     C                   EVAL      BBSSDL=A_CUSSDL
     C                   EVAL      BBORED=A_CUORED
     C                   EVAL      BBMCAC=A_CUMCAC
     C                   EVAL      BBCRPC=A_CUCRPC
     C                   EVAL      BBPSWC=A_CUPSWC
     C                   EVAL      BBMGTP=A_CUMGTP
     C                   EVAL      BBNET=A_CUNET
     C                   EVAL      BBNTGP=A_CUNTGP
     C                   EVAL      BBNTCP=A_CUNTCP
     C                   EVAL      BBNTND=A_CUNTND
     C                   EVAL      BBNTMM=A_CUNTMM
     C                   EVAL      BBTICS=A_CUTICS
     C                   EVAL      BBSWFI=A_CUSWFI
     C                   EVAL      BBDINC=A_CUDINC
     C                   EVAL      BBPRBA=A_CUPRBA
     C                   EVAL      BBCLSS=A_CUCLSS                                            CDL008
     C                   EVAL      BBEFDT=A_CUEFDT                                            CDL008
     C                   EVAL      BBCLST=A_CUCLST                                           BUG5409
     C                   EVAL      BBCLDT=A_CUCLDT                                           BUG5409
     C**********         IF        CGL132 = 'Y'                                    MD030958 MD042407
      ** Alternative Country of Citizenship                                                   CGL132
     C                   EVAL      XCACCZ=A_XCACCZ                                            CGL132
     C                   EVAL      XCBRCH = A_CUBRCD                                        MD050212
      ** Creation Date                                                                        CGL132
     C                   EVAL      XCCRDT=A_XCCRDT                                            CGL132
      ** Dormant Indicator                                                                    CGL132
     C                   EVAL      XCDRMT=A_XCDRMT                                            CGL132
      ** Last Change User                                                                     CGL132
     C**********         EVAL      XCLCUS=PSUSER                                    CGL132 MD026957B
     C**********         EVAL      XCLCUS=WKUSER                                 MD026957B MD027492A
     C                   EVAL      XCLCUS=WLUSER                                           MD027492A
     C**********         ENDIF                                                     MD030958 MD042407
                                                                                              CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
     C                   EVAL      BBCORP=A_CUCORP                                            CSW024
     C                   EVAL      BBCBEI=A_CUCBEI                                            CSW024
     C                   EVAL      BBRI01=A_CURI01                                            CSW024
     C                   EVAL      BBRI02=A_CURI02                                            CSW024
     C                   EVAL      BBRI03=A_CURI03                                            CSW024
     C                   EVAL      BBRI04=A_CURI04                                            CSW024
     C                   EVAL      BBRI05=A_CURI05                                            CSW024
     C                   EVAL      BBFUND=A_CUFUND                                            CSW024
     C     CSW037        IFEQ      'Y'                                                        CSW037
     C                   EVAL      BBFNAC=A_CUFNAC                                            CSW037
     C                   ENDIF                                                                CSW037
     C                   ENDIF                                                                CSW024
      *                                                                                       CSD025
     C/COPY WNCPYSRC,SDCUSDDC19                                                              BUG6444
     C     CSD025        IFEQ      'Y'                                                        CSD025
     C                   EVAL      BBDEAC = A_CUDEAC                                          CSD025
     C                   EVAL      BBDEDT = A_CUDEDT                                          CSD025
     C                   ENDIF                                                                CSD025

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      BBTMST=TimeStamp                             CAP013
      ** Front Office ID                                                        CAP013
     C                   EVAL      BBFRNT=A_CUFRNT                              CAP013
      ** Associated Front Office ID                                             CAP013
     C                   EVAL      BBAFRT=A_CUAFRT                              CAP013
                                                                                              CSD015
      ** If CSD015 = 'Y' and Watch List Checking is Applied                                   CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                             AND W1EWLC = 'Y'                                           CSD015
                                                                                              CSD015
      ** If user is in the main system                                                        CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y'                                              CSD015
     C                             OR CSC011 = 'Y' AND S1MAIN = LIBR                          CSD015
                                                                                              CSD015
      ** Access SDCWHTPD using fucntion type 'SDCUSTPD', identifier                           CSD015
      ** BBCUST, and branch BBBCRD to verify Hit Unconfirmed Flag                             CSD015
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'SDCUSTPD'                                     CSD015
     C                   EVAL      WIdntifier = BBCUST                                        CSD015
     C                   EVAL      WBranch = BBBRCD                                           CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
     C                   IF        NOT %FOUND(SDCWHTL1)                                       CSD015
     C                   EVAL      WUNCF1 = 'N'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C                   EVAL      WUNCF1 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If any of the watch list fields has changed                                          CSD015
      ** or Hit Unconfirmed flag is 'Y'                                                       CSD015
                                                                                              CSD015
     C                   IF        BBCNA1 <> B_BBCNA1                                         CSD015
     C                             OR BBCNA2 <> B_BBCNA2                                      CSD015
     C                             OR BBCNA3 <> B_BBCNA3                                      CSD015
     C                             OR BBCNA4 <> B_BBCNA4                                      CSD015
     C                             OR BBCSID <> B_BBCSID                                      CSD015
     C                             OR BBCNCZ <> B_BBCNCZ                                      CSD015
     C                             OR BBCOLC <> B_BBCOLC                                      CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
                                                                                              CSD015
     C                   EXSR      SRWTCH                                                     CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CLE025
      ** Update Facility Mandatory, Include Offsets, and                                      CLE025
      ** FX Margin Types flags                                                                CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                             OR  CFX001 = 'Y'                                           CFX001
     C                   EVAL      BBFCMF = A_CUFCMF                                          CLE025
     C                   EVAL      BBINOF = A_CUINOF                                          CLE025
     C                   EVAL      BBMSTF = A_CUMSTF                                          CLE025
     C                   EVAL      BBIOPC = A_CUIOPC                                          CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                      BUG3362
      **  Initialise CUTICS  to 'N', after reversal of TI details                            BUG3362
      *                                                                                      BUG3362
     C                   IF        BBTICS = 'D'                                              BUG3362
     C                   EVAL      WBBTICS=BBTICS                                            BUG3362
     C                   EVAL      BBTICS = 'N'                                              BUG3362
     C                   ENDIF                                                               BUG3362
                                                                                              CSD031
     C**********         IF        CSD037 = 'Y'                                      CSD031 BUG13525
     C**********         EVAL      BBAACC = A_CUAACC                                 CSD031 BUG13525
     C**********         EVAL      BBEACC = A_CUEACC                                 CSD031 BUG13525
     C**********         EVAL      BBGPDT = A_CUGPDT                                 CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD079
      ** Set Fx netting Fields                                                                CSD079
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
     C                             AND CDL002 = 'Y'                                           CSD079
     C                   EVAL      BBNET = A_CUNET                                            CSD079
     C                   EVAL      BBNTGP = A_CUNTGP                                          CSD079
     C                   EVAL      BBNTCP = A_CUNTCP                                          CSD079
     C                   EVAL      BBNTND = A_CUNTND                                          CSD079
     C                   EVAL      BBNTMM = A_CUNTMM                                          CSD079
     C                   EVAL      BBTICS = A_CUTICS                                          CSD079
     C                   EVAL      BBSWFI = A_CUSWFI                                          CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Fiduciary Deposits Fields                                                        CSD079
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
     C                             AND CDL006 = 'Y'                                           CSD079
     C                   EVAL      BBCOMG = A_CUCOMG                                          CSD079
     C                   EVAL      BBCHRG = A_CUCHRG                                          CSD079
     C                   EVAL      BBAGNT = A_CUAGNT                                          CSD079
     C                   EVAL      BBAGNP = A_CUAGNP                                          CSD079
     C                   EVAL      BBTRAS = A_CUTRAS                                          CSD079
     C                   EVAL      BBNAR1 = A_CUNAR1                                          CSD079
     C                   EVAL      BBNAR2 = A_CUNAR2                                          CSD079
     C                   EVAL      BBNAR3 = A_CUNAR3                                          CSD079
     C                   EVAL      BBNAR4 = A_CUNAR4                                          CSD079
     C                   EVAL      BBDFAC = A_CUDFAC                                          CSD079
     C                   EVAL      BBDFAS = A_CUDFAS                                          CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
      **********                                                                  AR679445 MD027492A
     C**********         MOVE      WKUSER        BBAUSR                           AR679445 MD027492A
                                                                                           MD027492A
     C                   EVAL      BBAUSR = WLUSER                                         MD027492A
     C                   IF        SDAAUTH <> 'Y'                                           MD055373
     C                   EVAL      BBXUSR = WKUSER                                         MD027492A
     C                   ENDIF                                                              MD055373
      *
      ** Update the SWIFT 2007 field details when CSW207 is on                                CSW207
     C**********         IF        CSW207 = 'Y' OR BGN4ST = 'Y'                      CSW207 BUG15138
     C     A_CUCUST      CHAIN     SDCSSWL0                                                   CSW207
     C                   IF        %FOUND(SDCSSWL0)                                           CSW207
     C                   EVAL      CSCUSD = A_CUCUST                                          CSW207
     C                   EVAL      CSBRCA = A_CUBRCD                                          CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG15138
     C                   EVAL      CSCICI = A_CUCICI                                          CSW207
     C                   EVAL      CSCPCI = A_CUCPCI                                          CSW207
     C                   ENDIF                                                              BUG15138
     C                   EVAL      CSIBEI = A_CUIBEI                                          CSW207
     C**********         IF        CFT050 = 'Y'                                      CFT050 MD028198
     C                   IF        CSW213 = 'Y'                                             MD028198
     C                   EVAL      CSLEIC = S13DDLEIC                                         CFT050
     C                   EVAL      CSCLSY = S13DDCLSY                                         CFT050
     C                   EVAL      CSCLID = S13DDCLID                                         CFT050
     C                   ENDIF                                                              MD028198
     C                   IF        CFT050 = 'Y'                                             MD028198
     C                   EVAL      CSBDRK = S13DDBDRK                                         CFT050
     C                   ENDIF                                                                CFT050
     C                   UPDATE    SDCSSWD0                                                   CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSCUSD = A_CUCUST                                          CSW207
     C                   EVAL      CSBRCA = A_CUBRCD                                          CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG15138
     C                   EVAL      CSCICI = A_CUCICI                                          CSW207
     C                   EVAL      CSCPCI = A_CUCPCI                                          CSW207
     C                   ENDIF                                                              BUG15138
     C                   EVAL      CSIBEI = A_CUIBEI                                          CSW207
     C**********         IF        CFT050 = 'Y'                                      CFT050 MD028198
     C                   IF        CSW213 = 'Y'                                             MD028198
     C                   EVAL      CSLEIC = A_CULEIC                                          CFT050
     C                   EVAL      CSCLSY = A_CUCLSY                                          CFT050
     C                   EVAL      CSCLID = A_CUCLID                                          CFT050
     C                   ENDIF                                                              MD028198
     C                   IF        CFT050 = 'Y'                                             MD028198
     C                   EVAL      CSBDRK = A_CUBDRK                                          CFT050
     C                   ENDIF                                                                CFT050
     C                   WRITE     SDCSSWD0                                                   CSW207
     C                   ENDIF                                                                CSW207
     C**********         ENDIF                                                       CSW207 BUG15138
      *                                                                                       CSW207
     C                   EVAL      BBAUSR = SDAUSER                                         MD055373
      *                                                                                     MD055373
      ** UPDATE RECORD

     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                       CSD028
     C                                          AND AUTHMD     = *BLANKS                      CSD028
     C                   UPDATE    SDCDSHD0                                                   CSD028
     C                   ELSE                                                                 CSD028
     C                   UPDATE    @BBREBG
      *                                                                                       CGL132
      ** UPDATE EXTENSION RECORD                                                              CGL132
     C**********         IF        CGL132 = 'Y'                                    MD030958 MD042407
     C                   UPDATE    SDCUSTX1                                                   CGL132
     C**********         ENDIF                                                     MD030958 MD042407
     C                   ENDIF                                                                CSD028
                                                                                              CSD092
     C**********         IF        CSD092 = 'Y'                                        CSD092 CGL132
     C                   IF        CSD092 = 'Y' AND                                           CGL132
     C                             CGL132 = 'N'                                               CGL132
     C                   IF        S01425 = 'Y' AND                                           CSD092
     C                             CSD079 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   IF        S01425 <> 'Y' OR CSD079 <> 'Y'                           MD026957
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      BBCUST        PCUST                                        CSD092
     C                   PARM      B_CUSTD       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD026957
     C                   ENDIF                                                                CSD092
     C                   ENDIF                                                                CSD092

     C/COPY WNCPYSRC,SDH00753
      ** Update Global Customer X-Reference                                                   CGP001
                                                                                              CGP001
     C                   IF        CGP001 = 'Y'                                               CGP001
     C                   EXSR      SRUpdGlbID                                                 CGP001
     C                   ENDIF                                                                CGP001

      **If*Midas/TI*Interface*is*on****************************************                  BUG3362
      **AND*TI*Flag*is*'Y'*then********************************************                  BUG3362
      *****change*the*TI*Flag*and*update*SDTICSPD*to*generate**************                  BUG3362
      *****a*journal entry which can be picked up by TI.                                     BUG3362
      **********                                                                             BUG3362
     C*****BGN3ST        IFEQ      'Y'                                                       BUG3362
     C*****BBTICS        ANDEQ     'Y'                                                       BUG3362
     C*****BBCUST        CHAIN     SDTICSL0                           95                     BUG3362
     C******IN95         IFEQ      '0'                                                       BUG3362
     C*****TCFLAG        IFEQ      'Y'                                                       BUG3362
     C**********         MOVEL     'N'           TCFLAG                                      BUG3362
     C**********         ELSE                                                                BUG3362
     C**********         MOVEL     'Y'           TCFLAG                                      BUG3362
     C**********         ENDIF                                                               BUG3362
     C**********         UPDATE    @TICSL0                                                   BUG3362
     C**********         ENDIF                                                               BUG3362
     C**********         ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   EXSR      UPDTID                                                    BUG3362
      *                                                                                      BUG3362
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No of records
     C                   Z-ADD     1             WUNOAM                         No of Amend
     C                   Z-ADD     *ZERO         WUNOIN                         No of delete
     C                   Z-ADD     *ZERO         WUNODL                         No of Insert
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDCUSTPD'    WFLNAME           8            No of delete
     C                   EXSR      SNCHRC
      * Pass parameters for marketing groups to SDCLINT to update CLINTCB
      * Customer marketing groups - Customer Marketing Groups  *
     C                   EXSR      SORVGN
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
      ** Access customer details recrod                                                       CGL132
                                                                                              CGL132
     C     A_CUCUST      CHAIN     SDFTCSL0                           99                      CGL132
     C                   CLEAR                   SDFTCS2                                      CGL132
     C                   MOVE      SDFTCS        SDFTCS2                                      CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '1'                                                        CGL132
     C                   MOVEL     A_CUCUST      DBKEY                                        CGL132
     C                   MOVEL     'SDFTCSPD'    DBFILE                                       CGL132
     C                   MOVEL     '005'         DBASE                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   END                                                                  CGL132
                                                                                              CGL132
     C                   MOVE      TimeStamp     WTime                                        CGL132
     C     *HMS0         MOVE      WTime         WWTIME                                       CGL132
     C                   EVAL      WWHVAC = FAHVAC                                            CGL132
     C                   EVAL      FACUST = BBCUST                                            CGL132
                                                                                              CGL132
     C                   IF        FACLAC <> A_FVCLAC                                         CGL132
     C                   EVAL      A_FVPCLA = FACLAC                                          CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FACIOV <> A_FVCIOV                                         CGL132
     C                             OR FACICO <> A_FVCICO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US CITIZENSHIP'                                  CGL132
     C                   EVAL      INUSSV = FACISV                                            CGL132
     C                   EVAL      INUSSD = FACISD                                            CGL132
     C                   EVAL      INUSSM = FACIST                                            CGL132
     C                   EVAL      INUSOV = FACIOV                                            CGL132
     C                   EVAL      INUSUN = FACION                                            CGL132
     C                   EVAL      INUSDT = FACIOD                                            CGL132
     C                   EVAL      INUSTM = FACIOT                                            CGL132
     C                   EVAL      INUSCO = FACICO                                            CGL132
     C                   IF        FACIOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FACIOD = BJRDNB                                            CGL132
     C**********         EVAL      FACION = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FACION = WKUSER                                MD026835 MD026835A
     C                   EVAL      FACION = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FACIOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FATXOV <> A_FVTXOV                                         CGL132
     C                             OR FATXCO <> A_FVTXCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US TIN'                                          CGL132
     C                   EVAL      INUSSV = FATXSV                                            CGL132
     C                   EVAL      INUSSD = FATXSD                                            CGL132
     C                   EVAL      INUSSM = FATXST                                            CGL132
     C                   EVAL      INUSOV = FATXOV                                            CGL132
     C                   EVAL      INUSUN = FATXON                                            CGL132
     C                   EVAL      INUSDT = FATXOD                                            CGL132
     C                   EVAL      INUSTM = FATXOT                                            CGL132
     C                   EVAL      INUSCO = FATXCO                                            CGL132
     C                   IF        FATXOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FATXOD = BJRDNB                                            CGL132
     C**********         EVAL      FATXON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FATXON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FATXON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FATXOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAAUOV <> A_FVAUOV                                         CGL132
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US Authority Holder'                             CGL132
     C                   EVAL      INUSSV = FAAUSV                                            CGL132
     C                   EVAL      INUSSD = FAAUSD                                            CGL132
     C                   EVAL      INUSSM = FAAUST                                            CGL132
     C                   EVAL      INUSOV = FAAUOV                                            CGL132
     C                   EVAL      INUSUN = FAAUON                                            CGL132
     C                   EVAL      INUSDT = FAAUOD                                            CGL132
     C                   EVAL      INUSTM = FAAUOT                                            CGL132
     C                   EVAL      INUSCO = FAAUCO                                            CGL132
     C                   IF        FAAUOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAAUOD = BJRDNB                                            CGL132
     C**********         EVAL      FAAUON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FAAUON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FAAUON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FAAUOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FACDOV <> A_FVCDOV                                         CGL132
     C                             OR FACDCO <> A_FVCDCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US COUNTRY OF +                                  CGL132
     C                                      DOMICILE'                                         CGL132
     C                   EVAL      INUSSV = FACDSV                                            CGL132
     C                   EVAL      INUSSD = FACDSD                                            CGL132
     C                   EVAL      INUSSM = FACDST                                            CGL132
     C                   EVAL      INUSOV = FACDOV                                            CGL132
     C                   EVAL      INUSUN = FACDON                                            CGL132
     C                   EVAL      INUSDT = FACDOD                                            CGL132
     C                   EVAL      INUSTM = FACDOT                                            CGL132
     C                   EVAL      INUSCO = FACDCO                                            CGL132
     C                   IF        FACDOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FACDOD = BJRDNB                                            CGL132
     C**********         EVAL      FACDON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FACDON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FACDON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FACDOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FATEOV <> A_FVTEOV                                         CGL132
     C                             OR FATECO <> A_FVTECO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US TELEPHONE'                                    CGL132
     C                   EVAL      INUSSV = FATESV                                            CGL132
     C                   EVAL      INUSSD = FATESD                                            CGL132
     C                   EVAL      INUSSM = FATEST                                            CGL132
     C                   EVAL      INUSOV = FATEOV                                            CGL132
     C                   EVAL      INUSUN = FATEON                                            CGL132
     C                   EVAL      INUSDT = FATEOD                                            CGL132
     C                   EVAL      INUSTM = FATEOT                                            CGL132
     C                   EVAL      INUSCO = FATECO                                            CGL132
     C                   IF        FATEOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FATEOD = BJRDNB                                            CGL132
     C**********         EVAL      FATEON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FATEON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FATEON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FATEOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAGCOV <> A_FVGCOV                                         CGL132
     C                             OR FAGCCO <> A_FVGCCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US GREEN CARD'                                   CGL132
     C                   EVAL      INUSSV = FAGCSV                                            CGL132
     C                   EVAL      INUSSD = FAGCSD                                            CGL132
     C                   EVAL      INUSSM = FAGCST                                            CGL132
     C                   EVAL      INUSOV = FAGCOV                                            CGL132
     C                   EVAL      INUSUN = FAGCON                                            CGL132
     C                   EVAL      INUSDT = FAGCOD                                            CGL132
     C                   EVAL      INUSTM = FAGCOT                                            CGL132
     C                   EVAL      INUSCO = FAGCCO                                            CGL132
     C                   IF        FAGCOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAGCOD = BJRDNB                                            CGL132
     C**********         EVAL      FAGCON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FAGCON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FAGCON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FAGCOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FACBOV <> A_FVCBOV                                         CGL132
     C                             OR FACBCO <> A_FVCBCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US COUNTRY OF +                                  CGL132
     C                                      BIRTH'                                            CGL132
     C                   EVAL      INUSSV = FACBSV                                            CGL132
     C                   EVAL      INUSSD = FACBSD                                            CGL132
     C                   EVAL      INUSSM = FACBST                                            CGL132
     C                   EVAL      INUSOV = FACBOV                                            CGL132
     C                   EVAL      INUSUN = FACBON                                            CGL132
     C                   EVAL      INUSDT = FACBOD                                            CGL132
     C                   EVAL      INUSTM = FACBOT                                            CGL132
     C                   EVAL      INUSCO = FACBCO                                            CGL132
     C                   IF        FACBOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FACBOD = BJRDNB                                            CGL132
     C**********         EVAL      FACBON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FACBON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FACBON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FACBOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAJAOV <> A_FVJAOV                                         CGL132
     C                             OR FAJACO <> A_FVJACO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US JOINT ACCOUNT +                               CGL132
     C                                      MEMBER'                                           CGL132
     C                   EVAL      INUSSV = FAJASV                                            CGL132
     C                   EVAL      INUSSD = FAJASD                                            CGL132
     C                   EVAL      INUSSM = FAJAST                                            CGL132
     C                   EVAL      INUSOV = FAJAOV                                            CGL132
     C                   EVAL      INUSUN = FAJAON                                            CGL132
     C                   EVAL      INUSDT = FAJAOD                                            CGL132
     C                   EVAL      INUSTM = FAJAOT                                            CGL132
     C                   EVAL      INUSCO = FAJACO                                            CGL132
     C                   IF        FAJAOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAJAOD = BJRDNB                                            CGL132
     C**********         EVAL      FAJAON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FAJAON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FAJAON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FAJAOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAHMOV <> A_FVHMOV                                         CGL132
     C                             OR FAHMCO <> A_FVHMCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'HOLD MAIL'                                       CGL132
     C                   EVAL      INUSSV = FAHMSV                                            CGL132
     C                   EVAL      INUSSD = FAHMSD                                            CGL132
     C                   EVAL      INUSSM = FAHMST                                            CGL132
     C                   EVAL      INUSOV = FAHMOV                                            CGL132
     C                   EVAL      INUSUN = FAHMON                                            CGL132
     C                   EVAL      INUSDT = FAHMOD                                            CGL132
     C                   EVAL      INUSTM = FAHMOT                                            CGL132
     C                   EVAL      INUSCO = FAHMCO                                            CGL132
     C                   IF        FAHMOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAHMOD = BJRDNB                                            CGL132
     C**********         EVAL      FAHMON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FAHMON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FAHMON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FAHMOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FARPOV <> A_FVRPOV                                         CGL132
     C                             OR FARPCO <> A_FVRPCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'REG PAYMENT +                                    CGL132
     C                                      INST TO US'                                       CGL132
     C                   EVAL      INUSSV = FARPSV                                            CGL132
     C                   EVAL      INUSSD = FARPSD                                            CGL132
     C                   EVAL      INUSSM = FARPST                                            CGL132
     C                   EVAL      INUSOV = FARPOV                                            CGL132
     C                   EVAL      INUSUN = FARPON                                            CGL132
     C                   EVAL      INUSDT = FARPOD                                            CGL132
     C                   EVAL      INUSTM = FARPOT                                            CGL132
     C                   EVAL      INUSCO = FARPCO                                            CGL132
     C                   IF        FARPOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FARPOD = BJRDNB                                            CGL132
     C**********         EVAL      FARPON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FARPON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FARPON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FARPOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAIDOV <> A_FVIDOV                                         CGL132
     C                             OR FAIDCO <> A_FVIDCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'US IDENTITY +                                    CGL132
     C                                      DOCUMENT'                                         CGL132
     C                   EVAL      INUSSV = FAIDSV                                            CGL132
     C                   EVAL      INUSSD = FAIDSD                                            CGL132
     C                   EVAL      INUSSM = FAIDST                                            CGL132
     C                   EVAL      INUSOV = FAIDOV                                            CGL132
     C                   EVAL      INUSUN = FAIDON                                            CGL132
     C                   EVAL      INUSDT = FAIDOD                                            CGL132
     C                   EVAL      INUSTM = FAIDOT                                            CGL132
     C                   EVAL      INUSCO = FAIDCO                                            CGL132
     C                   IF        FAIDOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAIDOD = BJRDNB                                            CGL132
     C**********         EVAL      FAIDON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FAIDON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FAIDON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FAIDOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FAMCOV <> A_FVMCOV                                         CGL132
     C                             OR FAMCCO <> A_FVMCCO                                    MD027525
     C                   EVAL      INCUST = FACUST                                            CGL132
     C                   EVAL      INUSIN = 'MAILING +                                        CGL132
     C                                      COUNTRY'                                          CGL132
     C                   EVAL      INUSSV = FAMCSV                                            CGL132
     C                   EVAL      INUSSD = FAMCSD                                            CGL132
     C                   EVAL      INUSSM = FAMCST                                            CGL132
     C                   EVAL      INUSOV = FAMCOV                                            CGL132
     C                   EVAL      INUSUN = FAMCON                                            CGL132
     C                   EVAL      INUSDT = FAMCOD                                            CGL132
     C                   EVAL      INUSTM = FAMCOT                                            CGL132
     C                   EVAL      INUSCO = FAMCCO                                            CGL132
     C                   IF        FAMCOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCHD0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAMCOD = BJRDNB                                            CGL132
     C**********         EVAL      FAMCON = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FAMCON = WKUSER                                MD026835 MD026835A
     C                   EVAL      FAMCON = WLUSER                                         MD026835A
     C                   MOVE      WWTIME        FAMCOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      FACLAC = A_FVCLAC                                          CGL132
     C                   EVAL      FACLAD = A_FVCLAD                                          CGL132
     C                   EVAL      FAPCLA = A_FVPCLA                                          CGL132
     C                   EVAL      FAHMSV = A_FVHMSV                                          CGL132
     C                   EVAL      FAHMSD = A_FVHMSD                                          CGL132
     C                   EVAL      FAHMOV = A_FVHMOV                                          CGL132
     C                   EVAL      FAHMD1 = A_FVHMD1                                          CGL132
     C                   EVAL      FAHMD2 = A_FVHMD2                                          CGL132
     C                   EVAL      FAHMD3 = A_FVHMD3                                          CGL132
     C                   EVAL      FAHMD4 = A_FVHMD4                                          CGL132
     C                   EVAL      FAHMD5 = A_FVHMD5                                          CGL132
     C                   EVAL      FAHMS1 = A_FVHMS1                                          CGL132
     C                   EVAL      FAHMS2 = A_FVHMS2                                          CGL132
     C                   EVAL      FAHMS3 = A_FVHMS3                                          CGL132
     C                   EVAL      FAHMS4 = A_FVHMS4                                          CGL132
     C                   EVAL      FAHMS5 = A_FVHMS5                                          CGL132
     C                   EVAL      FAHMCO = A_FVHMCO                                          CGL132
     C                   EVAL      FAMCSV = A_FVMCSV                                          CGL132
     C                   EVAL      FAMCSD = A_FVMCSD                                          CGL132
     C                   EVAL      FAMCOV = A_FVMCOV                                          CGL132
     C                   EVAL      FAMCD1 = A_FVMCD1                                          CGL132
     C                   EVAL      FAMCD2 = A_FVMCD2                                          CGL132
     C                   EVAL      FAMCD3 = A_FVMCD3                                          CGL132
     C                   EVAL      FAMCD4 = A_FVMCD4                                          CGL132
     C                   EVAL      FAMCD5 = A_FVMCD5                                          CGL132
     C                   EVAL      FAMCS1 = A_FVMCS1                                          CGL132
     C                   EVAL      FAMCS2 = A_FVMCS2                                          CGL132
     C                   EVAL      FAMCS3 = A_FVMCS3                                          CGL132
     C                   EVAL      FAMCS4 = A_FVMCS4                                          CGL132
     C                   EVAL      FAMCS5 = A_FVMCS5                                          CGL132
     C                   EVAL      FAMCCO = A_FVMCCO                                          CGL132
     C                   EVAL      FARPSV = A_FVRPSV                                          CGL132
     C                   EVAL      FARPSD = A_FVRPSD                                          CGL132
     C                   EVAL      FARPOV = A_FVRPOV                                          CGL132
     C                   EVAL      FARPD1 = A_FVRPD1                                          CGL132
     C                   EVAL      FARPD2 = A_FVRPD2                                          CGL132
     C                   EVAL      FARPD3 = A_FVRPD3                                          CGL132
     C                   EVAL      FARPD4 = A_FVRPD4                                          CGL132
     C                   EVAL      FARPD5 = A_FVRPD5                                          CGL132
     C                   EVAL      FARPS1 = A_FVRPS1                                          CGL132
     C                   EVAL      FARPS2 = A_FVRPS2                                          CGL132
     C                   EVAL      FARPS3 = A_FVRPS3                                          CGL132
     C                   EVAL      FARPS4 = A_FVRPS4                                          CGL132
     C                   EVAL      FARPS5 = A_FVRPS5                                          CGL132
     C                   EVAL      FARPCO = A_FVRPCO                                          CGL132
     C                   EVAL      FAAUSV = A_FVAUSV                                          CGL132
     C                   EVAL      FAAUSD = A_FVAUSD                                          CGL132
     C                   EVAL      FAAUOV = A_FVAUOV                                          CGL132
     C                   EVAL      FAAUD1 = A_FVAUD1                                          CGL132
     C                   EVAL      FAAUD2 = A_FVAUD2                                          CGL132
     C                   EVAL      FAAUD3 = A_FVAUD3                                          CGL132
     C                   EVAL      FAAUD4 = A_FVAUD4                                          CGL132
     C                   EVAL      FAAUD5 = A_FVAUD5                                          CGL132
     C                   EVAL      FAAUS1 = A_FVAUS1                                          CGL132
     C                   EVAL      FAAUS2 = A_FVAUS2                                          CGL132
     C                   EVAL      FAAUS3 = A_FVAUS3                                          CGL132
     C                   EVAL      FAAUS4 = A_FVAUS4                                          CGL132
     C                   EVAL      FAAUS5 = A_FVAUS5                                          CGL132
     C                   EVAL      FAAUCO = A_FVAUCO                                          CGL132
     C                   EVAL      FACISV = A_FVCISV                                          CGL132
     C                   EVAL      FACISD = A_FVCISD                                          CGL132
     C                   EVAL      FACIOV = A_FVCIOV                                          CGL132
     C                   EVAL      FACID1 = A_FVCID1                                          CGL132
     C                   EVAL      FACID2 = A_FVCID2                                          CGL132
     C                   EVAL      FACID3 = A_FVCID3                                          CGL132
     C                   EVAL      FACID4 = A_FVCID4                                          CGL132
     C                   EVAL      FACID5 = A_FVCID5                                          CGL132
     C                   EVAL      FACIS1 = A_FVCIS1                                          CGL132
     C                   EVAL      FACIS2 = A_FVCIS2                                          CGL132
     C                   EVAL      FACIS3 = A_FVCIS3                                          CGL132
     C                   EVAL      FACIS4 = A_FVCIS4                                          CGL132
     C                   EVAL      FACIS5 = A_FVCIS5                                          CGL132
     C                   EVAL      FACICO = A_FVCICO                                          CGL132
     C                   EVAL      FACBSV = A_FVCBSV                                          CGL132
     C                   EVAL      FACBSD = A_FVCBSD                                          CGL132
     C                   EVAL      FACBOV = A_FVCBOV                                          CGL132
     C                   EVAL      FACBD1 = A_FVCBD1                                          CGL132
     C                   EVAL      FACBD2 = A_FVCBD2                                          CGL132
     C                   EVAL      FACBD3 = A_FVCBD3                                          CGL132
     C                   EVAL      FACBD4 = A_FVCBD4                                          CGL132
     C                   EVAL      FACBD5 = A_FVCBD5                                          CGL132
     C                   EVAL      FACBS1 = A_FVCBS1                                          CGL132
     C                   EVAL      FACBS2 = A_FVCBS2                                          CGL132
     C                   EVAL      FACBS3 = A_FVCBS3                                          CGL132
     C                   EVAL      FACBS4 = A_FVCBS4                                          CGL132
     C                   EVAL      FACBS5 = A_FVCBS5                                          CGL132
     C                   EVAL      FACBCO = A_FVCBCO                                          CGL132
     C                   EVAL      FACDSV = A_FVCDSV                                          CGL132
     C                   EVAL      FACDSD = A_FVCDSD                                          CGL132
     C                   EVAL      FACDOV = A_FVCDOV                                          CGL132
     C                   EVAL      FACDD1 = A_FVCDD1                                          CGL132
     C                   EVAL      FACDD2 = A_FVCDD2                                          CGL132
     C                   EVAL      FACDD3 = A_FVCDD3                                          CGL132
     C                   EVAL      FACDD4 = A_FVCDD4                                          CGL132
     C                   EVAL      FACDD5 = A_FVCDD5                                          CGL132
     C                   EVAL      FACDS1 = A_FVCDS1                                          CGL132
     C                   EVAL      FACDS2 = A_FVCDS2                                          CGL132
     C                   EVAL      FACDS3 = A_FVCDS3                                          CGL132
     C                   EVAL      FACDS4 = A_FVCDS4                                          CGL132
     C                   EVAL      FACDS5 = A_FVCDS5                                          CGL132
     C                   EVAL      FACDCO = A_FVCDCO                                          CGL132
     C                   EVAL      FAGCSV = A_FVGCSV                                          CGL132
     C                   EVAL      FAGCSD = A_FVGCSD                                          CGL132
     C                   EVAL      FAGCOV = A_FVGCOV                                          CGL132
     C                   EVAL      FAGCD1 = A_FVGCD1                                          CGL132
     C                   EVAL      FAGCD2 = A_FVGCD2                                          CGL132
     C                   EVAL      FAGCD3 = A_FVGCD3                                          CGL132
     C                   EVAL      FAGCD4 = A_FVGCD4                                          CGL132
     C                   EVAL      FAGCD5 = A_FVGCD5                                          CGL132
     C                   EVAL      FAGCS1 = A_FVGCS1                                          CGL132
     C                   EVAL      FAGCS2 = A_FVGCS2                                          CGL132
     C                   EVAL      FAGCS3 = A_FVGCS3                                          CGL132
     C                   EVAL      FAGCS4 = A_FVGCS4                                          CGL132
     C                   EVAL      FAGCS5 = A_FVGCS5                                          CGL132
     C                   EVAL      FAGCCO = A_FVGCCO                                          CGL132
     C                   EVAL      FAIDSV = A_FVIDSV                                          CGL132
     C                   EVAL      FAIDSD = A_FVIDSD                                          CGL132
     C                   EVAL      FAIDOV = A_FVIDOV                                          CGL132
     C                   EVAL      FAIDD1 = A_FVIDD1                                          CGL132
     C                   EVAL      FAIDD2 = A_FVIDD2                                          CGL132
     C                   EVAL      FAIDD3 = A_FVIDD3                                          CGL132
     C                   EVAL      FAIDD4 = A_FVIDD4                                          CGL132
     C                   EVAL      FAIDD5 = A_FVIDD5                                          CGL132
     C                   EVAL      FAIDS1 = A_FVIDS1                                          CGL132
     C                   EVAL      FAIDS2 = A_FVIDS2                                          CGL132
     C                   EVAL      FAIDS3 = A_FVIDS3                                          CGL132
     C                   EVAL      FAIDS4 = A_FVIDS4                                          CGL132
     C                   EVAL      FAIDS5 = A_FVIDS5                                          CGL132
     C                   EVAL      FAIDCO = A_FVIDCO                                          CGL132
     C                   EVAL      FAJASV = A_FVJASV                                          CGL132
     C                   EVAL      FAJASD = A_FVJASD                                          CGL132
     C                   EVAL      FAJAOV = A_FVJAOV                                          CGL132
     C                   EVAL      FAJAD1 = A_FVJAD1                                          CGL132
     C                   EVAL      FAJAD2 = A_FVJAD2                                          CGL132
     C                   EVAL      FAJAD3 = A_FVJAD3                                          CGL132
     C                   EVAL      FAJAD4 = A_FVJAD4                                          CGL132
     C                   EVAL      FAJAD5 = A_FVJAD5                                          CGL132
     C                   EVAL      FAJAS1 = A_FVJAS1                                          CGL132
     C                   EVAL      FAJAS2 = A_FVJAS2                                          CGL132
     C                   EVAL      FAJAS3 = A_FVJAS3                                          CGL132
     C                   EVAL      FAJAS4 = A_FVJAS4                                          CGL132
     C                   EVAL      FAJAS5 = A_FVJAS5                                          CGL132
     C                   EVAL      FAJACO = A_FVJACO                                          CGL132
     C                   EVAL      FATESV = A_FVTESV                                          CGL132
     C                   EVAL      FATESD = A_FVTESD                                          CGL132
     C                   EVAL      FATEOV = A_FVTEOV                                          CGL132
     C                   EVAL      FATED1 = A_FVTED1                                          CGL132
     C                   EVAL      FATED2 = A_FVTED2                                          CGL132
     C                   EVAL      FATED3 = A_FVTED3                                          CGL132
     C                   EVAL      FATED4 = A_FVTED4                                          CGL132
     C                   EVAL      FATED5 = A_FVTED5                                          CGL132
     C                   EVAL      FATES1 = A_FVTES1                                          CGL132
     C                   EVAL      FATES2 = A_FVTES2                                          CGL132
     C                   EVAL      FATES3 = A_FVTES3                                          CGL132
     C                   EVAL      FATES4 = A_FVTES4                                          CGL132
     C                   EVAL      FATES5 = A_FVTES5                                          CGL132
     C                   EVAL      FATECO = A_FVTECO                                          CGL132
     C                   EVAL      FATXSV = A_FVTXSV                                          CGL132
     C                   EVAL      FATXSD = A_FVTXSD                                          CGL132
     C                   EVAL      FATXOV = A_FVTXOV                                          CGL132
     C                   EVAL      FATXD1 = A_FVTXD1                                          CGL132
     C                   EVAL      FATXD2 = A_FVTXD2                                          CGL132
     C                   EVAL      FATXD3 = A_FVTXD3                                          CGL132
     C                   EVAL      FATXD4 = A_FVTXD4                                          CGL132
     C                   EVAL      FATXD5 = A_FVTXD5                                          CGL132
     C                   EVAL      FATXS1 = A_FVTXS1                                          CGL132
     C                   EVAL      FATXS2 = A_FVTXS2                                          CGL132
     C                   EVAL      FATXS3 = A_FVTXS3                                          CGL132
     C                   EVAL      FATXS4 = A_FVTXS4                                          CGL132
     C                   EVAL      FATXS5 = A_FVTXS5                                          CGL132
     C                   EVAL      FATXCO = A_FVTXCO                                          CGL132
     C                   EVAL      FAEXEM = A_FVEXEM                                          CGL132
     C                   EVAL      FAEXER = A_FVEXER                                          CGL132
     C                   EVAL      FAEXED = A_FVEXED                                          CGL132
     C                   EVAL      FAEXET = A_FVEXET                                          CGL132
     C                   EVAL      FAEXEU = A_FVEXEU                                          CGL132
     C                   EVAL      FAREPT = A_FVREPT                                          CGL132
     C                   EVAL      FAGIIN = A_FVGIIN                                          CGL132
     C                   EVAL      FAGIID = A_FVGIID                                          CGL132
     C                   EVAL      FAGIIO = A_FVGIIO                                          CGL132
     C                   EVAL      FAUTIN = A_FVUTIN                                          CGL132
     C                   IF        CGL133 = 'N'                                               CGL132
     C                   IF        FAUTIN = *BLANKS                                           CGL132
     C                   MOVE      FACUST        PCustNo                                      CGL132
     C                   EVAL      WCTAX = SVal3                                              CGL132
     C                   MOVE      *BLANKS       FAUTIN                                       CGL132
     C**********         IF        E5TNC5 = WCTAX                                    CGL132 MD026550
     C**********         MOVEL     E5TIN5        FAUTIN                              CGL132 MD026550
     C**********         ENDIF                                                       CGL132 MD026550
     C**********         IF        E5TNC4 = WCTAX                                    CGL132 MD026550
     C**********         MOVEL     E5TIN4        FAUTIN                              CGL132 MD026550
     C**********         ENDIF                                                       CGL132 MD026550
     C**********         IF        E5TNC3 = WCTAX                                    CGL132 MD026550
     C**********         MOVEL     E5TIN3        FAUTIN                              CGL132 MD026550
     C**********         ENDIF                                                       CGL132 MD026550
     C**********         IF        E5TNC2 = WCTAX                                    CGL132 MD026550
     C**********         MOVEL     E5TIN2        FAUTIN                              CGL132 MD026550
     C**********         ENDIF                                                       CGL132 MD026550
     C**********         IF        BBCOLC = WCTAX                                    CGL132 MD026550
     C**********         MOVEL     E5TINO        FAUTIN                              CGL132 MD026550
     C**********         ENDIF                                                       CGL132 MD026550
     C                   IF        A_ADTNC5 = WCTAX                                         MD026550
     C                   MOVEL     A_ADTIN5      FAUTIN                                     MD026550
     C                   ENDIF                                                              MD026550
     C                   IF        A_ADTNC4 = WCTAX                                         MD026550
     C                   MOVEL     A_ADTIN4      FAUTIN                                     MD026550
     C                   ENDIF                                                              MD026550
     C                   IF        A_ADTNC3 = WCTAX                                         MD026550
     C                   MOVEL     A_ADTIN3      FAUTIN                                     MD026550
     C                   ENDIF                                                              MD026550
     C                   IF        A_ADTNC2 = WCTAX                                         MD026550
     C                   MOVEL     A_ADTIN2      FAUTIN                                     MD026550
     C                   ENDIF                                                              MD026550
     C                   IF        BBCOLC = WCTAX                                           MD026550
     C                   MOVEL     A_ADTINO      FAUTIN                                     MD026550
     C                   ENDIF                                                              MD026550
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FAGREC = A_FVGREC                                          CGL132
     C                   EVAL      FAMAIL = A_FVMAIL                                          CGL132
     C                   EVAL      FAPHON = A_FVPHON                                          CGL132
     C                   EVAL      FACSTY = A_FVCSTY                                          CGL132
     C                   EVAL      FACSST = A_FVCSST                                          CGL132
     C                   EVAL      FARPTT = A_FVRPTT                                          CGL132
     C                   EVAL      FARPTR = A_FVRPTR                                          CGL132
     C                   EVAL      FARPTD = A_FVRPTD                                          CGL132
     C                   EVAL      FARPTM = A_FVRPTM                                          CGL132
     C                   IF        FARPTM = '******'                                        MD051206
     C                   MOVE      BBTMST        WTime                                      MD051206
     C     *HMS0         MOVE      WTime         FARPTM                                     MD051206
     C                   ENDIF                                                              MD051206
     C                   EVAL      FARPTU = A_FVRPTU                                          CGL132
     C                   EVAL      FAHVAC = A_FVHVAC                                          CGL132
     C                   EVAL      FAINFC = A_FVINFC                                          CGL132
     C                   EVAL      FAEXMA = A_FVEXMA                                          CGL132
     C                   EVAL      FAEXID = A_FVEXID                                          CGL132
     C                   EVAL      FALDAT = BJRDNB                                            CGL132
     C                   EVAL      FALCTP = 'A'                                               CGL132
     C**********         EVAL      FALUSR = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FALUSR = WKUSER                                MD026835 MD027492A
     C                   EVAL      FALUSR = WLUSER                                         MD027492A
     C                   UPDATE    SDFTCSD0                                                   CGL132
                                                                                              CGL132
     C                   IF        CSD092 = 'Y'                                               CGL132
     C                   EVAL      PBefFTCS = SDFTCS2                                       MD026957
     C                   EVAL      PAftFTCS = SDFTCS                                        MD026957
     C                   EVAL      PBefCUXC = SDCUXC2                                       MD026957
     C                   EVAL      PAftCUXC = SDCUXC                                        MD026957
     C                   IF        S01425 <> 'Y' OR CSD079 <> 'Y'                           MD026957
     C                   CALL      'SD009696'                                                 CGL132
     C                   PARM      FACUST        PCUST                                        CGL132
     C                   PARM      CUSTDF2       PBefCUST                                     CGL132
     C                   PARM      CUSTDF        PAftCUST                                     CGL132
     C                   PARM      *BLANKS       PBefACUS                                     CGL132
     C                   PARM      *BLANKS       PAftACUS                                     CGL132
     C                   PARM      SDFTCS2       PBefFTCS                                     CGL132
     C                   PARM      SDFTCS        PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CGL132
     C                   PARM      *BLANKS       PAftJACC                                     CGL132
     C                   PARM      *BLANKS       PBefCUAH                                     CGL132
     C                   PARM      *BLANKS       PAftCUAH                                     CGL132
     C                   PARM      SDCUXC2       PBefCUXC                                   MD026854
     C                   PARM      SDCUXC        PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CGL132
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD026957
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             FAHVAC = 'H' AND                                           CGL132
     C                             WWHVAC <> 'H' AND                                          CGL132
     C                             CSD092 = 'Y'                                               CGL132
     C                   EVAL      KCUST = FACUST                                             CGL132
     C                   EVAL      KSCDT = BJRDNB                                             CGL132
     C                   EVAL      KSEQN = 999                                                CGL132
     C                   EVAL      ARSEQN = 0                                                 CGL132
     C     KACRV         SETGT     SDACRVL0                                                   CGL132
     C                   READP     SDACRVL0                                                   CGL132
                                                                                              CGL132
     C                   IF        ARCUST = KCUST AND                                         CGL132
     C                             ARSCDT = KSCDT                                             CGL132
     C                   EVAL      AVSEQN = ARSEQN + 1                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   CLEAR                   SDACRVDF                                   MD045218
     C                   EVAL      AVSEQN = 1                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C**********         CLEAR                   SDACRVDF                            CGL132 MD045218
                                                                                              CGL132
     C                   EVAL      ARCUST = FACUST                                            CGL132
     C                   EVAL      ARSEQN = AVSEQN                                            CGL132
     C                   EVAL      ARPURP = 'FATCA High Value +                               CGL132
     C                                      Account Review'                                   CGL132
     C**********         EVAL      ARSCDT = BJRDNB                                   CGL132 MD026502
     C                   EVAL      ARACRF = SVal2                                             CGL132
     C                   EVAL      ARCOMP = 'N'                                               CGL132
      ** Calculate for Schedule Date                                                        MD026502
     C                   CALL      'SD000164'                                               MD026502
     C                   PARM      *BLANKS       RtCdScDt          7                        MD026502
     C                   PARM      ARACRF        AcRvFreq          1                        MD026502
     C                   PARM      ARCOMP        AcRvComp          1                        MD026502
     C                   PARM                    BJDFIN                                     MD026502
     C                   PARM                    BJCYCD                                     MD026502
     C                   PARM                    BJLCCY                                     MD026502
     C                   PARM                    BJSLCD                                     MD026502
     C                   PARM                    BJRDNB                                     MD026502
     C                   PARM      0             AcRvScDt          5 0                      MD026502
      ** Account Review Schedule Date                                                       MD026502
     C                   EVAL      ARSCDT = AcRvScDt                                        MD026502
                                                                                              CGL132
      ** Get timestamp.                                                                       CGL132
                                                                                              CGL132
     C                   CALLB     'ZAGENTMSTM'                                               CGL132
     C                   PARM                    WWTMST                                       CGL132
     C                   MOVE      WWTMST        ARTMST                                       CGL132
                                                                                              CGL132
     C                   EVAL      ARMAGE = 'G'                                               CGL132
     C                   EVAL      ARLTYP = 'I'                                               CGL132
     C**********         EVAL      ARLUSR = PSUSER                                   CGL132 MD026835
     C**********         EVAL      ARLUSR = WKUSER                                MD026835 MD027492A
     C                   EVAL      ARLUSR = WLUSER                                         MD027492A
     C                   EVAL      ARINDT = BJRDNB                                            CGL132
     C                   EVAL      ARFOID = *BLANKS                                           CGL132
                                                                                              CGL132
     C                   WRITE     SDACRVD0                                                   CGL132
                                                                                              CGL132
     C                   EVAL      EXDDCUST = ARCUST                                        MD026499
     C                   EVAL      EXDDSCDF = *BLANKS                                       MD026499
     C                   MOVEL     ARSCDT        EXDDSCDF                                   MD026499
     C                   EVAL      EXDDSEQN = %TRIML(%CHAR(ARSEQN):'0')                     MD026499
     C                   EVAL      EXDDFOID = ARFOID                                        MD026499
     C                   WRITE     TSDACRVD0                                                MD026499
                                                                                            MD026499
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL157
      ** Access CRS Transaction Details if CGL157 is *ON                                      CGL157
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C     A_CUCUST      CHAIN     SDCRSHL0                             99                    CGL157
     C                   EVAL      PBefCRSH = SDCRSH                                          CGL177
                                                                                              CGL157
      ** Initialize Transaction Detail                                                        CGL157
                                                                                              CGL157
     C                   CLEAR                   SDCRSH                                       CGL157
                                                                                              CGL157
     C                   EVAL      CRCUST = BBCUST                                            CGL157
     C                   EVAL      CRTYPE = C_CVTYPE                                          CGL157
     C                   EVAL      CRSTYP = C_CVSTYP                                          CGL157
     C                   EVAL      CRHVAL = C_CVHVAL                                          CGL157
     C                   EVAL      CREXMP = C_CVEXMP                                          CGL157
     C                   EVAL      CREXMR = C_CVEXMR                                          CGL157
     C                   EVAL      CREXMD = C_CVEXMD                                          CGL157
     C                   EVAL      CREXMT = C_CVEXMT                                          CGL157
     C                   EVAL      CREXMU = C_CVEXMU                                          CGL157
     C                   EVAL      CRINFO = C_CVINFO                                          CGL157
     C                   EVAL      CREXMG = C_CVEXMG                                          CGL157
     C                   EVAL      CREXMI = C_CVEXMI                                          CGL157
     C                   EVAL      PAftCRSH = SDCRSH                                          CGL177
     C                                                                                        CGL157
     C                   UPDATE    SDCRSHD0                                                   CGL157
                                                                                              CGL157
      ** Update CRS Country Details                                                           CGL157
     C                   EVAL      A = 1                                                      CGL177
     C                   EVAL      X = 1                                                      CGL157
     C                   EVAL      PBefCRSD = *BLANKS                                         CGL177
     C                   EVAL      PAftCRSD = *BLANKS                                         CGL177
     C                   DOW       X < 31                                                     CGL157
     C                   EVAL      SDVCRSD = PCrsdF(X)                                        CGL157
     C                   EVAL      PCrsdZ = PCrsdF(X)                                         CGL157
     C                   IF        D_CVCTRY <> *Blanks                                        CGL157
     C                   EVAL      KCUST = BBCUST                                             CGL177
     C                   EVAL      KCTRY = D_CVCTRY                                           CGL177
     C     KCRSD         CHAIN     SDCRSDL1                                                   CGL177
     C                   EVAL      SDCRSDB = SDCRSD                                           CGL177
     C                   EVAL      CDCUST = BBCUST                                            CGL157
     C                   EVAL      CDCTRY = D_CVCTRY                                          CGL157
     C                   EVAL      CDREPT = D_CVREPT                                          CGL157
     C                   EVAL      CDREPR = D_CVREPR                                          CGL157
                                                                                            MD036375
      ** Look for the US Country and use the TIN if provided                                MD036375
     C                   IF        CGL132 = 'Y' AND                                         MD036375
     C                             CGL133 = 'N'                                             MD036375
     C*****BBCUST        CHAIN     SDFTCSL0                             99         MD036375 MD051230
     C     BBCUST        CHAIN(N)  SDFTCSL0                             99                  MD051230
                                                                                            MD036375
      ** Database error                                                                     MD036375
     C                   IF        NOT %FOUND(SDFTCSL0)                                     MD036375
     C                   EVAL      DBKEY  = BBCUST                                          MD036375
     C                   EVAL      DBFILE = 'SDFTCSPD'                                      MD036375
     C                   EVAL      DBASE  =  801                                            MD036375
     C                   EXSR      SRErr                                                    MD036375
     C                   ENDIF                                                              MD036375
                                                                                            MD036375
     C                   EVAL      WCTAX = SVal1                                            MD036375
                                                                                            MD036375
     C                   IF        BBCOLC = WCTAX                                           MD036375
     C     BBCUST        CHAIN     SDFTCSL0                             99                  MD051230
     C                   EVAL      FAUTIN = E5TINO                                          MD036375
     C                   UPDATE    SDFTCSD0                                                 MD036375
     C                   ELSE                                                               MD036457
     C                   IF        D_CVCTRY = WCTAX                                         MD036457
     C     BBCUST        CHAIN     SDFTCSL0                             99                  MD051230
     C                   EVAL      FAUTIN = D_CVTINN                                        MD036457
     C                   UPDATE    SDFTCSD0                                                 MD036457
     C                   ENDIF                                                              MD036457
     C                   ENDIF                                                              MD036457
     C                   ENDIF                                                              MD036375
                                                                                            MD036375
     C                   IF        %SUBST(PCrsdZ:138:3) = *Blanks                             CGL157
     C                   EVAL      CDREPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_CVREPD      CDREPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CDREPM = D_CVREPM                                          CGL157
     C                   IF        CDREPM = '******'                                          CGL177
     C**********         MOVE      E5TMST        WTime                               CGL177 MD051393
     C                   MOVE      BBTMST        WTime                                      MD051393
     C     *HMS0         MOVE      WTime         CDREPM                                       CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      CDREPU = D_CVREPU                                          CGL157
     C                   EVAL      CDEVE1 = D_CVEVE1                                          CGL157
     C                   EVAL      CDEVS1 = D_CVEVS1                                          CGL157
     C                   EVAL      CDEVE2 = D_CVEVE2                                          CGL157
     C                   EVAL      CDEVS2 = D_CVEVS2                                          CGL157
     C                   EVAL      CDEVE3 = D_CVEVE3                                          CGL157
     C                   EVAL      CDEVS3 = D_CVEVS3                                          CGL157
     C                   EVAL      CDEVE4 = D_CVEVE4                                          CGL157
     C                   EVAL      CDEVS4 = D_CVEVS4                                          CGL157
     C                   EVAL      CDEVE5 = D_CVEVE5                                          CGL157
     C                   EVAL      CDEVS5 = D_CVEVS5                                          CGL157
     C                   EVAL      CDTINN = D_CVTINN                                          CGL157
     C                   EVAL      CDCODO = D_CVCODO                                          CGL157
     C                   EVAL      CDJACM = D_CVJACM                                          CGL157
     C                   EVAL      CDMAIL = D_CVMAIL                                          CGL157
     C                   EVAL      CDPHON = D_CVPHON                                          CGL157
     C                   EVAL      CDRPAY = D_CVRPAY                                          CGL157
     C                   EVAL      CDTINS = D_CVTINS                                          CGL177
     C                   IF        %SUBST(PCrsdZ:207:3) = *Blanks                             CGL157
     C                   EVAL      CDEFFD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_CVEFFD      CDEFFD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        %SUBST(PCrsdZ:210:3) = *Blanks                             CGL157
     C                   EVAL      CDEXPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_CVEXPD      CDEXPD                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        %FOUND(SDCRSDL1)                                           CGL177
     C                   IF        %SUBST(PCrsdZ:3:1) <> '*'                                  CGL177
     C                   EVAL      %SUBST(PBefCRSD:A:219) = SDCRSDB                           CGL177
     C                   EVAL      %SUBST(PAftCRSD:A:219) = SDCRSD                            CGL177
     C                   EVAL      A = A + 229                                                CGL177
     C                   UPDATE    SDCRSDD0                                                   CGL177
     C                   ELSE                                                                 CGL177
     C                   DELETE    SDCRSDD0                                                   CGL177
     C                   ENDIF                                                                CGL177
     C                   ELSE                                                                 CGL177
     C                   IF        %SUBST(PCrsdZ:3:1) <> '*'                                  CGL177
     C                   EVAL      %SUBST(PBefCRSD:A:219) = *Blanks                           CGL177
     C                   EVAL      %SUBST(PAftCRSD:A:219) = SDCRSD                            CGL177
     C                   EVAL      A = A + 229                                                CGL177
     C                   WRITE     SDCRSDD0                                                   CGL157
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL157
     C                   EVAL      X = X + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        CSD092 = 'Y'                                               CGL177
     C                             AND (S01425 <> 'Y' OR CSD079 <> 'Y')                     MD051563
     C                   IF        CGL132 = 'Y'                                               CGL177
     C                   EVAL      PBefFTCS = SDFTCS2                                         CGL177
     C                   EVAL      PAftFTCS = SDFTCS                                          CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      PBefFTCS = *BLANKS                                         CGL177
     C                   EVAL      PAftFTCS = *BLANKS                                         CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        CGL157 = 'N'                                               CGL177
     C                   EVAL      PBefCRSH = *BLANKS                                         CGL177
     C                   EVAL      PAftCRSH = *BLANKS                                         CGL177
     C                   EVAL      PBefCRSD = *BLANKS                                         CGL177
     C                   EVAL      PAftCRSD = *BLANKS                                         CGL177
     C                   ENDIF                                                                CGL177
                                                                                            MD041429
      ** Separate call of History of Customer Info program                                  MD041429
      ** for CRS Header (Miscellaneous Change)                                              MD041429
                                                                                            MD041429
     C                   IF        CGL132 = 'Y'                                             MD041429
     C                   CALL      'SD009696'                                               MD041429
     C                   PARM      BBCUST        PCUST                                      MD041429
     C                   PARM      *BLANKS       PBefCUST                                   MD041429
     C                   PARM      CUSTDF        PAftCUST                                   MD041429
     C                   PARM      *Blanks       PBefACUS                                   MD041429
     C                   PARM      *Blanks       PAftACUS                                   MD041429
     C                   PARM                    PBefFTCS                                   MD041429
     C                   PARM                    PAftFTCS                                   MD041429
     C                   PARM      *BLANKS       PBefJACC                                   MD041429
     C                   PARM      *BLANKS       PAftJACC                                   MD041429
     C                   PARM      *BLANKS       PBefCUAH                                   MD041429
     C                   PARM      *BLANKS       PAftCUAH                                   MD041429
     C                   PARM      *BLANKS       PBefCUXC                                   MD041429
     C                   PARM      *BLANKS       PAftCUXC                                   MD041429
     C                   PARM      *BLANKS       PACRV                                      MD041429
     C                   PARM      *BLANKS       PELEC                                      MD041429
     C                   PARM                    PBefCRSH                                   MD041429
     C                   PARM                    PAftCRSH                                   MD041429
     C                   PARM                    PBefCRSD                                   MD041429
     C                   PARM                    PAftCRSD                                   MD041429
                                                                                            MD041429
     C                   ELSE                                                               MD041429
                                                                                            MD041429
     C                   CALL      'SD009696'                                               MD041429
     C                   PARM      BBCUST        PCUST                                      MD041429
     C                   PARM      *BLANKS       PBefCUST                                   MD041429
     C                   PARM      CUSTDF        PAftCUST                                   MD041429
     C                   PARM      *BLANKS       PBefACUS                                   MD041429
     C                   PARM      *BLANKS       PAftACUS                                   MD041429
     C                   PARM      *BLANKS       PBefFTCS                                   MD041429
     C                   PARM      *BLANKS       PAftFTCS                                   MD041429
     C                   PARM      *BLANKS       PBefJACC                                   MD041429
     C                   PARM      *BLANKS       PAftJACC                                   MD041429
     C                   PARM      *BLANKS       PBefCUAH                                   MD041429
     C                   PARM      *BLANKS       PAftCUAH                                   MD041429
     C                   PARM      *BLANKS       PBefCUXC                                   MD041429
     C                   PARM      *BLANKS       PAftCUXC                                   MD041429
     C                   PARM      *BLANKS       PACRV                                      MD041429
     C                   PARM      *BLANKS       PELEC                                      MD041429
     C                   PARM                    PBefCRSH                                   MD041429
     C                   PARM                    PAftCRSH                                   MD041429
     C                   PARM                    PBefCRSD                                   MD041429
     C                   PARM                    PAftCRSD                                   MD041429
     C                   ENDIF                                                              MD041429
                                                                                            MD041429
     C                   ENDIF                                                                CGL157


      * Update CLINTCB - Client Details  *
     C                   CALL      'SDCLINT'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      BBCUST        @CUST             6
     C                   PARM      BBCSSN        @CSSN            10
     C                   PARM      BBCRTN        @CRTN            10
     C                   PARM      BBPAIN        @PAIN             1
     C                   PARM      BBCRNM        @CRNM            20
     C                   PARM      BBACOC        @ACOC             2
     C                   PARM      BBCNCZ        @CNCZ             2
     C                   PARM      BBCOLC        @COLC             2
     C                   PARM      BBSSDT        @SSDT             5 0
     C                   PARM      BBDOIC        @DOIC             5 0
     C                   PARM      BBPCNB        @PCNB             6
     C                   PARM      BBCASC        @CASC             8
     C                   PARM      BBBRCD        @BRCD             3
     C                   PARM      BBBNBI        @BNBI             1
     C                   PARM      BBLINC        @LINC             2
     C                   PARM      BBLICD        @LICD             3
     C                   PARM      BBCTNB        @CTNB            12
     C                   PARM      BBREID        @REID             4
     C                   PARM      BBBSIN        @BSIN             1
     C                   PARM      BBCSTY        @CSTY             1
     C                   PARM      BBTAIN        @TAIN             1
     C                   PARM      BBCSID        @CSID            12
     C                   PARM      BBSTAD        @STAD            12
     C                   PARM      BBTXA1        @TXA1            10
     C                   PARM      BBCHID        @CHID             6 0
     C                   PARM      BBCHSC        @CHSC             6 0
     C                   PARM      BBCABA        @CABA             3 0
     C                   PARM      BBRWCD        @RWCD             4
     C                   PARM      BBCGRP        @CGRP             1
     C                   PARM      BBABA2        @ABA2             4 0
     C                   PARM      BBTYLC        @TYLC             1
     C                   PARM      BJRDNB        @RDNB             5 0
     C                   PARM      WUGPC1        @GPC1             4
     C                   PARM      WUGPC2        @GPC2             4
     C                   PARM      WUGPC3        @GPC3             4
     C                   PARM      WUGPC4        @GPC4             4
     C                   PARM      WUGPC5        @GPC5             4
     C                   PARM      A_ADLNID      @LNID             2                        AR830675
     C                   PARM      A_ADCTYP      @CTYP            10                        AR830675
     C/COPY WNCPYSRC,SDCUSDDC07
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'CLINTCB'     DBFILE                         ************
     C                   MOVEL     '011'         DBASE                          * DBERR 011*
     C                   EXSR      SRERR                                        ************
     C                   END

      * Update CLINTCC 2 - Client Details  *
     C                   CALL      'SDALTNA'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      BBCUST        @CUST             6
     C                   PARM      BBCNA1        @CNA1            35
     C                   PARM      BBCNA2        @CNA2            35
     C                   PARM      BBCNA3        @CNA3            35
     C                   PARM      BBCNA4        @CNA4            35
     C                   PARM      BBCRTN        @CRTN            10
     C                   PARM      BBTYLC        @TYLC             1
     C                   PARM      BJRDNB        @RDNB             5 0
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'CLINTCC'     DBFILE                         ************
     C                   MOVEL     '012'         DBASE                          * DBERR 012*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
                                                                                            MD027115
     C                   IF        CGL132 = 'Y'                                             MD027115
      ** Update exceptions on Joint Account                                                 MD027115
                                                                                            MD027115
     C     BBCUST        SETLL     SDJACCL4                                                 MD027115
     C     BBCUST        READE     SDJACCL4                                                 MD027115
                                                                                            MD027115
     C                   DOW       NOT %EOF(SDJACCL4)                                       MD027115
                                                                                            MD027115
     C                   CALL      'SD000715'                                               MD027115
     C                   PARM                    JCJANO                                     MD027115
     C                   PARM      '1'           PCommitCUSD                                MD043029
     C                   PARM      '0'           PCommitNAHL                                MD043029
                                                                                            MD027115
     C     BBCUST        READE     SDJACCL4                                                 MD027115
     C                   ENDDO                                                              MD027115
                                                                                            MD027115
     C                   ENDIF                                                              MD027115
                                                                                            MD027115
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DELETE - DELETE A CUSTOMER                                   *
     C*                                                              *
     C****************************************************************
     C     DELETE        BEGSR

      ** ACCESS CUSTOMER

     C     A_CUCUST      CHAIN     SDCUSTL0                           99

      ** DATABASE ERROR

     C     *IN99         IFEQ      '1'
     C                   MOVEL     A_CUCUST      DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     '013'         DBASE                          * DBERR 013*
     C                   EXSR      SRERR                                        ************
     C                   END

      ** UPDATE 'BEFORE' STATUS

     C                   MOVEL(P)  CUSTDF        B_CUSTD

      ** SET CUSTOMER FIELDS ON DELETE

     C                   EVAL      BBLCD=BJRDNB
     C                   EVAL      BBDTDL=BJRDNB
     C                   EVAL      BBTYLC='D'

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      BBTMST = TimeStamp

      ** Front Office ID                                                        CAP013
     C                   EVAL      BBFRNT=A_CUFRNT                              CAP013
      ** Associated Front Office ID                                             CAP013
     C                   EVAL      BBAFRT=A_CUAFRT                              CAP013
      *
      ** Update the SWIFT 2007 field details when CSW207 is on                                CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C     A_CUCUST      CHAIN     SDCSSWL0                                                   CSW207
     C                   IF        %FOUND(SDCSSWL0)                                           CSW207
     C                   EVAL      CSCUSD = A_CUCUST                                          CSW207
     C                   EVAL      CSBRCA = A_CUBRCD                                          CSW207
     C                   EVAL      CSCICI = A_CUCICI                                          CSW207
     C                   EVAL      CSCPCI = A_CUCPCI                                          CSW207
     C                   EVAL      CSIBEI = A_CUIBEI                                          CSW207
     C**********         IF        CFT050 = 'Y'                                      CFT050 MD028198
     C                   IF        CSW213 = 'Y'                                             MD028198
     C                   EVAL      CSLEIC = S13DDLEIC                                         CFT050
     C                   EVAL      CSCLSY = S13DDCLSY                                         CFT050
     C                   EVAL      CSCLID = S13DDCLID                                         CFT050
     C                   ENDIF                                                              MD028198
     C                   IF        CFT050 = 'Y'                                             MD028198
     C                   EVAL      CSBDRK = S13DDBDRK                                         CFT050
     C                   ENDIF                                                                CFT050
     C                   UPDATE    SDCSSWD0                                                   CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
      ** UPDATE RECORD

     C                   UPDATE    @BBREBG
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C     A_CUCUST      CHAIN     SDFTCSL0                           99                      CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '1'                                                        CGL132
     C                   MOVEL     A_CUCUST      DBKEY                                        CGL132
     C                   MOVEL     'SDFTCSPD'    DBFILE                                       CGL132
     C                   MOVEL     '006'         DBASE                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FALDAT = BJRDNB                                            CGL132
     C                   EVAL      FALCTP = 'D'                                               CGL132
     C**********         EVAL      FALUSR = PSUSER                                   CGL132 MD026835
     C**********         EVAL      FALUSR = WKUSER                                MD026835 MD027492A
     C                   EVAL      FALUSR = WLUSER                                         MD027492A
     C                   UPDATE    SDFTCSD0                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   IF        S01425 = 'Y' AND                                           CSD092
     C                             CSD079 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   IF        S01425 <> 'Y' OR CSD079 <> 'Y'                           MD026957
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      BBCUST        PCUST                                        CSD092
     C                   PARM      B_CUSTD       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                              MD026957
     C                   ENDIF                                                                CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C     A_CUCUST      CHAIN     SDCRSHL0                             99                    CGL157
     C                   EVAL      PBefCRSH = SDCRSH                                          CGL177
                                                                                              CGL157
     C                   EVAL      CRLDAT = BJRDNB                                            CGL157
     C                   EVAL      CRLCTP = 'D'                                               CGL157
     C                   EVAL      PAftCRSH = SDCRSH                                          CGL177
                                                                                              CGL157
     C                   UPDATE    SDCRSHD0                                                   CGL157
                                                                                              CGL157
     C                   CALL      'SD009696'                                                 CGL157
     C                   PARM      E5CUST        PCUST                                        CGL157
     C                   PARM      *BLANKS       PBefCUST                                     CGL157
     C                   PARM      *BLANKS       PAftCUST                                     CGL157
     C                   PARM      B_CUADF       PBefACUS                                     CGL157
     C                   PARM      CUSTDF        PAftACUS                                     CGL157
     C                   PARM                    PBefFTCS                                     CGL157
     C                   PARM                    PAftFTCS                                     CGL157
     C                   PARM      *BLANKS       PBefJACC                                     CGL157
     C                   PARM      *BLANKS       PAftJACC                                     CGL157
     C                   PARM      *BLANKS       PBefCUXC                                     CGL157
     C                   PARM      *BLANKS       PAftCUXC                                     CGL157
     C                   PARM      *BLANKS       PACRV                                        CGL157
     C                   PARM      *BLANKS       PELEC                                        CGL157
     C                   PARM                    PBefCRSH                                     CGL157
     C                   PARM                    PAftCRSH                                     CGL157
     C                   PARM      *BLANKS       XBefCRSD                                     CGL157
     C                   PARM      *BLANKS       XAftCRSD                                     CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157

      * USER: Processing after Data update
     C                   MOVEL     CUSTDF        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PBRC
     C                   MOVEL     'SDCUSTPD'    PBFNME
     C                   MOVEL     A_CUCUST      PBLKEY
     C                   MOVEL     WUDR01        PBDR01
     C                   MOVEL     WUDR02        PBDR02
     C                   MOVEL     WUDR03        PBDR03
     C                   MOVEL     WUDR04        PBDR04
     C                   MOVEL     WUDR05        PBDR05
     C                   MOVEL     WUDR06        PBDR06
     C                   MOVEL     WUDR07        PBDR07
     C                   MOVEL     WUDR08        PBDR08
     C                   MOVEL     WUDR09        PBDR09
     C                   MOVEL     WUDR10        PBDR10
     C                   MOVEL     WUDR11        PBDR11
     C                   MOVEL     WUDR12        PBDR12
     C                   MOVEL     BJRDNB        PBLCD
     C                   MOVEL     'D'           PBTYLC

     C                   CALL      'SD0520X'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    PBRC
      * Error detected?
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     A_CUCUST      DBKEY
     C                   MOVEL     'SDDELRL0'    DBFILE                         ************
     C                   MOVEL     '014'         DBASE                          * DBERR 014*
     C                   EXSR      SRERR                                        ************
     C                   END

     C                   Z-ADD     -1            WUNORC                         No of records
     C                   Z-ADD     *ZERO         WUNOAM                         No of Amend
     C                   Z-ADD     *ZERO         WUNOIN                         No of delete
     C                   Z-ADD     1             WUNODL                         No of Insert
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDCUSTPD'    WFLNAME           8            No of delete
     C                   EXSR      SNCHRC

     C                   EXSR      UPDTID                                                    BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     'D'           BBTYLC
      * Update CLINTCB - Client Details  *
     C                   CALL      'SDCLINT'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      BBCUST        @CUST             6
     C                   PARM      BBCSSN        @CSSN            10
     C                   PARM      BBCRTN        @CRTN            10
     C                   PARM      BBPAIN        @PAIN             1
     C                   PARM      BBCRNM        @CRNM            20
     C                   PARM      BBACOC        @ACOC             2
     C                   PARM      BBCNCZ        @CNCZ             2
     C                   PARM      BBCOLC        @COLC             2
     C                   PARM      BBSSDT        @SSDT             5 0
     C                   PARM      BBDOIC        @DOIC             5 0
     C                   PARM      BBPCNB        @PCNB             6
     C                   PARM      BBCASC        @CASC             8
     C                   PARM      BBBRCD        @BRCD             3
     C                   PARM      BBBNBI        @BNBI             1
     C                   PARM      BBLINC        @LINC             2
     C                   PARM      BBLICD        @LICD             3
     C                   PARM      BBCTNB        @CTNB            12
     C                   PARM      BBREID        @REID             4
     C                   PARM      BBBSIN        @BSIN             1
     C                   PARM      BBCSTY        @CSTY             1
     C                   PARM      BBTAIN        @TAIN             1
     C                   PARM      BBCSID        @CSID            12
     C                   PARM      BBSTAD        @STAD            12
     C                   PARM      BBTXA1        @TXAI            10
     C                   PARM      BBCHID        @CHID             6 0
     C                   PARM      BBCHSC        @CHSC             6 0
     C                   PARM      BBCABA        @CABA             3 0
     C                   PARM      BBRWCD        @RWCD             4
     C                   PARM      BBCGRP        @CGRP             1
     C                   PARM      BBABA2        @ABA2             4 0
     C                   PARM      BBTYLC        @TYLC             1
     C                   PARM      BJRDNB        @RUNDNB           5 0
     C                   PARM      WUGPC1        @GPC1             4
     C                   PARM      WUGPC2        @GPC2             4
     C                   PARM      WUGPC3        @GPC3             4
     C                   PARM      WUGPC4        @GPC4             4
     C                   PARM      WUGPC5        @GPC5             4
     C                   PARM      A_ADLNID      @LNID             2                        AR830675
     C                   PARM      A_ADCTYP      @CTYP            10                        AR830675
     C/COPY WNCPYSRC,SDCUSDDC09
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'CLINTCB'     DBFILE                         ************
     C                   MOVEL     '015'         DBASE                          * DBERR 015*
     C                   EXSR      SRERR                                        ************
     C                   END

      * Update CLINTCC 2 - Client Details  *
     C                   CALL      'SDALTNA'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      BBCUST        @CUST             6
     C                   PARM      BBCNA1        @CNA1            35
     C                   PARM      BBCNA2        @CNA2            35
     C                   PARM      BBCNA3        @CNA3            35
     C                   PARM      BBCNA4        @CNA4            35
     C                   PARM      BBCRTN        @CRTN            10
     C                   PARM      BBTYLC        @TYLC             1
     C                   PARM      BJRDNB        @RUNDNB           5 0
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'CLINTCC'     DBFILE                         ************
     C                   MOVEL     '016'         DBASE                          * DBERR 016*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Check/Tag records - Alternate Names & Address  *
     C                   EXSR      SRRVGN

      *
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                  CSD007
     C****************************************************************                        CSD007
     C*                                                              *                        CSD007
     C* CLOSE - CLOSE A CUSTOMER                                     *                        CSD007
     C*                                                              *                        CSD007
     C****************************************************************                        CSD007
     C     CLOSE         BEGSR                                                                CSD007
                                                                                              CSD007
      ** ACCESS CUSTOMER                                                                      CSD007
                                                                                              CSD007
     C     A_CUCUST      CHAIN     SDCUSTL0                           99                      CSD007
                                                                                              CSD007
      ** DATABASE ERROR                                                                       CSD007
                                                                                              CSD007
     C     *IN99         IFEQ      '1'                                                        CSD007
     C                   MOVEL     A_CUCUST      DBKEY                                        CSD007
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************  CSD007
     C                   MOVEL     '021'         DBASE                          * DBERR 021*  CSD007
     C                   EXSR      SRERR                                        ************  CSD007
     C                   END                                                                  CSD007
                                                                                              CSD007
      ** UPDATE 'BEFORE' STATUS                                                               CSD007
                                                                                              CSD007
     C                   MOVEL(P)  CUSTDF        B_CUSTD                                      CSD007
                                                                                              CSD007
      ** SET CUSTOMER FIELDS ON CLOSURE                                                       CSD007
                                                                                              CSD007
     C                   EVAL      BBLCD=BJRDNB                                               CSD007
     C                   EVAL      BBCLDT=BJRDNB                                              CSD007
     C                   EVAL      BBCLST='Y'                                                 CSD007
     C                   EVAL      BBTYLC='A'                                                 CSD007
                                                                                              CSD007
      ** Timestamp                                                                            CSD007
     C                   CALLB     'ZAGENTMSTM'                                               CSD007
     C                   PARM                    TimeStamp                                    CSD007
                                                                                              CSD007
     C                   EVAL      BBTMST = TimeStamp                                         CSD007
      ** Logically delete the retail accounts first                                           CSD023
                                                                                              CSD023
     C                   if        csd023 = 'Y'                                               CSD023
                                                                                              CSD023
     C     w0key1        klist                                                                CSD023
     C                   kfld                    w0cnum                                       CSD023
     C                   kfld                    w0ccy                                        CSD023
     C                   kfld                    w0acod                                       CSD023
     C                   kfld                    w0acsq                                       CSD023
     C                   kfld                    w0brca                                       CSD023
                                                                                              CSD023
     C                   move      BBCUST        w0cnum                                       CSD023
     C                   move      *loval        w0ccy                                        CSD023
     C                   move      *loval        w0acod                                       CSD023
     C                   move      *loval        w0acsq                                       CSD023
     C                   move      *loval        w0brca                                       CSD023
                                                                                              CSD023
     C                   move      *off          APIRetc                                      CSD023
                                                                                              CSD023
     C     w0key1        setll     ACCNTABF                               99                  CSD023
                                                                                              CSD023
     C     *in99         ifeq      *off                                                       CSD023
                                                                                              CSD023
     C                   read(N)   ACCNTABF                             9898                  CSD023
                                                                                              CSD023
     C     *in98         doweq     *off                                                       CSD023
     C     cnum          andeq     w0cnum                                                     CSD023
     C     APIRetc       andeq     *off                                                       CSD023
                                                                                              CSD023
      ** Only live retail accounts must be considered                                         CSD023
     C                   if        ATYP='R' and RECI='D' and ACST<>'C'                        CSD023
                                                                                              CSD023
     C                   move      CNUM          w1cnum                                       CSD023
     C                   move      CCY           w1ccy                                        CSD023
     C                   move      ACOD          w1acod                                       CSD023
     C                   move      ACSQ          w1acsq                                       CSD023
     C                   move      BRCA          w1brca                                       CSD023
                                                                                              CSD023
     C                   call      'SDC000801'                                                CSD023
     C                   parm                    w1accn                                       CSD023
     C                   parm      *off          APIRetc                                      CSD023
                                                                                              CSD023
     C                   endif                                                                CSD023
                                                                                              CSD023
     C                   read(N)   ACCNTABF                             9898                  CSD023
     C                   enddo                                                                CSD023
                                                                                              CSD023
     C                   endif                                                                CSD023
                                                                                              CSD023
      * Error detected?                                                                       CSD023
     C     APIRetc       ifeq      *on                                                        CSD023
     C                   movel     *BLANK        dbkey                                        CSD023
     C                   movel     'w0key1'      dbkey                                        CSD023
     C                   movel     'ACCNT   '    dbfile                         ************  CSD023
     C                   movel     '030'         dbase                          * DBERR 030*  CSD023
     C                   exsr      srerr                                        ************  CSD023
     C                   endif                                                                CSD023
                                                                                              CSD023
     C                   endif                                                                CSD023
                                                                                              CSD023
      *                                                                                       CSD007
      ** UPDATE RECORD                                                                        CSD007
                                                                                              CSD007
     C                   UPDATE    @BBREBG                                                    CSD007
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   IF        S01425 = 'Y' AND                                           CSD092
     C                             CSD079 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
                                                                                              CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      BBCUST        PCUST                                        CSD092
     C                   PARM      B_CUSTD       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      *BLANKS       PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CSD092
     C                   ENDIF                                                                CSD092
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C     A_CUCUST      CHAIN     SDCSSWL0                                                   CSW207
     C                   IF        %FOUND(SDCSSWL0)                                           CSW207
     C                   UPDATE    SDCSSWD0                                                   CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSD007
     C                   Z-ADD     *ZERO         WUNORC                         No of records CSD007
     C                   Z-ADD     1             WUNOAM                         No of Amend   CSD007
     C                   Z-ADD     *ZERO         WUNOIN                         No of Inserts CSD007
     C                   Z-ADD     *ZERO         WUNODL                         No of Deletes CSD007
      * Change Standing Data Cont - Standing Data Controls  *                                 CSD007
     C                   MOVEL     'SDCUSTPD'    WFLNAME           8            No of delete  CSD007
     C                   EXSR      SNCHRC                                                     CSD007
                                                                                              CSD007
     C                   ENDSR                                                                CSD007
     C****************************************************************                        CSD007
      /EJECT                                                                                  CSD007
     C****************************************************************                        CSD007
     C*                                                              *                        CSD007
     C* RELEASE - RELEASE A CUSTOMER                                 *                        CSD007
     C*                                                              *                        CSD007
     C****************************************************************                        CSD007
     C     RELEASE       BEGSR                                                                CSD007
                                                                                              CSD007
      ** ACCESS CUSTOMER                                                                      CSD007
                                                                                              CSD007
     C     A_CUCUST      CHAIN     SDCUSTL0                           99                      CSD007
                                                                                              CSD007
      ** DATABASE ERROR                                                                       CSD007
                                                                                              CSD007
     C     *IN99         IFEQ      '1'                                                        CSD007
     C                   MOVEL     A_CUCUST      DBKEY                                        CSD007
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************  CSD007
     C                   MOVEL     '022'         DBASE                          * DBERR 022*  CSD007
     C                   EXSR      SRERR                                        ************  CSD007
     C                   END                                                                  CSD007
                                                                                              CSD007
      ** UPDATE 'BEFORE' STATUS                                                               CSD007
                                                                                              CSD007
     C                   MOVEL(P)  CUSTDF        B_CUSTD                                      CSD007
                                                                                              CSD007
      ** SET CUSTOMER FIELDS ON CLOSURE                                                       CSD007
                                                                                              CSD007
     C                   EVAL      BBLCD=BJRDNB                                               CSD007
     C                   EVAL      BBCLDT=BJRDNB                                              CSD007
     C                   EVAL      BBCLST=' '                                                 CSD007
     C                   EVAL      BBTYLC='A'                                                 CSD007
                                                                                              CSD007
      ** Timestamp                                                                            CSD007
     C                   CALLB     'ZAGENTMSTM'                                               CSD007
     C                   PARM                    TimeStamp                                    CSD007
                                                                                              CSD007
     C                   EVAL      BBTMST = TimeStamp                                         CSD007
      *                                                                                       CSD007
      ** UPDATE RECORD                                                                        CSD007
                                                                                              CSD007
     C                   UPDATE    @BBREBG                                                    CSD007
                                                                                              CGL132
     C                   IF        CSD092 = 'Y'                                               CGL132
                                                                                              CGL132
     C                   CALL      'SD009696'                                                 CGL132
     C                   PARM      BBCUST        PCUST                                        CGL132
     C                   PARM      B_CUSTD       PBefCUST                                     CGL132
     C                   PARM      CUSTDF        PAftCUST                                     CGL132
     C                   PARM      *BLANKS       PBefACUS                                     CGL132
     C                   PARM      *BLANKS       PAftACUS                                     CGL132
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CGL132
     C                   PARM      *BLANKS       PAftJACC                                     CGL132
     C                   PARM      *BLANKS       PBefCUAH                                     CGL132
     C                   PARM      *BLANKS       PAftCUAH                                     CGL132
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CGL132
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C     A_CUCUST      CHAIN     SDCSSWL0                                                   CSW207
     C                   IF        %FOUND(SDCSSWL0)                                           CSW207
     C                   UPDATE    SDCSSWD0                                                   CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSD007
     C                   Z-ADD     *ZERO         WUNORC                         No of records CSD007
     C                   Z-ADD     1             WUNOAM                         No of Amend   CSD007
     C                   Z-ADD     *ZERO         WUNOIN                         No of Inserts CSD007
     C                   Z-ADD     *ZERO         WUNODL                         No of Deletes CSD007
      * Change Standing Data Cont - Standing Data Controls  *                                 CSD007
     C                   MOVEL     'SDCUSTPD'    WFLNAME           8            No of delete  CSD007
     C                   EXSR      SNCHRC                                                     CSD007
                                                                                              CSD007
     C                   ENDSR                                                                CSD007
     C****************************************************************                        CSD007
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SNCHRC - Change Standing Data Controls                        *
     C*                                                               *
     C*****************************************************************
     C     SNCHRC        BEGSR

     C                   MOVEL     *BLANK        W0RTN             7
      *
      * Move key fields to @AHREAU
     C                   MOVEL     *BLANK        AHFLNM
     C                   MOVEL     WFLNAME       AHFLNM
      *
     C     KLCHSN        KLIST
     C                   KFLD                    AHFLNM
     C     KLCHSN        CHAIN     @AHREAU                            90

      ** DATABASE ERROR

     C     *IN90         IFEQ      '1'
     C                   MOVEL     AHFLNM        DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE                         ************
     C                   MOVEL     '017'         DBASE                          * DBERR 017*
     C                   EXSR      SRERR                                        ************
     C                   END

      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC
     C                   ADD       AHNOIN        WUNOIN
     C                   ADD       AHNOAM        WUNOAM
     C                   ADD       AHNODL        WUNODL
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC
     C                   Z-ADD     WUNOIN        AHNOIN
     C                   Z-ADD     WUNOAM        AHNOAM
     C                   Z-ADD     WUNODL        AHNODL
      *
      * Update record
     C                   UPDATE    @AHREAU
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SORVGN - Customer Marketing Groups                            *
     C*                                                               *
     C*****************************************************************
     C     SORVGN        BEGSR

      * Define keylist
     C     KRSSO         KLIST
     C                   KFLD                    D7CUST
      *
      * Move fields to key list
     C                   MOVEL     BBCUST        D7CUST
     C     KRSSO         CHAIN     @D7REJB                            90

      ** DATABASE ERROR

     C     *IN90         IFEQ      '1'
      * USER: Processing if Data record not found
     C**********         MOVEL     *BLANK        WUGPC1            4                        MD031234
     C**********         MOVEL     *BLANK        WUGPC2            4                        MD031234
     C**********         MOVEL     *BLANK        WUGPC3            4                        MD031234
     C**********         MOVEL     *BLANK        WUGPC4            4                        MD031234
     C**********         MOVEL     *BLANK        WUGPC5            4                        MD031234
     C                   MOVEL     A_MIGPC1      WUGPC1            4                        MD031234
     C                   MOVEL     A_MIGPC2      WUGPC2            4                        MD031234
     C                   MOVEL     A_MIGPC3      WUGPC3            4                        MD031234
     C                   MOVEL     A_MIGPC4      WUGPC4            4                        MD031234
     C                   MOVEL     A_MIGPC5      WUGPC5            4                        MD031234
     C                   GOTO      SOEXIT
     C                   END

      * USER: Process Data record
      * PAR = DB1 By name
     C     *IN90         IFEQ      '0'
     C**********         MOVEL     D7GPC1        WUGPC1                                     MD020755
     C**********         MOVEL     D7GPC2        WUGPC2                                     MD020755
     C**********         MOVEL     D7GPC3        WUGPC3                                     MD020755
     C**********         MOVEL     D7GPC4        WUGPC4                                     MD020755
     C**********         MOVEL     D7GPC5        WUGPC5                                     MD020755
     C                   MOVEL     A_MIGPC1      WUGPC1                                     MD020755
     C                   MOVEL     A_MIGPC2      WUGPC2                                     MD020755
     C                   MOVEL     A_MIGPC3      WUGPC3                                     MD020755
     C                   MOVEL     A_MIGPC4      WUGPC4                                     MD020755
     C                   MOVEL     A_MIGPC5      WUGPC5                                     MD020755
     C                   END

      *
     C     SOEXIT        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SRRVGN - Check/Tag records - Alternate Names & Address        *
     C*                                                               *
     C*****************************************************************
     C     SRRVGN        BEGSR

     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSR         KLIST
     C                   KFLD                    BCCUST
     C                   KFLD                    BCADCD
     C     KRSSR         KLIST
     C                   KFLD                    BCCUST
      * Move key fields to key list
     C                   MOVEL     BBCUST        BCCUST
     C                   MOVEL     *BLANK        BCADCD
     C     KPSSR         SETLL     SDALTNL1
     C     KRSSR         READE     SDALTNL1                               90

     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0083'     W0RTN
     C                   END
     C     *IN90         DOWEQ     '0'
      * Delete Names & Addresses - Alternate Names & Address  *
     C                   EXSR      SSCHRC
     C     KRSSR         READE     SDALTNL1                               90
     C                   END
      *
     C     SREXIT        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SSCHRC - Delete Names & Addresses - Alternate Names & Address *
     C*                                                               *
     C*****************************************************************
     C     SSCHRC        BEGSR
      *
     C                   MOVEL     *BLANK        W0RTN             7
      *
      * Move key fields to @BCREDD (SDALTNL0)
      *
     C     KLCHSS        KLIST
     C                   KFLD                    BCCUST
     C                   KFLD                    BCADCD
     C                   MOVEL     BBCUST        BCCUST
     C                   MOVEL     *BLANK        BCADCD
     C     KLCHSS        CHAIN     SDALTNL0                           90

      ** DATABASE ERROR
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0009'     W0RTN
     C                   GOTO      SSEXIT
     C                   END

      * Move non-key fields to @BCREDD
     C                   Z-ADD     BJRDNB        BCLCD
     C                   MOVEL     'D'           BCTYLC
      * Update record
     C                   UPDATE    @BCREDD
      * USER: Processing after Data read
     C                   Z-ADD     -1            WUNORC
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     *ZERO         WUNOAM
     C                   Z-ADD     1             WUNODL
      * Change Standing Data Cont - Standing Data Controls  *
     C                   MOVEL     'SDALTNPD'    WFLNAME           8            No of delete
     C                   EXSR      SNCHRC
      * Update CLINTCC - Alternate Names & Address  *
     C                   CALL      'CLINTCC'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      BCCUST        @CUST             6
     C                   PARM      BCADCD        @ADCD             1
     C                   PARM      BCCNA1        @CNA1            35
     C                   PARM      BCCNA2        @CNA2            35
     C                   PARM      BCCNA3        @CNA3            35
     C                   PARM      BCCNA4        @CNA4            35
     C                   PARM      BCCRTN        @CRTN            10
     C                   PARM      BCCTNB        @CTNB            12
     C                   PARM      BCTXNB        @TXNB            12
     C                   PARM      BCCNCD        @CNCD             2
     C                   PARM      BJRDNB        @RDNB             5 0
     C                   PARM      'D'           @TYLC             1
      * Send message 'Unable to update'
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     BCCUST        DBKEY
     C                   MOVEL     'CLINTCC'     DBFILE                         ************
     C                   MOVEL     '018'         DBASE                          * DBERR 018*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      *
     C     SSEXIT        ENDSR
     C*****************************************************************
      /EJECT
     C********************************************************************
     C*                                                                  *
      * UPDBRT - UPDATE CUSTOMER BASE RATE TAX DETAILS IF S01383 = 'Y'   *
     C*                                                                  *
     C********************************************************************
     C     UPDBRT        BEGSR

     C     PTYKEY        KLIST
     C                   KFLD                    XCNUM
     C                   KFLD                    PTYSQN

      ** ACCESS CUSTOMER BASE RATE TAX DETAILS

     C     BRCNUM        CHAIN     SDCBRTL1                           98

      * Note file values for participant BRT
     C                   MOVE      H1BRTL        OLDBR1            1
     C                   MOVE      H2BRTL        OLDBR2            1
     C                   MOVE      H3BRTL        OLDBR3            1
     C                   MOVE      H4BRTL        OLDBR4            1
     C                   MOVE      H5BRTL        OLDBR5            1
     C                   MOVE      *BLANK        OLDBRT            1
     C                   MOVE      *BLANK        NEWBRT            1

      ** DATABASE ERROR
      ** IF INSERT, BUT RECORD PRESENT ALREADY
      ** OR IF NOT INSERT, BUT NO RECORD FOUND

      ** Skip validation if the customer came from the acceptance file.                       CSD031
                                                                                              CSD031
     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
     C     BRCHTP        IFEQ      'I'
     C     A_CUTYLC      ANDEQ     'I'                                                        201011
     C     *IN98         ANDEQ     '0'
     C     BRCHTP        ORNE      'I'
     C     *IN98         ANDEQ     '1'
     C                   MOVEL     BRCNUM        DBKEY
     C                   MOVEL     'SDCBRTL1'    DBFILE                         ************
     C                   MOVEL     '019'         DBASE                          * DBERR 019*
     C                   EXSR      SRERR                                        ************
     C                   END
     C**********         ENDIF                                                       CSD031 BUG13525

      ** Update with details from valid BRT DETAILS record

      ** SET SDCBRTPD FIELDS
     C                   EVAL      XRECI=BRRECI
     C                   EVAL      XCNUM=BRCNUM
     C                   EVAL      ACHLRT=BRAHLT
     C                   EVAL      H1TITL=BR1TIT
     C                   EVAL      H1NAME=BR1NAM
     C                   EVAL      H1INIT=BR1INI
     C                   EVAL      H1ADR1=BR1AD1
     C                   EVAL      H1ADR2=BR1AD2
     C                   EVAL      H1ADR3=BR1AD3
     C                   EVAL      H1PCD1=BR1PC1
     C                   EVAL      H1PCD2=BR1PC2
     C                   EVAL      H1BRTL=BR1BRL
     C                   EVAL      H1NINO=BR1NIN
     C                   EVAL      H1DOB= BR1DOB
     C                   EVAL      H1SEQN=BR1SQN

     C                   EVAL      H2TITL=BR2TIT
     C                   EVAL      H2NAME=BR2NAM
     C                   EVAL      H2INIT=BR2INI
     C                   EVAL      H2ADR1=BR2AD1
     C                   EVAL      H2ADR2=BR2AD2
     C                   EVAL      H2ADR3=BR2AD3
     C                   EVAL      H2PCD1=BR2PC1
     C                   EVAL      H2PCD2=BR2PC2
     C                   EVAL      H2BRTL=BR2BRL
     C                   EVAL      H2NINO=BR2NIN
     C                   EVAL      H2DOB=BR2DOB
     C                   EVAL      H2SEQN=BR2SQN

     C                   EVAL      H3TITL=BR3TIT
     C                   EVAL      H3NAME=BR3NAM
     C                   EVAL      H3INIT=BR3INI
     C                   EVAL      H3ADR1=BR3AD1
     C                   EVAL      H3ADR2=BR3AD2
     C                   EVAL      H3ADR3=BR3AD3
     C                   EVAL      H3PCD1=BR3PC1
     C                   EVAL      H3PCD2=BR3PC2
     C                   EVAL      H3BRTL=BR3BRL
     C                   EVAL      H3NINO=BR3NIN
     C                   EVAL      H3DOB=BR3DOB
     C                   EVAL      H3SEQN=BR3SQN

     C                   EVAL      H4TITL=BR4TIT
     C                   EVAL      H4NAME=BR4NAM
     C                   EVAL      H4INIT=BR4INI
     C                   EVAL      H4ADR1=BR4AD1
     C                   EVAL      H4ADR2=BR4AD2
     C                   EVAL      H4ADR3=BR4AD3
     C                   EVAL      H4PCD1=BR4PC1
     C                   EVAL      H4PCD2=BR4PC2
     C                   EVAL      H4BRTL=BR4BRL
     C                   EVAL      H4NINO=BR4NIN
     C                   EVAL      H4DOB=BR4DOB
     C                   EVAL      H4SEQN=BR4SQN

     C                   EVAL      H5TITL=BR5TIT
     C                   EVAL      H5NAME=BR5NAM
     C                   EVAL      H5INIT=BR5INI
     C                   EVAL      H5ADR1=BR5AD1
     C                   EVAL      H5ADR2=BR5AD2
     C                   EVAL      H5ADR3=BR5AD3
     C                   EVAL      H5PCD1=BR5PC1
     C                   EVAL      H5PCD2=BR5PC2
     C                   EVAL      H5BRTL=BR5BRL
     C                   EVAL      H5NINO=BR5NIN
     C                   EVAL      H5DOB=BR5DOB
     C                   EVAL      H5SEQN=BR5SQN

     C                   EVAL      TAXIND=BRTXIN
     C                   EVAL      PSTR=BRPSTR                                                CRE007
     C                   EVAL      NXASQN=BRNASQ
     C                   EVAL      ACHCGD=BRAHCD
     C                   EVAL      XLCD=BRXLCD
     C                   EVAL      XCHTP=BRCHTP
     C                   EVAL      XTNLU=0

      *
      * Update or write record in SDCBRTPD
      *
     C     *IN98         IFEQ      '1'
     C                   WRITE     SDCBRTD0
     C                   ELSE
     C                   UPDATE    SDCBRTD0
     C                   ENDIF


      ** Update BRT Particpator History file
      ** With details from valid BRT Participator History file

     C     ACTN          IFNE      'I'
     C     ACTN          ANDNE     'A'
     C                   GOTO      EndUPDBRT
     C                   ENDIF

     C     BRAHLT        IFNE      'I'
     C     BRAHLT        ANDNE     'J'
     C     BRAHLT        ANDNE     'R'                                                        201011
     C                   GOTO      EndUPDBRT
     C                   ENDIF

     C                   EVAL      XCNUM=BRCNUM

     C     BR1NAM        IFNE      *BLANK

     C                   EVAL      PTYSQN=BR1SQN

      ** Access BRT participator history details
     C     PTYKEY        CHAIN     PTYHSTPD                           94

      ** Set PTYHSTPD fields
     C                   EVAL      XRECI=BRRECI
     C                   EVAL      XCNUM=BRCNUM
     C                   EVAL      PTTITL=BR1TIT
     C                   EVAL      PTNAME=BR1NAM
     C                   EVAL      PTINIT=BR1INI
     C                   EVAL      PTADR1=BR1AD1
     C                   EVAL      PTADR2=BR1AD2
     C                   EVAL      PTADR3=BR1AD3
     C                   EVAL      PTPCD1=BR1PC1
     C                   EVAL      PTPCD2=BR1PC2
     C                   EVAL      PTNINO=BR1NIN
     C                   EVAL      PTDOB=BR1DOB
     C                   EVAL      PTYSQN=BR1SQN
     C                   EVAL      LFLAGS=*BLANKS
     C                   EVAL      EFFLDS=*ZEROS
     C                   EVAL      LCHGDS=*ZEROS
     C                   EVAL      XLCD=BRXLCD
     C                   EVAL      XCHTP=BRCHTP
     C                   EVAL      XTNLU=*ZERO

      *
      * Update or write record in PTYHSTPD
     C     *IN94         IFEQ      '0'
      *
     C                   EVAL      PTYSQN=BR1SQN
     C                   EVAL      OLDBRT=OLDBR1
     C                   EVAL      NEWBRT=BR1BRL
     C                   EXSR      CHKPRT
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   UPDATE    PTYHSTF
      *
     C                   ELSE
      *
     C     ACTN          IFEQ      'I'
     C                   Z-ADD     BJRDNB        LCHD(1)
     C                   Z-ADD     APR6CY        EFLD(1)
     C                   MOVE      BR1BRL        LFLG(1)
     C                   ELSE
     C                   EVAL      PTYSQN=BR1SQN
     C                   EVAL      OLDBRT=OLDBR1
     C                   EVAL      NEWBRT=BR1BRL
     C                   EXSR      CHKPRT
     C                   ENDIF
      *
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   WRITE     PTYHSTF
      *
     C                   ENDIF
      *
     C                   ENDIF

     C     BR2NAM        IFNE      *BLANK

     C                   EVAL      PTYSQN=BR2SQN

      ** Access BRT participator history details
     C     PTYKEY        CHAIN     PTYHSTPD                           94

      ** Set PTYHSTPD fields
     C                   EVAL      XRECI=BRRECI
     C                   EVAL      XCNUM=BRCNUM
     C                   EVAL      PTTITL=BR2TIT
     C                   EVAL      PTNAME=BR2NAM
     C                   EVAL      PTINIT=BR2INI
     C                   EVAL      PTADR1=BR2AD1
     C                   EVAL      PTADR2=BR2AD2
     C                   EVAL      PTADR3=BR2AD3
     C                   EVAL      PTPCD1=BR2PC1
     C                   EVAL      PTPCD2=BR2PC2
     C                   EVAL      PTNINO=BR2NIN
     C                   EVAL      PTDOB=BR2DOB
     C                   EVAL      PTYSQN=BR2SQN
     C                   EVAL      LFLAGS=*ZEROS
     C                   EVAL      EFFLDS=*ZEROS
     C                   EVAL      LCHGDS=*BLANKS
     C                   EVAL      XLCD=BRXLCD
     C                   EVAL      XCHTP=BRCHTP
     C                   EVAL      XTNLU=BRTNLU

      *
      * Update or write record in PTYHSTPD
     C     *IN94         IFEQ      '0'
      *
     C                   EVAL      PTYSQN=BR2SQN
     C                   EVAL      OLDBRT=OLDBR2
     C                   EVAL      NEWBRT=BR2BRL
     C                   EXSR      CHKPRT
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   UPDATE    PTYHSTF
      *
     C                   ELSE
      *
     C     ACTN          IFEQ      'I'
     C                   Z-ADD     BJRDNB        LCHD(1)
     C                   Z-ADD     APR6CY        EFLD(1)
     C                   MOVE      BR2BRL        LFLG(1)
     C                   ELSE
     C                   EVAL      PTYSQN=BR2SQN
     C                   EVAL      OLDBRT=OLDBR2
     C                   EVAL      NEWBRT=BR2BRL
     C                   EXSR      CHKPRT
     C                   ENDIF
      *
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   WRITE     PTYHSTF
      *
     C                   ENDIF
      *
     C                   ENDIF

     C     BR3NAM        IFNE      *BLANK

     C                   EVAL      PTYSQN=BR3SQN

      ** Access BRT participator history details
     C     PTYKEY        CHAIN     PTYHSTPD                           94

      ** Set PTYHSTPD fields
     C                   EVAL      XRECI=BRRECI
     C                   EVAL      XCNUM=BRCNUM
     C                   EVAL      PTTITL=BR3TIT
     C                   EVAL      PTNAME=BR3NAM
     C                   EVAL      PTINIT=BR3INI
     C                   EVAL      PTADR1=BR3AD1
     C                   EVAL      PTADR2=BR3AD2
     C                   EVAL      PTADR3=BR3AD3
     C                   EVAL      PTPCD1=BR3PC1
     C                   EVAL      PTPCD2=BR3PC2
     C                   EVAL      PTNINO=BR3NIN
     C                   EVAL      PTDOB=BR3DOB
     C                   EVAL      PTYSQN=BR3SQN
     C                   EVAL      LFLAGS=*ZEROS
     C                   EVAL      EFFLDS=*ZEROS
     C                   EVAL      LCHGDS=*BLANKS
     C                   EVAL      XLCD=BRXLCD
     C                   EVAL      XCHTP=BRCHTP
     C                   EVAL      XTNLU=BRTNLU

      *
      * Update or write record in PTYHSTPD
     C     *IN94         IFEQ      '0'
      *
     C                   EVAL      PTYSQN=BR3SQN
     C                   EVAL      OLDBRT=OLDBR3
     C                   EVAL      NEWBRT=BR3BRL
     C                   EXSR      CHKPRT
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   UPDATE    PTYHSTF
      *
     C                   ELSE
      *
     C     ACTN          IFEQ      'I'
     C                   Z-ADD     BJRDNB        LCHD(1)
     C                   Z-ADD     APR6CY        EFLD(1)
     C                   MOVE      BR3BRL        LFLG(1)
     C                   ELSE
     C                   EVAL      PTYSQN=BR3SQN
     C                   EVAL      OLDBRT=OLDBR3
     C                   EVAL      NEWBRT=BR3BRL
     C                   EXSR      CHKPRT
     C                   ENDIF
      *
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   WRITE     PTYHSTF
      *
     C                   ENDIF
      *
     C                   ENDIF

     C     BR4NAM        IFNE      *BLANK

     C                   EVAL      PTYSQN=BR4SQN

      ** Access BRT participator history details
     C     PTYKEY        CHAIN     PTYHSTPD                           94

      ** Set PTYHSTPD fields
     C                   EVAL      XRECI=BRRECI
     C                   EVAL      XCNUM=BRCNUM
     C                   EVAL      PTTITL=BR4TIT
     C                   EVAL      PTNAME=BR4NAM
     C                   EVAL      PTINIT=BR4INI
     C                   EVAL      PTADR1=BR4AD1
     C                   EVAL      PTADR2=BR4AD2
     C                   EVAL      PTADR3=BR4AD3
     C                   EVAL      PTPCD1=BR4PC1
     C                   EVAL      PTPCD2=BR4PC2
     C                   EVAL      PTNINO=BR4NIN
     C                   EVAL      PTDOB=BR4DOB
     C                   EVAL      PTYSQN=BR4SQN
     C                   EVAL      LFLAGS=*ZEROS
     C                   EVAL      EFFLDS=*ZEROS
     C                   EVAL      LCHGDS=*BLANKS
     C                   EVAL      XLCD=BRXLCD
     C                   EVAL      XCHTP=BRCHTP
     C                   EVAL      XTNLU=BRTNLU

      *
      * Update or write record in PTYHSTPD
     C     *IN94         IFEQ      '0'
      *
     C                   EVAL      PTYSQN=BR4SQN
     C                   EVAL      OLDBRT=OLDBR4
     C                   EVAL      NEWBRT=BR4BRL
     C                   EXSR      CHKPRT
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   UPDATE    PTYHSTF
      *
     C                   ELSE
      *
     C     ACTN          IFEQ      'I'
     C                   Z-ADD     BJRDNB        LCHD(1)
     C                   Z-ADD     APR6CY        EFLD(1)
     C                   MOVE      BR4BRL        LFLG(1)
     C                   ELSE
     C                   EVAL      PTYSQN=BR4SQN
     C                   EVAL      OLDBRT=OLDBR4
     C                   EVAL      NEWBRT=BR4BRL
     C                   EXSR      CHKPRT
     C                   ENDIF
      *
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   WRITE     PTYHSTF
      *
     C                   ENDIF
      *
     C                   ENDIF

     C     BR5NAM        IFNE      *BLANK

     C                   EVAL      PTYSQN=BR5SQN

      ** Access BRT participator history details
     C     PTYKEY        CHAIN     PTYHSTPD                           94

      ** Set PTYHSTPD fields
     C                   EVAL      XRECI=BRRECI
     C                   EVAL      XCNUM=BRCNUM
     C                   EVAL      PTTITL=BR5TIT
     C                   EVAL      PTNAME=BR5NAM
     C                   EVAL      PTINIT=BR5INI
     C                   EVAL      PTADR1=BR5AD1
     C                   EVAL      PTADR2=BR5AD2
     C                   EVAL      PTADR3=BR5AD3
     C                   EVAL      PTPCD1=BR5PC1
     C                   EVAL      PTPCD2=BR5PC2
     C                   EVAL      PTNINO=BR5NIN
     C                   EVAL      PTDOB=BR5DOB
     C                   EVAL      PTYSQN=BR5SQN
     C                   EVAL      LFLAGS=*ZEROS
     C                   EVAL      EFFLDS=*ZEROS
     C                   EVAL      LCHGDS=*BLANKS
     C                   EVAL      XLCD=BRXLCD
     C                   EVAL      XCHTP=BRCHTP
     C                   EVAL      XTNLU=BRTNLU

      *
      * Update or write record in PTYHSTPD
     C     *IN94         IFEQ      '0'
      *
     C                   EVAL      PTYSQN=BR5SQN
     C                   EVAL      OLDBRT=OLDBR5
     C                   EVAL      NEWBRT=BR5BRL
     C                   EXSR      CHKPRT
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   UPDATE    PTYHSTF
      *
     C                   ELSE
      *
     C     ACTN          IFEQ      'I'
     C                   Z-ADD     BJRDNB        LCHD(1)
     C                   Z-ADD     APR6CY        EFLD(1)
     C                   MOVE      BR5BRL        LFLG(1)
     C                   ELSE
     C                   EVAL      PTYSQN=BR5SQN
     C                   EVAL      OLDBRT=OLDBR5
     C                   EVAL      NEWBRT=BR5BRL
     C                   EXSR      CHKPRT
     C                   ENDIF
      *
     C                   MOVEA     LFLG          LFLAGS
     C                   MOVE      EFFLDA        EFFLDS
     C                   MOVE      LCHGDA        LCHGDS
      *
     C                   WRITE     PTYHSTF
      *
     C                   ENDIF
      *
     C                   ENDIF

      *
     C     EndUPDBRT     ENDSR
     C****************************************************************
      /EJECT
      ********************************************************************                   BUG3362
      *                                                                  *                   BUG3362
      * UPDTID - Update TI Customer Details if CSD012 is 'Y'             *                   BUG3362
      *                                                                  *                   BUG3362
      ********************************************************************                   BUG3362
     C     UPDTID        BEGSR                                                               BUG3362
      *                                                                                      BUG3362
      ** Access TI Customer Details File                                                     BUG3362
      *                                                                                      BUG3362
     C     BGN3ST        IFEQ      'Y'                                                       BUG3362
     C     BBTICS        ANDEQ     'Y'                                                       BUG3362
     C     BGN3ST        OREQ      'Y'                                                       BUG3362
     C     WBBTICS       ANDEQ     'D'                                                       BUG3362
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     BBTICS        ANDEQ     'Y'                                                      MD030956
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     WBBTICS       ANDEQ     'D'                                                      MD030956
     C     A_TCCFXC      IFNE      *BLANKS                                                   BG12238
     C     A_TCETIT      ORNE      *BLANKS                                                   BG12238
     C     A_TCPFXC      ORNE      *BLANKS                                                   BG12238
     C     A_TCSALU      ORNE      *BLANKS                                                   BG12238
     C     A_TCTELX      ORNE      *BLANKS                                                   BG12238
     C     A_TCTXAB      ORNE      *BLANKS                                                   BG12238
     C     A_TCFXNO      ORNE      *BLANKS                                                   BG12238
     C     A_TCZPCD      ORNE      *BLANKS                                                   BG12238
     C     A_TCTRFM      ORNE      *BLANKS                                                   BG12238
     C     A_TCDLNG      ORNE      *BLANKS                                                   BG12238
     C     A_TCANAL      ORNE      *BLANKS                                                   BG12238
     C     A_TCMLBR      ORNE      *BLANKS                                                   BG12238
     C                   IF        CSD028 = 'Y' AND PTransType = 'AUTH'                       CSD028
     C     BBCUST        CHAIN     SDTDSHL0                           95                      CSD028
     C                   ELSE                                                                 CSD028
     C     BBCUST        CHAIN     SDTICSL0                           95                     BUG3362
     C                   ENDIF                                                                CSD028
      *                                                                                      BUG3362
      * Check if INSERT or AMEND                                                             BG12238
      *                                                                                      BG12238
     C     A_TCTYLC      IFNE      'D'                                                       BG12238
     C     *IN95         IFEQ      '1'                                                       BG12238
     C                   MOVEL     'I'           A_TCTYLC                                    BG12238
     C                   ELSE                                                                BG12238
      *                                                                                      BG12238
     C                   MOVEL     'A'           A_TCTYLC                                    BG12238
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                               BG12238
      ***Database Error If INSERT, but record present already                        BUG3362 BG12238
      **********                                                                     BUG3362 BG12238
     C*****A_CUTYLC      IFEQ      'I'                                               BUG3362 BG12238
     C******IN95         ANDEQ     '0'                                               BUG3362 BG12238
     C**********         MOVEL     BBCUST        DBKEY                               BUG3362 BG12238
     C**********         MOVEL     'SDTICSPD'    DBFILE                 ************ BUG3362 BG12238
     C**********         MOVEL     '023'         DBASE                  * DBERR 023* BUG3362 BG12238
     C**********         EXSR      SRERR                                ************ BUG3362 BG12238
     C**********         ELSE                                                        BUG3362 BG12238
      *                                                                                      BUG3362
      ** if valid                                                                            BUG3362
      *                                                                                      BUG3362
     C     TCFLAG        IFEQ      'Y'                                                       BUG3362
     C                   MOVEL     'N'           TCFLAG                                      BUG3362
     C                   ELSE                                                                BUG3362
     C                   MOVEL     'Y'           TCFLAG                                      BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
      ** move values from SDVTID to fields of SDTICSL0                                       BUG3362
      *                                                                                      BUG3362
     C                   EVAL      TCCUST =A_TCCUST                                          BUG3362
     C                   EVAL      TCCFXC =A_TCCFXC                                          BUG3362
     C                   EVAL      TCPFXC =A_TCPFXC                                          BUG3362
     C                   EVAL      TCETIT =A_TCETIT                                          BUG3362
     C                   EVAL      TCSALU =A_TCSALU                                          BUG3362
     C                   EVAL      TCTELX =A_TCTELX                                          BUG3362
     C                   EVAL      TCTXAB =A_TCTXAB                                          BUG3362
     C                   EVAL      TCFXNO =A_TCFXNO                                          BUG3362
     C                   EVAL      TCZPCD =A_TCZPCD                                          BUG3362
     C                   EVAL      TCTRFM =A_TCTRFM                                          BUG3362
     C                   EVAL      TCDLNG =A_TCDLNG                                          BUG3362
     C                   EVAL      TCANAL =A_TCANAL                                          BUG3362
     C                   EVAL      TCMLBR =A_TCMLBR                                          BUG3362
     C                   EVAL      TCTYLC =A_TCTYLC                                          BUG3362
      *                                                                                      BUG3362
      ** initialise A_TCLCD when WBBTICS = D, i.e. no details to amend on                    BUG3362
      ** PF/SDTICSPD to avoid db problem on decimal data error                               BUG3362
      *                                                                                      BUG3362
     C     WBBTICS       IFEQ      'D'                                                       BUG3362
     C     WBBTICS       OREQ      ' '                                                       BUG4810
     C                   EVAL      A_TCLCD=0                                                 BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   EVAL      TCLCD  =A_TCLCD                                           BUG3362
     C                   EVAL      TCCSSN =A_TCCSSN                                          BUG3362
     C                   EVAL      TCFLAG =A_TCFLAG                                          BUG3362
      *                                                                                      BUG3362
      ** Check appropriate action on file SDTICSL0                                           BUG3362
      *                                                                                      BUG3362
     C*****A_CUTYLC      IFEQ      'I'                                               BUG3362 BG12238
     C*****A_CUTYLC      OREQ      'A'                                               BUG3362 BG12238
     C******IN95         ANDEQ     '1'                                               BUG3362 BG12238
     C     A_TCTYLC      IFEQ      'I'                                                       BG12238
      *                                                                                      BUG3362
      ** to ensure that error will not occur when SDVTID is blank(coming from APTRANVU)      BUG3362
      *                                                                                      BUG3362
     C     TCCUST        IFNE      *BLANKS                                                   BUG3362
      *                                                                                      BUG3362
     C                   WRITE     @TICSL0                                                   BUG3362
      *                                                                                      BUG3362
     C**********         Z-ADD     *ZERO         WUNORC                              BUG3362 BUG4201
     C                   Z-ADD     1             WUNORC                                      BUG4201
     C                   Z-ADD     *ZERO         WUNOAM                                      BUG3362
     C                   Z-ADD     1             WUNOIN                                      BUG3362
     C                   Z-ADD     *ZERO         WUNODL                                      BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ELSE                                                                BUG3362
      *                                                                                      BUG3362
     C*****A_CUTYLC      IFEQ      'A'                                               BUG3362 BG12238
     C     A_TCTYLC      IFEQ      'A'                                                       BG12238
     C     BBTICS        ANDEQ     'Y'                                                       BUG3362
     C******IN95         ANDEQ     '0'                                               BUG3362 BG12238
      *                                                                                      BUG3362
     C     TCCUST        IFNE      *BLANKS                                                   BUG3362
     C                   UPDATE    @TICSL0                                                   BUG3362
      *                                                                                      BUG3362
      ** USER: Processing after Data update                                                  BUG3362
      *                                                                                      BUG3362
     C                   Z-ADD     *ZERO         WUNORC                                      BUG3362
     C                   Z-ADD     1             WUNOAM                                      BUG3362
     C                   Z-ADD     *ZERO         WUNOIN                                      BUG3362
     C                   Z-ADD     *ZERO         WUNODL                                      BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ELSE                                                                BUG3362
      *                                                                                      BUG3362
      ** Delete action or WBBTICS = 'D'                                                      BUG3362
      *                                                                                      BUG3362
     C*****A_CUTYLC      IFEQ      'D'                                               BUG3362 BG12238
     C     A_TCTYLC      IFEQ      'D'                                                       BG12238
     C     BBTICS        ANDNE     'D'                                                       BUG3362
     C*****A_CUTYLC      OREQ      'A'                                               BUG3362 BG12238
     C     A_TCTYLC      OREQ      'A'                                                       BG12238
     C     WBBTICS       ANDEQ     'D'                                                       BUG3362
      *                                                                                      BUG3362
     C                   DELETE    @TICSL0                                                   BUG3362
      * USER: Processing after Data update                                                   BUG3362
     C                   MOVEL     SDTICDF       WUDELR                                      BUG3362
      * Write Deleted Record - SD Deleted Records File  *                                    BUG3362
     C                   CLEAR                   PBRC                                        BUG3362
     C                   MOVEL     'SDTICDPD'    PBFNME                                      BUG3362
     C                   MOVEL     A_TCCUST      PBLKEY                                      BUG3362
     C                   MOVEL     WUDR01        PBDR01                                      BUG3362
     C                   MOVEL     WUDR02        PBDR02                                      BUG3362
     C                   MOVEL     WUDR03        PBDR03                                      BUG3362
     C                   MOVEL     WUDR04        PBDR04                                      BUG3362
     C                   MOVEL     WUDR05        PBDR05                                      BUG3362
     C                   MOVEL     WUDR06        PBDR06                                      BUG3362
     C                   MOVEL     WUDR07        PBDR07                                      BUG3362
     C                   MOVEL     WUDR08        PBDR08                                      BUG3362
     C                   MOVEL     WUDR09        PBDR09                                      BUG3362
     C                   MOVEL     WUDR10        PBDR10                                      BUG3362
     C                   MOVEL     WUDR11        PBDR11                                      BUG3362
     C                   MOVEL     WUDR12        PBDR12                                      BUG3362
     C                   MOVEL     BJRDNB        PBLCD                                       BUG3362
     C                   MOVEL     'D'           PBTYLC                                      BUG3362
                                                                                             BUG3362
     C                   CALL      'SD0520X'                                                 BUG3362
     C                   PARM      *BLANK        @RTCD                                       BUG3362
     C                   PARM                    PBRC                                        BUG3362
      * Error detected?                                                                      BUG3362
     C     @RTCD         IFEQ      '*ERROR*'                                                 BUG3362
     C                   MOVEL     *BLANK        DBKEY                                       BUG3362
     C                   MOVEL     A_TCCUST      DBKEY                                       BUG3362
     C                   MOVEL     'SDDELRL0'    DBFILE                         ************ BUG3362
     C                   MOVEL     '014'         DBASE                          * DBERR 014* BUG3362
     C                   EXSR      SRERR                                        ************ BUG3362
     C                   END                                                                 BUG3362
                                                                                             BUG3362
     C                   Z-ADD     -1            WUNORC                         No of recordsBUG3362
     C                   Z-ADD     *ZERO         WUNOAM                         No of Amend  BUG3362
     C                   Z-ADD     *ZERO         WUNOIN                         No of delete BUG3362
     C                   Z-ADD     1             WUNODL                         No of Insert BUG3362
      * Change Standing Data Cont - Standing Data Controls  *                                BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
      * Change Standing Data Cont - Standing Data Controls  *                                BUG3362
     C                   MOVEL     'SDTICSPD'    WFLNAME                                     BUG3362
     C                   EXSR      SNCHRC                                                    BUG3362
     C**********         ENDIF                                                       BUG3362 BG12238
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   ENDSR                                                               BUG3362
      *                                                                                      BUG3362
      *****************************************************************
      * CHKPRT - Check Particpator History File and Update According'y*
      *****************************************************************
     C     CHKPRT        BEGSR
     C
     C     INTKEY        KLIST
     C                   KFLD                    XCNUM
     C                   KFLD                    KDATE             5 0
     C
     C**  IF THE BRT LIABLE FLAG HAS CHANGED CALCULATE THE DATE
     C**  FROM WHICH THE NEW VALUE IS TO BE EFFECTIVE.
     C**
     C     OLDBRT        IFNE      NEWBRT
     C                   EXSR      BRTFL
     C**
     C**  IF THE EFFECTIVE DATE IS THE SAME AS AN EXISTING DATE
     C**  IN THE EFFECTIVE DATE ARRAY.
     C**
     C                   Z-ADD     1             Z                 2 0
     C     EFF           LOOKUP    EFLD(Z)                                89
     C**
     C     *IN89         IFEQ      '1'
     C**
     C**  CHECK IF ANY INTEREST PAYMENTS HAVE BEEN MADE BETWEEN THE
     C**  EFFECTIVE DATE AND TODAY'S DATE.
     C**
     C                   Z-ADD     EFF           KDATE
     C     INTKEY        SETLL     INTPSLF6
     C                   READ      INTPSLF6                               89
     C**
     C     *IN89         IFEQ      '0'
     C     XCNUM         ANDEQ     A_CNUM
     C     A_IPDT        ANDLT     BJRDNB
     C     A_IPDT        ANDGE     EFF
     C**
     C**  IF PAYMENTS MADE THE NEXT AVAILABLE ARRAY ELEMENTS ARE
     C**  UPDATED WITH THE NEW DATA.
     C**
     C                   Z-ADD     1             W                 2 0
     C     *BLANKS       LOOKUP    LFLG(W)                                89
     C**
     C                   MOVEA     NEWBRT        LFLG(W)
     C                   Z-ADD     EFF           EFLD(W)
     C                   Z-ADD     BJRDNB        LCHD(W)
     C**
     C**  IF NO PAYMENTS HAVE BEEN MADE THEN THE CURRENT ELEMENT
     C**  IS OVERWRITTEN AND ALL SUBSEQUENT ELEMENTS ARE CLEARED.
     C**
     C                   ELSE
     C                   MOVEA     NEWBRT        LFLG(Z)
     C                   Z-ADD     EFF           EFLD(Z)
     C                   Z-ADD     BJRDNB        LCHD(Z)
     C**
     C     Z             DOUEQ     10
     C                   ADD       1             Z
     C                   MOVEA     *BLANKS       LFLG(Z)
     C                   Z-ADD     *ZEROS        EFLD(Z)
     C                   Z-ADD     *ZEROS        LCHD(Z)
     C                   END
     C**
     C                   END
     C**
     C**  IF EFFECTIVE DATE DOES NOT MATCH AN EXISTING EFFECTIVE DATE
     C**  UPDATE THE NEXT ARRAY ELEMENTS WITH THE NEW DATA.
     C**
     C                   ELSE
     C                   Z-ADD     1             W
     C     *BLANKS       LOOKUP    LFLG(W)                                89
     C**
     C                   MOVEA     NEWBRT        LFLG(W)
     C                   Z-ADD     EFF           EFLD(W)
     C                   Z-ADD     BJRDNB        LCHD(W)
     C                   END
      *
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *   BRTFL - TO CALCULATE THE EFFECTIVE DATE DEPENDING           *
      *           ON THE BRT LIABLE FLAG FOR THE PARTICIPANT.         *
      *****************************************************************
     C     BRTFL         BEGSR

     C**  SET DEFAULT EFFECTIVE DATE TO APRIL 6TH OF CURRENT TAX YEAR
     C**
     C                   Z-ADD     APR6CY        EFF               5 0
     C**
     C**  IF THE BRT IS 'N' AND A S352 STATEMENT HAS BEEN PRODUCED
     C**  EFFECTIVE DATE WILL BE SET TO THE LAST INTEREST DATE
     C**  PAYMENT ON THE INTEREST PAYMENT HISTORY FILE.
     C**
     C     NEWBRT        IFEQ      'N'
     C                   Z-ADD     99999         KDATE
     C     INTKEY        SETGT     INTPSLF7
     C                   READP     INTPSLF7                               89
     C**
     C     *IN89         IFEQ      '0'
     C     XCNUM         ANDEQ     B_CNUM
     C**
     C                   Z-ADD     B_IPDT        EFF
     C**
     C**  IF NO S352 STATEMENT HAS BEEN PRODUCED THE EFFECTIVE DATE
     C**  WILL BE SET TO APRIL 6TH OF THE CURRENT TAX YEAR.
     C**
     C                   ELSE
     C                   Z-ADD     APR6CY        EFF
     C                   Z-ADD     00000         KDATE
     C     INTKEY        SETLL     INTPSLF8
     C                   READ      INTPSLF8                               89
     C**
     C     *IN89         IFEQ      '0'
     C     XCNUM         ANDEQ     C_CNUM
     C                   Z-ADD     APR6CY        EFF
     C**
     C**  IF ANY INTEREST PAYMENTS HAVE BEEN MADE IN THE CURRENT TAX
     C**  YEAR, SEND MESSAGE 'INTEREST ADJUSTMENT ....'
     C**
     C     C_IPDT        IFGE      APR6CY
     C                   MOVEL     'Y'           INADJR            1
     C                   END
     C**
     C                   END
     C**
     C                   END
     C**
     C**  IF THE BRT IS 'Y' OR 'X' THE EFFECTIVE DATE WILL BE SET TO
     C**  THE LAST INTEREST PAYMENT DATE ON THE INTEREST PAYMENT
     C**  HISTORY FILE. IF THERE HAVE BEEN NO INTEREST PAYMENTS
     C**  FOR THIS ACCOUNT IN THE CURRENT TAX YEAR THE EFFECTIVE
     C**  DATE WILL BE SET TO APRIL 6TH OF THE CURRENT TAX YEAR.
     C**
     C                   ELSE
     C                   Z-ADD     99999         KDATE
     C     INTKEY        SETGT     INTPSLF6
     C                   READP     INTPSLF6                               89
     C**
     C     *IN89         IFEQ      '0'
     C     XCNUM         ANDEQ     A_CNUM
     C                   Z-ADD     A_IPDT        EFF
     C                   ELSE
     C                   Z-ADD     APR6CY        EFF
     C                   END
     C**
     C                   END
     C**

     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * UPDPRB - UPDATE PRIVATE BANKING DETAILS IF BGN4ST = 'Y'          *
      *                                                                  *
      ********************************************************************
     C     UPDPRB        BEGSR

     C     ACTN          IFEQ      'D'
     C                   MOVE      'C'           A_PBRECI
     C                   ELSE
     C                   MOVE      'D'           A_PBRECI
     C                   ENDIF
     C                   MOVE      BJRDNB        A_PBLCHD
     C                   MOVE      ACTN          A_PBCHTP
     C                   MOVE      A_CUCUST      A_PBCNUM

      ** ACCESS PRIVATE BANKING CUSTOMER DETAILS

     C     A_PBCNUM      CHAIN     SDPBDSL0                           98

      ** DATABASE ERROR
      ** IF INSERT, BUT RECORD PRESENT ALREADY
      ** OR IF NOT INSERT, BUT NO RECORD FOUND

      ** Skip validation if the customer came from the acceptance file.                       CSD031
                                                                                              CSD031
     C**********         IF        PAccMde <> 'A'                                    CSD031 BUG13525
     C     A_PBCHTP      IFEQ      'I'
     C     *IN98         ANDEQ     '0'
     C     A_PBCHTP      ORNE      'I'
     C     *IN98         ANDEQ     '1'
     C                   MOVEL     A_PBCNUM      DBKEY
     C                   MOVEL     'SDPBDSL0'    DBFILE                         ************
     C                   MOVEL     '020'         DBASE                          * DBERR 020*
     C                   EXSR      SRERR                                        ************
     C                   END
     C**********         ENDIF                                                       CSD031 BUG13525

      ** Update with details from valid Private Banking record

      ** SET SDPBDSPD FIELDS

     C                   EVAL      D_PBCNUM = A_PBCNUM
     C                   EVAL      D_PBRECI = A_PBRECI
     C                   EVAL      D_PBHOLD = A_PBHOLD
     C                   EVAL      D_PBNUAC = A_PBNUAC
     C                   EVAL      D_PBAGEN = A_PBAGEN
     C                   EVAL      D_PBCOUN = A_PBCOUN
     C                   EVAL      D_PBREPB = A_PBREPB
     C                   EVAL      D_PBPBST = A_PBPBST
     C                   EVAL      D_PBLCHD = A_PBLCHD
     C                   EVAL      D_PBCHTP = A_PBCHTP
                                                                                185595
      ***Set*timestamp*if*change*of branch*****************************                185595 202931
      ** Set timestamp                                                                        202931
                                                                                185595
     C***20*****         EVAL      D_PBTMES = BBTMST                                   185595 202931
     C                   EVAL      D_PBTMES = BBTMST                                          202931

     C                   EVAL      D_PBFRNT = A_PBFRNT                                      AR971184
     C                   EVAL      D_PBAFRT = A_PBAFRT                                      AR971184
     C                   EVAL      D_PBAFRT = A_PBAFRT                                      AR971184
                                                                                            AR971184
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        A_PBFRNT = *BLANKS                                         CSC011
     C                   EVAL      D_PBFRNT = BBFRNT                                          CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *
      * Update or write record in SDPBDSPD
      *
     C     *IN98         IFEQ      '1'
     C                   WRITE     SDPBDSD0
     C                   ELSE
     C                   UPDATE    SDPBDSD0
     C                   ENDIF

      *
     C     EndUPDPRB     ENDSR
     C****************************************************************
      /EJECT                                                                                  CGP001
      ********************************************************************                    CGP001
      *                                                                  *                    CGP001
      * SRUpdGlbID -  Update Global ID X-Reference if CGP001 = 'Y'       *                    CGP001
      *                                                                  *                    CGP001
      ********************************************************************                    CGP001
     C     SRUpdGlbID    BEGSR                                                                CGP001
                                                                                              CGP001
      ** Chain GPCUSTXL0                                                                      CGP001
                                                                                              CGP001
     C                   EVAL      K_BRCD = A_CUBRCD                                         BUG2313
     C                   EVAL      K_CUST = A_CUCUST                                         BUG2313
     C     KGlbKey       CHAIN     GPCUSTXL0                          98                      CGP001
                                                                                              CGP001
      ** Check if Global Customer is blanks                                                   CGP001
                                                                                              CGP001
     C                   IF        V_DDGCUS = *BLANKS                                         CGP001
                                                                                              CGP001
     C                   IF        *IN98 = *OFF                                               CGP001
     C                   DELETE    GPCUSTXD0                                                  CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   ELSE                                                                 CGP001
                                                                                              CGP001
     C                   IF        *IN98 = *ON                                                CGP001
                                                                                              CGP001
      ** if no record found write a new record                                                CGP001
                                                                                              CGP001
     C                   EVAL      G_CUBRCD = A_CUBRCD                                        CGP001
     C                   EVAL      G_CUCUST = A_CUCUST                                        CGP001
     C                   EVAL      G_CUGCUS = V_DDGCUS                                        CGP001
     C                   WRITE     GPCUSTXD0                                                  CGP001
     C                   ELSE                                                                 CGP001
                                                                                              CGP001
      ** if record found update record                                                        CGP001
                                                                                              CGP001
     C                   EVAL      G_CUBRCD = A_CUBRCD                                        CGP001
     C                   EVAL      G_CUCUST = A_CUCUST                                        CGP001
     C                   EVAL      G_CUGCUS = V_DDGCUS                                        CGP001
     C                   UPDATE    GPCUSTXD0                                                  CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   ENDSR                                                                CGP001
      ****************************************************************                        CGP001
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *                                                                                       CSD012
      * Override SDCDSHL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD1                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override SDCBSHL0                                                                     CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD2                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override SDPBSHL0                                                                     CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD3                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override SDTDSHL0                                                                    BUG3362
     C                   CALL      'QCMDEXC'                                                 BUG3362
     C                   PARM                    CMD4                                        BUG3362
     C                   PARM                    CMDLEN                                      BUG3362
      * Override SDSWSHL0                                                                   BUG14969
     C                   CALL      'QCMDEXC'                                                BUG14969
     C                   PARM                    CMD5                                       BUG14969
     C                   PARM                    CMDLEN                                     BUG14969
      * Override SDCUSXL0                                                                     CGL132
     C                   Z-ADD     50            CMDLEN                                       CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    CMDXC                                        CGL132
     C                   PARM                    CMDLEN           15 5                        CGL132
      * Override SDFTNHL0                                                                   MD027115
     C                   CALL      'QCMDEXC'                                                MD027115
     C                   PARM                    CMDNH                                      MD027115
     C                   PARM                    CMDLEN                                     MD027115
      * Override SDFTCSL0                                                                   MD027115
     C                   CALL      'QCMDEXC'                                                MD027115
     C                   PARM                    CMDCS                                      MD027115
     C                   PARM                    CMDLEN                                     MD027115
      ** Override SDCRSHL1                                                                  MD051230
     C                   CALL      'QCMDEXC'                                                MD051230
     C                   PARM                    CMDCR                                      MD051230
     C                   PARM                    CMDLEN                                     MD051230
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    SDVCUSD
     C                   PARM                    SDVCUXC                                      CGL132
     C                   PARM                    SDVCUBR
     C                   PARM                    SDVCUPB
     C                   PARM                    SDVTID                                      BUG3362
     C                   PARM                    SDVSWSD                                      CSW207
     C                   PARM                    SDVSW13                                      CFT050
     C                   PARM                    SDVCUMI                                      CSD079
     C                   PARM                    SDVCUAD                                      CSD079
     C                   PARM                    SDVCUFE                                      CSD079
     C                   PARM                    SDVCUCQ                                      CSD079
     C                   PARM                    SDVCUSF                                      CSD079
     C                   PARM                    SDVCURW                                      CSD079
     C                   PARM                    SDVCUFO                                      CSD079
     C                   PARM                    SDVCUFF                                      CSD079
     C                   PARM                    SDVCUPM                                      CSD079
     C                   PARM                    SDVCUEU                                      CSD079
     C                   PARM                    SDVCUIB                                      CSD079
     C**********         PARM                    SDVFTCS                             CGL132 MD026755
     C                   PARM                    SDVCTNM                                   AR1086546
     C                   PARM                    SDVFTCS                                    MD026755
      ** Externally described DS for CRS valid Transaction Detail                             CGL157
     C                   PARM                    SDVCRSH                                      CGL157
     C                   PARM                    PCrsdF                                       CGL157
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
     C                   PARM                    V_DDGCUS         10                          CGP001
     C                   PARM                    S01383            1
     C                   PARM                    CSW024            1                          CSW024
     C                   PARM                    CGP001            1                          CGP001
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      * Transaction Type                                                                      CSD028
     C                   PARM                    PTransType                                   CSD028
     C                   PARM                    DACTN             1                          CSD028
     C                   PARM                    CTI006            1                        MD030956
     C                   PARM                    SDVTransUser                               MD055373
     C                   PARM                    SDAAUTH                                    MD055373
      ** Acceptance Mode                                                                      CSD031
     C**********         PARM                    PAccMde                             CSD031 BUG13525
      ** Update (Y/N)                                                                         CSD031
     C**********         PARM                    PUpdYN                              CSD031 BUG13525
     C/COPY WNCPYSRC,SDCUSDDC08
                                                                                              CGL132
     C     KACRV         KLIST                                                                CGL132
     C                   KFLD                    KCUST                                        CGL132
     C                   KFLD                    KSCDT                                        CGL132
     C                   KFLD                    KSEQN                                        CGL132
                                                                                              CGL157
     C     KCRSD         KLIST                                                                CGL157
     C                   KFLD                    KCUST                                        CGL157
     C                   KFLD                    KCTRY                                        CGL157
                                                                                              CSD079
      ** Get Rundate - Rundate                                                                CSD079
                                                                                              CSD079
     C     *DTAARA       DEFINE                  RUNDAT                                       CSD079
     C                   IN        RUNDAT                                                     CSD079
      **********                                                                   MD026835 MD027492
      ***Retrieve ZMUSER details.                                                  MD026835 MD027492
     C******DTAARA       DEFINE                  ZMUSER                            MD026835 MD027492
     C**********         IN        ZMUSER                                          MD026835 MD027492
      **********                                                                   MD026835 MD027492
     C**********         IF        PSUSER = 'QUSER'                                MD026835 MD027492
     C**********         EVAL      WKUSER = WUSRID                                 MD026835 MD027492
     C**********         ELSE                                                      MD026835 MD027492
     C**********         EVAL      WKUSER = PSUSER                                 MD026835 MD027492
     C**********         ENDIF                                                     MD026835 MD027492
      **********                                                                   MD026835 MD027492
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   ELSE                                                                 CSD079
     C                   MOVEL     BJMRDT        WUMRDT                                       CSD079
     C                   MOVEL     BJRDNB        WURDNB                                       CSD079
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
     C/COPY WNCPYSRC,SDCUSDDC05
      ** ACCESS SECURITIES TRADING DETAILS
      ** (If module present)                                                                  202380
      *
     C     BGSECS        IFEQ      'Y'                                                        202380
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C                   ENDIF                                                                202380
     C/COPY WNCPYSRC,SDCUSDDC11
      *
      ** ACCESS PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDPORT        PARM      SDPORT        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      SRERR                                        *************
     C                   END
                                                                                              CSD079
      ** Portfolios Supported is Customer                                                     CSD079
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
     C                   END
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CGL132
      ** Check if CGL132 is installed                                                         CGL132
                                                                                              CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtCd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C                   IF        (Prtcd <> *BLANKS) and                                     CGL132
     C                             (Prtcd <> '*NRF   ')                                       CGL132
     C                   EVAL      DBKEY = 'CGL132'                                           CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBASE = 906                                                CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PRtCd = *BLANKS                                            CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if CGL133 is installed                                                         CGL132
                                                                                              CGL132
     C                   EVAL      CGL133 = 'N'                                               CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtCd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL133'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C                   IF        (Prtcd <> *BLANKS) and                                     CGL132
     C                             (Prtcd <> '*NRF   ')                                       CGL132
     C                   EVAL      DBKEY = 'CGL133'                                           CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBASE = 914                                                CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PRtCd = *BLANKS                                            CGL132
     C                   EVAL      CGL133 = 'Y'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL157
      ** Check if CGL157 is installed                                                         CGL157
                                                                                              CGL157
     C                   EVAL      CGL157 = 'N'                                               CGL157
                                                                                              CGL157
     C                   CALLB     'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       PRtCd                                        CGL157
     C                   PARM      '*VERIFY'     POptn                                        CGL157
     C                   PARM      'CGL157'      PSard                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
      ** Database error                                                                       CGL157
                                                                                              CGL157
     C                   IF        (Prtcd <> *BLANKS) and                                     CGL157
     C                             (Prtcd <> '*NRF   ')                                       CGL157
     C                   EVAL      DBKEY = 'CGL157'                                           CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBASE = 918                                                CGL157
     C                   EXSR      SRERR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        PRtCd = *BLANKS                                            CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD021
      ** Check if CSD021 is installed                                                         CSD021
                                                                                              CSD021
     C                   EVAL      CSD021 = 'N'                                               CSD021
                                                                                              CSD021
     C                   CALLB     'AOSARDR0'                                                 CSD021
     C                   PARM      *BLANKS       PRtCd                                        CSD021
     C                   PARM      '*VERIFY'     POptn                                        CSD021
     C                   PARM      'CSD021'      PSard                                        CSD021
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
                                                                                              CSD021
      ** Database error                                                                       CSD021
                                                                                              CSD021
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD021
     C                             (PRtCd <> '*NRF   ')                                       CSD021
     C                   EVAL      DBKEY = 'CSD021'                                           CSD021
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD021
     C                   EVAL      DBASE = 910                                                CSD021
     C                   EXSR      SRERR                                                      CSD021
     C                   ENDIF                                                                CSD021
                                                                                              CSD021
     C                   IF        PRtCd = *BLANKS                                            CSD021
     C                   EVAL      CSD021 = 'Y'                                               CSD021
     C******DTAARA***    DEFINE                  CNLU              6 0                 CSD021 CSD027
     C     *DTAARA       DEFINE                  CNLU              6                          CSD027
     C                   ENDIF                                                                CSD021
                                                                                              CSD090
      ** Check if CSD090 is installed                                                         CSD090
                                                                                              CSD090
     C                   EVAL      CSD090 = 'N'                                               CSD090
                                                                                              CSD090
     C                   CALLB     'AOSARDR0'                                                 CSD090
     C                   PARM      *BLANKS       PRtCd                                        CSD090
     C                   PARM      '*VERIFY'     POptn                                        CSD090
     C                   PARM      'CSD090'      PSard                                        CSD090
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD090
                                                                                              CSD090
      ** Database error                                                                       CSD090
                                                                                              CSD090
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD090
     C                             (PRtCd <> '*NRF   ')                                       CSD090
     C                   EVAL      DBKEY = 'CSD090'                                           CSD090
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD090
     C                   EVAL      DBASE = 927                                                CSD090
     C                   EXSR      SRERR                                                      CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
     C                   IF        PRtCd = *BLANKS                                            CSD090
     C                   EVAL      CSD090 = 'Y'                                               CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
      *
      ** Open files
      *
      *    Base Rate Tax files
     C     S01383        IFEQ      'Y'
     C                   OPEN      SDCBRTL1
     C                   OPEN      PTYHSTPD
     C                   END
      *    Trade Innovation file
     C     BGN3ST        IFEQ      'Y'
     C     CTI006        OREQ      'Y'                                                      MD030956
     C                   OPEN      SDTICSL0
     C                   END
      *
     C**   ROUTINE TO CALCULATE DAY NUMBER OF APRIL 6TH FOR CURRENT TAX YEAR
     C*
     C                   MOVE      '0'           *IN98
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEB        DATE
     C**
     C     MONTH         IFLT      4
     C     MONTH         OREQ      4
     C     DAY           ANDLT     6
     C                   SUB       1             YEAR
     C                   END
     C**
     C                   MOVE      '06'          TDAY
     C                   MOVE      '04'          TMONTH
     C                   MOVE      YEAR          TYEAR
     C**
     C                   MOVE      TDATE         ZDATEA
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        APR6CY            5 0
     C*
     C*******************EVAL      K_BRCD = A_CUBRCD                                  CGP001 BUG2313
     C*******************EVAL      K_CUST = A_CUCUST                                  CGP001 BUG2313
     C     KGlbKey       KLIST                                                                CGP001
     C                   KFLD                    K_BRCD                                       CGP001
     C                   KFLD                    K_CUST                                       CGP001
                                                                                              CGP001
     C/COPY WNCPYSRC,SDCUSDDC02
                                                                                              CSD015
      ** Check if CSD015 is installed                                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 906                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If Enhancement CSD015 is installed, access SDWLCCPD to                               CSD015
      ** see if 'SDCUSD' fucntion code is available.                                          CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'SDCUSD'      PFncCd                                       CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS)                                         CSD015
     C                             AND (PRTCD <> '*NRF')                                      CSD015
     C                   EVAL      DBKEY = 'SDCUSD'                                           CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access SDCWCDPD to get the 5 Private Customer Industry Code                          CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*FIRST '     POPTN                                        CSD015
     C     WDSCWCD       PARM      WDSCWCD       DSSDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS)                                         CSD015
     C                   EVAL      DBKEY = POPTN                                              CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 908                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if CCF001 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CCF001'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 909                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if CSW036 is installed                                                         CSW036
                                                                                              CSW036
     C                   EVAL      CSW036 = 'N'                                               CSW036
     C                   CALLB     'AOSARDR0'                                                 CSW036
     C                   PARM      *BLANKS       PRtCd                                        CSW036
     C                   PARM      '*VERIFY'     POptn                                        CSW036
     C                   PARM      'CSW036'      PSard                                        CSW036
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW036
                                                                                              CSW036
      ** Database error                                                                       CSW036
                                                                                              CSW036
     C                   IF        (PRtCd <> *BLANKS) and                                     CSW036
     C                             (PRtCd <> '*NRF   ')                                       CSW036
     C                   EVAL      DBKEY = 'CSW036'                                           CSW036
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW036
     C                   EVAL      DBASE = 910                                                CSW036
     C                   EXSR      SRERR                                                      CSW036
     C                   ENDIF                                                                CSW036
                                                                                              CSW036
     C                   IF        PRtCd = *BLANKS                                            CSW036
     C                   MOVE      'Y'           CSW036            1                          CSW036
     C                   ENDIF                                                                CSW036
      ** Check if CSW037 is installed                                                         CSW037
                                                                                              CSW037
     C                   EVAL      CSW037 = 'N'                                               CSW037
     C                   CALLB     'AOSARDR0'                                                 CSW037
     C                   PARM      *BLANKS       PRtCd                                        CSW037
     C                   PARM      '*VERIFY'     POptn                                        CSW037
     C                   PARM      'CSW037'      PSard                                        CSW037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW037
                                                                                              CSW037
      ** Database error                                                                       CSW037
                                                                                              CSW037
     C                   IF        (PRtCd <> *BLANKS) and                                     CSW037
     C                             (PRtCd <> '*NRF   ')                                       CSW037
     C                   EVAL      DBKEY = 'CSW037'                                           CSW037
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW037
     C                   EVAL      DBASE = 909                                                CSW037
     C                   EXSR      SRERR                                                      CSW037
     C                   ENDIF                                                                CSW037
                                                                                              CSW037
     C                   IF        PRtCd = *BLANKS                                            CSW037
     C                   MOVE      'Y'           CSW037            1                          CSW037
     C                   ENDIF                                                                CSW037
      ** Check if CSD025 is installed                                                         CSD025
                                                                                              CSD025
     C                   EVAL      CSD025 = 'N'                                               CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd                                        CSD025
     C                   PARM      '*VERIFY'     POptn                                        CSD025
     C                   PARM      'CSD025'      PSard                                        CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
      ** Database error                                                                       CSD025
                                                                                              CSD025
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD025
     C                             (PRtCd <> '*NRF   ')                                       CSD025
     C                   EVAL      DBKEY = 'CSD025'                                           CSD025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD025
     C                   EVAL      DBASE = 911                                                CSD025
     C                   EXSR      SRERR                                                      CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
     C                   IF        PRtCd = *BLANKS                                            CSD025
     C                   MOVE      'Y'           CSD025            1                          CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD023
      ** Check if enhancement CSD023 (Automatic Cust Closure) is on                           CSD023
                                                                                              CSD023
     C                   CALLB     'AOSARDR0'                                                 CSD023
     C                   PARM      *BLANKS       PRTCD                                        CSD023
     C                   PARM      '*VERIFY'     POPTN                                        CSD023
     C                   PARM      'CSD023'      PSARD                                        CSD023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD023
                                                                                              CSD023
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD023
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD023
     C                   EVAL      DBKEY = 'CSD023'                                           CSD023
     C                   EVAL      DBASE = 912                                                CSD023
     C                   EXSR      SRERR                                                      CSD023
     C                   ENDIF                                                                CSD023
                                                                                              CSD023
     C                   IF        PRTCD = *BLANKS                                            CSD023
     C                   EVAL      CSD023 = 'Y'                                               CSD023
     C                   OPEN      ACCNT                                                      CSD023
     C                   ELSE                                                                 CSD023
     C                   EVAL      CSD023 = 'N'                                               CSD023
     C                   ENDIF                                                                CSD023
      *                                                                                       CSD028
      ** Check if enhancement CSD028 (KYC) is on                                              CSD028
      *                                                                                       CSD028
     C                   CALLB     'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       PRTCD                                        CSD028
     C                   PARM      '*VERIFY'     POPTN                                        CSD028
     C                   PARM      'CSD028'      PSARD                                        CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
      *                                                                                       CSD028
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD028
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
     C                   EVAL      DBKEY = 'CSD028'                                           CSD028
     C                   EVAL      DBASE = 913                                                CSD028
     C                   EXSR      SRERR                                                      CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
     C                   IF        PRTCD = *BLANKS                                            CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   ELSE                                                                 CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   ENDIF                                                                CSD028
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
     C**********         EVAL      DBKey = 'CSD037'                                  CSD031 BUG13525
     C**********         EVAL      DBase = 101                                       CSD031 BUG13525
     C**********         OUT       LDA                                               CSD031 BUG13525
     C**********         EXSR      SRERR                                             CSD031 BUG13525
     C**********         ENDIF                                                       CSD031 BUG13525
                                                                                              CSD031
     C**********         ENDIF                                                       CSD031 BUG13525
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
     C                   EVAL      DBASE  = 920                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
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
     C                   EVAL      DBASE  = 921                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
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
     C                   EVAL      DBASE  = 922                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
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
     C                   EVAL      DBASE  = 923                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
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
     C                   EVAL      DBASE  = 924                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CGL018 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CGL018 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX004 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX004'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX004'                                          CSD079
     C                   EVAL      DBASE  = 915                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX004 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX004 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX609 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX609'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX609'                                          CSD079
     C                   EVAL      DBASE  = 916                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX609 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX609 = 'N'                                               CSD079
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
     C                   EVAL      DBASE  = 917                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX043 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX043 = 'N'                                               CSD079
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
     C                   EVAL      DBASE  = 925                                               CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD079 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD079 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   OPEN      SDCMRKL0                                                   CSD079
     C                   OPEN      SDACUSL0                                                   CSD079
     C                   OPEN      SDCFCDL0                                                   CSD079
     C                   OPEN      SDCHEQL0                                                   CSD079
     C                   OPEN      SDSAFEL0                                                   CSD079
     C                   OPEN      SDFOCSL0                                                   CSD079
     C                   OPEN      SDFOX1L0                                                   CSD079
     C                   OPEN      SDPLCSL0                                                   CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                      BUG3362
      ** initialise WBBTICS equal to blank                                                   BUG3362
      *                                                                                      BUG3362
     C                   MOVE      ' '           WBBTICS           1                         BUG3362
      *                                                                                      BUG3362
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
     C                   CALL      'AOSVALR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtcd                                        CGL132
     C                   PARM      SysVal1       SValK1                                       CGL132
     C                   PARM                    SVal1                                        CGL132
     C                   PARM      SysVal2       SValK2                                       CGL132
     C                   PARM                    SVal2                                        CGL132
     C                   PARM      SysVal3       SValK3                                       CGL132
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
     C                   EVAL      DBASE = 907                                                CGL132
     C                   EVAL      DBPGM = 'SDCUSDUPD'                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CSW207
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBKEY  = 'CSD083'                                          CSD083
     C                   EVAL      DBASE  = 926                                               CSD083
     C                   EXSR      SRERR                                                      CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CLE134
      ** Check if enhancement CLE134 is on                                                    CLE134
      *                                                                                       CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRTCD                                        CLE134
     C                   PARM      '*VERIFY'     POPTN                                        CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        PRTCD <> *BLANKS                                           CLE134
     C                             AND PRTCD <> '*NRF   '                                     CLE134
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE134
     C                   EVAL      DBKEY = 'CLE134'                                           CLE134
     C                   EVAL      DBASE = 930                                                CLE134
     C                   EXSR      SRERR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        PRTCD = *BLANKS                                            CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                    AR1086546
     C                   CALLB     'AOSARDR0'                                              AR1086546
     C                   PARM      *BLANKS       PRTCD                                     AR1086546
     C                   PARM      '*VERIFY'     POPTN                                     AR1086546
     C                   PARM      'CDL025'      PSARD                                     AR1086546
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1086546
                                                                                           AR1086546
     C                   IF        PRTCD       = *BLANKS                                   AR1086546
     C                   EVAL      CDL025      = 'Y'                                       AR1086546
     C                   ELSE                                                              AR1086546
     C                   EVAL      CDL025      = 'N'                                       AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
                                                                                              CSD083
      ** Check if account review (CSD092) is on                                               CSD092
                                                                                              CSD092
     C                   CALLB     'AOSARDR0'                                                 CSD092
     C                   PARM      *BLANKS       PRTCD                                        CSD092
     C                   PARM      '*VERIFY'     POPTN                                        CSD092
     C                   PARM      'CSD092'      PSARD                                        CSD092
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD092
                                                                                              CSD092
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD092
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD092
     C                   EVAL      DBKEY  = 'CSD092'                                          CSD092
     C                   EVAL      DBASE  = 929                                               CSD092
     C                   EXSR      SRERR                                                      CSD092
     C                   ENDIF                                                                CSD092
      *                                                                                       CSD092
     C                   IF        PRTCD = *BLANKS                                            CSD092
     C                   EVAL      CSD092 = 'Y'                                               CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
      *                                                                                       CFT050
      ** Check if CFT050 is installed                                                         CFT050
      *                                                                                       CFT050
     C                   EVAL      CFT050 = 'N'                                               CFT050
                                                                                              CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       PRtCd                                        CFT050
     C                   PARM      '*VERIFY'     POptn                                        CFT050
     C                   PARM      'CFT050'      PSard                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
                                                                                              CFT050
      ** Database error                                                                       CFT050
                                                                                              CFT050
     C                   IF        (PRtCd <> *BLANKS) and                                     CFT050
     C                             (PRtCd <> '*NRF   ')                                       CFT050
     C                   EVAL      DBKEY = 'CSW213'                                           CFT050
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT050
     C                   EVAL      DBASE = 928                                                CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ELSE                                                                 CFT050
     C                   EVAL      CFT050 = 'Y'                                               CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                     MD028198
      ** Check if SWIFT 2013 is installed                                                   MD028198
      *                                                                                     MD028198
     C                   CALL      'SWIF2013'                                               MD028198
     C                   PARM      *BLANKS       PRtCd                                      MD028198
                                                                                            MD028198
     C                   IF        PRtCd  = 'CSW2013'                                       MD028198
     C                   EVAL      CSW213 = 'Y'                                             MD028198
     C                   ELSE                                                               MD028198
     C                   EVAL      CSW213 = 'N'                                             MD028198
     C                   ENDIF                                                              MD028198
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR

     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEB            6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR
      *****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDCUSDUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWTCH - Set-up parameter and send transaction details to     *                       CSD015
      *          Compliance Watch by calling the Engine program       *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWTCH        BEGSR                                                                CSD015
                                                                                              CSD015
      ** Set-up first parameter for Compliance Engine                                         CSD015
                                                                                              CSD015
     C                   EVAL      PDSWLTD = *BLANKS                                          CSD015
     C                   EVAL      W4AMT1 = 0                                                 CSD015
     C                   EVAL      W4AMT2 = 0                                                 CSD015
     C                   EVAL      W4ITEM = 'SDCUSD'                                          CSD015
     C                   EVAL      W4IDEN = BBCUST                                            CSD015
     C                   EVAL      W4BRCH = BBBRCD                                            CSD015
     C                   EVAL      W4FUNT = 'SDCUSTPD'                                        CSD015
     C                   EVAL      W4CNUM = BBCUST                                            CSD015
                                                                                              CSD015
      ** Get Main System Prefix from data area SC24X7 if enhancement                          CSD015
      ** CSC011 is installed, else get it from SDSTAT                                         CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If Concord Interface Development is installed (CCF001)                               CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
                                                                                              CSD015
      ** If Corporate Customer is 'Y'                                                         CSD015
                                                                                              CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** If Local Industry Code is not blank or not equal to any                              CSD015
      ** of the five Private Customer Industry Code                                           CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Get the Counter Party (Midas Report Name + Customer Report Town)                     CSD015
                                                                                              CSD015
     C                   MOVEL     BBCRNM        W4CUST                                       CSD015
     C                   MOVE      BBCRTN        W4CUST                                       CSD015
                                                                                              CSD015
      ** Get converted dates                                                                  CSD015
                                                                                              CSD015
     C                   MOVE      '00000'       PINDATE                                      CSD015
     C                   EXSR      SRCVTDATE                                                  CSD015
     C                   MOVE      PCVTDDATE     W4DDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      '00000'       PINDATE                                      CSD015
     C                   EXSR      SRCVTDATE                                                  CSD015
     C                   MOVE      PCVTDDATE     W4VDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      '00000'       PINDATE                                      CSD015
     C                   EXSR      SRCVTDATE                                                  CSD015
     C                   MOVE      PCVTDDATE     W4MDAT                                       CSD015
                                                                                              CSD015
      ** Set-up second parameter for Compliance Engine                                        CSD015
                                                                                              CSD015
     C                   EVAL      PDSXML = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Set-up Customer Name                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBCNA1 <> B_BBCNA1                                         CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        BBCNA1 <> *BLANKS                                          CSD015
     C                   CAT       ARRTAG(1):0   PDSXML                                       CSD015
     C                   CAT       BBCNA1:0      PDSXML                                       CSD015
     C                   CAT       ARRTAG(2):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up Address Lines                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBCNA2 <> B_BBCNA2                                         CSD015
     C                             OR BBCNA3 <> B_BBCNA3                                      CSD015
     C                             OR BBCNA4 <> B_BBCNA4                                      CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   EVAL      WADDAL = *BLANKS                                           CSD015
     C                   CAT       BBCNA2:0      WADDAL                                       CSD015
     C                   CAT       BBCNA3:1      WADDAL                                       CSD015
     C                   CAT       BBCNA4:1      WADDAL                                       CSD015
     C                   IF        WADDAL <> *BLANKS                                          CSD015
     C                   CAT       ARRTAG(3):0   PDSXML                                       CSD015
     C                   CAT       WADDAL:0      PDSXML                                       CSD015
     C                   CAT       ARRTAG(4):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up SWIFT Identifier                                                              CSD015
                                                                                              CSD015
     C                   IF        BBCSID <> B_BBCSID                                         CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        BBCSID <> *BLANKS                                          CSD015
     C                   CAT       ARRTAG(5):0   PDSXML                                       CSD015
     C                   CAT       BBCSID:0      PDSXML                                       CSD015
     C                   CAT       ARRTAG(6):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up Country of Citizenship                                                        CSD015
                                                                                              CSD015
     C                   IF        BBCNCZ <> B_BBCNCZ                                         CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        BBCNCZ <> *BLANKS                                          CSD015
     C                   CAT       ARRTAG(7):0   PDSXML                                       CSD015
     C                   CAT       BBCNCZ:0      PDSXML                                       CSD015
     C                   CAT       ARRTAG(8):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up Country of Domicile                                                           CSD015
                                                                                              CSD015
     C                   IF        BBCOLC <> B_BBCOLC                                         CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        BBCOLC <> *BLANKS                                          CSD015
     C                   CAT       ARRTAG(9):0   PDSXML                                       CSD015
     C                   CAT       BBCOLC:0      PDSXML                                       CSD015
     C                   CAT       ARRTAG(10):0  PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   IF        PDSXML <> *BLANKS                                          CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    PDSWLTD                                      CSD015
     C                   PARM                    PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRXWTCH - Set-up parameter and send transaction details to    *                       CSD015
      *          Compliance Watch by calling the Engine program for   *                       CSD015
      *          Standing Data Authorisation enhancement              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRXWTCH       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Set-up first parameter for Compliance Engine                                         CSD015
                                                                                              CSD015
     C                   EVAL      PDSWLTD = *BLANKS                                          CSD015
     C                   EVAL      W4AMT1 = 0                                                 CSD015
     C                   EVAL      W4AMT2 = 0                                                 CSD015
     C                   EVAL      W4ITEM = 'SDCUSD'                                          CSD015
     C                   EVAL      W4IDEN = T_BBCUST                                          CSD015
     C                   EVAL      W4BRCH = T_BBBRCD                                          CSD015
     C                   EVAL      W4FUNT = 'SDCUSTPD'                                        CSD015
     C                   EVAL      W4CNUM = T_BBCUST                                          CSD015
                                                                                              CSD015
      ** Get Main System Prefix from data area SC24X7 if enhancement                          CSD015
      ** CSC011 is installed, else get it from SDSTAT                                         CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If Concord Interface Development is installed (CCF001)                               CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
                                                                                              CSD015
      ** If Corporate Customer is 'Y'                                                         CSD015
                                                                                              CSD015
     C                   IF        T_BBCRPC = 'Y'                                             CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** If Local Industry Code is not blank or not equal to any                              CSD015
      ** of the five Private Customer Industry Code                                           CSD015
                                                                                              CSD015
     C                   IF        T_BBLICD <> *BLANKS                                        CSD015
     C                             AND T_BBLICD <> W1IND1                                     CSD015
     C                             AND T_BBLICD <> W1IND2                                     CSD015
     C                             AND T_BBLICD <> W1IND3                                     CSD015
     C                             AND T_BBLICD <> W1IND4                                     CSD015
     C                             AND T_BBLICD <> W1IND5                                     CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Get the Counter Party (Midas Report Name + Customer Report Town)                     CSD015
                                                                                              CSD015
     C                   MOVEL     T_BBCRNM      W4CUST                                       CSD015
     C                   MOVE      T_BBCRTN      W4CUST                                       CSD015
                                                                                              CSD015
      ** Get converted dates                                                                  CSD015
                                                                                              CSD015
     C                   MOVE      '00000'       PINDATE                                      CSD015
     C                   EXSR      SRCVTDATE                                                  CSD015
     C                   MOVE      PCVTDDATE     W4DDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      '00000'       PINDATE                                      CSD015
     C                   EXSR      SRCVTDATE                                                  CSD015
     C                   MOVE      PCVTDDATE     W4VDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      '00000'       PINDATE                                      CSD015
     C                   EXSR      SRCVTDATE                                                  CSD015
     C                   MOVE      PCVTDDATE     W4MDAT                                       CSD015
                                                                                              CSD015
      ** Set-up second parameter for Compliance Engine                                        CSD015
                                                                                              CSD015
     C                   EVAL      PDSXML = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Set-up Customer Name                                                                 CSD015
                                                                                              CSD015
     C                   IF        T_BBCNA1 <> B_BBCNA1                                       CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        T_BBCNA1 <> *BLANKS                                        CSD015
     C                   CAT       ARRTAG(1):0   PDSXML                                       CSD015
     C                   CAT       T_BBCNA1:0    PDSXML                                       CSD015
     C                   CAT       ARRTAG(2):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up Address Lines                                                                 CSD015
                                                                                              CSD015
     C                   IF        T_BBCNA2 <> B_BBCNA2                                       CSD015
     C                             OR T_BBCNA3 <> B_BBCNA3                                    CSD015
     C                             OR T_BBCNA4 <> B_BBCNA4                                    CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   EVAL      WADDAL = *BLANKS                                           CSD015
     C                   CAT       T_BBCNA2:0    WADDAL                                       CSD015
     C                   CAT       T_BBCNA3:1    WADDAL                                       CSD015
     C                   CAT       T_BBCNA4:1    WADDAL                                       CSD015
     C                   IF        WADDAL <> *BLANKS                                          CSD015
     C                   CAT       ARRTAG(3):0   PDSXML                                       CSD015
     C                   CAT       WADDAL:0      PDSXML                                       CSD015
     C                   CAT       ARRTAG(4):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up SWIFT Identifier                                                              CSD015
                                                                                              CSD015
     C                   IF        T_BBCSID <> B_BBCSID                                       CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        T_BBCSID <> *BLANKS                                        CSD015
     C                   CAT       ARRTAG(5):0   PDSXML                                       CSD015
     C                   CAT       T_BBCSID:0    PDSXML                                       CSD015
     C                   CAT       ARRTAG(6):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up Country of Citizenship                                                        CSD015
                                                                                              CSD015
     C                   IF        T_BBCNCZ <> B_BBCNCZ                                       CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        T_BBCNCZ <> *BLANKS                                        CSD015
     C                   CAT       ARRTAG(7):0   PDSXML                                       CSD015
     C                   CAT       T_BBCNCZ:0    PDSXML                                       CSD015
     C                   CAT       ARRTAG(8):0   PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Set-up Country of Domicile                                                           CSD015
                                                                                              CSD015
     C                   IF        T_BBCOLC <> B_BBCOLC                                       CSD015
     C                             OR WUNCF1 = 'Y'                                            CSD015
     C                   IF        T_BBCOLC <> *BLANKS                                        CSD015
     C                   CAT       ARRTAG(9):0   PDSXML                                       CSD015
     C                   CAT       T_BBCOLC:0    PDSXML                                       CSD015
     C                   CAT       ARRTAG(10):0  PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   IF        PDSXML <> *BLANKS                                          CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    PDSWLTD                                      CSD015
     C                   PARM                    PDSXML                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SrCvtDate - Convert dates to be used for Watch Engine Program *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRCVTDATE     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM                    PINDATE                                      CSD015
     C                   PARM                    POUTDATE                                     CSD015
     C                   PARM                    PCVTDDATE                                    CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD027
      *****************************************************************                       CSD027
      *                                                               *                       CSD027
      * #@NUA -  "ADD" 1 to an alphanumeric customer number           *                       CSD027
      *                                                               *                       CSD027
      *****************************************************************                       CSD027
     C     #@NUA         BEGSR                                                                CSD027
      *                                                                                       CSD027
     C     *IN99         IFEQ      *OFF                                                       CSD027
     C                   MOVEL     'OFF'         IN99              3                          CSD027
     C                   ELSE                                                                 CSD027
     C                   MOVEL     'ON '         IN99                                         CSD027
     C                   END                                                                  CSD027
      *                                                                                       CSD027
     C                   MOVEA     #@NOA         #@CN                                         CSD027
     C                   Z-ADD     1             #@@6              2 0                        CSD027
     C                   Z-ADD     1             #@@5              2 0                        CSD027
     C                   Z-ADD     1             #@@4              2 0                        CSD027
     C                   Z-ADD     1             #@@3              2 0                        CSD027
     C                   Z-ADD     1             #@@2              2 0                        CSD027
     C                   Z-ADD     1             #@@1              2 0                        CSD027
      * Find chars                                                                            CSD027
     C     #@CN(6)       LOOKUP    #@VC(#@@6)                             99                  CSD027
     C     #@CN(5)       LOOKUP    #@VC(#@@5)                             99                  CSD027
     C     #@CN(4)       LOOKUP    #@VC(#@@4)                             99                  CSD027
     C     #@CN(3)       LOOKUP    #@VC(#@@3)                             99                  CSD027
     C     #@CN(2)       LOOKUP    #@VC(#@@2)                             99                  CSD027
     C     #@CN(1)       LOOKUP    #@VC(#@@1)                             99                  CSD027
      * Add 1 to last char                                                                    CSD027
     C                   ADD       1             #@@6                                         CSD027
     C     #@@6          IFGT      36                                                         CSD027
     C                   Z-ADD     1             #@@6                                         CSD027
     C                   ADD       1             #@@5                                         CSD027
     C                   END                                                                  CSD027
      *  Fifth char                                                                           CSD027
     C     #@@5          IFGT      36                                                         CSD027
     C                   Z-ADD     1             #@@5                                         CSD027
     C                   ADD       1             #@@4                                         CSD027
     C                   END                                                                  CSD027
      *  Fourth char                                                                          CSD027
     C     #@@4          IFGT      36                                                         CSD027
     C                   Z-ADD     1             #@@4                                         CSD027
     C                   ADD       1             #@@3                                         CSD027
     C                   END                                                                  CSD027
      *  Third char                                                                           CSD027
     C     #@@3          IFGT      36                                                         CSD027
     C                   Z-ADD     1             #@@3                                         CSD027
     C                   ADD       1             #@@2                                         CSD027
     C                   END                                                                  CSD027
      *  Second char                                                                          CSD027
     C     #@@2          IFGT      36                                                         CSD027
     C                   Z-ADD     1             #@@2                                         CSD027
     C                   ADD       1             #@@1                                         CSD027
     C                   END                                                                  CSD027
      *                                                                                       CSD027
     C                   MOVEL     #@VC(#@@1)    #@CN(1)                                      CSD027
     C                   MOVEL     #@VC(#@@2)    #@CN(2)                                      CSD027
     C                   MOVEL     #@VC(#@@3)    #@CN(3)                                      CSD027
     C                   MOVEL     #@VC(#@@4)    #@CN(4)                                      CSD027
     C                   MOVEL     #@VC(#@@5)    #@CN(5)                                      CSD027
     C                   MOVEL     #@VC(#@@6)    #@CN(6)                                      CSD027
      *                                                                                       CSD027
     C                   MOVEA     #@CN          #@NOA             6                          CSD027
     C*                                                                                       CSD027
     C     IN99          IFEQ      'OFF'                                                      CSD027
     C                   MOVEL     *OFF          *IN99                                        CSD027
     C                   ELSE                                                                 CSD027
     C                   MOVEL     *ON           *IN99                                        CSD027
     C                   END                                                                  CSD027
      *                                                                                       CSD027
     C                   ENDSR                                                                CSD027
                                                                                              CSD027
      *****************************************************************                       CSD027
      /EJECT                                                          *                       CSD027
     C****************************************************************
      *                                                               *                       CSD079
      *  TWRVGN - Retrieve Int Cust Branch - Branch Codes             *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     CSR   TWRVGN        BEGSR                                                                CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C     A_CUCUST      SETLL     @BRCHFM                                                    CSD079
     C     A_CUCUST      READE     @BRCHFM                                90                  CSD079
     C     *IN90         IFEQ      *ON                                                        CSD079
                                                                                              CSD079
      ** Data record not found                                                                CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C                   LEAVESR                                                              CSD079
     C                   END                                                                  CSD079
      *                                                                                       CSD079
     C     *IN90         DOWEQ     *OFF                                                       CSD079
                                                                                              CSD079
      ** USER: Process Data record                                                            CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C                   MOVEL     'BRANCH'      W0RTN                                        CSD079
     C     A_CUCUST      READE     @BRCHFM                                90                  CSD079
     C                   ENDDO                                                                CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * UPDMID - Update Customer Marketing Info. Details if CSD079    *                       CSD079
      *          is 'Y'                                               *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDMID        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Marketing Info. Details File                                         CSD079
                                                                                              CSD079
     C                   CLEAR                   CUMIF                                        CSD079
      *                                                                                       CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_MICUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     A_MICUST      CHAIN     SDCMRKL0                           95                      CSD079
                                                                                              CSD079
      ** Database Error If INSERT, but record present already                                 CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
     C     A_CUTYLC      ORNE      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
     C                   MOVEL     A_MICUST      DBKEY                                        CSD079
     C                   MOVEL     'SDCMRKPD'    DBFILE                                       CSD079
     C                   MOVEL     031           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUMIF         B_CUMIF                                      CSD079
                                                                                              CSD079
      ** move values from SDVCUMI to fields of SDCMRKL0                                       CSD079
                                                                                              CSD079
     C                   EVAL      D7CUST =A_MICUST                                           CSD079
     C                   EVAL      D7GPC1 =A_MIGPC1                                           CSD079
     C                   EVAL      D7GPC2 =A_MIGPC2                                           CSD079
     C                   EVAL      D7GPC3 =A_MIGPC3                                           CSD079
     C                   EVAL      D7GPC4 =A_MIGPC4                                           CSD079
     C                   EVAL      D7GPC5 =A_MIGPC5                                           CSD079
     C                   EVAL      D7LCD  =BJRDNB                                             CSD079
     C                   EVAL      D7TYLC =A_MITYLC                                           CSD079
     C                   IF        CSD090 = 'Y'                                               CSD090
     C                   EVAL      D7CSDE = A_MICSDE                                          CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD079
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
      *                                                                                       CSD079
     C                   WRITE     @D7REJA                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Insert                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
      *                                                                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend                                                                                CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'A'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
      *                                                                                       CSD079
     C                   UPDATE    @D7REJA                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'D'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   DELETE    @D7REJA                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUMIF       WUDELR                                       CSD079
                                                                                              CSD079
      ** Write Deleted Record - SD Deleted Records File                                       CSD079
                                                                                              CSD079
     C                   CLEAR                   PBRC                                         CSD079
     C                   MOVEL     'SDCMRKPD'    PBFNME                                       CSD079
     C                   MOVEL     A_MICUST      PBLKEY                                       CSD079
     C                   MOVEL     WUDR01        PBDR01                                       CSD079
     C                   MOVEL     WUDR02        PBDR02                                       CSD079
     C                   MOVEL     WUDR03        PBDR03                                       CSD079
     C                   MOVEL     WUDR04        PBDR04                                       CSD079
     C                   MOVEL     WUDR05        PBDR05                                       CSD079
     C                   MOVEL     WUDR06        PBDR06                                       CSD079
     C                   MOVEL     WUDR07        PBDR07                                       CSD079
     C                   MOVEL     WUDR08        PBDR08                                       CSD079
     C                   MOVEL     WUDR09        PBDR09                                       CSD079
     C                   MOVEL     WUDR10        PBDR10                                       CSD079
     C                   MOVEL     WUDR11        PBDR11                                       CSD079
     C                   MOVEL     WUDR12        PBDR12                                       CSD079
     C                   MOVEL     BJRDNB        PBLCD                                        CSD079
     C                   MOVEL     'D'           PBTYLC                                       CSD079
                                                                                              CSD079
     C                   CALL      'SD0520X'                                                  CSD079
     C                   PARM      *BLANK        @RTCD                                        CSD079
     C                   PARM                    PBRC                                         CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     @RTCD         IFEQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     A_MICUST      DBKEY                                        CSD079
     C                   MOVEL     'SDDELRL0'    DBFILE                                       CSD079
     C                   MOVEL     032           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Change Standing Data Cont - Standing Data Controls                                   CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCMRKPD'    WFLNAME                                      CSD079
     C                   EXSR      SNCHRC                                                     CSD079
      *                                                                                       CSD079
     C                   ENDSR                                                                CSD079
      *                                                                                       CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * UPDADD - Update Customer Additional Details.                  *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDADD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Additional Details File                                              CSD079
                                                                                              CSD079
     C                   CLEAR                   CUADF                                        CSD079
      *                                                                                       CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_ADCUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     A_ADCUST      CHAIN     SDACUSL0                           95                      CSD079
                                                                                              CSD079
      ** Database Error If INSERT, but record present already                                 CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
     C     A_CUTYLC      ORNE      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
     C                   MOVEL     A_ADCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDACUSPD'    DBFILE                                       CSD079
     C                   MOVEL     033           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUADF         B_CUADF                                      CSD079
                                                                                              CSD079
      ** move values from SDVCUAD to fields of SDACUSL0                                       CSD079
                                                                                              CSD079
     C                   EVAL      E5CUST = A_ADCUST                                          CSD079
     C                   EVAL      E5LCD  = RDNB                                              CSD079
     C                   EVAL      E5TYLC = A_ADTYLC                                          CSD079
     C                   EVAL      E5ALTN = A_ADALTN                                          CSD079
     C                   EVAL      E5IDNO = A_ADIDNO                                          CSD079
     C                   EVAL      E5FXNB = A_ADFXNB                                          CSD079
     C                   EVAL      E5TXNB = A_ADTXNB                                          CSD079
     C                   EVAL      E5DOLV = A_ADDOLV                                          CSD079
     C                   EVAL      E5PRVO = A_ADPRVO                                          CSD079
     C                   EVAL      E5MDTL = A_ADMDTL                                          CSD079
     C                   EVAL      E5CNA1 = A_ADCNA1                                          CSD079
     C                   EVAL      E5CNA2 = A_ADCNA2                                          CSD079
     C                   EVAL      E5CNA3 = A_ADCNA3                                          CSD079
     C                   EVAL      E5CNA4 = A_ADCNA4                                          CSD079
     C                   EVAL      E5CWL1 = A_ADCWL1                                          CSD079
     C                   EVAL      E5CWL2 = A_ADCWL2                                          CSD079
     C                   EVAL      E5CWL3 = A_ADCWL3                                          CSD079
     C                   EVAL      E5CWL4 = A_ADCWL4                                          CSD079
     C                   EVAL      E5BRTH = A_ADBRTH                                          CSD079
     C                   EVAL      E5BRT1 = A_ADBRT1                                          CSD079
     C                   EVAL      E5BRT2 = A_ADBRT2                                          CSD079
     C                   EVAL      E5CWL5 = A_ADCWL5                                          CSD079
     C                   EVAL      E5CITY = A_ADCITY                                          CSD079
     C                   EVAL      E5ZIPC = A_ADZIPC                                          CSD079
     C                   EVAL      E5TINO = A_ADTINO                                          CSD079
     C                   EVAL      E5IDTP = A_ADIDTP                                          CSD079
     C                   EVAL      E5ISCT = A_ADISCT                                          CSD079
     C                   EVAL      E5ISDT = A_ADISDT                                          CSD079
     C                   EVAL      E5DBTH = A_ADDBTH                                          CSD079
     C                   EVAL      E5BTHC = A_ADBTHC                                          CSD079
     C                   EVAL      E5BTHT = A_ADBTHT                                          CSD079
     C                   EVAL      E5JATP = A_ADJATP                                          CSD079
     C                   EVAL      E5REPI = A_ADREPI                                          CSD079
     C                   EVAL      E5FRNT = *BLANKS                                           CSD079
     C                   EVAL      E5CSSN = A_ADCSSN                                          CSD079
     C                   EVAL      E5TMST = TimeStamp                                         CSD079
     C                   EVAL      E5FL01 = A_ADFL01                                          CSD079
     C                   EVAL      E5FL02 = A_ADFL02                                          CSD079
     C                   EVAL      E5FL03 = A_ADFL03                                          CSD079
     C                   EVAL      E5FL04 = A_ADFL04                                          CSD079
     C                   EVAL      E5FL05 = A_ADFL05                                          CSD079
     C                   EVAL      E5FL06 = A_ADFL06                                          CSD079
     C                   EVAL      E5FL07 = A_ADFL07                                          CSD079
     C                   EVAL      E5FL08 = A_ADFL08                                          CSD079
     C                   EVAL      E5FL09 = A_ADFL09                                          CSD079
     C                   EVAL      E5FL10 = A_ADFL10                                          CSD079
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG14992
     C                   EVAL      E5ISCD = A_ADISCD                                        BUG14992
     C                   ELSE                                                               BUG14992
     C                   EVAL      E5ISCD = *BLANKS                                         BUG14992
     C                   ENDIF                                                              BUG14992
                                                                                              CSD079
     C                   EVAL      E5TITL = A_ADTITL                                          CER059
     C                   EVAL      E5MDNM = A_ADMDNM                                          CER059
     C                   EVAL      E5SHRF = A_ADSHRF                                          CER059
     C                   EVAL      E5PIND = A_ADPIND                                          CER059
     C                   EVAL      E5DCID = A_ADDCID                                          CER059
     C                   EVAL      E5DIPL = A_ADDIPL                                          CER059
     C                   EVAL      E5EXDT = A_ADEXDT                                          CER059
     C                   EVAL      E5EXTH = A_ADEXTH                                          CER059
     C                   EVAL      E5EADT = A_ADEADT                                          CER059
     C                   EVAL      E5EVDT = A_ADEVDT                                          CER059
     C                   EVAL      E5ETXT = A_ADETXT                                          CER059
     C                   EVAL      E5CDCL = A_ADCDCL                                          CER059
     C                   EVAL      E5S24C = A_ADS24C                                          CER059
     C                   EVAL      E5REM1 = A_ADREM1                                          CER059
     C                   EVAL      E5REM2 = A_ADREM2                                          CER059
     C                   EVAL      E5REM3 = A_ADREM3                                          CER059
     C                   EVAL      E5STCD = A_ADSTCD                                          CER059
     C                   EVAL      E5RLAF = A_ADRLAF                                          CER059
                                                                                              CER059
     C                   EVAL      E5FXCU = A_ADFXCU                                          CER059
     C                   EVAL      E5SMBR = A_ADSMBR                                          CER059
     C                   EVAL      E5SECU = A_ADSECU                                          CER059
     C                   EVAL      E5LNID = A_ADLNID                                          CER059
     C                   EVAL      E5CTYP = A_ADCTYP                                          CER059
     C                   EVAL      E5ZCFG = A_ADZCFG                                          CER059
     C                   EVAL      E5BSCC = A_ADBSCC                                          CER059
     C                   EVAL      E5ECAC = A_ADECAC                                          CER059
     C                   EVAL      E5BIST = A_ADBIST                                          CER059
     C                   EVAL      E5ABSK = A_ADABSK                                          CER059
     C                   EVAL      E5BEXT = A_ADBEXT                                          CER059
     C                   EVAL      E5RIGR = A_ADRIGR                                          CER070
     C                   EVAL      E5RECH = A_ADRECH                                          CER071
      ** Alternative Tax Identification Numbers                                               CGL132
     C                   EVAL      E5TIN2 = A_ADTIN2                                          CGL132
     C                   EVAL      E5TNC2 = A_ADTNC2                                          CGL132
     C                   EVAL      E5TIN3 = A_ADTIN3                                          CGL132
     C                   EVAL      E5TNC3 = A_ADTNC3                                          CGL132
     C                   EVAL      E5TIN4 = A_ADTIN4                                          CGL132
     C                   EVAL      E5TNC4 = A_ADTNC4                                          CGL132
     C                   EVAL      E5TIN5 = A_ADTIN5                                          CGL132
     C                   EVAL      E5TNC5 = A_ADTNC5                                          CGL132
                                                                                              CGL157
      ** Effective / Expiry Dates 1 - 10                                                      CGL157
     C                   EVAL      E5EFF1 = A_ADEFF1                                          CGL157
     C                   EVAL      E5EXP1 = A_ADEXP1                                          CGL157
     C                   EVAL      E5EFF2 = A_ADEFF2                                          CGL157
     C                   EVAL      E5EXP2 = A_ADEXP2                                          CGL157
     C                   EVAL      E5EFF3 = A_ADEFF3                                          CGL157
     C                   EVAL      E5EXP3 = A_ADEXP3                                          CGL157
     C                   EVAL      E5EFF4 = A_ADEFF4                                          CGL157
     C                   EVAL      E5EXP4 = A_ADEXP4                                          CGL157
     C                   EVAL      E5EFF5 = A_ADEFF5                                          CGL157
     C                   EVAL      E5EXP5 = A_ADEXP5                                          CGL157
                                                                                              CGL157
      ** Update the Additional field details for CGL157                                       CGL157
      ** Mailing Countries                                                                    CGL157
     C                   EVAL      E5CTR1 = A_ADCTR1                                          CGL157
     C                   EVAL      E5CTR2 = A_ADCTR2                                          CGL157
     C                   EVAL      E5CTR3 = A_ADCTR3                                          CGL157
     C                   EVAL      E5CTR4 = A_ADCTR4                                          CGL157
     C                   EVAL      E5CTR5 = A_ADCTR5                                          CGL157
      ** Phone Number Countries                                                               CGL157
     C                   EVAL      E5PHN1 = A_ADPHN1                                          CGL157
     C                   EVAL      E5PHN2 = A_ADPHN2                                          CGL157
     C                   EVAL      E5PHN3 = A_ADPHN3                                          CGL157
     C                   EVAL      E5PHN4 = A_ADPHN4                                          CGL157
     C                   EVAL      E5PHN5 = A_ADPHN5                                          CGL157
                                                                                              CGL157
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   EVAL      E5PDCU = A_ADPDCU                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CER059
     C                   EVAL      E5FRNT = A_ADFRNT                                        AR971184
     C                   EVAL      E5REPA = A_ADREPA                                        AR971184
                                                                                            AR971184
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
                                                                                              CSD079
      ** If enhancement CSD015 is installed and W1EWLC = 'Y'                                  CSD079
                                                                                              CSD079
     C                   IF        CSD015 = 'Y' AND                                           CSD079
     C                             W1EWLC = 'Y'                                               CSD079
                                                                                              CSD079
      ** If user is in the main system                                                        CSD079
                                                                                              CSD079
     C                   IF        CSC011 = 'N' OR                                            CSD079
     C                             CSC011 = 'Y' AND                                           CSD079
     C                             S1MAIN = LIBR                                              CSD079
                                                                                              CSD079
      ** If any of the watch list fields have been entered                                    CSD079
                                                                                              CSD079
     C                   IF        E5CNA1 <> *BLANKS  OR                                      CSD079
     C                             E5CNA2 <> *BLANKS  OR                                      CSD079
     C                             E5CNA3 <> *BLANKS  OR                                      CSD079
     C                             E5CNA4 <> *BLANKS  OR                                      CSD079
     C                             E5IDNO <> *BLANKS  OR                                      CSD079
     C                             E5BRTH <> 0                                                CSD079
                                                                                              CSD079
     C                   EXSR      SRADWTCH                                                   CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   WRITE     @ACUSL0                                                    CSD079
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   CALL      'SD009696'                                                 CGL157
     C                   PARM      E5CUST        PCUST                                        CGL157
     C                   PARM      *BLANKS       PBefCUST                                     CGL157
     C                   PARM      CUSTDF        PAftCUST                                     CGL157
     C                   PARM      *BLANKS       PBefACUS                                     CGL157
     C                   PARM      CUADF         PAftACUS                                     CGL157
     C                   PARM      *BLANKS       PBefFTCS                                     CGL157
     C                   PARM                    PAftFTCS                                     CGL157
     C                   PARM      *BLANKS       PBefJACC                                     CGL157
     C                   PARM      *BLANKS       PAftJACC                                     CGL157
     C                   PARM      *BLANKS       PBefCUAH                                     CGL157
     C                   PARM      *BLANKS       PAftCUAH                                     CGL157
     C                   PARM      *BLANKS       PBefCUXC                                     CGL157
     C                   PARM                    PAftCUXC                                     CGL157
     C                   PARM      *BLANKS       PACRV                                        CGL157
     C                   PARM      *BLANKS       PELEC                                        CGL157
     C                   PARM                    PBefCRSH                                     CGL157
     C                   PARM                    PAftCRSH                                     CGL157
     C                   PARM                    PBefCRSD                                     CGL157
     C                   PARM                    PAftCRSD                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      E5CUST        PCUST                                        CSD092
     C                   PARM      *BLANKS       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      CUADF         PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C**********         PARM      *BLANKS       PAftFTCS                            CGL132 MD026957
     C                   PARM                    PAftFTCS                                   MD026957
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C**********         PARM      *BLANKS       PAftCUXC                          MD026854 MD026957
     C                   PARM                    PAftCUXC                                   MD026957
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CSD092
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend                                                                                CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'A'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
      ** If CSD015 = 'Y' and watch list checking applied                                      CSD079
                                                                                              CSD079
     C                   IF        CSD015 = 'Y' AND                                           CSD079
     C                             W1EWLC = 'Y'                                               CSD079
                                                                                              CSD079
      ** If user is in the main system                                                        CSD079
                                                                                              CSD079
     C                   IF        CSC011 = 'N' OR                                            CSD079
     C                             CSC011 = 'Y' AND                                           CSD079
     C                             S1MAIN = LIBR                                              CSD079
                                                                                              CSD079
      ** Access SDCWHTPD using function type 'SDACUSPD', identifier                           CSD079
      ** BBCUST, and branch BBBCRD to verify Hit Unconfirmed Flag                             CSD079
                                                                                              CSD079
     C                   EVAL      WFuncType = 'SDACUSPD'                                     CSD079
     C                   EVAL      WIdntifier = A_ADCUST                                      CSD079
     C                   EVAL      WBranch = BBBRCD                                           CSD079
                                                                                              CSD079
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD079
     C                   IF        NOT %FOUND(SDCWHTL1)                                       CSD079
     C                   EVAL      WUNCF1 = 'N'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   IF        W3UNCF = 'Y'                                               CSD079
     C                   EVAL      WUNCF1 = 'Y'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If any of the watch list fields has been entered                                     CSD079
                                                                                              CSD079
     C                   IF        E5CNA1 <> B_E5CNA1  OR                                     CSD079
     C                             E5CNA2 <> B_E5CNA2  OR                                     CSD079
     C                             E5CNA3 <> B_E5CNA3  OR                                     CSD079
     C                             E5CNA4 <> B_E5CNA4  OR                                     CSD079
     C                             E5IDNO <> B_E5IDNO  OR                                     CSD079
     C                             E5BRTH <> B_E5BRTH  OR                                     CSD079
     C                             WUNCF1 = 'Y'                                               CSD079
                                                                                              CSD079
     C                   EXSR      SRADWTCH                                                   CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   UPDATE    @ACUSL0                                                    CSD079
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
      ** Ensure parameters are properly populated                                           MD051563
     C                   IF        CGL132 = 'Y'                                             MD051563
     C                   EVAL      PBefFTCS = SDFTCS2                                       MD051563
     C                   EVAL      PAftFTCS = SDFTCS                                        MD051563
     C                   ELSE                                                               MD051563
     C                   EVAL      PBefFTCS = *BLANKS                                       MD051563
     C                   EVAL      PAftFTCS = *BLANKS                                       MD051563
     C                   ENDIF                                                              MD051563
     C                   IF        CGL157 = 'N'                                             MD051563
     C                   EVAL      PBefCRSH = *BLANKS                                       MD051563
     C                   EVAL      PAftCRSH = *BLANKS                                       MD051563
     C                   EVAL      PBefCRSD = *BLANKS                                       MD051563
     C                   EVAL      PAftCRSD = *BLANKS                                       MD051563
     C                   ENDIF                                                              MD051563
      *                                                                                     MD051563
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      E5CUST        PCUST                                        CSD092
     C                   PARM      B_CUSTD       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      B_CUADF       PBefACUS                                     CSD092
     C                   PARM      CUADF         PAftACUS                                     CSD092
     C**********         PARM      *BLANKS       PBefFTCS                            CGL132 MD026957
     C**********         PARM      *BLANKS       PAftFTCS                            CGL132 MD026957
     C                   PARM                    PBefFTCS                                   MD026957
     C                   PARM                    PAftFTCS                                   MD026957
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM                    PBefCUXC                                   MD026957
     C                   PARM                    PAftCUXC                                   MD026957
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C**********         PARM      *BLANKS       PBefCRSH                            CGL177 MD051563
     C**********         PARM      *BLANKS       PAftCRSH                            CGL177 MD051563
     C**********         PARM      *BLANKS       PBefCRSD                            CGL177 MD051563
     C**********         PARM      *BLANKS       PAftCRSD                            CGL177 MD051563
     C                   PARM                    PBefCRSH                                   MD051563
     C                   PARM                    PAftCRSH                                   MD051563
     C                   PARM                    PBefCRSD                                   MD051563
     C                   PARM                    PAftCRSD                                   MD051563
     C                   ENDIF                                                                CSD092
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
                                                                                              CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'D'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   DELETE    @ACUSL0                                                    CSD079
                                                                                              CSD092
     C                   IF        CSD092 = 'Y'                                               CSD092
     C                   CALL      'SD009696'                                                 CSD092
     C                   PARM      E5CUST        PCUST                                        CSD092
     C                   PARM      B_CUSTD       PBefCUST                                     CSD092
     C                   PARM      CUSTDF        PAftCUST                                     CSD092
     C                   PARM      *BLANKS       PBefACUS                                     CSD092
     C                   PARM      CUADF         PAftACUS                                     CSD092
     C                   PARM      *BLANKS       PBefFTCS                                     CGL132
     C                   PARM      *BLANKS       PAftFTCS                                     CGL132
     C                   PARM      *BLANKS       PBefJACC                                     CSD092
     C                   PARM      *BLANKS       PAftJACC                                     CSD092
     C                   PARM      *BLANKS       PBefCUAH                                     CSD092
     C                   PARM      *BLANKS       PAftCUAH                                     CSD092
     C                   PARM      *BLANKS       PBefCUXC                                   MD026854
     C                   PARM      *BLANKS       PAftCUXC                                   MD026854
     C                   PARM      *BLANKS       PACRV                                        CSD092
     C                   PARM      *BLANKS       PELEC                                        CGL132
     C                   PARM      *BLANKS       PBefCRSH                                     CGL177
     C                   PARM      *BLANKS       PAftCRSH                                     CGL177
     C                   PARM      *BLANKS       PBefCRSD                                     CGL177
     C                   PARM      *BLANKS       PAftCRSD                                     CGL177
     C                   ENDIF                                                                CSD092
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUADF       WUDELR                                       CSD079
                                                                                              CSD079
      ** Write Deleted Record - SD Deleted Records File                                       CSD079
                                                                                              CSD079
     C                   CLEAR                   PBRC                                         CSD079
     C                   MOVEL     'SDACUSPD'    PBFNME                                       CSD079
     C                   MOVEL     A_ADCUST      PBLKEY                                       CSD079
     C                   MOVEL     WUDR01        PBDR01                                       CSD079
     C                   MOVEL     WUDR02        PBDR02                                       CSD079
     C                   MOVEL     WUDR03        PBDR03                                       CSD079
     C                   MOVEL     WUDR04        PBDR04                                       CSD079
     C                   MOVEL     WUDR05        PBDR05                                       CSD079
     C                   MOVEL     WUDR06        PBDR06                                       CSD079
     C                   MOVEL     WUDR07        PBDR07                                       CSD079
     C                   MOVEL     WUDR08        PBDR08                                       CSD079
     C                   MOVEL     WUDR09        PBDR09                                       CSD079
     C                   MOVEL     WUDR10        PBDR10                                       CSD079
     C                   MOVEL     WUDR11        PBDR11                                       CSD079
     C                   MOVEL     WUDR12        PBDR12                                       CSD079
     C                   MOVEL     RDNB          PBLCD                                        CSD079
     C                   MOVEL     'D'           PBTYLC                                       CSD079
                                                                                              CSD079
     C                   CALL      'SD0520X'                                                  CSD079
     C                   PARM      *BLANK        @RTCD                                        CSD079
     C                   PARM                    PBRC                                         CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     @RTCD         IFEQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     A_ADCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDDELRL0'    DBFILE                                       CSD079
     C                   MOVEL     034           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDSFD - Update Customer Service Fees Details                *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDSFD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Service Fees Details File                                            CSD079
                                                                                              CSD079
     C                   CLEAR                   CUFEF                                        CSD079
      *                                                                                       CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      F_SFCUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     F_SFCUST      CHAIN     SDCFCDL0                           95                      CSD079
                                                                                              CSD079
      ** Check if INSERT or AMEND                                                            BG12238
                                                                                             BG12238
     C     F_SFTYLC      IFNE      'D'                                                       BG12238
     C     *IN95         IFEQ      '1'                                                       BG12238
     C                   MOVEL     'I'           F_SFTYLC                                    BG12238
     C                   ELSE                                                                BG12238
      *                                                                                      BG12238
     C                   MOVEL     'A'           F_SFTYLC                                    BG12238
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                               BG12238
      ***Database Error If INSERT, but record present already                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
     C*****A_CUTYLC      ORNE      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
     C**********         MOVEL     F_SFCUST      DBKEY                                CRE026 BG12238
     C**********         MOVEL     'SDCFCDPD'    DBFILE                 ************  CRE026 BG12238
     C**********         MOVEL     035           DBASE                  * DBERR 035*  CRE026 BG12238
     C**********         EXSR      SRERR                                ************  CRE026 BG12238
     C**********         ENDIF                                                        CRE026 BG12238
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUFEF         B_CUFEF                                      CSD079
                                                                                              CSD079
      ** move values from SDVCUFE to fields of SDCFCDL0                                       CSD079
                                                                                              CSD079
     C                   EVAL      E6CUST = F_SFCUST                                          CSD079
     C                   EVAL      E6LCD  = RDNB                                              CSD079
     C                   EVAL      E6TYLC = F_SFTYLC                                          CSD079
     C                   EVAL      E6HMIN = F_SFHMIN                                          CSD079
     C                   EVAL      E6NAIN = F_SFNAIN                                          CSD079
     C                   EVAL      E6SMAC = F_SFSMAC                                          CSD079
     C                   EVAL      E6SBCH = F_SFSBCH                                          CSD079
     C                   EVAL      E6SCCY = F_SFSCCY                                          CSD079
     C                   EVAL      E6PFCD = F_SFPFCD                                          CSD079
     C                   EVAL      E6PCAC = F_SFPCAC                                          CSD079
     C                   EVAL      E6PCHM = F_SFPCHM                                          CSD079
     C                   EVAL      E6TAIF = F_SFTAIF                                          CSD079
                                                                                              CSD079
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     F_SFTYLC      IFEQ      'I'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
                                                                                              CRE079
     C                   WRITE     @CFCDL0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Insert                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend                                                                                CSD079
                                                                                              CSD079
     C     F_SFTYLC      IFEQ      'A'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'A'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
                                                                                              CSD079
     C                   UPDATE    @CFCDL0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C     F_SFTYLC      IFEQ      'D'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'D'                                                CRE026 BG12238
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   DELETE    @CFCDL0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUFEF       WUDELR                                       CSD079
                                                                                              CSD079
      ** Write Deleted Record - SD Deleted Records File                                       CSD079
                                                                                              CSD079
     C                   CLEAR                   PBRC                                         CSD079
     C                   MOVEL     'SDCFCDPD'    PBFNME                                       CSD079
     C                   MOVEL     F_SFCUST      PBLKEY                                       CSD079
     C                   MOVEL     WUDR01        PBDR01                                       CSD079
     C                   MOVEL     WUDR02        PBDR02                                       CSD079
     C                   MOVEL     WUDR03        PBDR03                                       CSD079
     C                   MOVEL     WUDR04        PBDR04                                       CSD079
     C                   MOVEL     WUDR05        PBDR05                                       CSD079
     C                   MOVEL     WUDR06        PBDR06                                       CSD079
     C                   MOVEL     WUDR07        PBDR07                                       CSD079
     C                   MOVEL     WUDR08        PBDR08                                       CSD079
     C                   MOVEL     WUDR09        PBDR09                                       CSD079
     C                   MOVEL     WUDR10        PBDR10                                       CSD079
     C                   MOVEL     WUDR11        PBDR11                                       CSD079
     C                   MOVEL     WUDR12        PBDR12                                       CSD079
     C                   MOVEL     RDNB          PBLCD                                        CSD079
     C                   MOVEL     'D'           PBTYLC                                       CSD079
                                                                                              CSD079
     C                   CALL      'SD0520X'                                                  CSD079
     C                   PARM      *BLANK        @RTCD                                        CSD079
     C                   PARM                    PBRC                                         CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     @RTCD         IFEQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     F_SFCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDDELRL0'    DBFILE                                       CSD079
     C                   MOVEL     036           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Change Standing Data Cont - Standing Data Controls                                   CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCFCDPD'    WFLNAME                                      CSD079
     C                   EXSR      SNCHRC                                                     CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * UPDCQD - Update Cheques & Cards Details                       *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDCQD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Cheques & Cards Details File                                                  CSD079
                                                                                              CSD079
     C                   CLEAR                   CUCQF                                        CSD079
      *                                                                                       CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_CCCUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     A_CCCUST      CHAIN     SDCHEQPF                           95                      CSD079
                                                                                              CSD079
      ** Database Error                                                                       CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
     C     A_CUTYLC      ORNE      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
     C                   MOVEL     A_CCCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDCHEQPD'    DBFILE                                       CSD079
     C                   MOVEL     037           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUCQF         B_CUCQF                                      CSD079
                                                                                              CSD079
      ** Move fields to SDCHEQPF which are common for Insert, Amend &                         CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C                   EVAL      SCRECI = A_CCRECI                                          CSD079
     C                   TIME                    SCTLUP                                       CSD079
     C                   EVAL      SCDLUP = W_DLUP                                            CSD079
     C                   EVAL      SCMLUP = W_MLUP                                            CSD079
     C                   EVAL      SCYLUP = W_YLUP                                            CSD079
     C                   EVAL      SCCHTP = A_CCCHTP                                          CSD079
     C                   EVAL      SCLCD  = BJRDNB                                            CSD079
     C                   EVAL      SCTNLU = A_CCTNLU                                          CSD079
     C                   EVAL      SCCUST = A_CCCUST                                          CSD079
     C                   EVAL      SCCSSN = A_CCCSSN                                          CSD079
     C                   EVAL      SCCRNM = A_CCCRNM                                          CSD079
     C                   EVAL      SCCRTN = A_CCCRTN                                          CSD079
     C                   EVAL      SCCAC1 = A_CCCAC1                                          CSD079
     C                   EVAL      SCDIS1 = A_CCDIS1                                          CSD079
     C                   EVAL      SCDRE1 = A_CCDRE1                                          CSD079
     C                   EVAL      SCCAC2 = A_CCCAC2                                          CSD079
     C                   EVAL      SCDIS2 = A_CCDIS2                                          CSD079
     C                   EVAL      SCDRE2 = A_CCDRE2                                          CSD079
     C                   EVAL      SCCAC3 = A_CCCAC3                                          CSD079
     C                   EVAL      SCDIS3 = A_CCDIS3                                          CSD079
     C                   EVAL      SCDRE3 = A_CCDRE3                                          CSD079
     C                   EVAL      SCCAC4 = A_CCCAC4                                          CSD079
     C                   EVAL      SCDIS4 = A_CCDIS4                                          CSD079
     C                   EVAL      SCDRE4 = A_CCDRE4                                          CSD079
     C                   EVAL      SCCAC5 = A_CCCAC5                                          CSD079
     C                   EVAL      SCDIS5 = A_CCDIS5                                          CSD079
     C                   EVAL      SCDRE5 = A_CCDRE5                                          CSD079
     C                   EVAL      SCCTX1 = A_CCCTX1                                          CSD079
     C                   EVAL      SCCQF1 = A_CCCQF1                                          CSD079
     C                   EVAL      SCCQT1 = A_CCCQT1                                          CSD079
     C                   EVAL      SCCQQ1 = A_CCCQQ1                                          CSD079
     C                   EVAL      SCCQI1 = A_CCCQI1                                          CSD079
     C                   EVAL      SCCQF2 = A_CCCQF2                                          CSD079
     C                   EVAL      SCCQT2 = A_CCCQT2                                          CSD079
     C                   EVAL      SCCQQ2 = A_CCCQQ2                                          CSD079
     C                   EVAL      SCCQI2 = A_CCCQI2                                          CSD079
     C                   EVAL      SCCQF3 = A_CCCQF3                                          CSD079
     C                   EVAL      SCCQT3 = A_CCCQT3                                          CSD079
     C                   EVAL      SCCQQ3 = A_CCCQQ3                                          CSD079
     C                   EVAL      SCCQI3 = A_CCCQI3                                          CSD079
     C                   EVAL      SCCQF4 = A_CCCQF4                                          CSD079
     C                   EVAL      SCCQT4 = A_CCCQT4                                          CSD079
     C                   EVAL      SCCQQ4 = A_CCCQQ4                                          CSD079
     C                   EVAL      SCCQI4 = A_CCCQI4                                          CSD079
     C                   EVAL      SCCQF5 = A_CCCQF5                                          CSD079
     C                   EVAL      SCCQT5 = A_CCCQT5                                          CSD079
     C                   EVAL      SCCQQ5 = A_CCCQQ5                                          CSD079
     C                   EVAL      SCCQI5 = A_CCCQI5                                          CSD079
     C                   EVAL      SCCTX2 = A_CCCTX2                                          CSD079
     C                   EVAL      SCCAN1 = A_CCCAN1                                          CSD079
     C                   EVAL      SCCAL1 = A_CCCAL1                                          CSD079
     C                   EVAL      SCCAI1 = A_CCCAI1                                          CSD079
     C                   EVAL      SCCAE1 = A_CCCAE1                                          CSD079
     C                   EVAL      SCCAN2 = A_CCCAN2                                          CSD079
     C                   EVAL      SCCAL2 = A_CCCAL2                                          CSD079
     C                   EVAL      SCCAI2 = A_CCCAI2                                          CSD079
     C                   EVAL      SCCAE2 = A_CCCAE2                                          CSD079
     C                   EVAL      SCCAN3 = A_CCCAN3                                          CSD079
     C                   EVAL      SCCAL3 = A_CCCAL3                                          CSD079
     C                   EVAL      SCCAI3 = A_CCCAI3                                          CSD079
     C                   EVAL      SCCAE3 = A_CCCAE3                                          CSD079
     C                   EVAL      SCCAN4 = A_CCCAN4                                          CSD079
     C                   EVAL      SCCAL4 = A_CCCAL4                                          CSD079
     C                   EVAL      SCCAI4 = A_CCCAI4                                          CSD079
     C                   EVAL      SCCAE4 = A_CCCAE4                                          CSD079
     C                   EVAL      SCCAN5 = A_CCCAN5                                          CSD079
     C                   EVAL      SCCAL5 = A_CCCAL5                                          CSD079
     C                   EVAL      SCCAI5 = A_CCCAI5                                          CSD079
     C                   EVAL      SCCAE5 = A_CCCAE5                                          CSD079
                                                                                              CSD079
      ** Insert Processing                                                                    CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
                                                                                              CSD079
      ** Move fields for Insert                                                               CSD079
                                                                                              CSD079
     C                   WRITE     SDCHEQPF                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Insert                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
      *                                                                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend Processing                                                                     CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'A'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
      ** Move fields for Amend                                                                CSD079
                                                                                              CSD079
     C                   UPDATE    SDCHEQPF                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete Processing                                                                    CSD079
      ** Database Error If Delete, but record not present                                     CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'D'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
      ** Move fields for Delete                                                               CSD079
                                                                                              CSD079
     C                   UPDATE    SDCHEQPF                                                   CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Change Standing Data Cont - Standing Data Controls                                   CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCHEQPD'    WFLNAME                                      CSD079
     C                   EXSR      SNCHRC                                                     CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDSAD - Update Customer Safes Details                       *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDSAD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Safes Details File                                                   CSD079
                                                                                              CSD079
     C                   CLEAR                   CUSFF                                        CSD079
                                                                                              CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_SFCUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     A_SFCUST      CHAIN     SDSAFEL0                           95                      CSD079
                                                                                              CSD079
      ** Database Error If INSERT, but record present already                                 CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
     C     A_CUTYLC      ORNE      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
     C                   MOVEL     A_SFCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDSAFEPD'    DBFILE                                       CSD079
     C                   MOVEL     038           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUSFF         B_CUSFF                                      CSD079
                                                                                              CSD079
      ** move values from SDVCUSF to fields of SDSAFEL0                                       CSD079
                                                                                              CSD079
     C                   EVAL      SARECI = A_SFRECI                                          CSD079
     C                   TIME                    SATLUP                                       CSD079
     C                   EVAL      SADLUP = W_DLUP                                            CSD079
     C                   EVAL      SAMLUP = W_MLUP                                            CSD079
     C                   EVAL      SAYLUP = W_YLUP                                            CSD079
     C                   EVAL      SACHTP = A_SFCHTP                                          CSD079
     C                   EVAL      SALCD  = BJRDNB                                            CSD079
     C                   EVAL      SATNLU = A_SFTNLU                                          CSD079
     C                   EVAL      SACUST = A_SFCUST                                          CSD079
     C                   EVAL      SACSSN = A_SFCSSN                                          CSD079
     C                   EVAL      SACRNM = A_SFCRNM                                          CSD079
     C                   EVAL      SACRTN = A_SFCRTN                                          CSD079
     C                   EVAL      SASFN1 = A_SFSFN1                                          CSD079
     C                   EVAL      SASFS1 = A_SFSFS1                                          CSD079
     C                   EVAL      SASFI1 = A_SFSFI1                                          CSD079
     C                   EVAL      SASFN2 = A_SFSFN2                                          CSD079
     C                   EVAL      SASFS2 = A_SFSFS2                                          CSD079
     C                   EVAL      SASFI2 = A_SFSFI2                                          CSD079
     C                   EVAL      SASFN3 = A_SFSFN3                                          CSD079
     C                   EVAL      SASFS3 = A_SFSFS3                                          CSD079
     C                   EVAL      SASFI3 = A_SFSFI3                                          CSD079
     C                   EVAL      SASFN4 = A_SFSFN4                                          CSD079
     C                   EVAL      SASFS4 = A_SFSFS4                                          CSD079
     C                   EVAL      SASFI4 = A_SFSFI4                                          CSD079
     C                   EVAL      SASFN5 = A_SFSFN5                                          CSD079
     C                   EVAL      SASFS5 = A_SFSFS5                                          CSD079
     C                   EVAL      SASFI5 = A_SFSFI5                                          CSD079
                                                                                              CSD079
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'I'                                                        CSD079
     C     *IN95         ANDEQ     *ON                                                        CSD079
     C                   WRITE     SDSAFEPF                                                   CSD079
      *                                                                                       CSD079
      ** USER: Processing after Insert                                                        CSD079
      *                                                                                       CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend                                                                                CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'A'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   UPDATE    SDSAFEPF                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'D'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   UPDATE    SDSAFEPF                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUFOF       WUDELR                                       CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Change Standing Data Cont - Standing Data Controls                                   CSD079
                                                                                              CSD079
     C                   MOVEL     'SDSAFEPD'    WFLNAME                                      CSD079
     C                   EXSR      SNCHRC                                                     CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDFOD - Update Customer Futures & Option Details            *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDFOD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access Customer Futures and Option Details File                                      CSD079
                                                                                              CSD079
     C                   CLEAR                   CUFOF                                        CSD079
                                                                                              CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_FOCUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     A_FOCUST      CHAIN     SDFOCSL0                           95                      CSD079
                                                                                              CSD079
      * Check if INSERT or AMEND                                                             BG12238
      *                                                                                      BG12238
     C     A_FOTYLC      IFNE      'D'                                                       BG12238
     C     *IN95         IFEQ      '1'                                                       BG12238
     C                   MOVEL     'I'           A_FOTYLC                                    BG12238
     C                   ELSE                                                                BG12238
      *                                                                                      BG12238
     C                   MOVEL     'A'           A_FOTYLC                                    BG12238
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                               BG12238
      ***Database Error If INSERT, but record present already                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
     C*****A_CUTYLC      ORNE      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
     C**********         MOVEL     A_FOCUST      DBKEY                                CRE026 BG12238
     C**********         MOVEL     'SDFOCSPD'    DBFILE                 ************  CRE026 BG12238
     C**********         MOVEL     039           DBASE                  * DBERR 039*  CRE026 BG12238
     C**********         EXSR      SRERR                                ************  CRE026 BG12238
     C**********         ENDIF                                                        CRE026 BG12238
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUFOF         B_CUFOF                                      CSD079
                                                                                              CSD079
      ** move values from SDVCUFO to fields of SDFOCSL0                                       CSD079
                                                                                              CSD079
     C                   EVAL      BHCUST = A_FOCUST                                          CSD079
     C                   EVAL      BHCYCD = A_FOCYCD                                          CSD079
     C                   EVAL      BHLCD  = RDNB                                              CSD079
     C                   EVAL      BHTYLC = A_FOTYLC                                          CSD079
     C                   EVAL      BHSTFQ = A_FOSTFQ                                          CSD079
     C                   EVAL      BHDMFS = A_FODMFS                                          CSD079
     C                   EVAL      BHNSDT = A_FONSDT                                          CSD079
     C                   EVAL      BHFACO = A_FOFACO                                          CSD079
     C                   EVAL      BHBKIN = A_FOBKIN                                          CSD079
     C                   EVAL      BHSTTY = A_FOSTTY                                          CSD079
     C                   EVAL      BHSMAC = A_FOSMAC                                          CSD079
     C                   EVAL      BHCPNO = A_FOCPNO                                          CSD079
     C                   EVAL      BHCOAD = A_FOCOAD                                          CSD079
     C                   EVAL      BHFTAO = A_FOFTAO                                          CSD079
     C                   EVAL      BHTXCI = A_FOTXCI                                          CSD079
     C                   EVAL      BHCTLM = A_FOCTLM                                          CSD079
     C                   EVAL      BHRVFQ = A_FORVFQ                                          CSD079
     C                   EVAL      BHRVBD = A_FORVBD                                          CSD079
     C                   EVAL      BHNRDT = A_FONRDT                                          CSD079
     C                   EVAL      BHPCIN = A_FOPCIN                                          CSD079
     C                   EVAL      BHACIN = A_FOACIN                                          CSD079
     C                   EVAL      BHCODE = A_FOCODE                                          CSD079
     C                   EVAL      BHCOAM = A_FOCOAM                                          CSD079
     C                   EVAL      BHSEBR = A_FOSEBR                                          CSD079
                                                                                              CSD079
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     A_FOTYLC      IFEQ      'I'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
                                                                                              CSD079
     C                   WRITE     @BHRED0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Insert                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend                                                                                CSD079
                                                                                              CSD079
     C     A_FOTYLC      IFEQ      'A'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'A'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
                                                                                              CSD079
     C                   UPDATE    @BHRED0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C     A_FOTYLC      IFEQ      'D'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'D'                                                CRE026 BG12238
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   DELETE    @BHRED0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUFOF       WUDELR                                       CSD079
                                                                                              CSD079
      ** Write Deleted Record - SD Deleted Records File                                       CSD079
                                                                                              CSD079
     C                   CLEAR                   PBRC                                         CSD079
     C                   MOVEL     'SDFOCSPD'    PBFNME                                       CSD079
     C                   MOVEL     A_FOCUST      PBLKEY                                       CSD079
     C                   MOVEL     WUDR01        PBDR01                                       CSD079
     C                   MOVEL     WUDR02        PBDR02                                       CSD079
     C                   MOVEL     WUDR03        PBDR03                                       CSD079
     C                   MOVEL     WUDR04        PBDR04                                       CSD079
     C                   MOVEL     WUDR05        PBDR05                                       CSD079
     C                   MOVEL     WUDR06        PBDR06                                       CSD079
     C                   MOVEL     WUDR07        PBDR07                                       CSD079
     C                   MOVEL     WUDR08        PBDR08                                       CSD079
     C                   MOVEL     WUDR09        PBDR09                                       CSD079
     C                   MOVEL     WUDR10        PBDR10                                       CSD079
     C                   MOVEL     WUDR11        PBDR11                                       CSD079
     C                   MOVEL     WUDR12        PBDR12                                       CSD079
     C                   MOVEL     RDNB          PBLCD                                        CSD079
     C                   MOVEL     'D'           PBTYLC                                       CSD079
                                                                                              CSD079
     C                   CALL      'SD0520X'                                                  CSD079
     C                   PARM      *BLANK        @RTCD                                        CSD079
     C                   PARM                    PBRC                                         CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     @RTCD         IFEQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     A_FOCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDDELRL0'    DBFILE                                       CSD079
     C                   MOVEL     040           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Change Standing Data Cont - Standing Data Controls                                   CSD079
                                                                                              CSD079
     C                   MOVEL     'SDFOCSPD'    WFLNAME                                      CSD079
     C                   EXSR      SNCHRC                                                     CSD079
                                                                                              CSD079
      ** Update FOCLT - Futures & Options Clients                                             CSD079
      *                                                                                      BG12238
     C                   CALL      'FOCLT'                              90                    CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C     @RTCD         PARM      *BLANK        WQ0086                                       CSD079
                                                                                              CSD079
      ** Customer No.                                                                         CSD079
                                                                                              CSD079
     C                   PARM      BHCUST        WQ0087                                       CSD079
                                                                                              CSD079
      ** Currency Code                                                                        CSD079
                                                                                              CSD079
     C                   PARM      BHCYCD        WQ0088                                       CSD079
                                                                                              CSD079
      ** Statement Freq                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHSTFQ        WQ0089                                       CSD079
                                                                                              CSD079
      ** Day in month                                                                         CSD079
                                                                                              CSD079
     C                   PARM      BHDMFS        WQ0090                                       CSD079
                                                                                              CSD079
      ** Next statement                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHNSDT        WQ0091                                       CSD079
                                                                                              CSD079
      ** For Account of                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHFACO        WQ0092                                       CSD079
                                                                                              CSD079
      ** Broker Indic.                                                                        CSD079
                                                                                              CSD079
     C                   PARM      BHBKIN        WQ0093                                       CSD079
                                                                                              CSD079
      ** Settlement Type                                                                      CSD079
                                                                                              CSD079
     C                   PARM      BHSTTY        WQ0094                                       CSD079
     C                   PARM      BHSMAC        WQ0095                                       CSD079
                                                                                              CSD079
      ** Counterparty                                                                         CSD079
                                                                                              CSD079
     C                   PARM      BHCPNO        WQ0096                                       CSD079
                                                                                              CSD079
      ** Correspondence                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHCOAD        WQ0097                                       CSD079
                                                                                              CSD079
      ** For the Atten.                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHFTAO        WQ0098                                       CSD079
                                                                                              CSD079
      ** Telex Confirm                                                                        CSD079
                                                                                              CSD079
     C                   PARM      BHTXCI        WQ0099                                       CSD079
                                                                                              CSD079
      ** Contract Limit                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHCTLM        WQ0100                                       CSD079
                                                                                              CSD079
      ** Revaluation Fq                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHRVFQ        WQ0101                                       CSD079
                                                                                              CSD079
      ** Revaluation Ba                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHRVBD        WQ0102                                       CSD079
                                                                                              CSD079
      ** Next revaluation                                                                     CSD079
                                                                                              CSD079
     C                   PARM      BHNRDT        WQ0103                                       CSD079
                                                                                              CSD079
      ** Positions comb                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHPCIN        WQ0104                                       CSD079
                                                                                              CSD079
      ** Automatic Clos                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHACIN        WQ0105                                       CSD079
                                                                                              CSD079
      ** Collateral Dsc                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHCODE        WQ0106                                       CSD079
                                                                                              CSD079
      ** Collateral Amt                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHCOAM        WQ0107                                       CSD079
                                                                                              CSD079
      ** Settlement Br.                                                                       CSD079
                                                                                              CSD079
     C                   PARM      BHSEBR        WQ0108                                       CSD079
                                                                                              CSD079
      ** Type of Lst Chg                                                                      CSD079
                                                                                              CSD079
     C                   PARM      BHTYLC        WQ0109                                       CSD079
                                                                                              CSD079
      ** Run day Number                                                                       CSD079
                                                                                              CSD079
     C                   PARM      RDNB          WQ0110                                       CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     *IN90         IFEQ      *ON                                                        CSD079
     C     @RTCD         OREQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     A_FOCUST      DBKEY                                        CSD079
     C                   MOVEL     'FOCLT'       DBFILE                                       CSD079
     C                   MOVEL     041           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDFFD - Update MIDAS/ABS FF Customers Maintenance Details   *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDFFD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access MIDAS/ABS FF Customers Maintenance Details File                               CSD079
                                                                                              CSD079
     C                   CLEAR                   CUFF                                         CSD079
                                                                                              CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      LXCUST = A_CUCUST                                        BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C     LXCUST        CHAIN     SDFOX1L0                           95                      CSD079
      *                                                                                       CSD079
      ***Database Error If INSERT, but record present already                         CRE026 BG12238
      **********                                                                      CRE026 BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
     C*****A_CUTYLC      ORNE      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
     C**********         MOVEL     LXCUST        DBKEY                                CRE026 BG12238
     C**********         MOVEL     'SDFOX1PD'    DBFILE                 ************  CRE026 BG12238
     C**********         MOVEL     050           DBASE                  * DBERR 050*  CRE026 BG12238
     C**********         EXSR      SRERR                                ************  CRE026 BG12238
     C**********         ENDIF                                                                CSD079
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUFF          B_CUFF                                       CSD079
                                                                                              CSD079
      ** move values from SDVCUFF to fields of SDFOX1L0                                       CSD079
                                                                                              CSD079
     C                   EVAL      CACUST = LXCUST                                            CSD079
     C                   EVAL      CANETA = LXNETA                                            CSD079
                                                                                              CSD079
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     A_FOTYLC      IFEQ      'I'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CSD079 BG12238
     C******IN95         ANDEQ     '1'                                                CSD079 BG12238
                                                                                              CSD079
     C                   WRITE     SDFOCSD6                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Insert                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend                                                                                CSD079
                                                                                              CSD079
     C     A_FOTYLC      IFEQ      'A'                                                        CSD079
     C*****A_CUTYLC      IFEQ      'A'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
                                                                                              CRE026
     C                   UPDATE    SDFOCSD6                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete                                                                               CSD079
                                                                                              CSD079
     C     A_CUTYLC      IFEQ      'D'                                                        CSD079
     C     *IN95         ANDEQ     *OFF                                                       CSD079
                                                                                              CSD079
     C                   DELETE    SDFOCSD6                                                   CSD079
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUFF        WUDELR                                       CSD079
                                                                                              CSD079
      ** Write Deleted Record - SD Deleted Records File                                       CSD079
                                                                                              CSD079
     C                   CLEAR                   PBRC                                         CSD079
     C                   MOVEL     'SDFOX1PD'    PBFNME                                       CSD079
     C                   MOVEL     LXCUST        PBLKEY                                       CSD079
     C                   MOVEL     WUDR01        PBDR01                                       CSD079
     C                   MOVEL     WUDR02        PBDR02                                       CSD079
     C                   MOVEL     WUDR03        PBDR03                                       CSD079
     C                   MOVEL     WUDR04        PBDR04                                       CSD079
     C                   MOVEL     WUDR05        PBDR05                                       CSD079
     C                   MOVEL     WUDR06        PBDR06                                       CSD079
     C                   MOVEL     WUDR07        PBDR07                                       CSD079
     C                   MOVEL     WUDR08        PBDR08                                       CSD079
     C                   MOVEL     WUDR09        PBDR09                                       CSD079
     C                   MOVEL     WUDR10        PBDR10                                       CSD079
     C                   MOVEL     WUDR11        PBDR11                                       CSD079
     C                   MOVEL     WUDR12        PBDR12                                       CSD079
     C                   MOVEL     RDNB          PBLCD                                        CSD079
     C                   MOVEL     'D'           PBTYLC                                       CSD079
                                                                                              CSD079
     C                   CALL      'SD0520X'                                                  CSD079
     C                   PARM      *BLANK        @RTCD                                        CSD079
     C                   PARM                    PBRC                                         CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     @RTCD         IFEQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     LXCUST        DBKEY                                        CSD079
     C                   MOVEL     'SDDELRL0'    DBFILE                                       CSD079
     C                   MOVEL     051           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ***Change*Standing*Data*Cont*-*Standing*Data*Controls************              CSD079 BUG27943
                                                                                              CSD079
     C**********         MOVEL     'SDFOX1PD'    WFLNAME                             CSD079 BUG27943
     C**********         EXSR      SNCHRC                                            CSD079 BUG27943
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDPMD - Update Customer Portfolio Management                *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDPMD        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Update PM PORTFOLIO DEFINITION AUDIT File                                            CSD079
                                                                                              CSD079
     C     BGN4ST        IFEQ      'Y'                                                        CSD079
                                                                                              CSD079
     C     A_PMDFPO      IFEQ      *BLANKS                                                    CSD079
     C     *LOVAL        SETLL     PBTMPDLL                                                   CSD079
     C                   READ      PBTMPDLL                               89                  CSD079
     C                   ELSE                                                                 CSD079
     C     A_PMDFPO      SETLL     PBTMPDLL                                                   CSD079
     C     A_PMDFPO      READE     PBTMPDLL                               89                  CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_PMCUST = A_CUCUST                                      BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C                   MOVE      A_PMCUST      PNCNUM                                       CSD079
     C                   MOVEL     'I'           PNCHTP                                       CSD079
     C                   Z-ADD     RDNB          PNLCD                                        CSD079
     C                   MOVEL     'D'           PNRECI                                       CSD079
     C     *IN89         IFEQ      *OFF                                                       CSD079
     C                   MOVE      PNPTFR        A_PMDFPO                                     CSD079
     C                   Z-ADD     WUDLUP        PNDLUP                                       CSD079
     C                   MOVEL     WUMLUP        PNMLUP                                       CSD079
     C                   Z-ADD     WUYLUP        PNYLUP                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   MOVE      A_PMDFPO      PNPTFR                                       CSD079
     C                   TIME                    PNTLUP                                       CSD079
                                                                                              CSD079
     C     A_PMCSBY      IFEQ      *BLANK                                                     CSD079
     C                   MOVE      *BLANKS       A_PMDFPO                                     CSD079
     C                   ELSE                                                                 CSD079
     C**********         MOVEL     A_PMCUST      PNPTCY                             CSD079 AR1081787
     C                   MOVEL     A_PMCSBY      PNPTCY                             CSD079 AR1081787
     C                   Z-ADD     A_PMBYDP      PNPCDP                                       CSD079
     C                   MOVE      PNPTFR        PNPTFR                                       CSD079
     C                   MOVEL     PNPTFN        PNPTFN                                       CSD079
     C                   Z-ADD     RDNB          PNDPOP                                       CSD079
     C                   MOVEL     'M'           PNMNGI                                       CSD079
     C                   MOVEL     'N'           PNIPIN                                       CSD079
     C                   MOVEL     'N'           PNCYIN                                       CSD079
     C                   MOVEL     'N'           PNYPIN                                       CSD079
     C                   MOVEL     'N'           PNNPIN                                       CSD079
     C                   MOVEL     PNRPYP        PNRPYP                                       CSD079
     C                   Z-ADD     99999         PNPSDT                                       CSD079
     C                   Z-ADD     01            PNACSQ                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** CASE: *OTHERWISE                                                                     CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        WURTCD                                       CSD079
     C                   MOVEL     '*PMCUSTV'    WUPMAC                                       CSD079
     C                   MOVEL     A_PMCUST      WUCUST                                       CSD079
     C                   MOVEL     *BLANK        WUBKCD                                       CSD079
     C                   MOVEL     A_PMDFPO      WUPTRF                                       CSD079
     C                   MOVEL     *BLANK        WUSCPF                                       CSD079
     C                   MOVEL     *BLANK        WUSCPT                                       CSD079
     C                   MOVEL     PSProcName    WUPGMN                                       CSD079
                                                                                              CSD079
      ** Call PMZ0010 - Book Details                                                          CSD079
                                                                                              CSD079
     C                   CALL      'PMZ0010'                            90                    CSD079
     C     WURTCD        PARM      WURTCD        WQ0035                                       CSD079
     C     WUPMAC        PARM      WUPMAC        WQ0036                                       CSD079
     C     WUCUST        PARM      WUCUST        WQ0037                                       CSD079
     C     WUBKCD        PARM      WUBKCD        WQ0038                                       CSD079
     C     WUPTRF        PARM      WUPTRF        WQ0039                                       CSD079
     C     WUSCPF        PARM      WUSCPF        WQ0040                                       CSD079
     C     WUSCPT        PARM      WUSCPT        WQ0041                                       CSD079
     C     WUPGMN        PARM      WUPGMN        WQ0042                                       CSD079
                                                                                              CSD079
     C     *IN90         IFEQ      *ON                                                        CSD079
                                                                                              CSD079
      ** Call to program ended in error                                                       CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     PNCNUM        DBKEY                                        CSD079
     C                   MOVEL     'PMPORTPD'    DBFILE                                       CSD079
     C                   MOVEL     070           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Return Code work field is NORMAL                                                     CSD079
                                                                                              CSD079
     C     WURTCD        IFEQ      *BLANK                                                     CSD079
     C     BGN4ST        ANDNE     'Y'                                                        CSD079
     C     WURTCD        OREQ      *BLANK                                                     CSD079
     C     WUSCPF        ANDNE     *BLANK                                                     CSD079
     C     WUSCPF        ANDNE     FCR997                                                     CSD079
     C     BGN4ST        ANDEQ     'Y'                                                        CSD079
     C                   MOVEL     WUSCPF        #1DFPO                                       CSD079
     C                   ELSE                                                                 CSD079
     C     A_PMDFPO      IFNE      *BLANKS                                                    CSD079
     C     PNCHTP        ANDEQ     'I'                                                        CSD079
     C     A_PMDFPO      ANDNE     FCR997                                                     CSD079
     C     BGN4ST        ANDEQ     'Y'                                                        CSD079
     C                   MOVEL     'D'           PNRECI                                       CSD079
                                                                                              CSD079
     C     PNMGTP        IFEQ      *ZEROS                                                     CSD079
     C                   Z-ADD     1             PNMGTP                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C     PNINTP        IFEQ      *ZEROS                                                     CSD079
     C                   Z-ADD     1             PNINTP                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   WRITE     PMPORTP0                                                   CSD079
                                                                                              CSD079
      ** Access to trailer                                                                    CSD079
                                                                                              CSD079
     C     1             CHAIN     PMPORTPA                           80                      CSD079
     C     *IN80         IFEQ      *ON                                                        CSD079
                                                                                              CSD079
      ** Write Trailer                                                                        CSD079
                                                                                              CSD079
     C                   MOVE      'Z'           PNRECI                                       CSD079
     C                   WRITE     PMPORTZ0                                                   CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
     C                   ADD       1             PNNORE                                       CSD079
     C                   UPDATE    PMPORTZ0                                                   CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   END                                                                  CSD079
                                                                                              CSD079
      ** Access Customer Portfolio Management Details File                                    CSD079
                                                                                              CSD079
     C                   CLEAR                   CUPMF                                        CSD079
                                                                                              CSD079
     C     A_PMCUST      CHAIN     @PLCSL0                            95                      CSD079
                                                                                              CSD079
      ** Check if INSERT or AMEND                                                            BG12238
                                                                                             BG12238
     C     A_PMTYLC      IFNE      'D'                                                       BG12238
     C     *IN95         IFEQ      '1'                                                       BG12238
     C                   MOVEL     'I'           A_PMTYLC                                    BG12238
     C                   ELSE                                                                BG12238
      *                                                                                      BG12238
     C                   MOVEL     'A'           A_PMTYLC                                    BG12238
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                               BG12238
                                                                                              CSD079
      ** Insert Processing                                                                    CSD079
                                                                                              CSD079
                                                                                              CSD079
      ***Database Error If INSERT, but record present already                         CRE026 BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
     C*****A_CUTYLC      ORNE      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
     C**********         MOVEL     A_PMCUST      DBKEY                                CRE026 BG12238
     C**********         MOVEL     'SDPLCSPD'    DBFILE                 ************  CRE026 BG12238
     C**********         MOVEL     042           DBASE                  * DBERR 042*  CRE026 BG12238
     C**********         EXSR      SRERR                                ************  CRE026 BG12238
     C**********         ENDIF                                                                CSD079
                                                                                              CSD079
      ** Update Before Status                                                                 CSD079
                                                                                              CSD079
     C                   MOVEL(P)  CUPMF         B_CUPMF                                      CSD079
                                                                                              CSD079
      ** Move all fields to @PLCSL0                                                           CSD079
                                                                                              CSD079
     C                   EVAL      QBCUST =A_PMCUST                                           CSD079
     C                   EVAL      QBLCD  =A_PMLCD                                            CSD079
     C                   EVAL      QBRECI =A_PMRECI                                           CSD079
     C                   EVAL      QBDLUP = WUDLUP                                            CSD079
     C                   EVAL      QBMLUP = WUMLUP                                            CSD079
     C                   EVAL      QBYLUP = WUYLUP                                            CSD079
     C                   EVAL      QBTLUP =A_PMTLUP                                           CSD079
     C                   EVAL      QBTNLU =A_PMTNLU                                           CSD079
     C                   EVAL      QBBDAT =A_PMBDAT                                           CSD079
     C                   EVAL      QBLANG =A_PMLANG                                           CSD079
     C                   EVAL      QBCSBY =A_PMCSBY                                           CSD079
     C                   EVAL      QBBYDP =A_PMBYDP                                           CSD079
     C                   EVAL      QBSAFI =A_PMSAFI                                           CSD079
     C                   EVAL      QBDCMS =A_PMDCMS                                           CSD079
     C                   EVAL      QBVLFQ =A_PMVLFQ                                           CSD079
     C                   EVAL      QBVLDM =A_PMVLDM                                           CSD079
     C                   EVAL      QBVLND =A_PMVLND                                           CSD079
     C                   EVAL      QBS1VR =A_PMS1VR                                           CSD079
     C                   EVAL      QBS2VR =A_PMS2VR                                           CSD079
     C                   EVAL      QBS3VR =A_PMS3VR                                           CSD079
     C                   EVAL      QBS4VR =A_PMS4VR                                           CSD079
     C                   EVAL      QBS5VR =A_PMS5VR                                           CSD079
     C                   EVAL      QBS6VR =A_PMS6VR                                           CSD079
     C                   EVAL      QBS7VR =A_PMS7VR                                           CSD079
     C                   EVAL      QBS8VR =A_PMS8VR                                           CSD079
     C                   EVAL      QBAPBC =A_PMAPBC                                           CSD079
     C                   EVAL      QBPPCS =A_PMPPCS                                           CSD079
     C                   EVAL      QBDFPO =A_PMDFPO                                           CSD079
     C                   EVAL      QBINSU =A_PMINSU                                           CSD079
     C                   EVAL      QBCYSU =A_PMCYSU                                           CSD079
     C                   EVAL      QBSECO =A_PMSECO                                           CSD079
                                                                                              CSD079
      ** Insert                                                                               CSD079
                                                                                              CSD079
     C     A_PMTYLC      IFEQ      'I'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'I'                                                CRE026 BG12238
     C******IN95         ANDEQ     '1'                                                CRE026 BG12238
                                                                                              CSD079
     C                   EVAL      QBTYLC =A_PMTYLC                                           CSD079
     C                   EVAL      QBPFM7 ='N'                                                CSD079
     C                   EVAL      QBPFM8 ='N'                                                CSD079
     C                   EVAL      QBPFM9 ='N'                                                CSD079
                                                                                              CSD079
     C                   WRITE     @PLCSL0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Insert                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     1             WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     1             WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Amend Processing                                                                     CSD079
      ** Database Error If Amend, but record not present                                      CSD079
                                                                                              CSD079
     C     A_PMTYLC      IFEQ      'A'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'A'                                                CRE026 BG12238
     C******IN95         ANDEQ     '0'                                                CRE026 BG12238
                                                                                              CSD079
      ** Has this record been inserted today?                                                 CSD079
                                                                                              CSD079
     C                   MOVEL     'N'           WURITD                                       CSD079
     C     WURDNB        IFEQ      QBLCD                                                      CSD079
     C     QBTYLC        IFEQ      'I'                                                        CSD079
     C                   MOVEL     'Y'           WURITD                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C     WURITD        IFEQ      'Y'                                                        CSD079
     C                   MOVEL     'I'           QBTYLC                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     A_PMTYLC      QBTYLC                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Move all fields to @PLCSL0                                                           CSD079
                                                                                              CSD079
     C                   EVAL      QBPFM7 =A_PMPFM7                                           CSD079
     C                   EVAL      QBPFM8 =A_PMPFM8                                           CSD079
     C                   EVAL      QBPFM9 =A_PMPFM9                                           CSD079
                                                                                              CSD079
     C                   UPDATE    @PLCSL0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Update                                                        CSD079
                                                                                              CSD079
     C                   Z-ADD     *ZERO         WUNORC                                       CSD079
     C                   Z-ADD     1             WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     *ZERO         WUNODL                                       CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Delete Processing                                                                    CSD079
      ** Database Error If Delete, but record not present                                     CSD079
                                                                                              CSD079
     C     A_PMTYLC      IFEQ      'D'                                                       BG12238
     C*****A_CUTYLC      IFEQ      'D'                                                CRE026 BG12238
     C     *IN95         ANDEQ     *OFF                                                       CSD079
      *                                                                                       CSD079
     C                   DELETE    @PLCSL0                                                    CSD079
                                                                                              CSD079
      ** USER: Processing after Delete                                                        CSD079
                                                                                              CSD079
     C                   MOVEL     B_CUPMF       WUDELR                                       CSD079
                                                                                              CSD079
      ** Write Deleted Record - SD Deleted Records File                                       CSD079
                                                                                              CSD079
     C                   CLEAR                   PBRC                                         CSD079
     C                   MOVEL     'SDPLCSPD'    PBFNME                                       CSD079
     C                   MOVEL     A_PMCUST      PBLKEY                                       CSD079
     C                   MOVEL     WUDR01        PBDR01                                       CSD079
     C                   MOVEL     WUDR02        PBDR02                                       CSD079
     C                   MOVEL     WUDR03        PBDR03                                       CSD079
     C                   MOVEL     WUDR04        PBDR04                                       CSD079
     C                   MOVEL     WUDR05        PBDR05                                       CSD079
     C                   MOVEL     WUDR06        PBDR06                                       CSD079
     C                   MOVEL     WUDR07        PBDR07                                       CSD079
     C                   MOVEL     WUDR08        PBDR08                                       CSD079
     C                   MOVEL     WUDR09        PBDR09                                       CSD079
     C                   MOVEL     WUDR10        PBDR10                                       CSD079
     C                   MOVEL     WUDR11        PBDR11                                       CSD079
     C                   MOVEL     WUDR12        PBDR12                                       CSD079
     C                   MOVEL     WURDNB        PBLCD                                        CSD079
     C                   MOVEL     'D'           PBTYLC                                       CSD079
                                                                                              CSD079
     C                   CALL      'SD0520X'                                                  CSD079
     C                   PARM      *BLANK        @RTCD                                        CSD079
     C                   PARM                    PBRC                                         CSD079
                                                                                              CSD079
      ** Error detected?                                                                      CSD079
                                                                                              CSD079
     C     @RTCD         IFEQ      '*ERROR*'                                                  CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     A_PMCUST      DBKEY                                        CSD079
     C                   MOVEL     'SDDELRL0'    DBFILE                                       CSD079
     C                   MOVEL     043           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   Z-ADD     -1            WUNORC                                       CSD079
     C                   Z-ADD     *ZERO         WUNOAM                                       CSD079
     C                   Z-ADD     *ZERO         WUNOIN                                       CSD079
     C                   Z-ADD     1             WUNODL                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Change Standing Data Cont - Standing Data Controls                                   CSD079
                                                                                              CSD079
     C                   MOVEL     'SDPLCSPD'    WFLNAME                                      CSD079
     C                   EXSR      SNCHRC                                                     CSD079
      *                                                                                       CSD079
     C                   ENDSR                                                                CSD079
      *                                                                                       CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDRWN - Update Customer Risk Weighted Assets                *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDRWN        BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDRWANUPD'                                                CSD079
                                                                                              CSD079
      ** Ensure correct parameters for this UPD function                                      CSD079
                                                                                              CSD079
     C                   PARM      *BLANKS       @RTCD                                        CSD079
     C                   PARM                    SDVCURW                                      CSD079
     C                   PARM      'Y'           From_Cust                                    CSD079
                                                                                              CSD079
      ** If there were any errors in the update functions,                                    CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANK                                                     CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     BBCUST        DBKEY                                        CSD079
     C                   MOVEL     'SDCRWAPD'    DBFILE                                       CSD079
     C                   MOVEL     071           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  UPDCUX2 - Update Lux(European Reporting)Customer file        *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDCUX2       BEGSR                                                                CSD079
                                                                                              CSD079
     C     ACTN          IFNE      'I'                                                        CSD079
     C                   EVAL      WFIND = 'Y'                                                CSD079
     C                   ELSE                                                               BUG13594
     C                   EVAL      WFIND = *BLANKS                                          BUG13594
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_#6LXVFCUST = A_CUCUST                                  BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C                   CALLB     'SDCUSD2UP'                                                CSD079
                                                                                              CSD079
      ** Ensure correct parameters for this UPD function                                      CSD079
                                                                                              CSD079
     C                   PARM                    ACTN                                         CSD079
     C                   PARM                    @RTCD                                        CSD079
     C                   PARM                    WFIND                                        CSD079
     C                   PARM                    SDVCUEU                                      CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
                                                                                              CSD079
      ** If there were any errors in the update functions                                     CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANK                                                     CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     VFCUST        DBKEY                                        CSD079
     C                   MOVEL     'SDCUX2PD'    DBFILE                                       CSD079
     C                   MOVEL     052           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * UPDCUX1 - Update Lux(IBLC - Extended Information)Customer file*                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     UPDCUX1       BEGSR                                                                CSD079
                                                                                              CSD079
     C     ACTN          IFNE      'I'                                                        CSD079
     C                   EVAL      WFIND = 'Y'                                                CSD079
     C                   ELSE                                                               BUG13594
     C                   EVAL      WFIND = *BLANKS                                          BUG13594
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      A_#LLXCUCNUM = A_CUCUST                                  BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C                   CALLB     'SDCUSD3UP'                                                CSD079
                                                                                              CSD079
      ** Ensure correct parameters for this UPD function                                      CSD079
                                                                                              CSD079
     C                   PARM                    ACTN                                         CSD079
     C                   PARM                    @RTCD                                        CSD079
     C                   PARM                    WFIND                                        CSD079
     C                   PARM                    SDVCUIB                                      CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
                                                                                              CSD079
      ** If there were any errors in the update functions                                     CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANK                                                     CSD079
     C                   MOVEL     *BLANK        DBKEY                                        CSD079
     C                   MOVEL     CUCNUM        DBKEY                                        CSD079
     C                   MOVEL     'SDCUX1PD'    DBFILE                                       CSD079
     C                   MOVEL     053           DBASE                                        CSD079
     C                   EXSR      SRERR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
     C*****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * SRADWTCH - Set-up parameter and send Additional Customer      *                       CSD079
      *          details to Compliance Watch by calling the Engine    *                       CSD079
      *          program for Standing Data Authorisation enhancement  *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     SRADWTCH      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Set-up first parameter for Compliance Engine                                         CSD079
                                                                                              CSD079
     C                   EVAL      PDSWLTD = *BLANKS                                          CSD079
     C                   EVAL      W4AMT1 = 0                                                 CSD079
     C                   EVAL      W4AMT2 = 0                                                 CSD079
     C                   EVAL      W4ITEM = 'SDCUSA'                                          CSD079
     C                   EVAL      W4IDEN = E5CUST                                            CSD079
     C                   EVAL      W4BRCH = BBBRCD                                            CSD079
     C                   EVAL      W4FUNT = 'SDACUSPD'                                        CSD079
     C                   EVAL      W4CNUM = E5CUST                                            CSD079
                                                                                              CSD079
      ** Get Main System Prefix from data area SC24X7 if enhancement                          CSD079
      ** CSC011 is installed, else get it from SDSTAT                                         CSD079
                                                                                              CSD079
     C                   IF        CSC011 = 'Y'                                               CSD079
     C                   EVAL      W4SYSM = S1MAIN                                            CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      W4SYSM = LIBR                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If Concord Interface Development is installed (CCF001)                               CSD079
                                                                                              CSD079
     C                   IF        CCF001 = 'Y'                                               CSD079
                                                                                              CSD079
      ** If Corporate Customer is 'Y'                                                         CSD079
                                                                                              CSD079
     C                   IF        BBCRPC = 'Y'                                               CSD079
     C                   EVAL      W4CTYP = 'C'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      W4CTYP = 'I'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** If Local Industry Code is not blank or not equal to any                              CSD079
      ** of the five Private Customer Industry Code                                           CSD079
                                                                                              CSD079
     C                   IF        BBLICD <> *BLANKS                                          CSD079
     C                             AND BBLICD <> W1IND1                                       CSD079
     C                             AND BBLICD <> W1IND2                                       CSD079
     C                             AND BBLICD <> W1IND3                                       CSD079
     C                             AND BBLICD <> W1IND4                                       CSD079
     C                             AND BBLICD <> W1IND5                                       CSD079
     C                   EVAL      W4CTYP = 'C'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      W4CTYP = 'I'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Get the Counter Party (Midas Report Name + Customer Report Town)                     CSD079
                                                                                              CSD079
     C                   MOVEL     BBCRNM        W4CUST                                       CSD079
     C                   MOVE      BBCRTN        W4CUST                                       CSD079
                                                                                              CSD079
      ** Get converted dates                                                                  CSD079
                                                                                              CSD079
     C                   MOVE      '00000'       PINDATE                                      CSD079
     C                   EXSR      SRCVTDATE                                                  CSD079
     C                   MOVE      PCVTDDATE     W4DDAT                                       CSD079
                                                                                              CSD079
     C                   MOVE      '00000'       PINDATE                                      CSD079
     C                   EXSR      SRCVTDATE                                                  CSD079
     C                   MOVE      PCVTDDATE     W4VDAT                                       CSD079
                                                                                              CSD079
     C                   MOVE      '00000'       PINDATE                                      CSD079
     C                   EXSR      SRCVTDATE                                                  CSD079
     C                   MOVE      PCVTDDATE     W4MDAT                                       CSD079
                                                                                              CSD079
      ** Set-up second parameter for Compliance Engine                                        CSD079
                                                                                              CSD079
     C                   EVAL      PDSXML = *BLANKS                                           CSD079
                                                                                              CSD079
      ** Set-up Customer Name                                                                 CSD079
                                                                                              CSD079
     C                   IF        A_ADCNA1 <> B_E5CNA1                                       CSD079
     C                             OR WUNCF1 = 'Y'                                            CSD079
     C                   IF        A_ADCNA1 <> *BLANKS                                        CSD079
     C                   CAT       ARRTAG(1):0   PDSXML                                       CSD079
     C                   CAT       A_ADCNA1:0    PDSXML                                       CSD079
     C                   CAT       ARRTAG(2):0   PDSXML                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set-up Address Lines                                                                 CSD079
                                                                                              CSD079
     C                   IF        A_ADCNA2 <> B_E5CNA2                                       CSD079
     C                             OR A_ADCNA3 <> B_E5CNA3                                    CSD079
     C                             OR A_ADCNA4 <> B_E5CNA4                                    CSD079
     C                             OR WUNCF1 = 'Y'                                            CSD079
     C                   EVAL      WADDAL = *BLANKS                                           CSD079
     C                   CAT       A_ADCNA2:0    WADDAL                                       CSD079
     C                   CAT       A_ADCNA3:1    WADDAL                                       CSD079
     C                   CAT       A_ADCNA4:1    WADDAL                                       CSD079
     C                   IF        WADDAL <> *BLANKS                                          CSD079
     C                   CAT       ARRTAG(3):0   PDSXML                                       CSD079
     C                   CAT       WADDAL:0      PDSXML                                       CSD079
     C                   CAT       ARRTAG(4):0   PDSXML                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set-up Identity Number                                                               CSD079
                                                                                              CSD079
     C                   IF        A_ADIDNO <> B_E5IDNO                                       CSD079
     C                             OR WUNCF1 = 'Y'                                            CSD079
     C                   IF        A_ADIDNO <> *BLANKS                                        CSD079
     C                   CAT       ARRTAG(11):0  PDSXML                                       CSD079
     C                   CAT       A_ADIDNO:0    PDSXML                                       CSD079
     C                   CAT       ARRTAG(12):0  PDSXML                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set-up Date of Birth                                                                 CSD079
                                                                                              CSD079
     C                   IF        A_ADBRTH <> B_E5BRTH                                       CSD079
     C                             OR WUNCF1 = 'Y'                                            CSD079
     C                   IF        A_ADBRTH > 0                                               CSD079
                                                                                              CSD079
      ** Convert Day No to DDMMMYY format                                                     CSD079
                                                                                              CSD079
     C                   CALLB     'ZDATE2'                                                   CSD079
     C                   PARM                    A_ADBRTH                                     CSD079
     C                   PARM                    BJDFIN                                       CSD079
     C                   PARM      *ZEROS        ZDATE                                        CSD079
     C                   PARM      *BLANK        ZADATE                                       CSD079
      *                                                                                       CSD079
     C                   CAT       ARRTAG(13):0  PDSXML                                       CSD079
     C                   CAT       ZADATE:0      PDSXML                                       CSD079
     C                   CAT       ARRTAG(14):0  PDSXML                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Send transaction details to Compliance Watch                                         CSD079
                                                                                              CSD079
     C                   IF        PDSXML <> *BLANKS                                          CSD079
     C                   CALL      'SDCWLCHK'                                                 CSD079
     C                   PARM                    PDSWLTD                                      CSD079
     C                   PARM                    PDSXML                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  259191
      *****************************************************************                    AR1086546
      *                                                               *                    AR1086546
      *  UPDCTNM - Update Currency/Time of Netting Details            *                    AR1086546
      *                                                               *                    AR1086546
      *****************************************************************                    AR1086546
     C     UPDCTNM       BEGSR                                                             AR1086546
                                                                                           AR1086546
     C                   CALLB     'SDCTNMUPD'                                             AR1086546
                                                                                           AR1086546
      ** Ensure correct parameters for this UPD function                                   AR1086546
                                                                                           AR1086546
     C                   PARM      *BLANKS       @RTCD                                     AR1086546
     C                   PARM                    SDVCTNM                                   AR1086546
     C                   PARM      'Y'           From_Cust                                 AR1086546
                                                                                           AR1086546
      ** If there were any errors in the update functions,                                 AR1086546
                                                                                           AR1086546
     C     @RTCD         IFNE      *BLANK                                                  AR1086546
     C                   MOVEL     *BLANK        DBKEY                                     AR1086546
     C                   MOVEL     BBCUST        DBKEY                                     AR1086546
     C                   MOVEL     'SDCTNMPD'    DBFILE                                    AR1086546
     C                   MOVEL     072           DBASE                                     AR1086546
     C                   EXSR      SRERR                                                   AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
     C                   ENDSR                                                             AR1086546
                                                                                           AR1086546
      *****************************************************************                    AR1086546
**  CPY@
(c) Finastra International Limited 2001
** CMD1                                                                                       CSD012
OVRDBF FILE(SDCDSHL0) TOFILE(SDCDSHL0) SHARE(*NO)                                             CSD012
** CMD2                                                                                       CSD012
OVRDBF FILE(SDCBSHL0) TOFILE(SDCBSHL0) SHARE(*NO)                                             CSD012
** CMD3                                                                                       CSD012
OVRDBF FILE(SDPBSHL0) TOFILE(SDPBSHL0) SHARE(*NO)                                             CSD012
** CMD4                                                                                      BUG3362
OVRDBF FILE(SDTDSHL0) TOFILE(SDTDSHL0) SHARE(*NO)                                            BUG3362
** CMD5                                                                                     BUG14969
OVRDBF FILE(SDSWSHL0) TOFILE(SDSWSHL0) SHARE(*NO)                                           BUG14969
** CMDXC                                                                                      CGL132
OVRDBF FILE(SDCUSXL0) TOFILE(SDCUSXL0) SHARE(*NO)                                             CGL132
** CMDNH                                                                                    MD027115
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)                                           MD027115
** CMDCS                                                                                    MD027115
OVRDBF FILE(SDFTCSL0) TOFILE(SDFTCSL0) SHARE(*NO)                                           MD027115
** CMDCR                                                                                    MD051230
OVRDBF FILE(SDCRSHL1) TOFILE(SDCRSHL1) SHARE(*NO)                                           MD051230
**  ARRTAG                                                                                    CSD015
<Customer Name>                                                                               CSD015
</Customer Name>                                                                              CSD015
<Address Lines>                                                                               CSD015
</Address Lines>                                                                              CSD015
<SWIFT BIC>                                                                                   CSD015
</SWIFT BIC>                                                                                  CSD015
<Country of Citizenship>                                                                      CSD015
</Country of Citizenship>                                                                     CSD015
<Country of Domicile>                                                                         CSD015
</Country of Domicile>                                                                        CSD015
<Identity Number>                                                                             CSD079
</Identity Number>                                                                            CSD079
<Date of Birth>                                                                               CSD079
</Date of Birth>                                                                              CSD079
** #@VC                                                                                       CSD027
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                                                          CSD027
