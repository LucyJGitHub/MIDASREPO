     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments detail screen validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMVAL - LE Loan amendment detail screen validation       *
      *                                                               *
      *  Function: This program validates a loan amendment input into *
      *            the Midas database.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. LUC109             Date 23Aug16               *
      *  Prev Amend No. MD035672           Date 07Sep15               *
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 10May13               *
      *                 AR1094243          Date 05Mar13               *
      *                 AR632104           Date 02Oct12               *
      *                 AR656363           Date 01Aug12               *
      *                 262461             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR965133           Date 11May12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR945263           Date 01Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG23545           Date 24Mar09               *
      *                 BUG23159           Date 03Mar09               *
      *                 BUG23025           Date 20Feb09               *
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16970           Date 14Mar08               *
      *                 245074             Date 06Mar07               *
      *                 249197             Date 17Jul07               *
      *                 245335             Date 01Feb07               *
      *                 244945             Date 17Jan07               *
      *                 244957A            Date 16Jan07               *
      *                 244957             Date 15Jan07               *
      *                 244483             Date 18Dec06               *
      *                 244314             Date 12Dec06               *
      *                 243251             Date 29Nov06               *
      *                 240411A            Date 10Nov06               *
      *                 BUG13318           Date 12Feb07               *
      *                 BUG11965           Date 29Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11584           Date 23Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 240968             Date 10Jul06               *
      *                 240408             Date 14Jun06               *
      *                 BUG10707           Date 28Feb06               *
      *                 BUG10392           Date 09Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9655            Date 19Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE035             Date 22Sep03               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4843            Date 29Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3760            Date 27Jul04               *
      *                 BUG3722            Date 19Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2301            Date 28Apr04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 01Dec03               *
      *                 CLE030             Date 01Oct02               *
      *                 CAP084             Date 11Oct02               *
      *                 CAP075  *CREATE    Date 22Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *           Bypass check for PI date against last availablity   *
      *           date.                                               *
      *           Amendment of core hook LELOAMV001                   *
      *           Amendment of core hook LELOAMV021                   *
      *           Amendment of core hook LELOAMV027                   *
      *           Addition of hook LUC109_010                         *
      *           Addition of hook LUC109_011                         *
      *  MD035672 - Spread rate should only be allowed if the loan has*
      *             either base rate, base rate code or current base  *
      *             rate.                                             *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1094243 - LOAM-DDVDAT - Principal increase cannot be       *
      *              valued after the last availability date          *
      *              on the facility                                  *
      *  AR632104 - Autosettlement 'C' when subtype change is present.*
      *             Do not allow LS deletion in case of absence of    *
      *             PDCL details in the previous type/subtype of loan.*
      *             (Child: AR632105)                                 *
      *  AR656363 - Do not update exposure when facility utilisation  *
      *             is 'N'. (Child: AR656364)                         *
      *  262461 - COB failed in component LEC07000 00001              *
      *         - check if PDCL loan type is defined                  *
      *         - Error LER5573 should not be output if               *
      *           Loan type starts by X, Y or Z.                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR965133 - Error encountered if Percentage is used           *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR945263 - No warning message issued if the spread indicator *
      *             is reversed                                       *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting ß24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG23545 - System is not allowing to change the Fixed Rate,  *
      *             its giving an error (Recompile)                   *
      *  BUG23159 - Fix BUG23025 to isolate fix for Principal         *
      *             Transfer events only                              *
      *  BUG23025 - Error in case of Loan event Principal Transfer in *
      *            discount loan                                      *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16970- LOAM Amendment on Principal Increase not reflected *
      *            even after authorisation                           *
      *  245074 - Incorrect warning message on PI participant         *
      *  249197 - SDHEDGPD access should be dependent on CAS009       *
      *  245335 - Deal date should not be validated against the last  *
      *           availability date if loan is of PTYP 66,67,72 or 69 *
      *  244945 - Invalid value of PTYP used for validating LOAM      *
      *           customer results to incorrect error message         *
      *           "LEA0104 : Customer entered does not match          *
      *           entry on related loan."                             *
      *  244957A - Obtaing hedging ICD file SDHEDGPD to prevent       *
      *           decimal data error.                                 *
      *  244957 - Recompile                                           *
      *  244483 - No warning on authorise that facility is exceeded   *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  243251 - Back-valued Base rate code doesn't display correct  *
      *           rate on loan activity enquiry.                      *
      *  240411A - Move DDFRSP to DDFRAT as DDFRSP is the input java  *
      *           screen field.                                       *
      *  BUG13318 - When there are no previous loan amendments field  *
      *             WSVACAI is blank resulting in invalid validation  *
      *  BUG11965 - Serious midas error has occured on SubType change *
      *             particularly on FSNLAC field                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11584 - Original Loan Number '000000' not found           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if loan was amended after original entry date  *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  BUG10707- DB Error 3 in LE1110                               *
      *          -Processing type is being overriten by a subtype     *
      *           change in a syndicated primary loan                 *
      *  BUG10392 - Amended conditioning of fields from CLE035 to     *
      *             CLE036.                                           *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9655- Base rate field in Loans, Base Rate Code Change in  *
      *           Loan Event and Rollover Maintenance should be       *
      *           dependent on switchable feature CLE036.             *
      *  CLE106 - Syndication Manager                                 *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits. Added *
      *           Base Rate and Fixed Rate fields.                    *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSC024 - Open Month End                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4843 - Allow amendments so that approval in WIP is possible
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  BUG3722- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines                                        *
      *  BUG2301- Validate currency if PI valued on rollover date.    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  CLE030 - Release Authorisation processing                    *
      *  CAP084 - Midas Plus API development                          *
      *  CAP075 - Lending API enhancements - loan amendments          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+

      ** Midas LE loan amendment details
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(LOAMSDKF)
     F                                     PREFIX(AM_)

      ** Midas LE loans detail files
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF)

      ** Facility amendments file - live
     FLEFCAML6  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FAM_)

      ** Midas LE participations sold by loan
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDF)
     F                                     PREFIX(SLD_)

      ** Midas LE loan amendments file, select on PI
     FLELOAML4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LELOAMD4)

      ** Midas historic base rates by code + date
     FSDBSHSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ***  Midas LE Customer Lending Facility
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF:FCLTYFNF)
     F                                     PREFIX(CAF_)
      *                                                                                      BUG3760
      ** Compliance Watch Hit List                                                           BUG3760
      *                                                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3760
                                                                                              CLE134
      ** PDCL Loans link file                                                                 CLE134
                                                                                              CLE134
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)                                       CLE134
                                                                                              CLE134
      ** PDCL Fees link file                                                                  CLE134
                                                                                              CLE134
     FLEPDUFL2  IF   E           K DISK    INFSR(*PSSR)                                       CLE134

      /COPY WNCPYSRC,LELOAMV001

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE025
     D SCA_LCD       E                     EXTFLD(LCD)                                        CLE025
                                                                                              CLE025
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148

      *****************************************************************
      /EJECT
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
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

     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

      ** Projected drawn facility amounts array
     D WOAM            S             13  0 DIM(10)
                                                                                            AR656363
     D WUpdExpo        S              1A                                                    AR656363

      ** Dates for Facility Exposure Array
     D                 DS
     D  FB_RUN0                1      3P 0
     D  FB_RUN1                4      6P 0
     D  FB_RUN2                7      9P 0
     D  FB_RUN3               10     12P 0
     D  FB_RUN4               13     15P 0
     D  FB_RUN5               16     18P 0
     D  FB_RUN6               19     21P 0
     D  FB_RUN7               22     24P 0
     D  FB_RUN8               25     27P 0
     D  FB_RUN9               28     30P 0
     D  FB_RUN                 1     30P 0 DIM(10) ASCEND

      ** Facility Exposure Array
     D                 DS
     D  FB_OAM1                1      7P 0
     D  FB_OAM2                8     14P 0
     D  FB_OAM3               15     21P 0
     D  FB_OAM4               22     28P 0
     D  FB_OAM5               29     35P 0
     D  FB_OAM6               36     42P 0
     D  FB_OAM7               43     49P 0
     D  FB_OAM8               50     56P 0
     D  FB_OAM9               57     63P 0
     D  FB_OA10               64     70P 0
     D  FB_OAM                 1     70P 0 DIM(10)

      ** Powers of 10 for currency conversions
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)

      ** Customer Details Record Layout
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Loan Type/Subtype
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)

      ** Base Rate Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)

      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029

      ** DS For Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS For Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for calculating PC reference
     D*LEALLO***     E DS                  EXTNAME(LEALLO) DTAARA                             CLE148
     D LEALLO        E DS                  EXTNAME(LEALLO)                                    CLE148

      ** DS to catch the record read from CLOANCL
     D LoanCRead     E DS                  EXTNAME(CLOANCL)

      ** DS to save the loan record -C- linked to the current amendment
     D LoanCSave     E DS                  EXTNAME(CLOANCL) PREFIX(SV)

      ** DS to save the loan record -K- linked to the current amendment
     D LoanKSave     E DS                  EXTNAME(CLOANCK) PREFIX(SV)
     D  LKSRECI      E                     EXTFLD(RECI)
     D  LKSLNRF      E                     EXTFLD(LNRF)
     D  LKSRCDT      E                     EXTFLD(RCDT)
     D  LKSMRIN      E                     EXTFLD(MRIN)
     D  LKSORED      E                     EXTFLD(ORED)
     D  LKSLCD       E                     EXTFLD(LCD)
     D  LKSCHTP      E                     EXTFLD(CHTP)
     D  LKSTNLU      E                     EXTFLD(TNLU)
     D  LKSFRNT      E                     EXTFLD(FRNT)
     D  LKSAFRT      E                     EXTFLD(AFRT)
     D  LKSREPA      E                     EXTFLD(REPA)
     D  LKSTMST      E                     EXTFLD(TMST)

      ** Loan amendment in screen format - input fields
     D LoamScnFmt    E DS                  EXTNAME(LELOAMPD)

      ** Current loan amendment in file format
     D CurFilLoam    E DS                  EXTNAME(LOAMSDK) PREFIX(CAM_)

      ** Flags to indicate whether transaction fields are valid
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)

      ** New loan amendment in file format
     D ValidLoam     E DS                  EXTNAME(LEVLOAMPD)

      * Screen receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)

      * Screen payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
                                                                                              CAS011
      ** External DS for Midas Hedging ICD file                                               CAS011
                                                                                              CAS011
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  CAS011
      *
      ***  Facility details 'A' format
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

     D                 DS
     D  FCLKEY                 1     12
     D**WFCNM***               1      6  0                                                    CSD027
     D  WFCNM                  1      6A                                                      CSD027
     D  WFACT                  7      9  0
     D  WFNUM                 10     11  0
     D  WFRTP                 12     12

      ** 24X7 status data area                                                               BUG3760
      *                                                                                      BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
      *                                                                                      BUG3760
      ** SD data area                                                                        BUG3760
      *                                                                                      BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
      *                                                                                      BUG3760
      ** External DS for Compliance Watch Transaction Details                                BUG3760
      *                                                                                      BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      *                                                                                      BUG3760
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  240968
     D SDBJDFIN      E                     EXTFLD(BJDFIN)                                     240968
     D SDBJLCCY      E                     EXTFLD(BJLCCY)                                     240968
      ***  External DS for bank details                                                       240968
      *                                                                                       240968
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
      *                                                                                      BUG3760
     D CAS009          S              1                                                       CAS011
     D CSC011          S              1                                                      BUG3760
     D CSD015          S              1                                                      BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D WLNRF           S              6                                                      BUG3760
     D WKVDAT          S              5                                                      BUG3760
     D WLASN           S              3                                                      BUG3760
     D WSVACAI         S              1                                                       CAS011
     D PSard           S              6                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
     D CLE056          S              1A                                                      CLE056
     D CLE106          S              1                                                       CLE106
     D*CLE035***       S              1                                              CLE035 BUG10392
     D CLE036          S              1                                             BUG9655 BUG10392
     D WWPTYP          S              2S 0                                                  BUG10707
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240408
     D CRE073          S              1                                                       CRE073
     D PModule         S              6                                                       CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D PNewSpread      S             11P 7                                                    CRE073
     D PFinalRate      S             11P 7                                                  AR847249
     D PCurset         S              2  0                                                    CRE073
     D PBaseRate       S             12    INZ(*BLANKS)                                       CRE073
     D PBaseCode       S              2    INZ(*BLANKS)                                       CRE073

      /COPY WNCPYSRC,LELOAMV002

     D PSysVal01       S             20A                                                      240968
     D PCurSet01       S            200A                                                      240968
     D PSysVal02       S             20A                                                      240968
     D PCurSet02       S            200A                                                      240968
     D PSysVal03       S             20A                                                      240968
     D PCurSet03       S            200A                                                      240968
     D PSysVal04       S             20A                                                      240968
     D PCurSet04       S            200A                                                      240968
     D PSysVal05       S             20A                                                      240968
     D PCurSet05       S            200A                                                      240968
     D PSysVal06       S             20A                                                      240968
     D PCurSet06       S            200A                                                      240968
     D PSysVal07       S             20A                                                      240968
     D PCurSet07       S            200A                                                      240968
     D PSysVal08       S             20A                                                      240968
     D PCurSet08       S            200A                                                      240968
     D PSysVal09       S             20A                                                      240968
     D PCurSet09       S            200A                                                      240968
     D PSysVal10       S             20A                                                      240968
     D PCurSet10       S            200A                                                      240968
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Start of I-specs                      
      **   ================                      
      ** +--------------------------------------+

      /COPY WNCPYSRC,LELOAMV003

      ** +--------------------------------------+
      **   End of I-specs                        
      **   ==============                        
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,LELOAMV004

      ** Check whether user is a web browser user, if so overwrite                            CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       USER             10                          CAP084
      *                                                                                       CAP084
     C                   IF        USER <> *BLANKS                                            CAP084
     C                   EVAL      PSUSER = USER                                              CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                      244957A
      ** Access object for Hedge ICD                                                         244957A
      *                                                                                      244957A
     C                   IF        CAS009 = 'Y'                                              244957A
     C                   CALL      'AOHEDGR0'                                                244957A
     C                   PARM      *BLANKS       PRetCode                                    244957A
     C                   PARM      '*VERIFY'     POption                                     244957A
     C     SDHEDG        PARM      SDHEDG        DSFDY                                       244957A
      *                                                                                      244957A
     C                   IF        PRetCode <> *BLANKS                                       244957A
     C     *LOCK         IN        LDA                                                       244957A
     C                   EVAL      DBFile = 'SDHEDGPD'                                       244957A
     C                   EVAL      DBase = 68                                                244957A
     C                   EVAL      DBKey = POption                                           244957A
     C                   OUT       LDA                                                       244957A
     C                   EXSR      *PSSR                                                     244957A
     C                   ENDIF                                                               244957A
     C                   ENDIF                                                               244957A
     C*                                                                                      244957A
      *
      ** Reset variables
     C                   EXSR      INIT
      *
      ** Validate action code, and retrieve amendment if not insert
     C                   EXSR      ValInit
      *
      ** If on initial screen, stop here
     C     CallModCod    IFEQ      'KDP'
     C                   GOTO      $EndMod
     C                   ENDIF
      *
      ** Processing initialisation. Don't go further if fatal error found
     C                   EXSR      SRINIT
      *
      /COPY WNCPYSRC,LELOAMV005
      *
      *
      /COPY WNCPYSRC,LELOAMV006
      *
      ** If in the direct input function, display warning message
      ** if loan is syndicated (Loan Manager only).
     C     CallModCod    IFEQ      'SIN'
     C                   EXSR      SRWARN
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMV007
      *
      ** There is no validation to do for Principal Transfer,
      ** Reverse or Enquire
     C                   IF        DDATYP = 'PF' OR DDATYP = 'PT' or
     C                             DDACTN = 'E' OR DDACTN = 'R'
                                                                                              CLE106
      ** For a Principal Transfer, the only thing to do is to format                          CLE106
      ** the amount to Midas format                                                           CLE106
     C                   IF        DDATYP = 'PT' OR                                           CLE106
     C                             DDATYP = 'PF'                                              CLE106
     C                   CALLB     'AOCURRR0'                                                 CLE106
     C                   PARM      *BLANKS       @RtCd                                        CLE106
     C                   PARM      '*KEY   '     @Optn                                        CLE106
     C                   PARM      DDCURR        @Curr                                        CLE106
     C     SDCURR        PARM                    DSSDY                                        CLE106
     C     13            SUB       A6NBDP        ZADIG                                        CLE106
                                                                                              CLE106
     C                   CALLB     'ZALIGN'                                                   CLE106
     C                   PARM      *BLANK        ZALIGNok                                     CLE106
     C                   PARM      DDAMNT        ZFIELD                                       CLE106
     C                   PARM      A6NBDP        ZADEC                                        CLE106
     C                   PARM                    ZADIG                                        CLE106
                                                                                              CLE106
     C                   MOVE      ZFIELD        WLAMT                                        CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   EXSR      SetupValid
      *                                                                                     AR632104
      **  Check on reverse action if loan type/subtype on loan level                        AR632104
      **  has undefined PDCL details.                                                       AR632104
      *                                                                                     AR632104
     C                   IF        CLE134 = 'Y'                                             AR632104
     C                   IF        SVAUTO = 'C'                                             AR632104
     C                   IF        %SUBST(DDLTYP:1:1) <> 'X'  AND                           AR632104
     C                             %SUBST(DDLTYP:1:1) <> 'Y'  AND                           AR632104
     C                             %SUBST(DDLTYP:1:1) <> 'Z'                                AR632104
      *                                                                                     AR632104
     C     DDACTN        IFEQ      'R'                                                      AR632104
     C     DDATYP        ANDEQ     'LS'                                                     AR632104
     C                   CALL      'AOLOANR0'                                               AR632104
     C                   PARM      '*BLANKS'     PRTCD                                      AR632104
     C                   PARM      '*KEY'        POPTN                                      AR632104
     C                   PARM      SVLTYP        ATCD                                       AR632104
     C                   PARM      SVSUTP        AUCD                                       AR632104
     C                   PARM      SVCLAS        AUCL                                       AR632104
     C     SDLOAN        PARM      SDLOAN        DSFDY                                      AR632104
     C     AYPPLT        IFEQ      *BLANKS                                                  AR632104
     C     AYPPLS        OREQ      *BLANKS                                                  AR632104
     C     AYIPLT        OREQ      *BLANKS                                                  AR632104
     C     AYIPLS        OREQ      *BLANKS                                                  AR632104
     C                   MOVE      'N'           DDSTYPOK                                   AR632104
     C                   EVAL      Idx        += 1                                          AR632104
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'                               AR632104
     C                   EVAL      MsgIdArr(Idx) =  '5045817'                               AR632104
     C                   ENDIF                                                              AR632104
     C                   ENDIF                                                              AR632104
      *                                                                                     AR632104
     C                   ENDIF                                                              AR632104
     C                   ENDIF                                                              AR632104
     C                   ENDIF                                                              AR632104
      *                                                                                     AR632104
     C                   GOTO      $EndMod
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMV008
      *
      ** Validate fields
     C                   EXSR      SRVCNUM
      *
      /COPY WNCPYSRC,LELOAMV009
      *
     C                   EXSR      SRVCURR
      *
      /COPY WNCPYSRC,LELOAMV010
      *
     C                   EXSR      SRVBRAT
      *
      /COPY WNCPYSRC,LELOAMV011
      *
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   IF        DDATYP = 'SC'                                              CRE073
                                                                                              CRE073
      ** Contractual Spread Rate/Sign                                                         CRE073
                                                                                              CRE073
     C                   EXSR      SRVCNSP                                                    CRE073
                                                                                              CRE073
      ** Rounding Method                                                                      CRE073
                                                                                              CRE073
     C                   IF        DDCNSPOK <> 'N'                                            CRE073
                                                                                              CRE073
     C                   EXSR      SRVRDMT                                                    CRE073
                                                                                              CRE073
      ** Rounding Method                                                                      CRE073
                                                                                              CRE073
     C                   EXSR      SRVRDFD                                                    CRE073
                                                                                              CRE073
     C                   IF        DDCNSGOK <> 'N' AND                                        CRE073
     C                             DDRDMTOK <> 'N' AND                                        CRE073
     C                             DDRDFDOK <> 'N'                                            CRE073
                                                                                              CRE073
     C                   EXSR      SRSPRT                                                     CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EXSR      SRVRTSP
     C                   ENDIF                                                                CRE073
      *                                                                                       CLE035
     C**********         If        CLE035 = 'Y' and DDATYP = 'SC'                    CLE035 BUG10392
     C                   If        CLE036 = 'Y' and DDATYP = 'SC'                           BUG10392
      *                                                                                       CLE035
      ** Validate fixed rate                                                                  CLE035
      *                                                                                       CLE035
     C                   EXSR      SRVFXRT                                                    CLE035
     C                   Endif                                                                CLE035
      *
      /COPY WNCPYSRC,LELOAMV012
      *
     C                   IF        DDCURROK = 'Y'
     C                   EXSR      SRVAMNT
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMV013
      *
     C                   EXSR      SRVSTPA
      *
      /COPY WNCPYSRC,LELOAMV014
      *
     C                   IF        DDCURROK = 'Y'
     C                   EXSR      SRLSPR
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMV015
      *
      ** Validate default participation loan type/subtype                                     CLE106
      ** (for loans and parts purchased when facility is syndicated)                          CLE106
                                                                                              CLE106
     C                   EXSR      SRVDFTP_ST
                                                                                              CLE106
      ** Validate default SUB-participation loan type/subtype when CLE106 is on               CLE106
                                                                                              CLE106
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EXSR      SRVFSTP                                                    CLE106
     C                   ENDIF                                                                CLE106
      *
      /COPY WNCPYSRC,LELOAMV016
      *
      ** Cross-fields validations if no fields error
     C                   IF        Idx = 0
     C                   EXSR      SRSCPR
      *
      ** Loan base rate code change processing
     C     DDATYP        IFEQ      'BC'
     C                   EXSR      SRBCPR
     C                   ENDIF
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMV017
      *
      ** Check for holidays
     C                   IF        DDATYP = 'PI'
     C                   EXSR      SRHOLY
     C                   ENDIF
      *
      ** Warn if PDCL (CLE134) are present                                                    CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   EXSR      SRPDCL                                                     CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If no errors set up fields of the valid file
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMV018
      *
     C     $EndMod       TAG
      *    -------
      /COPY WNCPYSRC,LELOAMV019
      *
      ***  Save the loan reference for warning
     C                   MOVEL     DDLOAN        SaveDDLOAN        6
     C                   MOVEL     DDVDAT        SaveDDVDAT        6
     C                   MOVEL     DDATYP        SaveDDATYP        3
     C                   MOVEL     DDSEQN        SaveDDSEQN        3
     C                   MOVEL     DDACTN        SaveDDACTN        1
      *
     C                   RETURN
      *
      /COPY WNCPYSRC,LELOAMV020

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValInit -  Validate action code                               *
      *****************************************************************
     C     ValInit       BEGSR
      *
      ** Copy the saved loan details to the work format
     C                   MOVEL     LoanCSave     LoanCRead

     C                   MOVE      SVCNUM        CNUM_Alph         6
     C                   MOVE      SVPTYP        PTYP_Loan         2 0                        244945
      *
      ** Compute and save the midas day number corresponding to
      ** the value date of the current loan amendment
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ErrorFlag         1
     C                   Z-ADD     ZDAYNO        VDAYNO            5 0
      *                                                                                     BUG23025
      ** Compute and save the midas day number corresponding to                             BUG23025
      ** the maturity date of the current loan amendment                                    BUG23025
     C                   CALLB     'ZDATE1'                                                 BUG23025
     C                   PARM      DDMDAT        ZDATEA                                     BUG23025
     C                   PARM                    ZDAYNO                                     BUG23025
     C                   PARM      BJDFIN        DateFmt                                    BUG23025
     C                   PARM                    ErrorFlag                                  BUG23025
     C                   Z-ADD     ZDAYNO        MDAYNO            5 0                      BUG23025
      *
      ** Check if reverse loan
     C     SVRECI        IFEQ      'R'
     C                   MOVE      'N'           DDLOANOK
     C     DDACTN        IFEQ      'I'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDLOAN'
     C                   Eval      MsgIdArr(Idx) = 'LEA0025'
     C                   GOTO      EXVALI
     C                   Else
     C                   ADD       1             WIdx
     C                   Eval      WFldNamArr(WIdx) = 'DDLOAN'
     C                   Eval      WMsgIdArr(WIdx) = 'LEA0025'
     C                   GOTO      EXVALI
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if matured loan
     C     SVRECI        IFEQ      'M'
     C     SVRATF        IFNE      'Y'
     C     CLE005        ORNE      'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLOANOK
     C     DDACTN        IFEQ      'I'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDLOAN'
     C                   Eval      MsgIdArr(Idx) = 'LEA0025'
     C                   GOTO      EXVALI
     C                   Else
     C                   ADD       1             WIdx
     C                   Eval      WFldNamArr(WIdx) = 'DDLOAN'
     C                   Eval      WMsgIdArr(WIdx) = 'LEA0025'
     C                   GOTO      EXVALI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/COPY WNCPYSRC,LELOAMV021
      *
      ** Error if value date not later than start date, or later than
      ** maturity date
     C     DDACTN        IFEQ      'I'
     C     VDAYNO        IFLE      VDAT
     C     CLE003        ANDNE     'Y'
     C     VDAYNO        ORLT      VDAT
     C     CLE003        ANDEQ     'Y'
      *                                                                                     BUG23159
     C     MDAT          ORGT      0                                                        BUG23159
     C     VDAYNO        ANDGE     MDAT                                                     BUG23159
      *                                                                                     BUG23159
     C     MDAT          ORGT      0
     C     DDMDAT        ANDNE     *BLANKS                                                  BUG23159
     C*****VDAYNO        ANDGE     MDAT                                                     BUG23025
     C     VDAYNO        ANDGE     MDAYNO                                                   BUG23025

     C/COPY WNCPYSRC,LELOAMV022

     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA0106'     MsgIdArr(Idx)
     C                   GOTO      EXVALI
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if value date falls between the multi-currency rollover
      ** date and the next working day
     C     CLE014        IFEQ      'Y'

     C     RLDT          IFNE      *ZEROS
     C     SVCCY         ANDNE     SVNCCY
      *
     C                   CALLB     'ZFWDT'
     C                   PARM      RLDT          ZDAYNO            5 0
     C                   PARM      1             ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
      *
     C     VDAYNO        IFGT      RLDT
     C     VDAYNO        ANDLT     ZDYNBR
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA1100'     MsgIdArr(Idx)
     C                   GOTO      EXVALI
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if value date is back valued and rollover date exists
     C     VDAYNO        IFLE      WRNDAY
     C     SVNCCY        ANDNE     *BLANKS
     C     RLDT          ANDNE     *ZEROS
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA1101'     MsgIdArr(Idx)
     C                   GOTO      EXVALI
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If amendment type is principal increase the value date must
      * not be later than the Last Available date
     C     DDATYP        IFEQ      'PI'
     C     DDACTN        ANDEQ     'I'
     C/COPY WNCPYSRC,LUC109_010
     C     DDATYP        OREQ      'PI'                                                       CLE030
     C     DDACTN        ANDEQ     'X'                                                        CLE030
     C/COPY WNCPYSRC,LUC109_011
     C     CAM_ASTS      ANDNE     'Q'                                                        CLE030
      *                                                                                       245335
      *  Do not validate value date against last availability date if                         245335
      *  loan type is for a participation sold.                                               245335
     C     SVPTYP        IFNE      66                                                         245335
     C     SVPTYP        ANDNE     67                                                         245335
     C     SVPTYP        ANDNE     69                                                         245335
     C     SVPTYP        ANDNE     72                                                         245335
      *
     C     VDAYNO        IFGT      FA_AVLD
      *                                                                                       CLE030
      ** If CLE030 is switched on then only issue a warning message                           CLE030
     C     CLE030        IFNE      'Y'                                                        CLE030
      *                                                                                    AR1094243
     C                   IF        CLE134 = 'Y'                                            AR1094243
     C                   MOVE      DDLOAN        WKLNR                                     AR1094243
     C                   MOVE      'A'           WRCDT                                     AR1094243
     C     KLKEY         CHAIN (N) CLOANCLF                           99                   AR1094243
      *                                                                                    AR1094243
     C     *IN99         IFEQ      '1'                                                     AR1094243
     C                   MOVE      'N'           DDLOANOK                                  AR1094243
     C                   ADD       1             Idx                                       AR1094243
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'                              AR1094243
     C                   MOVEL     'LEA1518'     MsgIdArr(Idx)                             AR1094243
     C**********         MOVEL(P)  SVOLNO        MsgDtaArr(Idx)                   AR1094243 MD000091
     C                   EVAL      BLen = %Len(%Trim(SVOLNO))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(SVOLNO)                   MD000091
      *                                                                                    AR1094243
     C                   ELSE                                                              AR1094243
      *                                                                                    AR1094243
     C                   IF        %SUBST(LTYP:1:1) = 'X'  OR                              AR1094243
     C                             %SUBST(LTYP:1:1) = 'Y'  OR                              AR1094243
     C                             %SUBST(LTYP:1:1) = 'Z'                                  AR1094243
      *                                                                                    AR1094243
     C                   CALL      'AOLOANR0'                                              AR1094243
     C                   PARM      '*BLANKS'     PRTCD                                     AR1094243
     C                   PARM      '*KEY'        POPTN                                     AR1094243
     C                   PARM      LTYP          ATCD                                      AR1094243
     C                   PARM      SUTP          AUCD                                      AR1094243
     C                   PARM      CLAS          AUCL                                      AR1094243
     C     SDLOAN        PARM      SDLOAN        DSFDY                                     AR1094243
      *                                                                                    AR1094243
     C                   IF        (PRTCD = *BLANKS)  AND (AYFAMU <> 'Y')                  AR1094243
     C                   GOTO      SkipVal                                                 AR1094243
     C                   ENDIF                                                             AR1094243
      *                                                                                    AR1094243
     C                   ENDIF                                                             AR1094243
     C                   ENDIF                                                             AR1094243
     C                   ENDIF                                                             AR1094243
      *                                                                                    AR1094243
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA0109'     MsgIdArr(Idx)
     C                   ELSE                                                                 CLE030
     C*****VDAYNO        IFNE      WVDAYNO                                            CLE030 BUG4351
     C                   MOVE      'N'           DDVDATOK                                     CLE030
     C**********         Z-ADD     VDAYNO        WVDAYNO           5 0                CLE030 BUG4351
     C                   ADD       1             WIdx                                         CLE030
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'                                CLE030
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA0606'                               CLE030
     C                   MOVE      'Q'           WLASTS            1                          CLE030
     C**********         ENDIF                                                        CLE030 BUG4351
     C                   ENDIF                                                                CLE030
     C                   ENDIF
      *
     C                   ENDIF                                                                245335
      *                                                                                       245335
     C                   ENDIF
     C     SkipVal       TAG                                                               AR1094243
      *
      ** If insert screen amendment type must be entered
      ** else amendment type must equal what is on file
     C     DDACTN        IFEQ      'I'
      *
      ** Validate loan amendment type
     C     DDATYP        IFEQ      *BLANKS
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA0181'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     DDATYP        IFEQ      'LS'
      *
      ** If Insert and 'Loan Subtype' amendment type,
      ** value date must equal rundate if CLE003 is off
     C     CLE003        IFNE      'Y'
     C     VDAYNO        IFNE      WRNDAY
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA0114'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If not LS amendment, check valid entry
     C                   ELSE
      *
     C     CallModCod    IFEQ      'SIN'
     C     DDATYP        ANDNE     'PI'
     C     DDATYP        ANDNE     'SC'
     C     DDATYP        ANDNE     'BC'
     C     DDATYP        ANDNE     'SA'
      *
     C     CallModCod    ORNE      'SIN'
     C     DDATYP        ANDNE     'PI'
     C     DDATYP        ANDNE     'SC'
     C     DDATYP        ANDNE     'BC'
     C     DDATYP        ANDNE     'SA'
     C     DDATYP        ANDNE     'PT'
     C     DDATYP        ANDNE     'PF'
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA0183'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If action is not insert, amendment type must equal what
      ** is on file
     C                   ELSE
     C     DDATYP        IFNE      *BLANK
     C     DDATYP        ANDNE     CAM_AMTP
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA0513'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'I'
      *                                                                                      BUG3722
      ** When CLE028 is installed, Amendment type 'BC', 'PI' and 'SC'                        BUG3722
      ** are not allowed for flat rate personal loans                                        BUG3722
      *                                                                                      BUG3722
     C     CLE028        IFEQ      'Y'                                                       BUG3722
     C     SVPTYP        ANDEQ     80                                                        BUG3722
     C     DDATYP        IFEQ      'BC'                                                      BUG3722
     C     DDATYP        OREQ      'PI'                                                      BUG3722
     C     DDATYP        OREQ      'SC'                                                      BUG3722
     C                   ADD       1             Idx                                         BUG3722
     C                   MOVE      'N'           DDATYPOK                                    BUG3722
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'                                BUG3722
     C                   MOVEL     'LEA1102'     MsgIdArr(Idx)                               BUG3722
     C                   ENDIF                                                               BUG3722
     C                   ENDIF                                                               BUG3722
      *
      ** For loan type 'PI' allow processing types 61, 62, 64, 66
      ** and 70 if CLE005 is off
      ** Or allow processing types 61, 62, 64, 66, 68, 69, 70, 71
      ** and 72 if CLE005 is on
     C     DDATYP        IFEQ      'PI'
     C     SVPTYP        IFNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     CLE005        ANDNE     'Y'
     C     SVPTYP        ORNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     69
     C     SVPTYP        ANDNE     71
     C     SVPTYP        ANDNE     72
     C     CLE005        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   MOVE      'N'           DDATYPOK
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA0184'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** For type BC and SC, Discount loan not allowed
     C     DDATYP        IFEQ      'BC'
     C     DDATYP        OREQ      'SC'
     C     SVPTYP        IFNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     CLE005        ANDNE     'Y'
     C     SVPTYP        ORNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     69
     C     SVPTYP        ANDNE     71
     C     SVPTYP        ANDNE     72
     C     CLE005        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   MOVE      'N'           DDATYPOK
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1037'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** For loan type 'SA' allow processing type 61, 62, 64, 66 or 70
     C     DDATYP        IFEQ      'SA'
      *                                                                                      BUG3722
      ** Allow SA amendment only if add on interest is not 'Y'                               BUG3722
      *                                                                                      BUG3722
     C     CLE028        IFEQ      'Y'                                                       BUG3722
     C     SVPTYP        ANDEQ     80                                                        BUG3722
     C     ADIF          IFEQ      'Y'                                                       BUG3722
     C                   MOVE      'N'           WALWSA            1                         BUG3722
     C                   ELSE                                                                BUG3722
     C                   MOVE      'Y'           WALWSA                                      BUG3722
     C                   ENDIF                                                               BUG3722
     C                   ENDIF                                                               BUG3722
      *                                                                                      BUG3722
     C     SVPTYP        IFNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     CLE005        ANDNE     'Y'
     C     WALWSA        ANDNE     'Y'                                                       BUG3722
     C     SVPTYP        ORNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     69
     C     SVPTYP        ANDNE     71
     C     SVPTYP        ANDNE     72
     C     CLE005        ANDEQ     'Y'
     C     WALWSA        ANDNE     'Y'                                                       BUG3722
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1001'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** If Insert and 'Stop Accruals' amendment type,
      ** value date must equal rundate if CLE003 is off
     C     CLE003        IFNE      'Y'
     C     VDAYNO        ANDNE     WRNDAY
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA0114'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     SVAUTO        IFNE      'N'
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA0185'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check that there is not another loan amendment
      ** of the same type for the same date
     C     DDATYP        IFNE      'PI'
     C     DDATYP        ANDNE     'PT'                                                       CLE106
     C     DDATYP        ANDNE     'PF'                                                       CLE106
      *
     C                   MOVE      DDLOAN        WKLNR
     C                   MOVE      VDAYNO        WKVDT
     C                   Z-ADD     0             WKLSN
     C                   MOVE      '0'           *IN99
      *
     C     KLAKEY        SETLL     LOAMSDKF
      *
     C     *IN99         DOWEQ     '0'
     C                   READ      LOAMSDKF                               99
     C     *IN99         IFEQ      '1'
     C     WKLNR         ORNE      AM_LNRF
     C     VDAYNO        ORNE      AM_VDAT
     C                   LEAVE
     C                   ENDIF
      *
     C     DDATYP        IFEQ      AM_AMTP
     C     AM_RECI       ANDEQ     'D'
     C                   MOVE      'N'           DDVDATOK
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   MOVEL     'LEA0177'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the loan amendment exists, check if the loan processing type
      ** is valid versus the amendment type when CLE005 is ON/OFF.
      ** Same tests as those done above on the screen amendment type
      ** in insert mode.
     C     DDACTN        IFNE      'I'
      *
      ** For loan type 'PI' allow processing type 61, 62, 64, 66
      ** or 70
     C     DDATYP        IFEQ      'PI'
     C     SVPTYP        IFNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     CLE005        ANDNE     'Y'
     C     SVPTYP        ORNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     69
     C     SVPTYP        ANDNE     71
     C     SVPTYP        ANDNE     72
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Idx
     C                   MOVEL     'LEA0184'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   ENDIF
     C                   ENDIF
      *
      ** For type BC and SC, discount loan not allowed
     C     DDATYP        IFEQ      'BC'
     C     DDATYP        OREQ      'SC'
     C     SVPTYP        IFNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     CLE005        ANDNE     'Y'
     C     SVPTYP        ORNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     69
     C     SVPTYP        ANDNE     71
     C     SVPTYP        ANDNE     72
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1037'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   ENDIF
     C                   ENDIF
      *
      ** For loan type 'SA' allow processing type 61, 62, 64, 66 or 70
     C     DDATYP        IFEQ      'SA'
      *                                                                                      BUG3722
      ** Allow SA amendment only if add on interest is not 'Y'                               BUG3722
      *                                                                                      BUG3722
     C     CLE028        IFEQ      'Y'                                                       BUG3722
     C     SVPTYP        ANDEQ     80                                                        BUG3722
     C     ADIF          IFEQ      'Y'                                                       BUG3722
     C                   MOVE      'N'           WALWSA            1                         BUG3722
     C                   ELSE                                                                BUG3722
     C                   MOVE      'Y'           WALWSA                                      BUG3722
     C                   ENDIF                                                               BUG3722
     C                   ENDIF                                                               BUG3722
      *                                                                                      BUG3722
     C     SVPTYP        IFNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     CLE005        ANDNE     'Y'
     C     WALWSA        ANDNE     'Y'                                                       BUG3722
     C     SVPTYP        ORNE      61
     C     SVPTYP        ANDNE     62
     C     SVPTYP        ANDNE     64
     C     SVPTYP        ANDNE     66
     C     SVPTYP        ANDNE     70
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     69
     C     SVPTYP        ANDNE     71
     C     SVPTYP        ANDNE     72
     C     CLE005        ANDEQ     'Y'
     C     WALWSA        ANDNE     'Y'                                                       BUG3722
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1001'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
      *
     C     CAM_RECI      IFEQ      'R'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLOANOK
     C                   MOVE      'N'           DDSEQNOK
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1002'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   ENDIF
      *
      **  Test if conf. & msg. seq. nos. blank
      **  Zeroise blank fields, else leave
     C                   MOVE      SVLSWC        LSWCA             3
     C     LSWCA         IFEQ      ' '
     C                   Z-ADD     0             WOLSWC            3 0
     C                   ELSE
     C                   Z-ADD     SVLSWC        WOLSWC            3 0
     C                   ENDIF
      *
     C                   MOVE      SVLSWS        LSWSA             3
     C     LSWSA         IFEQ      ' '
     C                   Z-ADD     0             WOLSWS            3 0
     C                   ELSE
     C                   Z-ADD     SVLSWS        WOLSWS            3 0
     C                   ENDIF
      *
      ** If invalid loan amendment type, output error message
     C     DDATYP        IFEQ      'PD'
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'I'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1003'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If amendment type is PD and action code is reversal and
      ** repayment was inserted against it (TAMT is less than or equal
      ** to zero), do not allow reversal of PD record.
     C     DDATYP        IFEQ      'PD'
     C     DDACTN        ANDEQ     'R'
     C     CAM_TAMT      ANDLE     0
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1041'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** If amendment type is repayment schedule, output error message
     C     DDATYP        IFEQ      'RE'
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1004'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** If amendment type is manual repayments, output error message
     C     DDATYP        IFEQ      'MR'
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1005'     MsgIdArr(Idx)
     C                   ENDIF
      *
      **  Can only do these for a loan subtype amendment
     C     DDATYP        IFNE      'LS'
     C     SVPTYP        IFEQ      63
     C     SVPTYP        OREQ      65
     C     SVPTYP        OREQ      67
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDATYP'
     C                   MOVEL     'LEA1006'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If amendment is LS convert maturity date
     C     DDATYP        IFEQ      'LS'
     C                   Z-ADD     CAM_LSMD      ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM      CAM_LSMD      ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
      *
     C                   MOVE      ZDATE         WMDAT1            6
     C                   ENDIF
      *
      ** Amendment only allowed for type PI
     C     DDACTN        IFEQ      'A'
     C     DDATYP        ANDNE     'PI'
     C     DDATYP        ANDEQ     '??'                                                      BUG4843
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   MOVEL     'LEA0056'     MsgIdArr(Idx)
     C                   ENDIF
      *                                                                                       CLE030
      ** If Action code is amend, amendment type is Principal Increase                        CLE030
      ** and the amendment status is 'Requires Release'                                       CLE030
     C     DDACTN        IFEQ      'A'                                                        CLE030
     C     DDATYP        ANDEQ     'PI'                                                       CLE030
     C     CAM_ASTS      ANDEQ     'Q'                                                        CLE030
     C                   MOVE      'N'           DDACTNOK                                     CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CLE030
     C                   MOVEL     'LEA0605'     MsgIdArr(Idx)                                CLE030
     C                   ENDIF                                                                CLE030
      *
     C     CLE003        IFEQ      'Y'
     C     *LIKE         DEFINE    G0HIDT        VADAT
     C                   Z-ADD     ZDAYNO        VADAT
     C                   ENDIF
      *
      ** If action code is 'X', execute Authorisation Processing
     C     DDACTN        IFEQ      'X'
     C                   EXSR      ValActnAut
     C                   ENDIF
      *                                                                                       CLE030
      ** If action code is 'Q', execute Release Processing                                    CLE030
     C     DDACTN        IFEQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   EXSR      ValActnRel                                                 CLE030
     C                   ENDIF                                                                CLE030
                                                                                              CLE106
      ** Check Loan Type                                                                      CLE106
                                                                                              CLE106
     C     DDLTYP        IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      SVLTYP        DDLTYP                                       CLE106
     C                   ENDIF                                                                CLE106
      *
     C     EXVALI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValActnAut Validate authorisation action                      *
      *****************************************************************
     C     ValActnAut    BEGSR
      *
      ** If authorisation feature (CLE002) is not installed
      ** authorisation action is not allowed
     C     CLE002        IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1021'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
      *
      ** If authorisation feature is installed
     C                   ELSE
      *
     C     BPLMAU        IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1022'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   ELSE
      *
      ** Original loan must be authorised
     C                   MOVE      LSTS          WLSTS             1
     C     WLSTS         IFNE      'A'
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1039'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   ENDIF
      *
      ** Authorising user must be different from the insert and
      ** amend users
      ***  Unless CLE056 is enabled and not day of input and not last amender                 CLE056

     C/COPY WNCPYSRC,LELOAMV023
      *
      * If system value CLAuthORED = 'Y' and last amend date is later than                    240968
      * original entry date then allow authorise user to be same as insert user               240968
      *                                                                                       240968
      * Or if CLAuthSameORED = 'Y' then allow authorise user to be same as original           244314
      * insert user as long as the last change type was an amendment and the                  244314
      * current status of transaction is 'Reauthorise Required'                               244314
      *                                                                                       244314
     C     ATHORED       IFEQ      'Y'                                                        240968
     C     ATHSMDT       ANDNE     'Y'                                                        244314
     C*****LCD           ANDGT     ORED                                                240968 244314
     C*****CHTP          ANDEQ     'A'                                                 240968 244314
     C     CAM_LCD       ANDGT     CAM_ORED                                                   244314
     C     CAM_CHTP      ANDEQ     'A'                                                        244314
     C     BJRDNB        ANDGT     ORED                                                       240968
     C     ATHSMDT       OREQ      'Y'                                                        244314
     C     CAM_CHTP      ANDEQ     'A'                                                        244314
     C     CAM_ASTS      ANDEQ     'R'                                                        244314
      *                                                                                       240968
     C     PSUser        IFEQ      CAM_AUSR                                                   240968
     C                   ADD       1             Idx                                          240968
     C                   MOVEL     'LEA1023'     MsgIdArr(Idx)                                240968
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 240968
     C                   ENDIF                                                                240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     PSUser        IFEQ      CAM_IUSR
     C     PSUser        OREQ      CAM_AUSR
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and CAM_ORED = WRNDAY                        CLE056
     C                                           and PSUser = CAM_IUSR) or                    CLE056
     C                             (CLE056 = 'Y' and CAM_LCD = WRNDAY and                     CLE056
     C                              CAM_CHTP = 'A' and PSUser = CAM_AUSR)                     CLE056
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1023'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EndIf                                                                CLE056
     C                   ENDIF
     C                   ENDIF                                                                240968

     C/COPY WNCPYSRC,LELOAMV024
      *
      ** Status of loan must be complete or requiring re-authorisation
     C     CAM_ASTS      IFNE      'C'
     C     CAM_ASTS      ANDNE     'R'
     C                   ADD       1             Idx
     C                   MOVEL     'LEA1024'     MsgIdArr(Idx)
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3760
      ** If the CLSP transaction exists in the hit list, setup error message                 BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                   IF        (CSC011 = 'N' OR CSC011 = 'Y'                             BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
     C                   MOVE      CAM_LNRF      WLNRF                                       BUG3760
     C                   MOVE      CAM_VDAT      WKVDAT                                      BUG3760
     C                   MOVE      CAM_LASN      WLASN                                       BUG3760
     C                   EVAL      WFuncType = 'LOAMSDK'                                     BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WIdntifier = WLNRF + WKVDAT + WLASN                       BUG3760
     C                   EVAL      WBranch = BRCA                                            BUG3760
      *                                                                                      BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                        BUG3760
     C                   ADD       1             Idx                                         BUG3760
     C                   MOVEL     'LEL0564'     MsgIdArr(Idx)                               BUG3760
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CLE030
      /EJECT                                                                                  CLE030
      *****************************************************************                       CLE030
      * ValActnRel Validate Release action                            *                       CLE030
      *****************************************************************                       CLE030
     C     ValActnRel    BEGSR                                                                CLE030
      *                                                                                       CLE030
      ** If authorisation feature (CLE002) is not installed                                   CLE030
      ** Release action is not allowed                                                        CLE030
     C     CLE002        IFEQ      'N'                                                        CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   MOVEL     'LEA0601'     MsgIdArr(Idx)                                CLE030
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CLE030
      *                                                                                       CLE030
      ** If authorisation feature is installed                                                CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
     C     BPLMAU        IFEQ      'N'                                                        CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   MOVEL     'LEA0600'     MsgIdArr(Idx)                                CLE030
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      ** Release Authorisation feature (CLE030) must be switched on.                          CLE030
     C     CLE030        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           DDLOANOK                                     CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   MOVEL     'LEA0602'     MsgIdArr(Idx)                                CLE030
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ** Authorising user must be different from the insert and                               CLE030
      ** amend users                                                                          CLE030
                                                                                              CLE030
     C/COPY WNCPYSRC,LELOAMV025                                                               CLE030
      *                                                                                       CLE030
     C     PSUser        IFEQ      CAM_IUSR                                                   CLE030
     C     PSUser        OREQ      CAM_XUSR                                                   CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   MOVEL     'LEA0604'     MsgIdArr(Idx)                                CLE030
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CLE030
     C                   ENDIF                                                                CLE030
                                                                                              CLE030
     C/COPY WNCPYSRC,LELOAMV026                                                               CLE030
      *                                                                                       CLE030
      ** Status of loan must be 'Requires Release'                                            CLE030
     C                   MOVE      CAM_ASTS      ASTS                                         CLE030
     C     ASTS          IFNE      'Q'                                                        CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   MOVEL     'LEA0603'     MsgIdArr(Idx)                                CLE030
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
     C                   ENDSR                                                                CLE030
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Initialisation for each call to this module          *
      *          (except initial screen)                              *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up a flag for parts sold
     C                   MOVE      *BLANK        WSOLD             1
      *
     C     SVPTYP        IFEQ      66
     C     SVPTYP        OREQ      67
     C     SVPTYP        OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     SVPTYP        OREQ      72
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF
      *
      ** For type 72 get processing type of loan sold
     C                   Z-ADD     0             WSPTYP            2 0
      *
     C     SVPTYP        IFEQ      72
     C     CLE005        ANDEQ     'Y'
      *
     C**********         Z-ADD     SVOLNO        WKLNR                                        CSD027
     C                   Move      SVOLNO        WKLNR                                        CSD027
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEA1518'     MsgIdArr(Idx)
     C**********         MOVEL(P)  SVOLNO        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SVOLNO))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(SVOLNO)                   MD000091
     C                   ENDIF
      *
     C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
     C                   Z-ADD     67            WSPTYP
     C                   ENDIF
      *
     C     PTYP          IFEQ      62
     C     PTYP          OREQ      64
     C                   Z-ADD     66            WSPTYP
     C                   ENDIF
      *
     C     PTYP          IFEQ      61
     C     PTYP          OREQ      68
     C                   Z-ADD     69            WSPTYP
     C                   ENDIF
      *
     C     PTYP          IFEQ      70
     C     PTYP          OREQ      71
     C                   Z-ADD     70            WSPTYP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXINIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRWARN   - Send a warning message if a syndicated loan is     *
      *            being amended, reversed or authorised directly on  *
      *            Midas as Loan Manager should be used to take       *
      *            advantage of the autogeneration process.           *
      *****************************************************************
     C     SRWARN        BEGSR
      *
      ** Warn if participation linked to a syndicate
     C     SVPTYP        IFEQ      64
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      65
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      66
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      67
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      68
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      69
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      71
     C     SVLNKS        ANDEQ     'Y'
     C     SVPTYP        OREQ      72
     C     SVLNKS        ANDEQ     'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDArr(WIdx) = 'LEM0232'
     C                   EVAL      WFldNamArr(WIdx) = 'DDACTN'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLOAN'
      *
     C                   ELSE
      *
      ** Warn if loan or direct participation purchased but facility
      ** is syndicated.
     C     SVPTYP        IFEQ      61
     C     SVPTYP        OREQ      62
     C     SVPTYP        OREQ      63
     C     SVPTYP        OREQ      64
     C     SVLNKS        ANDNE     'Y'
     C     SVPTYP        OREQ      65
     C     SVLNKS        ANDNE     'Y'
     C     SVPTYP        OREQ      68
     C     SVLNKS        ANDNE     'Y'
     C     SVPTYP        OREQ      70
     C     SVPTYP        OREQ      71
     C     SVLNKS        ANDNE     'Y'
      *
     C     FA_SYIN       IFEQ      'Y'
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDArr(WIdx) = 'LEM0232'
     C                   EVAL      WFldNamArr(WIdx) = 'DDACTN'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDLOAN'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCNUM - Validate Customer                                   *
      *****************************************************************
     C     SRVCNUM       BEGSR
      *
      ** Customer must not be blank
     C     DDCNUM        IFEQ      *BLANK
     C                   MOVE      'N'           DDCNUMOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCNUM'
     C                   MOVEL     'LEA0178'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** Customer must exist in Customer File
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCNUM        @CUST            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANK
     C                   MOVE      'N'           DDCNUMOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCNUM'
     C                   MOVEL     'LEA0034'     MsgIdArr(Idx)
     C                   ELSE
     C                   MOVEL(P)  BBCUST        DDCNUM
     C                   ENDIF
      *
      ** Customer must not be a parent
     C     BBPAIN        IFEQ      'P'
     C                   MOVE      'N'           DDCNUMOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCNUM'
     C                   MOVEL     'LEA0036'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** Entered customer must equal customer in related loan
      *                                                                                       240408
     C*****PTYP**********IFEQ      64                                                 240408  244945
     C*****PTYP**********OREQ      65                                                 240408  244945
     C*****PTYP**********OREQ      68                                                 240408  244945
     C*****PTYP**********OREQ      71                                                 240408  244945
     C     PTYP_Loan     IFEQ      64                                                         244945
     C     PTYP_Loan     OREQ      65                                                         244945
     C     PTYP_Loan     OREQ      68                                                         244945
     C     PTYP_Loan     OREQ      71                                                         244945
      *If the loan is a Participation Purchased, & System Value                               240408
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240408
     C     PPCUST        IFEQ      'O'                                                        240408
     C                   MOVE      SVOLNO        CNUM_Alph2                                   240408
      * Else, use 'Purchased from' customer number.                                           240408
     C                   ELSE                                                                 240408
     C                   MOVE      CNUM_Alph     CNUM_Alph2                                   240408
     C                   ENDIF                                                                240408
      * Else, loan is not a Part Purchased:                                                   240408
     C                   ELSE                                                                 240408
     C                   MOVE      CNUM_Alph     CNUM_Alph2        6                          240408
     C                   ENDIF                                                                240408
      *                                                                                       240408
     C*****BBCUST        IFNE      CNUM_Alph                                                  240408
     C     BBCUST        IFNE      CNUM_Alph2                                                 240408
     C                   MOVE      'N'           DDCNUMOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCNUM'
     C                   MOVEL     'LEA0104'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     EXVCNUM       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCURR - Validate currency                                   *
      *****************************************************************
     C     SRVCURR       BEGSR
      *
      ** Check that a currency has been entered
     C     DDCURR        IFEQ      *BLANK
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0175'     MsgIdArr(Idx)
     C                   GOTO      EXVCURR
     C                   ENDIF
      *
      ** Get currency decimal places
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCURR        @Curr
     C     SDCURR        PARM                    DSSDY

     C     @RtCd         IFNE      *BLANKS
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA1009'     MsgIdArr(Idx)
     C                   ELSE
     C                   Z-ADD     A6NBDP        CDPL              1 0
      *
      ** For a Principal Transfer, the only thing to do is to format
      ** the amount to Midas format
     C                   IF        DDATYP = 'PT' OR
     C                             DDATYP = 'PF' OR
     C                             DDATYP = 'PI'
     C     13            SUB       A6NBDP        ZADIG

     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok          1
     C                   PARM      DDAMNT        ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0

     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        WLAMT
     C                   ELSE
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNT'
     C                   MOVEL     'LEA0192'     MsgIdArr(Idx)
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
      *
      ** Save loan currency details.
     C     CLE023        IFEQ      'Y'
     C                   MOVE      DDCURR        ZCCYI
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   ENDIF
      *
      ** If Multi Currency Rollover is on and the loan has
      ** Rollover details
     C     CEU020        IFEQ      'Y'
      *
     C     SVRLDT        IFNE      0
      *
      ***If*the*rollover*date*is*later*than*the*value*date*of*the*loan****                   BUG2301
      ** If the rollover date is equal to or later than the date of the                      BUG2301
      ** amendment then ensure that the loan amendment is using the
      ** original loan currency
     C*****SVRLDT****    IFGT      VDAYNO                                                    BUG2301
     C     SVRLDT        IFGE      VDAYNO                                                    BUG2301
     C     DDCURR        ANDNE     SVCCY
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0189'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** If the rollover date is earlier than the value date of the
      ** loan amendment then ensure that the loan amendment is
      ** using the rollover ccy, if entered
      *
      ** This is only possible for an IN ccy which has started it's
      ** transition period on or before the rollover date.  These
      ** loans can only roll over to EUR (Checked in LE0070)
     C     SVRLDT        IFLT      VDAYNO
      *
     C     SVNCCY        IFNE      *BLANKS
      *
     C     DDCURR        IFNE      SVNCCY
     C     CLE014        ANDEQ     'N'
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0115'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** If CLE014 is installed, currency must be in the loan currency
     C     CLE014        IFEQ      'Y'
     C     DDCURR        ANDNE     SVCCY
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0189'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDCURR        IFNE      SVCCY
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0189'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Multi Currency Rollover (CEU020) is on and there are no
      ** rollover details then validate against the original Loan
      ** currency
     C     SVRLDT        IFEQ      0
      *
     C     DDCURR        IFNE      SVCCY
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0189'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *** For non CEU020 loan amends ensure that the loan amendment
      *** is using the original loan currency
     C     CEU020        IFNE      'Y'
     C     DDCURR        ANDNE     SVCCY
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   MOVEL     'LEA0189'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     EXVCURR       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **SRVBRAT*-*Validate*Base*Rate***********************************                       CLE035
      * SRVBRAT - Validate Base Rate Code and Base Rate               *                       CLE035
      *****************************************************************
     C     SRVBRAT       BEGSR
      *
     C     DDBRAT        IFEQ      *BLANK
      *
      ** Base Rate must be entered if amendment type is BC                                    CLE035
                                                                                              CLE035
     C     DDATYP        IFEQ      'BC'
     C*****CLE035        ANDEQ     'N'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'N'                                                      BUG10392
     C                   MOVE      'N'           DDBRATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C                   MOVEL     'LEA0193'     MsgIdArr(Idx)
     C                   GOTO      EXVBRAT
     C                   ENDIF
      *
     C**********         ELSE                                                                 CLE035
                                                                                              CLE035
      ** Either Base Rate Code or Base Rate must be entered if                                CLE035
      **    amendment type is Base Rate Code Change (BC)                                      CLE035
                                                                                              CLE035
     C     DDATYP        IFEQ      'BC'                                                       CLE035
     C     DDBASR        ANDEQ     *BLANK                                                     CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
     C                   MOVE      'N'           DDBRATOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'                                 CLE035
     C                   MOVEL     'LEA1620'     MsgIdArr(Idx)                                CLE035
     C                   GOTO      EXVBRAT                                                    CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C     DDBRAT        IFNE      *BLANK                                                     CLE035
     C     DDBASR        ANDNE     *BLANK                                                     CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
     C     DDATYP        ANDEQ     'BC'                                                       CLE035
     C                   MOVE      'N'           DDBRATOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'                                 CLE035
     C                   MOVEL     'LEA1620'     MsgIdArr(Idx)                                CLE035
     C                   GOTO      EXVBRAT                                                    CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Base Rate Code or Base Rate must not be entered                                      CLE035
      **    if amendment type is not Base Rate Code Change (BC)                               CLE035
                                                                                              CLE035
     C     DDBRAT        IFNE      *BLANK                                                     CLE035
     C     DDBASR        ORNE      *BLANK                                                     CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
      *
     C     DDATYP        IFNE      'BC'
     C                   MOVE      'N'           DDBRATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C*****CLE035        IFEQ      'Y'                                               CLE035 BUG10392
     C     CLE036        IFEQ      'Y'                                                      BUG10392
     C                   MOVEL     'LEA1621'     MsgIdArr(Idx)                                CLE035
     C                   ELSE                                                                 CLE035
     C                   MOVEL     'LEA0194'     MsgIdArr(Idx)
     C                   ENDIF                                                                CLE035
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check Base rate entered on Base Rate file
     C     DDBRAT        IFNE      *BLANK
     C*****CLE035        ANDEQ     'N'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'N'                                                      BUG10392
                                                                                              CLE035
      ** Base Rate Code = entered; Base Rate = Blanks                                         CLE035
                                                                                              CLE035
     C     DDBRAT        ORNE      *BLANK                                                     CLE035
     C     DDBASR        ANDEQ     *BLANK                                                     CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
      *
      ** Entry to this field is forbidden if base rate change
      ** facility indicator is not set to 'Y'
     C     BPBRCF        IFNE      'Y'
     C                   MOVE      'N'           DDBRATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C                   MOVEL     'LEA1010'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** The following validation can only be done if currency is ok
     C     DDCURROK      IFEQ      'Y'
      *                                                                                       243251
     C                   MOVEL     DDCURR        CRCY                                         243251
     C                   MOVEL     DDBRAT        BCCOD                                        243251
     C     BCKEY1        SETGT     SDBSHSD0                                                   243251
     C     BCKEY         READPE    SDBSHSD0                               99                  243251
     C     *IN99         IFEQ      '0'                                                        243251
     C                   Z-ADD     G0CBSR        WBASR                                        243251
     C                   ENDIF                                                                243251
      *                                                                                       243251
     C     *IN99         IFEQ      '1'                                                        243251
     C     VDAYNO        OREQ      WRNDAY                                                     243251
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY    '    @Optn
     C                   PARM      DDCURR        @Curr             3
     C                   PARM      DDBRAT        @BRat             2
     C     SDBSRT        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANK
     C                   MOVE      'N'           DDBRATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C                   MOVEL     'LEA0139'     MsgIdArr(Idx)
     C                   ELSE
      *
     C     CLE003        IFNE      'Y'
      *
      ** If base rate is going to change today then prohibit
      ** back valued amendments
     C     BAVDNR        IFEQ      WRNDAY
     C     VDAYNO        ANDLT     BAVDNR
     C     VDAYNO        ORLT      BAVDRC
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA0113'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If base rate is going to change on or before value date of
      ** loan amendment, then use new base rate
     C     VDAYNO        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        WBASR            11 7
     C                   ELSE
     C                   Z-ADD     BANBRT        WBASR            11 7
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                243251
      *
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CLE035
      ** Base Rate Code = Blanks; Base Rate = entered                                         CLE035
                                                                                              CLE035
     C     DDBRAT        IFEQ      *BLANK                                                     CLE035
     C     DDBASR        ANDNE     *BLANK                                                     CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
                                                                                              CLE035
     C                   CALLB     'ZALIGN'                                                   CLE035
     C                   PARM      *BLANK        ZALIGNok                                     CLE035
     C                   PARM      DDBASR        ZFIELD                                       CLE035
     C                   PARM      7             ZADEC                                        CLE035
     C                   PARM      4             ZADIG                                        CLE035
                                                                                              CLE035
      ** A Base Rate of zero is not valid.                                                    CLE035
      ** Invalid Base Rate Entered                                                            CLE035
                                                                                              CLE035
     C     ZALIGNok      Ifeq      'N'                                                        CLE035
     C                   MOVE      'N'           DDBASROK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDBASR'                                 CLE035
     C                   MOVEL     'LEA1624'     MsgIdArr(Idx)                                CLE035
     C                   Else                                                                 CLE035
     C                   MOVE      ZFIELD        WBASR                                        CLE035
     C                   Endif                                                                CLE035
     C                   ENDIF                                                                CLE035
      *
     C     EXVBRAT       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVRTSP - Validate Rate / Spread                              *
      *****************************************************************
     C     SRVRTSP       BEGSR
      *
      ** Field must not be blank for type 'SC' if:
      **    Analytical Accounting is not installed or the loan isn't
      **    directly funded and Revenue Analysis isn't on
     C     DDRTSP        IFEQ      *BLANK
      *
     C     DDATYP        IFEQ      'SC'
      *
     C     BGN0ST        IFNE      'Y'
     C     SVFPRC        OREQ      *BLANKS
      *
     C     CDE002        IFNE      'Y'
     C*****CLE035        ANDNE     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDNE     'Y'                                                      BUG10392
     C                   MOVE      'N'           DDRTSPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'
     C                   MOVEL     'LEA0186'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not blank, and not type SC, must equal file amount
     C     DDATYP        IFNE      'SC'
      *
      ** Get the file value in screen format
     C                   MOVE      *BLANKS       WRTSP            12
     C**********         If        CLE035 = 'N' or                                   CLE035 BUG10392
     C**********                   CLE035 = 'Y' and SVBRTE <> 0 or                   CLE035 BUG10392
     C**********                   CLE035 = 'Y' and SVBRTT <> 0                      CLE035 BUG10392
     C                   If        CLE036 = 'N' or                                          BUG10392
     C                             CLE036 = 'Y' and SVBRTE <> 0 or                          BUG10392
     C                             CLE036 = 'Y' and SVBRTT <> 0                             BUG10392
     C                   IF        CAM_RTSP <> 0 OR
     C                             (CAM_RTSP = 0 AND DDATYP = 'SC' AND
     C                              DDACTN <> 'A')
     C                   MOVE(P)   CAM_RTSP      ZFIELD
     C                   Z-ADD     7             ZADEC
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        WRTSP
     C                   ENDIF
     C                   Endif                                                                CLE035

     C                   IF        WRTSP <> DDRTSP
     C                   MOVE      'N'           DDRTSPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'
     C                   MOVEL     'LEA0187'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ELSE                                                                 CLE035
      *                                                                                       CLE035
      ** If spread rate is specified and amendment type is spread change,                     CLE035
      ** loan must have either a base rate code or a base rate                                CLE035
      *                                                                                       CLE035
     C*                  If        CLE035 = 'Y'                                               CLE035
     C                   IF        CLE036 = 'Y'                                             MD035672
     C                   IF        SVBRTT = 0 and SVBRTE = 0                         CLE035 MD035672
     C                             and SVBASR = 0                                           MD035672
     C                   MOVE      'N'           DDRTSPOK                            CLE035 MD035672
     C                   ADD       1             Idx                                 CLE035 MD035672
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'                        CLE035 MD035672
     C                   MOVEL     'LEA0547'     MsgIdArr(Idx)                       CLE035 MD035672
     C                   ENDIF                                                       CLE035 MD035672
     C                   ENDIF                                                       CLE035 MD035672
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDATYP        IFEQ      'SC'
     C**********         If        CLE035 = 'N' or                                   CLE035 BUG10392
     C**********                   CLE035 = 'Y' and SVBRTT <> 0 or                   CLE035 BUG10392
     C**********                   CLE035 = 'Y' and SVBRTE <> 0                      CLE035 BUG10392
     C                   If        CLE036 = 'N' or                                          BUG10392
     C                             (CLE036 = 'Y' and SVBRTT <> 0) or               BUG10392 MD035672
     C                             (CLE036 = 'Y' and SVBRTE <> 0) or               BUG10392 MD035672
     C                             (CLE036 = 'Y' and SVBASR <> 0)                           MD035672
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok          1
     C                   PARM      DDRTSP        ZFIELD           16
     C                   PARM      7             ZADEC             1 0
     C                   PARM      4             ZADIG             2 0
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDRTSPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'
     C                   MOVEL     'LEA0188'     MsgIdArr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WSPRT            11 7
     C                   ENDIF
     C                   Endif                                                                CLE035
      *
     C                   ENDIF
      *
     C     EXVRTSP       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE035
      * SRVFXRT - Validate Fixed Rate                                 *                       CLE035
      *****************************************************************                       CLE035
     C     SRVFXRT       BEGSR                                                                CLE035
      *                                                                                       CLE035
      ** Field must not be blank for type 'SC' if:                                            CLE035
      **    Analytical Accounting is not installed or the loan isn't                          CLE035
      **    directly funded and Revenue Analysis isn't on                                     CLE035
      *                                                                                       CLE035
     C     DDFXRT        Ifeq      *BLANK                                                     CLE035
      *                                                                                       CLE035
     C     DDATYP        Ifeq      'SC'                                                       CLE035
      *                                                                                       CLE035
     C     BGN0ST        Ifne      'Y'                                                        CLE035
     C     SVFPRC        Oreq      *BLANKS                                                    CLE035
      *                                                                                       CLE035
     C     CDE002        Ifne      'Y'                                                        CLE035
     C*****CLE035        Andne     'Y'                                               CLE035 BUG10392
     C     CLE036        Andne     'Y'                                                      BUG10392
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFXRT'                                 CLE035
     C                   MOVEL     'LEA0548'     MsgIdArr(Idx)                                CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   Else                                                                 CLE035
      *                                                                                       CLE035
      ** If not blank, and not type SC, must equal file amount                                CLE035
      *                                                                                       CLE035
     C     DDATYP        Ifne      'SC'                                                       CLE035
      *                                                                                       CLE035
      ** Get the file value in screen format                                                  CLE035
      *                                                                                       CLE035
     C                   MOVE      *BLANKS       WRTSP                                        CLE035
      *                                                                                       CLE035
      ** Base rate and base rate code are both zeroes                                         CLE035
      *                                                                                       CLE035
     C                   If        SVBRTT = 0 and  SVBRTE = 0                                 CLE035
     C                   If        SVRTSP <> 0 OR                                             CLE035
     C                             (SVRTSP = 0 AND DDATYP = 'SC' AND                          CLE035
     C                              DDACTN <> 'A')                                            CLE035
     C                   MOVE(P)   CAM_RTSP      ZFIELD                                       CLE035
     C                   Z-ADD     7             ZADEC                                        CLE035
      *                                                                                       CLE035
     C                   CALLB     'ZEDIT'                                                    CLE035
     C                   PARM                    ZFIELD                                       CLE035
     C                   PARM                    ZADEC                                        CLE035
     C                   MOVE      ZFIELD        WRTSP                                        CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   If        WRTSP <> DDRTSP                                            CLE035
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFXRT'                                 CLE035
     C                   MOVEL     'LEA0549'     MsgIdArr(Idx)                                CLE035
     C                   Endif                                                                CLE035
     C                   Else                                                                 CLE035
      *                                                                                       CLE035
      ** If fixed rate is specified and amendment type is spread change,                      CLE035
      ** loan must not have a base rate code or a base rate                                   CLE035
      *                                                                                       CLE035
     C**********         If        CLE035 = 'Y'                                      CLE035 BUG10392
     C                   If        CLE036 = 'Y'                                             BUG10392
     C                   If        SVBRTT <>0  or SVBRTE <> 0                                 CLE035
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFXRT'                                 CLE035
     C                   MOVEL     'LEA0550'     MsgIdArr(Idx)                                CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
     C                   EndiF                                                                CLE035
      *                                                                                       CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C     DDATYP        Ifeq      'SC'                                                       CLE035
     C**********         If        CLE035 = 'N'  or                                  CLE035 BUG10392
     C**********                   CLE035 = 'Y' and SVBRTT = 0 and SVBRTE = 0        CLE035 BUG10392
     C                   If        CLE036 = 'N'  or                                         BUG10392
     C                             CLE036 = 'Y' and SVBRTT = 0 and SVBRTE = 0               BUG10392
     C                   CALLB     'ZALIGN'                                                   CLE035
     C                   PARM      *BLANK        ZALIGNok                                     CLE035
     C                   PARM      DDFXRT        ZFIELD                                       CLE035
     C                   PARM      7             ZADEC                                        CLE035
     C                   PARM      4             ZADIG                                        CLE035
      *                                                                                       CLE035
     C     ZALIGNok      Ifeq      'N'                                                        CLE035
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFXRT'                                 CLE035
     C                   MOVEL     'LEA0551'     MsgIdArr(Idx)                                CLE035
     C                   Else                                                                 CLE035
     C                   MOVE      ZFIELD        WSPRT                                        CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   Endif                                                                CLE035
     C     EXVFXRT       ENDSR                                                                CLE035
      *****************************************************************                       CLE035
      /EJECT                                                                                  CLE035
      *****************************************************************
      * SRVAMNT - Validate loan amendment amount                      *
      *****************************************************************
     C     SRVAMNT       BEGSR
      *
      * Only principal increases should have an amount
     C     DDATYP        IFNE      'PI'
     C     DDAMNT        IFNE      *BLANK
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNT'
     C                   MOVEL     'LEA0191'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   GOTO      EXVAMNT
     C                   ENDIF
      *
     C                   Z-ADD     0             WLAMT            13 0
      *
      ** Currency details retrieved in SRVINIT...
     C     13            SUB       CDPL          ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok          1
     C                   PARM      DDAMNT        ZFIELD           16
     C                   PARM      CDPL          ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        WLAMT
     C                   ELSE
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNT'
     C                   MOVEL     'LEA0192'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     WLAMT         IFEQ      0
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNT'
     C                   MOVEL     'LEA0190'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** Check amount against the current principal amount of SVOLNO
      ** Only if amendment is against a participation sold
     C     SVPTYP        IFNE      64
     C     SVPTYP        ANDNE     65
     C     SVPTYP        ANDNE     68
     C     SVPTYP        ANDNE     71
     C*****DDACTN        ANDNE     'X'                                                        244483
     C*****DDACTN        ANDNE     'Q'                                                 CLE030 244483
     C*****SVOLNO        ANDNE     *ZERO                                                      CSD027
     C     SVOLNO        ANDNE     *BLANKS                                                    CSD027
     C*****SVOLNO        ANDNE     '000000'                                          BUG11584 CLE148
     C                   MOVE      SVOLNO        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEA1518'     MsgIdArr(Idx)
     C**********         MOVEL(P)  SVOLNO        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SVOLNO))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(SVOLNO)                   MD000091
     C                   ENDIF
      *
     C                   Z-ADD     CPAM          WCPAM            13 0
      *
      ** Accumulate total amount sold for the original loan.
     C                   EXSR      SRTAMT
      *
     C     LNKS          IFEQ      'N'                                                        245074
      *                                                                                       245074
     C     WTAMT         IFGT      WCPAM
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1040'
     C                   ENDIF
      *
     C                   ENDIF                                                                245074
     C                   ENDIF
      *
      ** Check amount against facility file for over facility position
     C     DDACTN        IFNE      'X'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C     CLE030        OREQ      'Y'                                                        CLE030
      *
      ** Use Facility CCY to pick facility decimal positions
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      FA_FCCY       @Curr             3
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEA1519'     MsgIdArr(Idx)
     C**********         MOVEL(P)  FA_FCCY       MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(FA_FCCY))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(FA_FCCY)                  MD000091
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        CDPF              1 0
      *
      ** Save facility currency details.
     C     CLE023        IFEQ      'Y'
     C                   MOVE      FA_FCCY       ZCCYO
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   MOVE      A6MDIN        ZMDI2
     C                   Z-ADD     A6NBDP        ZCDPO
     C                   ENDIF
      *
      * Load arrays
     C                   Eval      FB_RUN0 =  FA_RUN0
     C                   Eval      FB_RUN1 =  FA_RUN1
     C                   Eval      FB_RUN2 =  FA_RUN2
     C                   Eval      FB_RUN3 =  FA_RUN3
     C                   Eval      FB_RUN4 =  FA_RUN4
     C                   Eval      FB_RUN5 =  FA_RUN5
     C                   Eval      FB_RUN6 =  FA_RUN6
     C                   Eval      FB_RUN7 =  FA_RUN7
     C                   Eval      FB_RUN8 =  FA_RUN8
     C                   Eval      FB_RUN9 =  FA_RUN9
      *
     C                   Eval      FB_OAM1 =  FA_OAM1
     C                   Eval      FB_OAM2 =  FA_OAM2
     C                   Eval      FB_OAM3 =  FA_OAM3
     C                   Eval      FB_OAM4 =  FA_OAM4
     C                   Eval      FB_OAM5 =  FA_OAM5
     C                   Eval      FB_OAM6 =  FA_OAM6
     C                   Eval      FB_OAM7 =  FA_OAM7
     C                   Eval      FB_OAM8 =  FA_OAM8
     C                   Eval      FB_OAM9 =  FA_OAM9
     C                   Eval      FB_OA10 =  FA_OA10
                                                                                            AR656363
     C                   IF        CLE134 = 'Y'                                             AR656363
     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
     C                   EXSR      SrPDCLPI                                                 AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   EXSR      FCLTSR
      *
     C                   EVAL(H)   FA_FAMT = FA_FAMT * (FA_OVPC + 100) / 100
      *
      ** Check if there are facility amendments
     C                   EXSR      FCLTAM
      *
      ** Send warning message if loan amount causes facility amount
      ** to be exceeded
     C                   DO        10            L                 2 0
      *
     C     CLE030        IFNE      'Y'                                                        CLE030
     C     FA_FAMT       IFLT      WOAM(L)
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1029'
     C                   LEAVE
     C                   ENDIF
      *                                                                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
     C     FA_FAMT       IFLT      WOAM(L)                                                    CLE030
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C*****WVFACMT       ANDNE     WOAM(L)                                            CLE030 BUG4351
     C**********         MOVE      WOAM(L)       WVFACMT                              CLE030 BUG4351
     C                   MOVE      'N'           DDAMNTOK                                     CLE030
     C                   ADD       1             WIdx                                         CLE030
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNT'                                CLE030
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1029'                               CLE030
     C                   IF        DDACTN <> 'Q'                                              CLE030
     C                   MOVE      'Q'           WLASTS                                       CLE030
     C                   ENDIF                                                                CLE030
     C                   LEAVE                                                                CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *
     C                   ENDDO
      *
      ** If facility is a tranche, check if loan amount exceeds credit
      ** agreement facility amount
     C                   IF        FA_TRCA = 'TR'

      * Retrieve credit agreement details
     C                   EVAL      WFCNM = FA_CANM
     C                   EVAL      WFACT = FA_CAFT
     C                   EVAL      WFNUM = FA_CAFN
     C                   EVAL      WFRTP = 'A'
     C     KFCLT         CHAIN     FCLTY

     C                   IF        %FOUND
     C                   EVAL      WFRTP = 'B'
     C     KFCLT         CHAIN     FCLTY
      *
      * Load arrays
     C                   Eval      FB_RUN0 =  CAF_RUN0
     C                   Eval      FB_RUN1 =  CAF_RUN1
     C                   Eval      FB_RUN2 =  CAF_RUN2
     C                   Eval      FB_RUN3 =  CAF_RUN3
     C                   Eval      FB_RUN4 =  CAF_RUN4
     C                   Eval      FB_RUN5 =  CAF_RUN5
     C                   Eval      FB_RUN6 =  CAF_RUN6
     C                   Eval      FB_RUN7 =  CAF_RUN7
     C                   Eval      FB_RUN8 =  CAF_RUN8
     C                   Eval      FB_RUN9 =  CAF_RUN9
      *
     C                   Eval      FB_OAM1 =  CAF_OAM1
     C                   Eval      FB_OAM2 =  CAF_OAM2
     C                   Eval      FB_OAM3 =  CAF_OAM3
     C                   Eval      FB_OAM4 =  CAF_OAM4
     C                   Eval      FB_OAM5 =  CAF_OAM5
     C                   Eval      FB_OAM6 =  CAF_OAM6
     C                   Eval      FB_OAM7 =  CAF_OAM7
     C                   Eval      FB_OAM8 =  CAF_OAM8
     C                   Eval      FB_OAM9 =  CAF_OAM9
     C                   Eval      FB_OA10 =  CAF_OA10
     C                   IF        CLE134 = 'Y'                                             AR656363
     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
     C                   EXSR      SrPDCLPI                                                 AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   EXSR      CAFCYSR
     C                   EVAL(H)   CAF_FAMT = CAF_FAMT * (CAF_OVPC + 100)/ 100
      *
      ** Check if there are facility amendments
     C                   EXSR      CAFCYAM
      *
      ** Send warning message if loan amount causes credit agreement
      ** facility amount to be exceeded
     C                   DO        10            L                 2 0
      *
     C     CLE030        IFNE      'Y'                                                        CLE030
     C     CAF_FAMT      IFLT      WOAM(L)
     C                   MOVE      'N'           DDAMNTOK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEL0520'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
     C     CAF_FAMT      IFLT      WOAM(L)                                                    CLE030
     C*****WVCAAMT       ANDNE     WOAM(L)                                            CLE030 BUG4351
     C**********         MOVE      WOAM(L)       WVCAAMT                              CLE030 BUG4351
     C                   MOVE      'N'           DDAMNTOK                                     CLE030
     C                   ADD       1             WIdx                                         CLE030
     C                   EVAL      WFldNamArr(WIdx) = 'DDAMNT'                                CLE030
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEL0520'                               CLE030
     C                   IF        DDACTN <> 'Q'                                              CLE030
     C                   MOVE      'Q'           WLASTS                                       CLE030
     C                   ENDIF                                                                CLE030
     C                   LEAVE                                                                CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *
     C                   ENDDO

      * If credit agreement not found, error
     C                   ELSE
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEL0134'     MsgIdArr(Idx)
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
     C     EXVAMNT       ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      * SRPDCL - Past Due Call Loan warnings                          *                       CLE134
      *****************************************************************                       CLE134
     C     SRPDCL        BEGSR                                                                CLE134
                                                                                              CLE134
     C     SVAUTO        IFEQ      'C'                                                        CLE134
                                                                                              CLE134
      ** Proceed only if Amendment Type is BC/PI/SC                                           CLE134
                                                                                              CLE134
     C     DDATYP        IFEQ      'BC'                                                       CLE134
     C     DDATYP        OREQ      'PI'                                                       CLE134
     C     DDATYP        OREQ      'SC'                                                       CLE134
                                                                                              CLE134
      ** Warning only if we have existing PDCLs on file                                       CLE134
                                                                                              CLE134
     C                   MOVE      DDLOAN        WKLN2                                        CLE134
     C     KLOAN         SETLL     LEPDUED0                                                   CLE134
     C     KLOAN         READE     LEPDUED0                             9999                  CLE134
     C                   IF        *IN99 = *ON                                                CLE134
     C     KLOAN         SETLL     LEPDUFD0                                                   CLE134
     C     KLOAN         READE     LEPDUFD0                             9999                  CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        *IN99 = *OFF                                               CLE134
     C                   MOVE      'N'           DDLOANOK                                     CLE134
     C                   ADD       1             WIdx                                         CLE134
     C                   EVAL      WFldNamArr(WIdx) = 'DDLOAN'                                CLE134
     C                   EVAL      WMsgIDArr(WIdx)  = '5045674'                               CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                AR656363
      *****************************************************************                     AR656363
      * SRPDCLPI Check if loan has FAMU N/Y                           *                     AR656363
      *****************************************************************                     AR656363
     C     SRPDCLPI      BEGSR                                                              AR656363
                                                                                            AR656363
      ** Proceed only if Amendment Type is PI and for Interest(Y)                           AR656363
      ** or Fee(Z)                                                                          AR656363
                                                                                            AR656363
     C     DDATYP        IFEQ      'PI'                                                     AR656363
     C     SVAUTO        ANDEQ     'C'                                                      AR656363
     C                   IF        %SUBST(DDLTYP:1:1) =  'Y'  AND                           AR656363
     C                             SVFAMU = 'N' OR                                          AR656363
     C                             %SUBST(DDLTYP:1:1) =  'Z'  AND                           AR656363
     C                             SVFAMU = 'N'                                             AR656363
     C                   EVAL      WUpdExpo='N'                                             AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   ENDSR                                                              AR656363
      *****************************************************************                     AR656363
      /EJECT
      *****************************************************************
      * CAFCYSR - Evaluate facility exposure                          *
      *****************************************************************
     C     CAFCYSR       BEGSR
      *
      ** Use CA Facility CCY to pick facility decimal positions
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      CAF_FCCY      @Curr             3
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEA1519'     MsgIdArr(Idx)
     C**********         MOVEL(P)  CAF_FCCY      MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(CAF_FCCY))                             MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(CAF_FCCY)                 MD000091
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        CAPF              1 0
      *
      ** Convert amounts in CA facility currency equivalent
     C     CAPF          SUB       CDPL          CX                1 0
     C     CX            ADD       4             CX
     C     FA_CMDI       COMP      'D'                                    99
     C   99FA_CAXR       DIV(H)    POWR(CX)      OFCXRT
     C   991             DIV       OFCXRT        OFCXRT
     C  N99FA_CAXR       MULT(H)   POWR(CX)      OFCXRT           15 9

     C     FCBAL         MULT(H)   OFCXRT        CABAL            13 0
     C                   Z-ADD     VDAYNO        WDAYNO            5 0
      *
     C     DDACTN        IFEQ      'I'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '0'           *IN93
     C                   ELSE
     C                   MOVE      '1'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '1'           *IN93
     C                   ELSE
     C                   MOVE      '0'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SVLPFI        IFEQ      *BLANK
     C     WSOLD         ANDEQ     'Y'
     C     SVRCSI        ANDNE     'Y'
     C     CLE023        ANDEQ     'N'
     C     WDAYNO        ANDNE     0
      *
     C     SVLPFI        OREQ      *BLANK
     C     WSOLD         ANDEQ     *BLANK
     C     WDAYNO        ANDNE     0
     C                   EXSR      CAFCLTY
     C                   ENDIF

     C     CAF_RVCR      IFEQ      'T'
     C                   MOVE      FA_RVCR       WRVCR             1
     C                   ELSE
     C                   MOVE      CAF_RVCR      WRVCR
     C                   ENDIF
      *
      ** Also update availability of a prime facility without recourse
     C     WRVCR         IFEQ      'Y'
     C                   Z-ADD     SVMDAT        WDAYNO
      *
     C     DDACTN        IFEQ      'I'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '1'           *IN93
     C                   ELSE
     C                   MOVE      '0'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '0'           *IN93
     C                   ELSE
     C                   MOVE      '1'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WDAYNO        IFNE      0
      *
     C     SVLPFI        IFEQ      *BLANK
     C     WSOLD         ANDEQ     'Y'
     C     SVRCSI        ANDNE     'Y'
      *
     C     SVLPFI        OREQ      *BLANK
     C     WSOLD         ANDEQ     *BLANK
     C                   EXSR      CAFCLTY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CAFCLTY - Update Exposure Array                               *
      *****************************************************************
     C     CAFCLTY       BEGSR

     C                   Z-ADD     1             Z                 2 0
     C     WDAYNO        LOOKUP    FB_RUN(Z)                          99  99
     C  N99              GOTO      ENDCAFCT
      *
     C     LOOPZ2        TAG
      *
     C     Z             COMP      11                                   99
      *
      * Don't update beyond the expiry date
     C     *IN99         IFEQ      *ON
     C     FB_RUN(Z)     ANDGE     CAF_DTEX
     C                   GOTO      ENDCAFCT
     C                   ENDIF
      *
     C  N99              GOTO      ENDCAFCT
      *
     C   93FB_OAM(Z)     SUB       CABAL         FB_OAM(Z)
     C  N93FB_OAM(Z)     ADD       CABAL         FB_OAM(Z)
      *
     C     Z             ADD       1             Z
     C                   GOTO      LOOPZ2
      *
     C     ENDCAFCT      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CAFCYAM - Subroutine to verify facility amendments            *
      *****************************************************************
     C     CAFCYAM       BEGSR
      *
      ** Move drawn facility amount array to work array WOAM
     C                   MOVEA     FB_OAM        WOAM
      *
      ** Read live facility amendments file
     C     KEYCAA        SETLL     LEFCAMPF
     C     KEYCAA        READE     LEFCAMPF                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
      ** Verify amendment against the 10-day facility amount
      ** projection. Deduct (facility increase) or add (facility
      ** decrease) amendment amount to facility drawn amount (ex. WOAM)
      ** starting from the nearest projected date (ex. FB_RUN1)
      ** as compared to amendment value date.
     C                   Z-ADD     1             Z                 2 0
     C     FAM_VLDT      LOOKUP    FB_RUN(Z)                          99  99
      *
     C     *IN99         DOWEQ     *ON
     C     Z             ANDLT     11
      *
     C                   SELECT
     C     FAM_FATP      WHENEQ    'FI'
     C                   SUB       FAM_AAMT      WOAM(Z)
      *
     C     FAM_FATP      WHENEQ    'FD'
     C                   ADD       FAM_AAMT      WOAM(Z)
     C                   ENDSL
      *
     C                   ADD       1             Z
     C                   ENDDO
      *
     C     KEYCAA        READE     LEFCAMPF                               99
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTAMT - Accumulate total amount sold for the original loan   *
      *****************************************************************
     C     SRTAMT        BEGSR
      *
     C     WLAMT         ADD       PSAM          WTAMT            13 0
      *
      ** Determine all part sold for the original loan
      *
     C     SVOLNO        SETLL     PSOLDF
     C     SVOLNO        READE     PSOLDF                                 99
      *
     C     *IN99         DOWEQ     '0'
      *
      ** Accumulate all principal increase due.
     C     SLD_LNRF      SETLL     LELOAMD4
     C     SLD_LNRF      READE     LELOAMD4                               99
      *
     C     *IN99         DOWEQ     '0'
      *
     C     VDAT          IFLE      VDAYNO
     C                   ADD       PRAM          WTAMT
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C     SLD_LNRF      READE     LELOAMD4                               99
     C                   ENDDO
      *
     C     SVOLNO        READE     PSOLDF                                 99
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FCLTSR - Evaluate facility exposure                           *
      *****************************************************************
     C     FCLTSR        BEGSR
      *
      ** Convert amounts in facility currency equivalent
     C     CDPF          SUB       CDPL          CX                1 0
     C     CX            ADD       4             CX
     C     SVFMDI        COMP      'D'                                    99
     C   99SVFCXR        DIV(H)    POWR(CX)      OFCXRT
     C   991             DIV       OFCXRT        OFCXRT
     C  N99SVFCXR        MULT(H)   POWR(CX)      OFCXRT           15 9
      *
      ** If CLE023 is on, get cross rate of currencies spot.
     C     CLE023        IFEQ      'Y'

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1

     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'I'
     C     WLAMT         MULT(H)   OFCXRT        ILAAMF           13 0
      *
      ** If CLE023 is on convert amounts using spot rate.
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     WLAMT         ZAMTCI
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
      *
     C                   Z-ADD     ZAMTCO        WXAAMF           13 0
      *
      ** If rollover date is less than or equal to the value date of
      ** the amendment and there is a rollover of facility exchange
      ** rate, use the new facility exchange rate defined.
      *
     C     SVRLDT        IFLT      WRNDAY
     C     SVRLDT        ANDNE     0
     C     SVNFCE        ANDNE     0
     C     SVNCCY        ANDEQ     *BLANKS
     C     SVNFMD        IFEQ      'D'
     C     SVNFCE        DIV(H)    POWR(CX)      WNFCE            15 9
     C     1             DIV       WNFCE         WNFCE
     C                   ELSE
     C     SVNFCE        MULT(H)   POWR(CX)      WNFCE
     C                   ENDIF
     C     WLAMT         MULT(H)   WNFCE         ILAAMF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'
     C     CAM_PRAM      MULT(H)   OFCXRT        ILAAMF
      *
      ** If CLE023 is on convert amount using spot rate.
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     PRAM          ZAMTCI
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
     C                   Z-ADD     ZAMTCO        WXAAMF
      *
      ** If rollover date is less than or equal to the value date of
      ** the amendment and there is a rollover of facility exchange
      ** rate, use the new facility exchange rate defined.
      *
     C     SVRLDT        IFLT      WRNDAY
     C     SVRLDT        ANDNE     0
     C     SVNFCE        ANDNE     0
     C     SVNCCY        ANDEQ     *BLANKS
     C     SVNFMD        IFEQ      'D'
     C     SVNFCE        DIV(H)    POWR(CX)      WNFCE
     C                   ELSE
     C     SVNFCE        MULT(H)   POWR(CX)      WNFCE
     C                   ENDIF
     C     PRAM          MULT(H)   WNFCE         ILAAMF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Set up fields for value date updating
      ** Also update availability of a prime facility without recourse
     C                   Z-ADD     VDAYNO        DAYNO             5 0
     C                   IF        CLE134 = 'Y'   AND                                       AR656363
     C                             WUpdExpo= 'Y'   OR                                       AR656363
     C                             CLE134 = 'N'                                             AR656363
     C                   Z-ADD     ILAAMF        FCBAL            13 0
     C                   ELSE                                                               AR656363
     C                   Z-ADD     0             FCBAL                                      AR656363
     C                   ENDIF                                                              AR656363
      *
     C     DDACTN        IFEQ      'I'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '0'           *IN93
     C                   ELSE
     C                   MOVE      '1'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '1'           *IN93
     C                   ELSE
     C                   MOVE      '0'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SVLPFI        IFEQ      *BLANK
     C     WSOLD         ANDEQ     'Y'
     C     SVRCSI        ANDNE     'Y'
     C     CLE023        ANDEQ     'N'
     C     DAYNO         ANDNE     0
      *
     C     SVLPFI        OREQ      *BLANK
     C     WSOLD         ANDEQ     *BLANK
     C     DAYNO         ANDNE     0
     C                   EXSR      QFCLTY
     C                   ENDIF
      *
      ** Also update availability of a prime facility without recourse
     C     FA_RVCR       IFEQ      'Y'
     C                   Z-ADD     SVMDAT        DAYNO
      *
     C     DDACTN        IFEQ      'I'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '1'           *IN93
     C                   ELSE
     C                   MOVE      '0'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'
      *
     C     WSOLD         IFEQ      *BLANK
     C     SVLPFI        ANDEQ     *BLANK
     C                   MOVE      '0'           *IN93
     C                   ELSE
     C                   MOVE      '1'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DAYNO         IFNE      0
      *
     C     SVLPFI        IFEQ      *BLANK
     C     WSOLD         ANDEQ     'Y'
     C     SVRCSI        ANDNE     'Y'
      *
     C     SVLPFI        OREQ      *BLANK
     C     WSOLD         ANDEQ     *BLANK
     C                   EXSR      QFCLTY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * QFCLTY - Update Exposure Array                                *
      *****************************************************************
     C     QFCLTY        BEGSR
      *

     C                   Z-ADD     1             Z                 2 0
     C     DAYNO         LOOKUP    FB_RUN(Z)                          99  99
     C  N99              GOTO      ENDFCT
      *
     C     LOOPZ1        TAG
      *
     C     Z             COMP      11                                   99
      *
      * Don't update beyond the expiry date
     C     *IN99         IFEQ      *ON
     C     FB_RUN(Z)     ANDGE     FA_DTEX
     C                   GOTO      ENDFCT
     C                   ENDIF
      *
     C  N99              GOTO      ENDFCT
      *
     C   93FB_OAM(Z)     SUB       FCBAL         FB_OAM(Z)
     C  N93FB_OAM(Z)     ADD       FCBAL         FB_OAM(Z)
      *
     C     Z             ADD       1             Z
     C                   GOTO      LOOPZ1
      *
     C     ENDFCT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FCLTAM - Subroutine to verify facility amendments             *
      *****************************************************************
     C     FCLTAM        BEGSR
      *
      ** Move drawn facility amount array to work array WOAM
     C                   MOVEA     FB_OAM        WOAM
      *
      ** Read live facility amendments file
     C     KEYFLA        SETLL     LEFCAMPF
     C     KEYFLA        READE     LEFCAMPF                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
      ** Verify amendment against the 10-day facility amount
      ** projection. Deduct (facility increase) or add (facility
      ** decrease) amendment amount to facility drawn amount (ex. WOAM)
      ** starting from the nearest projected date (ex. FB_RUN1)
      ** as compared to amendment value date.
     C                   Z-ADD     1             Z                 2 0
     C     FAM_VLDT      LOOKUP    FB_RUN(Z)                          99  99
      *
     C     *IN99         DOWEQ     *ON
     C     Z             ANDLT     11
      *
     C                   SELECT
     C     FAM_FATP      WHENEQ    'FI'
     C                   SUB       FAM_AAMT      WOAM(Z)
      *
     C     FAM_FATP      WHENEQ    'FD'
     C                   ADD       FAM_AAMT      WOAM(Z)
     C                   ENDSL
      *
     C                   ADD       1             Z
     C                   ENDDO
      *
     C     KEYFLA        READE     LEFCAMPF                               99
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVSTPA - Validate Start / Stop Accruals                      *
      *****************************************************************
     C     SRVSTPA       BEGSR
      *
     C     DDSTPA        IFEQ      *BLANK
      *
     C     DDATYP        IFEQ      'SA'
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA0195'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDATYP        IFNE      'SA'
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA0196'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     DDSTPA        IFNE      'Y'
     C     DDSTPA        ANDNE     'N'
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA1007'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check Stop accrual BIT on file
     C     DDSTPA        IFNE      *BLANK
      *
      ** Get previous and next Stop Accrual amendments.
      ** If a previous Stop Accrual amendment exists, then the value of
      ** the flag cannot be the same as that entered;
      ** otherwise, check against the original bit setting as below.
      ** In addition, the entered Stop Accrual cannot be equal to the
      ** flag on the next Stop Accrual amendment, if this exists.
     C                   MOVE      *BLANKS       P#STAI            1
     C                   MOVE      *BLANKS       N#STAI            1
      *
     C                   MOVE      DDLOAN        WKLNR
     C                   MOVE      VDAYNO        WKVDT
      *
      ** Get previous stop accrual amendment
      *
     C     K#LM11        SETLL     LOAMSDKF
     C     WKLNR         READPE    LOAMSDKF                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     AM_RECI       IFEQ      'D'
     C     AM_AMTP       ANDEQ     'SA'
     C                   MOVE      AM_STAI       P#STAI
     C                   LEAVE
     C                   ENDIF
      *
     C     WKLNR         READPE    LOAMSDKF                               99
     C                   ENDDO
      *
      ** Get next stop accrual amendment.
     C     K#LM11        SETGT     LOAMSDKF
     C     WKLNR         READE     LOAMSDKF                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     AM_RECI       IFEQ      'D'
     C     AM_AMTP       ANDEQ     'SA'
     C                   MOVE      AM_STAI       N#STAI
     C                   LEAVE
     C                   ENDIF
      *
     C     WKLNR         READE     LOAMSDKF                               99
     C                   ENDDO
      *
      ** Check previous is not the same as entered or
      ** against the original bit setting
     C     P#STAI        IFNE      *BLANKS
     C     P#STAI        COMP      'Y'                                    99
     C                   ELSE
     C                   TESTB     '3'           SVLONI                   99
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C     DDSTPA        ANDEQ     'Y'
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA0197'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     *IN99         IFEQ      '0'
     C     DDSTPA        ANDNE     'Y'
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA1008'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** Check next is not the same as entered
     C     N#STAI        IFNE      *BLANKS
     C     N#STAI        ANDEQ     DDSTPA
      *
     C     DDSTPA        IFEQ      'Y'
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA0197'     MsgIdArr(Idx)
     C                   ELSE
     C                   MOVE      'N'           DDSTPAOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTPA'
     C                   MOVEL     'LEA1008'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXVSTPA       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLSPR  - Loan subtype and maturity date if amendment 'LS'    *
      *****************************************************************
     C     SRLSPR        BEGSR
      *
      ** Loan subtype amendment processing
     C     DDATYP        IFNE      'LS'
     C                   GOTO      EXLSPR
     C                   ENDIF
     C                   Z-Add     Idx           W#Idx             3 0
      *
      ** Get previous and next subtype amendments.
      ** If a previous subtype exists, check that this is not equal to
      ** the entered subtype; otherwise, the entered subtype is checked
      ** against the original subtype.
      ** In addition, the entered subtype cannot be equal to the next
      ** subtype, if this exists.
     C                   MOVE      *BLANKS       P#SUTP            2
     C                   MOVE      *BLANKS       P#CLAS            4                          CLE042
     C                   MOVE      *BLANKS       N#SUTP            2
     C                   MOVE      *BLANKS       N#CLAS            4                          CLE042
      *
     C                   MOVE      DDLOAN        WKLNR
     C                   MOVE      VDAYNO        WKVDT
      *                                                                                     BUG13318
      ** Retrieve original subtype details so that WSVACAI is still                         BUG13318
      ** populated when there are no previous loan amendments                               BUG13318
      *                                                                                     BUG13318
     C                   CALL      'AOLOANR0'                                               BUG13318
     C                   PARM      '*BLANKS'     PRTCD                                      BUG13318
     C                   PARM      '*KEY'        POPTN                                      BUG13318
     C                   PARM      SVLTYP        ATCD                                       BUG13318
     C                   PARM      SVSUTP        AUCD                                       BUG13318
     C                   PARM      SVCLAS        AUCL                                       BUG13318
     C     SDLOAN        PARM      SDLOAN        DSFDY                                      BUG13318
     C                   IF        PRTCD = *BLANKS                                          BUG13318
     C                   EVAL      WSVACAI = AYACAI                                         BUG13318
     C                   ENDIF                                                              BUG13318
      *
      ** Get previous subtype amendment.
     C     K#LM11        SETLL     LOAMSDKF
     C     WKLNR         READPE    LOAMSDKF                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     AM_RECI       IFEQ      'D'
     C     AM_AMTP       ANDEQ     'LS'
     C                   MOVE      AM_SUTP       P#SUTP
     C                   MOVE      AM_CLAS       P#CLAS                                       CLE042
     C                   LEAVE
     C                   ENDIF
      *
     C     WKLNR         READPE    LOAMSDKF                               99
     C                   ENDDO
      *
      ** Get next subtype amendment.
     C     K#LM11        SETGT     LOAMSDKF
     C     WKLNR         READE     LOAMSDKF                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     AM_RECI       IFEQ      'D'
     C     AM_AMTP       ANDEQ     'LS'
     C                   MOVE      AM_SUTP       N#SUTP
     C                   MOVE      AM_CLAS       N#CLAS                                       CLE042
     C                   LEAVE
     C                   ENDIF
      *
     C     WKLNR         READE     LOAMSDKF                               99
     C                   ENDDO
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   EVAL      ATCD = AM_LTYP                                             CAS011
     C                   EVAL      AUCD = AM_SUTP                                             CAS011
     C                   EVAL      AUCL = AM_CLAS                                             CLE042
     C                   CALL      'AOLOANR0'                                                 CAS011
     C                   PARM      '*BLANKS'     PRTCD                                        CAS011
     C                   PARM      '*KEY'        POPTN                                        CAS011
     C                   PARM                    ATCD                                         CAS011
     C                   PARM                    AUCD                                         CAS011
     C                   PARM                    AUCL                                         CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        CAS011
     C                   IF        PRTCD = *BLANKS                                            CAS011
     C                   EVAL      WSVACAI = AYACAI                                           CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C**********         PARM      SVLTYP        ATCD              2                          CLE106
     C                   PARM      DDLTYP        ATCD              2                          CLE106
     C                   PARM      DDSTYP        AUCD              2
     C                   PARM      DDCLAS        AUCL              4                          CLE042
     C     SDLOAN        PARM                    DSFDY
      *
     C     @RtCd         IFEQ      *BLANKS
     C                   MOVE      AYLNPT        WWPTYP                                     BUG10707
      *
      ** Loan type returned from call to AOLOANR0 must be the
      ** same as the original loan type and the loan subtype must
      ** differ from the original loan subtype.
     C     SVLTYP        IFNE      AYLNTY
      *
     C     SVLTYP        OREQ      AYLNTY
     C     SVSUTP        ANDEQ     AYLNST
     C     SVCLAS        ANDEQ     AYLNCL                                                     CLE042
     C     P#SUTP        ANDEQ     *BLANKS
      *
     C     P#SUTP        OREQ      AYLNST
     C     P#CLAS        ANDEQ     AYLNCL                                                     CLE042
     C     P#SUTP        ANDNE     *BLANKS
      *
     C     N#SUTP        OREQ      AYLNST
     C     N#CLAS        ANDEQ     AYLNCL                                                     CLE042
     C     N#SUTP        ANDNE     *BLANKS
                                                                                              CLE106
      ** Loan Type Entered must be the same of the original loan                              CLE106
                                                                                              CLE106
     C     SVLTYP        IFNE      AYLNTY                                                     CLE106
     C                   MOVE      'N'           DDLTYPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDLTYP'                                 CLE106
     C                   MOVEL     'LEA1601'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   MOVE      'N'           DDSTYPOK
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C**********         MOVEL     'LEA0520'     MsgIdArr(Idx)                                CLE106
     C                   MOVEL     'LEA1603'     MsgIdArr(Idx)                                CLE106
     C                   ELSE
                                                                                              CAS011
      ** Only process EIR cost accounting if loan's value date is same                        CAS011
      ** as or after the non-linear amortisation cut-off date.                                CAS011
      ** Loan's value date saved in VDAT in SRVALI.                                           CAS011
                                                                                              CAS011
     C                   IF        (CAS009 = 'Y' AND WSVACAI <> AYACAI)                       CAS011
     C                             AND (VDAT >= FSNLAC)                                       CAS011
     C                   MOVE      'N'           DDSTYPOK                                     CAS011
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ADD       1             Idx                                          CAS011
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'                                 CAS011
     C                   MOVEL     'LEV1075'     MsgIdArr(Idx)                                CAS011
     C                   ELSE                                                                 CAS011
      *
      ** If Loan Processing Type is 61 and new Processing Type is 62
      ** validate Maturity Date
     C     SVPTYP        IFEQ      61
     C     AYLNPT        ANDEQ     62
      *
     C     SVPTYP        OREQ      68
     C     AYLNPT        ANDEQ     62
     C     CLE005        ANDEQ     'Y'
      *
     C     SVPTYP        OREQ      69
     C     AYLNPT        ANDEQ     62
     C     CLE005        ANDEQ     'Y'
      *
      ** New Maturity Date must not be blank
     C     DDMDAT        IFEQ      *BLANKS
     C     DDMDAT        OREQ      *ZEROS
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0521'     MsgIdArr(Idx)
     C                   ELSE
     C                   CALLB     'ZDATE1'
     C                   PARM      DDMDAT        ZDATEA
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        DateFmt
     C                   PARM                    ErrorFlag
      *
      ** New Maturity Date must be later than Run Date
      ** New Maturity Date must be later than or equal to Loan Value Date
     C     ZDAYNO        IFLT      WRNDAY
     C     ZDAYNO        ORLE      SVVDAT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0129'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** New Maturity Date must be later than Next Interest Date
     C     ZDAYNO        IFLE      SVNIDT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0111'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** If Maturity Settlement Type is entered and is 01, 07 or 08
      ** must not be a Loan Currency Holiday
     C     SVMDST        IFNE      *ZEROS
      *
     C     SVMDST        IFEQ      01
     C     SVMDST        OREQ      07
     C     SVMDST        OREQ      08
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     SVSCCY        ANDNE     *BLANK
     C                   MOVE      SVSCCY        ZCCY
     C                   ELSE
     C                   MOVE      DDCURR        ZCCY
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      DDCURR        ZCCY                                         CLE031
      *                                                                                       CLE031
     C     SVPTYP        IFEQ      66                                                         CLE031
     C     SVPTYP        OREQ      67                                                         CLE031
     C     SVPTYP        OREQ      69                                                         CLE031
     C     SVPTYP        OREQ      72                                                         CLE031
     C     SVSCCY        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      SVSCCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C                   ELSE                                                                 CLE031
     C     SVPSCY        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      SVPSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      ** If Maturity Settlement Type is entered and is not 01, 07 or 08
      ** must not be a Local Currency Holiday
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
      ** If date is a holiday display warning errors
     C     ZIND          IFEQ      'H'
      *
     C     ZCCY          IFEQ      DDCURR
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1027'
     C                   ELSE
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1028'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Maturity date of loan must not be before the value date of
      ** any loan amendments input against former call loan
      *
      ** Set up key for LOAMS to detect any Loan Amendments Value-Dated
      ** after the input maturity date of the loan
     C                   MOVEL     SVLNRF        WKLNR
     C                   MOVE      ZDAYNO        WKVDT
     C                   Z-ADD     0             WKLSN
      *
     C     KLAKEY        SETLL     LOAMSDKF
     C                   READ      LOAMSDKF                               99
      *
      ** If a live record is found on LOAMS with a loan number equal to
      ** the input loan number, then it is an error
     C     *IN99         DOWEQ     '0'
     C     AM_LNRF       ANDEQ     SVLNRF
      *
     C     AM_RECI       IFEQ      'D'
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0525'     MsgIdArr(Idx)
     C                   ELSE
     C                   READ      LOAMSDKF                               99
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If not changing a loan from call to term, is is vice versa?
     C                   ELSE
      *
      ** If Loan Processing Type is 62 and new Processing Type is 61
     C     SVPTYP        IFEQ      62
     C     AYLNPT        ANDEQ     61
      *
     C     SVPTYP        OREQ      62
     C     AYLNPT        ANDEQ     68
     C     CLE005        ANDEQ     'Y'
      *
     C     SVPTYP        OREQ      62
     C     AYLNPT        ANDEQ     69
     C     CLE005        ANDEQ     'Y'
      *
      ** New Maturity Date must be blank for change to call Loan
     C     DDMDAT        IFNE      '      '
     C     DDMDAT        ANDNE     '000000'
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0524'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not changing from processing type 61 to 62 or vice-versa,
      ** old and new processing types must be the same
     C     SVPTYP        IFEQ      AYLNPT
     C                   CALLB     'ZDATE1'
     C                   PARM      DDMDAT        ZDATEA
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        DateFmt
     C                   PARM                    ErrorFlag
      *
      ** If not changing processing type, and loan is a discount one,
      ** Maturity Date must not be changed
     C     SVPTYP        IFEQ      63
     C     SVPTYP        OREQ      65
     C     SVPTYP        OREQ      67
      *
     C     CLE005        OREQ      'Y'
     C     SVPTYP        ANDEQ     72
     C     WSPTYP        ANDEQ     67
      *
     C     ZDAYNO        IFNE      SVMDAT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0218'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If not changing processing type, and loan is a term
      ** participation sold, new Maturity Date must not be later than
      ** original loan's Maturity Date
     C     SVPTYP        IFEQ      66
      *
     C     SVPTYP        OREQ      69
     C     CLE005        ANDEQ     'Y'
      *
     C     CLE005        OREQ      'Y'
     C     SVPTYP        ANDEQ     72
     C     WSPTYP        ANDEQ     66
      *
     C     CLE005        OREQ      'Y'
     C     SVPTYP        ANDEQ     72
     C     WSPTYP        ANDEQ     69
      *
      ** Obtain Maturity Date of loan that this participation is
      ** linked to
     C                   MOVEL     SVOLNO        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEA1518'     MsgIdArr(Idx)
     C**********         MOVEL(P)  SVOLNO        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SVOLNO))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(SVOLNO)                   MD000091
     C                   ENDIF
      *
     C     ZDAYNO        IFGT      MDAT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0218'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If not changing processing type, input Maturity Date
      ** must be zero if loan is a call loan
     C     AYLNPT        IFEQ      61
      *
     C     AYLNPT        OREQ      68
     C     CLE005        ANDEQ     'Y'
      *
     C     AYLNPT        OREQ      69
     C     CLE005        ANDEQ     'Y'
      *
     C     AYLNPT        OREQ      72
     C     CLE005        ANDEQ     'Y'
      *
     C     DDMDAT        IFNE      *BLANKS
     C     DDMDAT        ANDNE     *ZEROS
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0524'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** New Maturity Date must not be earlier than the old one
     C     ZDAYNO        IFLT      SVMDAT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA1019'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** Maturity Date must be equal to or later than Run Date
     C     ZDAYNO        IFLT      WRNDAY
     C     SVMDAT        ANDGT     0
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0129'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Else PTYP change is invalid (i.e. not from 61 to 62 or
      ** vice-versa).
     C                   ELSE
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0523'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If new loan is not a call loan, ensure that new Maturity
      ** Date of loan does not exceed Expiry Date of Facility
     C     AYLNPT        IFNE      61
     C     CLE005        ANDNE     'Y'
      *
     C     AYLNPT        ORNE      61
     C     AYLNPT        ANDNE     68
     C     CLE005        ANDEQ     'Y'
      *
     C     ZDAYNO        IFGT      FA_DTEX
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   MOVEL     'LEA0234'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
      *
     C                   ENDIF
      *
      ** Else the amendment isn't valid
     C                   ELSE
                                                                                              CLE106
      ** Loan type/subtype is mandatory and must exist on the system                          CLE106
                                                                                              CLE106
     C                   If        CLE106 = 'Y'                                               CLE106
     C                   MOVE      'N'           DDLTYPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDLTYP'                                 CLE106
     C                   MOVEL     'LEA1602'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   MOVE      'N'           DDSTYPOK
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C                   MOVEL     'LEA0520'     MsgIdArr(Idx)
     C                   ENDIF

      ** If no errors, update LSMD
     C                   If        Idx = W#Idx
     C                   Z-ADD     ZDAYNO        WLSMD             5 0
     C                   ENDIF
      *
      ** CLE134 - if Loan auto-settle is 'C', check if                                        262461
      ** new loan type/subtype has PDCL details defined                                       262461
                                                                                              262461
     C                   IF        CLE134 = 'Y'                                               262461
     C                   IF        SVAUTO = 'C'                                               262461
     C                   IF        %SUBST(DDLTYP:1:1) <> 'X'  AND                             262461
     C                             %SUBST(DDLTYP:1:1) <> 'Y'  AND                             262461
     C                             %SUBST(DDLTYP:1:1) <> 'Z'                                  262461
                                                                                              262461
     C     AYPPLT        IFEQ      *BLANKS                                                    262461
     C     AYPPLS        OREQ      *BLANKS                                                    262461
     C     AYIPLT        OREQ      *BLANKS                                                    262461
     C     AYIPLS        OREQ      *BLANKS                                                    262461
     C                   MOVE      'N'           DDSTYPOK                                     262461
     C                   EVAL      Idx        += 1                                            262461
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'                                 262461
     C                   EVAL      MsgIdArr(Idx) =  '5045706'                                 262461
     C                   END                                                                  262461
     C                   END                                                                  262461
     C                   END                                                                  262461
     C                   ENDIF                                                                262461
                                                                                              262461
                                                                                              262461
     C     EXLSPR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVDFTP_ST - Validate Default Participation Loan Type/Subtype *
      *            (for loans and parts purchased when facility is    *                       CLE106
      *             syndicated)                                       *                       CLE106
      *****************************************************************
     C     SRVDFTP_ST    BEGSR
                                                                                              CLE106
      ** If syndication indicator is OFF, fields should be blank                              CLE106
                                                                                              CLE106
     C     FA_SYIN       IFNE      'Y'                                                        CLE106
                                                                                              CLE106
     C     DDDFTP        IFNE      *BLANK                                                     CLE106
     C     DDDFST        ORNE      *BLANK                                                     CLE106
     C     DDDFCL        ORNE      *BLANK                                                     CLE042
     C                   MOVE      'N'           DDDFTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'                                 CLE106
     C                   MOVEL     'LEA1604'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF                                                                CLE106
      *
      ** If syndication indicator is ON and type / subtype not blank
     C     FA_SYIN       IFEQ      'Y'
     C     DDDFTP        ANDNE     *BLANK
     C     FA_SYIN       OREQ      'Y'
     C     DDDFST        ANDNE     *BLANK
     C     FA_SYIN       OREQ      'Y'                                                        CLE042
     C     DDDFCL        ANDNE     *BLANK                                                     CLE042
      *
      ** Default Participation Loan Type
     C     DDDFTP        IFNE      *BLANK
     C                   MOVEL     DDDFTP        WTP1              1
      *
     C     WTP1          IFNE      'H'
     C     WTP1          ANDNE     'J'
     C     WTP1          ANDNE     'K'
     C                   MOVE      'N'           DDDFTPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'
     C                   MOVEL     'LEA1012'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Default Participation Loan Subtype
     C     DDDFST        IFNE      *BLANK
     C     DDDFTP        ANDEQ     *BLANK
     C                   MOVE      'N'           DDDFSTOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFST'
     C                   MOVEL     'LEA1013'     MsgIdArr(Idx)
     C                   ENDIF
     C     DDDFCL        IFNE      *BLANK                                                     CLE042
     C     DDDFTP        ANDEQ     *BLANK                                                     CLE042
     C                   MOVE      'N'           DDDFCLOK                                     CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   EVAL      FldNameArr(Idx) = 'DDDFCL'                                 CLE042
     C                   MOVEL     'LEA1200'     MsgIdArr(Idx)                                CLE042
     C                   ENDIF                                                                CLE042
      *
      ** Default participation loan type / subtype
                                                                                              CLE106
     C     DDDFTPOK      IFNE      'N'                                                        CLE106
                                                                                              CLE106
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDDFTP        ATCD              2
     C                   PARM      DDDFST        AUCD              2
     C                   PARM      DDDFCL        AUCL              4                          CLE042
     C*****SDLOAN        PARM                    DSSDY                                        CLE106
     C     SDLOAN        PARM                    DSFDY                                        CLE106
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVE      'N'           DDDFTPOK
     C                   MOVE      'N'           DDDFSTOK
     C                   MOVE      'N'           DDDFCLOK                                     CLE042
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'
     C**********         MOVEL     'LEA1014'     MsgIdArr(Idx)                                CLE106
     C                   MOVEL     'LEA1609'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF
                                                                                              CLE106
     C     @RtCd         IFEQ      *BLANKS                                                    CLE106
                                                                                              CLE106
      ** Default Participation loan type/subtype does not                                     CLE106
      **    not have processing type for parts sold                                           CLE106
                                                                                              CLE106
     C     AYLNPT        IFNE      66                                                         CLE106
     C     AYLNPT        ANDNE     67                                                         CLE106
     C     AYLNPT        ANDNE     69                                                         CLE106
     C     AYLNPT        ANDNE     72                                                         CLE106
     C     SVPTYP        OREQ      69                                                         CLE106
     C     CLE005        ANDEQ     'N'                                                        CLE106
     C     SVPTYP        OREQ      72                                                         CLE106
     C     CLE005        ANDEQ     'N'                                                        CLE106
                                                                                              CLE106
     C                   MOVE      'N'           DDDFTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'                                 CLE106
     C                   MOVEL     'LEA1605'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Default Loan Type/Subtype must be in the same category as the loan's                 CLE106
                                                                                              CLE106
     C                   IF        SVPTYP = 61 And AYLNPT <> 69 Or                            CLE106
     C                             SVPTYP = 62 And AYLNPT <> 66 Or                            CLE106
     C                             SVPTYP = 63 And AYLNPT <> 67 Or                            CLE106
     C                             SVPTYP = 70 And AYLNPT <> 72                               CLE106
     C                   EVAL      DDDFTPOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'                                 CLE106
     C                   MOVEL     'LEA1611'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF                                                                CLE106
      *
     C                   ENDIF
      *
     C     EXVDFTP_ST    ENDSR
      *********************************************************************                   CLE106
      /EJECT                                                                                  CLE106
      *********************************************************************                   CLE106
      * SRVFSTP -  Validate default Sub-participation loan type/subtype   *                   CLE106
      *            (for loans and parts purchased when facility is        *                   CLE106
      *             syndicated)                                           *                   CLE106
      *********************************************************************                   CLE106
     C     SRVFSTP       BEGSR                                                                CLE106
                                                                                              CLE106
      ** Entry valid only when facility is syndicated                                         CLE106
                                                                                              CLE106
     C     FA_SYIN       IFNE      'Y'                                                        CLE106
                                                                                              CLE106
     C     DDSLTP        IFNE      *BLANKS                                                    CLE106
     C     DDSLST        ORNE      *BLANKS                                                    CLE106
     C     DDSLCL        ORNE      *BLANKS                                                    CLE042
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE106
     C                   MOVEL     'LEA1606'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** If syndication indicator is ON and SUB-type/subtype is not blank                     CLE106
                                                                                              CLE106
     C     FA_SYIN       IFEQ      'Y'                                                        CLE106
     C     DDSLTP        ANDNE     *BLANK                                                     CLE106
     C     FA_SYIN       OREQ      'Y'                                                        CLE106
     C     DDSLST        ANDNE     *BLANK                                                     CLE106
     C     FA_SYIN       OREQ      'Y'                                                        CLE042
     C     DDSLCL        ANDNE     *BLANK                                                     CLE042
                                                                                              CLE106
      ** Loan subtype must be entered if loan type is entered                                 CLE106
      ** and likewise                                                                         CLE106
                                                                                              CLE106
     C     DDSLTP        IFEQ      *BLANKS                                                    CLE106
     C     DDSLST        ANDNE     *BLANKS                                                    CLE106
     C     DDSLTP        ORNE      *BLANKS                                                    CLE106
     C     DDSLST        ANDEQ     *BLANKS                                                    CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE106
     C                   MOVEL     'LEA1607'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C     DDSLTP        IFEQ      *BLANKS                                                    CLE042
     C     DDSLCL        ANDNE     *BLANKS                                                    CLE042
     C     DDSLTP        ORNE      *BLANKS                                                    CLE042
     C     DDSLCL        ANDEQ     *BLANKS                                                    CLE042
     C     CLE042        ANDEQ     'Y'                                                        CLE042
     C                   MOVE      'N'           DDSLTPOK                                     CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE042
     C                   MOVEL     'LEA1201'     MsgIdArr(Idx)                                CLE042
     C                   ENDIF                                                                CLE042
                                                                                              CLE106
      ** Loan type must start with 'H, 'J' or 'K' if entered                                  CLE106
                                                                                              CLE106
     C     DDSLTP        IFNE      *BLANKS                                                    CLE106
     C     1             SUBST     DDSLTP:1      WFRST             1                          CLE106
                                                                                              CLE106
     C     WFRST         IFNE      'H'                                                        CLE106
     C     WFRST         ANDNE     'J'                                                        CLE106
     C     WFRST         ANDNE     'K'                                                        CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE106
     C                   MOVEL     'LEA1608'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Must form a valid loan type/subtype with processing type                             CLE106
      ** of a participations sold                                                             CLE106
                                                                                              CLE106
     C     DDSLTPOK      IFNE      'N'                                                        CLE106
                                                                                              CLE106
     C                   CALL      'AOLOANR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*KEY   '     @Optn                                        CLE106
     C                   PARM      DDSLTP        ATCD                                         CLE106
     C                   PARM      DDSLST        AUCD                                         CLE106
     C                   PARM      DDSLCL        AUCL                                         CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFNE      *BLANKS                                                    CLE106
     C*******************MOVE      'N'           DDDFTPOK                              CLE106 CLE042
     C*******************MOVE      'N'           DDDFSTOK                              CLE106 CLE042
     C                   MOVE      'N'           DDSLTPOK                                     CLE042
     C                   MOVE      'N'           DDSLSTOK                                     CLE042
     C                   MOVE      'N'           DDSLCLOK                                     CLE042
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE106
     C                   MOVEL     'LEA1610'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Only allow processing types 66, 67, 69 or 72 to be entered for default               CLE106
      ** SUB-participation loan type/sub type.                                                CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
                                                                                              CLE106
      ** Default Sub-Participation loan type/subtype does not                                 CLE106
      **    not have processing type for parts sold                                           CLE106
                                                                                              CLE106
     C     AYLNPT        IFNE      66                                                         CLE106
     C     AYLNPT        ANDNE     67                                                         CLE106
     C     AYLNPT        ANDNE     69                                                         CLE106
     C     AYLNPT        ANDNE     72                                                         CLE106
     C     SVPTYP        OREQ      69                                                         CLE106
     C     CLE005        ANDEQ     'N'                                                        CLE106
     C     SVPTYP        OREQ      72                                                         CLE106
     C     CLE005        ANDEQ     'N'                                                        CLE106
                                                                                              CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE106
     C                   MOVEL     'LEA1613'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Default Loan Type/Subtype must be in the same category as the loan's                 CLE106
                                                                                              CLE106
     C                   IF        SVPTYP = 61 And AYLNPT <> 69 Or                            CLE106
     C                             SVPTYP = 62 And AYLNPT <> 66 Or                            CLE106
     C                             SVPTYP = 63 And AYLNPT <> 67 Or                            CLE106
     C                             SVPTYP = 70 And AYLNPT <> 72                               CLE106
     C                   EVAL      DDSLTPOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDSLTP'                                 CLE106
     C                   MOVEL     'LEA1612'     MsgIdArr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSCPR - Subroutine to process 'SC' loan amendment            *
      *****************************************************************
     C     SRSCPR        BEGSR
      *
      ** Initialise funding info fields
     C                   Z-ADD     0             WFRAT            11 7
     C                   MOVE      *BLANKS       WFSGN             1
     C                   MOVE      *BLANKS       WIRCF             1
     C                   MOVE      *BLANKS       WFRCF             1
      *
      ** Calculate New Effective Interest Rate
      ** Obtain Interest New Rate/Spread
      ** New Interest Rate/Spread as entered
     C     DDRTSP        IFNE      *BLANKS
     C     DDFXRT        ORNE      *BLANKS                                                    CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
     C                   Z-ADD     WSPRT         WIRTS            11 7
     C                   MOVE      'Y'           WIRCF
      *
      ** Or, if no Interest Rate/Spread entered, from another 'SC'
      ** with value date <= current loan amendment value date and with
      ** interest rate chg flag = 'Y'
     C                   ELSE
     C                   MOVEL     DDLOAN        WKLNR
     C                   MOVEL     VDAYNO        WKVDT
      *
     C     DDSEQN        IFEQ      *BLANKS
     C                   MOVE      '999'         WKLSN
     C                   ELSE
     C                   MOVE      DDSEQN        WKLSN
     C                   ENDIF
      *
     C     KLAKEY        SETGT     LOAMSDKF
      *
     C     *IN99         DOUEQ     *ON
     C     AM_AMTP       OREQ      'SC'
     C     AM_IRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ORNE      WKLNR
     C                   READP     LOAMSDKF                               99
     C                   ENDDO
      *
     C     AM_AMTP       IFEQ      'SC'
     C     AM_IRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ANDEQ     WKLNR
     C     AM_RTSP       DIV       10000000      WIRTS
      *
      ** Or, if no Int Rate/Spread entered & no other 'SC' for loan,
      ** use original rate/spread from CLOAN
     C                   ELSE
     C                   Z-ADD     SVRTSP        WIRTS
     C                   ENDIF
      *
     C                   MOVE      'N'           WIRCF
     C                   ENDIF
      *
      ** Obtain base rate code
     C                   MOVE      *BLANKS       WBSRC             2
     C                   Z-ADD     *ZERO         WBRTE            11 7                        CLE035
      *
      ** Retrieve previous live 'BC' with value date <= current loan
      ** amendment value date
     C                   MOVEL     DDLOAN        WKLNR
     C                   MOVEL     VDAYNO        WKVDT
      *
     C     DDSEQN        IFEQ      *BLANKS
     C                   MOVE      '999'         WKLSN
     C                   ELSE
     C                   MOVE      DDSEQN        WKLSN
     C                   ENDIF
      *
     C     KLAKEY        SETGT     LOAMSDKF
      *
     C     *IN99         DOUEQ     *ON
     C     AM_AMTP       OREQ      'BC'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ORNE      WKLNR
     C                   READP     LOAMSDKF                               99
     C                   ENDDO
      *
     C     AM_AMTP       IFEQ      'BC'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ANDEQ     WKLNR
     C                   MOVE      AM_BRTT       WBSRC
     C*****CLE035        IFEQ      'Y'                                               CLE035 BUG10392
     C     CLE036        IFEQ      'Y'                                                      BUG10392
     C                   Z-ADD     AM_BRTE       WBRTE                                        CLE035
     C                   ENDIF                                                                CLE035
      *
      ** Or, if no other 'BC' for loan, use BRTT from CLOAN
     C                   ELSE
     C                   MOVE      SVBRTT        WBSRC
     C*****CLE035        IFEQ      'Y'                                               CLE035 BUG10392
     C     CLE036        IFEQ      'Y'                                                      BUG10392
     C                   Z-ADD     SVBRTE        WBRTE                                        CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF
      *
     C                   Z-ADD     0             WEFIR            11 7
      *
      ** If loan has base rate or there is previous 'BC'...
     C     WBSRC         IFNE      *BLANKS
     C     WBSRC         ANDNE     '00'
     C*****CLE035        OREQ      'Y'                                               CLE035 BUG10392
     C     CLE036        OREQ      'Y'                                                      BUG10392
     C     WBRTE         ANDNE     *ZERO                                                      CLE035
                                                                                              CLE035
     C*****CLE035        IFEQ      'Y'                                               CLE035 BUG10392
     C     CLE036        IFEQ      'Y'                                                      BUG10392
     C     WBRTE         ANDNE     *ZERO                                                      CLE035
     C                   Z-ADD     WBRTE         WBSRT                                        CLE035
     C                   ELSE                                                                 CLE035
      *
      ** Retrieve base rate associated with base rate code
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCURR        @Curr             3
     C                   PARM      WBSRC         @BRat             2
     C     SDBSRT        PARM                    DSSDY
      *
      ** Determine actual base rate
     C     @RtCd         IFEQ      *BLANKS
      *
     C     VDAYNO        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        WBSRT            11 7
     C                   ELSE
     C                   Z-ADD     BANBRT        WBSRT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                                CLE035
      *
      ** New Effective Interest Rate = Interest New Rate/Spread
      ** combined with Base Rate depending on Spread Indicator
     C                   SELECT
     C     SVSPIN        WHENEQ    'A'
     C     WBSRT         ADD       WIRTS         WEFIR
      *
     C     SVSPIN        WHENEQ    'S'
     C     WBSRT         SUB       WIRTS         WEFIR
      *
     C     SVSPIN        WHENEQ    'P'
     C     WBSRT         MULT      WIRTS         WEFIR
     C     WEFIR         DIV       100           WEFIR
     C                   ENDSL
      *
      ** New Effective Interest Rate = Interest New Rate/Spread if
      ** loan is not linked to base rate
     C                   ELSE
     C                   Z-ADD     WIRTS         WEFIR
     C                   ENDIF
      *
     C                   Z-ADD     0             WFRSP            11 7
      *
      ** Obtain New Funding Rate/Spread
     C     BGN0ST        IFEQ      'Y'
     C     DDATYP        ANDEQ     'SC'
     C*****SVFPRC        ANDNE     *BLANKS                                                   240411A
      *
     C     CDE002        OREQ      'Y'
     C     DDATYP        ANDEQ     'SC'
      *                                                                                       CLE035
     C*****CLE035        OREQ      'Y'                                               CLE035 BUG10392
     C     CLE036        OREQ      'Y'                                                      BUG10392
     C     DDATYP        ANDEQ     'SC'                                                       CLE035
      *                                                                                       CLE035
     C**********         If        CLE035 = 'Y'                                      CLE035 BUG10392
     C                   If        CLE036 = 'Y'                                             BUG10392
      *                                                                                       CLE035
      ** Error if spread rate, fixed rate, funding spread rate and funding rate are           CLE035
      ** all blanks                                                                           CLE035
      *                                                                                       CLE035
     C                   If        DDRTSP = *BLANKS and DDFRAT = *BLANKS and                  CLE035
     C                             DDFXRT = *BLANKS and DDFRSP = *BLANKS                      CLE035
     C                   MOVE      'N'           DDRTSPOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'                                 CLE035
     C                   MOVEL     'LEA0552'     MsgIdArr(Idx)                                CLE035
     C                   else                                                                 CLE035
      *                                                                                       CLE035
      ** Error if funding spread rate is specified but funding sign is blanks                 CLE035
      *                                                                                       CLE035
     C                   If        DDFRSP <> *BLANKS and SVFSGN = *BLANKS                     CLE035
     C                   MOVE      'N'           DDFRSPOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFRSP'                                 CLE035
     C                   MOVEL     'LEA0553'     MsgIdArr(Idx)                                CLE035
     C                   Else                                                                 CLE035
      *                                                                                       CLE035
      ** Error if funding rate is specified but funding sign is not equal to blanks           CLE035
      *                                                                                       CLE035
     C                   If        DDFRAT <> *BLANKS and SVFSGN <> *BLANKS                    CLE035
     C                             AND CLE036 = 'Y'                                          BUG9655
     C                   MOVE      'N'           DDFRATOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFRAT'                                 CLE035
     C                   MOVEL     'LEA0554'     MsgIdArr(Idx)                                CLE035
     C                   Else                                                                 CLE035
      *                                                                                       CLE035
      ** Retrieve  funding rate if funding rate spread and funding rate are not specified     CLE035
      ** and either the spread rate or the fixed rate is specified                            CLE035
      *                                                                                       CLE035
     C                   If        DDFRSP = *BLANKS and  DDFRAT = *BLANKS                     CLE035
      *                                                                                       CLE035
      ** Retrieve most recent 'SC' with Funding Rate Change Flag = 'Y'                        CLE035
     C                   MOVEL     DDLOAN        WKLNR                                        CLE035
     C                   MOVEL     VDAYNO        WKVDT                                        CLE035
      *                                                                                       CLE035
     C     DDSEQN        Ifeq      *BLANKS                                                    CLE035
     C                   MOVE      '999'         WKLSN                                        CLE035
     C                   Else                                                                 CLE035
     C                   MOVE      DDSEQN        WKLSN                                        CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C     KLAKEY        SETGT     LOAMSDKF                                                   CLE035
      *                                                                                       CLE035
     C     *IN99         DOUEQ     *ON                                                        CLE035
     C     AM_AMTP       OREQ      'SC'                                                       CLE035
     C     AM_FRCF       ANDEQ     'Y'                                                        CLE035
     C     AM_RECI       ANDEQ     'D'                                                        CLE035
     C     AM_LNRF       ORNE      WKLNR                                                      CLE035
     C                   READP     LOAMSDKF                               99                  CLE035
     C                   Enddo                                                                CLE035
      *                                                                                       CLE035
     C     AM_AMTP       Ifeq      'SC'                                                       CLE035
     C     AM_FRCF       Andeq     'Y'                                                        CLE035
     C     AM_RECI       Andeq     'D'                                                        CLE035
     C     AM_LNRF       Andeq     WKLNR                                                      CLE035
     C                   Z-ADD     AM_FSRP       WFRSP                                        CLE035
      *                                                                                       CLE035
      ** Or, if no Fund Rate/Spread entered & no other 'SC' for loan,                         CLE035
      ** use original funding rate/spread from CLOAN                                          CLE035
     C                   Else                                                                 CLE035
     C                   Z-ADD     SVFSRP        WFRSP                                        CLE035
     C                   Z-ADD     SVFSRP        WFRAT                                        CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   MOVE      'N'           WFRCF                                        CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
      ** Check funding spread rate format                                                     CLE035
      *                                                                                       CLE035
     C                   If        DDFRSP <> *Blanks                                          CLE035
     C                   CALLB     'ZALIGN'                                                   CLE035
     C                   PARM      *BLANK        ZALIGNok          1                          CLE035
     C                   PARM      DDFRSP        ZFIELD           16                          CLE035
     C                   PARM      7             ZADEC             1 0                        CLE035
     C                   PARM      4             ZADIG             2 0                        CLE035
      *                                                                                       CLE035
     C     ZALIGNok      Ifeq      'N'                                                        CLE035
      *                                                                                       CLE035
      ** Funding spread rate must be of valid numeric format                                  CLE035
      *                                                                                       CLE035
     C                   MOVE      'N'           DDFRSPOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFRSP'                                 CLE035
     C                   MOVEL     'LEA0555'     MsgIdArr(Idx)                                CLE035
     C                   Else                                                                 CLE035
      *                                                                                       CLE035
      ** Obtain the correct funding spread rate to be used in calculating the                 CLE035
      ** actual effective funding rate                                                        CLE035
      *                                                                                       CLE035
     C                   If        DDFRSP <> *BLANKS and SVFSGN <> *BLANKS                    CLE035
     C                   MOVE      ZFIELD        WFRAT                                        CLE035
     C                   Z-ADD     WFRAT         WFRSP                                        CLE035
     C                   MOVE      'Y'           WFRCF                                        CLE035
     C                   MOVE      SVFSGN        WFSGN                                        CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
      ** Check funding rate format                                                            CLE035
      *                                                                                       CLE035
     C                   If        DDFRAT <> *Blanks                                          CLE035
     C                             AND CLE036 = 'Y'                                          BUG9655
     C                   CALLB     'ZALIGN'                                                   CLE035
     C                   PARM      *BLANK        ZALIGNok                                     CLE035
     C                   PARM      DDFRAT        ZFIELD                                       CLE035
     C                   PARM      7             ZADEC                                        CLE035
     C                   PARM      4             ZADIG                                        CLE035
      *                                                                                       CLE035
     C     ZALIGNok      IFEQ      'N'                                                        CLE035
      *                                                                                       CLE035
      *** Funding rate rate must be of valid numeric format                                   CLE035
      *                                                                                       CLE035
     C                   MOVE      'N'           DDFRATOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   EVAL      FldNameArr(Idx) = 'DDFRAT'                                 CLE035
     C                   MOVEL     'LEA0546'     MsgIdArr(Idx)                                CLE035
     C                   ELse                                                                 CLE035
      *                                                                                       CLE035
      ** Obtain the correct funding rate to be used in calculating the actual                 CLE035
      ** effective funding rate                                                               CLE035
      *                                                                                       CLE035
     C                   If        DDFRAT <> *BLANKS and SVFSGN = *BLANKS                     CLE035
     C                   MOVE      ZFIELD        WFRAT                                        CLE035
     C                   Z-ADD     WFRAT         WFRSP                                        CLE035
     C                   MOVE      'Y'           WFRCF                                        CLE035
     C                   MOVE      SVFSGN        WFSGN                                        CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
     C                   Endif                                                                CLE035
     C                   Else                                                                 CLE035
      *                                                                                      240411A
      ** Move funding spread rate to DDFRAT as DDFRSP is the input                           240411A
      ** field from Java.                                                                    240411A
      *                                                                                      240411A
     C                   MOVE      DDFRSP        DDFRAT                                      240411A
      *
      ** Validate Funding Spread/Rate if it is enabled.
     C     DDFRAT        IFEQ      *BLANKS
      *
      ** Error if both interest and funding rate/spread are blank
     C     DDRTSP        IFEQ      *BLANKS
     C                   MOVE      'N'           DDRTSPOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'
     C                   MOVEL     'LEA0545'     MsgIdArr(Idx)
      *
      ** If interest rate/spread entered...
     C                   ELSE
      *
      ** Retrieve most recent 'SC' with Funding Rate Change Flag = 'Y'
     C                   MOVEL     DDLOAN        WKLNR
     C                   MOVEL     VDAYNO        WKVDT
      *
     C     DDSEQN        IFEQ      *BLANKS
     C                   MOVE      '999'         WKLSN
     C                   ELSE
     C                   MOVE      DDSEQN        WKLSN
     C                   ENDIF
      *
     C     KLAKEY        SETGT     LOAMSDKF
      *
     C     *IN99         DOUEQ     *ON
     C     AM_AMTP       OREQ      'SC'
     C     AM_FRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ORNE      WKLNR
     C                   READP     LOAMSDKF                               99
     C                   ENDDO
      *
     C     AM_AMTP       IFEQ      'SC'
     C     AM_FRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ANDEQ     WKLNR
     C                   Z-ADD     AM_FSRP       WFRSP
      *
      ** Or, if no Fund Rate/Spread entered & no other 'SC' for loan,
      ** use original funding rate/spread from CLOAN
     C                   ELSE
     C                   Z-ADD     SVFSRP        WFRSP
     C                   Z-ADD     SVFSRP        WFRAT
     C                   ENDIF
      *
     C                   MOVE      'N'           WFRCF
     C                   ENDIF
      *
      ** If funding rate/spread entered, check if it is a valid figure
     C                   ELSE
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok          1
     C                   PARM      DDFRAT        ZFIELD           16
     C                   PARM      7             ZADEC             1 0
     C                   PARM      4             ZADIG             2 0
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDFRATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFRAT'
     C                   MOVEL     'LEA0546'     MsgIdArr(Idx)
      *
      ** If valid figure, assign rate change flag and funding sign
     C                   ELSE
     C                   MOVE      ZFIELD        WFRAT
     C                   Z-ADD     WFRAT         WFRSP
     C                   MOVE      'Y'           WFRCF
     C                   MOVE      SVFSGN        WFSGN
     C                   ENDIF
      *
     C                   ENDIF
     C                   Endif                                                                CLE035
      *
      ** Do not perform tolerance check if New Funding Rate/Spread = 0
     C     WFRSP         IFNE      0
      *
      ** Calculate New Actual (Effective) Funding Rate
     C                   SELECT
     C     SVFSGN        WHENEQ    *BLANK
     C                   Z-ADD     WFRSP         WEFFR            11 7
      *
     C     SVFSGN        WHENEQ    '+'
     C     WEFIR         ADD       WFRSP         WEFFR
      *
     C     SVFSGN        WHENEQ    '-'
     C     WEFIR         SUB       WFRSP         WEFFR
     C                   ENDSL
      *
      ** Perform tolerance check
     C                   EXSR      SRTOLC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXSCPR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTOLC - Subroutine to check funding rate/spread tolerance    *
      *****************************************************************
     C     SRTOLC        BEGSR
      *
      ** Calculate minimum & maximum allowable amount based on Funding
      ** Tolerance
     C     WEFFR         IFGT      WEFIR
     C     FTTFRT        DIV       100           WTOL1             3 2
     C     WTOL1         ADD       1             WTOL4             3 2
     C     WEFIR         MULT      WTOL4         WMAX             11 7
     C                   ENDIF
      *
     C     WEFFR         IFLT      WEFIR
     C     FTTFRT        DIV       100           WTOL2             3 2
     C     1             SUB       WTOL2         WTOL3             3 2
     C     WEFIR         MULT      WTOL3         WMIN             11 7
     C                   ENDIF
      *
      ** Check if Effective Funding Rate is within tolerance level
      ** Send Warning message
     C     WEFFR         IFNE      WEFIR
      *
     C     WEFFR         IFGT      WMAX
     C     WEFFR         ANDGT     WEFIR
      *
     C     WEFFR         ORLT      WMIN
     C     WEFFR         ANDLT     WEFIR
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1036'
      *
      ** Reverse image base rate code if 'BC'; funding rate/spread
      ** if 'SC'
     C                   SELECT
     C     DDATYP        WHENEQ    'SC'
     C                   MOVE      'N'           DDFRATOK
     C                   EVAL      WFldNamArr(WIdx) = 'DDFRAT'
      *
     C     DDATYP        WHENEQ    'BC'
     C                   MOVE      'N'           DDBRATOK
     C                   EVAL      WFldNamArr(WIdx) = 'DDBRAT'
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBCPR - Subroutine to process 'BC' loan amendment            *
      *****************************************************************
     C     SRBCPR        BEGSR
      *
      ** Extra validation for value date. Check if there is
      ** a base rate for the period of the backvaluation.
     C     CLE003        IFEQ      'Y'
     C     *LIKE         DEFINE    G0CYCD        CRCY
     C     *LIKE         DEFINE    G0BSRC        BCCOD
     C                   MOVEL     DDCURR        CRCY
     C                   MOVEL     DDBRAT        BCCOD
      *
     C     DDCURR        IFNE      *BLANKS
     C     DDBRAT        ANDNE     *BLANKS
     C     BCKEY         CHAIN     SDBSHSD0                           99
      *                                                                                       243251
     C     BCKEY1        SETGT     SDBSHSD0                                                   243251
     C     BCKEY         READPE    SDBSHSD0                               99                  243251
     C     *IN99         IFEQ      '0'                                                        243251
     C                   Z-ADD     G0CBSR        BRTE                                         243251
     C                   Z-ADD     G0CBSR        WBASR                                        243251
     C                   Z-ADD     G0CBSR        BAVDNR                                       243251
     C                   ENDIF                                                                243251
      *
      ** If the new Value Date is not equal to the value on the historic
      ** file, check that a rate exists for the currency and code before
      ** the new date. If not then entry is not valid.
     C                   MOVE      ' '           AO#BSRT           1                          243251
     C     *IN99         IFEQ      *ON
     C     VDAYNO        OREQ      WRNDAY                                                     243251
      *
      ** Check if the rate exists in SDBSRTPD for the currency and the
      ** code.  Also check if dates are valid.
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCURR        @Curr             3
     C                   PARM      DDBRAT        @BRat             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C                   MOVE      'Y'           AO#BSRT           1                          243251
     C                   ENDIF
      *
     C     @RTCD         IFNE      *BLANKS
     C     AO#BSRT       ANDEQ     'Y'                                                        243251
     C     VADAT         ORLT      BAVDNR
     C     VADAT         ANDNE     *ZEROS
     C     *IN93         ANDEQ     '1'
     C     AO#BSRT       ANDEQ     'Y'                                                        243251
     C     VADAT         ORLT      G0HIDT
     C     VADAT         ANDNE     *ZEROS
     C     *IN93         ANDNE     '1'
     C     *IN99         ANDEQ     '0'                                                        243251
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   MOVEL     'LEA1038'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Analytical Accounting isn't available, or loan isn't
      ** directly funded and Revenue Analysis isn't installed,
      ** don't go further
     C     BGN0ST        IFNE      'Y'
     C     SVFPRC        OREQ      *BLANKS
      *
     C     CDE002        IFNE      'Y'
     C                   GOTO      EXBCPR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Calculate New Effective Interest Rate
      ** Obtain Interest New Rate/Spread
      ** Retrieve most recent 'SC' with value date <= current loan
      ** amendment value date and with int rate chg flag = 'Y'
     C                   MOVEL     DDLOAN        WKLNR
     C                   MOVEL     VDAYNO        WKVDT
      *
     C     DDSEQN        IFEQ      *BLANKS
     C                   MOVE      '999'         WKLSN
     C                   ELSE
     C                   MOVE      DDSEQN        WKLSN
     C                   ENDIF
      *
     C     KLAKEY        SETGT     LOAMSDKF
      *
     C     *IN99         DOUEQ     *ON
     C     AM_AMTP       OREQ      'SC'
     C     AM_IRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ORNE      WKLNR
     C                   READP     LOAMSDKF                               99
     C                   ENDDO
      *
     C     AM_AMTP       IFEQ      'SC'
     C     AM_IRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ANDEQ     WKLNR
     C     AM_RTSP       DIV       10000000      WIRTS
      *
      ** Or, if no other 'SC' for loan, use original rate/spread from
      ** CLOAN
     C                   ELSE
     C                   Z-ADD     SVRTSP        WIRTS
     C                   ENDIF
                                                                                              CLE035
      ** Use Base Rate if no Base Rate Code entered                                           CLE035
                                                                                              CLE035
     C*****CLE035        IFEQ      'N'                                               CLE035 BUG10392
     C     CLE036        IFEQ      'N'                                                      BUG10392
     C     DDBRAT        ORNE      *BLANKS                                                    CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10392
     C     CLE036        ANDEQ     'Y'                                                      BUG10392
      *                                                                                       243251
      ** Retrieve base rate associated with base rate code                                    243251
      *                                                                                       243251
     C     BCKEY1        SETGT     SDBSHSD0                                                   243251
     C     BCKEY         READPE    SDBSHSD0                               99                  243251
     C     *IN99         IFEQ      '0'                                                        243251
     C                   Z-ADD     G0CBSR        BRTE                                         243251
     C                   Z-ADD     G0CBSR        WBASR                                        243251
     C                   ENDIF                                                                243251
      *
      ** Retrieve base rate associated with base rate code
      *
     C     *IN99         IFEQ      '1'                                                        243251
     C     VDAYNO        OREQ      WRNDAY                                                     243251
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCURR        @Curr             3
     C                   PARM      DDBRAT        @BRat             2
     C     SDBSRT        PARM                    DSSDY
      *
      ** Determine actual base rate
     C     @RtCd         IFEQ      *BLANKS
      *
     C     VDAYNO        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        WBSRT
     C                   ELSE
     C                   Z-ADD     BANBRT        WBSRT
     C                   ENDIF
     C                   ENDIF                                                                243251
      *
     C                   ENDIF
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
     C                   Z-ADD     WBASR         WBSRT                                        CLE035
     C                   ENDIF                                                                CLE035
      *
      ** New Effective Interest Rate = Interest New Rate/Spread
      ** combined with Base Rate depending on Spread Indicator
     C                   SELECT
     C     SVSPIN        WHENEQ    'A'
     C     WBSRT         ADD       WIRTS         WEFIR
      *
     C     SVSPIN        WHENEQ    'S'
     C     WBSRT         SUB       WIRTS         WEFIR
      *
     C     SVSPIN        WHENEQ    'P'
     C     WBSRT         MULT      WIRTS         WEFIR
     C     WEFIR         DIV       100           WEFIR
     C                   ENDSL
      *
     C                   Z-ADD     0             WFRSP            11 7
      *
      ** Do not perform tolerance check if New Eff. Int. Rate = 0
     C     WEFIR         IFNE      0
      *
      ** Obtain New Funding Rate/Spread
      ** most recent 'SC' with Funding Rate Change Flag = 'Y'
      ** retrieved above
     C     AM_AMTP       IFEQ      'SC'
     C     AM_FRCF       ANDEQ     'Y'
     C     AM_RECI       ANDEQ     'D'
     C     AM_LNRF       ANDEQ     WKLNR
     C                   Z-ADD     AM_FSRP       WFRSP
      *
      ** Or, if no Fund Rate/Spread entered & no other 'SC' for loan,
      ** use original funding rate/spread from CLOAN
     C                   ELSE
     C                   Z-ADD     SVFSRP        WFRSP
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Do not perform tolerance check if New Eff. Int. Rate = 0
      ** or if New Funding Rate/Spread = 0
     C     WEFIR         IFNE      0
     C     WFRSP         ANDNE     0
      *
      ** Calculate New Actual (Effective) Funding Rate
     C                   SELECT
     C     SVFSGN        WHENEQ    *BLANK
     C                   Z-ADD     WFRSP         WEFFR            11 7
      *
     C     SVFSGN        WHENEQ    '+'
     C     WEFIR         ADD       WFRSP         WEFFR
      *
     C     SVFSGN        WHENEQ    '-'
     C     WEFIR         SUB       WFRSP         WEFFR
     C                   ENDSL
      *
      ** Perform tolerance check
     C                   EXSR      SRTOLC
     C                   ENDIF
      *
     C     EXBCPR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRHOLY - Validate holidays                                   *
      *****************************************************************
     C     SRHOLY        BEGSR
      *
      ** Holiday validations if loan currency is valid
     C     DDCURROK      IFNE      'N'
      *
      ** Test value date for holiday
     C     DDVDATOK      IFNE      'N'
     C     VDAT          ANDNE     0
     C                   Eval      ZDAYNO = CAM_VDAT
      *
      ** If receipt, use our branch, currency, settlement method,
      ** else use customer details
     C                   If        DDRSCY <> *Blanks
     C                   MOVE      A8BRCD        W@BRCA            3
     C                   MOVE      DDRSCY        WSCCY             3
     C                   MOVEL     DDRSTM        TYPE              2
     C                   Else
     C                   MOVE      BBBRCD        W@BRCA
     C                   MOVE      DDPSCY        WSCCY
     C                   MOVEL     DDPSTM        TYPE
     C                   EndIf
      *
      ** Find DRS location of a branch
     C     W@BRCA        IFNE      A8BRCD
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      W@BRCA        PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      A8LCCD        ZLOC
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   ENDIF
      *
      ** Find currency to use
     C     TYPE          IFEQ      '01'
     C     TYPE          OREQ      '07'
     C     TYPE          OREQ      '08'
      *
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANK
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C                   MOVE      CCY           ZCCY
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
      ** If date is holiday send warning messages
     C                   Z-ADD     0             ZNRDYS
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     TYPE          IFEQ      '01'
     C     TYPE          OREQ      '07'
     C     TYPE          OREQ      '08'
     C     ZIND          IFEQ      'H'
      *
      ** Add error message to array passed to detail screen
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1025'
     C                   ENDIF
     C                   ELSE
     C     ZIND          IFEQ      'H'
      *
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx)  = 'LEA1026'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up the fields of the valid file record       *
      *****************************************************************
     C     SetupValid    BEGSR
      *
     C     DDACTN        CASEQ     'I'           SRINSERT
     C                   CAS                     SRAMEND
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINSERT - Set up the valid file in Insert mode               *
      *****************************************************************
     C     SRINSERT      BEGSR
      *
      ** On first validation only, clear valid file (otherwise settlement
      ** details lost)
     C     LARECI        IFEQ      ' '
     C                   CLEAR                   ValidLoam
     C                   ENDIF
      *
     C                   MOVE      'D'           LARECI
     C                   MOVE      DDLOAN        LALNRF
     C                   IF        DDSEQN <> *BLANKS                                          CSC024
     C                   MOVE      DDSEQN        LALASN                                       CSC024
     C                   ENDIF                                                                CSC024
     C                   Z-ADD     VDAYNO        LAVDAT
     C                   MOVE      '2'           LAMRIN
     C                   MOVE      SVLTYP        LALTYP
      *
     C     DDATYP        IFNE      'LS'
     C                   MOVE      SVSUTP        LASUTP
     C                   MOVE      SVCLAS        LACLAS                                       CLE042
     C                   MOVE      SVPTYP        LAPTYP
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      DDMDAT        ZDATEA
     C     LALSMD        PARM                    ZDAYNO
     C                   PARM      BJDFIN        DateFmt
     C                   PARM                    ErrorFlag
      *
     C                   ELSE
     C                   MOVE      DDSTYP        LASUTP
     C                   MOVE      DDCLAS        LACLAS                                       CLE042
     C***********        MOVE      AYLNPT        LAPTYP                                     BUG10707
     C                   MOVE      WWPTYP        LAPTYP                                     BUG10707
     C                   Z-ADD     WLSMD         LALSMD
     C                   ENDIF
      *
     C                   MOVE      DDATYP        LAAMTP
     C                   MOVE      '00'          LAPRSQ
      *
     C     DDATYP        IFEQ      'BC'
     C                   MOVE      DDBRAT        LABRTT
     C                   Z-ADD     WBASR         BRTE
     C                   Z-ADD     WBASR         LABASR                                       CLE035
     C                   ENDIF
      *
     C     DDATYP        IFEQ      'SC'
     C                   Z-ADD     WSPRT         LARTSP
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   Z-ADD     TMCNSP        LACNSP                                       CRE073
     C                   MOVEL     DDCNSG        LACNSG                                       CRE073
     C                   MOVEL     DDRDMT        LARDMT                                       CRE073
     C                   MOVEL     DDRDFD        LARDFD                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF
      *
     C                   MOVE      DDCURR        LACCY
      *
     C     DDATYP        IFEQ      'PI'
     C     DDATYP        OREQ      'PT'
     C     DDATYP        OREQ      'PF'
     C                   Z-ADD     WLAMT         LAPRAM
     C                   Z-ADD     WLAMT         LATAMT
     C                   ENDIF
      *
     C                   MOVEL     SVBRCA        LABRCA
     C                   MOVE      SVCNUM        LACNUM
     C                   MOVE      'Y'           LAAUTO
     C                   MOVE      DDSTPA        LASTAI
     C                   MOVEL     DDSPI1        LASPI1
     C                   MOVEL     DDSPI2        LASPI2
     C                   MOVEL     DDSPI3        LASPI3
     C                   MOVE      X'00'         LALAIN
     C                   MOVE      'A'           LALLAG
     C**********         Z-ADD     SVFCUS        LAFCUS                                       CSD027
     C                   EVAL      LAFCUS = SVFCUS                                            CSD027
     C                   Z-ADD     SVFTYP        LAFTYP
     C                   Z-ADD     SVFSEQ        LAFSEQ
     C                   MOVE      X'00'         LAPONI
     C                   MOVE      SVNACD        LANACD
     C                   MOVE      SVFCLB        LAFCLB
      *
     C                   Z-ADD     WRNDAY        LAORED
     C                   Z-ADD     WRNDAY        LALCD
      *
     C                   MOVE      'I'           LACHTP
     C                   Z-ADD     WFRAT         LAFSRP
     C                   MOVE      WFSGN         LAFSGN
     C                   MOVE      SVFPRC        LAFPRC
     C                   MOVE      WIRCF         LAIRCF
     C                   MOVE      WFRCF         LAFRCF
      *
     C                   MOVE      DDDFTP        LADFTP
     C                   MOVE      DDDFST        LADFST
     C                   MOVE      DDDFCL        LADFCL                                       CLE042
                                                                                              CLE106
     C                   MOVE      DDSLTP        LASLTP                                       CLE106
     C                   MOVE      DDSLST        LASLST                                       CLE106
     C                   MOVE      DDSLCL        LASLCL                                       CLE042
      *
     C                   MOVE      'M'           LAMNSG
      *
     C**********         MOVE      'N'           LAGASS                                       CLE106
     C                   MOVE      'P'           LAGASS                                       CLE106
      *
     C     DDATYP        IFEQ      'BC'
     C                   Z-ADD     BRTE          LABRTE
     C                   ENDIF
      *
     C     DDATYP        IFEQ      'PT'
     C     DDATYP        OREQ      'PF'
     C                   MOVE      'Y'           LAGPRT
     C                   ELSE
     C                   MOVE      'N'           LAGPRT
     C                   ENDIF
      *
     C                   MOVE      'N'           LANRLI
      *
      *  If the transaction is a Principal Transfer, check the
      *  corresponding Customer Lending ICD Flag to authorise it
     C     DDATYP        IFEQ      'PT'
     C     DDATYP        OREQ      'PF'
      *
     C     BPTPAU        IFEQ      'N'
     C     CLE002        OREQ      'N'
     C                   MOVE      'A'           LAASTS
     C                   ELSE
     C                   MOVE      'C'           LAASTS
     C                   ENDIF
      *
      ** Else, check the general Flag for Loan Amendment
     C                   ELSE
      *
     C     BPLMAU        IFEQ      'N'
     C     CLE002        OREQ      'N'
     C                   MOVE      'A'           LAASTS
     C                   ELSE
     C                   MOVE      'C'           LAASTS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     PSUser        LAIUSR
      *
      *  If no front office id, create pc ref for use as fo id
     C     FOTranId      IFEQ      *BLANKS
     C     LAPCRF        ANDEQ     *BLANKS
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      SVBRCA        @Brca             3
     C     SDBRCH        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLOAN'
     C                   MOVEL     'LEA1520'     MsgIdArr(Idx)
     C**********         MOVEL(P)  SVBRCA        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SVBRCA))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(SVBRCA)                   MD000091
     C                   ELSE
      *
     C     A8MQSM        IFNE      *BLANKS
     C                   MOVEL     A8MQSM        WBRCH             3
     C                   ELSE
     C                   MOVE      SVBRCA        WBRCH
     C                   ENDIF
      *
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         ADD       1             PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
      *
     C**********         EVAL      LAPCRF = WBRCH + %Char(PCLAST) +                           CLE148
     C**********                                        '0001'                                CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   EVAL      LAPCRF = WBRCH + PCNEXT + '0001'                           CLE148
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      LAPCRF = FOTranId                                          CLE106
     C                   ENDIF                                                                CLE106
      *
     C     CEU020        IFEQ      'Y'
     C                   MOVE      'N'           LAECIN
     C                   ENDIF
      *
      ** If Principal Transfer, retrieve data from the receiving/originating loan
     C     DDATYP        IFEQ      'PT'
     C     DDATYP        OREQ      'PF'
     C                   MOVE      LAROLN        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   MOVEL     'LEA1521'     MsgIdArr(Idx)
     C**********         MOVEL(P)  LAROLN        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(LAROLN))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(LAROLN)                   MD000091
     C                   ENDIF
      *
      ** Calculate effective interest rate
     C                   SELECT
     C     SPIN          WHENEQ    'A'
     C     BRTE          ADD       RTSP          W#RATE           11 7
      *
     C     SPIN          WHENEQ    'S'
     C     BRTE          SUB       RTSP          W#RATE
      *
     C     SPIN          WHENEQ    'P'
     C                   EVAL(H)   W#RATE = RTSP * BRTE / 100
     C                   ENDSL
      *
     C                   Z-ADD     RTSP          LARTSP
     C                   Z-ADD     BRTE          LABRTE
     C                   MOVEL     SPIN          LASPIN
     C                   Z-ADD     ICBS          LACALC
     C                   Z-ADD     MDAT          ZIEND
      *
     C     ADDI          IFEQ      'B'
     C                   ADD       1             ZIEND
     C                   ENDIF
      *
     C                   CALLB     'GLINTC'
     C                   PARM      LAVDAT        ZIBEG             5 0
     C                   PARM                    ZIEND             5 0
     C                   PARM      ICBS          ZICALC            1 0
     C                   PARM      LAPRAM        ZIAMT            15 0
     C                   PARM      W#RATE        ZIRATE           11 7
     C                   PARM                    ZINTR            30 9
      *
     C                   Z-ADD     ZINTR         LAINTA
     C                   ENDIF
      *
     C                   MOVE      FOTranId      LAFRNT
     C                   MOVE      FOAssocId     LAAFRT
     C                   MOVE      RepairLoc     LAREPA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAMEND - Set up the valid file if not in Insert mode         *
      *****************************************************************
     C     SRAMEND       BEGSR
      *
      ** Load the current values of the Loan Amendment record
     C**********         MOVE      CurFilLoam    ValidLoam                                    CRE073
     C                   MOVEL     CurFilLoam    ValidLoam                                    CRE073
      *
      ** Set up the following fields for action Amend
     C     DDACTN        IFEQ      'A'
                                                                                              CLE042
     C     DDATYP        IFEQ      'LS'                                                       CLE042
     C                   MOVE      SVLTYP        LALTYP                                       CLE042
     C                   MOVE      DDSTYP        LASUTP                                       CLE042
     C                   MOVE      DDCLAS        LACLAS                                       CLE042
     C***********        MOVE      AYLNPT        LAPTYP                              CLE042 BUG10707
     C                   MOVE      WWPTYP        LAPTYP                                     BUG10707
     C                   MOVE      DDDFTP        LADFTP                                       CLE042
     C                   MOVE      DDDFST        LADFST                                       CLE042
     C                   MOVE      DDDFCL        LADFCL                                       CLE042
     C                   MOVE      DDSLTP        LASLTP                                       CLE042
     C                   MOVE      DDSLST        LASLST                                       CLE042
     C                   MOVE      DDSLCL        LASLCL                                       CLE042
     C                   ENDIF                                                                CLE042
                                                                                              CLE042
     C                   MOVEL     DDSPI1        LASPI1
     C                   MOVEL     DDSPI2        LASPI2
     C                   MOVEL     DDSPI3        LASPI3
     C                   MOVE      'A'           LACHTP
     C                   Z-ADD     WRNDAY        LALCD
     C                   MOVEL     PSUser        LAAUSR
      *
     C     DDATYP        IFEQ      'PT'
     C     DDATYP        OREQ      'PF'
     C     DDATYP        OREQ      'PI'                                                     BUG16970
      *
     C                   Z-ADD     WLAMT         LAPRAM                                       CLE106
     C                   Z-ADD     WLAMT         LATAMT                                       CLE106
                                                                                              CLE106
     C                   SELECT
     C     BPTPAU        WHENEQ    'N'
     C     CLE002        OREQ      'N'
     C                   MOVE      'A'           LAASTS
      *
     C     LAASTS        WHENEQ    'A'
     C                   MOVE      'R'           LAASTS
      *
      ** Status 'R' should remain as 'R' on amend
     C     LAASTS        WHENEQ    'R'
      *
     C                   OTHER
     C                   MOVE      'C'           LAASTS
     C                   ENDSL
      *
     C                   ELSE
      *
     C     BPLMAU        IFEQ      'N'
     C     CLE002        OREQ      'N'
     C                   MOVE      'A'           LAASTS
     C                   ELSE
      *
     C     LAASTS        IFEQ      'A'
     C                   MOVE      'R'           LAASTS
      *
      ** Status 'R' should remain as 'R' on amend
     C                   ELSE
      *
     C     LAASTS        IFEQ      'R'
     C                   ELSE
     C                   MOVE      'C'           LAASTS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Set up the following fields for Authorisation
     C     DDACTN        IFEQ      'X'
     C     BPLMAU        ANDEQ     'Y'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     BPLMAU        ANDEQ     'Y'                                                        CLE030
     C     WLASTS        IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'A'           LAASTS
     C                   ELSE                                                                 CLE030
     C                   MOVE      WLASTS        LAASTS                                       CLE030
     C                   ENDIF                                                                CLE030
     C*******************MOVE      'X'           LACHTP                         213280
     C                   Z-ADD     WRNDAY        LALCD
     C                   MOVEL     PSUser        LAXUSR
     C                   ENDIF
      *
      ** Set up the following fields for Reverse
     C     DDACTN        IFEQ      'R'
     C                   MOVE      'R'           LARECI
     C                   MOVE      'R'           LACHTP
     C                   MOVE      'D'           LAASTS
     C                   Z-ADD     WRNDAY        LALCD
     C                   ENDIF
      *
      ** Setting of 'manual/system generated' flag
     C                   SELECT
     C     DDACTN        WHENEQ    'X'
     C                   MOVE      'S'           LAMNSG
      *
     C     DDACTN        WHENEQ    'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      'S'           LAMNSG                                       CLE030
      *                                                                                       CLE030
     C                   OTHER
     C                   MOVE      'M'           LAMNSG
     C                   ENDSL
      *
      ** If Principal Transfer, retrieve data from the current Loan Amendment
      ** except the loan maturity date, which must be retrieved from the
      ** receiving/originating loan number
     C     DDATYP        IFEQ      'PT'
     C     DDACTN        ANDEQ     'A'
     C     DDATYP        OREQ      'PF'
     C     DDACTN        ANDEQ     'A'
     C                   MOVE      LAROLN        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   MOVEL     'LEA1521'     MsgIdArr(Idx)
     C**********         MOVEL(P)  LAROLN        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(LAROLN))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(LAROLN)                   MD000091
     C                   ENDIF
      *
     C                   SELECT
     C     LASPIN        WHENEQ    'A'
     C     LABRTE        ADD       LARTSP        W#RATE
      *
     C     LASPIN        WHENEQ    'S'
     C     LABRTE        SUB       LARTSP        W#RATE
      *
     C     LASPIN        WHENEQ    'P'
     C                   EVAL(H)   W#RATE = LARTSP * LABRTE / 100
     C                   ENDSL
      *
     C                   Z-ADD     MDAT          ZIEND
      *
     C     ADDI          IFEQ      'B'
     C                   ADD       1             ZIEND
     C                   ENDIF
      *
     C                   CALLB     'GLINTC'
     C                   PARM      LAVDAT        ZIBEG
     C                   PARM                    ZIEND
     C                   PARM      LACALC        ZICALC
     C                   PARM      LAPRAM        ZIAMT
     C                   PARM      W#RATE        ZIRATE
     C                   PARM                    ZINTR
      *
     C                   Z-ADD     ZINTR         LAINTA
     C                   ENDIF
      *
     C     CEU020        IFEQ      'Y'
     C                   MOVE      'N'           LAECIN
     C                   ENDIF
      *
     C                   MOVE      FOTranId      LAFRNT
     C                   MOVE      FOAssocId     LAAFRT
     C                   MOVE      RepairLoc     LAREPA
      *
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRVCNSP - Validate Contractual Spread/Sign                   *                       CRE073
      *****************************************************************                       CRE073
     C     SRVCNSP       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   IF        SVBRTE <> *ZERO                                            CRE073
     C                   EVAL      PBaseRate = %CHAR(SVBRTE)                                  CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        SVBRTT <> *ZERO                                            CRE073
     C                   EVAL      PBaseCode = %CHAR(SVBRTT)                                  CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    PBaseRate                                    CRE073
     C                   PARM                    PBaseCode                                    CRE073
     C                   PARM                    DDFXRT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDCNSG                                       CRE073
     C                   PARM      *ZERO         TMCNSP                                       CRE073
     C                   PARM      'LOAN  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurSet                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDCNSPOK                                     CRE073
     C                   PARM                    DDCNSGOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRVRDMT - Validate Rounding Method                            *                      CRE073
      *****************************************************************                       CRE073
     C     SRVRDMT       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      'LOAN  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDRDMTOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRVRDFD - Validate Rounding Fraction/Decimal                 *                       CRE073
      *****************************************************************                       CRE073
     C     SRVRDFD       BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM      'LOAN  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDRDFDOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPRT - Compute for the new spread rate based on the        *                       CRE073
      *           rounding rules                                      *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPRT        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    SVBRTE                                       CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDCNSG                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      *ZERO         PNewSpread                                   CRE073
     C                   PARM      *ZERO         PFinalRate                                 AR847249
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
                                                                                              CRE073
     C**********         IF        PFinalRate <= 0 AND                             AR847249 AR947093
     C**********                   DDRDMT <> *BLANKS                               AR847249 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      Idx = Idx + 1                                   AR847249 AR947093
     C**********         EVAL      FldNameArr(Idx) = 'DDRDMT'                      AR847249 AR947093
     C**********         EVAL      MsgIDArr(Idx)   = 'USS0015'                     AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaArr(Idx) = %EDITC(PFinalRate:'J')         AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        PNewSpread = *ZERO                                         CRE073
     C**********         EVAL      DDRTSP = *BLANKS                                  CRE073 AR965133
     C                   EVAL      DDRTSP = '0'                                             AR965133
     C                   EVAL      LASPIN = DDCNSG                                            CRE073
     C                   ELSEIF    PNewSpread < *ZERO                                         CRE073
     C                             AND DDCNSG <> 'P'                                          CRE073
     C                   EVAL      DDRTSPOK = 'N'                                           AR945263
     C                   ADD       1             WIdx                                       AR945263
     C                   EVAL      WFldNamArr(WIdx) = 'DDRTSP'                              AR945263
     C                   EVAL      WMsgIdArr(WIdx)  = 'USS0016'                             AR945263
     C**********         EVAL      WMsgDtaArr(WIdx) = %EDITC(PNewSpread:'J')       AR945263 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(PNewSpread:'J')                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
                                                                                            AR945263
     C                   EVAL      PNewSpread = %ABS(PNewSpread)                              CRE073
     C                   EVAL      DDRTSP = %CHAR(PNewSpread)                                 CRE073
                                                                                              CRE073
     C                   IF        DDCNSG = 'A'                                               CRE073
     C                   EVAL      LASPIN = 'S'                                               CRE073
     C                   ELSEIF    DDCNSG = 'S'                                               CRE073
     C                   EVAL      LASPIN = 'A'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      LASPIN = DDCNSG                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDRTSP = %CHAR(PNewSpread)                                 CRE073
     C                   EVAL      LASPIN = DDCNSG                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   Z-ADD     PNewSpread    LARTSP                                       CRE073
     C                   Z-ADD     PNewSpread    WSPRT                                        CRE073
     C                   MOVEL     DDRTSP        WRTSP                                        CRE073
     C**********         ENDIF                                                     AR847249 AR947093
     C                   ELSE                                                                 CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************
      /EJECT
      *****************************************************************
      *  INIT - Reset error information                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIDArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Reset warning flags
     C     SaveDDLOAN    IFNE      DDLOAN
     C     SaveDDVDAT    ORNE      DDVDAT
     C     SaveDDATYP    ORNE      DDATYP
     C     SaveDDSEQN    ORNE      DDSEQN
     C     SaveDDACTN    ORNE      DDACTN
     C**********         Z-ADD     *ZERO         WVDAYNO                                     BUG4351
     C**********         Z-ADD     *ZERO         WVFACMT          13 0                       BUG4351
     C**********         Z-ADD     *ZERO         WVCAAMT          13 0                       BUG4351
     C                   MOVE      *BLANKS       WLASTS
     C                   ENDIF
      *
      ** Initalise arrays
     C                   MOVE      *ALL'0'       FB_OAM
     C                   MOVE      *ALL'0'       FB_RUN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Module Initialisation routine                        *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST

      ** Transaction information (DS) from source system  (screen format)
     C                   PARM                    LoamScnFmt

      ** Current loan amendment in file format from caller
     C                   PARM                    CurFilLoam

      * File receive instructions
      * File payment instructions
     C                   PARM                    S_REC
     C                   PARM                    S_PAY

      ** Loan 'A' & 'B' formats
     C                   PARM                    LoanCSave
     C                   PARM                    LoanKSave

      ** Facility 'A' & 'B' formats
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB

      ** Front Office Transaction Id., Associated Front Office Transaction Id.
      ** Repair Location
     C                   PARM                    FOTranId         20
     C                   PARM                    FOAssocId        20
     C                   PARM                    RepairLoc         1

      ** Date format indicator / local currency / run day
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    WRNDAY            5 0

      ** Analytical Accounting
     C                   PARM                    BGN0ST            1

      * Authorise amends / authorise principal tfr / base rate change
     C                   PARM                    BPLMAU            1
     C                   PARM                    BPTPAU            1
     C                   PARM                    BPBRCF            1

      * Tolerance for funding rate
     C***************    PARM                    FTTFRT            3 0          213496
     C                   PARM                    WFTTFRT           3            213496

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

      * Calling module code
     C                   PARM                    CallModCod        3

      ** Features
     C                   PARM                    CDE002            1
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CLE014            1
     C                   PARM                    CLE023            1
     C                   PARM                    CLE030            1                          CLE030
     C                   PARM                    CEU004            1
     C                   PARM                    CEU020            1

      ** Valid Loan Amendment layout (DS) from/to caller
     C                   PARM                    ValidLoam
      *
     C                   MOVE      WFTTFRT       FTTFRT            3 0          213496
      *
      ** Klist's
     C     KLKEY         KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WRCDT             1
      *
     C     K#LM11        KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WKVDT             5 0
      *
     C     KLAKEY        KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WKVDT             5 0
     C                   KFLD                    WKLSN             3 0
      *
     C     KFCLT         KLIST
     C**********         KFLD                    WFCNM             6 0                        CSD027
     C                   KFLD                    WFCNM             6                          CSD027
     C                   KFLD                    WFACT             3 0
     C                   KFLD                    WFNUM             2 0
     C                   KFLD                    WFRTP             1
      *
     C     KEYFLA        KLIST
     C                   KFLD                    SVFCUS
     C                   KFLD                    SVFTYP
     C                   KFLD                    SVFSEQ
      *
     C     KEYCAA        KLIST
     C                   KFLD                    FA_CANM
     C                   KFLD                    FA_CAFT
     C                   KFLD                    FA_CAFN
      *
     C     BCKEY         KLIST
     C                   KFLD                    CRCY
     C                   KFLD                    BCCOD
      *                                                                                       243251
     C     BCKEY1        KLIST                                                                243251
     C                   KFLD                    CRCY                                         243251
     C                   KFLD                    BCCOD                                        243251
     C                   KFLD                    VDAYNO                                       243251
      *
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
      *                                                                                      BUG3760
     C     KLOAN         KLIST                                                                CLE134
     C                   KFLD                    WKLN2             6                          CLE134
                                                                                              CLE134
      ** Initialise program name
     C                   MOVEL     'LELOAMVAL'   DBPGM
      *
      /COPY WNCPYSRC,LELOAMV027
      *                                                                                       CLE025
      ** Check if Credit Lines feature is installed                                           CLE025
      *                                                                                       CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       @RtCd                                        CLE025
     C                   PARM      '*VERIFY'     @Optn                                        CLE025
     C                   PARM      'CLE025'      @SARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
      *                                                                                       CLE025
     C                   IF        @RtCd = *BLANKS                                            CLE025
     C                   MOVEL     'Y'           CLE025            1                          CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVEL     'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE106
      ** Check if CLE134 is installed                                                         262461
     C                   CALLB     'AOSARDR0'                                                 262461
     C                   PARM      *BLANKS       @RtCd                                        262461
     C                   PARM      '*VERIFY'     @Optn                                        262461
     C                   PARM      'CLE134'      @SARD                                        262461
     C     SCSARD        PARM      SCSARD        DSFDY                                        262461
                                                                                              262461
     C                   IF        @RtCd = *BLANKS                                            262461
     C                   MOVEL     'Y'           CLE134            1                          262461
     C                   ELSE                                                                 262461
     C                   MOVEL     'N'           CLE134                                       262461
     C                   ENDIF                                                                262461
                                                                                              262461
      ** Check if CLE106 is installed                                                         CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RtCd                                        CLE106
     C                   PARM      '*VERIFY'     @Optn                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RtCd = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE042
      ** Check if CLE042 is installed                                                         CLE042
                                                                                              CLE042
     C                   MOVE      'N'           CLE042            1                          CLE042
     C                   CALLB     'AOSARDR0'                                                 CLE042
     C                   PARM      *Blanks       @RtCd                                        CLE042
     C                   PARM      '*VERIFY'     @Optn                                        CLE042
     C                   PARM      'CLE042'      @SARD                                        CLE042
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE042
                                                                                              CLE042
     C                   IF        @RtCd = *Blanks                                            CLE042
     C                   EVAL      CLE042 = 'Y'                                               CLE042
     C                   ENDIF                                                                CLE042
                                                                                              CLE035
      ***Check*if*CLE035*is*installed*********************************               CLE035 BUG10392
      ** Check if CLE036 is installed                                                       BUG10392
                                                                                              CLE035
     C**********         EVAL      CLE035 = 'N'                                      CLE035 BUG10392
     C                   EVAL      CLE036 = 'N'                                             BUG10392
     C                   CALLB     'AOSARDR0'                                                 CLE035
     C                   PARM      *Blanks       @RtCd                                        CLE035
     C                   PARM      '*VERIFY'     @Optn                                        CLE035
     C**********         PARM      'CLE035'      @SARD                               CLE035 BUG10392
     C                   PARM      'CLE036'      @SARD                                      BUG10392
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE035
                                                                                              CLE035
     C                   IF        @RtCd = *Blanks                                            CLE035
     C**********         EVAL      CLE035 = 'Y'                                      CLE035 BUG10392
     C                   EVAL      CLE036 = 'Y'                                             BUG10392
     C                   ENDIF                                                                CLE035
      *                                                                                      BUG3722
      ** Check if CLE028 is installed                                                        BUG3722
      *                                                                                      BUG3722
     C                   CALLB     'AOSARDR0'                                                BUG3722
     C                   PARM      *BLANKS       @RtCd                                       BUG3722
     C                   PARM      '*VERIFY'     @Optn                                       BUG3722
     C                   PARM      'CLE028'      @SARD                                       BUG3722
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3722
      *                                                                                      BUG3722
     C                   IF        @RtCd = *BLANKS                                           BUG3722
     C                   MOVEL     'Y'           CLE028            1                         BUG3722
     C                   ELSE                                                                BUG3722
     C                   MOVEL     'N'           CLE028                                      BUG3722
     C                   ENDIF                                                               BUG3722
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      **  Access the SDSTAT Data Area.                                                       BUG3760
      *                                                                                      BUG3760
     C                   IN        SDSTAT                                                    BUG3760
      *                                                                                      BUG3760
      **  Access SAR details to see if CSD015 is switched on.                                BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 906                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      **  Access SAR details to see if CSC011 is switched on.                                BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSC011'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   IN        SC24X7                                                    BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSC011'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 903                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAS011
      ** Determine if SAR CAS009 is installed                                                 CAS011
                                                                                              CAS011
     C                   CALL      'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRTCD                                        CAS011
     C                   PARM      '*VERIFY '    POPTN                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBase = 904                                                CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        PRTCD = *BLANKS                                            CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   EVAL      CAS009 = 'N'                                               CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CLE056
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        CLE056
                                                                                              CLE056
     C                   EVAL      CLE056 = 'N'                                               CLE056
     C                   CALLB     'AOSARDR0'                                                 CLE056
     C                   PARM      *BLANKS       @RTCD                                        CLE056
     C                   PARM      '*VERIFY'     @OPTN                                        CLE056
     C                   PARM      'CLE056'      @SARD                                        CLE056
                                                                                              CLE056
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE056
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE056
     C                   EVAL      DBKey  = 'CLE056'                                          CLE056
     C                   EVAL      DBase  = 8                                                 CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056
                                                                                             BUG9655
      ** Determine if SAR CLE036 is installed                                                BUG9655
                                                                                             BUG9655
     C                   CALL      'AOSARDR0'                                                BUG9655
     C                   PARM      *BLANKS       PRTCD                                       BUG9655
     C                   PARM      '*VERIFY '    POPTN                                       BUG9655
     C                   PARM      'CLE036'      PSARD                                       BUG9655
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9655
                                                                                             BUG9655
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                   BUG9655
     C     *LOCK         IN        LDA                                                       BUG9655
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG9655
     C                   EVAL      DBase = 905                                               BUG9655
     C                   EVAL      DBKey = 'CLE036'                                          BUG9655
     C                   OUT       LDA                                                       BUG9655
     C                   EXSR      *PSSR                                                     BUG9655
     C                   ENDIF                                                               BUG9655
                                                                                             BUG9655
     C                   IF        PRTCD = *BLANKS                                           BUG9655
     C                   EVAL      CLE036 = 'Y'                                              BUG9655
     C                   ELSE                                                                BUG9655
     C                   EVAL      CLE036 = 'N'                                              BUG9655
     C                   ENDIF                                                               BUG9655
                                                                                              CRE073
      ** Determine if SAR CRE073 is installed                                                 CRE073
                                                                                              CRE073
     C                   CALL      'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY '    POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBase = 910                                                CRE073
     C                   EVAL      DBKey = 'CRE073'                                           CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       240968
      ***  Access bank details                                                                240968
      *                                                                                       240968
     C                   CALLB     'AOBANKR0'                                                 240968
     C                   PARM      *BLANKS       @RTCD             7                          240968
     C                   PARM      '*FIRST '     @OPTN             7                          240968
     C     SDBANK        PARM      SDBANK        DSFDY                                        240968
      *                                                                                       240968
     C     @RTCD         IFNE      *BLANKS                                                    240968
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************* 240968
     C                   MOVEL     '908'         DBASE                          * DBERR 908 * 240968
     C                   MOVEL     @OPTN         DBKEY                          ************* 240968
     C                   EXSR      *PSSR                                                      240968
     C                   END                                                                  240968
      ** Check for auto allocation of loan numbers system value.                              240968
     C                   CALLB     'AOSVALR0'                                                 240968
     C                   PARM      *BLANKS       PRtCd             7                          240968
     C                   PARM      CLAuthORED    PSysVal01                                    240968
     C                   PARM      *BLANKS       PCurSet01                                    240968
     C**********         PARM      *BLANKS       PSysVal02                             240968 244314
     C                   PARM      CLAuthSMDT    PSysVal02                                    244314
     C                   PARM      *BLANKS       PCurSet02                                    240968
     C                   PARM      *BLANKS       PSysVal03                                    240968
     C                   PARM      *BLANKS       PCurSet03                                    240968
     C                   PARM      *BLANKS       PSysVal04                                    240968
     C                   PARM      *BLANKS       PCurSet04                                    240968
     C                   PARM      *BLANKS       PSysVal05                                    240968
     C                   PARM      *BLANKS       PCurSet05                                    240968
     C                   PARM      *BLANKS       PSysVal06                                    240968
     C                   PARM      *BLANKS       PCurSet06                                    240968
     C                   PARM      *BLANKS       PSysVal07                                    240968
     C                   PARM      *BLANKS       PCurSet07                                    240968
     C                   PARM      *BLANKS       PSysVal08                                    240968
     C                   PARM      *BLANKS       PCurSet08                                    240968
     C                   PARM      *BLANKS       PSysVal09                                    240968
     C                   PARM      *BLANKS       PCurSet09                                    240968
     C                   PARM      *BLANKS       PSysVal10                                    240968
     C                   PARM      *BLANKS       PCurSet10                                    240968
                                                                                              240968
     C                   If        PRtCd <> *Blanks                                           240968
     C                   Eval      DBFile = 'SDSVALPD'                                        240968
     C                   Eval      DBase = 909                                                240968
     C                   Eval      DBKey = '*KEY    '                                         240968
     C                   ExSR      *PSSR                                                      240968
     C                   EndIf                                                                240968
     C                   MOVEL     PCurSet01     ATHORED           1                          240968
     C                   MOVEL     PCurSet02     ATHSMDT           1                          244314
      *                                                                                       240968
      *                                                                                       240408
      ** Check System Value: Use Original Borrower or Purchased From?                         240408
      ** Set up parameter so access object checks LoanCustOriginPurch                         240408
     C                   MOVEL     WPARM         SVALK1                                       240408
      * Call Access object:                                                                   240408
     C                   CALL      'AOSVALR0'                                                 240408
     C                   PARM                    RTNCDE            7                          240408
     C                   PARM                    SVALK1           20                          240408
     C                   PARM                    SVAL1           200                          240408
     C                   PARM                    SVALK2           20                          240408
     C                   PARM                    SVAL2           200                          240408
     C                   PARM                    SVALK3           20                          240408
     C                   PARM                    SVAL3           200                          240408
     C                   PARM                    SVALK4           20                          240408
     C                   PARM                    SVAL4           200                          240408
     C                   PARM                    SVALK5           20                          240408
     C                   PARM                    SVAL5           200                          240408
     C                   PARM                    SVALK6           20                          240408
     C                   PARM                    SVAL6           200                          240408
     C                   PARM                    SVALK7           20                          240408
     C                   PARM                    SVAL7           200                          240408
     C                   PARM                    SVALK8           20                          240408
     C                   PARM                    SVAL8           200                          240408
     C                   PARM                    SVALK9           20                          240408
     C                   PARM                    SVAL9           200                          240408
     C                   PARM                    SVALK0           20                          240408
     C                   PARM                    SVAL10          200                          240408
      * If the system value is not found then default value to 'P'                            240408
     C     RTNCDE        IFNE      '        '                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ELSE                                                                 240408
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              240408
     C                   MOVEL     SVAL1         WRK01             1                          240408
     C     WRK01         IFEQ      'O'                                                        240408
     C                   MOVE      'O'           PPCUST            1                          240408
     C                   ELSE                                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ENDIF                                                                240408
     C                   ENDIF                                                                240408
      ***********                                                                    BUG11965 249197
      ***Access*Midas SD Hedging ICD File                                            BUG11965 249197
      ***********                                                                    BUG11965 249197
     C***********        Call      'AOHEDGR0'                                        BUG11965 249197
     C***********        Parm      *BLANKS       PRTCD                               BUG11965 249197
     C***********        Parm      '*FIRST '     @Optn                               BUG11965 249197
     C*****SDHEDG        Parm      SDHEDG        DSFDY                               BUG11965 249197
      ***********                                                                    BUG11965 249197
      ***Database Error                                                              BUG11965 249197
      ***********                                                                    BUG11965 249197
     C***********        If        PRTCD <> *Blanks                                  BUG11965 249197
     C***********        Eval      DBKey  =  @Optn                                   BUG11965 249197
     C***********        Eval      DBFile =  'SDHEDGPD'                              BUG11965 249197
     C***********        Eval      DBase  =  908                                     BUG11965 249197
     C***********        Out       LDA                                               BUG11965 249197
     C***********        Exsr      *PSSR                                             BUG11965 249197
     C***********        EndIf                                                       BUG11965 249197
      *                                                                                      BUG3760
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      *
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2002
**CTDATA POWR
0000001
0000010
0000100
0001000
0010000
0100000
1000000
