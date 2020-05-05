     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility first screen validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  LEFCIP1VL -  Facility First screen  Validation               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. CLE160             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD034007           Date 17Jun15               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD024398           Date 11May14               *
      *                 MD000091           Date 09May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR741374           Date 11Apr11               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR870095           Date 02Dec11               *
      *                 AR865343           Date 16Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 AR787620           Date 10Jun11               *
      *                 AR747727           Date 19Apr11               *
      *                 CLE064             Date 06Dec10               *
      *                 AR740355           Date 28Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22020           Date 02Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245541             Date 06Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 239211             Date 31Aug06               *
      *                 242261             Date 14Sep06               *
      *                 BUG11995           Date 03Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 05Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10941           Date 24Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 BUG7905            Date 24Aug05               *
      *                 BUG8549            Date 22Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6435            Date 11May05               *
      *                 BUG6984            Date 05May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5863            Date 14Feb04               *
      *                 CLE041             Date 15Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5132            Date 20Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG4351            Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3732            Date 20Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG774             Date 19Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CSF002             Date 11Aug03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  CLE160 - Remove Default for Revolving Credit Indicator       *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD034007 - Make sure that CLE147 changes was implemented     *
      *             properly when changing facility into CA.          *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD024398 - API Performance Optimisation                      *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR741374 - System allowed a stand-alone facility with out-   *
      *             standing loan transactions to be converted to TR  *
      *             and linked to CA. Codes were added to prohibit    *
      *             conversion to TR. (Child: AR741375)               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR870095 - Credit Lines Warning was generated even if        *
      *             structure is newly created                        *
      *  AR865343 - Tranche event from previous Credit Agreement      *
      *             was not removed in FACHISA file                   *
      *  CLE147 - Aggregate Facility                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00088                                 *
      *  AR747727 - Two Monthly Frequency is not accepted             *
      *             (Child: AR747728)                                 *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  AR740355 - Incorrect values in Previous and Penultimate Date *
      *             (Child: AR740356)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP               *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  BUG22020 - Wrong warning message for Date Expires            *
      *  245541 - Review date being retained from previously used     *
      *           facility.  Need to clear work field.                *
      *  CRE026 - Consumer Banking                                    *
      *  239211 - Amending user is not captured during closure of     *
      *           facility.  Recompile over changes in LEFCSPPD.      *
      *  242261   - Remove part of BUG10941. Only check if Credit     *
      *             Agreement is live. Tranches can still be entered  *
      *             even if the CA is not yet authorised.             *
      *  BUG11995 - LER0057 message too vague - pass back ccy name    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10941 - Check if Credit Agreement is an authorized and    *
      *             live facility.                                    *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A. Added     *
      *           validation on Over-line amount.                     *
      *  BUG7905 - Message should be about start date not value date  *
      *  BUG8549 - OCBC 83037 - Invalid value reported in LE0300P1.   *
      *            Date of Last Financial Statement Temporary field   *
      *            (W#DLFS) is initialized to zeroes.                 *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG6435 - Only check allowable currencies if currency select *
      *            indicator is 'Y'                                   *
      *  BUG6984 - Ignore allowable currency validation if Tranche    *
      *            currency is same as the Credit Agreement currency  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5132 - Not allowed to link a tranche to a credit agreement*
      *            if tranche ccy is not an allowable ccy in the CA   *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collaterised Lending (Recompile)  *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3732- If Credit Agreement's multi-customer, multi-branch  *
      *           and multi-currency is 'N', then tranche's customer  *
      *           branch and currency should match CA's.  Patterned   *
      *           from 205168 in LE2020                               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG774 - Problem with negative facility amounts              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CSF002 - Global layer.                                       *
      *         - Replace previous ZBACT* parameters with the new     *
      *           unique code.                                        *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      **  Facilities Details file
     FFCLTY     IF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
      **  Facility Amendment Retrieval Index
     FLEFCAML0  IF   E           K DISK    INFSR(*PSSR)

     FLEAGAML0  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMDF0)                         CLE041
     F                                     PREFIX(AGL0_)                                      CLE041
      **  Credit Agreement File
     FLEFCLTL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL9)
     F                                     PREFIX(LE)
      **  Fees Master file
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)

      **  Customer/Facility/Loan Cross-Reference file
     FLEREF     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RF)

      **  Loan Master file
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CL)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     IGNORE(CLOANCKF)

      **  Live Utilisation Retrieval Index
     FLEMNFUL6  IF   E           K DISK    INFSR(*PSSR)

      **  Deals Extension Detail Files by Facility                                            CLE147
     FDLDLDQL0  IF   E           K DISK    INFSR(*PSSR)                                       CLE147
     F                                     PREFIX(DQ)                                         CLE147
                                                                                              CLE147
      **  Accounts Master Detail File by Facility                                             CLE147
     FACCNTLB   IF   E           K DISK    INFSR(*PSSR)                                       CLE147
     F                                     PREFIX(AC)                                         CLE147
                                                                                              CLE147
      **  All Deals File                                                                      CLE147
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)                                       CLE147
     F                                     PREFIX(DL)                                         CLE147
                                                                                              CLE147
      **  Manual Facility Utilization File                                                    CLE147
     FLEMNFULA  IF   E           K DISK    INFSR(*PSSR)                                       CLE147
     F                                     RENAME(LEMNFUPF:LEMNFUP1)                          CLE147
     F                                     PREFIX(FC)                                         CLE147
                                                                                              CLE147
      **  Loans Detail File                                                                   CLE147
     FLELOANLC  IF   E           K DISK    INFSR(*PSSR)                                       CLE147
     F                                     RENAME(CLOANCLF:CLOANCL1)                          CLE147
     F                                     PREFIX(CL)                                         CLE147
                                                                                              CLE147
      **  Compile time arrays

     D/COPY ZSRSRC,ZALIGNZ1LE
      *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(75)

      ** Constant to hold input parameter for AOSVALR0                                        CLE160
     D DftRevCRInd     C                   CONST('DftRevolvingCRInd')                         CLE160
                                                                                              CLE160
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
                                                                                             BUG5132
      ** Array of allowable currencies                                                       BUG5132
     D ArrALCY         S              3A   DIM(12)                                           BUG5132

      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDACTNOK                      1A
     D  DDFSTSOK                      1A
     D  DDCSSNOK                      1A
     D  DDFACTOK                      1A
     D  DDFCNOOK                      1A
     D  DDBRCAOK                      1A
     D  DDFCCYOK                      1A
     D  DDFAMTOK                      1A
     D  DDOVPCOK                      1A
     D  DDFCTIOK                      1A
     D  DDDTAPOK                      1A
     D  DDRVCROK                      1A
     D  DDMCCYOK                      1A
     D  DDSECIOK                      1A
     D  DDDTEXOK                      1A
     D  DDCRSKOK                      1A
     D  DDMCSIOK                      1A
     D  DDNACDOK                      1A
     D  DDMBFCOK                      1A
     D  DDRVCDOK                      1A
     D  DDDLFSOK                      1A
     D  DDNOMROK                      1A
     D  DDRVDTOK                      1A
     D  DDRVFROK                      1A
     D  DDRVDYOK                      1A
     D  DDACOFOK                      1A
     D  DDPRFCOK                      1A
     D  DDORBROK                      1A
     D  DDTRCAOK                      1A
     D  DDCANMOK                      1A
     D  DDCAFTOK                      1A
     D  DDCAFNOK                      1A
     D  DDNAR1OK                      1A
     D  DDNAR2OK                      1A
     D  DDNAR3OK                      1A
     D  DDNAR4OK                      1A
     D  DDBTINOK                      1A
     D  DDBLDYOK                      1A
     D  DDACSQOK                      1A
     D  DDOVAMOK                      1A                                                      CLE034
      *                                                                                       CER020
      ** Fields added for CER020                                                              CER020
     D  CER020                        1A                                                      CER020
     D  PErrorFlag                    1A                                                      CER020
     D  PZDayNo                       5P 0                                                    CER020
     D  PZDate                        6P 0                                                    CER020
     D  PZDateA                       6A                                                      CER020
     D  PZADate                       7A                                                      CER020
     D  WCExpRDt                      5P 0                                                    CER020
     D  WCExpDat                      6A                                                      CER020
     D  WRdPEXD                       5P 0                                                    CER020
     D  WRdPNXD                       5P 0                                                    CER020
     D  PRtCd                         7A                                                      CER020
     D  POptn                         7A                                                      CER020
     D  PSard                         6A                                                      CER020
     D  WCSExpDt                      6P 0                                                    CER020
     D**KFCNUM**                      6P 0                                             CER020 CER059
     D  KFCNUM                        6A                                                      CER059
     D  KFFACT                        3P 0                                                    CER020
     D  KFFCNO                        2P 0                                                    CER020
     D  KFRCDT                        1A                                                      CER020

     D SDFACT        E DS                  EXTNAME(SDFACTPD)
      **   FACILITY TYPE

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      **  CUSTOMER LENDING DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** BRANCH CODES

     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      **   COUNTRY

     D SDALTN        E DS                  EXTNAME(SDALTNPD)
      ** ALTERNATE NAME AND ADDRESSES

     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      **   ACCOUNT OFFICER DETAILS

     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      **   PROFIT CENTRES

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      **   CUSTOMER

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **   CURRENCY TYPE

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE034
                                                                                              CLE034
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
      * Valid Facility FM layout -> FCLTYFM

     D ValidFacn     E DS                  EXTNAME(LEVFCINPD)
      * Valid Facility FN layout -> FCLTYFN

     D TranInPrim    E DS                  EXTNAME(LEFCPPPD)
      * Incoming Transaction

     D TranInSeco    E DS                  EXTNAME(LEFCSPPD)                                  CLE106
      * Incoming Transaction 2                                                                CLE106
                                                                                              CLE106
      * (Current) Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM) PREFIX(@@)

      * (Current) Facility record FN in file Format
     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN) PREFIX(@@@)

     D ZMUSER          DS            17
     D  USRID                  1     10                                                     MD024398
     D  USRBCH                11     13
      * ZMUSER data layout
     D  DBRN                  11     13

     D RUNDAT          DS            13
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  AGMBIN                13     13
      * Rundate data area

     D                 DS
     D  RUN                    1     30P 0
     D                                     DIM(10)                              FCTLY DRAW DATES
     D  RUN0                   1      3P 0
     D  RUN1                   4      6P 0
     D  RUN2                   7      9P 0
     D  RUN3                  10     12P 0
     D  RUN4                  13     15P 0
     D  RUN5                  16     18P 0
     D  RUN6                  19     21P 0
     D  RUN7                  22     24P 0
     D  RUN8                  25     27P 0
     D  RUN9                  28     30P 0
     D                 DS
     D  OAM                    1     70P 0
     D                                     DIM(10)                              FCLTY O/S AMTS.
     D  OAM1                   1      7P 0
     D  OAM2                   8     14P 0
     D  OAM3                  15     21P 0
     D  OAM4                  22     28P 0
     D  OAM5                  29     35P 0
     D  OAM6                  36     42P 0
     D  OAM7                  43     49P 0
     D  OAM8                  50     56P 0
     D  OAM9                  57     63P 0
     D  OA10                  64     70P 0

      ** DS for Credit Agreement Details                                                      CLE147
     D CADetails       DS            33                                                       CLE147
     D  DDOAFL                        1A                                                      CLE147
     D  DDOANM                       10A                                                      CLE147
     D  DDOAFT                        3A                                                      CLE147
     D  DDOAFN                        2A                                                      CLE147
     D  DDNAFL                        1A                                                      CLE147
     D  DDNANM                       10A                                                      CLE147
     D  DDNAFT                        3A                                                      CLE147
     D  DDNAFN                        2A                                                      CLE147
     D  DDAXTN                        1A                                                      CLE147
                                                                                              CLE147
      * DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
                                                                                             BUG5132
     D n               S              1  0                                                   BUG5132
     D CLE025          S              1A                                                      CLE041
      *                                                                                       CLE034
      ** CLE034                                                                               CLE034
      *                                                                                       CLE034
     D CLE034          S              1A                                                      CLE034
     D CLE106          S              1A                                                      CLE106
     D CLE147          S              1A                                                      CLE147
     D CLE160          S              1A                                                      CLE160
      *                                                                                       CLE160
     D DftCRInd        S              1A                                                      CLE160
     D W#NANM          S              6A                                                      CLE147
     D W#NAFT          S              3  0                                                    CLE147
     D W#NAFN          S              2  0                                                    CLE147
     D W#LIVE          S              1A                                                      CLE147
     D KDLNO           S              6  0                                                    CLE147

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** Parameters for call to AOSVALR0                                                      CLE160
     D PSysVal01       S             20A                                                      CLE160
     D PCurSet01       S            200A                                                      CLE160
     D PSysVal02       S             20A                                                      CLE160
     D PCurSet02       S            200A                                                      CLE160
     D PSysVal03       S             20A                                                      CLE160
     D PCurSet03       S            200A                                                      CLE160
     D PSysVal04       S             20A                                                      CLE160
     D PCurSet04       S            200A                                                      CLE160
     D PSysVal05       S             20A                                                      CLE160
     D PCurSet05       S            200A                                                      CLE160
     D PSysVal06       S             20A                                                      CLE160
     D PCurSet06       S            200A                                                      CLE160
     D PSysVal07       S             20A                                                      CLE160
     D PCurSet07       S            200A                                                      CLE160
     D PSysVal08       S             20A                                                      CLE160
     D PCurSet08       S            200A                                                      CLE160
     D PSysVal09       S             20A                                                      CLE160
     D PCurSet09       S            200A                                                      CLE160
     D PSysVal10       S             20A                                                      CLE160
     D PCurSet10       S            200A                                                      CLE160
                                                                                              CLE160
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Get ZMUSER to access default branch.                                                BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
     C                   EXSR      RESETERRS

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C**********         CALL      'SFC000026'                                       CAP084 MD024398
     C**********         PARM      *BLANKS       USER             10                 CAP084 MD024398
      *                                                                         CAP084
     C**********         IF        USER <> *BLANKS                                   CAP084 MD024398
     C**********         EVAL      PSUSER = USER                                     CAP084 MD024398
     C                   IF        USRID <> *BLANKS                                         MD024398
     C                   EVAL      PSUSER = USRID                                           MD024398
     C                   ENDIF                                                  CAP084

      ** Call Validation Modules in Sequence
      *
      ** Validate Branch number
     C     DDACTN        IFEQ      'I'
     C                   EXSR      VBrca
     C                   ENDIF
      ** Validate Facility Currency
     C                   EXSR      VFccy
      ** Validate Facility Amount
     C                   EXSR      VFamt
      ** Validate Overline %
     C                   EXSR      VOvpc
      *                                                                                       CLE034
      ** Validate Overline Amount                                                             CLE034
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EXSR      VOvam                                                      CLE034
     C                   ENDIF                                                                CLE034
      ** Validate Facility Cmmt Ind
     C                   EXSR      VFcti
      ** Validate Start Date
     C                   EXSR      VDtap
      ** Validate Date expired
     C                   EXSR      VDtex
      ** Validate Revolving credit
     C                   EXSR      VRvcr
      ** Validate Secured
     C                   EXSR      VSeci
      ** Validate Tranche/Credit agreement ind
     C     CLE005        Ifeq      'Y'
     C                   EXSR      VTrca
     C                   End
      ** Validate Multi currency
     C                   EXSR      VMccy
      ** Validate Multi customer
     C                   EXSR      VMCSI
      ** Validate Country of Risk
     C                   EXSR      VCrsk
      ** Validate Alt n/a
     C                   EXSR      VNacd
      ** Validate Multi Branch
     C                   EXSR      VMbfc
      ** Validate Rev. CR Date changed
     C                   EXSR      VRvcd
      ** Validate Date of Last Fin.Stmt
     C                   EXSR      VDlfs
      ** Validate Nominal rate
     C                   EXSR      VNomr
      ** Validate Review date
     C                   EXSR      VRvdt
      ** Validate Frequency
     C                   EXSR      VRvfr
      ** Validate Day no
     C                   EXSR      VRVDY
      ** Validate Account officer
     C                   EXSR      VAcof
      ** Validate Profit Center
     C                   EXSR      VPrfc
      ** Validate Originating Branch
     C                   EXSR      VOrbr
      ** Validate Bill/Telex ind
     C                   EXSR      VBtin
      ** Validate Billing days
     C                   EXSR      VBldy
      ** Validate Account sequence
     C                   EXSR      VAcsq

      *                                                                                       CER020
      ** Default and Validate the Previous and Penultimate Expiry Dates                       CER020
      ** if feature is installed                                                              CER020
      *                                                                                       CER020
     C**********         IF        CER020 = 'Y'                                      CER020 AR740355
     C                   IF        CER020 = 'Y' AND                                         AR740355
     C                             DDDTEXOK <> 'N'                                          AR740355
     C                   EXSR      VPExpDat                                                   CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   EXSR      UPDATERRS
      *
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBRCA   - Validate Branch
      *****************************************************************
     C     VBRCA         BEGSR

      ** If branch is not yet defined
      ** Default branch from ZMUSER
      *
     C                   If        DDBrca=*Blanks
     C                   Move      USRBCH        DDBrca
     C                   EndIf
      *
      ** Branch code if entered must exist on SDBRCHPD file
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDBRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0017'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDBRCA
     C                   ENDIF
      *
      **  Validate facility branch if not an insert
     C     AGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
      *
     C     Respmode      IFEQ      'B'
     C                   CALL      'ZBACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      DDBRCA        @ZBR              3
     C                   PARM                    @USER            10
     C**********         PARM                    @ZMGRP            4 0                        CSF002
     C**********         PARM                    @ZICDE            4                          CSF002
     C                   PARM                    @UNQCDE          10                          CSF002
     C                   PARM                    @ERR              1 0
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      DDBRCA        @ZBR              3
     C                   PARM                    @ERR              1 0
     C                   ENDIF
      *
     C     @ERR          IFNE      *ZERO
     C     @ERR          IFEQ      1
     C                   Move      'N'           DDBRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0010'     MsgIDXAr(Idx)
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   Move      'N'           DDBRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0009'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** If an error was found, set the return code appropriately
     C     DDBRCAOK      IFEQ      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else
     C                   Movel     A8MQSM        W#1ST3            3
      *                                                                                       CAP084
      ** If A8MQSM is blanks then move in the branch code instead                             CAP084
      *                                                                                       CAP084
     C     A8MQSM        IfEq      *BLANKS                                                    CAP084
     C                   Move      A8BRCD        W#1ST3                                       CAP084
     C                   EndIf                                                                CAP084
      *                                                                                       CAP084
     C                   EndIf

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFCCY   - Validate currency
      *****************************************************************
     C     VFCCY         BEGSR

      **   Must be a valid code on SDCURRPD
     C                   MOVE      DDFCCY        CKEY
      *
     C                   MOVE      '*BLANKS'     @RTCD
     C                   CALLB     'AOCURRR0'    PLIST2
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDFCCYOK
     C                   Add       1             Idx
     C                   Movel     'DDFCCY'      FldNamXAr(Idx)
     C                   Movel     'LEF0018'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      A6CYCD        DDFCCY
     C                   Z-ADD     A6NBDP        W#NBDP
     C                   MOVE      A6NBDP        WWNBDP            1
      *
     C     A6DLCI        IFEQ      'N'
     C                   Move      'N'           DDFCCYOK
     C                   Add       1             Idx
     C                   Movel     'DDFCCY'      FldNamXAr(Idx)
     C                   Movel     'LEF0057'     MsgIDXAr(Idx)
     C**********         Movel     A6CYCD        MsgDtaXAr(Idx)                    BUG11995 MD000091
     C                   EVAL      BLen = %Len(%Trim(A6CYCD))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(A6CYCD)                   MD000091
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFAMT   - Validate Facility amount
      *****************************************************************
     C     VFAMT         BEGSR

     C                   MOVE      'N'           FacAmChg
      *
      **  Must be valid per ZALIGN
     C                   MOVE      *BLANKS       ZFIELD
      *                                                                                       BUG774
      ** If negative sign is part of the amount string then remove before going to ZALIGN     BUG774
     C                   Eval      WSIGN = *blanks                                            BUG774
     C                   MOVE      DDFAMT        SVDDFAMT         15                          BUG774
      *                                                                                       BUG774
     C     1             SUBST     DDFAMT        WSIGN             1                          BUG774
     C     WSIGN         IfEq      '-'                                                        BUG774
     C     14            SUBST     DDFAMT:2      DDFAMT                                       BUG774
     C                   Else                                                                 BUG774
     C     1             SUBST     DDFAMT:15     WSIGN                                        BUG774
     C     WSIGN         IfEq      '-'                                                        BUG774
     C                   Eval      WDDFAMT = *blanks                                          BUG774
     C     14            SUBST     DDFAMT        WDDFAMT          14                          BUG774
     C                   EvalR     DDFAMT = WDDFAMT                                           BUG774
     C                   EndIf                                                                BUG774
     C                   EndIf                                                                BUG774
      *                                                                                       BUG774
     C                   MOVE      DDFAMT        ZFIELD
     C                   Z-ADD     W#NBDP        ZADEC
     C     13            SUB       W#NBDP        ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   Move      'N'           DDFAMTOK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT'      FldNamXAr(Idx)
     C                   Movel     'LEF0019'     MsgIDXAr(Idx)
     C                   ELSE
     C     *LIKE         DEFINE    FAMT          W#FAMT
     C                   MOVE      ZFIELD        W#FAMT
      *                                                                                       BUG774
     C     WSIGN         IFEQ      '-'                                                        BUG774
     C                   Z-SUB     W#FAMT        W#FAMT                                       BUG774
     C                   Eval      DDFAMT = SVDDFAMT                                          BUG774
     C                   ENDIF                                                                BUG774
      *                                                                                       BUG774
     C     W#FAMT        IFLE      0

      ** To allow validation of amount only during Insert
      *
     C     DDACTN        ANDEQ     'I'
                                                                                              CLE106
     C                   IF        CLE106 = 'N' Or                                            CLE106
     C                             CLE106 = 'Y' And                                           CLE106
     C                             (DDPRTR = 'A' Or DDPRTR = *Blanks)                         CLE106
     C                   Move      'N'           DDFAMTOK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT'      FldNamXAr(Idx)
     C                   Movel     'LEF0019'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ELSE
      *  determine wheather facility has changed
     C     DDACTN        IFEQ      'A'
     C     @@FAMT        IFNE      W#FAMT
     C                   MOVE      'Y'           FacAmChg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VOVPC   - Validate Overline %
      *****************************************************************
     C     VOVPC         BEGSR

      **  Must be valid per ZALIGN
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDOVPC        ZFIELD
     C                   Z-ADD     3             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   Move      'N'           DDOVPCOK
     C                   Add       1             Idx
     C                   Movel     'DDOVPC'      FldNamXAr(Idx)
     C                   Movel     'LEF0020'     MsgIDXAr(Idx)
     C                   ELSE
     C     DDACTN        IFEQ      'I'
     C                   MOVE      ZFIELD        W#OVPC
     C                   ELSE
     C     DDACTN        IFEQ      'A'
     C     FacAmChg      ANDNE     'Y'
     C     *LIKE         DEFINE    OVPC          W#OVPC
     C                   MOVE      ZFIELD        W#OVPC
     C     @@OVPC        IFNE      W#OVPC
     C                   MOVE      'Y'           FacAmChg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFCTI   - Fclty/Cmmt Ind
      *****************************************************************
     C     VFCTI         BEGSR

      **  Must be 'C','F' OR 'G'
     C     DDFCTI        IFNE      'C'
     C     DDFCTI        ANDNE     'F'
     C     DDFCTI        ANDNE     'G'
     C                   Move      'N'           DDFCTIOK
     C                   Add       1             Idx
     C                   Movel     'DDFCTI'      FldNamXAr(Idx)
     C                   Movel     'LEF0021'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDTAP   - Validate Start date
      *****************************************************************
     C     VDTAP         BEGSR

      **  Must be valid date format
     C                   MOVE      DDDTAP        DATEA
     C                   TESTN                   DATEA                9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   Move      'N'           DDDTAPOK
     C                   Add       1             Idx
     C                   Movel     'DDDTAP'      FldNamXAr(Idx)
     C                   Movel     'LEF0023'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ** Check if Date Approved is a Holiday
      *
     C*****DDDTAP        IFNE      DAYSV2                                                    BUG4351
     C                   MOVEL     DDFCCY        ZCCY
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd        1
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDDTAPOK
     C                   ADD       1             WId
     C                   MOVEL     'DDDTAP'      WFldNmXAr(WId)
     C**********         MOVEL     'LEF0223'     WMsgIdXAr(WId)                              BUG7905
     C                   MOVEL     'LEF0136'     WMsgIdXAr(WId)                              BUG7905
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
      *
     C**********         MOVE      DDDTAP        DAYSV2            6                         BUG4351
      *
     C                   Z-ADD     ZDAYNO        W#DTAP            5 0
     C                   MOVE      ZDAYNO        WWDTAP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRVCR   - Validate Revolving CR
      *****************************************************************
     C     VRVCR         BEGSR

      ** Value must be 'Y','N' or ' '
      ** or 'T' for a 'Credit Agreement' facility.
      ** If CLE160 is ON, default RVCR field to the value in                                  CLE160
      ** system value DftRevolvingCrInd                                                       CLE160
     C     DDRVCR        IFEQ      *BLANKS
     C     CLE160        ANDEQ     'N'                                                        CLE160
     C     DDRVCR        OREQ      *BLANKS                                                    CLE160
     C     CLE160        ANDEQ     'Y'                                                        CLE160
     C     DftCRInd      ANDNE     *BLANKS                                                    CLE160
      *                                                                                       CLE160
     C     CLE160        IFEQ      'Y'                                                        CLE160
     C                   MOVEL     DftCRInd      DDRVCR                                       CLE160
     C                   ELSE                                                                 CLE160
     C                   MOVE      'N'           DDRVCR
     C                   ENDIF                                                                CLE160
      *                                                                                       CLE160
     C                   ENDIF                                                                CLE160
     C**********         ELSE                                                                 CLE160
      *
     C                   SELECT
      *
     C     CLE014        WHENEQ    'Y'
     C     DDTRCA        ANDEQ     'CA'
     C     CLE014        OREQ      'Y'                                                        CLE041
     C     DDTRCA        ANDEQ     'AG'                                                       CLE041
     C     DDRVCR        IFNE      'Y'
     C     DDRVCR        ANDNE     'N'
     C     DDRVCR        ANDNE     'T'
     C                   Move      'N'           DDRVCROK
     C                   Add       1             Idx
     C                   Movel     'DDRVCR'      FldNamXAr(Idx)
      *                                                                                       CLE160
     C     CLE160        IFEQ      'Y'                                                        CLE160
     C                   MOVEL     '5049113'     MsgIDXAr(Idx)                                CLE160
     C                   ELSE                                                                 CLE160
     C                   Movel     'LEF0350'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE160
                                                                                              CLE160
     C                   ENDIF
      *
     C                   OTHER
      *
     C     DDRVCR        IFNE      'Y'
     C     DDRVCR        ANDNE     'N'
     C     DDRVCR        ANDNE     ' '
     C     CLE160        ANDEQ     'N'                                                        CLE160
     C                   Move      'N'           DDRVCROK
     C                   Add       1             Idx
     C                   Movel     'DDRVCR'      FldNamXAr(Idx)
     C                   Movel     'LEF0026'     MsgIDXAr(Idx)
     C                   ENDIF
      *                                                                                       CLE160
     C     DDRVCR        IFNE      'Y'                                                        CLE160
     C     DDRVCR        ANDNE     'N'                                                        CLE160
     C     CLE160        ANDEQ     'Y'                                                        CLE160
     C                   Move      'N'           DDRVCROK                                     CLE160
     C                   Add       1             Idx                                          CLE160
     C                   Movel     'DDRVCR'      FldNamXAr(Idx)                               CLE160
     C                   Movel     '5049112'     MsgIDXAr(Idx)                                CLE160
     C                   ENDIF                                                                CLE160
      *                                                                                       CLE160
     C                   ENDSL
     C**********         ENDIF                                                                CLE160
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VMCCY   - Validate Multi currency
      *****************************************************************
     C     VMCCY         BEGSR

      ** Value must be 'Y' or 'N' and cannot be amended from 'Y' to 'N'
     C                   SELECT
     C     DDMCCY        WHENEQ    *BLANKS
     C     DDACTN        IFNE      'A'
     C                   MOVE      'N'           DDMCCY
     C                   ELSE
     C     @@MCCY        IFEQ      'Y'
     C     DDMCCY        ANDNE     'Y'
     C                   Move      'N'           DDMCCYOK
     C                   Add       1             Idx
     C                   Movel     'DDMCCY'      FldNamXAr(Idx)
     C                   Movel     'LEF0029'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C     DDMCCY        WHENEQ    'N'
     C     DDACTN        ANDEQ     'A'
     C     @@MCCY        ANDEQ     'Y'
     C                   Move      'N'           DDMCCYOK
     C                   Add       1             Idx
     C                   Movel     'DDMCCY'      FldNamXAr(Idx)
     C                   Movel     'LEF0029'     MsgIDXAr(Idx)

     C     DDMCCY        WHENNE    'Y'
     C     DDMCCY        ANDNE     'N'
     C                   Move      'N'           DDMCCYOK
     C                   Add       1             Idx
     C                   Movel     'DDMCCY'      FldNamXAr(Idx)
     C                   Movel     'LEF0028'     MsgIDXAr(Idx)
      *
     C     DDMCCY        WHENEQ    'Y'
     C     DDTRCA        IFEQ      'TR'
     C     WTRCA         ANDEQ     'CA'
     C     WMCCY         ANDEQ     'N'
     C     CLE025        ANDEQ     'N'                                                        CLE041
     C                   Move      'N'           DDMCCYOK
     C                   Add       1             Idx
     C                   Movel     'DDMCCY'      FldNamXAr(Idx)
     C                   Movel     'LEF0132'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSL
      *
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSECI   - Validate Secured
      *****************************************************************
     C     VSECI         BEGSR

      ** Value must be 'Y','N' or ' '
     C     DDSECI        IFEQ      *BLANKS
     C                   MOVE      'N'           DDSECI
     C                   ELSE
     C     DDSECI        IFNE      'Y'
     C     DDSECI        ANDNE     'N'
     C     DDSECI        ANDNE     ' '
     C                   Move      'N'           DDSECIOK
     C                   Add       1             Idx
     C                   Movel     'DDSECI'      FldNamXAr(Idx)
     C                   Movel     'LEF0027'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDTEX   - Validate Date expired
      *****************************************************************
     C     VDTEX         BEGSR

      **  Must be valid date format
     C                   MOVE      DDDTEX        DATEA
     C                   TESTN                   DATEA                9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0056'     MsgIDXAr(Idx)
     C                   ELSE
      *
      **  Earlier than run date
      **   Field protected for expired facilities - do not validate
     C     ZDAYNO        IFLT      RUND
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'X'
     C     @@RECI        ANDNE     'E'
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0024'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     ZDAYNO        IFLT      RUND
     C     DDACTN        ANDEQ     'A'
     C     @@RECI        ANDNE     'E'
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0024'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     ZDAYNO        IFLE      W#DTAP
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0025'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Check if Expiry Date is a Holiday
     C     DDDTEXOK      IFNE      'N'
     C*****DDDTEX        ANDNE     DAYSV                                                     BUG4351
     C                   MOVEL     DDFCCY        ZCCY
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd        1
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDDTEXOK
     C                   ADD       1             WId
     C                   MOVEL     'DDDTEX'      WFldNmXAr(WId)
     C                   IF        DDACTN = 'A'                                             BUG22020
     C                             AND ZDAYNO <> @@DTEX                                     BUG22020
     C                   MOVEL     'LEF0212'     WMsgIdXAr(WId)
     C                   ELSE                                                               BUG22020
     C                   MOVEL     'LEF0604'     WMsgIdXAr(WId)                             BUG22020
     C                   ENDIF                                                              BUG22020
     C**********         MOVEL     'Y'           W#WARN            1                         BUG4351
     C                   ENDIF
     C                   ENDIF
      *
     C**********         MOVE      DDDTEX        DAYSV             6                         BUG4351
      *
      **  Check to see if there are any outstanding loans
     C     DDDTEXOK      IFNE      'N'
     C     DDACTN        IFNE      'I'
     C                   EXSR      CHKOTS
      *
     C     W#ERR4        IFEQ      'Y'
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0059'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  If valid
     C     DDDTEXOK      IFNE      'N'
     C                   Z-ADD     ZDAYNO        W#DTEX            5 0
     C                   MOVE      ZDAYNO        WWDTEX            5
     C                   ENDIF

     C     DDDTEXOK      IFNE      'N'
     C     DDACTN        ANDEQ     'A'
      **  Update of drawn amount array
     C                   MOVEL     'Y'           UpdOam
     C                   ENDIF
      *
      **  Read through LEFCAML0 if Expiry Date is amended
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
      *
     C                   MOVE      DDBRCA        K9BRCA
     C                   MOVEL     DDCSSN        K9CUST
     C                   MOVE      DDFACT        K9FCTY
     C                   MOVE      DDFCNO        K9FTNO
      *
     C     DDACTN        IFEQ      'A'
                                                                                              CLE041
      ** If aggregate, access the aggregate facility amendments                               CLE041
      ** file                                                                                 CLE041
     C                   IF        DDTRCA = 'AG'                                              CLE041
     C     K#KY09        SETLL     LEAGAML0                                                   CLE041
     C     K#KY09        READE     LEAGAML0                               80                  CLE041
     C     *IN80         DOWEQ     '0'                                                        CLE041
     C***  W#WARN        ANDEQ     'N'                                                        CLE041
     C     AGL0_VLDT     IFGT      ZDAYNO                                                     CLE041
     C                   MOVE      'W'           DDDTEXOK                                     CLE041
     C                   ADD       1             WId                                          CLE041
     C                   MOVEL     'DDDTEX'      WFldNmXAr(WId)                               CLE041
     C                   MOVEL     'LEF0261'     WMsgIdXAr(WId)                               CLE041
     C****               MOVEL     'Y'           W#WARN                                       CLE041
     C                   ENDIF                                                                CLE041
     C     K#KY09        READE     LEAGAML0                               80                  CLE041
     C                   ENDDO                                                                CLE041
                                                                                              CLE041
      ** Otherwise, access the facility amendments file                                       CLE041
     C                   ELSE                                                                 CLE041
     C     K#KY09        SETLL     LEFCAML0
     C     K#KY09        READE     LEFCAML0                               80
     C     *IN80         DOWEQ     '0'
     C*****W#WARN        ANDEQ     'N'                                                       BUG4351
     C     VLDT          IFGT      ZDAYNO
     C                   MOVE      'W'           DDDTEXOK
     C                   ADD       1             WId
     C                   MOVEL     'DDDTEX'      WFldNmXAr(WId)
     C                   MOVEL     'LEF0261'     WMsgIdXAr(WId)
     C**********         MOVEL     'Y'           W#WARN                                      BUG4351
     C                   ENDIF
     C     K#KY09        READE     LEFCAML0                               80
     C                   ENDDO
                                                                                              CLE041
     C                   ENDIF                                                                CLE041
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If expiry date has changed and there are any fees related to
      ** this facility with an End date greater than the Expiry date
      ** issue an error message
      *
     C     ZDAYNO        IFNE      @@DTEX
     C     DDACTN        ANDNE     'I'
      *
     C**********         Z-ADD     @@CNUM        K7CNUM                                       CSD027
     C                   EVAL      K7CNUM = @@CNUM                                            CSD027
     C                   MOVEL     @@FACT        K7FCTY            5 0
     C                   MOVE      @@FCNO        K7FCTY
      *
     C     K#KY07        SETLL     LEFEEDL1
     C     K#KY07        READE     LEFEEDL1                               80
      *
     C     *IN80         DOWEQ     *OFF
      *
      **  Check if outstanding fees are found (FERECI = 'D')
      *
     C     FERECI        IFEQ      'D'
     C     ZDAYNO        IFLT      FEPEND
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0237'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C     K#KY07        READE     LEFEEDL1                               80
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCRSK   - Validate Country of risk
      *****************************************************************
     C     VCRSK         BEGSR

     C     DDCRSK        IFEQ      *BLANKS
      *
      **  Default it to country of citizenship
      **  Access customer file for country of citizenship
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCSSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     DDCSSN        DBKEY
     C                   MOVEL     'LE2020'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BBCNCZ        DDCRSK
     C/COPY WNCPYSRC,LEH01207
     C                   ENDIF
      *
     C                   ELSE
      *
      **  Must be valid country code
     C                   MOVE      DDCRSK        CTRYKY
     C                   CALL      'AOCTRYR0'    PLIST5
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A4CNCD        DDCRSK
     C                   ELSE
     C                   Move      'N'           DDCRSKOK
     C                   Add       1             Idx
     C                   Movel     'DDCRSK'      FldNamXAr(Idx)
     C                   Movel     'LEF0081'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VMCSI   - Validate Multi customer
      *****************************************************************
     C     VMCSI         BEGSR

      ** Value must be 'Y' or 'N' and cannot be amended from 'Y' to 'N'
     C                   SELECT
     C     DDMCSI        WHENEQ    *BLANKS
     C     DDACTN        IFNE      'A'
     C                   MOVE      'N'           DDMCSI
     C                   ELSE
     C     @@MCSI        IFEQ      'Y'
     C     DDMCSI        ANDNE     'Y'
     C                   Move      'N'           DDMCSIOK
     C                   Add       1             Idx
     C                   Movel     'DDMCSI'      FldNamXAr(Idx)
     C                   Movel     'LEF0031'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C     DDMCSI        WHENEQ    'N'
     C     DDACTN        ANDEQ     'A'
     C     @@MCSI        ANDEQ     'Y'
     C                   Move      'N'           DDMCSIOK
     C                   Add       1             Idx
     C                   Movel     'DDMCSI'      FldNamXAr(Idx)
     C                   Movel     'LEF0031'     MsgIDXAr(Idx)

     C     DDMCSI        WHENNE    'Y'
     C     DDMCSI        ANDNE     'N'
     C                   Move      'N'           DDMCSIOK
     C                   Add       1             Idx
     C                   Movel     'DDMCSI'      FldNamXAr(Idx)
     C                   Movel     'LEF0030'     MsgIDXAr(Idx)

     C     DDMCSI        WHENEQ    'Y'
     C     DDTRCA        IFEQ      'TR'
     C     WTRCA         ANDEQ     'CA'
     C     WMCSI         ANDEQ     'N'
     C     CLE025        ANDEQ     'N'                                                        CLE041
     C                   Move      'N'           DDMCSIOK
     C                   Add       1             Idx
     C                   Movel     'DDMCSI'      FldNamXAr(Idx)
     C                   Movel     'LEF0133'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNACD   - Validate Alt N/A
      *****************************************************************
     C     VNACD         BEGSR

      **  Must be valid name & address record on SDALTNPD
     C     DDNACD        IFEQ      *BLANKS
     C     DDNACD        OREQ      'B'
     C                   MOVE      'B'           DDNACD
      *
     C                   ELSE
     C
     C                   MOVEL     DDCSSN        CUST              6
     C                   MOVEL     DDNACD        ADCD              1
     C                   CALLB     'AOALTNR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM                    CUST
     C                   PARM                    ADCD
     C     SDALTN        PARM      SDALTN        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDNACDOK
     C                   Add       1             Idx
     C                   Movel     'DDNACD'      FldNamXAr(Idx)
     C                   Movel     'LEF0060'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VMBFC   - Validate Multi Branch
      *****************************************************************
     C     VMBFC         BEGSR

      **  Must be 'Y' or 'N' if entered (DEFAULT 'N' IF BLANK)
      **  Cannot be amended from 'Y' to 'N'
      **  & only allowed in multi-branch system
     C     AGMBIN        IFNE      'Y'
     C                   MOVE      'N'           DDMBFC
     C                   ELSE

      **  Validate indicator value
     C     DDMBFC        IFNE      'Y'
     C     DDMBFC        ANDNE     'N'
     C     DDMBFC        ANDNE     ' '
     C                   Move      'N'           DDMBFCOK
     C                   Add       1             Idx
     C                   Movel     'DDMBFC'      FldNamXAr(Idx)
     C                   Movel     'LEF0061'     MsgIDXAr(Idx)
     C                   ENDIF

      **  IF INDICATOR IS 'N' OR ' ' PREVENT AMENDMENT OF FIELD ON FILE
      **  FROM 'Y' TO 'N' ELSE SET FILE FIELD
     C     DDMBFC        IFEQ      'N'
     C     DDMBFC        OREQ      ' '
     C     @@@MBFC       IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
     C                   Move      'N'           DDMBFCOK
     C                   Add       1             Idx
     C                   Movel     'DDMBFC'      FldNamXAr(Idx)
     C                   Movel     'LEF0062'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      'N'           DDMBFC
     C                   ENDIF
     C                   ENDIF

     C     DDMBFC        IFEQ      'Y'
     C     DDTRCA        IFEQ      'TR'
     C     WTRCA         ANDEQ     'CA'
     C     WMBFC         ANDEQ     'N'
     C     CLE025        ANDEQ     'N'                                                        CLE041
     C                   Move      'N'           DDMBFCOK
     C                   Add       1             Idx
     C                   Movel     'DDMBFC'      FldNamXAr(Idx)
     C                   Movel     'LEF0134'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRVCD   - Validate Rec.CR Date changed (output field only)
      *****************************************************************
     C     VRVCD         BEGSR

     C     DDACTN        IFEQ      'A'
      *
      **  If this is the first change of RVCR today then RVCD become
      **  run date
     C     DDRVCR        IFNE      @@RVCR
     C     RUND          ANDNE     RVCD
     C                   Z-ADD     RUND          RVCD
     C                   ENDIF

     C                   MOVE      RVCD          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DDRVCD
      *
     C                   ENDIF

     C     DDACTN        IFEQ      'I'
     C                   MOVEL     *BLANKS       DDRVCD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDLFS   - Validate Date of Last Fin.Stmt
      *****************************************************************
     C     VDLFS         BEGSR

      ** Date of Last Financial Statement Temp field initialized                             BUG8549
     C                   Z-ADD     *ZEROS        W#DLFS                                      BUG8549
      *                                                                                      BUG8549
     C     DDDLFS        IFNE      *BLANKS
      *
      **  Must be valid date format & not greater than run date
     C                   MOVE      DDDLFS        DATEA
     C                   TESTN                   DATEA                9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   Move      'N'           DDDLFSOK
     C                   Add       1             Idx
     C                   Movel     'DDDLFS'      FldNamXAr(Idx)
     C                   Movel     'LEF0033'     MsgIDXAr(Idx)
     C                   ELSE
     C     ZDAYNO        IFGT      RUND
     C                   Move      'N'           DDDLFSOK
     C                   Add       1             Idx
     C                   Movel     'DDDLFS'      FldNamXAr(Idx)
     C                   Movel     'LEF0034'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     ZDAYNO        W#DLFS            5 0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNOMR   - Validate Nominal rate
      *****************************************************************
     C     VNOMR         BEGSR

      **  Must be valid per ZALIGN
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDNOMR        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   Move      'N'           DDNOMROK
     C                   Add       1             Idx
     C                   Movel     'DDNOMR'      FldNamXAr(Idx)
     C                   Movel     'LEF0035'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   MOVE      ZFIELD        W#NOMR           11 7
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRVDT   - Validate Review date
      *****************************************************************
     C     VRVDT         BEGSR
      *                                                                                       245541
      **  Must clear work field W#RVDT else value retained from                               245541
      **  previous facility.                                                                  245541
     C                   Z-ADD     0             W#RVDT                                       245541

     C     DDRVDT        IFNE      *BLANKS
      *
      **  Must be valid date format, greater than approved date (N.B.
      **  now called Start Date on screen), and, if Insert, greater
      **   than run date and less than expiry date)
     C                   MOVE      DDRVDT        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

     C                   SELECT
     C     ErrorFlag     WHENEQ    'Y'
     C                   Move      'N'           DDRVDTOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDT'      FldNamXAr(Idx)
     C                   Movel     'LEF0036'     MsgIDXAr(Idx)

     C     ZDAYNO        WHENLE    RUND
     C     DDACTN        ANDEQ     'I'
     C                   Move      'N'           DDRVDTOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDT'      FldNamXAr(Idx)
     C                   Movel     'LEF0037'     MsgIDXAr(Idx)

     C     ZDAYNO        WHENLE    W#DTAP
     C                   Move      'N'           DDRVDTOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDT'      FldNamXAr(Idx)
     C                   Movel     'LEF0038'     MsgIDXAr(Idx)

     C     ZDAYNO        WHENGE    W#DTEX
     C     DDACTN        ANDEQ     'I'
     C                   Move      'N'           DDRVDTOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDT'      FldNamXAr(Idx)
     C                   Movel     'LEF0039'     MsgIDXAr(Idx)
     C                   ENDSL

     C                   Z-ADD     ZDAYNO        W#RVDT            5 0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRVFR   - Validate Frequency
      *****************************************************************
     C     VRVFR         BEGSR

     C     DDRVFR        IFNE      *BLANKS
      *
      **  Must be valid frequency
     C     DDRVDT        IFEQ      *BLANKS
     C     DDRVFR        ANDNE     *BLANKS
     C                   Move      'N'           DDRVFROK
     C                   Add       1             Idx
     C                   Movel     'DDRVFR'      FldNamXAr(Idx)
     C                   Movel     'LEF0040'     MsgIDXAr(Idx)
     C                   ELSE

     C     DDRVFR        IFNE      'M'
     C     DDRVFR        ANDNE     'Q'
     C     DDRVFR        ANDNE     'X'
     C     DDRVFR        ANDNE     'Y'
     C     DDRVFR        ANDNE     'D'                                                        CLE064
     C     DDRVFR        ANDNE     'W'                                                        CLE064
     C     DDRVFR        ANDNE     'F'                                                        CLE064
     C     DDRVFR        ANDNE     '4'                                                        CLE064
     C     DDRVFR        ANDNE     '5'                                                        CLE064
     C     DDRVFR        ANDNE     '7'                                                        CLE064
     C     DDRVFR        ANDNE     '8'                                                        CLE064
     C     DDRVFR        ANDNE     '9'                                                        CLE064
     C     DDRVFR        ANDNE     'V'                                                        CLE064
     C     DDRVFR        ANDNE     'E'                                                        CLE064
     C     DDRVFR        ANDNE     'C'                                                        CLE064
     C     DDRVFR        ANDNE     'I'                                                        CLE064
     C     DDRVFR        ANDNE     'J'                                                        CLE064
     C     DDRVFR        ANDNE     'N'                                                        CLE064
     C     DDRVFR        ANDNE     'U'                                                        CLE064
     C     DDRVFR        ANDNE     'T'                                                      AR747727
     C                   Move      'N'           DDRVFROK
     C                   Add       1             Idx
     C                   Movel     'DDRVFR'      FldNamXAr(Idx)
     C                   Movel     'LEF0041'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRVDY   - Validate Day no
      *****************************************************************
     C     VRVDY         BEGSR

     C     DDRVDY        IFNE      *BLANKS
      *
      **  Entered only if REV.FRQ. entered, must be valid numeric 1->31
     C     DDRVFR        IFEQ      *BLANKS
     C     DDRVDY        ANDNE     *BLANKS
     C                   Move      'N'           DDRVDYOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0042'     MsgIDXAr(Idx)
     C                   ELSE

     C                   TESTN                   DDRVDY               19
     C     *IN19         IFEQ      *OFF
     C                   Move      'N'           DDRVDYOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0043'     MsgIDXAr(Idx)
     C                   ELSE

     C     *IN19         IFEQ      *ON
     C                   MOVE      DDRVDY        W#RVDY            2 0
     C     W#RVDY        IFGT      31
     C     W#RVDY        ORLT      01
     C                   Move      'N'           DDRVDYOK
     C                   Add       1             Idx
     C                   Movel     'DDRVDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0043'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACOF   - Validate Account officer
      *****************************************************************
     C     VACOF         BEGSR

     C                   MOVE      'N'           WBLACF            1
      *
      **  Default it to country of citizenship
      **  Access customer file for country of citizenship
     C     DDACOF        IFEQ      *BLANKS
     C                   MOVE      'Y'           WBLACF
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCSSN        @CNUM
     C                   PARM                    @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     DDCSSN        DBKEY
     C                   MOVEL     'LE2020'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BBACOC        DDACOF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      DDACOF        ACOKEY
     C                   CALL      'AOACOFR0'    PLIST4
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDACOFOK
     C                   Add       1             Idx
     C                   Movel     'DDACOF'      FldNamXAr(Idx)
     C                   Movel     'LEF0044'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      AZACOC        DDACOF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPRFC   - Validate Profit center
      *****************************************************************
     C     VPRFC         BEGSR

      *
      **  VALIDATE PROFIT CENTRE IF PROFIT CENTRE IS USED AND
      **  IS AMENDABLE, OR DURING INSERT.
     C     BKPRCU        IFEQ      'Y'
     C     BKPRCA        IFEQ      'Y'
     C     DDACTN        OREQ      'I'

      **  IF PROFIT CENTRE IS USED THEN :-
      **  VALIDATE THE INPUT PROFIT CENTRE IF ENTERED
      *
     C     DDPRFC        IFNE      *BLANKS
     C                   MOVE      *BLANKS       @KEY              4
     C                   CALLB     'AOPRFCR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDPRFC        @KEY
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANK
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'LEF0045'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      DSPCCD        DDPRFC
     C                   ENDIF
      *
      **  ELSE /* PROFIT CENTRE IS USED BUT NOT ENTERED */ :-
      **  EXTRACT THE DEFAULT PROFIT CENTRE IF INPUT PROFIT CENTRE IS
      **  BLANK AND PROFIT CENTRE USED FLAG IS ON AND DEFAULT FLAG IS
      **  ALSO ON.
     C                   ELSE
     C     BKPCDU        IFEQ      'Y'
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       RTCDPR            1
     C                   PARM      *BLANKS       BOOKPR            2
     C                   PARM      *BLANKS       TRTPPR            5
     C                   PARM      *BLANKS       SUTPPR            2
     C                   PARM      DDBRCA        BRANPR            3
     C                   PARM      *BLANKS       DEPTPR            3
     C                   PARM      PSUSER        USERPR           10
     C                   PARM      DDACOF        ACOFPR            2
     C                   PARM      DDCSSN        CNUMPR            6
     C                   PARM      *BLANKS       PRFCPR            4
     C                   MOVE      PRFCPR        DDPRFC
     C     RTCDPR        IFEQ      '2'
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'LEF0045'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VORBR   - Validate Originating branch
      *****************************************************************
     C     VORBR         BEGSR

      **  Must be valid for user and on SDBRCHPD
     C     AGMBIN        IFEQ      'Y'
      *
      ** IF ORIGINATING BR. NOT USED, SET FIELD IN DBASE TO BOOKING BR.
     C     BKOBRU        IFEQ      'N'
     C                   MOVE      DDBRCA        DDORBR
     C                   ELSE
      *
      ** IF ORIGINATING BR. USED BUT NOT ENTERED, TAKE VALID BOOKING BR.
      ** AS DEFAULT.
     C     DDORBR        IFEQ      *BLANKS
     C     DDBRCAOK      IFNE      'N'
     C                   MOVE      DDBRCA        DDORBR
     C                   ELSE
     C                   Move      'N'           DDORBROK
     C                   Add       1             Idx
     C                   Movel     'DDORBR'      FldNamXAr(Idx)
     C                   Movel     'LEF0049'     MsgIDXAr(Idx)
E4   C                   ENDIF
      *
     C                   ELSE
      *
      ** ORIGINATING BRANCH USED AND ENTERED, MUST BE VALID FOR USER.
      **  CHECK IF BRANCH CODE DEFINED IN STANDING DATA
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDORBR        @BRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDORBROK
     C                   Add       1             Idx
     C                   Movel     'DDORBR'      FldNamXAr(Idx)
     C                   Movel     'LEF0049'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDORBR
      *
      **  ONLY VALIDATED VS USER IF 'ORIG BR/USER VALIDATION' = Y
     C     BKOBUV        IFEQ      'Y'
      *
     C     Respmode      IFEQ      'B'
     C                   CALL      'ZBOBU'
     C                   PARM      DDORBR        @ZOBRX            3
     C                   PARM                    @USER            10
     C                   PARM                    @ERR              1 0
     C                   ELSE
     C                   CALL      'ZVOBU'
     C                   PARM      DDORBR        @ZBR
     C                   PARM                    @ERR
     C                   ENDIF
      *
     C     @ERR          IFNE      *ZERO
     C     @ERR          IFEQ      1
     C                   Move      'N'           DDORBROK
     C                   Add       1             Idx
     C                   Movel     'DDORBR'      FldNamXAr(Idx)
     C                   Movel     'LEF0050'     MsgIDXAr(Idx)
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   Move      'N'           DDORBROK
     C                   Add       1             Idx
     C                   Movel     'DDORBR'      FldNamXAr(Idx)
     C                   Movel     'LEF0051'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTRCA   - Validate Tranche/Credit agreement ind
      *****************************************************************
     C     VTRCA         BEGSR

      **  Validate Tranche/Credit Agreement Indicator

     C     DDTRCA        IFNE      'TR'
     C     DDTRCA        ANDNE     'CA'
     C     DDTRCA        ANDNE     *BLANKS
     C     CLE025        ANDEQ     'N'                                                        CLE041
     C                   Move      'N'           DDTRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDTRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0264'     MsgIDXAr(Idx)
     C                   ENDIF
                                                                                              CLE041
     C                   IF        CLE025 = 'Y' AND                                           CLE041
     C                             DDTRCA <> 'TR' AND                                         CLE041
     C                             DDTRCA <> 'CA' AND                                         CLE041
     C                             DDTRCA <> 'AG' AND                                         CLE041
     C                             DDTRCA <> *BLANKS                                          CLE041
     C                   MOVE      'N'           DDTRCAOK                                     CLE041
     C                   ADD       1             Idx                                          CLE041
     C                   MOVEL     'DDTRCA'      FldNamXAr(Idx)                               CLE041
     C                   MOVEL     'LEF0451'     MsgIDXAr(Idx)                                CLE041
     C                   GOTO      EVTRCA                                                     CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Do not allow aggregate facility to be changed                                        CLE041
                                                                                              CLE041
     C                   IF        CLE025 = 'Y' AND                                           CLE041
     C                             DDACTN = 'A' AND                                           CLE041
     C                             @@TRCA = 'AG' AND                                          CLE041
     C                             @@TRCA <> DDTRCA                                           CLE041
     C                   MOVE      'N'           DDTRCAOK                                     CLE041
     C                   ADD       1             Idx                                          CLE041
     C                   MOVEL     'DDTRCA'      FldNamXAr(Idx)                               CLE041
     C                   MOVEL     'LEF0452'     MsgIDXAr(Idx)                                CLE041
     C                   GOTO      EVTRCA                                                     CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Do not allow facility to be changed to aggregate                                     CLE041
                                                                                              CLE041
     C                   IF        CLE025 = 'Y' AND                                           CLE041
     C                             DDACTN = 'A' AND                                           CLE041
     C                             DDTRCA = 'AG' AND                                          CLE041
     C                             DDTRCA <> @@TRCA                                           CLE041
     C                   MOVE      'N'           DDTRCAOK                                     CLE041
     C                   ADD       1             Idx                                          CLE041
     C                   MOVEL     'DDTRCA'      FldNamXAr(Idx)                               CLE041
     C                   MOVEL     'LEF0453'     MsgIDXAr(Idx)                                CLE041
     C                   GOTO      EVTRCA                                                     CLE041
     C                   ENDIF                                                                CLE041
      *
      * Do not allow a credit agreement to change to a TR and attach
      * it to itself.
     C     @@TRCA        IFEQ      'CA'
     C     DDTRCA        ANDEQ     'TR'
     C     DDACTN        ANDEQ     'A'
     C     DDCSSN        ANDEQ     DDCANM
     C     DDFACT        ANDEQ     DDCAFT
     C     DDFCNO        ANDEQ     DDCAFN
     C                   Move      'N'           DDTRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDTRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0128'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  Check if Tranche/Credit Agreement Indicator may be changed
      **  from blank or TR to CA (prohibit if loans o/s)
      **  Also prohibit conversion of facility to TR if there are                           AR741374
      **  outstanding loans.                                                                AR741374
      *
     C     @@TRCA        IFEQ      'TR'
     C     DDTRCA        ANDEQ     'CA'
     C     DDACTN        ANDNE     'I'
     C     @@TRCA        OREQ      '  '
     C     DDTRCA        ANDEQ     'CA'
     C     DDACTN        ANDNE     'I'
     C     @@TRCA        OREQ      '  '                                                     AR741374
     C     DDTRCA        ANDEQ     'TR'                                                     AR741374
     C     DDACTN        ANDNE     'I'                                                      AR741374
      *
      ** Check for outstanding loans.
      *                                                                                     MD034007
     C     CLE147        IFNE      'Y'                                                      MD034007
     C**********         Z-ADD     @@CNUM        K8CNUM                                       CSD027
     C                   EVAL      K8CNUM = @@CNUM                                            CSD027
     C                   Z-ADD     @@FACT        K8FACT
     C                   Z-ADD     @@FCNO        K8FCNO
      *
     C     K#KY08        SETLL     LEREF
     C     K#KY08        READE     LEREF                                  80
      *
     C     *IN80         IFEQ      '0'
     C                   Move      'N'           DDTRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDTRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0086'     MsgIDXAr(Idx)
     C                   ENDIF
      *                                                                                     MD034007
     C                   ELSE                                                               MD034007
      *                                                                                     MD034007
      ** Check Loans attached to the Facility                                               MD034007
      *                                                                                     MD034007
     C     KFCLT         SETLL     LELOANLC                                                 MD034007
     C     KFCLT         READE     LELOANLC                               10                MD034007
     C     *IN10         DOWEQ     *OFF                                                     MD034007
     C     DDTRCAOK      ANDNE     'N'                                                      MD034007
     C     CLVDAT        IFLT      RUND                                                     MD034007
     C     CLORED        ANDLT     RUND                                                     MD034007
     C     DDTRCA        OREQ      'CA'                                                     MD034007
     C                   Move      'N'           DDTRCAOK                                   MD034007
     C                   Add       1             Idx                                        MD034007
     C                   Movel     'DDTRCA'      FldNamXAr(Idx)                             MD034007
     C                   Movel     'LEF0086'     MsgIDXAr(Idx)                              MD034007
     C                   ENDIF                                                              MD034007
     C     KFCLT         READE     LELOANLC                               10                MD034007
     C                   ENDDO                                                              MD034007
      *                                                                                     MD034007
     C                   ENDIF                                                              MD034007
      *                                                                                     AR741374
      ** Check for outstanding manual utilisations                                          AR741374
      *                                                                                     AR741374
     C*****K#KY08        CHAIN     LEMNFUL6                           80           AR741374 MD034007
     C******IN80         IFEQ      '0'                                             AR741374 MD034007
     C     K#KY08        SETLL     LEMNFUL6                                                 MD034007
     C     K#KY08        READE     LEMNFUL6                               80                MD034007
      *                                                                                     MD034007
     C     *IN80         DOWEQ     '0'                                                      MD034007
     C     DDTRCAOK      ANDNE     'N'                                                      MD034007
      *                                                                                     MD034007
     C     CLE147        IFNE      'Y'                                                      MD034007
     C     CLE147        OREQ      'Y'                                                      MD034007
     C     STDT          ANDLT     RUND                                                     MD034007
     C     ORED          ANDLT     RUND                                                     MD034007
     C                   Move      'N'           DDTRCAOK                                   AR741374
     C                   Add       1             Idx                                        AR741374
     C                   Movel     'DDTRCA'      FldNamXAr(Idx)                             AR741374
     C                   Movel     'LEF0290'     MsgIDXAr(Idx)                              AR741374
     C                   ENDIF                                                              MD034007
      *                                                                                     MD034007
     C     K#KY08        READE     LEMNFUL6                               80                MD034007
     C                   ENDDO                                                              MD034007
     C**********         ENDIF                                                     AR741374 MD034007
      *                                                                                     AR741374
     C                   ENDIF
      *
      **  Check if Tranche/Credit Agreement Indicator may be changed
      **  from CA to TR
     C     @@TRCA        IFEQ      'CA'
     C     DDTRCA        ANDEQ     'TR'
     C     DDACTN        ANDNE     'I'
     C                   MOVE      @@CNUM        K0CANM
     C                   MOVE      @@FACT        K0CAFT
     C                   MOVE      @@FCNO        K0CAFN
     C     K#KY10        CHAIN     LEFCLTL9                           80
     C     *IN80         IFEQ      '0'
     C                   Move      'N'           DDTRCAOK
     C                   Add       1             Idx
     C                   Movel     'DDTRCA'      FldNamXAr(Idx)
     C                   Movel     'LEF0280'     MsgIDXAr(Idx)
      *
      **  Chain to FCLTY to obtain original record
      *
     C                   MOVE      'A'           K3RCTP
     C                   MOVEL     DDCSSN        K3CNUM
     C                   MOVE      DDFACT        K3FACT
     C                   MOVE      DDFCNO        K3FCNO
     C     K#KY03        CHAIN     FCLTY                              80
     C                   MOVE      'B'           K3RCTP
     C     K#KY03        CHAIN     FCLTY                              80
     C                   ENDIF
     C                   ENDIF
      *
      **  Validate Credit Agreement Customer
     C     DDTRCA        IFEQ      'TR'
      *
     C                   MOVE      *BLANKS       WTRCA             2
     C                   MOVE      *BLANK        WMCCY             1
     C                   MOVE      *BLANK        WMCSI             1
     C                   MOVE      *BLANK        WMBFC             1
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCANM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDCANMOK
     C                   Add       1             Idx
     C                   Movel     'DDCANM'      FldNamXAr(Idx)
     C                   Movel     'LEF0266'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE(P)   BBCUST        DDCANM
     C                   ENDIF
      *
      **  Validate Credit Agreement Type
     C                   MOVE      DDCAFT        FKEY
     C                   CALLB     'AOFACTR0'    PLIST1
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDCANMOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFT'      FldNamXAr(Idx)
     C                   Movel     'LEF0268'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     AMFCTY        DDCAFT
     C                   ENDIF
      *
      **  Validate Credit Agreement Facility No.
     C                   TESTN                   DDCAFN               19
     C     *IN19         IFEQ      '0'
     C                   Move      'N'           DDCAFNOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFN'      FldNamXAr(Idx)
     C                   Movel     'LEF0270'     MsgIDXAr(Idx)
     C                   ELSE

     C     DDCAFN        IFLT      '01'
     C     DDCAFN        ORGT      '99'
     C                   Move      'N'           DDCAFNOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFN'      FldNamXAr(Idx)
     C                   Movel     'LEF0271'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDTRCAOK      IFNE      'N'
     C     DDCANMOK      ANDNE     'N'
     C     DDCAFTOK      ANDNE     'N'
     C     DDCAFNOK      ANDNE     'N'
     C                   MOVE      'A'           K3RCTP
     C                   MOVE      DDCANM        K3CNUM
     C                   MOVE      DDCAFT        K3FACT
     C                   MOVE      DDCAFN        K3FCNO
      *
     C     K#KY03        CHAIN     FCLTY                              80
     C                   MOVE      'B'           K3RCTP
     C     K#KY03        CHAIN     FCLTY                              80
      *
      **  Must be a valid facility set up as a Credit Agreement
     C     *IN80         IFEQ      '1'
     C                   Move      'N'           DDCAFNOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFN'      FldNamXAr(Idx)
     C                   Movel     'LEF0006'     MsgIDXAr(Idx)
      *
      **  Facility chosen must be set up as Credit Agreement
      ****Credit*Agreement*must*be*live*and*authorized**************                 BUG10941 242261
      **  Credit Agreement must be live.                                                      242261
      *                                                                                     BUG10941
     C                   ELSE
     C     TRCA          IFNE      'CA'
     C     RECI          OREQ      'R'                                                      BUG10941
     C*****FSTS******    ORNE      'A'                                               BUG10941 242261
     C                   Move      'N'           DDCAFNOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFN'      FldNamXAr(Idx)
     C                   Movel     'LEF0277'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   MOVE      TRCA          WTRCA
     C                   MOVE      MCCY          WMCCY
     C                   MOVE      MCSI          WMCSI
     C                   MOVE      MBFC          WMBFC
      * Save Credit agreement currency for validation of CAXR later.
     C                   MOVE      FCCY          WCACCY            3            CA currency
      *
     C     DDTRCA        IFEQ      'TR'
      *                                                                                      BUG3732
      ** If credit agreement's multi customer, multi branch and multi                        BUG3732
      ** currency is 'N', then tranche's customer, branch, and ccy                           BUG3732
      ** should match CA's.                                                                  BUG3732
      *                                                                                      BUG3732
     C     WTRCA         IFEQ      'CA'                                                      BUG3732
      *                                                                                      BUG3732
     C                   MOVEL     DDCSSN        DCUST             6                         BUG3732
     C**********         MOVE      DCUST         DCNUMS            6 0                BUG3732 CSD027
     C                   MOVE      DCUST         DCNUMS            6                          CSD027
     C     WMCSI         IFEQ      'N'                                                       BUG3732
     C     DCNUMS        ANDNE     CNUM                                                      BUG3732
     C                   Move      'N'           DDCSSNOK                                    BUG3732
     C                   Add       1             Idx                                         BUG3732
     C                   Movel     'DDCSSN'      FldNamXAr(Idx)                              BUG3732
     C                   Movel     'LEF0365'     MsgIDXAr(Idx)                               BUG3732
     C                   ENDIF                                                               BUG3732
      *                                                                                      BUG3732
     C     WMBFC         IFEQ      'N'                                                       BUG3732
     C     DDBRCA        ANDNE     BRCA                                                      BUG3732
     C                   Move      'N'           DDBRCAOK                                    BUG3732
     C                   Add       1             Idx                                         BUG3732
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)                              BUG3732
     C                   Movel     'LEF0366'     MsgIDXAr(Idx)                               BUG3732
     C                   ENDIF                                                               BUG3732
      *                                                                                      BUG3732
     C     WMCCY         IFEQ      'N'                                                       BUG3732
     C     DDFCCY        ANDNE     FCCY                                                      BUG3732
     C                   Move      'N'           DDFCCYOK                                    BUG3732
     C                   Add       1             Idx                                         BUG3732
     C                   Movel     'DDFCCY'      FldNamXAr(Idx)                              BUG3732
     C                   Movel     'LEF0364'     MsgIDXAr(Idx)                               BUG3732
     C                   ENDIF                                                               BUG3732
                                                                                             BUG5132
      * If credit agreement is multi currency                                                BUG5132
      * Check tranche currency against allowable currencies for the credit agreement         BUG5132
     C                   If        WMCCY = 'Y'                                               BUG3732
     C                             AND WCACCY <> DDFCCY                                      BUG6984
     C                             AND ALCY <> *BLANKS                                       BUG6984
     C                             and CSEL = 'Y'                                            BUG6435
     C                   MOVEA     ALCY          ArrALCY                                     BUG5132
     C                   Eval      n = 0                                                     BUG5132
     C                   Eval      n = %lookup(DDFCCY:ArrALCY)                               BUG5132
     C                   If        n = 0                                                     BUG5132
     C                   Move      'N'           DDFCCYOK                                    BUG5132
     C                   Add       1             Idx                                         BUG5132
     C                   Movel     'DDFCCY'      FldNamXAr(Idx)                              BUG5132
     C                   Movel     'LEF0370'     MsgIDXAr(Idx)                               BUG5132
     C                   EndIf                                                               BUG5132
     C                   EndIf                                                               BUG5132
      *                                                                                      BUG3732
     C                   ENDIF                                                               BUG3732
      *
      * The start date for a tranche agreement cannot be before the
      * start date of the credit agreement facility
     C     W#DTAP        IFLT      DTAP
     C                   Move      'N'           DDDTAPOK
     C                   Add       1             Idx
     C                   Movel     'DDDTAP'      FldNamXAr(Idx)
     C                   Movel     'LEF0127'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      * The expiry date for a tranche agreement cannot be after the
      * expiry date of the credit agreement facility
     C     W#DTEX        IFGT      DTEX
     C                   Move      'N'           DDDTEXOK
     C                   Add       1             Idx
     C                   Movel     'DDDTEX'      FldNamXAr(Idx)
     C                   Movel     'LEF0130'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      **  Chain to FCLTY to obtain original record
     C                   MOVE      'A'           K3RCTP
     C                   MOVEL     DDCSSN        K3CNUM
     C                   MOVE      DDFACT        K3FACT
     C                   MOVE      DDFCNO        K3FCNO
     C     K#KY03        CHAIN     FCLTY                              80
     C                   MOVE      'B'           K3RCTP
     C     K#KY03        CHAIN     FCLTY                              80
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDCANM        IFNE      *BLANKS
     C                   Move      'N'           DDCANMOK
     C                   Add       1             Idx
     C                   Movel     'DDCANM'      FldNamXAr(Idx)
     C                   Movel     'LEF0265'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDCAFT        IFNE      *BLANKS
     C                   Move      'N'           DDCAFTOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFT'      FldNamXAr(Idx)
     C                   Movel     'LEF0267'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDCAFN        IFNE      *BLANKS
     C                   Move      'N'           DDCAFNOK
     C                   Add       1             Idx
     C                   Movel     'DDCAFN'      FldNamXAr(Idx)
     C                   Movel     'LEF0269'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       CACY
     C                   ENDIF
      *
      **  Check if Manual Fac. is attached to credit agreement's tranche
      *   before allowing amend from '  ' to 'TR' or from 'TR' to '  '
     C     DDTRCAOK      IFNE      'N'
     C     DDCANMOK      ANDNE     'N'
     C     DDCAFTOK      ANDNE     'N'
     C     DDCAFNOK      ANDNE     'N'

     C*****DDTRCA        IFNE      TRCASV                                                    BUG4351

     C     @@TRCA        IFEQ      '  '
     C     DDTRCA        ANDEQ     'TR'
     C     DDACTN        ANDNE     'I'

     C     @@TRCA        OREQ      'TR'
     C     DDTRCA        ANDEQ     '  '
     C     DDACTN        ANDNE     'I'
     C**********         Z-ADD     @@CNUM        K8CNUM                                       CSD027
     C                   EVAL      K8CNUM = @@CNUM                                            CSD027
     C                   Z-ADD     @@FACT        K8FACT
     C                   Z-ADD     @@FCNO        K8FCNO

     C     K#KY08        CHAIN     LEMNFUL6                           80
     C     *IN80         IFEQ      '0'
     C                   MOVE      'W'           DDTRCAOK
     C                   ADD       1             WId
     C                   MOVEL     'DDTRCA'      WFldNmXAr(WId)
     C                   MOVEL     'LEF0323'     WMsgIdXAr(WId)
     C                   ENDIF
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351

     C**********         MOVE      DDTRCA        TRCASV            2                         BUG4351
                                                                                              CLE147
      ** Check if the Credit Agreement has been changed and if a live                         CLE147
      ** transaction is attached to the tranche.                                              CLE147
                                                                                              CLE147
     C                   IF        CLE147 = 'Y' AND DDACTN <> 'I'                             CLE147
     C                             AND DDREJT <> 'Y'                                          CLE147
     C                             AND @@ORED <> BJRDNB                                     AR870095
                                                                                              CLE147
      ** Check if there's live transaction attached to the facility                           CLE147
     C                   MOVE      'N'           W#LIVE                                       CLE147
     C                   EXSR      SRLIVE                                                     CLE147
                                                                                              CLE147
     C                   IF        W#LIVE = 'Y'                                               CLE147
                                                                                              CLE147
      ** If CA details has been changed, set the Change Flag to 'Y'                           CLE147
                                                                                              CLE147
     C                   EVAL      W#NANM = DDNANM                                            CLE147
     C                   MOVE      DDNAFT        W#NAFT                                       CLE147
     C                   MOVE      DDNAFN        W#NAFN                                       CLE147
                                                                                              CLE147
     C                   IF        W#NANM <> @@CANM OR W#NAFT <> @@CAFT                       CLE147
     C                             OR W#NAFN <> @@CAFN                                        CLE147
     C                   MOVE      'Y'           DDNAFL                                       CLE147
     C                   IF        DDOANM <> *BLANKS                                          CLE147
     C                   MOVE      'Y'           DDOAFL                                       CLE147
     C                   ENDIF                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
      ** If Change Flag is 'Y', throw a warning message and determine                         CLE147
      ** if the CA amendment is for attach, detach, or change                                 CLE147
                                                                                              CLE147
     C                   IF        DDNAFL = 'Y'                                               CLE147
     C                   MOVE      'W'           DDCANMOK                                     CLE147
     C                   ADD       1             WId                                          CLE147
     C                   MOVEL     'DDCANM'      WFldNmXAr(WId)                               CLE147
     C                   MOVEL     'LEF0605'     WMsgIdXAr(WId)                               CLE147
                                                                                              CLE147
     C                   SELECT                                                               CLE147
     C                   WHEN      DDNANM <> *BLANKS AND                                      CLE147
     C                             DDOANM = *BLANKS                                           CLE147
     C                   MOVE      'A'           DDAXTN                                       CLE147
     C                   WHEN      DDNANM = *BLANKS AND                                       CLE147
     C                             DDOANM <> *BLANKS                                          CLE147
     C                   MOVE      'D'           DDAXTN                                       CLE147
     C                   WHEN      DDNANM <> *BLANKS AND                                      CLE147
     C                             DDOANM <> *BLANKS                                          CLE147
     C                   MOVE      'C'           DDAXTN                                       CLE147
     C                   WHEN      DDNANM = *BLANKS AND                                     AR865343
     C                             DDOANM = *BLANKS                                         AR865343
     C                   MOVE      *BLANKS       DDOAFL                                     AR865343
     C                   MOVE      *BLANKS       DDNAFL                                     AR865343
     C                   MOVE      *BLANKS       DDAXTN                                     AR865343
     C                   ENDSL                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
     C                   ENDIF                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
     C                   ENDIF
      *
     C**********         ENDSR                                                                CLE041
     C     EVTRCA        ENDSR                                                                CLE041
      *****************************************************************                       CLE147
     C/EJECT                                                                                  CLE147
      *****************************************************************                       CLE147
      ** SRLIVE  - Check Live Transaction Attached to the Facility                            CLE147
      *****************************************************************                       CLE147
                                                                                              CLE147
     C     SRLIVE        BEGSR                                                                CLE147
                                                                                              CLE147
     C                   MOVEL     DDCSSN        KCNUM                                        CLE147
     C                   MOVE      DDFACT        KFACT                                        CLE147
     C                   MOVE      DDFCNO        KFCNO                                        CLE147
                                                                                              CLE147
      ** Check Loans attached to the Facility                                                 CLE147
     C     KFCLT         CHAIN     LELOANLC                           10                      CLE147
     C                   IF        *IN10 = *OFF                                               CLE147
     C                   MOVE      'Y'           W#LIVE                                       CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
      ** Check Account attached to the facility for live account                              CLE147
     C                   IF        W#LIVE <> 'Y'                                              CLE147
     C     KFCLT         CHAIN     ACCNTLB                            10                      CLE147
     C                   IF        *IN10 = *OFF                                               CLE147
     C                   MOVE      'Y'           W#LIVE                                       CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
      ** Check live Manual Utilisation attached to the Facility                               CLE147
     C                   IF        W#LIVE <> 'Y'                                              CLE147
     C     KFCLT         CHAIN     LEMNFULA                           10                      CLE147
     C                   IF        *IN10 = *OFF                                               CLE147
     C                   MOVE      'Y'           W#LIVE                                       CLE147
     C                   ENDIF                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
      ** Check Deals extension files attached to the facility                                 CLE147
     C                   IF        W#LIVE <> 'Y'                                              CLE147
     C     KFCLT         SETLL     DLDLDQL0                                                   CLE147
     C     KFCLT         READE     DLDLDQL0                               10                  CLE147
                                                                                              CLE147
     C                   DOW       NOT %EOF(DLDLDQL0)                                         CLE147
                                                                                              CLE147
     C                   MOVE      DQF1DLNO      KDLNO                                        CLE147
     C     KDLNO         CHAIN     DEALSALL                           10                      CLE147
                                                                                              CLE147
      ** Check if deal transaction read is live                                               CLE147
     C                   IF        DLRECI = 'D' AND *IN10 = *OFF                              CLE147
     C                   MOVE      'Y'           W#LIVE                                       CLE147
     C                   LEAVE                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
     C     KFCLT         READE     DLDLDQL0                               10                  CLE147
                                                                                              CLE147
     C                   ENDDO                                                                CLE147
     C                   ENDIF                                                                CLE147
                                                                                              CLE147
     C                   ENDSR                                                                CLE147
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBTIN   - Validate Bill/Telex ind
      *****************************************************************

     C     VBTIN         BEGSR

      **  Must be be 'B', 'T', 'N' or blank
     C     DDBTIN        IFEQ      *BLANKS
     C                   MOVE      BPBTIN        DDBTIN
     C                   ELSE
     C     DDBTIN        IFNE      'B'
     C     DDBTIN        ANDNE     'T'
     C     DDBTIN        ANDNE     'N'
     C                   Move      'N'           DDBTINOK
     C                   Add       1             Idx
     C                   Movel     'DDBTIN'      FldNamXAr(Idx)
     C                   Movel     'LEF0052'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBLDY   - Validate Billing days
      *****************************************************************
     C     VBLDY         BEGSR

     C                   SELECT
      *
     C     DDBLDY        WHENEQ    *BLANKS
     C     DDBTIN        ANDEQ     'T'
     C                   MOVEL     '0'           DDBLDY
     C                   MOVE      A6TXND        DDBLDY
      *
     C     DDBLDY        WHENEQ    *BLANKS
     C     DDBTIN        ANDEQ     'B'
     C                   MOVE      BPDBDY        DDBLDY
      *
     C     DDBLDY        WHENEQ    *BLANKS
     C     DDBTIN        ANDEQ     'N'
     C                   MOVE      '00'          DDBLDY
      *
     C     DDBLDY        WHENNE    *BLANKS
     C                   TESTN                   DDBLDY               19
     C     *IN19         IFEQ      *OFF
     C                   Move      'N'           DDBLDYOK
     C                   Add       1             Idx
     C                   Movel     'DDBLDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0053'     MsgIDXAr(Idx)
     C                   ELSE

     C                   MOVE      DDBLDY        W#BLDY            2 0
     C     DDBTIN        IFEQ      'B'
     C     W#BLDY        IFGT      30
     C     W#BLDY        ORLT      1
     C                   Move      'N'           DDBLDYOK
     C                   Add       1             Idx
     C                   Movel     'DDBLDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0053'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C     DDBTIN        IFEQ      'T'
     C     W#BLDY        IFGT      9
     C     W#BLDY        ORLT      1
     C                   Move      'N'           DDBLDYOK
     C                   Add       1             Idx
     C                   Movel     'DDBLDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0053'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C     DDBTIN        IFEQ      'N'
     C     W#BLDY        ANDNE     0
     C                   Move      'N'           DDBLDYOK
     C                   Add       1             Idx
     C                   Movel     'DDBLDY'      FldNamXAr(Idx)
     C                   Movel     'LEF0053'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACSQ   - Validate Account seq
      *****************************************************************
     C     VACSQ         BEGSR

      *
      **  Default Account Sequence Number to '01' if blank
     C     DDACSQ        IFEQ      *BLANK
     C                   MOVE      01            DDACSQ
     C                   ELSE
      *
      **  Account Sequence Number must be numeric between 01-99
     C                   TESTN                   DDACSQ               19
     C     *IN19         IFEQ      '0'
     C                   Move      'N'           DDACSQOK
     C                   Add       1             Idx
     C                   Movel     'DDACSQ'      FldNamXAr(Idx)
     C                   Movel     'LEF0259'     MsgIDXAr(Idx)
      *
      **  Value must be between 01 and 99
     C                   ELSE
     C     DDACSQ        IFLT      '01'
     C     DDACSQ        ORGT      '99'
     C                   Move      'N'           DDACSQOK
     C                   Add       1             Idx
     C                   Movel     'DDACSQ'      FldNamXAr(Idx)
     C                   Movel     'LEF0260'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CLE034
      ** VOVAM   - Validate Overline Amount                                                   CLE034
      *****************************************************************                       CLE034
     C     VOVAM         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C                   MOVE      'N'           FacAmChg                                     CLE034
      *                                                                                       CLE034
      **  Must be valid per ZALIGN                                                            CLE034
      *                                                                                       CLE034
     C                   MOVE      *BLANKS       ZFIELD                                       CLE034
     C                   MOVE      DDOVAM        ZFIELD                                       CLE034
     C                   Z-ADD     W#NBDP        ZADEC                                        CLE034
     C     13            SUB       W#NBDP        ZADIG                                        CLE034
     C                   EXSR      ZALIGN                                                     CLE034
     C     *IN99         IFEQ      *ON                                                        CLE034
     C                   Move      'N'           DDOVAMOK                                     CLE034
     C                   Add       1             Idx                                          CLE034
     C                   Movel     'DDOVAM'      FldNamXAr(Idx)                               CLE034
     C                   Movel     'LEF0440'     MsgIDXAr(Idx)                                CLE034
     C                   ELSE                                                                 CLE034
     C     *LIKE         DEFINE    FAMT          W#OVAM                                       CLE034
     C                   MOVE      ZFIELD        W#OVAM                                       CLE034
     C     W#OVPC        IFNE      0                                                          CLE034
     C     DDOVAM        ANDNE     *BLANKS                                                    CLE106
      *                                                                                       CLE034
     C                   Move      'N'           DDOVAMOK                                     CLE034
     C                   Add       1             Idx                                          CLE034
     C                   Movel     'DDOVAM'      FldNamXAr(Idx)                               CLE034
     C                   Movel     'LEF0441'     MsgIDXAr(Idx)                                CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      * Fields from LEVFCIMPD - FM File
     C                   MOVEL     'A'           FPRCTP
     C                   MOVEL     DDACTN        FPCHTP
     C                   MOVEL     DDCSSN        FPCNUM
     C                   MOVEL     DDFACT        FPFACT
     C                   MOVEL     DDFCNO        FPFCNO
     C                   MOVEL     DDBRCA        FPBRCA
     C                   MOVEL     DDFCCY        FPFCCY
     C                   Z-ADD     W#FAMT        FPFAMT
     C                   Z-ADD     W#OVAM        FPOVAM                                       CLE034
     C                   Z-ADD     W#OVPC        FPOVPC
     C                   MOVEL     DDFCTI        FPFCTI
     C                   Z-ADD     W#DTAP        FPDTAP
     C                   MOVEL     DDRVCR        FPRVCR
     C                   MOVEL     DDMCCY        FPMCCY
     C                   MOVEL     DDSECI        FPSECI
     C                   Z-ADD     W#DTEX        FPDTEX
     C                   MOVEL     DDCRSK        FPCRSK
     C                   MOVEL     DDMCSI        FPMCSI
     C                   MOVEL     DDNACD        FPNACD
     C                   Z-ADD     RVCD          FPRVCD
     C                   Z-ADD     W#DLFS        FPDLFS
     C                   Z-ADD     W#NOMR        FPNOMR
     C                   Z-ADD     W#RVDT        FPRVDT
     C                   MOVEL     DDRVFR        FPRVFR
     C                   MOVE      DDRVDY        FPRVDY
     C                   MOVEL     DDACOF        FPACOF
     C                   MOVEL     DDORBR        FPORBR
     C                   MOVEL     DDTRCA        FPTRCA
     C                   MOVE      DDCANM        FPCANM
     C                   MOVE      DDCAFT        FPCAFT
     C                   MOVE      DDCAFN        FPCAFN
     C                   MOVEL     DDNAR1        FPNAR1
     C                   MOVEL     DDNAR2        FPNAR2
     C                   MOVEL     DDNAR3        FPNAR3
     C                   MOVEL     DDNAR4        FPNAR4
     C                   MOVE      DDACSQ        FPACSQ
      *                                                                                       CER020
      ** Populate the two new dates to the valid file, if feature ON                          CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   Z-ADD     WRdPEXD       FPPEXD                                       CER020
     C                   Z-ADD     WRdPNXD       FPPNXD                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
     C/COPY WNCPYSRC,LEH00088

     C     DDACTN        IFEQ      'I'

     C     ModeOfop      IFEQ      '*FRONT'
     C                   MOVE      F1IUSR        FPIUSR
     C                   MOVE      F1XUSR        FPXUSR
     C                   MOVE      F1AUSR        FPAUSR
     C                   MOVE      'A'           FPFSTS
     C                   ELSE
     C                   MOVE      PSUSER        FPIUSR
     C     CLE002        IFEQ      'N'
     C     BPFAAU        OREQ      'N'
     C                   MOVE      'A'           FPFSTS
     C                   ELSE
     C                   MOVE      'C'           FPFSTS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     DDACTN        IFEQ      'X'

     C     ModeOfop      IFEQ      '*FRONT'
     C                   MOVE      F1IUSR        FPIUSR
     C                   MOVE      F1XUSR        FPXUSR
     C                   ENDIF

     C                   ENDIF

     C     DDACTN        IFEQ      'A'

     C     ModeOfop      IFEQ      '*FRONT'
     C                   MOVE      F1AUSR        FPAUSR
     C                   MOVE      F1XUSR        FPXUSR
     C                   MOVE      'A'           FPFSTS
     C                   ELSE
     C                   MOVE      PSUSER        FPAUSR
     C                   MOVE      *BLANKS       FPXUSR
      *
     C     CLE002        IFEQ      'N'
     C     BPFAAU        OREQ      'N'
     C                   MOVE      'A'           FPFSTS
     C                   ELSE
     C     FPFSTS        IFEQ      'A'
     C                   MOVE      'R'           FPFSTS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     @@RECI        IFEQ      'E'
     C     W#DTEX        ANDGT     RUND
     C                   MOVE      'D'           FPRECI
     C                   ENDIF
      *
     C                   ENDIF

     C     ModeOfop      IFEQ      '*FRONT'
     C                   MOVE      F1PCOB        FPPCOB
     C                   ELSE
     C                   MOVE      *BLANKS       FPPCOB
     C                   ENDIF

     C     ModeOfop      IFNE      '*FRONT'
     C     DDACTN        ANDEQ     'I'
     C     CLE106        ANDNE     'Y'                                                        CLE106

     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
                                                                                              CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD             7                          CLE148
     C                   PARM      'Y'           PUPDT             1                          CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT            8                          CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        FPPCRF
     C                   MOVE      '0001'        FPPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
      *
     C                   ELSE
      *
     C     ModeOfop      IFEQ      '*FRONT'
     C     CLE106        OREQ      'Y'                                                        CLE106
     C                   MOVE      F1TNRF        FPPCRF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Fields from LEVFCINPD - FN File
     C                   MOVEL     'B'           FNRCTP
     C                   MOVEL     DDACTN        FNCHTP
     C                   MOVEL     DDCSSN        FNCNUM
     C                   MOVEL     DDFACT        FNFACT
     C                   MOVEL     DDFCNO        FNFCNO
     C                   MOVEL     DDMBFC        FNMBFC
     C                   MOVEL     DDPRFC        FNPRFC
     C                   MOVEL     DDBTIN        FNBTIN
     C                   MOVE      DDBLDY        FNBLDY

     C     DDACTN        IFEQ      'A'

      **  If this is the first change of RVCR today then RVCD become
      **  run date
      **  and if RVCR has been changed to 'N' then initialise OAM
      **  outstanding amount array (for elements run date to end of array
     C     DDRVCR        IFNE      @@RVCR
     C     RUND          ANDNE     @@RVCD
      *
     C                   Z-ADD     RUND          FPRVCD
      *
     C     DDRVCR        IFEQ      'N'
      *
     C                   Z-ADD     1             A                 2 0
     C     RUND          LOOKUP    RUN(A)                                 19
     C     *IN19         IFEQ      *ON
     C     A             DOWLE     10
     C                   Z-ADD     FPFAMT        OAM(A)
     C                   ADD       1             A
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@@OAM1       FNOAM1
     C                   Z-ADD     @@@OAM2       FNOAM2
     C                   Z-ADD     @@@OAM3       FNOAM3
     C                   Z-ADD     @@@OAM4       FNOAM4
     C                   Z-ADD     @@@OAM5       FNOAM5
     C                   Z-ADD     @@@OAM6       FNOAM6
     C                   Z-ADD     @@@OAM7       FNOAM7
     C                   Z-ADD     @@@OAM8       FNOAM8
     C                   Z-ADD     @@@OAM9       FNOAM9
     C                   Z-ADD     @@@OA10       FNOA10

     C                   ENDIF

     C                   ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *  CHKOTS :
      ***********************************************************
     C     CHKOTS        BEGSR
      *
     C                   MOVE      'N'           W#ERR4            1
      *
      **  Check to see if new expiry date is less than any of the
      **  customer outstanding loan expiry dates.
     C**********         Z-ADD     @@CNUM        K8CNUM                                       CSD027
     C                   EVAL      K8CNUM = @@CNUM                                            CSD027
     C                   Z-ADD     @@FACT        K8FACT
     C                   Z-ADD     @@FCNO        K8FCNO
      *
     C     K#KY08        SETLL     LEREF
     C     K#KY08        READE     LEREF                                  80
      *
     C     *IN80         DOWEQ     *OFF
      *
     C     RFRECI        IFEQ      'D'
     C**********         Z-ADD     RFLNNO        K5LNRF                                       CLE148
     C                   MOVEL     RFLNNO        K5LNRF                                       CLE148
     C                   MOVE      'A'           K5RCTP
     C     K#KY05        CHAIN     CLOAN                              80
      *
     C     ZDAYNO        IFLT      CLMDAT
     C                   MOVE      'Y'           W#ERR4
     C                   LEAVE
     C                   ENDIF

     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C     CLMDAT        IFEQ      0
     C     CLRECI        OREQ      'D'
     C     CLRECI        OREQ      'M'
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           W#ERR4
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     K#KY08        READE     LEREF                                  80
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER020
      *                                                               *                       CER020
      *  VPExpDat - Default and Validate new Expiry Dates             *                       CER020
      *                                                               *                       CER020
      *  Called by: MAIN Processing                                   *                       CER020
      *                                                               *                       CER020
      *  Calls: None                                                  *                       CER020
      *                                                               *                       CER020
      *****************************************************************                       CER020
     C     VPExpDat      BEGSR                                                                CER020
      *                                                                                     BUG23786
      ** Skip processing when Action is 'REJECT'                                            BUG23786
      *                                                                                     BUG23786
     C**********         IF        DDREJT <> 'Y'                                   BUG23786 AR740355
     C                   IF        DDREJT = *BLANKS                                         AR740355
      *                                                                                       CER020
      ** Initialize the dates                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      DDPEXD = *BLANKS                                           CER020
     C                   EVAL      DDPNXD = *BLANKS                                           CER020
      *                                                                                       CER020
      ** Store Current Expiry Date, as on screen, in DDMMYY format                            CER020
      *                                                                                       CER020
     C                   EVAL      WCExpRDt = W#DTEX                                          CER020
     C                   EVAL      PZDayNo = W#DTEX                                           CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE2'                                                   CER020
     C                   PARM                    PZDayNo                                      CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PZDate                                       CER020
     C                   PARM                    PZaDate                                      CER020
      *                                                                                       CER020
      ** Store Expiry Date in DDMMYY format                                                   CER020
      *                                                                                       CER020
     C                   MOVEL     PZDate        WCSExpDt                                     CER020
      *                                                                                       CER020
      ** Populate Key List Fields                                                             CER020
      *                                                                                       CER020
     C                   MOVEL     DDCSSN        KFCNUM                                       CER020
     C                   MOVEL     DDFACT        KFFACT                                       CER020
     C                   MOVEL     DDFCNO        KFFCNO                                       CER020
     C                   EVAL      KFRCDT = 'A'                                               CER020
      *                                                                                       CER020
      ** Retrieve Expiry Dates, if present                                                    CER020
      *                                                                                       CER020
     C     KLFCLT        CHAIN     FCLTY                                                      CER020
      *                                                                                       CER020
     C                   IF        %FOUND(FCLTY)                                              CER020
      *                                                                                       CER020
      ** Populate Screen Fields                                                               CER020
      *                                                                                       CER020
     C                   IF        PEXD <> *ZEROS                                             CER020
     C                   EVAL      PZDayNo = PEXD                                             CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE2'                                                   CER020
     C                   PARM                    PZDayNo                                      CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PZDate                                       CER020
     C                   PARM                    PZaDate                                      CER020
      *                                                                                       CER020
     C                   MOVEL     PZDate        DDPEXD                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PNXD <> *ZEROS                                             CER020
     C                   EVAL      PZDayNo = PNXD                                             CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE2'                                                   CER020
     C                   PARM                    PZDayNo                                      CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PZDate                                       CER020
     C                   PARM                    PZaDate                                      CER020
      *                                                                                       CER020
     C                   MOVEL     PZDate        DDPNXD                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** In Amend Mode access the 'old' expiry date from the facilities                       CER020
      ** file                                                                                 CER020
      *                                                                                       CER020
     C                   IF        DDACTN = 'A'                                               CER020
      *                                                                                       CER020
     C                   EVAL      PZDayNo = DTEX                                             CER020
     C                   CALLB     'ZDATE2'                                                   CER020
     C                   PARM                    PZDayNo                                      CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PZDate                                       CER020
     C                   PARM                    PZaDate                                      CER020
      *                                                                                       CER020
      ** Store Expiry Date in 'DDMMYY' format                                                 CER020
      *                                                                                       CER020
     C                   MOVEL     PZDate        WCExpDat                                     CER020
      *                                                                                       CER020
      ** If Expiry Date changed                                                               CER020
      *                                                                                       CER020
     C                   IF        DTEX <> WCExpRDt                                           CER020
      *                                                                                       CER020
     C                   EVAL      DDPNXD = DDPEXD                                            CER020
     C                   EVAL      DDPEXD = WCExpDat                                          CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
      ** If No Record Exists, default the two new dates with the                              CER020
      ** current expiry date on screen                                                        CER020
      *                                                                                       CER020
     C                   MOVEL     WCSExpDt      DDPEXD                                       CER020
     C                   MOVEL     WCSExpDt      DDPNXD                                       CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                     BUG23786
     C                   ENDIF                                                              BUG23786
      *                                                                                       CER020
      ** Convert Previous and Penultimate Expiry Dates to Day number                          CER020
      *                                                                                       CER020
      ** Previous Expiry Date                                                                 CER020
      *                                                                                       CER020
     C                   MOVE      DDPEXD        PZDateA                                      CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE1'                                                   CER020
     C                   PARM                    PZDateA                                      CER020
     C                   PARM                    PZdayNo                                      CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    ErrorFlag         1                          CER020
      *                                                                                       CER020
     C                   EVAL      WRdPEXD = PZdayNo                                          CER020
      *                                                                                       CER020
      ** Penultimate Expiry Date                                                              CER020
      *                                                                                       CER020
     C                   MOVE      DDPNXD        PZDateA                                      CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE1'                                                   CER020
     C                   PARM                    PZDateA                                      CER020
     C                   PARM                    PZdayNo                                      CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    ErrorFlag         1                          CER020
      *                                                                                       CER020
     C                   EVAL      WRdPNXD = PZdayNo                                          CER020
      *                                                                                       CER020
     C                   ENDSR                                                                CER020
      *****************************************************************                       CER020
      /EJECT                                                                                  CER020
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
      ** Customer Primary Details
     C                   PARM                    TranInPrim
      ** Customer Secondary Details                                                           CLE106
     C                   PARM                    TranInSeco                                   CLE106
      ** Current Facility FM file
     C                   PARM                    FacmFilFmt
      ** Current Facility FN file
     C                   PARM                    FacnFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      * CLE002
     C                   PARM                    CLE002            1
      * CLE005
     C                   PARM                    CLE005            1
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1

      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      * Customer Extra Data file data
     C                   PARM                    ExtData         500

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
      * Start date used in another module
     C                   PARM                    WWDTAP            5
      * Expiry date used in another module
     C                   PARM                    WWDTEX
      * Decimal places
     C                   PARM                    WWNBDP            1
      * CA currency
     C                   PARM                    WCACCY            3
      * Facility amount
     C                   PARM                    W#FAMT
      * Account officer to default
     C                   PARM                    WBLACF
      * Credit Agreement Change Flag                                                          CLE147
     C                   PARM                    CADetails                                    CLE147
      *
      **  GET ZMUSER to access default branch.
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  GET RUNDAT to access multi-branching indicator
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEFCIP1VL'   DBPGM
     C                   OUT       LDA
      *
      ** Define work field
     C     *LIKE         DEFINE    A6NBDP        W#NBDP
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     BPAURV        IFEQ      'Y'
     C                   MOVE      *ON           *IN88
     C                   MOVE      'Y'           W#IN88            1
     C                   ELSE
     C                   MOVE      *OFF          *IN88
     C                   MOVE      'N'           W#IN88
     C                   ENDIF
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
                                                                                              CLE041
      ** Access Switchable SAR details for the existence of CLE025                            CLE041
                                                                                              CLE041
     C                   CALLB     'AOSARDR0'                                                 CLE041
     C                   PARM      *BLANK        @RTCD                                        CLE041
     C                   PARM      '*VERIFY'     @OPTN                                        CLE041
     C                   PARM      'CLE025'      @SARD                                        CLE041
      *                                                                                       CLE041
     C                   IF        @RTCD = *BLANK                                             CLE041
     C                   EVAL      CLE025 = 'Y'                                               CLE041
     C                   ELSE                                                                 CLE041
     C                   EVAL      CLE025 = 'N'                                               CLE041
     C                   ENDIF                                                                CLE041
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *                                                                                       CLE034
      ** Determine if CLE004 is installed                                                     CLE034
      *                                                                                       CLE034
     C                   CALL      'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
                                                                                              CLE034
     C     @RTCD         IFNE      *BLANKS                                                    CLE034
     C                   MOVEL     'N'           CLE034            1                          CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVEL     'Y'           CLE034                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE106
      ** Access Switchable SAR details for the existence of CLE106                            CLE106
      *                                                                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANK        @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CER020
      ** Access Switchable SAR details for the existence of CER020                            CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRtcd                                        CER020
     C                   PARM      '*VERIFY'     POptn                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C     PRtcd         IFEQ      *BLANKS                                                    CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CLE147
      ** Access Switchable SAR details for the existence of CLE147                            CLE147
      *                                                                                       CLE147
     C                   CALLB     'AOSARDR0'                                                 CLE147
     C                   PARM      *BLANKS       PRtcd                                        CLE147
     C                   PARM      '*VERIFY'     POptn                                        CLE147
     C                   PARM      'CLE147'      PSard                                        CLE147
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE147
      *                                                                                       CLE147
     C     PRtcd         IFEQ      *BLANKS                                                    CLE147
     C                   EVAL      CLE147 = 'Y'                                               CLE147
     C                   ELSE                                                                 CLE147
     C                   EVAL      CLE147 = 'N'                                               CLE147
     C     PRtcd         IFNE      '*NRF   '                                                  CLE147
     C     *LOCK         IN        LDA                                                        CLE147
     C                   Z-ADD     5             DBASE                                        CLE147
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE147
     C                   MOVEL     'CLE147'      DBKEY                                        CLE147
     C                   MOVEL     'LEFCIP1VL'   DBPGM                                        CLE147
     C                   OUT       LDA                                                        CLE147
     C                   EXSR      *PSSR                                                      CLE147
     C                   ENDIF                                                                CLE147
     C                   ENDIF                                                                CLE147
      *                                                                                       CLE160
      ** Access Switchable SAR details for the existence of CLE160                            CLE160
      *                                                                                       CLE160
     C                   EVAL      CLE160 = 'N'                                               CLE160
     C                   CALLB     'AOSARDR0'                                                 CLE160
     C                   PARM      *BLANKS       PRTCD                                        CLE160
     C                   PARM      '*VERIFY'     POPTN                                        CLE160
     C                   PARM      'CLE160'      PSARD                                        CLE160
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE160
      *                                                                                       CLE160
     C     PRTCD         IFEQ      *BLANKS                                                    CLE160
     C                   EVAL      CLE160 = 'Y'                                               CLE160
     C                   ENDIF                                                                CLE160
      *                                                                                       CLE160
      ** Check for Revolving Credit Indicator default system value                            CLE160
      *                                                                                       CLE160
     C                   CALLB     'AOSVALR0'                                                 CLE160
     C                   PARM      *BLANKS       PRTCD                                        CLE160
     C                   PARM      DftRevCrInd   PSysVal01                                    CLE160
     C                   PARM      *BLANKS       PCurSet01                                    CLE160
     C                   PARM                    PSysVal02                                    CLE160
     C                   PARM                    PCurSet02                                    CLE160
     C                   PARM                    PSysVal03                                    CLE160
     C                   PARM                    PCurSet03                                    CLE160
     C                   PARM                    PSysVal04                                    CLE160
     C                   PARM                    PCurSet04                                    CLE160
     C                   PARM                    PSysVal05                                    CLE160
     C                   PARM                    PCurSet05                                    CLE160
     C                   PARM                    PSysVal06                                    CLE160
     C                   PARM                    PCurSet06                                    CLE160
     C                   PARM                    PSysVal07                                    CLE160
     C                   PARM                    PCurSet07                                    CLE160
     C                   PARM                    PSysVal08                                    CLE160
     C                   PARM                    PCurSet08                                    CLE160
     C                   PARM                    PSysVal09                                    CLE160
     C                   PARM                    PCurSet09                                    CLE160
     C                   PARM                    PSysVal10                                    CLE160
     C                   PARM                    PCurSet10                                    CLE160
      *                                                                                       CLE160
     C                   IF        PRTCD <> *BLANKS                                           CLE160
     C                   Eval      DBFILE = 'SDSVALPD'                                        CLE160
     C                   Eval      DBASE = 900                                                CLE160
     C                   Eval      DBKEY = '*KEY    '                                         CLE160
     C                   EXSR      *PSSR                                                      CLE160
     C                   ENDIF                                                                CLE160
      *                                                                                       CLE160
     C                   MOVEL     PCurSet01     DftCRInd                                     CLE160
      *                                                                                       CLE160
     C/COPY WNCPYSRC,LEH01208
      *                                                                                       CER020
      ** Key list for facility                                                                CER020
      *                                                                                       CER020
     C     KLFCLT        KLIST                                                                CER020
     C                   KFLD                    KFCNUM                                       CER020
     C                   KFLD                    KFFACT                                       CER020
     C                   KFLD                    KFFCNO                                       CER020
     C                   KFLD                    KFRCDT                                       CER020

      **  Facility
     C     K#KY03        KLIST
     C**********         KFLD                    K3CNUM            6 0                        CSD027
     C                   KFLD                    K3CNUM            6                          CSD027
     C                   KFLD                    K3FACT            3 0
     C                   KFLD                    K3FCNO            2 0
     C                   KFLD                    K3RCTP            1

      ** used for CLOAN
     C     K#KY05        KLIST
     C**********         KFLD                    K5LNRF            6 0                        CLE148
     C                   KFLD                    K5LNRF            6                          CLE148
     C                   KFLD                    K5RCTP            1

      ** Key for LEFEDL1
     C     K#KY07        KLIST
     C**********         KFLD                    K7CNUM            6 0                        CSD027
     C                   KFLD                    K7CNUM            6                          CSD027
     C                   KFLD                    K7FCTY            5 0

      **  Used for LEREF
     C     K#KY08        KLIST
     C**********         KFLD                    K8CNUM            6 0                        CSD027
     C                   KFLD                    K8CNUM            6                          CSD027
     C                   KFLD                    K8FACT            3 0
     C                   KFLD                    K8FCNO            2 0

      **  Used for LEFCAML0
     C     K#KY09        KLIST
     C                   KFLD                    K9BRCA            3
     C**********         KFLD                    K9CUST            6 0                        CSD027
     C                   KFLD                    K9CUST            6                          CSD027
     C                   KFLD                    K9FCTY            3 0
     C                   KFLD                    K9FTNO            2 0

      **  Used for LEFCLTL9
     C     K#KY10        KLIST
     C**********         KFLD                    K0CANM            6 0                        CSD027
     C                   KFLD                    K0CANM            6                          CSD027
     C                   KFLD                    K0CAFT            3 0
     C                   KFLD                    K0CAFN            2 0

     C     KFCLT         KLIST                                                                CLE147
     C                   KFLD                    KCNUM             6                          CLE147
     C                   KFLD                    KFACT             3 0                        CLE147
     C                   KFLD                    KFCNO             2 0                        CLE147
                                                                                              CLE147
     C     PLIST1        PLIST
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    FKEY              3
     C     SDFACT        PARM      SDFACT        DSFDY

     C     PLIST2        PLIST
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CKEY              3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PLIST4        PLIST
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    ACOKEY            2
     C     SDACOF        PARM      SDACOF        DSFDY


     C     PLIST5        PLIST
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CTRYKY            2
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************

     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZALIGNZ2LE
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
