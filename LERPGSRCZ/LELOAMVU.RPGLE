     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendment validate and update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LELOAMVU - Loan amendment validate and update                *
      *                                                               *
      *                                                               *
      *  Function: This Program Validates LE Loan Amendment for       *
      *            Input into the Midas database.                     *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD029046           Date 27Nov19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD051890           Date 17Sep18               *
      *                 MD039547           Date 20Sep16               *
      *                 CLE071             Date 18Jul18               *
      *                 MD041649           Date 29Sep16               *
      *                 MD046248           Date 27Oct17               *
      *                 AR878735           Date 13Dec11               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD021423E          Date 12Sep13               *
      *                 AR868380           Date 19Jun13               *
      *                 MD020736           Date 05Jun13               *
      *                 AR1070223          Date 19Dec12               *
      *                 AR1095624          Date 13Mar13               *
      *                 AR1021983          Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR852654           Date 20Oct11               *
      *                 CSF011             Date 12Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 243270             Date 03Nov06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22169           Date 27Jan09               *
      *                 256564             Date 17Sep08               *
      *                 247172             Date 10May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243619A            Date 20Nov06               *
      *                 243619             Date 08Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240917             Date 24Aug06               *
      *                 BUG11406           Date 25May06               *
      *                 BUG8758            Date 19Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9550            Date 07Dec05               *
      *                 BUG9493            Date 07Dec05               *
      *                 BUG9492            Date 05Dec05               *
      *                 BUG8294            Date 25Aug05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4486            Date 08Oct04               *
      *                 BUG2480            Date 26May04               *
      *                 BUG1373_R          Date 30Apr04               *
      *                 BUG1373            Date 28Apr04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA091             Date 31Mar04               *
      *                 TDA066             Date 22Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 06Jan04               *
      *                 CLE034             Date 29Oct03               *
      *                 222373             Date 29Oct03               *
      *                 CDE005             Date 07Nov02               *
      *                 CLE030             Date 02Oct02               *
      *                 CAP084  *CREATE    Date 02Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029046 - Default Principal Increase settlement from        *
      *             SSI (standard settlement instructions) before     *
      *             trying to default from loan.                      *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD051890 - Missing Principal Projection on Nostro Account    *
      *  MD039547 - Referred account is not properly validated.       *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD041649 - Validation during authorisation should be executed*
      *  MD046248 - Finastra Rebranding                               *
      *  AR878735 - Field CVMR not properly inserted/updated in       *
      *             LOAMSDK. Ensure that CVMR will be written in file *
      *             Pattern fix after TCA091. (Child: AR878736)       *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  MD020736 - LE Principal Increase settlement is missing upon  *
      *             Confirm Complete action is done                   *
      *  AR1070223 - Principal increase settlement details are not    *
      *              defaulted. Default details from SAV_PAY/SAV_REC  *
      *              if S_PAY/S_REC contain blanks. (Child: AR1070225)*
      *  AR1095624 - Invalid Settlement Branch entered and Our nostro *
      *              (payment) is not a live account number           *
      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
      *              in POC                                           *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - Some codes of AR852654 will be physically deleted  *
      *          - CCR016: Settlement Allocation                      *
      *  AR852654 - Display CN fields even with business error        *
      *             encountered related to the input field.           *
      *  CSF011 - Customer Name on Inputs                             *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  243270 - Prevent accidental input of both pay and receive    *
      *           settlement instructions when only one or the        *
      *           other is valid.                                     *
      *  BUG22169 - Protect all fields in settlement instructions     *
      *             when authorising                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247172 - Corrected position of EXTDATA in the buffer. It     *
      *           should be at the end of the buffer.                 *
      *  243619A - Reverse 243619. (Recompile)                        *
      *  243619 - Principal increase gave an exception error          *
      *           (Recompile)                                         *
      *  240917 - Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *           Patterned from fix 240408.                          *
      *  BUG11406 - Need to blank return code field @RTCD after       *
      *             test for CAP086. (similar to 9492)                *
      *  BUG8758- Need to set up value for FACO field                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                 d*
      *  BUG9550 - Enusre that all changes made by CLE031 are enclosed*
      *            by CLE031 = 'Y'.                                   *
      *  BUG9493 - Corrected position of ExtData data structure on    *
      *            buffer.                                            *
      *  BUG9492- Properly initialise @RTCD after checking of         *
      *           switchable features.                                *
      *  BUG8294- Wrong branch was defaulted on the payment setlement *
      *           instruction                                         *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086  - Introduce Auto Authorisation to the API's          *
      *            without it                                         *
      *  BUG4486 - 'PI' transactions are posted to suspense a/c rather*
      *            than to the settlement a/c.                        *
      *  BUG2480 - Send the reservation id to the back end            *
      *  BUG1373_R-Have to enter Settlement Receipts for PI (REOPENED)*
      *  BUG1373- Have to enter Settlement Receipts for PI            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA091 - Wrong settlement account for method '05'.           *
      *  TDA066 - Wrong settlement method and account when enquired.  *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Buffer rebuilt incorrectly                          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  222373 - Parameter Mismatch                                  *
      *  CDE005 - Reservation ID                                      *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *                                                                                       240917
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       240917
     F                                     PREFIX(LO_)                                        240917
     F                                     IGNORE(CLOANHHF)                                   240917
     F                                     IGNORE(CLOANZ1F)                                   240917

      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **----------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming Transaction
     D TranInLOAM    E DS                  EXTNAME(LELOAMPD)
                                                                                              CLE106
      * Incoming Transaction 2                                                                CLE106
     D TranInLOA2    E DS                  EXTNAME(LELOA2PD)                                  CLE106
      ****************************
      * Separate eg settlement instructions to grouped DS (See mmldnivu for example)
      ****************************

                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * File receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029

      * File payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029

      * File FRA/IRS instructions (needed as a parameter for call
      * to ZASETINVAL etc)
     D F_FRI         E DS                  EXTNAME(SDESFFPD)

      * Pay Settlement Instructions - Input
     D S_Pay         E DS                  EXTNAME(SDESSPPD)

      * Receive Settlement Instructions - Input
     D S_Rec         E DS                  EXTNAME(SDESSRPD)

      *  Screen FRA/IRS instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
                                                                                BUG1373_R
     D Sav_Pay       E DS                  EXTNAME(SDESSPPD)                    BUG1373_R
     D                                     PREFIX(S_)                           BUG1373_R
                                                                                BUG1373_R
     D Sav_Rec       E DS                  EXTNAME(SDESSRPD)                    BUG1373_R
     D                                     PREFIX(S_)                           BUG1373_R
      *                                                                                       CLE031
      ** Flags to indicate whether Pay Settlement instruction fields                          CLE031
      ** are valid                                                                            CLE031
      *                                                                                       CLE031
     D OKPayInsDS      DS                                                                     CLE031
     D  DDPscyOK                      1A   INZ('Y')                                           CLE031
     D  DDPstmOK                      1A   INZ('Y')                                           CLE031
     D  DDPonxOK                      1A   INZ('Y')                                           CLE031
     D  DDRvnoOK                      1A   INZ('Y')                                           CLE031
     D  DDCvmrOK                      1A   INZ('Y')                                           CLE031
     D  DDPocnOK                      1A   INZ('Y')                                           CLE031
     D  DDPobnOK                      1A   INZ('Y')                                           CLE031
     D  DDRcrnOK                      1A   INZ('Y')                                           CLE031
     D  DDRcraOK                      1A   INZ('Y')                                           CLE031
     D  DDPibnOK                      1A   INZ('Y')                                           CLE031
     D  DDPibaOK                      1A   INZ('Y')                                           CLE031
     D  DDAwbnOK                      1A   INZ('Y')                                           CLE031
     D  DDAwbaOK                      1A   INZ('Y')                                           CLE031
     D  DDBennOK                      1A   INZ('Y')                                           CLE031
     D  DDBenaOK                      1A   INZ('Y')                                           CLE031
     D  DDDtp1OK                      1A   INZ('Y')                                           CLE031
     D  DDDtp2OK                      1A   INZ('Y')                                           CLE031
     D  DDDtp3OK                      1A   INZ('Y')                                           CLE031
     D  DDDtp4OK                      1A   INZ('Y')                                           CLE031
     D  DDDchgOK                      1A   INZ('Y')                                           CLE031
     D  DDIc72OK                      1A   INZ('Y')                                           CLE031
     D  DDBtb1OK                      1A   INZ('Y')                                           CLE031
     D  DDBtb2OK                      1A   INZ('Y')                                           CLE031
     D  DDBtb3OK                      1A   INZ('Y')                                           CLE031
     D  DDBtb4OK                      1A   INZ('Y')                                           CLE031
     D  DDBtb5OK                      1A   INZ('Y')                                           CLE031
     D  DDBtb6OK                      1A   INZ('Y')                                           CLE031
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
      *                                                                                       CLE031
      ** Flags to indicate whether Receive Settlement instruction fields                      CLE031
      **  are valid                                                                           CLE031
      *                                                                                       CLE031
     D OKRecInsDS      DS                                                                     CLE031
     D  DDRscyOK                      1A   INZ('Y')                                           CLE031
     D  DDRstmOK                      1A   INZ('Y')                                           CLE031
     D  DDRonxOK                      1A   INZ('Y')                                           CLE031
     D  DDRocnOK                      1A   INZ('Y')                                           CLE031
     D  DDRobnOK                      1A   INZ('Y')                                           CLE031
     D  DDRibnOK                      1A   INZ('Y')                                           CLE031
     D  DDRibaOK                      1A   INZ('Y')                                           CLE031
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
      *                                                                                       CLE031
      ** Flags to indicate whether FRA/IRS instruction fields are valid                       CLE031
      *                                                                                       CLE031
     D OKFRAInsDS      DS                                                                     CLE031
     D  DDDsr1OK                      1A   INZ('Y')                                           CLE031
     D  DDDsr2OK                      1A   INZ('Y')                                           CLE031
     D  DDDsr3OK                      1A   INZ('Y')                                           CLE031
     D  DDDsr4OK                      1A   INZ('Y')                                           CLE031
     D  DDDsr5OK                      1A   INZ('Y')                                           CLE031
     D  DDDsr6OK                      1A   INZ('Y')                                           CLE031
     D  DDSsr1OK                      1A   INZ('Y')                                           CLE031
     D  DDSsr2OK                      1A   INZ('Y')                                           CLE031
     D  DDSsr3OK                      1A   INZ('Y')                                           CLE031
     D  DDSsr4OK                      1A   INZ('Y')                                           CLE031
     D  DDSsr5OK                      1A   INZ('Y')                                           CLE031
     D  DDSsr6OK                      1A   INZ('Y')                                           CLE031
     D  DDCnd1OK                      1A   INZ('Y')                                           CLE031
     D  DDCnd2OK                      1A   INZ('Y')                                           CLE031
     D  DDCnd3OK                      1A   INZ('Y')                                           CLE031
     D  DDCnd4OK                      1A   INZ('Y')                                           CLE031
     D  DDCnd5OK                      1A   INZ('Y')                                           CLE031
     D  DDCnd6OK                      1A   INZ('Y')                                           CLE031
     D  DDIsdaOK                      1A   INZ('Y')                                           CLE031
     D  DDAgtyOK                      1A   INZ('Y')                                           CLE031
     D  DDAgdtOK                      1A   INZ('Y')                                           CLE031
     D  DDAgvvOK                      1A   INZ('Y')                                           CLE031
                                                                                              CLE031
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A

      * Valid Loan amendment details layout
     D ValidLOAM     E DS                  EXTNAME(LEVLOAMPD)
     D                                     PREFIX(V_)
     D***VREC***              321    389                                                      CGL029
     D***VPAY***              390    948                                                      CGL029
     D  VREC                 335    389                                                       CGL029
     D  VPAY                 404    948                                                       CGL029
     D**VRECEx*             1194   1211                                                CGL029 TDA066
     D  VRECEx              1195   1212                                                       TDA066
     D**VPAYEx*             1212   1229                                                CGL029 TDA066
     D  VPAYEx              1213   1230                                                       TDA066

      * Current Amendment record in file format
     D CurFilLoam    E DS                  EXTNAME(LEVLOAMPD)
     D  LAREC                335    389                                                       TDA066
     D  LAPAY                404    948                                                       TDA066
     D  LARECEx             1195   1212                                                       TDA066
     D  LAPAYEx             1213   1230                                                       TDA066

      * Current Amendment in Screen Format
     D LoamScnFmt    E DS                  EXTNAME(LELOAMPD)
     D                                     PREFIX(@)
      *
      ***  Loan Details 'A' Format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
     D***CLREC**              459    527                                                      CGL029
     D***CLPAY**              528   1086                                                      CGL029
     D  CLREC                473    527                                                       CGL029
     D  CLPAY                542   1086                                                       CGL029
     D  CLRECEx             1597   1614                                                       CGL029
     D  CLPAYEx             1615   1632                                                       CGL029
      *
      ***  Loan Details 'B' Format
     D LoanDetsB     E DS                  EXTNAME(CLOAN:CLOANCKF)
     D                                     PREFIX(LO_)
     D LB_RECI       E                     EXTFLD(RECI)
     D LB_LNRF       E                     EXTFLD(LNRF)
     D LB_RCDT       E                     EXTFLD(RCDT)
     D LB_MRIN       E                     EXTFLD(MRIN)
     D LB_ORED       E                     EXTFLD(ORED)
     D LB_LCD        E                     EXTFLD(LCD)
     D LB_CHTP       E                     EXTFLD(CHTP)
     D LB_TNLU       E                     EXTFLD(TNLU)
     D LB_FRNT       E                     EXTFLD(FRNT)
     D LB_AFRT       E                     EXTFLD(AFRT)
     D LB_REPA       E                     EXTFLD(REPA)
     D LB_TMST       E                     EXTFLD(TMST)
      *
      ***  Facility Details 'A' Format
     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
     D                                     PREFIX(FA_)
      *
      ***  Facility Details 'B' Format
     D FacilityB     E DS                  EXTNAME(FCLTY:FCLTYFNF)
     D                                     PREFIX(FA_)
     D FB_RECI       E                     EXTFLD(RECI)
     D FB_CNUM       E                     EXTFLD(CNUM)
     D FB_FACT       E                     EXTFLD(FACT)
     D FB_FCNO       E                     EXTFLD(FCNO)
     D FB_RCTP       E                     EXTFLD(RCTP)
     D FB_ORED       E                     EXTFLD(ORED)
     D FB_LCD        E                     EXTFLD(LCD)
     D FB_CHTP       E                     EXTFLD(CHTP)
     D FB_TNLU       E                     EXTFLD(TNLU)
     D FB_FRNT       E                     EXTFLD(FRNT)
     D FB_AFRT       E                     EXTFLD(AFRT)
     D FB_REPA       E                     EXTFLD(REPA)
     D FB_STMP       E                     EXTFLD(STMP)

      * Error indicators
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)

      ** Customer lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ***  Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D SCA_LCD       E                     EXTFLD(LCD)

      ** PCA ICD Details
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)

     D ExtData       E DS                  EXTNAME(LELOEXPD)
      * LE Function xxxxxxxxxxxxxxxx Extra Data - File (D/B) format
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

      * 24X7 Data Area Structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      * SDSTAT Data Area Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      ** Work variables                          r                                            240917
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240917

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      * Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A

      ** Fields (500A) to receive the incoming transaction                                    CLE106
     D Trans5002       S            500A                                                      CLE106
                                                                                              CLE106
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D Object          S             10A   INZ('LELOAMUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepLOAM         S              1A   INZ('N')
                                                                                              CSC022
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
     D CAP086          S              1A                                                      CAP086
      ** Work variables for switchable feature                                                CLE106
     D CLE106          S              1A                                                      CLE106
     D CLE134          S              1A                                                   AR1021983
     D W#FRNT          S              8A                                                   AR1021983
                                                                                              CLE106
     D CLE034          S              1A                                                      CLE034
     D ZAMSID          S              7A                                                      CLE106
     D ZAMSGF          S             10A                                                      CLE106
     D ZAMSDA          S            132A                                                      CLE106
     D ZAMSTX          S            132A                                                      CLE106
     D COBMode         S              1A                                                   AR1095624
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+


      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInLOAM
     C                   MOVEL     Trans5002     TranInLOA2                                   CLE106
     C                   EVAL      InfData = InfData500                                       CAP086
     C                   MOVEL     Extdata500    Extdata


      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      *  Validate Action Code

     C                   EXSR      ValidateAc
      *

      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      *                                                                                       243270
      *  For principal increase, determine if loan is participation sold.                     243270
      *                                                                                       243270
     C     DDATYP        IFEQ      'PI'                                                       243270
     C                   MOVE      '    '        PTYPE                                        243270
     C     LO_PTYP       IFEQ      66                                                         243270
     C     LO_PTYP       OREQ      67                                                         243270
     C     LO_PTYP       OREQ      69                                                         243270
     C     LO_PTYP       OREQ      72                                                         243270
     C                   MOVE      'PTSO'        PTYPE                                        243270
     C                   ENDIF                                                                243270
     C                   ENDIF                                                                243270
      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN         DDACTN = 'I' OR DDACTN = 'X'
     C                                OR DDACTN = 'Q' OR DDACTN = 'R'
      *                                                                                     BUG22169
      ** Protect all fields in settlement instructions when authorising                     BUG22169
      *                                                                                     BUG22169
     C                   IF        DDACTN = 'X'                                             BUG22169
     C                   MOVEL     'Y'           ##PPAY                                     BUG22169
     C                   MOVEL     'Y'           ##PREC                                     BUG22169
      *                                                                                     MD041649
      ** Principal increases for loans and parts purchased need                             MD041649
      ** pay settlements, parts sold need receive settlements                               MD041649
      *                                                                                     MD041649
     C     DDATYP        IFEQ      'PI'                                                     MD041649
     C     LO_PTYP       IFEQ      66                                                       MD041649
     C     LO_PTYP       OREQ      67                                                       MD041649
     C     LO_PTYP       OREQ      69                                                       MD041649
     C     LO_PTYP       OREQ      72                                                       MD041649
     C                   MOVE      'N'           ##PREC                                     MD041649
     C                   ELSE                                                               MD041649
     C                   MOVE      'N'           ##PPAY                                     MD041649
     C                   ENDIF                                                              MD041649
     C                   ENDIF                                                              MD041649
      *                                                                                     MD041649
     C                   ENDIF                                                              BUG22169
      *  Processing for Inserts
     C                   IF        DDACTN = 'I' AND DDATYP = 'PI'
     C                   EXSR      DftSettmts
     C                   ENDIF

     C                   EXSR      SrFmtPTPF                                                  CLE106
     C                   EXSR      ValidateTr
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
                                                                                              CDE005
     C     UpdateYN      IFEQ      'Y'                                                        CDE005
     C     DDATYP        ANDEQ     'PI'                                                       CDE005
     C     CDE005        ANDEQ     'Y'                                                        CDE005
     C                   EXSR      ValidateRs                                                 CDE005

     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

     C                   ENDIF                                                                CDE005

     C                   IF        DDATYP = 'PI'
     C                   EXSR      ValidateSt
     C                   ENDIF

     C                   WHEN         DDACTN = 'A'
      *  Processing for Amends or Changes
     C                   EXSR      SetupAmd
     C                   EXSR      SrFmtPTPF                                                  CLE106
     C                   EXSR      ValidateTr
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

     C                   IF        DDATYP = 'PI'
     C                   EXSR      ValidateSt
     C                   ENDIF

     C                   ENDSL
      *
     C     INVALID       TAG

      ** Populate Customer Name Inputs                                                        CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

      * Remerge buffer with all relevant data structures
     C*******************EVAL                    Buffer = TranInLOAM + S_Rec                  CGP001
     C*******************                        + S_Pay + ReservID + DDSTAT                  CGP001
     C*******************                        + ExtData                                    CGP001
     C
     C*******************EVAL                    Buffer = TranInLOAM + ReservID        CGP001BUG2480
     C*******************                        + DDSTAT + S_Rec + S_Pay              CGP001BUG2480
     C*******************                        + ExtData                             CGP001BUG2480
     C                   EVAL                    Buffer = TranInLOAM            BUG2480
     C                                           + TranInLOA2                                 CLE106
     C**********                                 + DDSTAT + S_Rec + S_Pay             BUG2480 CLE106
     C***********                                + ExtData                      BUG2480       CAP086
     C**********                                 + InfData + ExtData                  CAP086 BUG9493
     C**********                                 + ExtData                            BUG9493 247172
     C                                           + S_Rec + S_Pay                              CLE106
     C                                           + InfData                                   BUG9493
     C                                           + ExtData                                    247172

     C                   RETURN

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the LE database is retrieved
      * as well.

     C                   RESET                   ReturnCode

      * Obviously ensure that parameter list matches requirements of RTV module

     C                   CALLB     'LELOAMRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
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
      * Loan Number / Value Date / Sequence
     C                   PARM                    DDLOAN
     C                   PARM                    DDVDAT
     C                   PARM                    DDSEQN
     C                   PARM                    DDATYP            2

      * Where called from
     C                   PARM                    CallModCod        3
      *
      * Features
     C                   PARM                    CEU020
     C                   PARM                    CLE030                                       CLE030

      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN

      * Outputs
      * Current Loan Amendment in file format, plus Loan/facility details
     C                   PARM                    CurFilLoam
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
      *
      * Error Indicators
     C                   PARM                    LOAM_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    CurFilLoam                                   CRE073
     C                   PARM                    CobMode                                   MD021423E

     C                   EVAL      ValidLoam = CurFilLoam
      *                                                                                       240917
      *Get the default Customer code using the System Value                                   240917
     C                   IF        DDVDAT = *BLANK and DDACTN='I'                             240917
     C                   MOVE      DDLOAN        V_LALNRF                                     240917
     C     V_LALNRF      CHAIN     CLOAN                              01                      240917
     C     LO_PTYP       IFEQ      64                                                         240917
     C     LO_PTYP       OREQ      65                                                         240917
     C     LO_PTYP       OREQ      68                                                         240917
     C     LO_PTYP       OREQ      71                                                         240917
      *If the loan is a Participation Purchased, & System Value                               240917
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240917
     C     PPCUST        IFEQ      'O'                                                        240917
     C                   MOVEL     LO_OLNO       DDCNUM                                       240917
      * Else, use 'Purchased from' customer number.                                           240917
     C                   ELSE                                                                 240917
     C                   MOVEL     LO_CNUM       DDCNUM                                       240917
     C                   ENDIF                                                                240917
      * Else, loan is not a Part Purchased:                                                   240917
     C                   ELSE                                                                 240917
     C                   MOVEL     LO_CNUM       DDCNUM                                       240917
     C                   ENDIF                                                                240917
     C                   ENDIF                                                                240917

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************

     C     DftSettmts    BEGSR
     C**********         MOVEL     APFOTRANID    W#FRNT                          AR1095624 MD021423E
     C**********         IF        (CLE134 = 'Y') AND                            AR1095624 MD021423E
     C**********                   (APSRCSYS = 'MIDASCOB') AND                   AR1095624 MD021423E
     C**********                   (W#FRNT = 'LE000473')                         AR1095624 MD021423E
     C**********         EVAL      COBMode  = 'Y'                                AR1095624 MD021423E
     C**********         ENDIF                                                   AR1095624 MD021423E

      * Apply default settlement instructions if none supplied
     C*******************IF        (S_REC = *blank) and                         BUG1373_R
     C*******************          (S_PAY = *blank)                             BUG1373_R
     C                   EVAL      SAV_PAY = S_PAY                              BUG1373_R
     C                   EVAL      SAV_REC = S_REC                              BUG1373_R
      *                                                                         BUG1373
      **  Protect all fields in settlement instructions                         BUG1373
     C                   MOVEL     'Y'           ##PPAY                         BUG1373
     C                   MOVEL     'Y'           ##PREC                         BUG1373

      **Move*the*customer number*to parameter*field**************************** BUG1373
     C****************** MOVEL     LO_CNUM       ##CSNM                         BUG1373
      *
      ** Principal increases for loans and parts purchased need
      ** pay settlements, parts sold need receive settlements
     C                   MOVE      *BLANKS       PTYPE             4
     C     LO_PTYP       IFEQ      66
     C     LO_PTYP       OREQ      67
     C     LO_PTYP       OREQ      69
     C     LO_PTYP       OREQ      72
     C                   MOVE      'PTSO'        PTYPE
     C                   ENDIF
                                                                                BUG1373
     C                   IF        PTYPE = 'PTSO'                               BUG1373
     C                   MOVE      'N'           ##PREC                         BUG1373
     C                   ELSE                                                   BUG1373
     C                   MOVE      'N'           ##PPAY                         BUG1373
     C                   ENDIF                                                  BUG1373
      *                                                                                     MD029046
      ** Default settlement from standard settlement instructions of customer first         MD029046
      ** before trying to default from loan. Placed another call for ZASETINDFT             MD029046
      ** for Principal increase insert.                                                     MD029046
      *                                                                                     MD029046
     C                   IF        DDACTN = 'I'                                             MD029046
     C                             AND DDATYP = 'PI'                                        MD029046
     C                   MOVEL     LO_CNUM       ##CSNM                                     MD029046
     C                   CALLB     'ZASETINDFT'                                             MD029046
      *                                                                                     MD029046
      ** Inputs                                                                             MD029046
      ** Calling program                                                                    MD029046
     C                   PARM      'LEND'        ##CALP                                     MD029046
      *                                                                                     MD029046
      ** Payment currency                                                                   MD029046
     C                   PARM      LO_CCY        ##PCCY                                     MD029046
      *                                                                                     MD029046
      ** Receive currency                                                                   MD029046
     C                   PARM      LO_CCY        ##RCCY                                     MD029046
      *                                                                                     MD029046
      ** Customer shortname                                                                 MD029046
     C                   PARM                    ##CSNM                                     MD029046
      *                                                                                     MD029046
      ** Loan type                                                                          MD029046
     C                   PARM      *BLANKS       ##TTYP                                     MD029046
      *                                                                                     MD029046
      ** Parameters not used in LOAM :                                                      MD029046
      ** Federal funds indicator                                                            MD029046
      ** Version of ISDA rules                                                              MD029046
      ** Type of ISDA agreement                                                             MD029046
      ** Date of ISDA agreement                                                             MD029046
      ** Version of ISDA agreement                                                          MD029046
      ** Version of ISDA agreement century                                                  MD029046
     C                   PARM      *BLANK        ##FFND                                     MD029046
     C                   PARM      *BLANK        BQISDA                                     MD029046
     C                   PARM      *BLANK        BQAGTY                                     MD029046
     C                   PARM      *BLANK        BQAGDT                                     MD029046
     C                   PARM      *BLANK        BQAGVV                                     MD029046
     C                   PARM      *BLANK        Blank2                                     MD029046
                                                                                            MD029046
      ** Deal Subtype                                                                       MD029046
     C                   PARM      *BLANK        BlankSTYP                                  MD029046
                                                                                            MD029046
      ** Branch                                                                             MD029046
     C                   PARM      *BLANK        BlankBRCA                                  MD029046
      *                                                                                     MD029046
      ***  OUTPUTS                                                                          MD029046
      ***  Payment instructions                                                             MD029046
     C                   PARM                    F_PAY                                      MD029046
      *                                                                                     MD029046
      ***  Receive instructions                                                             MD029046
     C                   PARM                    F_REC                                      MD029046
      *                                                                                     MD029046
      ***  FRA/IRS instructions                                                             MD029046
     C                   PARM                    F_FRI                                      MD029046
     C                   ENDIF                                                              MD029046
      *
      ** Set up payment instructions from loan
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   IF        (DDACTN = 'I')                                             TDA066
     C     PType         IFNE      'PTSO'                                                     TDA066
     C     FLPSTM        ANDEQ     *ZERO                                                    MD029046
     C     ##PPAY        ANDNE     'Y'                                                      MD029046
     C                   CLEAR                   FLREC                          BUG1373
     C                   Z-ADD     0             FLRSTM                         BUG1373
     C                   MOVE      *BLANKS       FLRONS                         BUG1373
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     LO_PSTM       FLPSTM                                       CGL029
     C                   MOVEL     LO_CVMR       FLCVMR
     C                   MOVEL     LO_SCCY       FLPSCY
     C                   MOVEL     LO_ICCY       FLIC72
     C***********        MOVE      LO_OMDB       FLPOBR                               TDA066 BTDA066
     C                   MOVE      LO_OSDB       FLPOBR                                      BUG8294
      *                                                                                       CLE031
      ** If CLE031 is switched on, move correct settlement currency.                          CLE031
      ** Note do not default exchange rate from CLOANCL.                                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     LO_PSCY       FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                TDA066
      *
      ** If part sold, receive branch is our start date branch
     C     PType         IFEQ      'PTSO'
     C     FLRSTM        ANDEQ     *ZERO                                                    MD029046
     C     ##PREC        ANDNE     'Y'                                                      MD029046
     C                   CLEAR                   FLPAY                          BUG1373
     C                   Z-ADD     0             FLPSTM                         BUG1373
     C                   MOVE      *BLANKS       FLPONS                         BUG1373
     C                   MOVE      LO_OSDB       FLROBR
      *
      ** Set up receive instructions from loan
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     LO_RSTM       FLRSTM                                       CGL029
     C                   MOVEL     LO_SCCY       FLRSCY
     C**********         MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move correct settlement currency.                          CLE031
      ** Note do not default exchange rate from CLOANCL.                                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     LO_SCCY       FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   Z-ADD     0             FLREXR                                       CLE031
     C                   Z-ADD     0             FLPEXR                                       CLE031
      *                                                                                    AR1095624
      ** If CLE134 is switched ON, override Pay instructions from                          AR1095624
      ** details of receipt instructions                                                   AR1095624
     C                   IF        (CLE134 = 'Y'  AND COBMode = 'Y')                       AR1095624
     C                   EXSR      PDPOverride                                             AR1095624
     C                   ENDIF                                                             AR1095624
      *                                                                                       TDA066
      ** On action other than insert, setup setllement instructions                           TDA066
      ** from current loan amendment.                                                         TDA066
     C                   ELSE                                                                 TDA066
     C                   IF        (PType <> 'PTSO')                                          TDA066
     C                   MOVEL     LAPAY         FLPAY                                        TDA066
     C                   MOVEL     LAPAYEx       FLPONS                                       TDA066
     C                   MOVEL     LAPSTM        FLPSTM                                       TDA066
     C                   MOVEL     LACVMR        FLCVMR                                       TDA066
     C                   MOVEL     LAPSCY        FLPSCY                                       TDA066
     C                   MOVEL     LAICCY        FLIC72                                       TDA066
     C                   MOVE      LAOSBR        FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LAPEXR        FLPEXR                                       CLE031
     C                   MOVE      LAPEXI        FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 TDA066
     C                   MOVEL     LAREC         FLREC                                        TDA066
     C                   MOVEL     LARECEx       FLRONS                                       TDA066
     C                   MOVE      LAOSBR        FLROBR                                       TDA066
     C                   MOVEL     LARSTM        FLRSTM                                       TDA066
     C                   MOVEL     LASCCY        FLRSCY                                       TDA066
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                       BUG9550
     C                   Z-ADD     LAREXR        FLREXR                                       CLE031
     C                   MOVE      LAREXI        FLREXI                                       CLE031
     C                   ENDIF                                                               BUG9550
      *                                                                                       CLE031
     C                   ENDIF                                                                TDA066
     C                   ENDIF                                                                TDA066
      *
      ***  If settlement instructions are not defined,                          BUG1373
      ***  and payment/receipt dates aren't in the past, default them           BUG1373
     C     FLPSTM        IFEQ      *ZERO                                        BUG1373
     C     ##PPAY        ANDNE     'Y'                                          BUG1373
     C     FLRSTM        OREQ      *ZERO                                        BUG1373
     C     ##PREC        ANDNE     'Y'                                          BUG1373
     C                   MOVEL     LO_CNUM       ##CSNM                         BUG1373
     C                   CALLB     'ZASETINDFT'
      *
      ** Inputs
      ** Calling program
     C***************    PARM      'LOAM'        ##CALP            4            BUG1373
     C                   PARM      'LEND'        ##CALP            4            BUG1373
      *
      ** Payment currency
     C                   PARM      LO_CCY        ##PCCY            3
      *
      ** Receive currency
     C                   PARM      LO_CCY        ##RCCY            3
      *
      ** Customer shortname
     C                   PARM                    ##CSNM           10
      *
      ** Loan type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ** Parameters not used in LOAM :
      ** Federal funds indicator
      ** Version of ISDA rules
      ** Type of ISDA agreement
      ** Date of ISDA agreement
      ** Version of ISDA agreement
      ** Version of ISDA agreement century
     C                   PARM      *BLANK        ##FFND            1
     C                   PARM      *BLANK        BQISDA            4
     C                   PARM      *BLANK        BQAGTY            6
     C                   PARM      *BLANK        BQAGDT            6
     C                   PARM      *BLANK        BQAGVV            2
     C                   PARM      *BLANK        Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      ***  Payment instructions
     C                   PARM                    F_PAY
      *
      ***  Receive instructions
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
     C                   PARM                    F_FRI
     C                   ENDIF                                                  BUG1373
      *
      *
      ***  Convert settlement details from file to screen format
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      ***  File payment settlement instructions
     C                   PARM                    F_PAY
      *
      ***  File receipt settlement instructions
     C                   PARM                    F_REC
      *
      ***  File FRA/IRS settlement instructions
     C                   PARM      *BLANK        F_FRI
      *
      ***  Outputs
      ***  Screen payment settlement instructions
     C                   PARM      *BLANK        S_PAY
      *
      ***  Screen Receipt settlement instructions
     C                   PARM      *BLANK        S_REC
      *
      ***  Screen FRA/IRS settlement instructions
     C                   PARM      *BLANK        S_FRI
     C                   PARM      LO_CCY        #TRCCY                                      CSF011A
     C                   PARM      LO_CCY        #TPCCY                                      CSF011A

     C                   IF        SAV_PAY <> *BLANKS                           BUG1373_R
     C                             AND S_DDPSTM <> '00'                                     MD020736
     C**********                   and S_PAY = *BLANKS                            AR1070223 MD020736
     C                   EVAL      S_PAY = SAV_PAY                              BUG1373_R
     C                   ENDIF                                                  BUG1373_R
                                                                                BUG1373_R
     C                   IF        SAV_REC <> *BLANKS                           BUG1373_R
     C                             AND S_DDRSTM <> '00'                                     MD020736
     C**********                   and S_REC = *BLANKS                            AR1070223 MD020736
     C                   EVAL      S_REC = SAV_REC                              BUG1373_R
     C                   ENDIF                                                  BUG1373_R
     C*******************ENDIF                                                  BUG1373_R

     C     EDFTSETT      ENDSR
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateSt - Routine to validate settlement details            *
      *                                                                *
      ******************************************************************
     C     ValidateSt    BEGSR

      * Move the customer number to parameter field
     C                   MOVEL     LO_CNUM       ##CSNM
      *
      ** Set up date of receipt/payment
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ErrorFlag         1
     C                   Z-ADD     ZDAYNO        ##DATR            5 0
     C                   Z-ADD     ZDAYNO        ##DATP            5 0
     C                   IF        PTYPE = 'PTSO'                                             243270
     C                   CLEAR                   S_PAY                                        243270
     C                   MOVE      '00'          DDPSTM                                       243270
     C                   ELSE                                                                 243270
     C                   CLEAR                   S_REC                                        243270
     C                   MOVE      '00'          DDRSTM                                       243270
     C                   ENDIF                                                                243270

      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      S_Pay = *Blanks                                            CLE034
     C                   EVAL      S_Rec = *Blanks                                            CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return code
     C                   PARM                    ReturnCode

      ** Output:
      ** Calling function type
     C****************** PARM      'LOAM'        ##CALP                         BUG1373
     C                   PARM      'LEND'        ##CALP            4            BUG1373

      ** Payment currency
     C                   PARM      LO_CCY        ##PCCY            3

      ** Receive currency
     C                   PARM      LO_CCY        ##RCCY            3

      ** Customer (shortname or number)
     C                   PARM                    ##CSNM

      ** Deal type
     C                   PARM                    ##TTYP

      ** Federal funds indicator
     C                   PARM                    ##FFND

      ** Booking branch
     C                   PARM      LO_BRCA       ##BRCA            3

      ** Receipt date
     C                   PARM                    ##DATR            5 0

      ** Payment date
     C                   PARM                    ##DATP            5 0

      ** Receipt / payment / FRA settlement instructions in screen
      ** format
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI

      * Action code
     C                   PARM                    DDACTN
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373

      ** Inputs:
      ** Payment instruction OK flag
     C**********         PARM                    OKPayInsDS        1                          CLE031
     C                   PARM                    OKPayInsDS                                   CLE031

      ** Receive instruction OK flag
     C**********         PARM                    OKRecInsDS        1                          CLE031
     C                   PARM                    OKRecInsDS                                   CLE031

      ** FRA/IRS Instruction OK flag
     C**********         PARM                    OKFRAInsDS        1                          CLE031
     C                   PARM                    OKFRAInsDS                                   CLE031

      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373

      ** Receipt / payment / FRA settlement instructions in file
      ** format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI

      ** Action code used
     C                   PARM      DDACTN        ##ACTN            1

      ** Validation iteration
     C                   PARM      '1ST'         ##ValIter         3

     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      S_Pay = *Blanks                                            CLE034
     C                   EVAL      S_Rec = *Blanks                                            CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   IF        DDACTN <> 'X'                                            MD051890
     C                   EVAL      VREC = FLREC
     C                   EVAL      VRECEx = FLRONS                                            CGL029
     C                   EVAL      V_LARSTM = FLRSTM                                          CGL029
     C                   EVAL      VPAY = FLPAY
     C                   EVAL      VPAYEx = FLPONS                                            CGL029
     C                   EVAL      V_LAPSTM = FLPSTM                                          CGL029
     C                   MOVEL     FLBENN        V_LAFACO                                    BUG8758
     C                   MOVEL     FLCVMR        V_LACVMR                                    CSF011A
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                       BUG9550
     C                   Z-ADD     FLREXR        V_LAREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_LAPEXR                                     CLE031
     C                   MOVE      FLREXI        V_LAREXI                                     CLE031
     C                   MOVE      FLPEXI        V_LAPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_LASCCY                                     CLE031
     C                   MOVE      FLPSCY        V_LAPSCY                                     CLE031
     C                   ENDIF                                                               BUG9550
      *                                                                                       TCA091
     C                   IF        (PType <> 'PTSO')                                          TCA091
     C                   EVAL      V_LAOSBR = FLPOBR                                          TCA091
     C                   EVAL      V_LACVMR = FLCVMR                                        AR878735
      *                                                                                      BUG4486
      ** Populate SETP and OSAC fields in order for the system to post the 'PI' to the       BUG4486
      ** correct a/c during COB.                                                             BUG4486
      *                                                                                      BUG4486
     C                   EVAL      V_LASETP= FLPSTM                                          BUG4486
     C                   EVAL      V_LAOSAC= FLPONS                                          BUG4486
      *                                                                                      BUG4486
     C                   ELSE                                                                 TCA091
     C                   EVAL      V_LAOSBR = FLROBR                                          TCA091
     C                   EVAL      V_LACVMR = FLCVMR                                        AR878735
      *                                                                                      BUG4486
     C                   EVAL      V_LASETP= FLRSTM                                          BUG4486
     C                   EVAL      V_LAOSAC= FLRONS                                          BUG4486
     C                   ENDIF                                                              MD051890
      *                                                                                      BUG4486
     C                   ENDIF                                                                TCA091
      *                                                                                       TCA091
      ** Call account referred validation.                                                  MD039547
      *                                                                                     MD039547
     C                   CALL      'ZASETINVL2'                                             MD039547
     C                   PARM                    ReturnCode                                 MD039547
     C                   PARM      'LEND'        ##CALP                                     MD039547
     C                   PARM      LO_CCY        ##PCCY                                     MD039547
     C                   PARM      LO_CCY        ##RCCY                                     MD039547
     C                   PARM                    ##CSNM                                     MD039547
     C                   PARM      LO_BRCA       ##BRCA                                     MD039547
     C                   PARM                    S_PAY                                      MD039547
     C                   PARM                    S_REC                                      MD039547
     C                   PARM                    DDACTN                                     MD039547
     C                   PARM                    ##PPAY                                     MD039547
     C                   PARM                    ##PREC                                     MD039547
     C                   PARM                    OKPayInsDS                                 MD039547
     C                   PARM                    OKRecInsDS                                 MD039547
     C                   PARM                    FldNameArr                                 MD039547
     C                   PARM                    MsgIDArr                                   MD039547
     C                   PARM                    Idx                                        MD039547
     C                   PARM                    WFldNamArr                                 MD039547
     C                   PARM                    WMsgIdArr                                  MD039547
     C                   PARM                    WMsgDtaArr                                 MD039547
     C                   PARM                    WIdx                                       MD039547
     C     ValSetExit    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments.                                             *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For Amends, convert the Amendment to screen format
     C                   CALLB     'LELOAMCVT'
      * Inputs
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Amendment - file format
     C                   PARM                    ValidLOAM
      *
      * Date format indicator
     C                   PARM                    BJDFIN
      *
      * Output parameters
      * Amendment Details - screen formats
     C                   PARM                    LoamScnFmt
      *
      ***  Output only screen field : Loan status
     C                   PARM                    DDSTAT           16
                                                                                              CRE073
     C                   PARM                    ValidLOAM                                    CRE073
      *
      **  Add the action code
     C                   MOVE      DDACTN        @DDACTN

      ** If no amendment type was entered, update screen field, else
      ** move screen field to file to be validated
     C                   If        DDATYP = *Blank
     C                   MOVE      @DDATYP       DDATYP
     C                   ELse
     C                   MOVE      DDATYP        @DDATYP
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
                                                                                              CLE106
      ** If Syndications Manager is available, use UTN from thin client as PC Ref             CLE106
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      FOTranId = DDLUTN                                          CLE106
     C                   ENDIF                                                                CLE106
                                                                                           AR1021983
     C                   MOVEL     APFOTRANID    W#FRNT                                    AR1021983
     C                   IF        (CLE134 = 'Y') AND                                      AR1021983
     C                             (APSRCSYS = 'MIDASCOB') AND                             AR1021983
     C                             (W#FRNT = 'LE000473')                                   AR1021983
     C                   EVAL      FOTranId = APFOTRANID                                   AR1021983
     C                   ENDIF                                                             AR1021983

      * Validate xxxxxxxx Transaction details

     C                   CALLB     'LELOAMVAL'

      * Inputs

      ** Transaction information (DS) from source system (screen format)
     C                   PARM                    TranInLOAM

      ** Current Loan Amendment in file format from caller
     C                   PARM                    CurFilLoam

      * File receive instructions
      * File payment instructions
     C                   PARM                    S_REC
     C                   PARM                    S_PAY

      ** Loan 'A' & 'B' formats
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB

      ** Facility 'A' & 'B' formats
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB

      ** Front Office Transaction Id., Associated Front Office Transaction Id.
      ** Repair Location
     C                   PARM                    FOTranId         20
     C                   PARM                    FOAssocId        20
     C                   PARM                    RepairLoc         1

      ** Date format indicator / local currency / run day
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    WRNDAY

      ** Analytical Accounting
     C                   PARM                    BGN0ST

      * Authorise amends / authorise principal tfr / base rate change
     C                   PARM                    BPLMAU
     C                   PARM                    BPTPAU
     C                   PARM                    BPBRCF

      * Tolerance for funding rate
     C                   PARM                    FTTFRT

      ** Field OK flags (DS) from/to caller
     C                   PARM                    LOAM_OK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Calling Module Code
     C                   PARM      'CTL'         CallModCod        3

      ** Features
     C                   PARM                    CDE002
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE014
     C                   PARM                    CLE023
     C                   PARM                    CLE030                                       CLE030
     C                   PARM                    CEU004
     C                   PARM                    CEU020

      ** Valid Loan Amendment layout (DS) from/to caller
     C                   PARM                    ValidLoam

                                                                                             CSF011A
      ** If Syndications Manager is off, override UTN with PC Ref value                      CSF011A
                                                                                             CSF011A
     C                   IF        CLE106 <> 'Y'                                             CSF011A
     C                   IF        UpdateYN = 'Y'                                            CSF011A
     C                   EVAL      V_LAPCRF = DDLUTN                                         CSF011A
     C                   ELSE                                                                CSF011A
     C                   EVAL      DDLUTN = V_LAPCRF                                         CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A

     C     EValidTr      ENDSR
      *****************************************************************                       CLE106
      /EJECT                                                                                  CLE106
      ******************************************************************                      CLE106
      *                                                                *                      CLE106
      * SrFmtPTPF - Format details for Principal Transfer To and From  *                      CLE106
      *                                                                *                      CLE106
      ******************************************************************                      CLE106
     C     SrFmtPTPF     BEGSR                                                                CLE106
                                                                                              CLE106
     C                   CALLB     'LELOAMPTF'                                                CLE106
                                                                                              CLE106
      ** Input                                                                                CLE106
     C                   PARM                    TranInLoa2                                   CLE106
                                                                                              CLE106
      ** Output                                                                               CLE106
     C                   PARM                    FldNameArr                                   CLE106
     C                   PARM                    MsgIDArr                                     CLE106
     C                   PARM                    MsgDtaArr                                    CLE106
     C                   PARM                    Idx                                          CLE106
     C                   PARM                    ValidLoam                                    CLE106
     C                                                                                        CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                     CDE005
      /EJECT                                                                                CDE005
      ******************************************************************                    CDE005
      *                                                                *                    CDE005
      * ValidateRs - Validate Reservation ID                           *                    CDE005
      *                                                                *                    CDE005
      ******************************************************************                    CDE005
     C     ValidateRs    BEGSR                                                              CDE005
                                                                                            CDE005
     C                   CALLB     'LERSVIDVL'                                              CDE005
     C                   PARM      'LE'          Module            2                        CDE005
     C                   PARM      'LAMN'        TransType         4                        CDE005
     C                   PARM                    DDACTN                                     CDE005
     C                   PARM                    ReservID                                   CDE005
     C                   PARM                    FldNameArr                                 CDE005
     C                   PARM                    MsgIdArr                                   CDE005
     C                   PARM                    MsgDtaArr                                  CDE005
     C                   PARM                    Idx                                        CDE005
                                                                                            CDE005
     C                   ENDSR                                                              CDE005
      *****************************************************************
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCNUM <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDCNUM                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF

     C                   ENDSR
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

     C                   CLEAR                   LoamScnFmt

     C                   MOVE      *ALL'Y'       Loam_OK

     C                   CLEAR                   ValidLOAM

     C                   EVAL      DDCRSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDCRNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDCRTN  = *BLANKS                                         CSF011A
                                                                                             CSF011A
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
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_LAAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      V_LASTAL = DDSTAL                                          CLE034
     C                   ENDIF                                                                CLE034

     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EXSR      SRSTAT                                                     CLE106
     C                   ENDIF                                                                CLE106
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
      * Include header fields that need to be output to the valid file.
      * As there is no front office ID, use the PCREF created by LEFAMDVAL.
     C**********         MOVEL     LAPCRF        LAFRNT                                      CSF011A
     C                   MOVEL     V_LAPCRF      LAFRNT                                      CSF011A
      *
      *
      * LOAMS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'LELOAMUPD'
     C                   PARM      *BLANKS       @RTCD

      ** Action requested
     C                   PARM                    DDACTN
     C                   PARM                    ValidLoam

      * Calling module code
     C                   PARM                    CallModCod        3

      ** Reservation ID (input from VU only)
     C                   PARM                    ReservId         10

      * Features
     C                   PARM                    CDE001
     C                   PARM                    CDE005
     C                   PARM                    CEU004
     C                   PARM                    CEU020
     C                   PARM                    CLE002
     C                   PARM                    CLE005
     C                   PARM                    CLE009
     C                   PARM                    CLE014
     C                   PARM                    CLE023
     C                   PARM                    CLE030                                       CLE030

      * Authorise amends / authorise principal tfr / consolidated conf.
     C                   PARM                    BPLMAU
     C                   PARM                    BPTPAU
     C                   PARM                    BPCONR

      ** Date format indicator, local currency & run day number
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    WRNDAY

      ** Multi-branching
     C                   PARM                    BGMBIN

      * Which system is active (24x7)
     C                   PARM                    System
     C                   END

      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
     C                   MOVEL     '0'           APIRetc
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   IF        @RTCD <> '*RECLCK'                                       AR868380
     C                   EXSR      *PSSR
     C                   ENDIF                                                              AR868380
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     @RTCD         IFEQ      '*RECUPD'
     C     @RTCD         OREQ      '*RECLCK'                                                AR868380

     C                   MOVEL     '*ANY'        FldNameArr(1)
      ** Amend this message number with correct detail
     C*********          MOVEL     'XXX0000'     MsgIdArr(1)                                  247172
     C                   MOVEL     'LEL0666'     MsgIdArr(1)                                  247172
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     'LEL0817'     MsgIdArr(1)                                AR868380
     C                   ENDIF                                                              AR868380
     C                   ELSE

      * Allocated sequence number on insert
     C                   IF        DDACTN = 'I'
     C                   MOVE      V_LALASN      DDSEQN
     C                   ENDIF

     C                   END


     C                   ENDSR
      *****************************************************************
      * SRSTAT  -  Determine loan amendment status narrative          *                       CLE106
      *****************************************************************                       CLE106
     C     SRSTAT        BEGSR                                                                CLE106
                                                                                              CLE106
     C                   MOVE      *BLANKS       ZAMSID                                       CLE106
     C                   MOVE      *BLANKS       DDASTS                                       CLE106
                                                                                              CLE106
     C                   SELECT                                                               CLE106
     C     V_LAASTS      WHENEQ    'C'                                                        CLE106
     C                   MOVEL     'LEA0060'     ZAMSID                                       CLE106
                                                                                              CLE106
     C     V_LAASTS      WHENEQ    'R'                                                        CLE106
     C                   MOVEL     'LEA0061'     ZAMSID                                       CLE106
                                                                                              CLE106
     C     V_LAASTS      WHENEQ    'A'                                                        CLE106
     C                   MOVEL     'LEA0062'     ZAMSID                                       CLE106
                                                                                              CLE106
     C     V_LAASTS      WHENEQ    'D'                                                        CLE106
     C                   MOVEL     'LEA0063'     ZAMSID                                       CLE106
                                                                                              CLE106
     C     V_LAASTS      WHENEQ    'Q'                                                        CLE106
     C                   MOVEL     'LEA0064'     ZAMSID                                       CLE106
                                                                                              CLE106
     C                   OTHER                                                                CLE106
     C                   MOVE      *BLANKS       DDSTAT                                       CLE106
     C                   ENDSL                                                                CLE106
                                                                                              CLE106
     C     ZAMSID        IFNE      *BLANKS                                                    CLE106
     C                   CALL      'Y2RVMGC'                                                  CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM                    ZAMSID            7                          CLE106
     C                   PARM      'LERMSGF '    ZAMSGF           10                          CLE106
     C                   PARM                    ZAMSDA          132                          CLE106
     C                   PARM                    ZAMSTX          132                          CLE106
     C                   EVAL      DDASTS = ZAMSTX                                            CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002                                    CLE106
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    ExtData500
     C                   PARM                    ReservID         10
     C                   PARM                    DDSTAT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'SDUSRMSG'                                  CRE073

      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LELOAMM01

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'

      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Retrieve Customer lending ICD
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDCLND        PARM                    DSFDY                                        CLE134
     C     SDCLND        PARM                    DSSDY                                        CLE134
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Midas Module details
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM                    DSFDY

     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Analytical Accounting Module is switched on, access
      ** profit centre accounting details
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDPCACPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF

      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access SAR details file to determine if MDF Switchable feature
      ** is switched on  OR SIMILAR INZSR PROCESSING
      *
      ** Determine if CDE001 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CDE001            1
     C                   ELSE
     C                   MOVEL     'Y'           CDE001
     C                   ENDIF
      *
      ** Determine if CDE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CDE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CDE002
     C                   ENDIF

      ** Determine if CDE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDE005            1
     C                   ELSE
     C                   MOVEL     'N'           CDE005
     C                   ENDIF

      ** Determine if CEU004 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU004            1
     C                   ELSE
     C                   MOVEL     'N'           CEU004
     C                   END

      ** Determine if CEU020 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU020            1
     C                   ELSE
     C                   MOVEL     'N'           CEU020
     C                   END

      ** Determine if CLE002 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE002            1
     C                   ELSE
     C                   MOVEL     'N'           CLE002
     C                   END

      ** Determine if CLE003 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE003            1
     C                   ELSE
     C                   MOVEL     'N'           CLE003
     C                   END

      ** Determine if CLE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE005            1
     C                   ELSE
     C                   MOVEL     'N'           CLE005
     C                   ENDIF

      ** Determine if CLE009 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE009            1
     C                   ELSE
     C                   MOVEL     'N'           CLE009
     C                   ENDIF

      ** Determine if CLE014 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE014            1
     C                   ELSE
     C                   MOVEL     'N'           CLE014
     C                   END

      ** Determine if CLE023 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE023            1
     C                   ELSE
     C                   MOVEL     'N'           CLE023
     C                   END
                                                                                              CLE030
      ** Determine if CLE030 is switched on                                                   CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD                                        CLE030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE030
     C                   IF        @RTCD = *BLANK                                             CLE030
     C                   MOVEL     'Y'           CLE030            1                          CLE030
     C                   ELSE                                                                 CLE030
     C                   MOVEL     'N'           CLE030                                       CLE030
     C                   END                                                                  CLE030
                                                                                              CLE106
      ** Determine if CLE106 is switched on                                                   CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106

      ** Determine if CSC011 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSC011            1
     C                   ELSE
     C                   MOVEL     'N'           CSC011
     C                   END
     C                   Eval      @RTCD = *BLANK

      * If CSC011 is installed and in switchover mode, use
      * S1DATE from DTAARA/SC24x7 as the run day number.
     C                   IN        SC24X7
     C                   IN        SDSTAT
      *
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   Z-ADD     S1DATE        WRNDAY            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM      S1DATE        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATEA        WRUNDT            7
     C                   MOVE      'S'           System            1
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   MOVE      BJMRDT        WRUNDT
     C                   MOVE      'M'           System
     C                   ENDIF
     C                   MOVEL     'LOAM'        @CALLP            4

     C                   EVAL      @RTCD = *BLANKS

      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 005                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      ** Determine if CLE034 (Lending Enhancements)                                           CLE034
                                                                                              CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
                                                                                              CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   ENDIF                                                                CLE034

     C**********         MOVE      *BLANKS       @RTCD                                CLE106 BUG9492
      *  Hook to enable non-core initial processing to be included
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LELOAMVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 6                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                             BUG9492
      ** Check if CLE134 Past Due Processing is switched on                                AR1021983
                                                                                           AR1021983
     C                   CALL      'AOSARDR0'                                              AR1021983
     C                   PARM      *BLANKS       @RTCD                                     AR1021983
     C                   PARM      '*VERIFY'     @OPTN                                     AR1021983
     C                   PARM      'CLE134'      @SARD                                     AR1021983
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1021983
                                                                                           AR1021983
     C                   EVAL      CLE134 = 'N'                                            AR1021983
                                                                                           AR1021983
     C                   IF        @RTCD = *BLANKS                                         AR1021983
     C                   EVAL      CLE134 = 'Y'                                            AR1021983
     C                   ELSE                                                              AR1021983
     C                   IF        @RTCD <> '*NRF'                                         AR1021983
     C     *LOCK         IN        LDA                                                     AR1021983
     C                   EVAL      DBPGM = 'LELOAMVU'                                      AR1021983
     C                   EVAL      DBKEY = 'CLE134'                                        AR1021983
     C                   EVAL      DBFILE ='SCSARDPD'                                      AR1021983
     C                   EVAL      DBASE  = 7                                              AR1021983
     C                   OUT       LDA                                                     AR1021983
     C                   EXSR      *PSSR                                                   AR1021983
     C                   ENDIF                                                             AR1021983
     C                   ENDIF                                                             AR1021983
                                                                                           AR1021983
     C                   MOVE      *BLANKS       @RTCD                                       BUG9492
      *                                                                                       240917
      ** Check System Value: Use Original Borrower or Purchased From?                         240917
      ** Set up parameter so access object checks LoanCustOriginPurch                         240917
     C                   MOVEL     WPARM         SVALK1                                       240917
      * Call Access object:                                                                   240917
     C                   CALL      'AOSVALR0'                                                 240917
     C                   PARM                    RTNCDE            7                          240917
     C                   PARM                    SVALK1           20                          240917
     C                   PARM                    SVAL1           200                          240917
     C                   PARM                    SVALK2           20                          240917
     C                   PARM                    SVAL2           200                          240917
     C                   PARM                    SVALK3           20                          240917
     C                   PARM                    SVAL3           200                          240917
     C                   PARM                    SVALK4           20                          240917
     C                   PARM                    SVAL4           200                          240917
     C                   PARM                    SVALK5           20                          240917
     C                   PARM                    SVAL5           200                          240917
     C                   PARM                    SVALK6           20                          240917
     C                   PARM                    SVAL6           200                          240917
     C                   PARM                    SVALK7           20                          240917
     C                   PARM                    SVAL7           200                          240917
     C                   PARM                    SVALK8           20                          240917
     C                   PARM                    SVAL8           200                          240917
     C                   PARM                    SVALK9           20                          240917
     C                   PARM                    SVAL9           200                          240917
     C                   PARM                    SVALK0           20                          240917
     C                   PARM                    SVAL10          200                          240917
      * If the system value is not found then default value to 'P'                            240917
     C     RTNCDE        IFNE      '        '                                                 240917
     C                   MOVE      'P'           PPCUST                                       240917
     C                   ELSE                                                                 240917
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              240917
     C                   MOVEL     SVAL1         WRK01             1                          240917
     C     WRK01         IFEQ      'O'                                                        240917
     C                   MOVE      'O'           PPCUST            1                          240917
     C                   ELSE                                                                 240917
     C                   MOVE      'P'           PPCUST                                       240917
     C                   ENDIF                                                                240917
     C                   ENDIF                                                                240917
      *                                                                                    MD021423E
     C                   MOVEL     APFOTRANID    W#FRNT                                    MD021423E
     C                   IF        (CLE134 = 'Y') AND                                      MD021423E
     C                             (APSRCSYS = 'MIDASCOB') AND                             MD021423E
     C                             (W#FRNT = 'LE000473')                                   MD021423E
     C                   EVAL      COBMode  = 'Y'                                          MD021423E
     C                   ENDIF                                                             MD021423E

     C                   ENDSR
      ******************************************************************                   AR1095624
      *                                                                *                   AR1095624
      * PDPOverride - Override pay instructions from receipt           *                   AR1095624
      *               instructions                                     *                   AR1095624
      *                                                                *                   AR1095624
      ******************************************************************                   AR1095624
     C     PDPOverride   BEGSR                                                             AR1095624
      *                                                                                    AR1095624
     C                   MOVEL     *BLANKS       FLPAY                                     AR1095624
     C                   MOVEL     *BLANKS       FLPONS                                    AR1095624
     C                   MOVEL     *BLANKS       FLPSTM                                    AR1095624
     C                   MOVEL     *BLANKS       FLPSCY                                    AR1095624
     C                   MOVE      *BLANKS       FLPOBR                                    AR1095624
      *                                                                                    AR1095624
      ** If CLE031 is switched on, move correct settlement currency.                       AR1095624
      ** Note do not default exchange rate from CLOANCL.                                   AR1095624
      *                                                                                    AR1095624
     C     CLE031        IFEQ      'Y'                                                     AR1095624
     C                   MOVEL     *BLANKS       FLPSCY                                    AR1095624
     C                   ENDIF                                                             AR1095624
      *                                                                                    AR1095624
     C                   ENDSR                                                             AR1095624
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
