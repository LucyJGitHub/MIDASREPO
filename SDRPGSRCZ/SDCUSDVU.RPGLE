     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate & Update')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data  ILE Module                            *
      *                                                               *
      *  SDCUSDVU - Customer details validate and update              *
      *                                                               *
      *  Function: This program validates customer details for input  *
      *            into the Midas database.                           *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD042966           Date 20Dec16               *
      *  Prev Amend No. MD042692           Date 20Dec16               *
      *                 MD042407           Date 07Nov16               *
      *                 CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 MD034317           Date 17Jul15               *
      *                 MD034876           Date 03Jul15               *
      *                 AR684053           Date 03Jun15               *
      *                 AR316373           Date 03Jun15               *
      *                 CER070             Date 24Nov14               *
      *                 CSW214             Date 24Nov14               *
      *                 MD030956           Date 09Oct14               *
      *                 MD029805           Date 05Sep14               *
      *                 MD027584           Date 17Jun14               *
      *                 MD027213           Date 05Jun14               *
      *                 TI010338           Date 21May13               *
      *                 TI010224           Date 16May13               *
      *                 MD027296           Date 02Jun14               *
      *                 MD026997           Date 29May14               *
      *                 MD026753B          Date 29May14               *
      *                 MD026705           Date 29May14               *
      *                 MD026693           Date 22May14               *
      *                 MD026550A          Date 22May14               *
      *                 MD026550           Date 22May14               *
      *                 MD026497           Date 27Apr14               *
      *                 MD026519           Date 12May14               *
      *                 MD026540           Date 13May14               *
      *                 MD026458           Date 24Apr14               *
      *                 CGL132             Date 01May13               *
      *                 MD026253           Date 08Apr14               *
      *                 MD024991           Date 24Mar14               *
      *                 AR811594           Date 10Aug11               *
      *                 MD022463           Date 27Sep13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD021813           Date 28Aug13               *
      *                 AR1086546          Date 08Jul13               *
      *                 MD021617           Date 08Aug13               *
      *                 AR1093456          Date 04Mar13               *
      *                 262859B            Date 01Aug12               *
      *                 263079             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR971184A          Date 13Jun12               *
      *                 AR971184           Date 28May12               *
      *                 AR971167           Date 16May12               *
      *                 AR970389           Date 15May12               *
      *                 AR917747           Date 27Feb12               *
      *                 AR913994           Date 15Feb11               *
      *                 AR855391           Date 27Oct11               *
      *                 CER049             Date 06Dec10               *
      *                 CSD090             Date 06Dec10               *
      *                 AR784700           Date 07Jun11               *
      *                 AR745923           Date 12May11               *
      *                 AR743761           Date 16Apr11               *
      *                 AR741363           Date 15Apr11               *
      *                 AR740758           Date 04Apr11               *
      *                 AR740196           Date 03Apr11               *
      *                 AR739736           Date 01Apr11               *
      *                 AR739532           Date 30Mar11               *
      *                 AR728530           Date 07Mar11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22143           Date 14Jan09               *
      *                 256330             Date 01Sep08               *
      *                 BUG21091           Date 25Sep08               *
      *                 BUG16705           Date 04Mar08               *
      *                 BUG15872           Date 12Feb08               *
      *                 BUG14803           Date 06Sep07               *
      *                 BUG15314           Date 22Nov07               *
      *                 BUG14485           Date 31Jul07               *
      *                 BUG14161           Date 15Jun07               *
      *                 BUG14104A          Date 09Jun07               *
      *                 BUG13595           Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13525           Date 05Mar07               *
      *                 CSD079             Date 05Feb07               *
      *                 BG12238            Date 24Oct06               *
      *                 CRE026             Date 06Jun06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 08Jun07               *
      *                 249593             Date 22Aug07               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD028             Date 22Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5870            Date 14Feb05               *
      *                 BUG4742            Date 07Feb05               *
      *                 CSC022             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5082            Date 02Dec04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4196            Date 08Sep04               *
      *                 BUG3362            Date 28Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 222373             Date 24Oct03               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042966 - FATCA US Indicia are not updated upon             *
      *             complete                                          *
      *  MD042692 - Serious midas error occurred after pressing       *
      *             complete during customer insert                   *
      *  MD042407 - Creation Date field is missing when CGL132 is     *
      *             switched off ; reversed MD034317 fix              *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field                             *
      *  MD034317 - Added CGL132 to the parameter when calling        *
      *             SDCUSD2VL                                         *
      *  MD034876 - BOE Upgrade to FBM2.1 Compatibility Amendments    *
      *  AR684053 - Cannot enter a new customer. Applied AR665308.    *
      *  AR665308 - Error message BYM0071 incorrectly issues.         *
      *             Set values in Ds/Data that are used in BYCUSDW0VL.*
      *  AR316373 - BOE @ MPlus - BOE cust dtls are not displayed in  *
      *             java wrapped function. Add validation for the     *
      *             additional fields and update the extension file.  *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  MD027584 - Validation issues with Override comments          *
      *  MD027213 - GIIN field not populate on input                  *
      *  TI010338 - Validation is expected when Parent Indicator is   *
      *             set to 'P' and TI tab is filled. Applied for      *
      *             MD026906.                                         *
      *  TI010224 - Amended fields were being deleted after clicking  *
      *             confirm authorize. Applied for MD026906.          *
      *  MD027296 - Serious MIDAS Error on Confirm Authorise of Newly *
      *             Inserted Customers                                *
      *  MD026997 - Only check US TIN if subject to reporting is 'Y'  *
      *             for Customers/Non-Account Holders created after   *
      *             FATCA Effective Date                              *
      *  MD026753B - FAUTIN not updated properly                      *
      *  MD026705 - Authority Holder Indicia                          *
      *  MD026693 - FATCA Info complete flag error                    *
      *  MD026550A - Fix parameters on call to SDFTCS5VL              *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  MD026497 - Inappropriate Exception Message appears upon      *
      *             Customer/Non-Account Holder Insert                *
      *  MD026519 - US Indicia Auto Update                            *
      *  MD026540 - Validate Country of TIN againsts Country of       *
      *             Domicile passed                                   *
      *  MD026458 - Parameter mismatch on SDCUSDVU                    *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD026253 - Added Authority Holder is not displayed after     *
      *             Amendment Authorisation                           *
      *  MD024991 - Error appears upon deleting customer.             *
      *           - Do not perform defaulting if action code is 'D'.  *
      *           - Do not perform validation if action code is 'D'.  *
      *  AR811594 - Defaulf entry of Customer details by Country of   *
      *             Tax for a taxable customer is not automatically   *
      *             generated (Child: AR811595)                       *
      *  MD022463 - No screen is displayed to show Bank Directory     *
      *             Plus Detail Screen on Linked Customers during     *
      *             Amend and Enquire                                 *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD021813 - BankFusion_FX Netting:CDL025 Missing Menu Options *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813                             *
      *  MD021617 - A serious Midas error has occurred on amending    *
      *             transactions                                      *
      *  AR1093456 - Basel II Customer field defaults to N            *
      *  262859B- Decimal data error encountered in SDCUSDUPD. Fix is *
      *           to initialize ValidCufn to prevent error.           *
      *  263079 - Past due flag - allow blank, Y and N to be accepted.*
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR971184A - Additional Coding. V_PBFRNT should not be blank  *
      *              during amend.                                    *
      *            - Applied fix for AR989192 (Child:AR989193)        *
      *            - During Amend Front Ofc Id must be updated with   *
      *              the new one                                      *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  AR971167 - Invalid parameters for call of SDCUSDCVT          *
      *             This provokes some decimal data error when send   *
      *             of customer from external system through JMS API  *
      *             (Child:AR971168) (Recompile)                      *
      *  AR970389 - No validation should be made if there are no      *
      *             changes made under Portfolio Management tab       *
      *             (Child:AR970392)                                  *
      *  AR917747 - CUSD returning multiple warning message for the   *
      *             same error in IBEI. (Recompile)                   *
      *  AR913994 - Cannot input Customer if Joint Acct Type is       *
      *             Y or I                                            *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  CER049 - Stamp Tax                                           *
      *  CSD090 - Customer Segmentation                               *
      *  AR784700  - REC62N 00001 failed                              *
      *  AR745923 - Tax not collected on joint customer with no       *
      *             member/s (Child: AR745924)                        *
      *  AR743761  - The pay/rec confirmation job DLC0211 encountered *
      *              a DB Error (Child:AR743762)                      *
      *  AR741363 - Cannot close or delete customer (Child: AR741364) *
      *  AR740758 - System does not validate customer's individual    *
      *             threshold in CUSD against Country of Tax Code     *
      *             definition (Child: AR740759)                      *
      *  AR740196  - Cannot enquire on deal for non-resident using    *
      *              Deals Enquiry (Child:AR740197)                   *
      *  AR739736 - USR4761: Joint Account Type cannot be "I"         *
      *             Customer is a Bank (Child:AR739761)               *
      *  AR739532 - CUSD Error issued if State code has value         *
      *             (Child: AR739533)                                 *
      *  AR728530 - Country of Tax should be not available when joint *
      *             account type = 'N' (Child:AR728531)               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22143 - Missing authorization field in repository.        *
      *  256330 - Recompiled due to change in APDUMP under PSSR_ILE.  *
      *  BUG21091 - Error occurs when encoding "SWIFT" in the default *
      *             network                                           *
      *  BUG16705 - The system should automatically generate customer *
      *             number if field is blank                          *
      *  BUG15872 - Parameter mismatch. Applied fix BUG14992          *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *  BUG15314 - A "serious Midas error" occurred upon clicking    *
      *             Confirm authorise in CUSD (Recompile)             *
      *  BUG14803 - XML Input falls into Repair Queue due             *
      *             to field mismatched.                              *
      *  BUG14485 - MidasPlus Definition for CUSD is not in synch     *
      *             with that of API XML definition.                  *
      *             Applied fixes are BUG14228 & 243781               *
      *  BUG14161 - MidasPlus error encountered when authorising a    *
      *             new Wholesale Customer                            *
      *  BUG14104A - MidasPlus error encountered when authorising a   *
      *              new Wholesale Customer                           *
      *  BUG13595 - European Reporting fields not being populated     *
      *             properly during edit mode                         *
      *  BUG13525 - ECSD Mismatch between XML and RPG (Recompile)     *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  BG12238 - Conditional writes to files within wholesale/      *
      *            universal customer input                           *
      *  CRE026 - Consumer Banking                                    *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  249593 - Add parameters on call to SDCUSDRTV to prevent      *
      *           parameter mismatch.                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5870- Extension data processing added                     *
      *  BUG4742- Read to SDCUSDR so API returns correct paramaters   *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5082 - Fix to Bug 3362                                    *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4196- Stop changes being overwrite by other users         *
      *  BUG3362 - Added TI details for CSD012(Standing Data Autho-   *
      *            risation).                                         *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)                                       CSD079
      ** RSQ : Midas SD Branch codes by customer number                                       CSD079

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

     F/COPY WNCPYSRC,SDH00572
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *                                                                                     AR316373
      ** Datastructure to define input parameter DATA                                       AR316373
      *                                                                                     AR316373
      /COPY QWINDSRC,SDCUSDDTA                                                              AR316373

     D CUAHArrDS       DS                                                                     CER059
     D***CUAHArr                      22A   DIM(50)                                    CER059 CGL132
     D  CUAHArr                      26A   DIM(50)                                            CGL132
                                                                                              CER059
     D CCTXArrDS       DS                                                                     CER059
     D  CCTXArr                      51A   DIM(50)                                            CER059
                                                                                              CER059
     D V_CUAHArr       S                   DIM(50) LIKE(ValidCUAH)                            CER059
     D V_CCTXArr       S                   DIM(50) LIKE(ValidCCTX)                            CER059
                                                                                              CER059
      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(SDCUPRPD)
     D TranInSwft    E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D TranInSeco    E DS                  EXTNAME(SDCUSEPD)
     D TranInMsrt    E DS                  EXTNAME(SDCUMRPD)
     D TranInBrTx    E DS                  EXTNAME(SDCUBRPD)
     D   TranInBrT1            1    500
     D   TranInBrT2          501    693
     D TranInPriv    E DS                  EXTNAME(SDCUPBPD)
     D TranInMT3X    E DS                  EXTNAME(SDCUMTPD)                                BUG14485
     D                                     PREFIX(MT)                                       BUG14485
     D TranInCumi    E DS                  EXTNAME (SDCUMIPD)                                 CSD079
     D                                     PREFIX(MI)                                         CSD079
     D TranInCuad    E DS                  EXTNAME (SDCUADPD)                                 CSD079
     D                                     PREFIX(AD)                                         CSD079
     D TranInAdd1              1    500                                                       CSD079
     D TranInAdd2            501   1000                                                       CSD079
     D***TranInAdd3            1001   1281                                           CSD079 BUG14992
     D***TranInAdd3         1001   1316                                           BUG14992 AR1093456
     D TranInAdd3           1001   1317                                                    AR1093456
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D                                     PREFIX(AD)                                         CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
     D                                     PREFIX(AD)                                         CER059
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCUA1              1    500                                                       CER059
     D TranInCUA2            501   1000                                                       CER059
     D***TranInCUA3           1001   1100                                            CER059 MD026458
     D TranInCUA3           1001   1300                                                     MD026458
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D TranInCCT1              1    500                                                       CER059
     D TranInCCT2            501   1000                                                       CER059
     D TranInCCT3           1001   1500                                                       CER059
     D TranInCCT4           1501   2000                                                       CER059
     D TranInCCT5           2001   2500                                                       CER059
     D TranInCCT6           2501   2550                                                       CER059
     D***TranInCUAH1     DS            22                                              CER059 CGL132
     D TranInCUAH1     DS            26                                                       CGL132
     D TranInCCTX1   E DS                  EXTNAME (SDCCTXPD)                                 CER059
     D                                     PREFIX(TX)                                         CER059
     D TranInSfee    E DS                  EXTNAME (SDSFEEPD)                                 CSD079
     D                                     PREFIX(SFE)                                        CSD079
     D TranInChec    E DS                  EXTNAME (SDCHECPD)                                 CSD079
     D                                     PREFIX(CHE)                                        CSD079
     D TranInChe1              1    500                                                       CSD079
     D TranInChe2            501    511                                                       CSD079
     D TranInCusf    E DS                  EXTNAME (SDCUSFPD)                                 CSD079
     D                                     PREFIX(CUS)                                        CSD079
     D TranInCufx    E DS                  EXTNAME (SDCUFXPD)                                 CSD079
     D                                     PREFIX(FX)                                         CSD079
     D TranInCufd    E DS                  EXTNAME (SDCUFDPD)                                 CSD079
     D                                     PREFIX(FD)                                         CSD079
     D TranInRwan    E DS                  EXTNAME (SDRWANPD)                                 CSD079
     D                                     PREFIX(RW)                                         CSD079
     D TranInCufo    E DS                  EXTNAME (SDCUFOPD)                                 CSD079
     D                                     PREFIX(FO)                                         CSD079
     D TranInCupm    E DS                  EXTNAME (SDCUPMPD)                                 CSD079
     D                                     PREFIX(PM)                                         CSD079
     D TranInTicd    E DS                  EXTNAME (SDTICDPD)                                 CSD079
     D                                     PREFIX(TIC)                                        CSD079
     D TranInCurx    E DS                  EXTNAME (SDCURXPD)                                 CSD079
     D                                     PREFIX(RX)                                         CSD079
     D TranInCtnm    E DS                  EXTNAME (SDCCTNPD)                              AR1086546
     D                                     PREFIX(CT)                                      AR1086546
     D TranInCUXC    E DS                  EXTNAME (SDCUXCPD)                                 CGL132
     D                                     PREFIX(XC)                                         CGL132
     D TranInFTCR    E DS                  EXTNAME (SDFTCRPD)                                 CGL132
     D                                     PREFIX(FS)                                         CGL132

      * Valid Customer layout
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
     D                                     PREFIX(V_)
      * Current Customer - SWIFT Details  in File Format                                      CSW207
     D ValidSwft     E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
     D                                     PREFIX(V_)                                         CSW207
      * Current Customer Authority Holder File Format                                         CER059
     D ValidCUAH     E DS                  EXTNAME(SDVCUAHPD)                                 CER059
     D                                     PREFIX(V_)                                         CER059
      * Current Customer details by Country of tax File Format                                CER059
     D ValidCCTX     E DS                  EXTNAME(SDVCCTXPD)                                 CER059
     D                                     PREFIX(V_)                                         CER059
      * Valid Customer Private Banking details layout
     D ValidPriv     E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(V_)
      * Valid Customer BRT details layout
     D ValidCuBr     E DS                  EXTNAME(SDVCUBRPD)
     D                                     PREFIX(V_)

     D ValidTIcd     E DS                  EXTNAME(SDVTICDPD)                                BUG3362
     D                                     PREFIX(V_)                                        BUG3362
                                                                                             BUG3362
      ** Valid Marketing Info Details layout                                                  CSD079
     D ValidCumi     E DS                  EXTNAME (SDVCUMIPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Additional Customer Details layout                                             CSD079
     D ValidCuad     E DS                  EXTNAME (SDVCUADPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Service Fees Details layout                                                    CSD079
     D ValidSfee     E DS                  EXTNAME (SDVSFEEPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Cheques and Cards Details layout                                               CSD079
     D ValidChec     E DS                  EXTNAME (SDVCHECPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Safe Details layout                                                            CSD079
     D ValidCusf     E DS                  EXTNAME (SDVCUSFPD)                                CSD079
     D                                     PREFIX (V_CF)                                      CSD079
                                                                                              CSD079
      ** Valid Risk weighted assets layout                                                    CSD079
     D ValidRwan     E DS                  EXTNAME (SDVRWANPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Future and Option layout                                                       CSD079
     D ValidCufo     E DS                  EXTNAME (SDVCUFOPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Portfolio Management Details layout                                            CSD079
     D ValidCupm     E DS                  EXTNAME (SDVCUPMPD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Fn Details layout                                                              CSD079
     D ValidCufn     E DS                  EXTNAME (SDVFOX1PD)                                CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Lux(European Reporting) Details file                                           CSD079
     D ValidCulx2    E DS                  EXTNAME (SDVCULX2PD)                               CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CSD079
      ** Valid Lux(IBLC - Extended Information) Details file                                  CSD079
     D ValidCulx1    E DS                  EXTNAME (SDVCULX1PD)                               CSD079
     D                                     PREFIX (V_)                                        CSD079
                                                                                              CGL132
      ** Valid Customer extension layout                                                      CGL132
     D ValidCuxc     E DS                  EXTNAME (SDVCUXCPD)                                CGL132
     D                                     PREFIX (V_)                                        CGL132
                                                                                              CGL132
      ** Valid FATCA Customer Details layout                                                  CGL132
     D ValidFtcs     E DS                  EXTNAME (SDVFTCSPD)                                CGL132
     D                                     PREFIX (V_)                                        CGL132
                                                                                              CSD079
      ** Valid Currency/Time of Netting Details file                                       AR1086546
     D ValidCtnm     E DS                  EXTNAME (SDVCTNMPD)                             AR1086546
     D                                     PREFIX (V_)                                     AR1086546
      * (Current) Customer record in file Format
     D CustFilFmt    E DS                  EXTNAME(SDCUSTPD)
      * Current Customer - SWIFT Details  in File Format                                      CSW207
     D SwftFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
                                                                                              CSW207
      * (Current) Customer Private Banking details record in file Format
     D PrivFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(A_)
      * (Current) Customer BRT details record in file Format
     D BrtxFilFmt    E DS                  EXTNAME(SDCBRTPD)
      * (Current) BRT Participator history record in file Format
     D BrptFilFmt    E DS                  EXTNAME(PTYHSTPD)
     D                                     PREFIX(P)
                                                                                             BUG3362
     D TICdFilFmt    E DS                  EXTNAME(SDTICSPD)                                 BUG3362
      * (Current) TI Details in file Format                                                  BUG3362
                                                                                              CSD079
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
      ** (Current) Marketing Info Details in file Format                                      CSD079
                                                                                              CSD079
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
      ** (Current) Additional Customer Details in file Format                                 CSD079
                                                                                              CSD079
     D CCTXFilFmt    E DS                  EXTNAME(SDACTXPD)                                  CER059
      ** (Current) Customer Details by Country of tax in file Format                          CER059
                                                                                              CER059
     D CUAHFilFmt    E DS                  EXTNAME(SDCUAHPD)                                  CER059
     D                                     PREFIX(CU)                                         CER059
      ** (Current) Customer Authority Holder details in file Format                           CER059
                                                                                              CER059
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079
      ** (Current) Service Fees Details in file Format                                        CSD079
                                                                                              CSD079
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
      ** (Current) Cheques and Cards Details in file Format                                   CSD079
                                                                                              CSD079
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
      ** (Current) Safe Details in file Format                                                CSD079
                                                                                              CSD079
     D RwanFilFmt    E DS                  EXTNAME(SDCRWAPD)                                  CSD079
      ** (Current) Risk weighted assets in file Format                                        CSD079
                                                                                              CSD079
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D Q1SMAC        E                     EXTFLD(QQSMAC)                                     CSD079
      ** (Current) Future and Option in file Format                                           CSD079
                                                                                              CSD079
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
      ** (Current) Portfolio Management in file Format                                        CSD079
                                                                                              CSD079
     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CSD079
      ** (Current) Fn in file Format                                                          CSD079
                                                                                              CSD079
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CSD079
      ** (Current) Lux(European Reporting) in file format                                     CSD079
                                                                                              CSD079
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CSD079
      ** (Current) Lux(IBLC - Extended Information) in file format                            CSD079
                                                                                           AR1086546
     D CtnmFilFmt    E DS                  EXTNAME(SDCTNMPD)                               AR1086546
      ** (Current) Currency/Time of Netting Details                                        AR1086546
                                                                                              CGL132
     D CuXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                  CGL132
      ** (Current) Safe Details in file Format                                                CGL132
                                                                                              CGL132
     D CuFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                  CGL132
      ** (Current) Risk weighted assets in file Format                                        CGL132

      * (Current) Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D**********                           PREFIX(@)                                          CSD079
     D                                     PREFIX(C@)                                         CSD079
      * (Current) Customer in Screen Format - Primary Details                                 CSW207
     D CurCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D                                     PREFIX(@)                                          CSW207
                                                                                              CSD079
      * (Current) Customer in Screen Format - Secondary Details
     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D**********                           PREFIX(@)                                          CSD079
     D                                     PREFIX(D@)                                         CSD079
                                                                                              CSD079
      * (Current) Customer in Screen Format - Message Routing Details
     D CurCuMsrt     E DS                  EXTNAME(SDCUMRPD)
     D**********                           PREFIX(@)                                          CSD079
     D                                     PREFIX(E@)                                         CSD079
                                                                                              CSD079
      * (Current) Customer in Screen Format - Base Rate Tax Details
     D CurCuBrTx     E DS                  EXTNAME(SDCUBRPD)
     D**********                           PREFIX(@)                                          CSD079
     D                                     PREFIX(F@)                                         CSD079
                                                                                              CSD079
      * (Current) Customer in Screen Format - Private Banking Details
     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D**********                           PREFIX(@)                                          CSD079
     D                                     PREFIX(G@)                                         CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Marketing Info Details                         CSD079
     D CurCuCumi     E DS                  EXTNAME (SDCUMIPD)                                 CSD079
     D                                     PREFIX (I@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Additional Customer                            CSD079
     D CurCuCuad     E DS                  EXTNAME (SDCUADPD)                                 CSD079
     D                                     PREFIX (J@)                                        CSD079
     D CurCuACU3     E DS                  EXTNAME (SDACU3DPD)                                CER059
     D                                     PREFIX (J3@)                                       CER059
     D CurCuACU4     E DS                  EXTNAME (SDACU4DPD)                                CER059
     D                                     PREFIX (J4@)                                       CER059
     D CurCuCUAH     E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX (J5@)                                       CER059
     D CurCuCCTX     E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX (J5@)                                       CER059
     D CurCuCUXC     E DS                  EXTNAME (SDCUXCPD)                                 CGL132
     D                                     PREFIX (Y@)                                        CGL132
     D CurCuFTCR     E DS                  EXTNAME (SDFTCRPD)                                 CGL132
     D                                     PREFIX (Z@)                                        CGL132
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Service Fees                                   CSD079
     D CurCuSfee     E DS                  EXTNAME (SDSFEEPD)                                 CSD079
     D                                     PREFIX (K@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Cheques and Cards                              CSD079
     D CurCuChec     E DS                  EXTNAME (SDCHECPD)                                 CSD079
     D                                     PREFIX (L@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Safe Details                                   CSD079
     D CurCuCusf     E DS                  EXTNAME (SDCUSFPD)                                 CSD079
     D                                     PREFIX (M@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Fx Netting                                     CSD079
     D CurCuCufx     E DS                  EXTNAME (SDCUFXPD)                                 CSD079
     D                                     PREFIX (N@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Fiduciary Details                              CSD079
     D CurCuCufd     E DS                  EXTNAME (SDCUFDPD)                                 CSD079
     D                                     PREFIX (O@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Risk weighted assets                           CSD079
     D CurCuRwan     E DS                  EXTNAME (SDRWANPD)                                 CSD079
     D                                     PREFIX (P@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Future and Option                              CSD079
     D CurCuCufo     E DS                  EXTNAME (SDCUFOPD)                                 CSD079
     D                                     PREFIX (Q@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Portfolio Management                           CSD079
     D CurCuCupm     E DS                  EXTNAME (SDCUPMPD)                                 CSD079
     D                                     PREFIX (R@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - TI Details                                     CSD079
     D CurCuTicd     E DS                  EXTNAME (SDTICDPD)                                 CSD079
     D                                     PREFIX (S@)                                        CSD079
                                                                                              CSD079
      ** (Current) European Reporting & IBLC  Extended Information                            CSD079
      ** Screen Format - Details                                                              CSD079
     D CurCuCurx     E DS                  EXTNAME (SDCURXPD)                                 CSD079
     D                                     PREFIX (X@)                                        CSD079
                                                                                              CSD079
      ** (Current) Customer in Screen Format - Currency/Time of Netting                    AR1086546
     D CurCuCtnm     E DS                  EXTNAME (SDCCTNPD)                              AR1086546
     D                                     PREFIX (T@)                                     AR1086546
      ** Global Customer X-Reference - File Format                                            222373
     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 222373
      ** Current Customer in Screen Format - MT3xx BEI Details                                222373
     D CuMT3X        E DS                  EXTNAME(SDCUMTPD)                                  222373

     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * SD Customer details Extra Data - File (D/B) format

      * Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuMsrt      E DS                  EXTNAME(SDECUMRPD)
     D OKCuBrtx      E DS                  EXTNAME(SDECUBRPD)
     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
     D OKCuMT3x      E DS                  EXTNAME(SDECUMTPD)                               BUG14485
     D OKCuCumi      E DS                  EXTNAME (SDECUMIPD)                                CSD079
     D I_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuCuad      E DS                  EXTNAME (SDECUADPD)                                CSD079
     D                                     PREFIX(J_)                                         CSD079
     D OKCuACU3      E DS                  EXTNAME(SDEACU3PD)                                 CER059
     D OKCuACU4      E DS                  EXTNAME(SDEACU4PD)                                 CER059
     D OKCuACU5      E DS                  EXTNAME(SDEACU5PD)                                 CGL132
     D OKCuCUAH        DS             7                                                       CER059
     D OKCuCCTX      E DS                  EXTNAME(SDECCTXPD)                                 CER059
     D OKCuSfee      E DS                  EXTNAME (SDESFEEPD)                                CSD079
     D K_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuChec      E DS                  EXTNAME (SDECHECPD)                                CSD079
     D L_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuCusf      E DS                  EXTNAME (SDECUSFPD)                                CSD079
     D M_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuCufx      E DS                  EXTNAME (SDECUFXPD)                                CSD079
     D N_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuCufd      E DS                  EXTNAME (SDECUFDPD)                                CSD079
     D O_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuRwan      E DS                  EXTNAME (SDERWANPD)                                CSD079
     D P_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuCufo      E DS                  EXTNAME (SDECUFOPD)                                CSD079
     D Q_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D Q_DDSMACOK    E                     EXTFLD(DDSMACOK)                                   CSD079
     D OKCuCupm      E DS                  EXTNAME (SDECUPMPD)                                CSD079
     D R_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuTicd      E DS                  EXTNAME (SDETICDPD)                                CSD079
     D S_DDACTNOK    E                     EXTFLD(DDACTNOK)                                   CSD079
     D OKCuCuxc      E DS                  EXTNAME (SDECUXCPD)                                CGL132
     D OKCuFtcs      E DS                  EXTNAME (SDEFTCSPD)                                CGL132
     D OKCuCulx2     E DS                  EXTNAME (SDECULX2PD)                               CSD079
     D OKCuCulx1     E DS                  EXTNAME (SDECULX1PD)                               CSD079
      *                                                                                     AR316373
     D ValidBoE      E DS                  EXTNAME (SDVCUSDPE)                              AR316373
      *                                                                                     AR316373
     D FileBoE       E DS                  EXTNAME (BYCUSTX0)                               AR316373
     D  LCUSTX       E                     EXTFLD(LCUST)                                    MD034876
      *                                                                                     AR316373
     D OKCuBoE       E DS                  EXTNAME (SDECUSDPE)                              AR316373
     D OKCuCtnm      E DS                  EXTNAME (SDECTNMPD)                             AR1086546
     D T_DDACTNOK    E                     EXTFLD(DDACTNOK)                                AR1086546
     D T_DDCUSTOK    E                     EXTFLD(DDCUSTOK)                                AR1086546
     D T_DDNTCPOK    E                     EXTFLD(DDNTCPOK)                                AR1086546

     D RUNDAT        E DS            13                                                       CSD079
     D RDLUP                   1      2  0                                                    CSD079
     D RMLUP                   3      5                                                       CSD079
     D RYLUP                   6      7  0                                                    CSD079
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD079
      ** Second DS for access programs - long data structure                                  CSD079
                                                                                              CSD079
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)                                  222373
     D                                     PREFIX(X_)                                         CSD079
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  CSD079
      ** Data Structure for Portfolio Management Details                                      CSD079
     D TransInTot      DS          9999                                                       CSW213
     D  TransCUPR                          LIKE(TranInPrim)                                   CSW213
     D  TransCUSE                          LIKE(TranInSeco)                                   CSW213
     D  TransCUMT                          LIKE(TranInMT3X)                                   CSW213
     D  TransCUMR                          LIKE(TranInMsrt)                                   CSW213
     D  TransCUBR                          LIKE(TranInBrTx)                                   CSW213
     D  TransCUPB                          LIKE(TranInPriv)                                   CSW213
     D  TransCUMI                          LIKE(TranInCumi)                                   CSW213
     D  TransCUAD                          LIKE(TranInCuad)                                   CSW213
     D  TransACU3                          LIKE(TranInACU3)                                   CSW213
     D  TransACU4                          LIKE(TranInACU4)                                   CSW213
     D  TransSFEE                          LIKE(TranInSfee)                                   CSW213
     D  TransCHEC                          LIKE(TranInChec)                                   CSW213
     D  TransCUSF                          LIKE(TranInCusf)                                   CSW213
     D  TransCUFX                          LIKE(TranInCufx)                                   CSW213
     D  TransCUFD                          LIKE(TranInCufd)                                   CSW213
     D  TransCUFO                          LIKE(TranInCufo)                                   CSW213
     D  TransCUPM                          LIKE(TranInCupm)                                   CSW213
     D  TransTICD                          LIKE(TranInTicd)                                   CSW213
     D  TransCUSW                          LIKE(TranInSwft)                                   CSW213
     D  TransCURX                          LIKE(TranInCurx)                                   CSW213
     D  TransTimeStmp                      LIKE(@TimeStamp)                                   CSW213
     D  TransRWAN                          LIKE(TranInRwan)                                   CSW213
     D  TransStmpTax                       LIKE(TransStmTax)                                  CSW213
     D  TransAUTH                          LIKE(AAUTH)                                        CSW213
                                                                                              CSW213
     D TransInEx2      DS          9999                                                       CSW213
     D  TransCS13                          LIKE(SDSW13)                                       CSW213
     D  TransCUXC                          LIKE(SDCUXC)                                       CGL132
     D  TransFTCR                          LIKE(SDFTCR)                                       CGL132
                                                                                              CSW213
     D TransInEx3      DS          9999                                                       CSW213
     D  TransCARS              1   9999                                                       CSW213
                                                                                              CSW213
     D TransInEx4      DS          9999                                                       CSW213
     D  TransCUAH                          LIKE(TranInCUAH)                                   CSW213
     D  TransCCTX                          LIKE(TranInCCTX)                                   CSW213
     D SDSW13        E DS                  EXTNAME(SDSW13PD)                                  CSW213
     D**********                           PREFIX(S13)                               CSW213 MD022463
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                   MD022463
     D SDCUXC        E DS                  EXTNAME(SDCUXCPD)                                  CGL132
     D SDFTCR        E DS                  EXTNAME(SDFTCRPD)                                  CGL132
      ** Customer dtls Bank directory details                                                 CSW213
     D/COPY WNCPYSRC,SDH00575
                                                                                              CSD079
     D PDATA           DS          1024                                                       CSD079
     D #1CUST                  1      6                                                       CSD079
     D #1PAIN                  7      7                                                       CSD079
     D #1PCNB                  8     13                                                       CSD079
     D #1COLC                 15     16                                                       CSD079
     D #1LINC                 17     18                                                       CSD079
     D #1BRCD                 19     21                                                       CSD079
     D #1BNBI                 22     22                                                       CSD079
     D #2CNCZ                 23     24                                                       CSD079
     D #1FOTR                 45     64                                                       CSD079
     D #1TMST                 65     90Z                                                      CSD079
     D #1CRNM                 91    110                                                       CSD079
     D TimeTemp        S             26A   INZ('0001-01-01-00.00.00.000000')                  CSD079

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D*****Idx             S              3P 0                                               BUG5082
     D Idx             S              3P 0 INZ(0)                                            BUG5082

      ** Index for arrays of warning message ids etc
     D***** WIdx            S              3P 0                                              BUG5082
     D WIdx            S              3P 0 INZ(0)                                            BUG5082

      ** Index for arrays of error message ids etc in Amend validation
     D***** AmIdx           S              3P 0                                              BUG5082
     D AmIdx           S              3P 0 INZ(0)                                            BUG5082

      ** Field (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans507A       S            500A                                                    BUG14485
     D Trans5007       S            500A                                                      CSD079
     D Trans5008       S            500A                                                      CSD079
     D Trans508A       S            500A                                                      CSD079
     D Trans508B       S            500A                                                      CSD079
     D Trans5083       S            500A                                                      CER059
     D Trans5084       S            500A                                                      CER059
     D Trans5009       S            500A                                                      CSD079
     D Trans5010       S            500A                                                      CSD079
     D Trans501X       S            500A                                                      CSD079
     D Trans5011       S            500A                                                      CSD079
     D Trans5012       S            500A                                                      CSD079
     D Trans5013       S            500A                                                      CSD079
     D Trans5014       S            500A                                                      CSD079
     D Trans5015       S            500A                                                      CSD079
     D Trans5016       S            500A                                                      CSD079
     D TransSW         S            500A                                                    BUG14992
     D TransStmTax     S            500A                                                      CER049
     D Trans5017       S            500A                                                      CSD079
     D TransCUA1       S            500A                                                      CER059
     D TransCUA2       S            500A                                                      CER059
     D TransCUA3       S            500A                                                      CER059
     D TransCCT1       S            500A                                                      CER059
     D TransCCT2       S            500A                                                      CER059
     D TransCCT3       S            500A                                                      CER059
     D TransCCT4       S            500A                                                      CER059
     D TransCCT5       S            500A                                                      CER059
     D TransCCT6       S            500A                                                      CER059
     D RegData500      S            500A                                                      CSD079
     D Trans5018       S            500A                                                   AR1086546

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
     D RepSeco         S              1A   inz('N')
     D RepMsrt         S              1A   inz('N')
     D RepBrTx         S              1A   inz('N')
     D RepPriv         S              1A   inz('N')
     D RepCumi         S              1A   inz('N')                                           CSD079
     D RepCuad         S              1A   inz('N')                                           CSD079
     D RepACU3         S              1A   inz('N')                                           CER059
     D RepACU4         S              1A   inz('N')                                           CER059
     D RepCUAH         S              1A   inz('N')                                           CER059
     D RepCCTX         S              1A   inz('N')                                           CER059
     D RepSfee         S              1A   inz('N')                                           CSD079
     D RepChec         S              1A   inz('N')                                           CSD079
     D RepCusf         S              1A   inz('N')                                           CSD079
     D RepCufx         S              1A   inz('N')                                           CSD079
     D RepCufd         S              1A   inz('N')                                           CSD079
     D RepRwan         S              1A   inz('N')                                           CSD079
     D RepCufo         S              1A   inz('N')                                           CSD079
     D RepCupm         S              1A   inz('N')                                           CSD079
     D RepTicd         S              1A   inz('N')                                           CSD079
     D RepCurx         S              1A   inz('N')                                           CSD079

     D DBerrUpd        C                   CONST('DB error in CUSD API update')
                                                                                              222373
     D V_DDGCUS        S             10A                                                      222373
                                                                                              CLE025
     D CLE025          S              1                                                      BUG5082
     D CFX001          S              1                                                      BUG5082
     D PRTCD           S              7                                                      BUG5082
     D POPTN           S              7                                                      BUG5082
     D PSARD           S              6                                                      BUG5082
     D PMODE           S              1                                                      BUG5082

      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)                         BUG5082
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                          MD026519
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                          MD026519
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)                          MD026519
     D ##OV4           S             50    DIM(1) CTDATA PERRCD(1)                          MD026519
     D ##OV5           S             50    DIM(1) CTDATA PERRCD(1)                          MD026705
     D ##OV6           S             50    DIM(1) CTDATA PERRCD(1)                          MD026705
     DOVERRIDE1        S             28    INZ('OVRDBF FILE(SDTICSLR) TOFILE')
     DOVERRIDE2        S             22    INZ('(SDTICSL0) SHARE(*NO) ')
     DOVERRIDE3        S             50    INZ(' ')

      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
     D CSD079          S              1A   inz('N')                                           CSD079
     D S01425          S              1A   inz('N')                                           CSD079
     D CSD008          S              1A   inz('N')                                           CSD079
     D CDL002          S              1A   inz('N')                                           CSD079
     D CDL006          S              1A   inz('N')                                           CSD079
     D CGL018          S              1A   inz('N')                                           CSD079
     D ULX004          S              1A   inz('N')                                           CSD079
     D ULX043          S              1A   inz('N')                                           CSD079
     D ULX008          S              1A   inz('N')                                           CSD079
     D ULX012          S              1A   inz('N')                                           CSD079
     D ULX609          S              1A   inz('N')                                           CSD079
     D CSW207          S              1A                                                    BUG14992
     D CSD021          S              1A   inz('N')                                         BUG16705
     D CDL025          S              1A   inz('N')                                        AR1086546
     D CER034          S              1A   INZ('N')                                           CER059
     D CER038          S              1A   INZ('N')                                           CER059
     D CER041          S              1A   INZ('N')                                           CER059
     D CER045          S              1A   INZ('N')                                           CER059
     D CER047          S              1A   INZ('N')                                           CER059
     D CER048          S              1A   INZ('N')                                           CER059
     D CER054          S              1A   INZ('N')                                           CER059
     D CGL031          S              1A                                                    AR728530
     D CGL032          S              1A                                                    AR728530
     D CSD090          S              1A                                                      CSD090
     D CGL132          S              1A                                                      CGL132
                                                                                              CER059
     D DfltScrn1       S              1A   INZ('N')                                           CER059
     D Idy             S              3P 0 INZ(0)                                             CER059
     D PAuthNum        S              4S 0                                                    CER059
     D PErrorIndex     S              3P 0                                                    CER059
     D PAction         S              1A                                                      CER059
     D ParmMode        S              7A                                                      CER059
     D UpdKey          DS                                                                     CER059
     D  UpCust                 1      6                                                       CER059
     D  UpAuth                 7     16                                                       CER059
     D  UpLtyp                17     18                                                       CER059
                                                                                              CER059
     D DateIn          S              6A                                                      CER059
     D DaynoOut        S              5P 0                                                    CER059
                                                                                              CSC022
     D PTransType      S              4                                                       CSD028
     D W0RTN           S              7A                                                      CSD079
     D WUPMSC          S              1A                                                      CSD079
                                                                                              CSC022
     D hasDetails      S              1N                                                    AR743761
                                                                                            AR743761
      ** Stamp Tax details                                                                    CER049
     DTranInStamp      S             31A                                                      CER049
     D FillerBuf       S           5276A                                                      CSW213
     D***FillerBufEx2    S           8951A                                             CSW213 CGL132
     D FillerBufEx2    S           5980A                                                      CGL132
     D FillerBufEx3    S           9999A                                                      CSW213
     D FillerBufEx4    S           6898A                                                      CSW213
     D PPCOLC          S              2A                                                    MD026693
      ** +--------------------------------------+
                                                                                            MD026519
     D PReturn         S              7A                                                    MD026519
     D PTranID         S             10A                                                    MD026519
     D PSource         S              1A                                                    MD026519
     D PClass          S              5A                                                    MD026519
     D PRepType        S              1A                                                    MD026519
     D PTMode          S              1A                                                    MD026519
     D WMsgLen         S             15P 5 INZ(50)                                          MD026519
     D CTI006          S              1A                                                    MD030956
                                                                                            MD026519
     D PAPARM          DS           100                                                     MD042692
     D  PAMODE                 1      1                                                     MD042692
     D  PADOMC                 2      3                                                     MD042692
     D  PACNCZ                 4      5                                                     MD042692
     D  PACSSN                 6     15                                                     MD042692
     D  PACRNM                16     35                                                     MD042692
     D  PACRTN                36     45                                                     MD042692
     D  PAACCZ                46     47                                                     MD042692
     D  PAINSF                48     48                                                     MD042692
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *****COPY WNCPYSRC,SDCUSDC002                                                   BUG5082BUG5870
      /COPY WNCPYSRC,SDCUSDVU02

      *****************************************************************
      /EJECT
      *****************************************************************
                                                                                             BUG5082
      *****/COPY WNCPYSRC,SDCUSDC003                                                  BUG5082BUG5870

     C**********         MOVEL     Trans5001     TranInPrim                                   CSW213
     C**********         MOVEL     Trans5002     TranInSeco                                   CSW213
     C**********         MOVEL     Trans5003     TranInMsrt                                   CSW213
     C**********         MOVEL     Trans5004     TranInBrT1                                   CSW213
     C**********         MOVEL     Trans5005     TranInBrT2                                   CSW213
     C**********         MOVEL     Trans5006     TranInPriv                                   CSW213
     C**********         MOVEL     Trans507A     TranInMT3X                          BUG14485 CSW213
     C**********         MOVEL     Trans5007     TranInCumi                            CSD079 CSW213
     C**********         MOVEL     Trans5008     TranInAdd1                            CSD079 CSW213
     C**********         MOVEL     Trans508A     TranInAdd2                            CSD079 CSW213
     C**********         MOVEL     Trans508B     TranInAdd3                            CSD079 CSW213
     C**********         MOVEL     Trans5083     TranInACU3                            CER059 CSW213
     C**********         MOVEL     Trans5084     TranInACU4                            CER059 CSW213
     C**********         MOVEL     Trans5009     TranInSfee                            CSD079 CSW213
     C**********         MOVEL     Trans5010     TranInChe1                            CSD079 CSW213
     C**********         MOVEL     Trans501X     TranInChe2                            CSD079 CSW213
     C**********         MOVEL     Trans5011     TranInCusf                            CSD079 CSW213
     C**********         MOVEL     Trans5012     TranInCufx                            CSD079 CSW213
     C**********         MOVEL     Trans5013     TranInCufd                            CSD079 CSW213
     C**********         MOVEL     Trans5014     TranInCufo                            CSD079 CSW213
     C**********         MOVEL     Trans5015     TranInCupm                            CSD079 CSW213
     C**********         MOVEL     Trans5016     TranInTicd                            CSD079 CSW213
     C**********         MOVEL     TransSW       TranInSwft                          BUG14992 CSW213
     C**********         MOVEL     RegData500    TranInCurx                            CSD079 CSW213
     C**********         MOVEL     Trans5017     TranInRwan                            CSD079 CSW213
     C**********         MOVEL     TransStmTax   TranInStamp                           CER049 CSW213
     C**********         MOVEL     TransCUA1     TranInCUA1                            CER059 CSW213
     C**********         MOVEL     TransCUA2     TranInCUA2                            CER059 CSW213
     C**********         MOVEL     TransCUA3     TranInCUA3                            CER059 CSW213
     C**********         MOVEL     TransCCT1     TranInCCT1                            CER059 CSW213
     C**********         MOVEL     TransCCT2     TranInCCT2                            CER059 CSW213
     C**********         MOVEL     TransCCT3     TranInCCT3                            CER059 CSW213
     C**********         MOVEL     TransCCT4     TranInCCT4                            CER059 CSW213
     C**********         MOVEL     TransCCT5     TranInCCT5                            CER059 CSW213
     C**********         MOVEL     TransCCT6     TranInCCT6                            CER059 CSW213
     C                   MOVEL     Trans5018     TranInCtnm                                AR1086546
     C**********         MOVEL     Extdata500    Extdata                                      CSW213
     C                   EVAL      TranInPrim = TransCUPR                                     CSW213
     C                   EVAL      TranInSeco = TransCUSE                                     CSW213
     C                   EVAL      TranInMT3X = TransCUMT                                     CSW213
     C                   EVAL      TranInMsrt = TransCUMR                                     CSW213
     C                   EVAL      TranInBrTx = TransCUBR                                     CSW213
     C                   EVAL      TranInPriv = TransCUPB                                     CSW213
     C                   EVAL      TranInCumi = TransCUMI                                     CSW213
     C                   EVAL      TranInCuad = TransCUAD                                     CSW213
     C                   EVAL      TranInACU3 = TransACU3                                     CSW213
     C                   EVAL      TranInACU4 = TransACU4                                     CSW213
     C                   EVAL      TranInSfee = TransSFEE                                     CSW213
     C                   EVAL      TranInChec = TransCHEC                                     CSW213
     C                   EVAL      TranInCusf = TransCUSF                                     CSW213
     C                   EVAL      TranInCufx = TransCUFX                                     CSW213
     C                   EVAL      TranInCufd = TransCUFD                                     CSW213
     C                   EVAL      TranInCufo = TransCUFO                                     CSW213
     C                   EVAL      TranInCupm = TransCUPM                                     CSW213
     C                   EVAL      TranInTicd = TransTICD                                     CSW213
     C                   EVAL      TranInSwft = TransCUSW                                     CSW213
     C                   EVAL      TranInCurx = TransCURX                                     CSW213
     C                   EVAL      @TimeStamp = TransTimeStmp                                 CSW213
     C                   EVAL      TranInRwan = TransRWAN                                     CSW213
     C                   EVAL      TranInStamp = TransStmpTax                                 CSW213
     C                   EVAL      AAUTH      = TransAUTH                                     CSW213
     C                   EVAL      SDSW13     = TransCS13                                     CSW213
     C                   EVAL      TranInCUAH = TransCUAH                                     CSW213
     C                   EVAL      TranInCCTX = TransCCTX                                     CSW213
     C                   EVAL      TranInCUXC = TransCUXC                                     CGL132
     C                   EVAL      TranInFTCR = TransFTCR                                     CGL132

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

     C/COPY WNCPYSRC,SDH00573
      *  Validate Action Code

     C                   EXSR      ValidateAc

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      ValidateTr
      *                                                                                     AR316373
      ** If LLN007 is ON then validate Bank Of England Extra Data                           AR316373
      *                                                                                     AR316373
     C     LLN007        IFEQ      'Y'                                                      AR316373
      *                                                                                     AR316373
     C                   MOVE      DDCUSN        LVCUST                                     AR316373
     C                   MOVE      DDCUSN        BYCUST                                     AR665308
     C                   MOVE      DDLINC        BYLINC                                     AR665308
     C                   MOVE      DDLICD        BYLICD                                     AR665308
     C                   MOVE      DDCOLC        BYCOLC                                     AR665308
     C                   CALLB     'BYCUSDW0VL'                                             AR316373
     C                   PARM                    DDACTN                                     AR316373
     C                   PARM                    DATA                                       AR316373
     C                   PARM      *BLANKS       CallMod           3                        AR316373
     C                   PARM                    ExtData500                                 AR316373
     C                   PARM                    OkCuBoE                                    AR316373
     C                   PARM                    FldNameArr                                 AR316373
     C                   PARM                    MsgIdArr                                   AR316373
     C                   PARM                    MsgDtaArr                                  AR316373
     C                   PARM                    Idx                                        AR316373
     C                   PARM                    WFldNamArr                                 AR316373
     C                   PARM                    WMsgIdArr                                  AR316373
     C                   PARM                    WMsgDtaArr                                 AR316373
     C                   PARM                    WIdx                                       AR316373
     C                   PARM                    ValidBoE                                   AR316373
     C                   ENDIF                                                              AR316373

     C                   WHEN      DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *  Processing for Amends
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank

     C     GHSUBS        scan      TranInPrim                             99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInSeco                             99
     C                   if        *in99
     C                   eval      RepSeco = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInMsrt                             99
     C                   if        *in99
     C                   eval      RepMsrt = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInBrT1                             99
     C                   if        *in99
     C                   eval      RepBrTx = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInBrT2                             99
     C                   if        *in99
     C                   eval      RepBrTx = 'Y'
     C                   endif

     C     GHSUBS        scan      TranInPriv                             99
     C                   if        *in99
     C                   eval      RepPriv = 'Y'
     C                   endif
     C                   If        CSD079 = 'Y'                                               CSD079
     C     GHSUBS        Scan      TranInCumi                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCumi = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCuad                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCuad = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInACU3                             99                  CER059
     C                   If        *in99                                                      CER059
     C                   Eval      RepACU3 = 'Y'                                              CER059
     C                   EndIf                                                                CER059
     C     GHSUBS        Scan      TranInACU4                             99                  CER059
     C                   If        *in99                                                      CER059
     C                   Eval      RepACU4 = 'Y'                                              CER059
     C                   EndIf                                                                CER059
     C     GHSUBS        Scan      TranInCUAH                             99                  CER059
     C                   If        *in99                                                      CER059
     C                   Eval      RepCUAH = 'Y'                                              CER059
     C                   EndIf                                                                CER059
     C     GHSUBS        Scan      TranInCCTX                             99                  CER059
     C                   If        *in99                                                      CER059
     C                   Eval      RepCCTX = 'Y'                                              CER059
     C                   EndIf                                                                CER059
     C     GHSUBS        Scan      TranInSfee                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepSfee = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInChec                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepChec = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCusf                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCusf = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCufx                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCufx = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCufd                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCufd = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInRwan                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepRwan = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCufo                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCufo = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCupm                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCupm = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInTicd                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepTicd = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C     GHSUBS        Scan      TranInCurx                             99                  CSD079
     C                   If        *in99                                                      CSD079
     C                   Eval      RepCurx = 'Y'                                              CSD079
     C                   EndIf                                                                CSD079
     C                   EndIf                                                                CSD079

      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        (RepPrim = 'Y' OR RepSeco = 'Y' OR
     C                              RepMsrt = 'Y' OR RepBrTx = 'Y' OR
     C                              RepPriv = 'Y')
     C                   EXSR      DtaSubs
     C                   else                                                                 CSD079
     C                   if        CSD079 = 'Y' AND                                           CSD079
     C                             (RepCumi = 'Y' OR RepCuad = 'Y' OR                         CSD079
     C                              RepACU3 = 'Y' OR RepACU4 = 'Y' OR                         CER059
     C                              RepCUAH = 'Y' OR RepCCTX = 'Y' OR                         CER059
     C                              RepSfee = 'Y' OR RepChec = 'Y' OR                         CSD079
     C                              RepCusf = 'Y' OR RepCufx = 'Y' OR                         CSD079
     C                              RepRwan = 'Y' OR RepCufo = 'Y' OR                         CSD079
     C                              RepCupm = 'Y' OR RepTicd = 'Y' OR                         CSD079
     C                              RepCufd = 'Y' OR RepCurx = 'Y' )                          CSD079
     C                   EXSR      DtaSubs                                                    CSD079
     C                   endif                                                                CSD079
     C                   endif

     C                   endif
      **                 (End of "if DDACTN = 'A' and GHSUBS <> *blank")
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
      *                                                                                     AR316373
      ** If LLN007 is ON then validate Bank Of England Extra Data                           AR316373
      *                                                                                     AR316373
     C     LLN007        IFEQ      'Y'                                                      AR316373
      *                                                                                     AR316373
     C                   MOVE      DDCUSN        LVCUST                                     AR316373
     C                   MOVE      DDCUSN        BYCUST                                     AR665308
     C                   MOVE      DDLINC        BYLINC                                     AR665308
     C                   MOVE      DDLICD        BYLICD                                     AR665308
     C                   MOVE      DDCOLC        BYCOLC                                     AR665308
     C                   CALLB     'BYCUSDW0VL'                                             AR316373
     C                   PARM                    DDACTN                                     AR316373
     C                   PARM                    DATA                                       AR316373
     C                   PARM      *BLANKS       CallMod           3                        AR316373
     C                   PARM                    ExtData500                                 AR316373
     C                   PARM                    OkCuBoE                                    AR316373
     C                   PARM                    FldNameArr                                 AR316373
     C                   PARM                    MsgIdArr                                   AR316373
     C                   PARM                    MsgDtaArr                                  AR316373
     C                   PARM                    Idx                                        AR316373
     C                   PARM                    WFldNamArr                                 AR316373
     C                   PARM                    WMsgIdArr                                  AR316373
     C                   PARM                    WMsgDtaArr                                 AR316373
     C                   PARM                    WIdx                                       AR316373
     C                   PARM                    ValidBoE                                   AR316373
     C                   ENDIF                                                              AR316373
     C                   EXSR      ValdateAmd

     C                   WHEN         DDACTN = 'C'
     C                             OR DDACTN = 'R'

     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr

     C                   ENDSL
      *
     C     INVALID       TAG

      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information                         BUG4742
      ** from file                                                                           BUG4742
     C**********         IF        UpdateYN = 'Y'                                     BUG4742 CSD079
     C                   IF        UpdateYN = 'Y'       AND                                   CSD079
     C                             Idx = 0              AND                                   CSD079
     C                             DDACTN <> 'D'                                              CSD079
     C                   MOVE      DDCUSN        DDCUSN_In                                   BUG4742
     C                   CALL      'SDCUSDR'                                                 BUG4742
     C                   PARM                    @AuthComp         1                         BUG4742
     C                   PARM                    @FwdBck           1                         BUG4742
     C                   PARM                    DDCUSN_In         6                         BUG4742
     C                   PARM                    Buffer                                      BUG4742
     C                   PARM                    BufferEx2                                    CSW213
     C                   PARM                    BufferEx3                                    CSW213
     C                   PARM                    BufferEx4                                    CSW213
     C                   PARM                    FldNameArr                                  BUG4742
     C                   PARM                    MsgIDArr                                    BUG4742
     C                   PARM                    MsgDtaArr                                   BUG4742
     C                   PARM                    MsgFArray                                   BUG4742
     C                   PARM                    APIRetC           1                         BUG4742
     C                   MOVEL     DDACTN        Buffer                                      BUG4742
     C                   ELSE                                                                BUG4742
     C                   EVAL                    Buffer = TranInPrim
     C**********                                 + TranInSeco + TranInMsrt                  BUG14803
     C                                           + Traninseco                               BUG14803
     C                                           + TranInMT3X + TraninMsrt                  BUG14803
     C**********                                 + TranInMsrt + TranInBrT1                    CSD079
     C                                           + TranInBrT1 + TranInBrT2
     C*****************                          + TranInPriv + ExtData                      BUG4196
     C                                           + TranInPriv                                BUG4196
     C**********                                 + TranInMT3X                      BUG14485 BUG14803
     C                                           + TranInCumi                                 CSD079
     C                                           + TranInCuad                                 CSD079
     C                                           + TranInACU3                                 CER059
     C                                           + TranInACU4                                 CER059
     C                                           + TranInSfee                                 CSD079
     C                                           + TranInChec                                 CSD079
     C                                           + TranInCusf                                 CSD079
     C                                           + TranInCufx                                 CSD079
     C                                           + TranInCufd                                 CSD079
     C                                           + TranInCufo                                 CSD079
     C                                           + TranInCupm                                 CSD079
     C                                           + TranInTicd                                 CSD079
     C                                           + TranInSwft                               BUG14992
     C                                           + TranInCurx                                 CSD079
     C                                           + @TimeStamp                                BUG4196
     C                                           + TranInRwan                                 CSD079
     C                                           + TranInStamp                                CER049
     C                                           + AAuth                                      CER059
     C**********                                 + TranInCUAH                          CER059 CSW213
     C**********                                 + TranInCCTX                          CER059 CSW213
     C**********                                 + ExtData                            BUG4196 CSD079
     C                                           + TranInCtnm                              AR1086546
     C                                           + FillerBuf                                  CSW213
     C                   EVAL      BufferEx2 = SDSW13                                         CSW213
     C                                       + TranInCUXC                                     CGL132
     C                                       + TranInFTCR                                     CGL132
     C                                       + FillerBufEx2                                   CSW213
                                                                                              CSW213
     C                   EVAL      BufferEx3 = FillerBufEx3                                   CSW213
                                                                                              CSW213
     C                   EVAL      BufferEx4 = TranInCUAH                                     CSW213
     C                                       + TranInCCTX                                     CSW213
     C                                       + ExtData                                      AR316373
     C                                       + FillerBufEx4                                   CSW213
     C                   ENDIF                                                               BUG4742

     C/COPY WNCPYSRC,SDH00574
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR

     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      * Validate action code versus transaction IDs supplied
      * The Customer in file format from the SD database is retrieved
      * as well.

     C                   RESET                   ReturnCode

      * Override SDTICSLR                                                                    BUG5082
     C                   Z-ADD     50            MESLEN           15 5                       BUG5082
     C                   CALL      'QCMDEXC'                                                 BUG5082
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN                                      BUG5082
                                                                                             BUG5082
     C                   CALLB     'SDCUSDRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C**********         PARM      '      '      ModeofOp          6                        AR971184
     C                   PARM                    ModeofOp          6                        AR971184
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Customer Number
     C                   PARM                    DDCUSN            6
      * Base Rate Auth Req                                                                    222373
     C                   PARM                    AUTHRQ            1                          222373
      * Authorisation Mode                                                                    222373
     C                   PARM                    AUTHMD            1                          222373
      *
      *  Base Rate Tax option feature is switched on
     C                   PARM                    S01383
      *
      *  Private Banking Customer module is switched on
     C                   PARM                    BGN4ST
      ** Global Data Layout                                                                   222373
     C                   PARM                    CGP001                                       222373
      ** KYC: Transaction Type                                                                CSD028
     C                   PARM                    PTransType                                   CSD028
      ** Acceptance Mode                                                                      249593
     C                   PARM                    PAccMde           1                          249593
      ** Update (Y/N)                                                                         249593
     C                   PARM                    PUpdYN            1                          249593
      *
      * OUTPUTS
      *
      * (Current) Customer in file format
     C                   PARM                    CustFilFmt
      *
      * (Current) Base Rate Tax details in file format
     C                   PARM                    BrtxFilFmt
      *
      * (Current) Private Banking details in file format
     C                   PARM                    PrivFilFmt
     C                   PARM                    TICdFilFmt                                  BUG3362
     C                   PARM                    GCustFilFmt                                  222373
     C                   PARM                    SwftFilFmt                                   CSW207
     C                   PARM                    SDSW13                                       CSW213
     C                   PARM                    CuXcFilFmt                                   CGL132
     C                   PARM                    CuFaFilFmt                                   CGL132
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
     C**********         PARM                    CtnmFilFmt                       AR1086546 MD021813
     C                   PARM                    ValidCtnm                                  MD021813
     C                   PARM                    TranInPrim                                   CSW213
     C                   PARM                    TranInSeCo                                   CSW213
     C                   PARM                    TranInMT3X                                   CSW213
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Customer Number
     C                   PARM                    DDCUSNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *                                                                                     BUG23518
      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIDArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      *                                                                                     BUG23518
      ** Array index (3P0) from/to caller                                                   BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WIdx                                       BUG23518

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For Amends, put the complete (pre-existing) Customer into the Valid
      *  file record - fields in this will be updated during processing

     C                   MOVE      CustFilFmt    ValidCusd
     C**********         MOVE      BrtxFilFmt    ValidCuBr                                  BUG14161
     C                   MOVEL     BrtxFilFmt    ValidCuBr                                  BUG14161
     C                   MOVE      PrivFilFmt    ValidPriv
     C                   MOVE      TIcdFilFmt    ValidTiCd                                   BUG3362
     C                   MOVEL     CumiFilFmt    ValidCumi                                    CSD079
     C                   MOVEL     CuadFilFmt    ValidCuad                                    CSD079
     C                   MOVEL     SfeeFilFmt    ValidSfee                                    CSD079
     C                   MOVEL     ChecFilFmt    ValidChec                                    CSD079
     C                   MOVEL     CusfFilFmt    ValidCusf                                    CSD079
     C                   MOVEL     RwanFilFmt    ValidRwan                                    CSD079
     C                   MOVEL     CufoFilFmt    ValidCufo                                    CSD079
     C                   MOVEL     CupmFilFmt    ValidCupm                                    CSD079
     C                   MOVEL     TicdFilFmt    ValidTicd                                    CSD079
     C                   MOVEL     CtnmFilFmt    ValidCtnm                                 AR1086546
     C*********          MOVE      CueuFilFmt    ValidCulx2                          CSD079 BUG13595
     C                   EXSR      MovCueuVld                                               BUG13595
     C                   MOVE      CuibfFilFmt   ValidCulx1                                 BUG13595
     C                   MOVEL     CuXcFilFmt    ValidCuXc                                    CGL132
     C                   MOVEL     CuFaFilFmt    ValidFTCS                                    CGL132

      * For Amends, convert the Customer to screen format

     C                   CALLB     'SDCUSDCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Customer - file formats
     C                   PARM                    ValidCusd
     C                   PARM                    ValidCuBr
     C                   PARM                    ValidPriv
     C                   PARM                    ValidCumi                                    CSD079
     C                   PARM                    ValidCuad                                    CSD079
     C                   PARM                    ValidSfee                                    CSD079
     C                   PARM                    ValidChec                                    CSD079
     C                   PARM                    ValidCusf                                    CSD079
     C                   PARM                    ValidRwan                                    CSD079
     C                   PARM                    ValidCufo                                    CSD079
     C                   PARM                    ValidCufn                                    CSD079
     C                   PARM                    ValidCupm                                    CSD079
     C                   PARM                    ValidTicd                                    CSD079
     C                   PARM                    ValidCulx2                                   CSD079
     C                   PARM                    ValidCulx1                                   CSD079
     C                   PARM                    ValidCtnm                                 AR1086546
      ** Global Customer X-Reference                                                          222373
     C                   PARM                    GCustFilFmt                                  222373
     C                   PARM                    ValidSwft                                    CSW207
     C                   PARM                    ValidCuXc                                    CGL132
     C                   PARM                    ValidFTCS                                    CGL132
                                                                                             BUG5082
      ** Switchable features                                                                 BUG5082
                                                                                             BUG5082
     C                   PARM                    CLE025                                      BUG5082
     C                   PARM                    CFX001                                      BUG5082
      *
      * Output parameters
      *
      * Customer Details - screen formats
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCuSeco
     C                   PARM                    CuMT3x                                       222373
     C                   PARM                    CurCuMsrt
     C                   PARM                    CurCuBrTx
     C                   PARM                    CurCuPriv
     C**********         PARM                    CurCuSwft                           CSW207 AR971167
     C                   PARM                    CurCuCumi                                    CSD079
     C                   PARM                    CurCuCuad                                    CSD079
     C                   PARM                    CurCuACU3                                    CER059
     C                   PARM                    CurCuACU4                                    CER059
     C                   PARM                    CurCuSfee                                    CSD079
     C                   PARM                    CurCuCufx                                    CSD079
     C                   PARM                    CurCuCufd                                    CSD079
     C                   PARM                    CurCuChec                                    CSD079
     C                   PARM                    CurCuCusf                                    CSD079
     C                   PARM                    CurCuRwan                                    CSD079
     C                   PARM                    CurCuCufo                                    CSD079
     C                   PARM                    CurCuCupm                                    CSD079
     C                   PARM                    CurCuTicd                                    CSD079
     C                   PARM                    CurCuCurx                                    CSD079
     C                   PARM                    CurCuSwft                                  AR971167
     C                   PARM                    CurCuCtnm                                 AR1086546
     C                   PARM                    CurCuCUXC                                    CGL132
     C                   PARM                    CurCuFTCR                                    CGL132

      ** Customer Details

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************

     C     ValidateTr    BEGSR

      * Validate Customer Primary details

     C                   EXSR      ValdCuPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Base Rate Tax Details

     C     S01383        IFEQ      'Y'
     C     DDTAIN        ANDEQ     'I'
     C     S01383        OREQ      'Y'
     C     DDTAIN        ANDEQ     'J'
     C     S01383        OREQ      'Y'
     C     DDTAIN        ANDEQ     'R'
     C*****S01383        OREQ      'Y'                                            BUG14104A BUG14161
     C*****DDTAIN        ANDEQ     'B'                                            BUG14104A BUG14161
     C*****S01383        OREQ      'Y'                                            BUG14104A BUG14161
     C*****DDTAIN        ANDEQ     'C'                                            BUG14104A BUG14161
     C*****S01383        OREQ      'Y'                                            BUG14104A BUG14161
     C*****DDTAIN        ANDEQ     'N'                                            BUG14104A BUG14161
     C*****S01383        OREQ      'Y'                                            BUG14104A BUG14161
     C*****DDTAIN        ANDEQ     'O'                                            BUG14104A BUG14161

     C                   EXSR      ValdCuBrtx
     C                   EXSR      ValdCuBrtt                                               BUG14161
      *                                                                                     BUG14161
     C                   ENDIF                                                              BUG14161
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *                                                                                     BUG14161
     C     S01383        IFEQ      'Y'                                                      BUG14161
     C     DDTAIN        ANDEQ     'B'                                                      BUG14161
     C     S01383        OREQ      'Y'                                                      BUG14161
     C     DDTAIN        ANDEQ     'C'                                                      BUG14161
     C     S01383        OREQ      'Y'                                                      BUG14161
     C     DDTAIN        ANDEQ     'N'                                                      BUG14161
     C     S01383        OREQ      'Y'                                                      BUG14161
     C     DDTAIN        ANDEQ     'O'                                                      BUG14161
     C                   EXSR      ValdCuBrtt

     C                   ENDIF

      * Validate Customer Private Banking Details

     C     BGN4ST        IFEQ      'Y'
     C                   EXSR      ValdCuPriv
     C                   ENDIF
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Secondary details

     C                   EXSR      ValdCuSeco
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

                                                                                            BUG14485
      * If CSW024 is installed perform MT3X validation routine                              BUG14485
                                                                                            BUG14485
     C                   IF        CSW024 = 'Y'                                             BUG14485
                                                                                            BUG14485
      * Validate MT3X BEI & Fund Information details                                        BUG14485
                                                                                            BUG14485
     C                   EXSR      ValdCuMT3X                                               BUG14485
      *                                                                                     BUG14485
      *  If error in validation, fail this input                                            BUG14485
      *                                                                                     BUG14485
     C     Idx           IFNE      0                                                        BUG14485
     C                   GOTO      EValidTr                                                 BUG14485
     C                   ENDIF                                                              BUG14485
                                                                                            BUG14485
     C                   ENDIF                                                              BUG14485
                                                                                            BUG14485
      * Validate Message Routing details

     C                   EXSR      ValdCuMsrt

      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
                                                                                              CSD079
      ** Validate Marketing Information                                                       CSD079
                                                                                              CSD079
     C                   EXSR      ValdCuCumi                                                 CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
     C                   EVAL      hasDetails = *OFF                                        AR743761
                                                                                            AR740196
      ** Validate Customer details by currency of tax                                       AR740196
                                                                                            AR740196
     C     CSD079        IFEQ      'Y'                                                      AR740196
     C     CGL031        ANDEQ     'Y'                                                      AR913994
     C     CGL032        ANDEQ     'Y'                                                      AR913994
     C                   EVAL      Idy = 1                                                  AR740196
     C                   EVAL      CCTXArrDS = TranInCCTX                                   AR740196
                                                                                            AR811594
      ** Default values if no country of tax defined                                        AR811594
      ** for Joint account type 'I' and 'Y'                                                 AR811594
     C                   IF        (ADDDJATP = 'Y' AND CCTXArrDS = *BLANKS) OR              AR811594
     C                             (ADDDJATP = 'I' AND CCTXArrDS = *BLANKS)                 AR811594
     C                   EXSR      DftCCTX                                                  AR811594
     C                   ENDIF                                                              AR811594
                                                                                            AR811594
     C                   CLEAR                   V_CCTXArr                                  AR740196
     C                   DOW       Idy <= 50                                                AR740196
     C                             AND CCTXArr(Idy) <> *BLANKS                              AR740196
     C                   EVAL      TranInCCTX1 = CCTXArr(Idy)                               AR740196
     C                   EVAL      TXDDCUST =  DDCUSN                                       AR740196
     C                   EVAL      V_ADJATP =  ADDDJATP                                     AR784700
     C                   EXSR      ValdCCTX                                                 AR740196
     C                   EVAL      V_CTCUST =  TXDDCUST                                     AR740196
     C                   EVAL      V_CTCTTX =  TXDDCTTX                                     AR740196
     C                   EVAL      D01ETXS  =  TXDDETXS                                     AR784700
     C                   EVAL      V_CCTXArr(Idy)  = ValidCCTX                              AR740196
     C                   EVAL      Idy = Idy + 1                                            AR740196
     C                   EVAL      hasDetails = *ON                                         AR743761
     C                   ENDDO                                                              AR740196
     C**********         ENDIF                                                     AR740196 AR913994
                                                                                            AR740196
                                                                                            AR743761
     C                   IF        (ADDDJATP = 'Y' AND hasDetails = *OFF) OR                AR743761
     C                             (ADDDJATP = 'I' AND hasDetails = *OFF)                   AR743761
     C                   EVAL      Idx = Idx + 1                                            AR743761
     C**********         EVAL      FldNameArr(Idx) = 'DDGPC2   '                   AR743761 AR913994
     C                   EVAL      FldNameArr(Idx) = 'AXCTTX   '                            AR913994
     C                   EVAL      MsgIdArr(Idx) = 'USR4995'                                AR743761
     C                   ENDIF                                                              AR743761
     C                   ENDIF                                                              AR913994
                                                                                            AR743761
      ** If error in validation, fail this input                                            AR740196
                                                                                            AR740196
     C     Idx           IFNE      0                                                        AR740196
     C                   GOTO      EValidTr                                                 AR740196
     C                   ENDIF                                                              AR740196
                                                                                              CSD079
      ** Validate Additional Customer Details                                                 CSD079
                                                                                              CSD079
     C     S01425        IFEQ      'Y'                                                        CSD079
     C                   EXSR      ValdCuCuad                                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CER059
      ** Validate Additional Customer Inforamtion 2                                           CER059
                                                                                              CER059
     C     S01425        IFEQ      'Y'                                                        CER059
     C                   EXSR      ValdCuACU3                                                 CER059
     C                   EXSR      ValdCuACU4                                                 CER059
     C                   EXSR      ValdCuACU5                                                 CGL132
     C                   ENDIF                                                                CER059
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Service Fees                                                                CSD079
                                                                                              CSD079
     C     CSD008        IFEQ      'Y'                                                        CSD079
     C     SFEDDSMAC     IFNE      *BLANKS                                                   BG12238
     C     SFEDDHMIN     ORNE      *BLANKS                                                   BG12238
     C     SFEDDNAIN     ORNE      *BLANKS                                                   BG12238
     C     SFEDDSBCH     ORNE      *BLANKS                                                   BG12238
     C     SFEDDSCCY     ORNE      *BLANKS                                                   BG12238
     C     SFEDDPFCD     ORNE      *BLANKS                                                   BG12238
     C     SFEDDPCAC     ORNE      *BLANKS                                                   BG12238
     C     SFEDDPCHM     ORNE      *BLANKS                                                   BG12238
     C     SFEDDTAIF     ORNE      *BLANKS                                                   BG12238
     C                   EXSR      ValdCuSfee                                                 CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Cheques and Card Details                                                    CSD079
                                                                                              CSD079
     C     BGNXST        IFEQ      'Y'                                                        CSD079
     C                   EXSR      ValdCuChec                                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Safe Details                                                                CSD079
                                                                                              CSD079
     C                   EXSR      ValdCuCusf                                                 CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Fx netting Details                                                          CSD079
                                                                                              CSD079
     C     CDL002        IFEQ      'Y'                                                        CSD079
     C     FXDDNET       IFNE      *BLANKS                                                    CSD079
     C     FXDDNTGP      ORNE      *BLANKS                                                    CSD079
     C     FXDDNTCP      ORNE      *BLANKS                                                    CSD079
     C     FXDDNTND      ORNE      *BLANKS                                                    CSD079
     C     FXDDNTMM      ORNE      *BLANKS                                                    CSD079
     C                   EXSR      ValdCuCufx                                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Fiduciary Details                                                           CSD079
                                                                                              CSD079
     C     CDL006        IFEQ      'Y'                                                        CSD079
     C     FDDDCOMG      IFNE      *BLANKS                                                    CSD079
     C     FDDDCHRG      ORNE      *BLANKS                                                    CSD079
     C     FDDDAGNT      ORNE      *BLANKS                                                    CSD079
     C     FDDDAGNP      ORNE      *BLANKS                                                    CSD079
     C     FDDDTRAS      ORNE      *BLANKS                                                    CSD079
     C     FDDDNAR1      ORNE      *BLANKS                                                    CSD079
     C     FDDDNAR2      ORNE      *BLANKS                                                    CSD079
     C     FDDDNAR3      ORNE      *BLANKS                                                    CSD079
     C     FDDDNAR4      ORNE      *BLANKS                                                    CSD079
     C     FDDDDFAC      ORNE      *BLANKS                                                    CSD079
     C     FDDDDFAS      ORNE      *BLANKS                                                    CSD079
     C                   EXSR      ValdCuCufd                                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Risk weighted assets                                                        CSD079
                                                                                              CSD079
     C     CGL018        IFEQ      'Y'                                                        CSD079
     C                   IF        %SUBST(TranInRwan:8:172) <> *BLANKS                       BG12238
     C                   EXSR      ValdCuRwan                                                 CSD079
     C                   ENDIF                                                               BG12238
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C     CDL025        IFEQ      'Y'                                                     AR1086546
     C     FXDDNET       IFEQ      'Y'                                                     AR1086546
     C                   EXSR      ValdCuCtnm                                              AR1086546
     C                   ENDIF                                                             AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
      ** If error in validation, fail this input                                           AR1086546
                                                                                           AR1086546
     C     Idx           IFNE      0                                                       AR1086546
     C                   GOTO      EValidTr                                                AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
      ** Validate Futures and Option                                                          CSD079
                                                                                              CSD079
     C     BGFUOP        IFEQ      'Y'                                                        CSD079
     C     FODDSTFQ      IFNE      *BLANKS                                                    CSD079
     C     FODDDMFS      ORNE      *BLANKS                                                    CSD079
     C     FODDNSDT      ORNE      *BLANKS                                                    CSD079
     C     FODDFACO      ORNE      *BLANKS                                                    CSD079
     C     FODDBKIN      ORNE      *BLANKS                                                    CSD079
     C     FODDSTTY      ORNE      *BLANKS                                                    CSD079
     C     FODDCPNO      ORNE      *BLANKS                                                    CSD079
     C     FODDCOAD      ORNE      *BLANKS                                                    CSD079
     C     FODDFTAO      ORNE      *BLANKS                                                    CSD079
     C     FODDTXCI      ORNE      *BLANKS                                                    CSD079
     C     FODDCTLM      ORNE      *BLANKS                                                    CSD079
     C     FODDRVFQ      ORNE      *BLANKS                                                    CSD079
     C     FODDRVBD      ORNE      *BLANKS                                                    CSD079
     C     FODDNRDT      ORNE      *BLANKS                                                    CSD079
     C     FODDPCIN      ORNE      *BLANKS                                                    CSD079
     C     FODDACIN      ORNE      *BLANKS                                                    CSD079
     C     FODDCYCD      ORNE      *BLANKS                                                    CSD079
     C     FODDCODE      ORNE      *BLANKS                                                    CSD079
     C     FODDCOAM      ORNE      *BLANKS                                                    CSD079
     C     FODDSEBR      ORNE      *BLANKS                                                    CSD079
     C     FODDSMAC      ORNE      *BLANKS                                                    CSD079
     C     FODDNETA      ORNE      *BLANKS                                                    CSD079
     C                   EXSR      ValdCuCufo                                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Portfolio Management                                                        CSD079
                                                                                              CSD079
     C     WUPMSC        IFEQ      'Y'                                                        CSD079
     C     PMDDLANG      IFNE      *BLANKS                                                    CSD079
     C     PMDDBDAT      ORNE      *BLANKS                                                    CSD079
     C     PMDDCSBY      ORNE      *BLANKS                                                    CSD079
     C*****PMDDSAFI      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDSAFI      ORNE      'N'                                                      AR970389
     C     PMDDDCMS      ORNE      *BLANKS                                                    CSD079
     C     PMDDVLFQ      ORNE      *BLANKS                                                    CSD079
     C     PMDDVLDM      ORNE      *BLANKS                                                    CSD079
     C     PMDDVLND      ORNE      *BLANKS                                                    CSD079
     C*****PMDDS1VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS1VR      ORNE      'N'                                                      AR970389
     C*****PMDDS2VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS2VR      ORNE      'N'                                                      AR970389
     C*****PMDDS3VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS3VR      ORNE      'N'                                                      AR970389
     C*****PMDDS4VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS4VR      ORNE      'N'                                                      AR970389
     C*****PMDDS5VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS5VR      ORNE      'N'                                                      AR970389
     C*****PMDDS6VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS6VR      ORNE      'N'                                                      AR970389
     C*****PMDDS7VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS7VR      ORNE      'N'                                                      AR970389
     C*****PMDDS8VR      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDS8VR      ORNE      'N'                                                      AR970389
     C     PMDDAPBC      ORNE      *BLANKS                                                    CSD079
     C*****PMDDPPCS      ORNE      *BLANKS                                           CSD079 AR970389
     C     PMDDPPCS      ORNE      'N'                                                      AR970389
     C     PMDDDFPO      ORNE      *BLANKS                                                    CSD079
     C     PMDDINSU      ORNE      *BLANKS                                                    CSD079
     C     PMDDCYSU      ORNE      *BLANKS                                                    CSD079
     C     PMDDSECO      ORNE      *BLANKS                                                    CSD079
     C                   EXSR      ValdCuCupm                                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Trade Innovation                                                            CSD079
                                                                                              CSD079
     C     BGN3ST        IFEQ      'Y'                                                        CSD079
     C     CTI006        OREQ      'Y'                                                      MD030956
     C     TICDDCFXC     IFNE      *BLANKS                                                    CSD079
     C*****TICDDETIT     ORNE      *BLANKS                                           CSD079 TI010338
     C     TICDDETIT     OREQ      'Y'                                                      TI010338
     C     TICDDPFXC     ORNE      *BLANKS                                                    CSD079
     C     TICDDSALU     ORNE      *BLANKS                                                    CSD079
     C     TICDDTELX     ORNE      *BLANKS                                                    CSD079
     C     TICDDTXAB     ORNE      *BLANKS                                                    CSD079
     C     TICDDFXNO     ORNE      *BLANKS                                                    CSD079
     C     TICDDZPCD     ORNE      *BLANKS                                                    CSD079
     C     TICDDTRFM     ORNE      *BLANKS                                                    CSD079
     C     TICDDDLNG     ORNE      *BLANKS                                                    CSD079
     C     TICDDANAL     ORNE      *BLANKS                                                    CSD079
     C     TICDDMLBR     ORNE      *BLANKS                                                    CSD079
     C                   EXSR      ValdCuTicd                                                 CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Populate values to the PDATA DS                                                      CSD079
                                                                                              CSD079
     C                   Eval      #1CUST = DDCUSN                                            CSD079
     C                   Eval      #1PAIN = DDPAIN                                            CSD079
     C                   Eval      #1PCNB = DDPCNB                                            CSD079
     C                   Eval      #1COLC = DDCOLC                                            CSD079
     C                   Eval      #1LINC = DDLINC                                            CSD079
     C                   Eval      #1BRCD = DDBRCD                                            CSD079
     C                   Eval      #1BNBI = DDBNBI                                            CSD079
     C                   Eval      #2CNCZ = DDCNCZ                                            CSD079
     C                   Eval      #1FOTR = APFOTranID                                        CSD079
     C     @TimeStamp    IFEQ      *Blanks                                                    CSD079
     C                   MOVEL     TimeTemp      #1TMST                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     @TimeStamp    #1TMST                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   Eval      #1CRNM = DDCRNM                                            CSD079
                                                                                              CSD079
      ** Validate Lux(European Reporting)                                                     CSD079
                                                                                              CSD079
     C     ULX609        IFEQ      'Y'                                                        CSD079
     C*****TranInCurx    IFNE      *Blanks                                           CSD079 BUG13595
     C                   EXSR      ValdCulx2                                                  CSD079
     C**********         ENDIF                                                       CSD079 BUG13595
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Lux(IBLC - Extended Information)                                            CSD079
                                                                                              CSD079
     C     ULX043        IFEQ      'Y'                                                        CSD079
     C*****TranInCurx    IFNE      *Blanks                                           CSD079 BUG13595
     C                   EXSR      ValdCulx1                                                  CSD079
     C**********         ENDIF                                                       CSD079 BUG13595
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** If error in validation, fail this input                                              CSD079
                                                                                              CSD079
     C     Idx           IFNE      0                                                          CSD079
     C                   GOTO      EValidTr                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Validate Customer/Authority Holder details                                           CER059
                                                                                              CER059
     C     CSD079        IFEQ      'Y'                                                        CER059
     C*****CGL031        ANDEQ     'Y'                                             AR728530 MD026253
     C*****CGL032        ANDEQ     'Y'                                             AR728530 MD026253
     C*****ADDDJATP      IFEQ      'Y'                                             AR728530 MD026253
     C*****ADDDJATP      OREQ      'I'                                             AR728530 MD026253
     C                   EVAL      Idy = 1                                                    CER059
     C                   EVAL      CUAHArrDS = TranInCUAH                                     CER059
     C                   CLEAR                   V_CUAHArr                                    CER059
     C                   DOW       Idy <= 50                                                  CER059
     C                             AND CUAHArr(Idy) <> *BLANKS                                CER059
     C                   EVAL      TranInCUAH1 = CUAHArr(Idy)                                 CER059
     C                   EXSR      ValdCUAH                                                   CER059
     C                   EVAL      V_CUAHArr(Idy)  = ValidCUAH                                CER059
     C                   EVAL      Idy = Idy + 1                                              CER059
     C                   ENDDO                                                                CER059
     C**********         ENDIF                                                     AR728530 MD026253
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** If error in validation, fail this input                                              CER059
                                                                                              CER059
     C     Idx           IFNE      0                                                          CER059
     C                   GOTO      EValidTr                                                   CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Validate Customer details by currency of tax                                         CER059
                                                                                              CER059
     C*****CSD079        IFEQ      'Y'                                               CER059 AR740196
     C*********          EVAL      Idy = 1                                           CER059 AR740196
     C*********          EVAL      CCTXArrDS = TranInCCTX                            CER059 AR740196
     C*********          CLEAR                   V_CCTXArr                           CER059 AR740196
     C*********          DOW       Idy <= 50                                         CER059 AR740196
     C*********                    AND CCTXArr(Idy) <> *BLANKS                       CER059 AR740196
     C*********          EVAL      TranInCCTX1 = CCTXArr(Idy)                        CER059 AR740196
     C*********          EVAL      TXDDCUST =  DDCUSN                                CER059 AR740196
     C*********          EXSR      ValdCCTX                                          CER059 AR740196
     C*********          EVAL      V_CTCUST =  TXDDCUST                              CER059 AR740196
     C*********          EVAL      V_CTCTTX =  TXDDCTTX                              CER059 AR740196
     C*********          EVAL      V_CCTXArr(Idy)  = ValidCCTX                       CER059 AR740196
     C*********          EVAL      Idy = Idy + 1                                     CER059 AR740196
     C*********          ENDDO                                                       CER059 AR740196
     C*********          ENDIF                                                       CER059 AR740196
                                                                                     CER059 AR740196
      ***If*error in validation, fail this input                                     CER059 AR740196
                                                                                     CER059 AR740196
     C*****Idx           IFNE      0                                                 CER059 AR740196
     C*********          GOTO      EValidTr                                          CER059 AR740196
     C*********          ENDIF                                                       CER059 AR740196
                                                                                     CER059 AR740196
     C                   ENDIF                                                                CSD079
                                                                                              CGL132
     C     CGL132        IFEQ      'Y'                                                        CGL132
                                                                                              CGL132
     C                   EXSR      ValdCuFTCS1                                                CGL132
                                                                                              CGL132
     C*****Idx**         IFNE      0                                                 CGL132 MD027584
     C**********         GOTO      EValidTr                                          CGL132 MD027584
     C**********         ENDIF                                                       CGL132 MD027584
                                                                                              CGL132
     C                   EXSR      ValdCuFTCS2                                                CGL132
                                                                                              CGL132
     C*****Idx**         IFNE      0                                                 CGL132 MD027584
     C**********         GOTO      EValidTr                                          CGL132 MD027584
     C**********         ENDIF                                                       CGL132 MD027584
                                                                                              CGL132
     C                   EXSR      ValdCuFTCS3                                                CGL132
                                                                                              CGL132
     C*****Idx**         IFNE      0                                                 CGL132 MD027584
     C**********         GOTO      EValidTr                                          CGL132 MD027584
     C**********         ENDIF                                                       CGL132 MD027584
                                                                                              CGL132
     C                   EXSR      ValdCuFTCS4                                                CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EValidTr                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EXSR      ValdCuFTCS5                                                CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EValidTr                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132

     C/COPY WNCPYSRC,SDCUSDVU01

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuPrim - Validate Customer Primary details                *
      *                                                               *
      *****************************************************************
     C     ValdCuPrim    BEGSR
     C                   IF        %SUBST(TranInTICD:2:12) = *BLANKS AND                    TI010224
     C                             %SUBST(TranInTICD:15:102) = *BLANKS                      TI010224
     C                   MOVE      'N'           V_CUTICS                                   TI010224
     C                   ELSE                                                               TI010224
     C                   MOVE      'Y'           V_CUTICS                                   TI010224
     C                   ENDIF                                                              TI010224

     C                   CALLB     'SDCUSD2VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      ** Customer Primary Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInCUXC                                   CGL132
      * Customer Extra Data file data
     C                   PARM                    ExtData
                                                                                             BUG5082
      ** Switchable features                                                                 BUG5082
                                                                                             BUG5082
     C                   PARM                    CLE025                                      BUG5082
     C                   PARM                    CFX001                                      BUG5082
     C**********         PARM                    CGL132                            MD034317 MD042407
      ** Customer SWIFT Details                                                               CSW207
     C                   PARM                    TranInSwft                                   CSW207
      * OUTPUTS

      *
      ** Customer Primary Details OK inds
     C                   PARM                    OKCuPrim
     C                   PARM                    OKCuFtcs                                     CGL132

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Customer layout (DS) from/to caller
     C                   PARM                    ValidCusd
     C                   PARM                    ValidCuXc                                    CGL132
     C                   PARM                    V_DDGCUS                                     222373
      ** Customer Primary Details OK inds                                                     CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      * Valid Customer SWIFT Details (DS) from/to caller                                      CSW207
     C                   PARM                    ValidSwft                                    CSW207

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuBrTx - Validate Customer Base Rate Tax details          *
      *                                                               *
      *****************************************************************
     C     ValdCuBrtx    BEGSR

     C                   CALLB     'SDCUSD6VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      * Action Code
     C                   PARM                    DDACTN
      *
      * Customer Number
     C                   PARM                    DDCUSN
      *
      * Account Holder Type
     C                   PARM                    DDTAIN
      *
      ** Customer Base Rate Tax Details
     C                   PARM                    TranInBrtx
      *
      ** Screen validation
     C                   PARM      '0'           SinVal            1
      *

      *
      * OUTPUTS
      *
      ** Customer Base Rate Tax Details OK inds
     C                   PARM                    OKCuBrtx

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidCuBr
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         5

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuBrTt - Validate Customer Base Rate Tax details 2ND      *
      *                                                               *
      *****************************************************************
     C     ValdCuBrtt    BEGSR

     C                   CALLB     'SDCUSD7VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      * Action Code
     C                   PARM                    DDACTN
      *
      * Customer Number
     C                   PARM                    DDCUSN
      *
      * Account Holder Type
     C                   PARM                    DDTAIN
      *
      ** Customer Base Rate Tax Details
     C                   PARM                    TranInBrtx
      *
      * OUTPUTS
      *
      ** Customer Base Rate Tax Details OK inds
     C                   PARM                    OKCuBrtx

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         5

      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidCuBr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuPriv - Validate Customer Private Banking Deteils        *
      *                                                               *
      *****************************************************************
     C     ValdCuPriv    BEGSR

      * Check if customer is a Portfolio Management customer.
     C                   EXSR      CHKPTFR

     C                   CALLB     'SDCUSD5VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      ** Private Banking Customer Indicator
     C                   PARM                    V_CUPRBA
      *
      ** Customer Private Banking Details
     C                   PARM                    TranInPriv
      *                                                                                       222373
      ** Portfolio Management Customer Indicator                                              222373
     C                   PARM                    PtfrCust                                     222373
      *                                                                                       222373
      ** Account Officer                                                                      222373
     C                   PARM                    DDACOC            2                          222373
                                                                                            BUG14992
      ** Customer Number                                                                    BUG14992
     C                   PARM                    DDCUSN                                     BUG14992
      **********                                                                  MD026550 MD026550A
      ***Customer Creation Date                                                   MD026550 MD026550A
     C**********         PARM      DDCRDT        P_CRDT            8              MD026550 MD026550A
      *
      * OUTPUTS
      *
      ** Customer Private Banking Details OK inds
     C                   PARM                    OKCuPriv

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Valid Private Banking layout (DS) from/to caller
     C                   PARM                    ValidPriv

     C*****BGN4ST        IFEQ      'Y'                                            AR971167 AR971184A
     C**********         EVAL      V_PBFRNT = APFOTranID                          AR971167 AR971184A
     C**********         ENDIF                                                    AR971167 AR971184A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHKPTFR - Check if Portfolio Management Customer.
      *****************************************************************
     C     CHKPTFR       BEGSR
      *
      ** Initialize Portfolio Management customer indicator.
     C                   MOVE      'N'           PtfrCust          1
      *
      * Retrieve Portfolio Management customer details.
      *
     C                   CALL      'AOPLCSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      DDCUSN        P@CUST           10
     C     SDPLCS        PARM      SDPLCS        DSFDY                                        222373
      *
      ** If Portfolio Management customer details exist, set up
      ** Portfolio Management Customer Indicator.
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           PtfrCust
      *
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuSeco - Validate Customer Secondary details              *
      *                                                               *
      *****************************************************************
     C     ValdCuSeco    BEGSR

     C                   CALLB     'SDCUSD3VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      ** Customer Primary Details
     C                   PARM                    TranInPrim
      ** Customer Secondary Details
     C                   PARM                    TranInSeco
      * Customer Extra Data file data
     C                   PARM                    ExtData
      ** SWIFT Detail                                                                         CSW207
     C                   PARM                    TranInSwft                                   CSW207
     C                   PARM                    SDSW13                                       CSW213
      *
      * OUTPUTS
      *
      ** Customer Secondary Details OK inds
     C                   PARM                    OKCuSeco

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Customer layout (DS) from/to caller
     C                   PARM                    ValidCusd
      * Valid SWIFT Layout (DS) from/to caller                                                CSW207
     C                   PARM                    ValidSwft                                    CSW207
      * Customer SWIFT Details OK Indicator                                                   CSW207
     C                   PARM                    OkCuSwft                                     CSW207

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuMsrt - Validate Customer Message Routing details        *
      *                                                               *
      *****************************************************************
     C     ValdCuMsrt    BEGSR

     C                   CALLB     'SDCUSD4VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      ** Customer Primary Details
      ** Customer Base Rate Tax Details
      ** Customer Secondary Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
      ** Customer Message Routing Details
     C                   PARM                    TranInMsrt
      * Customer Extra Data file data
     C                   PARM                    ExtData

      *
      * OUTPUTS
      *
      ** Customer Message Routing Details OK inds
     C                   PARM                    OKCuMsrt

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Customer layout (DS) from/to caller
     C                   PARM                    ValidCusd

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG14485
      *****************************************************************                     BUG14485
      *                                                               *                     BUG14485
      * ValdCuMT3X - Validate MT3xx BEI & Fund Details                *                     BUG14485
      *                                                               *                     BUG14485
      *****************************************************************                     BUG14485
     C     ValdCuMT3X    BEGSR                                                              BUG14485
                                                                                            BUG14485
     C                   CALLB     'SDCUSD8VL'                                              BUG14485
                                                                                            BUG14485
      * INPUTS                                                                              BUG14485
                                                                                            BUG14485
      * Response mode                                                                       BUG14485
     C                   PARM                    RespMode                                   BUG14485
      ** MT3xx BEI & Fund Details                                                           BUG14485
     C                   PARM                    TranInMT3X                                 BUG14485
      *                                                                                     BUG14485
      * OUTPUTS                                                                             BUG14485
      *                                                                                     BUG14485
      *  MT3xx BEI details screen error indicators                                          BUG14485
     C                   PARM                    OKCuMT3x                                   BUG14485
                                                                                            BUG14485
      * Error fields/message IDs/message data (arrays) from/to caller                       BUG14485
     C                   PARM                    FldNameArr                                 BUG14485
     C                   PARM                    MsgIDArr                                   BUG14485
     C                   PARM                    MsgDtaArr                                  BUG14485
      * Array index (3P0) from/to caller                                                    BUG14485
     C                   PARM                    Idx                                        BUG14485
                                                                                            BUG14485
      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG14485
     C                   PARM                    WFldNamArr                                 BUG14485
     C                   PARM                    WMsgIDArr                                  BUG14485
     C                   PARM                    WMsgDtaArr                                 BUG14485
      * Array index (3P0) from/to caller                                                    BUG14485
     C                   PARM                    WIdx                                       BUG14485
                                                                                            BUG14485
      * Valid Customer layout (DS) from/to caller                                           BUG14485
     C                   PARM                    ValidCusd                                  BUG14485
                                                                                            BUG14485
     C                   ENDSR                                                              BUG14485
      *****************************************************************                     BUG14485
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************

     C     DtaSubs       begsr

      ** Convert file fields to screen format
     C                   reset                   ReturnCode
     C                   CALLB     'SDCUSDCVT'
      * Return Code
     C                   PARM                    ReturnCode
      * Input parameters
      * Customer - file formats
     C                   PARM                    CustFilFmt
     C                   PARM                    BrtxFilFmt
     C                   PARM                    PrivFilFmt
     C                   PARM                    CumiFilFmt                                   CSD079
     C                   PARM                    CuadFilFmt                                   CSD079
     C                   PARM                    SfeeFilFmt                                   CSD079
     C                   PARM                    ChecFilFmt                                   CSD079
     C                   PARM                    CusfFilFmt                                   CSD079
     C                   PARM                    RwanFilFmt                                   CSD079
     C                   PARM                    CufoFilFmt                                   CSD079
     C                   PARM                    CufnFilFmt                                 AR971167
     C                   PARM                    CupmFilFmt                                   CSD079
     C                   PARM                    TicdFilFmt                                   CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
     C                   PARM                    CtnmFilFmt                                AR1086546
      ** Global Customer X-Reference                                                          222373
     C                   PARM                    GCustFilFmt                                  222373
     C                   PARM                    SwftFilFmt                                   CSW207
     C                   PARM                    CuXcFilFmt                                   CGL132
     C                   PARM                    CuFaFilFmt                                   CGL132
      *                                                                                       CSD079
      ** Switchable features                                                                  CSD079
      *                                                                                       CSD079
     C                   PARM                    CLE025                                       CSD079
     C                   PARM                    CFX001                                       CSD079
      *
      * Output parameters
      * Customer Details - screen formats
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCuSeco
     C                   PARM                    CuMT3x                                       222373
     C                   PARM                    CurCuMsrt
     C                   PARM                    CurCuBrTx
     C                   PARM                    CurCuPriv
     C**********         PARM                    CurCuSwft                           CSW207 AR971167
     C                   PARM                    CurCuCumi                                    CSD079
     C                   PARM                    CurCuCuad                                    CSD079
     C                   PARM                    CurCuACU3                                    CER059
     C                   PARM                    CurCuACU4                                    CER059
     C                   PARM                    CurCuSfee                                    CSD079
     C                   PARM                    CurCuCufx                                    CSD079
     C                   PARM                    CurCuCufd                                    CSD079
     C                   PARM                    CurCuChec                                    CSD079
     C                   PARM                    CurCuCusf                                    CSD079
     C                   PARM                    CurCuRwan                                    CSD079
     C                   PARM                    CurCuCufo                                    CSD079
     C                   PARM                    CurCuCupm                                    CSD079
     C                   PARM                    CurCuTicd                                    CSD079
     C                   PARM                    CurCuCurx                                    CSD079
     C                   PARM                    CurCuSwft                                  AR971167
     C                   PARM                    CurCuCtnm                                 AR1086546
     C                   PARM                    CurCuCUXC                                    CGL132
     C                   PARM                    CurCuFTCR                                    CGL132

      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.

     C                   if        RepPrim = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInPrim    IncData        2000
      * Current Data
     C                   PARM      CurCuPrim     CurData        2000

     C                   MOVEL     IncDATA       TranInPrim

     C                   endif

     C                   if        RepSeco = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSeco    IncData
      * Current Data
     C                   PARM      CurCuSeco     CurData

     C                   MOVEL     IncDATA       TranInSeco

     C                   endif

     C                   if        RepMsrt = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInMsrt    IncData
      * Current Data
     C                   PARM      CurCuMsrt     CurData

     C                   MOVEL     IncDATA       TranInMsrt

     C                   endif

     C                   if        RepBrTx = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInBrTx    IncData
      * Current Data
     C                   PARM      CurCuBrTx     CurData

     C                   MOVEL     IncDATA       TranInBrTx

     C                   endif

     C                   if        RepPriv = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInPriv    IncData
      * Current Data
     C                   PARM      CurCuPriv     CurData

     C                   MOVEL     IncDATA       TranInPriv

     C                   endif
     C                   if        CSD079 = 'Y'                                               CSD079
                                                                                              CSD079
     C                   if        RepCumi = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCumi    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCumi     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCumi                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepCuad = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCuad    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCuad     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCuad                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CER059
     C                   if        RepACU3 = 'Y'                                              CER059
                                                                                              CER059
     C                   clear                   IncData                                      CER059
     C                   clear                   CurData                                      CER059
     C                   RESET                   ReturnCode                                   CER059
     C                   CALLB     'APDTASUBS'                                                CER059
                                                                                              CER059
      ** Return Code                                                                          CER059
                                                                                              CER059
     C                   PARM                    ReturnCode                                   CER059
                                                                                              CER059
      ** Substitution character                                                               CER059
                                                                                              CER059
     C                   PARM                    GHSUBS                                       CER059
                                                                                              CER059
      ** Incoming Data                                                                        CER059
                                                                                              CER059
     C                   PARM      TranInACU3    IncData                                      CER059
                                                                                              CER059
      ** Current Data                                                                         CER059
                                                                                              CER059
     C                   PARM      CurCuACU3     CurData                                      CER059
     C                   MOVEL     IncDATA       TranInACU3                                   CER059
     C                   endif                                                                CER059
                                                                                              CER059
     C                   if        RepACU4 = 'Y'                                              CER059
                                                                                              CER059
     C                   clear                   IncData                                      CER059
     C                   clear                   CurData                                      CER059
     C                   RESET                   ReturnCode                                   CER059
     C                   CALLB     'APDTASUBS'                                                CER059
                                                                                              CER059
      ** Return Code                                                                          CER059
                                                                                              CER059
     C                   PARM                    ReturnCode                                   CER059
                                                                                              CER059
      ** Substitution character                                                               CER059
                                                                                              CER059
     C                   PARM                    GHSUBS                                       CER059
                                                                                              CER059
      ** Incoming Data                                                                        CER059
                                                                                              CER059
     C                   PARM      TranInACU4    IncData                                      CER059
                                                                                              CER059
      ** Current Data                                                                         CER059
                                                                                              CER059
     C                   PARM      CurCuACU4     CurData                                      CER059
     C                   MOVEL     IncDATA       TranInACU4                                   CER059
     C                   endif                                                                CER059
                                                                                              CER059
     C                   if        RepCUAH = 'Y'                                              CER059
                                                                                              CER059
     C                   clear                   IncData                                      CER059
     C                   clear                   CurData                                      CER059
     C                   RESET                   ReturnCode                                   CER059
     C                   CALLB     'APDTASUBS'                                                CER059
                                                                                              CER059
      ** Return Code                                                                          CER059
                                                                                              CER059
     C                   PARM                    ReturnCode                                   CER059
                                                                                              CER059
      ** Substitution character                                                               CER059
                                                                                              CER059
     C                   PARM                    GHSUBS                                       CER059
                                                                                              CER059
      ** Incoming Data                                                                        CER059
                                                                                              CER059
     C                   PARM      TranInCUAH    IncData                                      CER059
                                                                                              CER059
      ** Current Data                                                                         CER059
                                                                                              CER059
     C                   PARM      CurCuCUAH     CurData                                      CER059
     C                   MOVEL     IncDATA       TranInCUAH                                   CER059
     C                   endif                                                                CER059
                                                                                              CER059
     C                   if        RepCCTX = 'Y'                                              CER059
                                                                                              CER059
     C                   clear                   IncData                                      CER059
     C                   clear                   CurData                                      CER059
     C                   RESET                   ReturnCode                                   CER059
     C                   CALLB     'APDTASUBS'                                                CER059
                                                                                              CER059
      ** Return Code                                                                          CER059
                                                                                              CER059
     C                   PARM                    ReturnCode                                   CER059
                                                                                              CER059
      ** Substitution character                                                               CER059
                                                                                              CER059
     C                   PARM                    GHSUBS                                       CER059
                                                                                              CER059
      ** Incoming Data                                                                        CER059
                                                                                              CER059
     C                   PARM      TranInCCTX    IncData                                      CER059
                                                                                              CER059
      ** Current Data                                                                         CER059
                                                                                              CER059
     C                   PARM      CurCuCCTX     CurData                                      CER059
     C                   MOVEL     IncDATA       TranInCCTX                                   CER059
     C                   endif                                                                CER059
                                                                                              CSD079
     C                   if        RepSfee = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInSfee    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuSfee     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInSfee                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepChec = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInChec    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuChec     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInChec                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepCusf = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCusf    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCusf     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCusf                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepCufx = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCufx    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCufx     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCufx                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepCufd = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCufd    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCufd     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCufd                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepRwan = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInRwan    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuRwan     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInRwan                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepCufo = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCufo    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCufo     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCufo                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepCupm = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCupm    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCupm     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCupm                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   if        RepTicd = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInTicd    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuTicd     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInTicd                                   CSD079
     C                   endif                                                                CSD079
                                                                                              CSD079
     C                   If        RepCurx = 'Y'                                              CSD079
                                                                                              CSD079
     C                   clear                   IncData                                      CSD079
     C                   clear                   CurData                                      CSD079
     C                   RESET                   ReturnCode                                   CSD079
     C                   CALLB     'APDTASUBS'                                                CSD079
                                                                                              CSD079
      ** Return Code                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    ReturnCode                                   CSD079
                                                                                              CSD079
      ** Substitution character                                                               CSD079
                                                                                              CSD079
     C                   PARM                    GHSUBS                                       CSD079
                                                                                              CSD079
      ** Incoming Data                                                                        CSD079
                                                                                              CSD079
     C                   PARM      TranInCurx    IncData                                      CSD079
                                                                                              CSD079
      ** Current Data                                                                         CSD079
                                                                                              CSD079
     C                   PARM      CurCuCurx     CurData                                      CSD079
     C                   MOVEL     IncDATA       TranInCurx                                   CSD079
     C                   ENDIF                                                                CSD079
     C                   endif                                                                CSD079

     C                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR

      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend.

      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

     C                   CALLB     'SDCUSDAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Customer in Screen Format :
 Form * - Primary Details
      * - Base Rate Tax Details
      * - Secondary Details
      * - Message Routing Details
     C                   PARM                    TraninPrim
     C                   PARM                    TraninBrtx
     C                   PARM                    TraninSeco
     C                   PARM                    TraninMsrt
     C                   PARM                    TranInSwft                                   CSW207
     C                   PARM                    TranInCumi                                   CSD079
     C                   PARM                    TranInCuad                                   CSD079
     C                   PARM                    TranInSfee                                   CSD079
     C                   PARM                    TranInCufx                                   CSD079
     C                   PARM                    TranInCufd                                   CSD079
     C                   PARM                    TranInChec                                   CSD079
     C                   PARM                    TranInCusf                                   CSD079
     C                   PARM                    TranInRwan                                   CSD079
     C                   PARM                    TranInCufo                                   CSD079
     C                   PARM                    TranInCupm                                   CSD079
     C                   PARM                    TranInTicd                                   CSD079
     C                   PARM                    TranInCurx                                   CSD079
     C                   PARM                    TranInCtnm                                AR1086546
      *
      * (Current) Customer in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Message Routing Details
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCuSeco
     C                   PARM                    CurCuMsrt
     C                   PARM                    CurCuBrTx
     C                   PARM                    CurCuSwft                                    CSW207
     C                   PARM                    CurCuCumi                                    CSD079
     C                   PARM                    CurCuCuad                                    CSD079
     C                   PARM                    CurCuSfee                                    CSD079
     C                   PARM                    CurCuCufx                                    CSD079
     C                   PARM                    CurCuCufd                                    CSD079
     C                   PARM                    CurCuChec                                    CSD079
     C                   PARM                    CurCuCusf                                    CSD079
     C                   PARM                    CurCuRwan                                    CSD079
     C                   PARM                    CurCuCufo                                    CSD079
     C                   PARM                    CurCuCupm                                    CSD079
     C                   PARM                    CurCuTicd                                    CSD079
     C                   PARM                    CurCuCurx                                    CSD079
     C                   PARM                    CurCuCtnm                                 AR1086546
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKCuPrim
     C                   PARM                    OKCuSeco
     C                   PARM                    OKCuMsrt
     C                   PARM                    OKCuBrtx
     C                   PARM                    OKCuSwft                                     CSW207
     C                   PARM                    OKCuCumi                                     CSD079
     C                   PARM                    OKCuCuad                                     CSD079
     C                   PARM                    OKCuSfee                                     CSD079
     C                   PARM                    OKCuCufx                                     CSD079
     C                   PARM                    OKCuCufd                                     CSD079
     C                   PARM                    OKCuChec                                     CSD079
     C                   PARM                    OKCuCusf                                     CSD079
     C                   PARM                    OKCuRwan                                     CSD079
     C                   PARM                    OKCuCufo                                     CSD079
     C                   PARM                    OKCuCupm                                     CSD079
     C                   PARM                    OKCuTicd                                     CSD079
     C                   PARM                    OKCuCulx2                                    CSD079
     C                   PARM                    OKCuCulx1                                    CSD079
     C                   PARM                    OKCuCtnm                                  AR1086546
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      ** Warning fields/message IDs/message data (arrays) from/to                           AR855391
      ** caller                                                                             AR855391
                                                                                            AR855391
     C                   PARM                    WFldNamArr                                 AR855391
     C                   PARM                    WMsgIDArr                                  AR855391
     C                   PARM                    WMsgDtaArr                                 AR855391
                                                                                            AR855391
      ** Array index (3P0) from/to caller                                                   AR855391
                                                                                            AR855391
     C                   PARM                    WIdx                                       AR855391

      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
      *                                                                                     AR316373
     C     LLN007        IFEQ      'Y'                                                      AR316373
     C     DDACTN        ANDNE     'R'                                                      AR316373
     C     DDACTN        ANDNE     'C'                                                      AR316373
      *                                                                                     AR316373
     C                   CALLB     'BYCUSDW0UP'                                             AR316373
     C                   PARM                    V_CUTYLC                                   AR316373
     C                   PARM      *BLANKS       DATA                                       AR316373
     C                   PARM      *BLANKS       @RTCD                                      AR316373
     C                   PARM      *BLANKS       WFIND             1                        AR316373
     C                   PARM                    ValidBoE                                   AR316373
     C                   PARM                    FileBoE                                    AR316373
     C                   ENDIF                                                              AR316373
      *                                                                                     AR316373
     C                   ENDIF

     C                   ENDSR
      *****************************************************************                     BUG13595
      /EJECT                                                                                BUG13595
      *****************************************************************                     BUG13595
     C     MovCueuVld    BEGSR                                                              BUG13595
                                                                                            BUG13595
     C                   Eval      V_#6LXVFCUST = VFCUST                                    BUG13595
     C                   Eval      V_#6LXVFCONS = VFCONS                                    BUG13595
     C                   Eval      V_#6LXVFECOS = VFECOS                                    BUG13595
     C                   Eval      V_#6LXVFINRF = VFINRF                                    BUG13595
     C                   Eval      V_#6LXVFCGRP = VFCGRP                                    BUG13595
     C                   Eval      V_#6LXVFCRNM = VFCRNM                                    BUG13595
     C                   Eval      V_#6LXVFCOLC = VFCOLC                                    BUG13595
     C                   Eval      V_#6LXVFPAPS = VFPAPS                                    BUG13595
     C                   Eval      V_#6LXVFPERF = VFPERF                                    BUG13595
     C                   Eval      V_#6LXVFNCOS = VFNCOS                                    BUG13595
     C                   Eval      V_#6LXVFAUTG = VFAUTG                                    BUG13595
     C                   Eval      V_#6LXVFPROG = VFPROG                                    BUG13595
     C                   Eval      V_#6LXVFASSP = VFASSP                                    BUG13595
     C                   Eval      V_#6LXVFICCD = VFICCD                                    BUG13595
     C                   Eval      V_#6LXVFMCID = VFMCID                                    BUG13595
     C                   Eval      V_#6LXVFSMRS = VFSMRS                                    BUG13595
                                                                                            BUG13595
     C                   ENDSR                                                              BUG13595
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************

     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx

     C                   RESET                   FldNoArr

     C                   CLEAR                   CurCuPrim
     C                   CLEAR                   CurCuSeco
     C                   CLEAR                   CurCuMsrt
     C                   CLEAR                   CurCuBrtx
     C                   CLEAR                   CurCuPriv
     C                   CLEAR                   CurCuCumi                                    CSD079
     C                   CLEAR                   CurCuCuad                                    CSD079
     C                   CLEAR                   CurCuACU3                                    CER059
     C                   CLEAR                   CurCuACU4                                    CER059
     C                   CLEAR                   CurCuSfee                                    CSD079
     C                   CLEAR                   CurCuCufx                                    CSD079
     C                   CLEAR                   CurCuCufd                                    CSD079
     C                   CLEAR                   CurCuChec                                    CSD079
     C                   CLEAR                   CurCuCusf                                    CSD079
     C                   CLEAR                   CurCuRwan                                    CSD079
     C                   CLEAR                   CurCuCufo                                    CSD079
     C                   CLEAR                   CurCuCupm                                    CSD079
     C                   CLEAR                   CurCuTicd                                    CSD079
     C                   CLEAR                   CurCuCurx                                    CSD079
     C                   CLEAR                   CurCuCtnm                                 AR1086546
     C                   CLEAR                   CurCuCUXC                                    CGL132
     C                   CLEAR                   CurCuFTCR                                    CGL132

     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVE      *ALL'Y'       OKCuMsrt
     C                   MOVE      *ALL'Y'       OKCuBrtx
     C                   MOVE      *ALL'Y'       OKCuPriv
     C                   MOVE      *ALL'Y'       OKCuMT3x                                   BUG14485
     C                   MOVE      *ALL'Y'       OKCuCumi                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCuad                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuACU3                                     CER059
     C                   MOVE      *ALL'Y'       OKCuACU4                                     CER059
     C                   MOVE      *ALL'Y'       OKCuCUAH                                     CER059
     C                   MOVE      *ALL'Y'       OKCuCCTX                                     CER059
     C                   MOVE      *ALL'Y'       OKCuSfee                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCufx                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCufd                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuChec                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCusf                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuRwan                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCufo                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCupm                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuTicd                                     CSD079
     C                   MOVE      *ALL'Y'       OKCuCulx2                                    CSD079
     C                   MOVE      *ALL'Y'       OKCuCulx1                                    CSD079
     C                   MOVE      *ALL'Y'       OKCuCtnm                                  AR1086546
     C                   MOVE      *ALL'Y'       OKCuCuxc                                     CGL132
     C                   MOVE      *ALL'Y'       OKCuFtcs                                     CGL132

     C                   CLEAR                   ValidCusd
     C                   CLEAR                   ValidCuBr
     C                   CLEAR                   ValidPriv
     C                   CLEAR                   ValidTIcd                                   BUG3362
     C                   CLEAR                   ValidCumi                                    CSD079
     C                   CLEAR                   ValidCuad                                    CSD079
     C                   CLEAR                   ValidSfee                                    CSD079
     C                   CLEAR                   ValidChec                                    CSD079
     C                   CLEAR                   ValidCusf                                    CSD079
     C                   CLEAR                   ValidRwan                                    CSD079
     C                   CLEAR                   ValidCufo                                    CSD079
     C                   CLEAR                   ValidCufn                                   262859B
     C                   CLEAR                   ValidCupm                                    CSD079
     C                   CLEAR                   ValidCulx2                                   CSD079
     C                   CLEAR                   ValidCulx1                                   CSD079
     C                   CLEAR                   ValidCtnm                                 AR1086546
     C                   CLEAR                   ValidCuXc                                    CGL132
     C                   CLEAR                   ValidFTCS                                    CGL132

      * Reset packed fields of Private Banking Details                                      BUG14161
     C                   Z-ADD     0             V_PBPBST                                   BUG14161
     C                   Z-ADD     0             V_PBLCHD                                   BUG14161
      * Reset packed fields of Base Rate Tax Details                                        BUG14161
     C                   Z-ADD     0             V_BRAHCD                                   BUG14161
     C                   Z-ADD     0             V_BRXLCD                                   BUG14161
     C                   Z-ADD     0             V_BRTNLU                                   BUG14161
                                                                                            BUG14161
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      *
      * Update valid customer: customer reference
      *
     C                   MOVEL     DDCUSN        V_CUCUST
     C                   MOVEL     DDACTN        V_CUTYLC
                                                                                              CSD079
     C                   IF        CSD079 = 'Y'                                               CSD079
                                                                                              CSD079
      ** Set Marketing Information Fields                                                     CSD079
                                                                                              CSD079
     C                   MOVEL     DDCUSN        V_MICUST                                     CSD079
     C                   MOVEL     MIDDGPC1      V_MIGPC1                                     CSD079
     C                   MOVEL     MIDDGPC2      V_MIGPC2                                     CSD079
     C                   MOVEL     MIDDGPC3      V_MIGPC3                                     CSD079
     C                   MOVEL     MIDDGPC4      V_MIGPC4                                     CSD079
     C                   MOVEL     MIDDGPC5      V_MIGPC5                                     CSD079
     C                   IF        CSD090 = 'Y'                                               CSD090
     C                   MOVEL     MIDDCSDE      V_MICSDE                                     CSD090
     C                   ENDIF                                                                CSD090
     C                   MOVEL     BJRDNB        V_MILCD                                      CSD079
     C                   MOVEL     MIDDACTN      V_MITYLC                                     CSD079
                                                                                              CSD079
      ** Set Additional Information Fields                                                    CSD079
                                                                                              CSD079
     C                   IF        S01425 = 'Y'                                               CSD079
     C                   MOVEL     DDCUSN        V_ADCUST                                     CSD079
     C                   Z-ADD     BJRDNB        V_ADLCD                                      CSD079
     C                   MOVEL     ADDDACTN      V_ADTYLC                                     CSD079
     C                   MOVEL     ADDDALTN      V_ADALTN                                     CSD079
     C                   MOVEL     ADDDIDNO      V_ADIDNO                                     CSD079
     C                   MOVEL     ADDDFXNB      V_ADFXNB                                     CSD079
     C                   MOVEL     ADDDTXNB      V_ADTXNB                                     CSD079
     C                   MOVEL     ADDDPRVO      V_ADPRVO                                     CSD079
     C                   MOVEL     ADDDMDTL      V_ADMDTL                                     CSD079
     C                   MOVEL     ADDDCNA1      V_ADCNA1                                     CSD079
     C                   MOVEL     ADDDCNA2      V_ADCNA2                                     CSD079
     C                   MOVEL     ADDDCNA3      V_ADCNA3                                     CSD079
     C                   MOVEL     ADDDCNA4      V_ADCNA4                                     CSD079
     C                   MOVEL     ADDDCWL1      V_ADCWL1                                     CSD079
     C                   MOVEL     ADDDCWL2      V_ADCWL2                                     CSD079
     C                   MOVEL     ADDDCWL3      V_ADCWL3                                     CSD079
     C                   MOVEL     ADDDCWL4      V_ADCWL4                                     CSD079
     C                   MOVEL     ADDDCWL5      V_ADCWL5                                     CSD079
     C                   MOVEL     ADDDCITY      V_ADCITY                                     CSD079
     C                   MOVEL     ADDDZIPC      V_ADZIPC                                     CSD079
     C                   MOVEL     ADDDTINO      V_ADTINO                                     CSD079
     C                   MOVEL     ADDDIDTP      V_ADIDTP                                     CSD079
     C                   MOVEL     ADDDISCT      V_ADISCT                                     CSD079
     C                   MOVEL     ADDDISDT      V_ADISDT                                     CSD079
     C                   MOVEL     ADDDDBTH      V_ADDBTH                                     CSD079
     C                   MOVEL     ADDDBTHC      V_ADBTHC                                     CSD079
     C                   MOVEL     ADDDBTHT      V_ADBTHT                                     CSD079
     C                   MOVEL     ADDDJATP      V_ADJATP                                     CSD079
     C                   MOVEL     ADDDREPI      V_ADREPI                                     CSD079
     C                   MOVEL     ADDDCSSN      V_ADCSSN                                     CSD079
     C                   MOVEL     ADDDF001      V_ADFL01                                     CSD079
     C                   MOVEL     ADDDF002      V_ADFL02                                     CSD079
     C                   MOVEL     ADDDF003      V_ADFL03                                     CSD079
     C                   MOVEL     ADDDF004      V_ADFL04                                     CSD079
     C                   MOVEL     ADDDF005      V_ADFL05                                     CSD079
     C                   MOVEL     ADDDF006      V_ADFL06                                     CSD079
     C                   MOVEL     ADDDF007      V_ADFL07                                     CSD079
     C                   MOVEL     ADDDF008      V_ADFL08                                     CSD079
     C                   MOVEL     ADDDF009      V_ADFL09                                     CSD079
     C                   MOVEL     ADDDF010      V_ADFL10                                     CSD079
                                                                                            BUG14992
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG14992
     C                   EVAL      ADDDISCD = V_ADISCD                                      BUG14992
     C                   ELSE                                                               BUG14992
     C                   EVAL      ADDDISCD = *BLANKS                                       BUG14992
     C                   ENDIF                                                              BUG14992
                                                                                            BUG14992
     C                   MOVEL     ADDDTITL      V_ADTITL                                     CER059
     C                   MOVEL     ADDDMDNM      V_ADMDNM                                     CER059
     C                   MOVEL     ADDDSHRF      V_ADSHRF                                     CER059
     C                   MOVEL     ADDDPIND      V_ADPIND                                     CER059
     C                   MOVEL     ADDDDCNM      V_ADDCID                                     CER059
     C                   MOVEL     ADDDISPL      V_ADDIPL                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDEXDT      DateIn                                       CER059
     C                   EXSR      SrZDate                                                    CER059
     C                   MOVEL     DaynoOut      V_ADEXDT                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDEXTH      V_ADEXTH                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDEADT      DateIn                                       CER059
     C                   EXSR      SrZDate                                                    CER059
     C                   MOVEL     DaynoOut      V_ADEADT                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDEVDT      DateIn                                       CER059
     C                   EXSR      SrZDate                                                    CER059
     C                   MOVEL     DaynoOut      V_ADEVDT                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDETXT      DateIn                                       CER059
     C                   EXSR      SrZDate                                                    CER059
     C                   MOVEL     DaynoOut      V_ADETXT                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDCDCL      V_ADCDCL                                     CER059
     C                   MOVEL     ADDDS24C      V_ADS24C                                     CER059
     C                   MOVEL     ADDDREM1      V_ADREM1                                     CER059
     C                   MOVEL     ADDDREM2      V_ADREM2                                     CER059
     C                   MOVEL     ADDDREM3      V_ADREM3                                     CER059
     C                   MOVEL     ADDDSTCD      V_ADSTCD                                     CER059
     C                   MOVEL     ADDDRLAF      V_ADRLAF                                     CER059
                                                                                              CER059
     C                   MOVEL     ADDDFXCU      V_ADFXCU                                     CER059
     C                   MOVEL     ADDDSMBR      V_ADSMBR                                     CER059
     C                   MOVEL     ADDDSECU      V_ADSECU                                     CER059
     C                   MOVEL     ADDDLNID      V_ADLNID                                     CER059
     C                   MOVEL     ADDDCTYP      V_ADCTYP                                     CER059
     C                   MOVEL     ADDDZCFG      V_ADZCFG                                     CER059
     C                   MOVEL     ADDDBSCC      V_ADBSCC                                     CER059
     C                   MOVEL     ADDDECAC      V_ADECAC                                     CER059
     C                   MOVEL     ADDDBIST      V_ADBIST                                     CER059
     C                   MOVEL     ADDDABSK      V_ADABSK                                     CER059
     C                   MOVEL     ADDDBEXT      V_ADBEXT                                     CER059
     C                   MOVEL     ADDDRIGR      V_ADRIGR                                     CER070
     C                   MOVEL     ADDDRECH      V_ADRECH                                     CER071
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Service fees Fields                                                              CSD079
                                                                                              CSD079
     C                   IF        CSD008 = 'Y'                                               CSD079
     C                   MOVEL     DDCUSN        V_SFCUST                                     CSD079
     C                   MOVEL     SFEDDSMAC     V_SFSMAC                                     CSD079
     C                   MOVEL     SFEDDHMIN     V_SFHMIN                                     CSD079
     C                   MOVEL     SFEDDNAIN     V_SFNAIN                                     CSD079
     C                   MOVEL     *Blanks       V_XXSMAC                                     CSD079
     C                   IF        V_SFSBCH = ''                                              CSD079
     C                   MOVEL     SFEDDSBCH     V_SFSBCH                                     CSD079
     C                   ENDIF                                                                CSD079
     C                   MOVEL     SFEDDSCCY     V_SFSCCY                                     CSD079
     C                   MOVEL     SFEDDPFCD     V_SFPFCD                                     CSD079
     C                   MOVEL     SFEDDPCAC     V_SFPCAC                                     CSD079
     C                   MOVEL     SFEDDPCHM     V_SFPCHM                                     CSD079
     C                   MOVEL     SFEDDTAIF     V_SFTAIF                                     CSD079
     C                   Z-ADD     BJRDNB        V_SFLCD                                      CSD079
     C                   MOVEL     SFEDDACTN     V_SFTYLC                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Cheques and Cards fields                                                         CSD079
                                                                                              CSD079
     C                   IF        BGNXST = 'Y'                                               CSD079
     C                   IF        CHEDDACTN = 'I'                                            CSD079
     C                   MOVE      'D'           V_CCRECI                                     CSD079
     C                   Z-ADD     0             V_CCTNLU                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   TIME                    V_CCTLUP                                     CSD079
     C                   Z-ADD     RDLUP         V_CCDLUP                                     CSD079
     C                   MOVEL     RMLUP         V_CCMLUP                                     CSD079
     C                   Z-ADD     RYLUP         V_CCYLUP                                     CSD079
     C                   Z-ADD     BJRDNB        V_CCLCD                                      CSD079
     C                   MOVE      CHEDDACTN     V_CCCHTP                                     CSD079
                                                                                              CSD079
     C                   MOVE      DDCUSN        V_CCCUST                                     CSD079
     C                   IF        CHEDDACTN = 'A' OR CHEDDACTN = 'I'                         CSD079
                                                                                              CSD079
     C                   MOVE      DDCSSN        V_CCCSSN                                     CSD079
     C                   MOVE      DDCRNM        V_CCCRNM                                     CSD079
     C                   MOVE      DDCRTN        V_CCCRTN                                     CSD079
     C                   MOVE      CHEDDCAC1     V_CCCAC1                                     CSD079
     C                   MOVE      CHEDDCAC2     V_CCCAC2                                     CSD079
     C                   MOVE      CHEDDCAC3     V_CCCAC3                                     CSD079
     C                   MOVE      CHEDDCAC4     V_CCCAC4                                     CSD079
     C                   MOVE      CHEDDCAC5     V_CCCAC5                                     CSD079
     C                   MOVE      CHEDDCTX1     V_CCCTX1                                     CSD079
     C                   MOVE      CHEDDCQF1     V_CCCQF1                                     CSD079
     C                   MOVE      CHEDDCQT1     V_CCCQT1                                     CSD079
     C                   MOVE      CHEDDCQQ1     V_CCCQQ1                                     CSD079
     C                   MOVE      CHEDDCQF2     V_CCCQF2                                     CSD079
     C                   MOVE      CHEDDCQT2     V_CCCQT2                                     CSD079
     C                   MOVE      CHEDDCQQ2     V_CCCQQ2                                     CSD079
     C                   MOVE      CHEDDCQF3     V_CCCQF3                                     CSD079
     C                   MOVE      CHEDDCQT3     V_CCCQT3                                     CSD079
     C                   MOVE      CHEDDCQQ3     V_CCCQQ3                                     CSD079
     C                   MOVE      CHEDDCQF4     V_CCCQF4                                     CSD079
     C                   MOVE      CHEDDCQT4     V_CCCQT4                                     CSD079
     C                   MOVE      CHEDDCQQ4     V_CCCQQ4                                     CSD079
     C                   MOVE      CHEDDCQF5     V_CCCQF5                                     CSD079
     C                   MOVE      CHEDDCQT5     V_CCCQT5                                     CSD079
     C                   MOVE      CHEDDCQQ5     V_CCCQQ5                                     CSD079
     C                   MOVE      CHEDDCTX2     V_CCCTX2                                     CSD079
     C                   MOVE      CHEDDCAN1     V_CCCAN1                                     CSD079
     C                   MOVE      CHEDDCAL1     V_CCCAL1                                     CSD079
     C                   MOVE      CHEDDCAN2     V_CCCAN2                                     CSD079
     C                   MOVE      CHEDDCAL2     V_CCCAL2                                     CSD079
     C                   MOVE      CHEDDCAN3     V_CCCAN3                                     CSD079
     C                   MOVE      CHEDDCAL3     V_CCCAL3                                     CSD079
     C                   MOVE      CHEDDCAN4     V_CCCAN4                                     CSD079
     C                   MOVE      CHEDDCAL4     V_CCCAL4                                     CSD079
     C                   MOVE      CHEDDCAN5     V_CCCAN5                                     CSD079
     C                   MOVE      CHEDDCAL5     V_CCCAL5                                     CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Safe Details fields                                                              CSD079
                                                                                              CSD079
     C                   IF         CUSDDACTN = 'I'                                           CSD079
     C                   MOVE      'D'           V_CFSFRECI                                   CSD079
     C                   Z-ADD     0             V_CFSFTNLU                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   TIME                    V_CFSFTLUP                                   CSD079
     C                   Z-ADD     RDLUP         V_CFSFDLUP                                   CSD079
     C                   MOVEL     RMLUP         V_CFSFMLUP                                   CSD079
     C                   Z-ADD     RYLUP         V_CFSFYLUP                                   CSD079
     C                   Z-ADD     BJRDNB        V_CFSFLCD                                    CSD079
     C                   MOVE      CUSDDACTN     V_CFSFCHTP                                   CSD079
     C                   MOVE      DDCUSN        V_CFSFCUST                                   CSD079
     C                   MOVE      DDCSSN        V_CFSFCSSN                                   CSD079
     C                   MOVE      DDCRNM        V_CFSFCRNM                                   CSD079
     C                   MOVE      DDCRTN        V_CFSFCRTN                                   CSD079
                                                                                              CSD079
     C                   IF        CUSDDACTN = 'I' OR CUSDDACTN = 'A'                         CSD079
     C                   MOVE      CUSDDSFN1     V_CFSFSFN1                                   CSD079
     C                   MOVE      CUSDDSFS1     V_CFSFSFS1                                   CSD079
     C                   MOVE      CUSDDSFN2     V_CFSFSFN2                                   CSD079
     C                   MOVE      CUSDDSFS2     V_CFSFSFS2                                   CSD079
                                                                                              CSD079
     C                   MOVE      CUSDDSFN3     V_CFSFSFN3                                   CSD079
     C                   MOVE      CUSDDSFS3     V_CFSFSFS3                                   CSD079
     C                   MOVE      CUSDDSFN4     V_CFSFSFN4                                   CSD079
     C                   MOVE      CUSDDSFS4     V_CFSFSFS4                                   CSD079
     C                   MOVE      CUSDDSFN5     V_CFSFSFN5                                   CSD079
     C                   MOVE      CUSDDSFS5     V_CFSFSFS5                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set FX Net details fields                                                            CSD079
                                                                                              CSD079
     C                   IF        CDL002 = 'Y'                                               CSD079
     C                   Z-ADD     BJRDNB        V_CULCD                                      CSD079
     C                   MOVEL     FXDDNET       V_CUNET                                      CSD079
     C                   MOVEL     FXDDNTGP      V_CUNTGP                                     CSD079
     C                   MOVEL     FXDDNTCP      V_CUNTCP                                     CSD079
     C                   MOVEL     FXDDNTMM      V_CUNTMM                                     CSD079
     C                   MOVEL     DDSWFI        V_CUSWFI                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Fiduciary Deposits Details Fields                                                CSD079
                                                                                              CSD079
     C                   IF        CDL006 = 'Y'                                               CSD079
     C                   Z-ADD     BJRDNB        V_CULCD                                      CSD079
     C                   MOVE      FDDDCOMG      V_CUCOMG                                     CSD079
     C                   MOVE      FDDDCHRG      V_CUCHRG                                     CSD079
     C                   MOVEL     FDDDAGNT      V_CUAGNT                                     CSD079
     C                   MOVE      FDDDTRAS      V_CUTRAS                                     CSD079
     C                   MOVEL     FDDDNAR1      V_CUNAR1                                     CSD079
     C                   MOVEL     FDDDNAR2      V_CUNAR2                                     CSD079
     C                   MOVEL     FDDDNAR3      V_CUNAR3                                     CSD079
     C                   MOVEL     FDDDNAR4      V_CUNAR4                                     CSD079
     C                   MOVE      FDDDDFAC      V_CUDFAC                                     CSD079
     C                   MOVE      FDDDDFAS      V_CUDFAS                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Risk Weighted Assets Fields                                                      CSD079
                                                                                              CSD079
     C                   IF        CGL018 = 'Y'                                               CSD079
     C                   MOVEL     *BLANK        V_RARECI                                     CSD079
     C                   MOVEL     DDCUSN        V_RACUST                                     CSD079
     C                   MOVEL     RWDDCOD1      V_RACOD1                                     CSD079
     C                   MOVEL     RWDDSET1      V_RASET1                                     CSD079
     C                   MOVEL     RWDDCOD2      V_RACOD2                                     CSD079
     C                   MOVEL     RWDDSET2      V_RASET2                                     CSD079
     C                   MOVEL     RWDDCOD3      V_RACOD3                                     CSD079
     C                   MOVEL     RWDDSET3      V_RASET3                                     CSD079
     C                   MOVEL     RWDDCOD4      V_RACOD4                                     CSD079
     C                   MOVEL     RWDDSET4      V_RASET4                                     CSD079
     C                   MOVEL     RWDDCOD5      V_RACOD5                                     CSD079
     C                   MOVEL     RWDDSET5      V_RASET5                                     CSD079
     C                   MOVEL     RWDDCOD6      V_RACOD6                                     CSD079
     C                   MOVEL     RWDDSET6      V_RASET6                                     CSD079
     C                   MOVEL     RWDDCOD7      V_RACOD7                                     CSD079
     C                   MOVEL     RWDDSET7      V_RASET7                                     CSD079
     C                   MOVEL     RWDDCOD8      V_RACOD8                                     CSD079
     C                   MOVEL     RWDDSET8      V_RASET8                                     CSD079
     C                   MOVEL     RWDDCOD9      V_RACOD9                                     CSD079
     C                   MOVEL     RWDDSET9      V_RASET9                                     CSD079
     C                   MOVEL     RWDDCOD10     V_RACOD10                                    CSD079
     C                   MOVEL     RWDDSET10     V_RASET10                                    CSD079
     C                   MOVEL     RWDDCOD11     V_RACOD11                                    CSD079
     C                   MOVEL     RWDDSET11     V_RASET11                                    CSD079
     C                   MOVEL     RWDDCOD12     V_RACOD12                                    CSD079
     C                   MOVEL     RWDDSET12     V_RASET12                                    CSD079
     C                   MOVEL     RWDDCOD13     V_RACOD13                                    CSD079
     C                   MOVEL     RWDDSET13     V_RASET13                                    CSD079
     C                   MOVEL     RWDDCOD14     V_RACOD14                                    CSD079
     C                   MOVEL     RWDDSET14     V_RASET14                                    CSD079
     C                   MOVEL     RWDDCOD15     V_RACOD15                                    CSD079
     C                   MOVEL     RWDDSET15     V_RASET15                                    CSD079
     C                   MOVEL     RWDDCOD16     V_RACOD16                                    CSD079
     C                   MOVEL     RWDDSET16     V_RASET16                                    CSD079
     C                   MOVEL     RWDDCOD17     V_RACOD17                                    CSD079
     C                   MOVEL     RWDDSET17     V_RASET17                                    CSD079
     C                   MOVEL     RWDDCOD18     V_RACOD18                                    CSD079
     C                   MOVEL     RWDDSET18     V_RASET18                                    CSD079
     C                   MOVEL     RWDDCOD19     V_RACOD19                                    CSD079
     C                   MOVEL     RWDDSET19     V_RASET19                                    CSD079
     C                   MOVEL     RWDDCOD20     V_RACOD20                                    CSD079
     C                   MOVEL     RWDDSET20     V_RASET20                                    CSD079
     C                   MOVEL     RWDDCOD21     V_RACOD21                                    CSD079
     C                   MOVEL     RWDDSET21     V_RASET21                                    CSD079
     C                   MOVEL     RWDDCOD22     V_RACOD22                                    CSD079
     C                   MOVEL     RWDDSET22     V_RASET22                                    CSD079
     C                   MOVEL     RWDDCOD23     V_RACOD23                                    CSD079
     C                   MOVEL     RWDDSET23     V_RASET23                                    CSD079
     C                   MOVEL     RWDDCOD24     V_RACOD24                                    CSD079
     C                   MOVEL     RWDDSET24     V_RASET24                                    CSD079
     C                   MOVEL     RWDDCOD25     V_RACOD25                                    CSD079
     C                   MOVEL     RWDDSET25     V_RASET25                                    CSD079
     C                   MOVEL     RWDDCOD26     V_RACOD26                                    CSD079
     C                   MOVEL     RWDDSET26     V_RASET26                                    CSD079
     C                   MOVEL     RWDDCOD27     V_RACOD27                                    CSD079
     C                   MOVEL     RWDDSET27     V_RASET27                                    CSD079
     C                   MOVEL     RWDDCOD28     V_RACOD28                                    CSD079
     C                   MOVEL     RWDDSET28     V_RASET28                                    CSD079
     C                   MOVEL     RWDDCOD29     V_RACOD29                                    CSD079
     C                   MOVEL     RWDDSET29     V_RASET29                                    CSD079
     C                   MOVEL     RWDDCOD30     V_RACOD30                                    CSD079
     C                   MOVEL     RWDDSET30     V_RASET30                                    CSD079
     C                   MOVEL     RWDDCOD31     V_RACOD31                                    CSD079
     C                   MOVEL     RWDDSET31     V_RASET31                                    CSD079
     C                   MOVEL     RWDDCOD32     V_RACOD32                                    CSD079
     C                   MOVEL     RWDDSET32     V_RASET32                                    CSD079
     C                   MOVEL     RWDDCOD33     V_RACOD33                                    CSD079
     C                   MOVEL     RWDDSET33     V_RASET33                                    CSD079
     C                   MOVEL     RWDDCOD34     V_RACOD34                                    CSD079
     C                   MOVEL     RWDDSET34     V_RASET34                                    CSD079
     C                   MOVEL     RWDDCOD35     V_RACOD35                                    CSD079
     C                   MOVEL     RWDDSET35     V_RASET35                                    CSD079
     C                   MOVEL     RWDDCOD36     V_RACOD36                                    CSD079
     C                   MOVEL     RWDDSET36     V_RASET36                                    CSD079
     C                   MOVEL     RWDDACTN      V_RACHTP                                     CSD079
     C                   MOVEL     BJRDNB        V_RALCD                                      CSD079
     C                   IF        DDACTN <> 'I'                                              CSD079
     C                   IF        @TimeStamp = *BLANKS                                     MD021617
     C                   MOVEL     TimeTemp      V_RATMST                                   MD021617
     C                   ELSE                                                               MD021617
     C                   MOVEL     @TimeStamp    V_RATMST                                     CSD079
     C                   ENDIF                                                              MD021617
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Futures and Options                                                              CSD079
                                                                                              CSD079
     C                   IF        BGFUOP = 'Y'                                               CSD079
     C                   MOVEL     DDCUSN        V_FOCUST                                     CSD079
     C                   MOVEL     FODDCYCD      V_FOCYCD                                     CSD079
     C                   Z-ADD     BJRDNB        V_FOLCD                                      CSD079
     C                   MOVEL     FODDACTN      V_FOTYLC                                     CSD079
     C                   MOVEL     FODDSTFQ      V_FOSTFQ                                     CSD079
     C                   MOVEL     FODDFACO      V_FOFACO                                     CSD079
     C                   MOVEL     FODDBKIN      V_FOBKIN                                     CSD079
     C                   MOVEL     FODDSTTY      V_FOSTTY                                     CSD079
     C                   MOVEL     FODDSMAC      V_FOSMAC                                     CSD079
     C                   MOVEL     FODDCPNO      V_FOCPNO                                     CSD079
     C                   MOVEL     FODDCOAD      V_FOCOAD                                     CSD079
     C                   MOVEL     FODDFTAO      V_FOFTAO                                     CSD079
     C                   MOVEL     FODDTXCI      V_FOTXCI                                     CSD079
     C                   MOVEL     FODDRVFQ      V_FORVFQ                                     CSD079
     C                   MOVEL     FODDPCIN      V_FOPCIN                                     CSD079
     C                   MOVEL     FODDACIN      V_FOACIN                                     CSD079
     C                   MOVEL     FODDCODE      V_FOCODE                                     CSD079
     C                   MOVEL     FODDSEBR      V_FOSEBR                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Fn Fields                                                                        CSD079
                                                                                              CSD079
     C                   IF        ULX004 = 'Y'                                               CSD079
     C                   MOVEL     DDCUSN        V_LXCUST                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Portfolio Management fields                                                      CSD079
                                                                                              CSD079
     C                   IF        WUPMSC = 'Y'                                               CSD079
     C                   MOVEL     DDCUSN        V_PMCUST                                     CSD079
     C                   MOVEL     PMDDACTN      V_PMTYLC                                     CSD079
     C                   Z-ADD     BJRDNB        V_PMLCD                                      CSD079
                                                                                              CSD079
     C                   MOVEL     RDLUP         V_PMDLUP                                     CSD079
     C                   MOVEL     RMLUP         V_PMMLUP                                     CSD079
     C                   Z-ADD     RYLUP         V_PMYLUP                                     CSD079
     C                   TIME                    V_PMTLUP                                     CSD079
     C                   IF        PMDDACTN = 'I'                                             CSD079
     C                   MOVEL     'D'           V_PMRECI                                     CSD079
     C                   Z-ADD     0             V_PMTNLU                                     CSD079
     C                   ENDIF                                                                CSD079
     C                   MOVEL     PMDDLANG      V_PMLANG                                     CSD079
     C                   MOVEL     PMDDCSBY      V_PMCSBY                                     CSD079
     C                   MOVEL     PMDDSAFI      V_PMSAFI                                     CSD079
     C                   MOVEL     PMDDDCMS      V_PMDCMS                                     CSD079
     C                   MOVEL     PMDDDFPO      V_PMDFPO                                     CSD079
     C                   MOVEL     PMDDVLFQ      V_PMVLFQ                                     CSD079
     C                   MOVEL     PMDDS1VR      V_PMS1VR                                     CSD079
     C                   MOVEL     PMDDS2VR      V_PMS2VR                                     CSD079
     C                   MOVEL     PMDDS3VR      V_PMS3VR                                     CSD079
     C                   MOVEL     PMDDS4VR      V_PMS4VR                                     CSD079
     C                   MOVEL     PMDDS5VR      V_PMS5VR                                     CSD079
     C                   MOVEL     PMDDS6VR      V_PMS6VR                                     CSD079
     C                   MOVEL     PMDDS7VR      V_PMS7VR                                     CSD079
     C                   MOVEL     PMDDS8VR      V_PMS8VR                                     CSD079
     C                   MOVEL     PMDDAPBC      V_PMAPBC                                     CSD079
     C                   MOVEL     PMDDPPCS      V_PMPPCS                                     CSD079
     C                   MOVEL     PMDDINSU      V_PMINSU                                     CSD079
     C                   MOVEL     PMDDCYSU      V_PMCYSU                                     CSD079
     C                   MOVEL     PMDDSECO      V_PMSECO                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set TI details fields                                                                CSD079
                                                                                              CSD079
     C                   IF        BGN3ST = 'Y'                                               CSD079
     C                             OR CTI006 = 'Y'                                          MD030956
     C                   MOVEL     DDCUSN        V_TCCUST                                     CSD079
     C                   MOVEL     TICDDCFXC     V_TCCFXC                                     CSD079
     C                   MOVEL     TICDDPFXC     V_TCPFXC                                     CSD079
     C                   MOVEL     TICDDETIT     V_TCETIT                                     CSD079
     C                   MOVEL     TICDDSALU     V_TCSALU                                     CSD079
     C                   MOVEL     TICDDTELX     V_TCTELX                                     CSD079
     C                   MOVEL     TICDDTXAB     V_TCTXAB                                     CSD079
     C                   MOVEL     TICDDFXNO     V_TCFXNO                                     CSD079
     C                   MOVEL     TICDDZPCD     V_TCZPCD                                     CSD079
     C                   MOVEL     TICDDTRFM     V_TCTRFM                                     CSD079
     C                   MOVEL     TICDDDLNG     V_TCDLNG                                     CSD079
     C                   MOVEL     TICDDANAL     V_TCANAL                                     CSD079
     C                   MOVEL     TICDDMLBR     V_TCMLBR                                     CSD079
     C                   MOVEL     TICDDACTN     V_TCTYLC                                     CSD079
     C                   Z-ADD     BJRDNB        V_TCLCD                                      CSD079
     C                   MOVEL     DDCSSN        V_TCCSSN                                     CSD079
     C                   MOVEL     'Y'           V_TCFLAG                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Luxembourg Details Fields                                                        CSD079
                                                                                              CSD079
     C     ULX609        IFEQ      'Y'                                                        CSD079
     C                   MOVE      *BLANKS       V_#6LXVFFOTR                                 CSD079
     C                   MOVE      DDCUSN        V_#6LXVFCUST                                 CSD079
     C                   MOVE      RXL6LXCONS    V_#6LXVFCONS                                 CSD079
     C                   MOVE      RXL6LXECOS    V_#6LXVFECOS                                 CSD079
     C                   MOVE      RXL6LXINRF    V_#6LXVFINRF                                 CSD079
     C                   MOVE      DDCRNM        V_#6LXVFCRNM                                 CSD079
     C                   MOVE      DDCOLC        V_#6LXVFCOLC                                 CSD079
     C                   MOVE      RXL6LXPERF    V_#6LXVFPERF                                 CSD079
     C                   MOVE      RXL6LXNCOS    V_#6LXVFNCOS                                 CSD079
     C                   MOVE      RXL6LXAUTG    V_#6LXVFAUTG                                 CSD079
     C                   MOVE      RXL6LXPROG    V_#6LXVFPROG                                 CSD079
     C                   MOVE      RXL6LXASSP    V_#6LXVFASSP                                 CSD079
     C                   MOVE      RXL6LXICCD    V_#6LXVFICCD                                 CSD079
     C                   MOVE      RXL6LXMCID    V_#6LXVFMCID                                 CSD079
     C                   MOVE      RXL6LXSMRS    V_#6LXVFSMRS                                 CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C     ULX043        IFEQ      'Y'                                                        CSD079
     C                   MOVE      *BLANKS       V_#LLXCUFOTR                                 CSD079
     C                   MOVE      DDCUSN        V_#LLXCUCNUM                                 CSD079
     C                   MOVE      RXLLLXTYPE    V_#LLXCUTYPE                                 CSD079
     C                   MOVE      RXLLLXIDCO    V_#LLXCUIDCO                                 CSD079
     C                   MOVE      RXLLLXIDEN    V_#LLXCUIDEN                                 CSD079
     C                   MOVE      RXLLLXIMCO    V_#LLXCUIMCO                                 CSD079
     C                   MOVE      RXLLLXIMNB    V_#LLXCUIMNB                                 CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** End of CSD079                                                                        CSD079
                                                                                              CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C**********         EVAL      V_FVGIIN = DDGIIN                                 CGL132 MD027213
     C**********         EVAL      V_FVUTIN = DDUTIN                                CGL132 MD026753B
     C                   EVAL      V_FVHMSV = FAHMSV                                          CGL132
     C                   EVAL      V_FVHMSD = FAHMSD                                          CGL132
     C                   EVAL      V_FVHMST = FAHMST                                          CGL132
     C                   EVAL      V_FVMCSV = FAMCSV                                          CGL132
     C                   EVAL      V_FVMCSD = FAMCSD                                          CGL132
     C                   EVAL      V_FVMCST = FAMCST                                          CGL132
     C                   EVAL      V_FVRPSV = FARPSV                                          CGL132
     C                   EVAL      V_FVRPSD = FARPSD                                          CGL132
     C                   EVAL      V_FVRPST = FARPST                                          CGL132
     C                   EVAL      V_FVCISV = FACISV                                          CGL132
     C                   EVAL      V_FVCISD = FACISD                                          CGL132
     C                   EVAL      V_FVCIST = FACIST                                          CGL132
     C                   EVAL      V_FVCBSV = FACBSV                                          CGL132
     C                   EVAL      V_FVCBSD = FACBSD                                          CGL132
     C                   EVAL      V_FVCBST = FACBST                                          CGL132
     C                   EVAL      V_FVCDSV = FACDSV                                          CGL132
     C                   EVAL      V_FVCDSD = FACDSD                                          CGL132
     C                   EVAL      V_FVCDST = FACDST                                          CGL132
     C                   EVAL      V_FVGCSV = FAGCSV                                          CGL132
     C                   EVAL      V_FVGCSD = FAGCSD                                          CGL132
     C                   EVAL      V_FVGCST = FAGCST                                          CGL132
     C                   EVAL      V_FVIDSV = FAIDSV                                          CGL132
     C                   EVAL      V_FVIDSD = FAIDSD                                          CGL132
     C                   EVAL      V_FVIDST = FAIDST                                          CGL132
     C                   EVAL      V_FVJASV = FAJASV                                          CGL132
     C                   EVAL      V_FVJASD = FAJASD                                          CGL132
     C                   EVAL      V_FVJAST = FAJAST                                          CGL132
     C                   EVAL      V_FVTESV = FATESV                                          CGL132
     C                   EVAL      V_FVTESD = FATESD                                          CGL132
     C                   EVAL      V_FVTEST = FATEST                                          CGL132
     C                   EVAL      V_FVTXSV = FATXSV                                          CGL132
     C                   EVAL      V_FVTXSD = FATXSD                                          CGL132
     C                   EVAL      V_FVTXST = FATXST                                          CGL132
     C                   ENDIF                                                                CGL132
      *
      ** Carry forward non-validated master file values to valid file
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVE      BBTXA2        V_CUTXA2
     C                   MOVE      BBTXA3        V_CUTXA3
     C                   MOVE      BBTXA4        V_CUTXA4
     C                   MOVE      BBTXA5        V_CUTXA5
     C                   MOVE      BBLETI        V_CULETI
     C                   MOVE      BBCMTI        V_CUCMTI
     C                   MOVE      BBOGID        V_CUOGID
     C                   Z-ADD     BBORED        V_CUORED
     C**********         MOVE      BBNET         V_CUNET                                      CSD079
     C**********         MOVE      BBNTGP        V_CUNTGP                                     CSD079
     C**********         MOVE      BBNTCP        V_CUNTCP                                     CSD079
     C**********         Z-ADD     BBNTND        V_CUNTND                                     CSD079
     C**********         MOVE      BBNTMM        V_CUNTMM                                     CSD079
     C                   MOVE      BBTMST        V_CUTMST
     C                   ELSE
      *
      ** Initialise non-validated valid file fields for Insert
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *BLANKS       V_CUTXA2
     C                   MOVE      *BLANKS       V_CUTXA3
     C                   MOVE      *BLANKS       V_CUTXA4
     C                   MOVE      *BLANKS       V_CUTXA5
     C                   MOVE      *BLANKS       V_CULETI
     C                   MOVE      *BLANKS       V_CUCMTI
     C                   MOVE      *BLANKS       V_CUOGID
     C                   Z-ADD     BJRDNB        V_CUORED
     C                   IF        FXDDNET = *Blanks                                          CSD079
     C                   MOVE      'N'           V_CUNET
     C                   ENDIF                                                                CSD079
     C                   IF        FXDDNTGP = *Blanks                                         CSD079
     C                   MOVE      *BLANKS       V_CUNTGP
     C                   ENDIF                                                                CSD079
     C                   IF        FXDDNTCP = *Blanks                                         CSD079
     C                   MOVE      'N'           V_CUNTCP
     C                   ENDIF                                                                CSD079
     C                   IF        FXDDNTMM = *Blanks                                         CSD079
     C                   MOVE      'N'           V_CUNTMM
     C                   ENDIF                                                                CSD079
     C*****V_CUTICS      IFEQ      *BLANK                                                     CSD079
     C*****TranInTICD    IFEQ      *BLANK                                             CRE026 BG12238
     C**********         IF        %SUBST(TranInTICD:2:115) = *BLANKS                        BG12238
     C                   IF        %SUBST(TranInTICD:2:12) = *BLANKS AND                    TI010224
     C                             %SUBST(TranInTICD:15:102) = *BLANKS                      TI010224
     C                   MOVE      'N'           V_CUTICS
     C                   ELSE                                                                 CSD079
     C                   MOVE      'Y'           V_CUTICS                                     CSD079
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Include Header fields that need to be o/p to the Valid file                        AR971184
     C**********         IF        APFOTranID <> ' ' and                          AR971184 AR971184A
     C**********                   DDACTN = 'I'                                   AR971184 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      V_CUFRNT = APFOTranID                                    AR971184
     C                   EVAL      V_CUAFRT = APFOAsocID                                    AR971184
     C                   EVAL      V_CUREPA = APRprLocn                                     AR971184
     C                                                                                      AR971184
     C                   IF        BGN4ST  = 'Y'                                            AR971184
     C                   EVAL      V_PBFRNT = APFOTranID                                    AR971184
     C                   EVAL      V_PBAFRT = APFOAsocID                                    AR971184
     C                   EVAL      V_PBREPA = APRprLocn                                     AR971184
     C                   ENDIF                                                              AR971184
     C                                                                                      AR971184
     C                   EVAL      V_ADFRNT = APFOTranID                                    AR971184
     C                   EVAL      V_ADREPA = APRprLocn                                     AR971184
     C                   ENDIF                                                              AR971184
                                                                                            AR971184
      * Restore Timestamp from the original record                                           BUG4196
     C                   IF        DDACTN <> 'I'                                             BUG4196
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    V_CUTMST                                    BUG4196
     C                   ENDIF                                                               BUG4196
                                                                                             BUG4196
      *                                                                                     BUG21091
      ** Message Routing & MT3xx BEI and Fund details tabs not properly updated             BUG21091
      *                                                                                     BUG21091
     C                   Eval      V_CUCORP = MTDDCORP                                      BUG21091
     C                   Eval      V_CUCBEI = MTDDCBEI                                      BUG21091
     C                   Eval      V_CURI01 = MTDDRI01                                      BUG21091
     C                   Eval      V_CURI02 = MTDDRI02                                      BUG21091
     C                   Eval      V_CURI03 = MTDDRI03                                      BUG21091
     C                   Eval      V_CURI04 = MTDDRI04                                      BUG21091
     C                   Eval      V_CURI05 = MTDDRI05                                      BUG21091
     C                   Eval      V_CUFUND = MTDDFUND                                      BUG21091
     C                   Eval      V_CUFNAC = MTDDFNAC                                      BUG21091
     C                   Eval      V_CUNG01 = DDNG01                                        BUG21091
     C                   Eval      V_CUNG02 = DDNG02                                        BUG21091
     C                   Eval      V_CUNG03 = DDNG03                                        BUG21091
     C                   Eval      V_CUNG04 = DDNG04                                        BUG21091
     C                   Eval      V_CUNG05 = DDNG05                                        BUG21091
     C                   Eval      V_CUNG06 = DDNG06                                        BUG21091
     C                   Eval      V_CUNG07 = DDNG07                                        BUG21091
     C                   Eval      V_CUNG08 = DDNG08                                        BUG21091
     C                   Eval      V_CUNG09 = DDNG09                                        BUG21091
     C                   Eval      V_CUNG10 = DDNG10                                        BUG21091
     C                   Eval      V_CUNG11 = DDNG11                                        BUG21091
     C                   Eval      V_CUNG12 = DDNG12                                        BUG21091
     C                   Eval      V_CUNG13 = DDNG13                                        BUG21091
     C                   Eval      V_CUNG14 = DDNG14                                        BUG21091
     C                   Eval      V_CUNG15 = DDNG15                                        BUG21091
     C                   Eval      V_CUDS01 = DDDS01                                        BUG21091
     C                   Eval      V_CUDS02 = DDDS02                                        BUG21091
     C                   Eval      V_CUDS03 = DDDS03                                        BUG21091
     C                   Eval      V_CUDS04 = DDDS04                                        BUG21091
     C                   Eval      V_CUDS05 = DDDS05                                        BUG21091
     C                   Eval      V_CUDS06 = DDDS06                                        BUG21091
     C                   Eval      V_CUDS07 = DDDS07                                        BUG21091
     C                   Eval      V_CUDS08 = DDDS08                                        BUG21091
     C                   Eval      V_CUDS09 = DDDS09                                        BUG21091
     C                   Eval      V_CUDS10 = DDDS10                                        BUG21091
     C                   Eval      V_CUDS11 = DDDS11                                        BUG21091
     C                   Eval      V_CUDS12 = DDDS12                                        BUG21091
     C                   Eval      V_CUDS13 = DDDS13                                        BUG21091
     C                   Eval      V_CUDS14 = DDDS14                                        BUG21091
     C                   Eval      V_CUDS15 = DDDS15                                        BUG21091
     C                   Eval      V_CUDNW1 = DDDNW1                                        BUG21091
     C                   Eval      V_CUDNW2 = DDDNW2                                        BUG21091
     C                   Eval      V_CUDNW3 = DDDNW3                                        BUG21091
     C                   Eval      V_CUDNW4 = DDDNW4                                        BUG21091
     C                   Eval      V_CUDNW5 = DDDNW5                                        BUG21091
     C                   Eval      V_CUDNW6 = DDDNW6                                        BUG21091
     C                   Eval      V_CUDNW7 = DDDNW7                                        BUG21091
     C                   Eval      V_CUDNW8 = DDDNW8                                        BUG21091
     C                   Eval      V_CUDNW9 = DDDNW9                                        BUG21091
                                                                                           AR1086546
     C                   IF        CDL025 = 'Y'                                            AR1086546
     C                   MOVEL     CTDDCUST      V_TNCUST                                  AR1086546
     C                   MOVEL     CTDDNTCP      V_TNNTCP                                  AR1086546
     C                   MOVEL     DDACTN        V_TNTYLC                                  AR1086546
     C                   MOVEL     BJRDNB        V_TNLCD                                   AR1086546
     C                   MOVEL     CTDDCCY1_1    V_TNCCY1_1                                AR1086546
     C                   MOVEL     CTDDCCY2_1    V_TNCCY2_1                                AR1086546
     C                   MOVEL     CTDDTIME_1    V_TNTIME_1                                AR1086546
     C                   MOVEL     CTDDRNTD_1    V_TNRNTD_1                                AR1086546
     C                   MOVEL     CTDDCCY1_2    V_TNCCY1_2                                AR1086546
     C                   MOVEL     CTDDCCY2_2    V_TNCCY2_2                                AR1086546
     C                   MOVEL     CTDDTIME_2    V_TNTIME_2                                AR1086546
     C                   MOVEL     CTDDRNTD_2    V_TNRNTD_2                                AR1086546
     C                   MOVEL     CTDDCCY1_3    V_TNCCY1_3                                AR1086546
     C                   MOVEL     CTDDCCY2_3    V_TNCCY2_3                                AR1086546
     C                   MOVEL     CTDDTIME_3    V_TNTIME_3                                AR1086546
     C                   MOVEL     CTDDRNTD_3    V_TNRNTD_3                                AR1086546
     C                   MOVEL     CTDDCCY1_4    V_TNCCY1_4                                AR1086546
     C                   MOVEL     CTDDCCY2_4    V_TNCCY2_4                                AR1086546
     C                   MOVEL     CTDDTIME_4    V_TNTIME_4                                AR1086546
     C                   MOVEL     CTDDRNTD_4    V_TNRNTD_4                                AR1086546
     C                   MOVEL     CTDDCCY1_5    V_TNCCY1_5                                AR1086546
     C                   MOVEL     CTDDCCY2_5    V_TNCCY2_5                                AR1086546
     C                   MOVEL     CTDDTIME_5    V_TNTIME_5                                AR1086546
     C                   MOVEL     CTDDRNTD_5    V_TNRNTD_5                                AR1086546
     C                   MOVEL     CTDDCCY1_6    V_TNCCY1_6                                AR1086546
     C                   MOVEL     CTDDCCY2_6    V_TNCCY2_6                                AR1086546
     C                   MOVEL     CTDDTIME_6    V_TNTIME_6                                AR1086546
     C                   MOVEL     CTDDRNTD_6    V_TNRNTD_6                                AR1086546
     C                   MOVEL     CTDDCCY1_7    V_TNCCY1_7                                AR1086546
     C                   MOVEL     CTDDCCY2_7    V_TNCCY2_7                                AR1086546
     C                   MOVEL     CTDDTIME_7    V_TNTIME_7                                AR1086546
     C                   MOVEL     CTDDRNTD_7    V_TNRNTD_7                                AR1086546
     C                   MOVEL     CTDDCCY1_8    V_TNCCY1_8                                AR1086546
     C                   MOVEL     CTDDCCY2_8    V_TNCCY2_8                                AR1086546
     C                   MOVEL     CTDDTIME_8    V_TNTIME_8                                AR1086546
     C                   MOVEL     CTDDRNTD_8    V_TNRNTD_8                                AR1086546
     C                   MOVEL     CTDDCCY1_9    V_TNCCY1_9                                AR1086546
     C                   MOVEL     CTDDCCY2_9    V_TNCCY2_9                                AR1086546
     C                   MOVEL     CTDDTIME_9    V_TNTIME_9                                AR1086546
     C                   MOVEL     CTDDRNTD_9    V_TNRNTD_9                                AR1086546
     C                   MOVEL     CTDDCCY1_10   V_TNCCY1_10                               AR1086546
     C                   MOVEL     CTDDCCY2_10   V_TNCCY2_10                               AR1086546
     C                   MOVEL     CTDDTIME_10   V_TNTIME_10                               AR1086546
     C                   MOVEL     CTDDRNTD_10   V_TNRNTD_10                               AR1086546
     C                   ENDIF                                                             AR1086546
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *
      * CUSTOMER UPDATES
      *
     C                   CALLB     'SDCUSDUPD'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ValidCusd
     C                   PARM                    ValidCuXc                                  MD026458
     C                   PARM                    ValidCuBr
     C                   PARM                    ValidPriv
     C                   PARM                    ValidTIcd                                   BUG3362
     C                   PARM                    ValidSwft                                    CSW207
     C                   PARM                    SDSW13                                       CSW213
     C                   PARM                    ValidCumi                                    CSD079
     C                   PARM                    ValidCuad                                    CSD079
     C                   PARM                    ValidSfee                                    CSD079
     C                   PARM                    ValidChec                                    CSD079
     C                   PARM                    ValidCusf                                    CSD079
     C                   PARM                    ValidRwan                                    CSD079
     C                   PARM                    ValidCufo                                    CSD079
     C                   PARM                    ValidCufn                                    CSD079
     C                   PARM                    ValidCupm                                    CSD079
     C                   PARM                    ValidCulx2                                   CSD079
     C                   PARM                    ValidCulx1                                   CSD079
     C                   PARM                    ValidCtnm                                 AR1086546
     C                   PARM                    ValidFTCS                                    CGL132
      * Base Rate Auth req                                                                    222373
     C                   PARM                    AUTHRQ            1                          222373
      * Authorisation Mode                                                                    222373
     C                   PARM                    AUTHMD            1                          222373
     C                   PARM                    V_DDGCUS         10                          222373
     C                   PARM                    S01383
     C                   PARM                    CSW024                                       222373
     C                   PARM                    CGP001                                       222373
     C                   PARM                    CLE025                                      BUG5082
     C                   PARM                    CFX001                                      BUG5082
      ** KYC: Transaction Type                                                                CSD028
     C                   PARM      *BLANKS       PTransType                                   CSD028
     C                   PARM      *BLANKS       DACTN             1                          CSD028
     C                   PARM                    CTI006                                     MD030956
                                                                                              CER059
     C                   IF        @RTCD = *BLANKS                                            CER059
     C                             AND (DDACTN <> 'D'                                       AR741363
     C                             AND DDACTN <> 'C')                                       AR741363
     C                   CLEAR                   UpdKey                                       CER059
     C                   CLEAR                   ValidCUAH                                    CER059
     C                   EVAL      UpCust = V_CUCUST                                          CER059
     C                   EVAL      V_ACTYLC = 'D'                                             CER059
     C                   EVAL      V_ACCUST = V_CUCUST                                        CER059
     C                   EXSR      SrUpdCUAH                                                  CER059
                                                                                              CER059
     C                   EVAL      Idy = 1                                                    CER059
     C                   DOW       Idy <= 50                                                  CER059
     C                             AND V_CUAHArr(Idy) <> *BLANKS                              CER059
     C                             AND @RTCD = *BLANKS                                        CER059
     C                   EVAL      ValidCUAH  = V_CUAHArr(Idy)                                CER059
     C                   EVAL      V_ACTYLC = 'I'                                             CER059
     C                   EXSR      SrUpdCUAH                                                  CER059
     C                   EVAL      Idy = Idy + 1                                              CER059
     C                   ENDDO                                                                CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        @RTCD = *BLANKS                                            CER059
     C                             AND (DDACTN <> 'D'                                       AR741363
     C                             AND DDACTN <> 'C')                                       AR741363
     C                   CLEAR                   ValidCCTX                                    CER059
     C                   EVAL      PAction  = 'D'                                             CER059
     C                   EXSR      SrUpdCCTX                                                  CER059
                                                                                              CER059
     C                   EVAL      PAction  = 'I'                                             CER059
     C                   EVAL      Idy = 1                                                    CER059
     C                   DOW       Idy <= 50                                                  CER059
     C                             AND V_CCTXArr(Idy) <> *BLANKS                              CER059
     C                             AND @RTCD = *BLANKS                                        CER059
     C                   EVAL      ValidCCTX = V_CCTXArr(Idy)                                 CER059
     C                   EXSR      SrUpdCCTX                                                  CER059
     C                   EVAL      Idy = Idy + 1                                              CER059
     C                   ENDDO                                                                CER059
     C                   ENDIF                                                                CER059
      *                                                                                     AR745923
      ** Inform user that joint account should have atleast one member where calculation of AR745923
      ** tax will be based on.                                                              AR745923
      *                                                                                     AR745923
     C                   IF        CER048 = 'Y'                                             AR745923
     C                             AND ADDDJATP = 'Y'                                       AR745923
     C                             AND DDACTN = 'I'                                         AR745923
     C                   EVAL      WIdx = WIdx + 1                                          AR745923
     C                   EVAL      WFldNamArr(WIdx) = 'DDGPC2   '                           AR745923
     C                   EVAL      WMsgIdArr(WIdx) = 'USR8442'                              AR745923
     C                   ENDIF                                                              AR745923
      *                                                                                     AR745923
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      /COPY WNCPYSRC,SDCUSDVU04
     C                   IF        CGL132 = 'Y' AND                                         MD026519
     C                             CGL133 = 'N'                                             MD026519
                                                                                            MD026519
     C                   CALL      'QCMDEXC'                                                MD026519
     C                   PARM                    ##OV1                                      MD026519
     C                   PARM                    WMsgLen                                    MD026519
                                                                                            MD026519
     C                   CALL      'QCMDEXC'                                                MD026519
     C                   PARM                    ##OV3                                      MD026519
     C                   PARM                    WMsgLen                                    MD026519
                                                                                            MD026519
     C                   CALL      'QCMDEXC'                                                MD027296
     C                   PARM                    ##OV5                                      MD027296
     C                   PARM                    WMsgLen                                    MD027296
                                                                                            MD027296
     C                   CALL      'SD000732A'                                              MD026519
     C                   PARM      *BLANKS       PReturn                                    MD026519
     C                   PARM      V_CUCUST      PTranID                                    MD026519
     C                   PARM      'C'           PSource                                    MD026519
     C                   PARM      *BLANKS       PClass                                     MD026519
     C                   PARM      *BLANKS       PCLass                                     MD026519
     C                   PARM      ' '           PRepType                                   MD026519
     C                   PARM      'A'           PTMode                                     MD026519
                                                                                            MD026519
     C                   CALL      'QCMDEXC'                                                MD026519
     C                   PARM                    ##OV2                                      MD026519
     C                   PARM                    WMsgLen                                    MD026519
                                                                                            MD026519
     C                   CALL      'QCMDEXC'                                                MD026519
     C                   PARM                    ##OV4                                      MD026519
     C                   PARM                    WMsgLen                                    MD026519
                                                                                            MD026519
     C                   CALL      'QCMDEXC'                                                MD027296
     C                   PARM                    ##OV6                                      MD027296
     C                   PARM                    WMsgLen                                    MD027296
                                                                                            MD027296
     C                   ENDIF                                                              MD026519
                                                                                            MD026519
     C**********         CALL      'QCMDEXC'                                       MD026705 MD027296
     C**********         PARM                    ##OV5                             MD026705 MD027296
     C**********         PARM                    WMsgLen                           MD026705 MD027296
      **********                                                                   MD026705 MD027296
     C**********         CALL      'QCMDEXC'                                       MD026705 MD027296
     C**********         PARM                    ##OV6                             MD026705 MD027296
     C**********         PARM                    WMsgLen                           MD026705 MD027296
      **********                                                                   MD026705 MD027296
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C**********         COMMIT                                                               CSD079
     C                   EndIf                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     DBerrUpd      MsgIdArr(1)
     C
     C                   END

      ** If CSD021 is on, get the customer number generated from the                        BUG16705
      ** program                                                                            BUG16705
                                                                                            BUG16705
     C                   IF        CSD021 = 'Y'                                             BUG16705
     C                   EVAL      DDCUSN = V_CUCUST                                        BUG16705
     C                   ENDIF                                                              BUG16705
                                                                                            BUG16705
     C                   ENDSR
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * SRUpdCUAH - Update SDCUAHPD                                   *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     SRUpdCUAH     BEGSR                                                                CER059
                                                                                              CER059
     C                   CALLB     'SDCUAHUPD'                                                CER059
     C                   PARM      *BLANKS       @RTCD                                        CER059
     C                   PARM                    UpdKey                                       CER059
     C                   PARM                    ValidCUAH                                    CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * SRUpdCCTX - Update SDACTXPD                                   *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     SRUpdCCTX     BEGSR                                                                CER059
                                                                                              CER059
      ** Update Records                                                                       CER059
                                                                                              CER059
     C                   CALLB     'SDCCTXUPD'                                                CER059
                                                                                              CER059
      ** Input Parameters                                                                     CER059
      ** ================                                                                     CER059
                                                                                              CER059
      ** Return Code                                                                          CER059
     C                   PARM      *BLANK        @RTCD                                        CER059
                                                                                              CER059
      ** Mode                                                                                 CER059
     C                   PARM      '*CUSDVU'     ParmMode                                     CER059
                                                                                              CER059
      ** Action Code                                                                          CER059
     C                   PARM                    PAction                                      CER059
                                                                                              CER059
      ** Customer Number                                                                      CER059
     C                   PARM                    V_CUCUST                                     CER059
                                                                                              CER059
      ** New Details in File Format                                                           CER059
     C                   PARM                    ValidCCTX                                    CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CSD079
      * ValdCuCumi - Validate Marketing Information                   *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCumi    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDLVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Customer Marketing Info                                                              CSD079
                                                                                              CSD079
     C                   PARM                    TranInCumi                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Customer Marketing Information - Ok inds                                             CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCumi                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Marketing Information (DS) from/to caller                                      CSD079
                                                                                              CSD079
     C                   PARM                    ValidCumi                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuCuad - Validate Additional Customer Details             *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCuad    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDAVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      **Additional customer Details                                                           CSD079
                                                                                              CSD079
     C                   PARM                    TranInCuad                                   CSD079
                                                                                              CSD079
      ** Customer Number                                                                      CSD079
                                                                                              CSD079
     C                   PARM                    DDCUSN                                       CSD079
                                                                                            AR739736
      ** Customer Number                                                                    AR739736
                                                                                            AR739736
     C                   PARM                    DDBNBI                                     AR739736
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Additional customer Details OK inds                                                  CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCuad                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Additional customer Details (DS) from/to caller                                CSD079
                                                                                              CSD079
     C                   PARM                    ValidCuad                                    CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * ValdCuACU3 - Validate Additional Customer Details tab 2       *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     ValdCuACU3    BEGSR                                                                CER059
                                                                                              CER059
     C                   CALLB     'SDACUD3VL'                                                CER059
                                                                                              CER059
      ** Inputs                                                                               CER059
      ** Response Mode                                                                        CER059
                                                                                              CER059
     C                   PARM      *BLANKS       RespMode                                     CER059
                                                                                              CER059
      ** Current Transaction Screen 2 Details                                                 CER059
                                                                                              CER059
     C                   PARM                    TranInACU3                                   CER059
                                                                                              CER059
      ** Customer                                                                             CER059
                                                                                              CER059
     C                   PARM                    DDCUSN                                       CER059
                                                                                            AR739532
      ** Country of Domicile                                                                AR739532
                                                                                            AR739532
     C                   PARM                    DDCOLC                                     AR739532
      ** Branch                                                                             AR740758
     C                   PARM                    DDBRCD                                     AR740758
      ** Country of Tax                                                                     AR740758
     C                   PARM                    V_CCTXArr                                  AR740758
                                                                                              CER059
      ** Joint Account Type                                                                   CER059
                                                                                              CER059
     C                   PARM                    ADDDJATP                                     CER059
                                                                                              CER059
      ** Identification Type                                                                  CER059
                                                                                              CER059
     C                   PARM                    ADDDIDTP                                     CER059
                                                                                              CER059
      ** Switchable Features                                                                  CER059
                                                                                              CER059
     C                   PARM                    CER047                                       CER059
     C                   PARM                    CER048                                       CER059
     C                   PARM                    CER054                                       CER059
                                                                                              CER059
      ** Outputs                                                                              CER059
      ** Transaction Details OK Inds                                                          CER059
                                                                                              CER059
     C                   PARM                    OKCuACU3                                     CER059
                                                                                              CER059
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER059
                                                                                              CER059
     C                   PARM                    FldNameArr                                   CER059
     C                   PARM                    MsgIDArr                                     CER059
     C                   PARM                    MsgDtaArr                                    CER059
                                                                                              CER059
      ** Array index (3P0) from/to caller                                                     CER059
                                                                                              CER059
     C                   PARM                    Idx                                          CER059
                                                                                              CER059
      ** Warning fields/message IDs/message data (arrays) from/to                             CER059
      ** caller                                                                               CER059
                                                                                              CER059
     C                   PARM                    WFldNamArr                                   CER059
     C                   PARM                    WMsgIDArr                                    CER059
     C                   PARM                    WMsgDtaArr                                   CER059
                                                                                              CER059
      ** Array index (3P0) from/to caller                                                     CER059
                                                                                              CER059
     C                   PARM                    WIdx                                         CER059
                                                                                              CER059
      ** Valid Transaction details layout (DS) from/to caller                                 CER059
                                                                                              CER059
     C                   PARM                    ValidCuad                                    CER059
                                                                                              CER059
      ** Indicator to check if defaulting has occured on this screen                          CER059
                                                                                              CER059
     C                   PARM                    DfltScrn1                                    CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * ValdCuACU4 - Validate Additional Customer Details tab 2       *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     ValdCuACU4    BEGSR                                                                CER059
                                                                                              CER059
      ** Validate New Additional Detail                                                       CER059
     C                   CALLB     'SDACUD4VL'                                                CER059
                                                                                              CER059
      ** Inputs                                                                               CER059
      ** Response Mode                                                                        CER059
     C                   PARM      *BLANKS       RespMode                                     CER059
                                                                                            MD024991
      * Action Code                                                                         MD024991
     C                   PARM                    DDACTN                                     MD024991
                                                                                              CER059
      ** Current Transaction Screen 2 Details                                                 CER059
     C                   PARM                    TranInACU4                                   CER059
                                                                                              CER059
      ** Customer                                                                             CER059
     C                   PARM                    DDCUSN                                       CER059
                                                                                              CER059
      ** Switchable Features                                                                  CER059
     C                   PARM                    CER034                                       CER059
     C                   PARM                    CER038                                       CER059
     C                   PARM                    CER041                                       CER059
                                                                                              CER059
      ** Outputs                                                                              CER059
      ** Transaction Details OK Inds                                                          CER059
     C                   PARM                    OKCuACU4                                     CER059
                                                                                              CER059
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER059
     C                   PARM                    FldNameArr                                   CER059
     C                   PARM                    MsgIDArr                                     CER059
     C                   PARM                    MsgDtaArr                                    CER059
                                                                                              CER059
      ** Array index (3P0) from/to caller                                                     CER059
     C                   PARM                    Idx                                          CER059
                                                                                              CER059
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER059
                                                                                              CER059
     C                   PARM                    WFldNamArr                                   CER059
     C                   PARM                    WMsgIDArr                                    CER059
     C                   PARM                    WMsgDtaArr                                   CER059
                                                                                              CER059
      ** Array index (3P0) from/to caller                                                     CER059
     C                   PARM                    WIdx                                         CER059
                                                                                              CER059
      ** Valid Transaction details layout (DS) from/to caller                                 CER059
     C                   PARM                    ValidCuad                                    CER059
                                                                                              CER059
      ** Pass the value of CER045                                                             CER059
                                                                                              CER059
     C                   PARM                    CER045                                       CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * ValdCuACU5 - Validate Additional Customer Details - TIN Detls *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
     C     ValdCuACU5    BEGSR                                                                CGL132
                                                                                              CGL132
      ** Validate New Additional Detail                                                       CGL132
     C                   CALLB     'SDACUD5VL'                                                CGL132
                                                                                              CGL132
      ** Inputs                                                                               CGL132
      ** Response Mode                                                                        CGL132
     C                   PARM      *BLANKS       RespMode                                     CGL132
                                                                                              CGL132
      ** Current Transaction Screen 2 Details                                                 CGL132
     C                   PARM                    TranInCUAD                                   CGL132
                                                                                              CGL132
      ** Customer                                                                             CGL132
     C                   PARM                    DDCUSN                                       CGL132
     C                   PARM                    DDCOLC                                     MD026540
                                                                                              CGL132
      ** Outputs                                                                              CGL132
      ** Transaction Details OK Inds                                                          CGL132
     C                   PARM                    OKCuACU5                                     CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Valid Transaction details layout (DS) from/to caller                                 CGL132
     C                   PARM                    ValidCuad                                    CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * ValdCUAH - Validate Customer Authority Holder details         *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     ValdCUAH      BEGSR                                                                CER059
                                                                                              CER059
      ** Clear Record in File Format                                                          CER059
     C                   CLEAR                   ValidCUAH                                    CER059
                                                                                              CER059
     C                   CALLB     'SDCUAHVAL'                                                CER059
     C                   PARM      *BLANKS       RespMode                                     CER059
     C                   PARM      *ZEROS        PAuthNum                                     CER059
     C                   PARM                    DDCUSN                                       CER059
     C                   PARM                    TranInCUAH1                                  CER059
     C                   PARM                    OkCuCUAH                                     CER059
     C                   PARM                    FldNameArr                                   CER059
     C                   PARM                    MsgIdArr                                     CER059
     C                   PARM                    MsgDtaArr                                    CER059
     C                   PARM                    Idx                                          CER059
     C                   PARM      *ZEROS        PErrorIndex                                  CER059
     C                   PARM                    WFldNamArr                                   CER059
     C                   PARM                    WMsgIdArr                                    CER059
     C                   PARM                    WMsgDtaArr                                   CER059
     C                   PARM                    WIdx                                         CER059
     C                   PARM                    ValidCUAH                                    CER059
      *                                                                                       CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * ValdCCTX - Validate Customer details by Country of tax        *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     ValdCCTX      BEGSR                                                                CER059
                                                                                              CER059
      ** Clear Record in File Format                                                          CER059
     C                   CLEAR                   ValidCCTX                                    CER059
                                                                                              CER059
     C                   CALLB     'SDCCTXVAL'                                                CER059
                                                                                              CER059
      ** Return Code                                                                          CER059
     C                   PARM      *BLANK        RetCodeOut                                   CER059
                                                                                              CER059
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CER059
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CER059
      ** Mode = '*RPR  ' (Repair function)                                                    CER059
      ** Mode = '*SIN  ' (Screen Input function)                                              CER059
      ** Mode = '*VU   ' (CSDU API)                                                           CER059
     C                   PARM      '*VU   '      ModeOfOp                                     CER059
                                                                                              CER059
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))                      CER059
     C                   PARM      *BLANK        RespMode                                     CER059
                                                                                              CER059
      ** New Details in Screen Format                                                         CER059
     C                   PARM                    TranInCCTX1                                  CER059
                                                                                              CER059
      ** Date Format Indicator                                                                CER059
     C                   PARM                    BJDFIN                                       CER059
                                                                                              CER059
      ** Rundate                                                                              CER059
     C                   PARM                    BJRDNB                                       CER059
                                                                                              CER059
     C                   PARM                    ValidCusd                                  AR740196
     C                   PARM                    ValidCuad                                  AR740196
      ** Output Parameters                                                                    CER059
      ** =================                                                                    CER059
                                                                                              CER059
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER059
     C                   PARM                    FldNameArr                                   CER059
     C                   PARM                    MsgIdArr                                     CER059
     C                   PARM                    MsgDtaArr                                    CER059
                                                                                              CER059
      ** Array index (3P0) from/to caller                                                     CER059
     C                   PARM                    Idx                                          CER059
                                                                                              CER059
      ** Screen error indicators                                                              CER059
     C                   PARM                    OkCuCCTX                                     CER059
                                                                                              CER059
      ** New Details in File Format                                                           CER059
     C                   PARM                    ValidCCTX                                    CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                     AR811594
      /EJECT                                                                                AR811594
      *****************************************************************                     AR811594
      *                                                               *                     AR811594
      * DftCCTX - Default Customer Details by Country of Tax          *                     AR811594
      *                                                               *                     AR811594
      *****************************************************************                     AR811594
     C     DftCCTX       BEGSR                                                              AR811594
                                                                                            AR811594
     C                   CALL      'SDCCTXDFT'                                              AR811594
                                                                                            AR811594
      ** Customer number                                                                    AR811594
     C                   PARM                    DDCUSN                                     AR811594
                                                                                            AR811594
      ** Country of location                                                                AR811594
     C                   PARM                    DDCOLC                                     AR811594
                                                                                            AR811594
      ** CCTX API Format Definition                                                         AR811594
     C                   PARM                    TranInCCTX                                 AR811594
                                                                                            AR811594
     C                   EVAL      CCTXArrDS = TranInCCTX                                   AR811594
                                                                                            AR811594
      ** Send warning message                                                               AR811594
     C                   IF        CCTXArrDS <> *BLANKS                                     AR811594
     C                   EVAL      WIdx = WIdx + 1                                          AR811594
     C                   EVAL      WFldNamArr(WIdx) = 'DDGPC2   '                           AR811594
     C                   EVAL      WMsgIdArr(WIdx) = 'USR8443'                              AR811594
     C                   ENDIF                                                              AR811594
                                                                                            AR811594
     C                   ENDSR                                                              AR811594
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuSfee - Validate Service Fees                            *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuSfee    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDBVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Service Fees                                                                         CSD079
                                                                                              CSD079
     C                   PARM                    TranInSfee                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Service Fees OK inds                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    OKCuSfee                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Service Fees (DS) from/to caller                                               CSD079
                                                                                              CSD079
     C                   PARM                    ValidSfee                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuChec - Validate Cheques and Card Details                *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuChec    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDCVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Cheques and Card Details                                                             CSD079
                                                                                              CSD079
     C                   PARM                    TranInChec                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Cheques and Card Details OK inds                                                     CSD079
                                                                                              CSD079
     C                   PARM                    OKCuChec                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Cheques and Card Details (DS) from/to caller                                   CSD079
                                                                                              CSD079
     C                   PARM                    ValidChec                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuCusf - Validate Safe Details                            *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCusf    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDDVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
     ** Safe Details                                                                          CSD079
                                                                                              CSD079
     C                   PARM                    TranInCusf                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Safe Details OK inds                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCusf                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Safe Details (DS) from/to caller                                               CSD079
                                                                                              CSD079
     C                   PARM                    ValidCusf                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuCufx - Validate Fx netting Details                      *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCufx    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDEVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Fx netting Details                                                                   CSD079
                                                                                              CSD079
     C                   PARM                    TranInCufx                                   CSD079
                                                                                              CSD079
      ** Customer Number                                                                      CSD079
                                                                                              CSD079
     C                   PARM                    DDCUSN                                       CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Fx netting Details OK inds                                                           CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCufx                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Fx netting Details (DS) from/to caller                                         CSD079
                                                                                              CSD079
     C                   PARM                    ValidCusd                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuCufd - Validate Fiduciary Details                       *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCufd    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDFVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Fiduciary Details                                                                    CSD079
                                                                                              CSD079
     C                   PARM                    TranInCufd                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Fiduciary Details OK inds                                                            CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCufd                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Fiduciary Details (DS) from/to caller                                          CSD079
                                                                                              CSD079
     C                   PARM                    ValidCusd                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuRwan - Validate Risk weighted assets                    *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuRwan    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDRWANVAL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Risk weighted assets                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    TranInRwan                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Risk weighted assets OK inds                                                         CSD079
                                                                                              CSD079
     C                   PARM                    OKCuRwan                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Risk weighted assets (DS) from/to caller                                       CSD079
                                                                                              CSD079
     C                   PARM                    ValidRwan                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuCufo - Validate Futures and Option                      *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCufo    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDHVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Futures and Option                                                                   CSD079
                                                                                              CSD079
     C                   PARM                    TranInCufo                                   CSD079
     C                   PARM                    ULX004                                       CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Futures and Option OK inds                                                           CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCufo                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Futures and Option (DS) from/to caller                                         CSD079
                                                                                              CSD079
     C                   PARM                    ValidCufo                                    CSD079
     C                   PARM                    ValidCufn                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuCupm - Validate Portfolio Management                    *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuCupm    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDIVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Portfolio Management                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    TranInCupm                                   CSD079
                                                                                              CSD079
      ** Customer Number                                                                      CSD079
                                                                                              CSD079
     C                   PARM                    DDCUSN                                       CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Portfolio Management OK inds                                                         CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCupm                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Portfolio Management (DS) from/to caller                                       CSD079
                                                                                              CSD079
     C                   PARM                    ValidCupm                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCuTicd - Validate Trade Innovation                        *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCuTicd    BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSDKVL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
                                                                                              CSD079
      ** Trade Innovation                                                                     CSD079
                                                                                              CSD079
     C                   PARM                    TranInTicd                                   CSD079
                                                                                              CSD079
      ** Customer Number                                                                      CSD079
                                                                                              CSD079
     C                   PARM                    DDCUSN                                       CSD079
                                                                                              CSD079
      ** Bank/Non Bank-ID                                                                     CSD079
                                                                                              CSD079
     C                   PARM                    DDBNBI                                       CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Trade Innovation OK inds                                                             CSD079
                                                                                              CSD079
     C                   PARM                    OKCuTicd                                     CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Trade Innovation(DS) from/to caller                                            CSD079
                                                                                              CSD079
     C                   PARM                    ValidTicd                                    CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCulx2 - Validate Lux(European Reporting)                  *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCulx2     BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUSD9VL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
      *                                                                                       CSD079
     C                   PARM                    PDATA                                        CSD079
                                                                                              CSD079
      ** Lux(European Reporting) & (IBLC - Extended Information)                              CSD079
                                                                                              CSD079
     C                   PARM                    TranInCurx                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Lux (European Reporting) OK inds                                                     CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCulx2                                    CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Lux (European Reporting) (DS) from/to caller                                   CSD079
                                                                                              CSD079
     C                   PARM                    ValidCulx2                                   CSD079
     C                   PARM                    ULX008                                       CSD079
     C                   PARM                    ULX012                                       CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * ValdCulx1 - Validate Lux(IBLC -Extended Information)          *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ValdCulx1     BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'SDCUS10VL'                                                CSD079
                                                                                              CSD079
      ** INPUTS                                                                               CSD079
      ** Response mode                                                                        CSD079
                                                                                              CSD079
     C                   PARM      'S'           RespMode                                     CSD079
      *                                                                                       CSD079
     C                   PARM                    PDATA                                        CSD079
                                                                                              CSD079
      ** Lux(European Reporting) & (IBLC - Extended Information)                              CSD079
                                                                                              CSD079
     C                   PARM                    TranInCurx                                   CSD079
                                                                                              CSD079
      ** OUTPUTS                                                                              CSD079
      ** Lux(IBLC -Extended Information) OK inds                                              CSD079
                                                                                              CSD079
     C                   PARM                    OKCuCulx1                                    CSD079
                                                                                              CSD079
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    Idx                                          CSD079
                                                                                              CSD079
      ** Warning fields/message IDs/message data (arrays) from/to                             CSD079
      ** caller                                                                               CSD079
                                                                                              CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
                                                                                              CSD079
      ** Array index (3P0) from/to caller                                                     CSD079
                                                                                              CSD079
     C                   PARM                    WIdx                                         CSD079
                                                                                              CSD079
      ** Valid Lux(IBLC -Extended Information) (DS) from/to caller                            CSD079
                                                                                              CSD079
     C                   PARM                    ValidCulx1                                   CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * ValdCuFTCS1 - Validate FATCA Customer info 1                  *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     ValdCuFTCS1   BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTCS1VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Response mode                                                                        CGL132
                                                                                              CGL132
     C                   PARM      'S'           RespMode                                     CGL132
                                                                                              CGL132
      ** FATCA customer details                                                               CGL132
                                                                                              CGL132
     C                   PARM                    TranInFTCR                                   CGL132
                                                                                              CGL132
      ** Previous FATCA customer details                                                      CGL132
                                                                                              CGL132
     C                   PARM                    CurCuFTCR                                    CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
                                                                                              CGL132
     C                   PARM                    OKCuFTCS                                     CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
                                                                                              CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to                             CGL132
      ** caller                                                                               CGL132
                                                                                              CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA Customer Detail(DS) from/to caller                                       CGL132
                                                                                              CGL132
     C                   PARM                    ValidFTCS                                    CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * ValdCuFTCS2 - Validate FATCA Customer info 2                  *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     ValdCuFTCS2   BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTCS2VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Response mode                                                                        CGL132
                                                                                              CGL132
     C                   PARM      'S'           RespMode                                     CGL132
                                                                                              CGL132
      ** FATCA customer details                                                               CGL132
                                                                                              CGL132
     C                   PARM                    TranInFTCR                                   CGL132
                                                                                              CGL132
      ** Previous FATCA customer details                                                      CGL132
                                                                                              CGL132
     C                   PARM                    CurCuFTCR                                    CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
                                                                                              CGL132
     C                   PARM                    OKCuFTCS                                     CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
                                                                                              CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to                             CGL132
      ** caller                                                                               CGL132
                                                                                              CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA Customer Detail(DS) from/to caller                                       CGL132
                                                                                              CGL132
     C                   PARM                    ValidFTCS                                    CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * ValdCuFTCS3 - Validate FATCA Customer info 3                  *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     ValdCuFTCS3   BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTCS3VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Response mode                                                                        CGL132
                                                                                              CGL132
     C                   PARM      'S'           RespMode                                     CGL132
                                                                                              CGL132
      ** FATCA customer details                                                               CGL132
                                                                                              CGL132
     C                   PARM                    TranInFTCR                                   CGL132
                                                                                              CGL132
      ** Previous FATCA customer details                                                      CGL132
                                                                                              CGL132
     C                   PARM                    CurCuFTCR                                    CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
                                                                                              CGL132
     C                   PARM                    OKCuFTCS                                     CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
                                                                                              CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to                             CGL132
      ** caller                                                                               CGL132
                                                                                              CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA Customer Detail(DS) from/to caller                                       CGL132
                                                                                              CGL132
     C                   PARM                    ValidFTCS                                    CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * ValdCuFTCS4 - Validate FATCA Customer info 4                  *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     ValdCuFTCS4   BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTCS4VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Response mode                                                                        CGL132
                                                                                              CGL132
     C                   PARM      'S'           RespMode                                     CGL132
                                                                                              CGL132
      ** FATCA customer details                                                               CGL132
                                                                                              CGL132
     C                   PARM                    TranInFTCR                                   CGL132
                                                                                              CGL132
      ** Previous FATCA customer details                                                      CGL132
                                                                                              CGL132
     C                   PARM                    CurCuFTCR                                    CGL132
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
                                                                                              CGL132
     C                   PARM                    OKCuFTCS                                     CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
                                                                                              CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to                             CGL132
      ** caller                                                                               CGL132
                                                                                              CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA Customer Detail(DS) from/to caller                                       CGL132
                                                                                              CGL132
     C                   PARM                    ValidFTCS                                    CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * ValdCuFTCS5 - Validate FATCA Customer info 5                  *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     ValdCuFTCS5   BEGSR                                                                CGL132
                                                                                              CGL132
     C                   MOVE      DDCUSN        FSDDCUST                                   MD042966
     C                   EVAL      PADOMC = V_CUCOLC                                        MD042966
     C                   EVAL      PACNCZ = V_CUCNCZ                                        MD042966
     C                   CALLB     'SDFTCS5VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS                                                                               CGL132
      ** Response mode                                                                        CGL132
                                                                                              CGL132
     C                   PARM      'S'           RespMode                                     CGL132
                                                                                              CGL132
      ** FATCA customer details                                                               CGL132
                                                                                              CGL132
     C                   PARM                    TranInFTCR                                   CGL132
                                                                                              CGL132
      ** Previous FATCA customer details                                                      CGL132
                                                                                              CGL132
     C                   PARM                    CurCuFTCR                                    CGL132
                                                                                              CGL132
      ** Additional customer details                                                          CGL132
     C                   PARM                    TranInCuad                                   CGL132
                                                                                           MD026550A
      ** Customer Creation Date                                                            MD026550A
     C**********         PARM      DDCRDT        P_CRDT            8              MD026550A MD026997
     C                   PARM      XCDDCRDT      P_CRDT            8                        MD026997
     C                   PARM      DDCOLC        PPCOLC                                     MD026693
     C                   PARM                    ValidCuxc                                  MD026497
     C                   PARM                    PAPARM                                     MD042692
                                                                                              CGL132
      ** OUTPUTS                                                                              CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
                                                                                              CGL132
     C                   PARM                    OKCuFTCS                                     CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
                                                                                              CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to                             CGL132
      ** caller                                                                               CGL132
                                                                                              CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
                                                                                              CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA Customer Detail(DS) from/to caller                                       CGL132
                                                                                              CGL132
     C                   PARM                    ValidFTCS                                    CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CSD079
      /EJECT                                                                               AR1086546
      *****************************************************************                    AR1086546
      *                                                               *                    AR1086546
      * ValdCuCtnm - Validate Currency/Time of Netting Details        *                    AR1086546
      *                                                               *                    AR1086546
      *****************************************************************                    AR1086546
     C     ValdCuCtnm    BEGSR                                                             AR1086546
                                                                                           AR1086546
     C                   CALLB     'SDCTNMVAL'                                             AR1086546
                                                                                           AR1086546
      ** INPUTS                                                                            AR1086546
      ** Response mode                                                                     AR1086546
                                                                                           AR1086546
     C                   PARM      'S'           RespMode                                  AR1086546
                                                                                           AR1086546
      ** Currency/Time of Netting                                                          AR1086546
                                                                                           AR1086546
     C                   PARM                    TranInCtnm                                AR1086546
                                                                                           AR1086546
      ** OUTPUTS                                                                           AR1086546
      ** Currency/Time of Netting OK Inds                                                  AR1086546
                                                                                           AR1086546
     C                   PARM                    OKCuCtnm                                  AR1086546
                                                                                           AR1086546
      ** Error fields/message IDs/message data (arrays) from/to caller                     AR1086546
                                                                                           AR1086546
     C                   PARM                    FldNameArr                                AR1086546
     C                   PARM                    MsgIDArr                                  AR1086546
     C                   PARM                    MsgDtaArr                                 AR1086546
                                                                                           AR1086546
      ** Array index (3P0) from/to caller                                                  AR1086546
                                                                                           AR1086546
     C                   PARM                    Idx                                       AR1086546
                                                                                           AR1086546
      ** Warning fields/message IDs/message data (arrays) from/to                          AR1086546
      ** caller                                                                            AR1086546
                                                                                           AR1086546
     C                   PARM                    WFldNamArr                                AR1086546
     C                   PARM                    WMsgIDArr                                 AR1086546
     C                   PARM                    WMsgDtaArr                                AR1086546
                                                                                           AR1086546
      ** Array index (3P0) from/to caller                                                  AR1086546
                                                                                           AR1086546
     C                   PARM                    WIdx                                      AR1086546
                                                                                           AR1086546
      ** Valid Currency/Time of Netting (DS) from/to caller                                AR1086546
                                                                                           AR1086546
     C                   PARM                    ValidCtnm                                 AR1086546
     C                   ENDSR                                                             AR1086546
      *****************************************************************                    AR1086546
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  Retrieve Int Cust Branch - Branch Codes                      *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     CSR   TWRVGN        BEGSR                                                                CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C**********         EVAL      DDCUSN = %SUBST(Trans5001:2:6)                      CSD079 CSW213
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
      * SrZDate - Convert date to midas date format                   *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     SrZDate       BEGSR                                                                CER059
                                                                                              CER059
     C                   CALLB     'ZDATE1'                                                   CER059
     C                   PARM                    DateIn                                       CER059
     C                   PARM                    DaynoOut                                     CER059
     C                   PARM                    BJDFIN                                       CER059
     C                   PARM                    ErrorFlag                                    CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C**********         PARM                    Trans5001                                    CSW213
     C**********         PARM                    Trans5002                                    CSW213
     C**********         PARM                    Trans507A                           BUG14803 CSW213
     C**********         PARM                    Trans5003                                    CSW213
     C**********         PARM                    Trans5004                                    CSW213
     C**********         PARM                    Trans5005                                    CSW213
     C**********         PARM                    Trans5006                                    CSW213
     C***********        PARM                    Trans507A                         BUG14485 BUG14803
     C**********         PARM                    Trans5007                             CSD079 CSW213
     C**********         PARM                    Trans5008                             CSD079 CSW213
     C**********         PARM                    Trans508A                             CSD079 CSW213
     C**********         PARM                    Trans508B                             CSD079 CSW213
     C**********         PARM                    Trans5083                             CER059 CSW213
     C**********         PARM                    Trans5084                             CER059 CSW213
     C**********         PARM                    Trans5009                             CSD079 CSW213
     C**********         PARM                    Trans5010                             CSD079 CSW213
     C**********         PARM                    Trans501X                             CSD079 CSW213
     C**********         PARM                    Trans5011                             CSD079 CSW213
     C**********         PARM                    Trans5012                             CSD079 CSW213
     C**********         PARM                    Trans5013                             CSD079 CSW213
     C**********         PARM                    Trans5014                             CSD079 CSW213
     C**********         PARM                    Trans5015                             CSD079 CSW213
     C**********         PARM                    Trans5016                             CSD079 CSW213
     C**********         PARM                    TransSW                             BUG14992 CSW213
     C**********         PARM                    RegData500                            CSD079 CSW213
     C**********         PARM                    Trans5017                             CSD079 CSW213
     C**********         PARM                    TransStmTax                           CER049 CSW213
     C**********         PARM                    TransCUA1                             CER059 CSW213
     C**********         PARM                    TransCUA2                             CER059 CSW213
     C**********         PARM                    TransCUA3                             CER059 CSW213
     C**********         PARM                    TransCCT1                             CER059 CSW213
     C**********         PARM                    TransCCT2                             CER059 CSW213
     C**********         PARM                    TransCCT3                             CER059 CSW213
     C**********         PARM                    TransCCT4                             CER059 CSW213
     C**********         PARM                    TransCCT5                             CER059 CSW213
     C**********         PARM                    TransCCT6                             CER059 CSW213
     C                   PARM                    Trans5018                                 AR1086546
     C**********         PARM                    ExtData500                                   CSW213
     C                   PARM                    TransInTot                                   CSW213
     C                   PARM                    TransInEx2                                   CSW213
     C                   PARM                    TransInEx3                                   CSW213
     C                   PARM                    TransInEx4                                   CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C**********         PARM                    Buffer         6000                          CER059
     C                   PARM                    Buffer         9999                          CER059
     C                   PARM                    BufferEx2      9999                          CSW213
     C                   PARM                    BufferEx3      9999                          CSW213
     C                   PARM                    BufferEx4      9999                          CSW213
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG4196
     C                   PARM                    AAuth             1                        BUG22143

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(4) = 'MIDAS'                                     CSD079
     C                   EVAL      MsgFArray(5) = 'STUSRMSG'                                  CER059

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDCUSDM01

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access SAR details file to determine if S01383 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVEL     'S01383'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *                                                                                       222373
      ** Access SAR details file to determine if CSW024 is on.                                222373
      *                                                                                       222373
     C                   CALLB     'AOSARDR0'                                                 222373
     C                   PARM      *BLANKS       @RTCD                                        222373
     C                   PARM      '*VERIFY'     @OPTN                                        222373
     C                   PARM      'CSW024'      @SARD                                        222373
     C     SCSARD        PARM      SCSARD        DSFDY                                        222373
      *                                                                                       222373
      * Database Error                                                                        222373
      *                                                                                       222373
     C     @RTCD         IFNE      *BLANKS                                                    222373
     C     @RTCD         ANDNE     '*NRF   '                                                  222373
     C                   MOVEL     'SCSARDPD'    DBFILE                                       222373
     C                   Z-ADD     11            DBASE                                        222373
     C                   MOVEL     'CSW024'      DBKEY                                        222373
     C                   EXSR      *PSSR                                                      222373
     C                   END                                                                  222373
      *                                                                                       222373
     C     @RTCD         IFEQ      *BLANK                                                     222373
     C                   MOVEL     'Y'           CSW024            1                          222373
     C                   ELSE                                                                 222373
     C                   MOVEL     'N'           CSW024                                       222373
     C                   END                                                                  222373
                                                                                              222373
      *                                                                                       222373
      ** Access SAR details file to determine if CGP001 is on.                                222373
      *                                                                                       222373
     C                   CALLB     'AOSARDR0'                                                 222373
     C                   PARM      *BLANKS       @RTCD                                        222373
     C                   PARM      '*VERIFY'     @OPTN                                        222373
     C                   PARM      'CGP001'      @SARD                                        222373
     C     SCSARD        PARM      SCSARD        DSFDY                                        222373
      *                                                                                       222373
      * Database Error                                                                        222373
      *                                                                                       222373
     C     @RTCD         IFNE      *BLANKS                                                    222373
     C     @RTCD         ANDNE     '*NRF   '                                                  222373
     C                   MOVEL     'SCSARDPD'    DBFILE                                       222373
     C                   Z-ADD     12            DBASE                                        222373
     C                   MOVEL     'CGP001'      DBKEY                                        222373
     C                   EXSR      *PSSR                                                      222373
     C                   END                                                                  222373
      *                                                                                       222373
     C     @RTCD         IFEQ      *BLANK                                                     222373
     C                   MOVEL     'Y'           CGP001            1                          222373
     C                   ELSE                                                                 222373
     C                   MOVEL     'N'           CGP001                                       222373
     C                   END                                                                  222373
                                                                                              222373
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
                                                                                             BUG5082
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                         BUG5082
                                                                                             BUG5082
     C                   CALLB     'AOSARDR0'                                                BUG5082
     C                   PARM      *BLANKS       PRTCD                                       BUG5082
     C                   PARM      '*VERIFY'     POPTN                                       BUG5082
     C                   PARM      'CLE025'      PSARD                                       BUG5082
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5082
                                                                                             BUG5082
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG5082
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG5082
     C                   EVAL      DBKEY  = 'CLE025'                                         BUG5082
     C                   EVAL      DBASE  = 902                                              BUG5082
     C                   EXSR      *PSSR                                                     BUG5082
     C                   ENDIF                                                               BUG5082
      *                                                                                      BUG5082
     C                   IF        PRTCD = *BLANKS                                           BUG5082
     C                   EVAL      CLE025 = 'Y'                                              BUG5082
     C                   ELSE                                                                BUG5082
     C                   EVAL      CLE025 = 'N'                                              BUG5082
     C                   ENDIF                                                               BUG5082
                                                                                             BUG5082
      ** Check if enhancement CFX001 (FX Margin Trading) is on                               BUG5082
                                                                                             BUG5082
     C                   CALLB     'AOSARDR0'                                                BUG5082
     C                   PARM      *BLANKS       PRTCD                                       BUG5082
     C                   PARM      '*VERIFY'     POPTN                                       BUG5082
     C                   PARM      'CFX001'      PSARD                                       BUG5082
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5082
                                                                                             BUG5082
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG5082
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG5082
     C                   EVAL      DBKEY  = 'CFX001'                                         BUG5082
     C                   EVAL      DBASE  = 903                                              BUG5082
     C                   EXSR      *PSSR                                                     BUG5082
     C                   ENDIF                                                               BUG5082
      *                                                                                      BUG5082
     C                   IF        PRTCD = *BLANKS                                           BUG5082
     C                   EVAL      CFX001 = 'Y'                                              BUG5082
     C                   ELSE                                                                BUG5082
     C                   EVAL      CFX001 = 'N'                                              BUG5082
     C                   ENDIF                                                               BUG5082
      *                                                                                       CSC022
      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   If        @RTCD = *BLANKS                                            CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Check if Current Job exists in the Commitment Job Names                              CSC022
      ** Data Area.                                                                           CSC022
     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
     C                   If        *IN20                                                      CSC022
     C                   Eval      wCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      ** Database error                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         In        LDA                                                        CSC022
     C                   Eval      DBKey = 'CSC022'                                           CSC022
     C                   Eval      DBPgm = 'FXFXDLVU'                                         CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 904                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
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
     C                   EVAL      DBASE  = 905                                               CSD079
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
     C                   EVAL      DBASE  = 906                                               CSD079
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
     C                   EVAL      DBASE  = 907                                               CSD079
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
     C                   EVAL      DBASE  = 908                                               CSD079
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
     C                   EVAL      DBASE  = 909                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CGL018 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CGL018 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CSD079 is on                                                    CSD079
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
     C                   EVAL      DBASE  = 910                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD079 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD079 = 'N'                                               CSD079
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
     C                   EVAL      DBASE  = 912                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX004 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX004 = 'N'                                               CSD079
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
     C                   EVAL      DBASE  = 913                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX043 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX043 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX008 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX008'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX008'                                          CSD079
     C                   EVAL      DBASE  = 914                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX008 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX008 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX012 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX012'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX012'                                          CSD079
     C                   EVAL      DBASE  = 915                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX012 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX012 = 'N'                                               CSD079
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
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX609 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX609 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
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
     C                   EVAL      DBASE  = 919                                            AR1086546
     C                   EXSR      *PSSR                                                   AR1086546
     C                   ENDIF                                                             AR1086546
      *                                                                                    AR1086546
     C                   IF        PRTCD = *BLANKS                                         AR1086546
     C                   EVAL      CDL025 = 'Y'                                            AR1086546
     C                   ELSE                                                              AR1086546
     C                   EVAL      CDL025 = 'N'                                            AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
      ** Check if enhancement for portfolio Management                                        CSD079
                                                                                              CSD079
     C     BGPFMG        IFEQ      'Y'                                                        CSD079
     C                   CALLB     'AOPORTR0'                                                 CSD079
     C                   PARM      '*MSG    '    @RTCD                                        CSD079
     C                   PARM      '*FIRST  '    @OPTN                                        CSD079
     C     SDPORT        PARM      SDPORT        DSSDY                                        CSD079
                                                                                              CSD079
      ** Database Error                                                                       CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANK                                                     CSD079
     C                   MOVEL     @OPTN         DBKEY                                        CSD079
     C                   MOVEL     'SDPORTPD'    DBFILE                                       CSD079
     C                   MOVEL     911           DBASE                                        CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   END                                                                  CSD079
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
     C                   END                                                                  CSD079
     C                   END                                                                  CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           WUPMSC                                       CSD079
     C                   END                                                                  CSD079
                                                                                              CSD079
      ** Get Rundat                                                                           CSD079
                                                                                              CSD079
     C     *DTAARA       DEFINE                  RUNDAT                                       CSD079
     C                   IN        RUNDAT                                                     CSD079
                                                                                              CSD079
      ** Check if SWIFT 2007 is installed                                                   BUG14992
                                                                                            BUG14992
     C                   CALL      'SWIF2007'                                               BUG14992
     C                   PARM      *BLANKS       PRTCD                                      BUG14992
                                                                                            BUG14992
     C                   IF        PRTCD = 'CSW2007'                                        BUG14992
     C                   EVAL      CSW207 = 'Y'                                             BUG14992
     C                   ELSE                                                               BUG14992
     C                   EVAL      CSW207 = 'N'                                             BUG14992
     C                   ENDIF                                                              BUG14992
                                                                                            BUG14992
     C                   CALLB     'AOSARDR0'                                               BUG16705
     C                   PARM      *BLANKS       PRTCD                                      BUG16705
     C                   PARM      '*VERIFY'     POPTN                                      BUG16705
     C                   PARM      'CSD021'      PSARD                                      BUG16705
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG16705
                                                                                            BUG16705
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                BUG16705
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG16705
     C                   EVAL      DBKEY  = 'CSD021'                                        BUG16705
     C                   EVAL      DBASE  = 917                                             BUG16705
     C                   EXSR      *PSSR                                                    BUG16705
     C                   ENDIF                                                              BUG16705
      *                                                                                     BUG16705
     C                   IF        PRTCD = *BLANKS                                          BUG16705
     C                   EVAL      CSD021 = 'Y'                                             BUG16705
     C                   ELSE                                                               BUG16705
     C                   EVAL      CSD021 = 'N'                                             BUG16705
     C                   ENDIF                                                              BUG16705
      *                                                                                     AR316373
      ** Access SAR details file to determine if LLN007 is on.                              AR316373
      *                                                                                     AR316373
     C                   CALLB     'AOSARDR0'                                               AR316373
     C                   PARM      *BLANKS       @RTCD                                      AR316373
     C                   PARM      '*VERIFY'     @OPTN                                      AR316373
     C                   PARM      'LLN007'      @SARD                                      AR316373
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR316373
      *                                                                                     AR316373
      ** Database Error                                                                     AR316373
      *                                                                                     AR316373
     C     @RTCD         IFNE      *BLANKS                                                  AR316373
     C     @RTCD         ANDNE     '*NRF   '                                                AR316373
     C                   MOVEL     'SCSARDPD'    DBFILE                                     AR316373
     C                   Z-ADD     918           DBASE                                      AR316373
     C                   MOVEL     'LLN007'      DBKEY                                      AR316373
     C                   EXSR      *PSSR                                                    AR316373
     C                   ENDIF                                                              AR316373
      *                                                                                     AR316373
     C     @RTCD         IFEQ      *BLANK                                                   AR316373
     C                   MOVEL     'Y'           LLN007            1                        AR316373
     C                   ELSE                                                               AR316373
     C                   MOVEL     'N'           LLN007                                     AR316373
     C                   ENDIF                                                              AR316373
                                                                                              CER059
      ** Check if enhancement CER034 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER034'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER034'                                          CER059
     C                   EVAL      DBASE  = 918                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER034 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER034 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Check if enhancement CER038 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER038'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER038'                                          CER059
     C                   EVAL      DBASE  = 919                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER038 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER038 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Check if enhancement CER041 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER041'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER041'                                          CER059
     C                   EVAL      DBASE  = 920                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER041 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER041 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Check if enhancement CER045 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER045'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER045'                                          CER059
     C                   EVAL      DBASE  = 921                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER045 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER045 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Check if enhancement CER047 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER047'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER047'                                          CER059
     C                   EVAL      DBASE  = 922                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER047 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER047 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Check if enhancement CER048 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER048'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER048'                                          CER059
     C                   EVAL      DBASE  = 923                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER048 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER048 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Check if enhancement CER054 is on                                                    CER059
                                                                                              CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRTCD                                        CER059
     C                   PARM      '*VERIFY'     POPTN                                        CER059
     C                   PARM      'CER054'      PSARD                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER059
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER059
     C                   EVAL      DBKEY  = 'CER054'                                          CER059
     C                   EVAL      DBASE  = 924                                               CER059
     C                   EXSR      *PSSR                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   IF        PRTCD = *BLANKS                                            CER059
     C                   EVAL      CER054 = 'Y'                                               CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      CER054 = 'N'                                               CER059
     C                   ENDIF                                                                CER059
                                                                                            AR728530
     C                   CALLB     'AOSARDR0'                                               AR728530
     C                   PARM      *BLANKS       PRTCD                                      AR728530
     C                   PARM      '*VERIFY'     POPTN                                      AR728530
     C                   PARM      'CGL031'      PSARD                                      AR728530
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR728530
                                                                                            AR728530
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                AR728530
     C                   EVAL      DBFILE = 'SCSARDPD'                                      AR728530
     C                   EVAL      DBKEY  = 'CGL031'                                        AR728530
     C                   EVAL      DBASE  = 918                                             AR728530
     C                   EXSR      *PSSR                                                    AR728530
     C                   ENDIF                                                              AR728530
      *                                                                                     AR728530
     C                   IF        PRTCD = *BLANKS                                          AR728530
     C                   EVAL      CGL031 = 'Y'                                             AR728530
     C                   ELSE                                                               AR728530
     C                   EVAL      CGL031 = 'N'                                             AR728530
     C                   ENDIF                                                              AR728530
                                                                                            AR728530
     C                   CALLB     'AOSARDR0'                                               AR728530
     C                   PARM      *BLANKS       PRTCD                                      AR728530
     C                   PARM      '*VERIFY'     POPTN                                      AR728530
     C                   PARM      'CGL032'      PSARD                                      AR728530
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR728530
                                                                                            AR728530
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                AR728530
     C                   EVAL      DBFILE = 'SCSARDPD'                                      AR728530
     C                   EVAL      DBKEY  = 'CGL032'                                        AR728530
     C                   EVAL      DBASE  = 919                                             AR728530
     C                   EXSR      *PSSR                                                    AR728530
     C                   ENDIF                                                              AR728530
      *                                                                                     AR728530
     C                   IF        PRTCD = *BLANKS                                          AR728530
     C                   EVAL      CGL032 = 'Y'                                             AR728530
     C                   ELSE                                                               AR728530
     C                   EVAL      CGL032 = 'N'                                             AR728530
     C                   ENDIF                                                              AR728530
                                                                                            AR728530
      ** Check if CSD090 is installed                                                         CSD090
                                                                                              CSD090
     C                   CALLB     'AOSARDR0'                                                 CSD090
     C                   PARM      *BLANKS       PRTCD                                        CSD090
     C                   PARM      '*VERIFY'     POPTN                                        CSD090
     C                   PARM      'CSD090'      PSARD                                        CSD090
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD090
                                                                                              CSD090
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD090
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD090
     C                   EVAL      DBKEY  = 'CSD090'                                          CSD090
     C                   EVAL      DBASE  = 925                                               CSD090
     C                   EXSR      *PSSR                                                      CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
     C                   IF        PRTCD = *BLANKS                                            CSD090
     C                   EVAL      CSD090 = 'Y'                                               CSD090
     C                   ELSE                                                                 CSD090
     C                   EVAL      CSD090 = 'N'                                               CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
      ** Check if CGL132 is installed                                                         CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRTCD                                        CGL132
     C                   PARM      '*VERIFY'     POPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBKEY  = 'CGL132'                                          CGL132
     C                   EVAL      DBASE  = 926                                               CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PRTCD = *BLANKS                                            CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
                                                                                            MD026519
      ** Check if CGL133 is switched on                                                     MD026519
                                                                                            MD026519
     C                   CALLB     'AOSARDR0'                                               MD026519
     C                   PARM      *BLANKS       @RTCD                                      MD026519
     C                   PARM      '*VERIFY'     @OPTN                                      MD026519
     C                   PARM      'CGL133'      @SARD                                      MD026519
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD026519
                                                                                            MD026519
      ** Database error                                                                     MD026519
                                                                                            MD026519
     C     @RTCD         IFNE      *BLANKS                                                  MD026519
     C     @RTCD         ANDNE     '*NRF   '                                                MD026519
     C                   MOVEL     'SCSARDPD'    DBFILE                                     MD026519
     C                   MOVEL     '918'         DBASE                                      MD026519
     C                   MOVEL     'CGL133'      DBKEY                                      MD026519
     C                   EXSR      *PSSR                                                    MD026519
     C                   ENDIF                                                              MD026519
                                                                                            MD026519
     C     @RTCD         IFEQ      *BLANK                                                   MD026519
     C                   MOVEL     'Y'           CGL133            1                        MD026519
     C                   ELSE                                                               MD026519
     C                   MOVEL     'N'           CGL133                                     MD026519
     C                   ENDIF                                                              MD026519
                                                                                            MD026519
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
     C                   EVAL      DBASE  = 927                                             MD030956
     C                   EXSR      *PSSR                                                    MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
     C                   IF        @RTCD  = *BLANKS                                         MD030956
     C                   EVAL      CTI006 = 'Y'                                             MD030956
     C                   ELSE                                                               MD030956
     C                   EVAL      CTI006 = 'N'                                             MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
                                                                                              CGL132
      /COPY WNCPYSRC,SDCUSDVU03
     C                   ENDSR
                                                                                             BUG5082
      /COPY WNCPYSRC,SDCUSDVU05
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** ##OX1
OVRDBF FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)
** ##OV1
OVRDBF FILE(SDFTCSL0) TOFILE(SDFTCSL0) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDFTCSL0)
** ##OV3
OVRDBF FILE(SDCUSTL0) TOFILE(SDCUSTL0) SHARE(*NO)
** ##OV4
DLTOVR FILE(SDCUSTL0)
** ##OV5
OVRDBF FILE(SDCUAHLA) TOFILE(SDCUAHLA) SHARE(*NO)
** ##OV6
DLTOVR FILE(SDCUAHLA)
