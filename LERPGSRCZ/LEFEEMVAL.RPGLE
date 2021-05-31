     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee screen validation')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  LEFEEMVAL -  Fee screen  Validation                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR375891B          Date 26Aug20               *
      *  Prev Amend No. AR375892           Date 26Aug20               *
      *                 MD031003           Date 08Sep20               *      
      *                 MD052696           Date 04Apr19               *
      *                 MD004904           Date 04Apr19               *
      *                 AR1049357          Date 04Apr19               *
      *                 AR994776           Date 04Apr19               *
      *                 MD053942           Date 23Jul19               *
      *                 CER050             Date 16Jun19               *
      *                 MD053837           Date 28Aug19               *
      *                 MD021377           Date 18Jul18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046370           Date 07Nov17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD028931           Date 13May14               *
      *                 MD039016           Date 26May16               *
      *                 CLE141A            Date 28Apr16               *
      *                 CLE141             Date 08Feb16               *
      *                 MD039613           Date 05Jul16               *
      *                 MD036962           Date 26Apr16               *
      *                 CLE164             Date 18Aug14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027024           Date 19Aug14               *
      *                 MD022414           Date 18Sep13               *
      *                 MD022378           Date 16Sep13               *
      *                 AR1035111          Date 18Jun13               *
      *                 MD020632           Date 28May13               *
      *                 MD020592           Date 23May13               *
      *                 AR1073605          Date 06May13               *
      *                 AR1053740          Date 13Nov12               *
      *                 AR760725           Date 09Feb13               *
      *                 AR1077167          Date 17Jan13               *
      *                 AR1072101          Date 28Dec12               *
      *                 AR826996B          Date 09Nov12               *
      *                 AR693137           Date 01Aug12               *
      *                 AR549983           Date 01Aug12               *
      *                 AR402732           Date 01Aug12               *
      *                 AR322844           Date 01Aug12               *
      *                 AR318270           Date 01Aug12               *
      *                 AR314017           Date 01Aug12               *
      *                 263801             Date 01Aug12               *
      *                 263560             Date 01Aug12               *
      *                 262461A            Date 01Aug12               *
      *                 262754             Date 01Aug12               *
      *                 262672             Date 01Aug12               *
      *                 262513             Date 01Aug12               *
      *                 262461             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR747729           Date 20Apr11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 AR738851           Date 30Mar11               *
      *                 257478             Date 29Oct08               *
      *                 256199             Date 07Aug08               *
      *                 CLE073             Date 13May08               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 248820             Date 10Jul07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248566             Date 06Jul07               *
      *                 CAS019             Date 20Apr07               *
      *                 245071             Date 30Mar07               *
      *                 242377             Date 30Mar07               *
      *                 242784             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241581             Date 18Aug06               *
      *                 241724 (Gems)      Date 16Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG10955           Date 21Mar06               *
      *                 237347             Date 08Feb06               *
      *                 BUG11390           Date 08Jun06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CLE054             Date 15Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10933           Date 20Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9988            Date 20Jan06               *
      *                 BUG9496            Date 06Dec05               *
      *                 BUG8565            Date 15Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 05May03               *
      *                 BUG7528            Date 14Sep05               *
      *                 CAS011             Date 16May05               *
      *                 BUG7290            Date 27May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3729            Date 21Jul04               *
      *                 CLE025             Date 20May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084             Date 26Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR375891B - Amendment to Settlement details do not reflect   *
      *              on file. Ensure currency is set correctly.       *
      *              (Child: AR375892)                                *
      *  AR375892 - Incorrect projection for fees attached to parts   *
      *             sold loan. Use Payment Settlement instead of      *
      *             Receipt Settlement.                               *
      *  MD031003 - Facility Fee amount divided by 100 upon rejection *
      *             of change in Fee end date.                        *
      *  MD052696 - Unauthorised Loans and fees not visible in WIP,   *
      *             after rejecting amendments to their maturity dates*
      *  MD004904 - Rejection causes incorrect exchange rate and      *
      *             fee amount1-5. Enhanced fix AR9947776.            *
      *           - Applied for MD052696                              *
      *  AR1049357 - Rejection of fee causes the Fee amount to be     *
      *              corrupted. Details should be reverted correctly. *
      *              Enhanced fix AR994776. (Child: AR1049358)        *
      *           - Applied for MD052696                              *
      *  AR994776 - Fees remains unauthorised after rejection of      *
      *             amendment. Details are not reverted correctly.    *
      *             Add a flag if action is reject to revert back the *
      *             details of fees. (Child: AR994777)                *
      *           - Applied for MD052696                              *
      *  MD053942 - Incorrect defaulting of DDEXRT for loan fees. Add *
      *             exchange rate default process for loan fee only   *
      *             when fee currency not equal to loan currency.     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD053837 - Classification out of range for initial date if   *
      *             rundate falls on the last day of classification.  *
      *             Use %LOOKUP if rundate is equal to start date +   *
      *             period days.                                      *
      *  MD021377 - Reversed Fee Rate Changes have FCRECI = 'R'.      *
      *             LER0238 should be checked against live fees only. *
      *  CLE071 - Value Dating of Rate Changes to Fees                *
      *  MD046370 - Component LERC135 is looping in COB. If system    *
      *             value AutoEndCalcLoanFee is 'Y' & loan already has*
      *             a zero amount, prevent fee from being inserted    *
      *             with start date that falls after date when loan's *
      *             principal is zero. Also, if system value is 'Y',  *
      *             prevent fee end date that falls after loan        *
      *             maturity date and if system value is 'N', this is *
      *             allowed. Also, prevent fee start date that falls  *
      *             after loan maturity date. Applicable for all      *
      *             calculated loan fee.                              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD028931 - Incorrect defaulting of exhange rate for loan fees*
      *             Added check on FA_FCCY not equal to blank to      *
      *             suppress unncessary default process.              *
      *  MD039016 - Different event codes for BDC validation in       *
      *             various Lending APIs                              *
      *  CLE141A - CLE141 Change Control 1                            *
      *  CLE141 - Currency and Location Business Day Convention       *
      *  MD039613 - Fee Amount field in FEEM validates when Facility  *
      *             Fee is inserted                                   *
      *  MD036962 - Incorrect validation if fee amount left blank     *
      *            when CLE073 is enabled.                            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           Reverse fix AR314017 due to LEACCNPD being redundant*
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD027024 - When loan is more than 999 days PD impossible to  *
      *             amend as always get error on Reporting PD Class'n *
      *             and Basle II Reporting PD Class'n                 *
      *  MD022414 - It is impossible to reduce Fee end date for FEEM  *
      *             if "Frequency/Day" are filled                     *
      *  MD022378 - Impossible to amend Amount/Precent Indicator      *
      *  AR1035111 - Will not allow a combination of Frequency 'P'    *
      *              with calculation type other than '90'.           *
      *              (Child: AR1035112)                               *
      *  MD020632 - System automatically changed calculation basis    *
      *             after pressing confirm complete                   *
      *  MD020592 - System is not allowing to amend existing fee      *
      *  AR1073605 - The system does not validate the rate field for  *
      *              calculated fees correctly. Check if the inserted *
      *              rate for fees with non tierred and threshold     *
      *              calculation type is zero or blank.               *
      *              (Child: AR1073606)                               *
      *  AR1053740 - Adjustment to yield validation prevents amendment*
      *              of facility fees details. Reverse some parts of  *
      *              fix BUG10933. Validation for AUADJY should be    *
      *              for loan fees only. (Child: AR1053741)           *
      *  AR760725 - Loan fees with Calt 99 are still in live though   *
      *             there are no oustanding past due and end date is  *
      *             less than rundate. 'Z-ADD WFAMT VFAMTO' in SR/SET-*
      *             UPVALID is commented out to ensure that during    *
      *             amend/authorize, value of FEFAMT would not be     *
      *             defaulted to FEAMTO. (Child: AR760726)            *
      *  AR1077167 - Base Rate for PDCL Interest is invalid when it   *
      *              is blank.                                        *
/*    *  AR1072101 - Event Code error encountered when creating fee   *
      *  AR826996B- Validate Base Rate Code + Currency in SDBSRTPD    *
      *             for Fess PDCL generation. (Child: AR826997B)      *
      *  AR693137 - If pre-deal check is defined, Receipt settlement  *
      *             should be equal to 01, 05, 08 or 14. Fix patterned*
      *             from AR634878/A. (Child: AR693138)                *
      *  AR549983 - Prevent input of Fees with A/C indicator =  C     *
      *           - Remove 262461A as it isn't relevant to Fees.      *
      *             (Child: AR549984)                                 *
      *  AR402732 - Unable to create specific PDCL for fee            *
      *           - Don't allow input of Advice/Confirmed indicator   *
      *             = 'C' if Fee end date is in the past or is zero.  *
      *             the Fee does not exist or whether it exists but   *
      *             has End date in the past.                         *
      *             (Child: AR402733)                                 *
      *  AR322844 - Component LERC135 failed in EOM COB               *
      *           - Failure of Component LERC135 was encountered due  *
      *             to incorrect calculation type for calculated loan *
      *             fees.  Amended ECTP to contain 90, 97, 98 and 99  *
      *             only for CLE073 and CLE134.                       *
      *             (Child: AR322845)                                 *
      *  AR318270 - CLE134 formatting error in amounts. Recompile.    *
      *             (Child: AR321380)                                 *
      *  AR314017 - CLE134 LEC0459 failed in COB # 10 in BB           *
      *           - PONS/RONS warning if changed with LEACCNPD records*
      *             (Child: AR314018)                                 *
      *  263801 - P2: CLE134 API FEEM Wrong interpretaion of DDSFPM   *
      *  263560 - Format dates correctly for output parameter.        *
      *  262461A- (Reopen) - Error LER5573 should not be output if    *
      *           Loan type starts by X, Y or Z.                      *
      *  262754 - Corrected setting of facility key. Recompile        *
      *  262672 - Fee Input fails with MidasPlus error                *
      *         - Modified to only set/validate suspense details when *
      *           suspense fees allowed. (Recomp)                     *
      *  262513 - CLE134 Amendment to correct numeric formatting error*
      *  262461 - COB failed in component LEC07000 00001              *
      *         - CLE134 PDCL additional validation on DDEADV         *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  AR747729 - System doesn't throw an error message when Fee    *
      *             Capitalisation is set to yes on (Child: AR747730) *
      *  CLE139 - Lending Fee Capitalisation                          *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  AR738851 - Calculation basis must be blank for               *
      *             calculation type 99 (Child:AR738852)              *
      *  257478 - CLE073: cannot amend due to sign validation when    *
      *           input of blank is stored as '+' for fixed fee loan  *
      *  256199 - CLE073: wrong error field for XLE0007 in XLE0008    *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  248820 - Fee Settlement Amount Always being set to zero      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248566 - Unable to input facility fee                        *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  245071 - The system gives unrelated ESM0912 settle. msg when *
      *           the next payment date is input incorrectly.         *
      *  242377 - When System Values for LoanCustOriginPurch = 'O',   *
      *           customer for fee that should be displayed should be *
      *           the original borrower for participations purchased. *
      *  242784 - Do not reset FldNameArr, IdxNew, WidNew so that     *
      *           errors previously stored are not deleted.           *
      *  241581 - Default DDESHR (Shared fee indicator)               *
      *  241724   - Work fields WPSTD and WPEND ( Fee start date and  *
      *             Fee end date) not being reset. Causes invalid     *
      *             dates to be written to file. (Gems)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10955-Ensure index counter of error messages for the      *
      *           calculation amounts are correct.                    *
      *  237347 - Default auto settlement indicator from ICD during   *
      *           insert when left blank by user.  Moved call to      *
      *           AOCLNDR0 to pick up change on ICD.                  *
      *  BUG11390 - Ok flags not initialized, database error occurs   *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CLE054 - Customer Lending Fees Default Auto-settle Indicator *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10933 - Non adjustment to yield fee codes should be       *
      *             allowed for facility fees                         *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9988 - Inappropriate validation against rate field 2      *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  BUG8565- Fee Exchange Rate Error                             *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  BUG7528- File fields incorrectly reset when not insert mode  *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  BUG7290- Percent Indicator is not setup correctly            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG3729 - LEC0609B failed in COB. LE0492 divide by zero.     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Midas Plus API development.                         *
      *           Incorrect blank value in Array FldNameArr.          *
      *           Renamed the Idx field in the *ENTRY to IdxNew.      *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
      *****************************************************************

      * Fees Settlement/Adjustment Detail
     FLEFEADL2  IF   E           K DISK    INFSR(*PSSR)
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)                                       CLE134
     F                                     PREFIX(pd_)                                        CLE134
     FLEPDUFL4  IF   E           K DISK    INFSR(*PSSR)                                       CLE134
     F                                     PREFIX(pd_)                                        CLE134
     FCLOANL4   IF   E           K DISK    INFSR(*PSSR)                                       CLE134
     F                                     PREFIX(pd_) RENAME(CLOANCLF:CLOANL4F)              CLE134
     FLEFEEDL0  IF   E           K DISK    INFSR(*PSSR)                                       CLE134
     F                                     PREFIX(pd_) RENAME(LEFEEDF:LEFEEDFL0)              CLE134
     F***LEACCNLB  UF A E           K DISK    INFSR(*PSSR)                           AR314017 CLE164
     F**********                           COMMIT                                    AR314017 CLE164
     FSDBSRTL0  IF   E           K DISK    INFSR(*PSSR)                                    AR826996B
     F                                                                                     AR826996B
     FLEHISTLA  IF   E           K DISK    INFSR(*PSSR)                                     MD046370
     F                                     PREFIX(HP_)                                      MD046370
      ** Fee Rate Change Amendment Details                                                    CLE071
     FLEFERCL1  IF   E           K DISK    INFSR(*PSSR)                                       CLE071
                                                                                              CLE071
      **  Compile time arrays

     D WCTP            S              2    DIM(14) CTDATA PERRCD(14)
     D***ECTP***       S              2    DIM(17) CTDATA PERRCD(17)                   CLE073 CLE134
     D***ECTP***       S              2    DIM(18) CTDATA PERRCD(18)                 CLE134 AR322844
     D ECTP            S              2    DIM(04) CTDATA PERRCD(04)                        AR322844

     D CLE141          S              1A                                                      CLE141
     D RetCode         S              7A                                                     CLE141A

      *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
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
      ** Ê End of automatically included D-specsÊ
      ** Ê =====================================Ê
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
      ** Error message fields received as parameters                                          CAS019
     D     Msg1        S                   LIKE(#MsgID)                                       CAS019
     D     Msg2        S                   LIKE(#MsgID)                                       CAS019
     D     Msg3        S                   LIKE(#MsgID)                                       CAS019
     D     Msg4        S                   LIKE(#MsgID)                                       CAS019
     D     Msg5        S                   LIKE(#MsgID)                                       CAS019
     D     Msg6        S                   LIKE(#MsgID)                                       CAS019
     D     Msg7        S                   LIKE(#MsgID)                                       CAS019
                                                                                              CAS019
      ** Warning error message fields received as parameters                                  CAS019
     D     WMSGID1     S                   LIKE(#MsgID)                                       CAS019
     D     WMSGID2     S                   LIKE(#MsgID)                                       CAS019
     D     WMSGID3     S                   LIKE(#MsgID)                                       CAS019
     D     WMSGID4     S                   LIKE(#MsgID)                                       CAS019
                                                                                              CAS019
     D MSGDATA         S                   LIKE(#MsgData)                                     CAS019

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(75)

      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
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

      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D                 DS                                                                     242377
     D  WPARM                  1     20                                                       242377
     D  WPARM1                 1      5                                                       242377
     D  WPARM2                 6     10                                                       242377
     D  WPARM3                11     15                                                       242377
     D  WPARM4                16     20                                                       242377
      *                                                                                       242377
      ** Flags to indicate whether transaction fields are valid
     D OKFee         E DS                  EXTNAME(LEEFEEMPD)

     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** External DS for Fee Details

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
                                                                                              CAS011
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)                                  CAS011
      ** Loan Type/Sub Type Details                                                           CAS011
                                                                                              CAS011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS011
      ** External DS for SAR details                                                          CAS011
                                                                                              CLE134
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  CLE134
      ** External DS for base rate details                                                    CLE134

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
      * Valid Fee layout -> LEFEED

     D TranInPrim    E DS                  EXTNAME(LEFEEMPD)
      * Incoming Transaction

     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input

     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input

     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input

      * (Current) Fee record in file Format
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED) PREFIX(@@)

      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)

      * Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)

     D ZMUSER          DS            17
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

      * DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
      *
      ** Fees/Profitability enhancement status data area
     D LERSTS        E DS                  EXTNAME(LERSTS)
     D  WHISST       E                     EXTFLD(FACHISD)

     D                 DS
     D  WF3TDS                 1      8
     D  WF3DD                  1      2
     D  WF3MM                  3      4
     D  WF3CC                  5      6
     D  WF3YY                  7      8
      *
     D                 DS
      ** Data structure to set work amounts
     D  WFAMT                  1     13  0
     D  DDMMYY                14     19  0
     D  WFAC3                 20     22  0
     D  WA13                  23     35  0

      ** Data structure to set Business Day Convention                                       CLE141A
     D CurLocDS        DS            60                                                      CLE141A
     D   CurLocDS1             1      3                                                      CLE141A
     D   CurLocDS2             4      6                                                      CLE141A
     D   CurLocDS3             7      9                                                      CLE141A
     D   CurLocDS4            10     12                                                      CLE141A
     D   CurLocDS5            13     15                                                      CLE141A
     D   CurLocDS6            16     18                                                      CLE141A
     D   CurLocDS7            19     21                                                      CLE141A
     D   CurLocDS8            22     24                                                      CLE141A
     D   CurLocDS9            25     27                                                      CLE141A
     D   CurLocDS10           28     30                                                      CLE141A
     D   CurLocDS11           31     33                                                      CLE141A
     D   CurLocDS12           34     36                                                      CLE141A
     D   CurLocDS13           37     39                                                      CLE141A
     D   CurLocDS14           40     42                                                      CLE141A
     D   CurLocDS15           43     45                                                      CLE141A
     D   CurLocDS16           46     48                                                      CLE141A
     D   CurLocDS17           49     51                                                      CLE141A
     D   CurLocDS18           52     54                                                      CLE141A
     D   CurLocDS19           55     57                                                      CLE141A
     D   CurLocDS20           58     60                                                      CLE141A
                                                                                             CLE141A
      *
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D IdxNew          S              3P 0                                                    CAP084

      ** Index for arrays of warning message ids etc
     D WId             S              3P 0
     D WIdNew          S              3P 0                                                    CAP084

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
     D AIdx            S              3P 0                                                  BUG10955
                                                                                              CAS011
      ** Work variables                                                                       CAS011
     D WADJY           S              1A                                                      CAS011
     D PLTYP           S              2A                                                      CAS011
     D PSUTP           S              2A                                                      CAS011
     D PCLAS           S              4A                                                      CLE042
     D PSARD           S              6A                                                      CAS011
     D CAS009          S              1A                                                      CAS011
     D TEST2           S              3A                                                      CAS011
     D WRKRP           S              4P 0                                                    CAS011
     D ZFREQ           S              1A                                                      CAS011
     D ZMDAY           S              2P 0                                                    CAS011
                                                                                              CAS019
      ** Amortisation Start & Date Date                                                       CAS019
     D WAStrDat        S              5P 0 INZ(*ZEROS)                                        CAS019
     D WAEndDat        S              5P 0 INZ(*ZEROS)                                        CAS019

      **  Syndications Manager Switchable Feature                                             CLE106
     D CLE106          S              1                                                       CLE106
     D PRtcd           S              7                                                       CLE106
     D POptn           S              7                                                       CLE106
     D CLE031          S              1                                                       CLE031
                                                                                              CAS019
      **  EIR Recalculation Switchable Feature                                                CAS019
     D CAS016          S              1    INZ('N')                                           CAS019
                                                                                              CLE106
      ** Work variable for CLE054 amendments                                                  CLE054
     D CLE054          S              1A                                                      CLE054
                                                                                              CLE071
      ** Value Dating of Rate changes to Fees switchable feature                              CLE071
     D CLE071          S              1                                                       CLE071
                                                                                              CLE054
     D PDAYNS          S              5P 0                                                    CLE139
     D PDAYNE          S              5P 0                                                    CLE139
     D PErrFlag        S              1A                                                      CLE139
                                                                                              CLE139
      ** Work variable for CLE134 amendments                                                  CLE134
                                                                                              CLE134
     D CLE134          S              1                                                       CLE134
     D DSField         S             10    INZ                                                CLE134
     D DSFESts         S             10    INZ                                                CLE134
     D DSPDSts         S             10    INZ                                                CLE134
     D @KEY1           S              3                                                       CLE134
     D @KEY2           S              2                                                       CLE134
                                                                                              CLE134
      ** Key fields for CLE134 amendments                                                     CLE134
                                                                                              CLE134
     D Kpd_LNRF        S                   INZ LIKE(pd_LNRF)                                  CLE134
     D Kpd_RECI        S                   INZ LIKE(pd_RECI)                                  CLE134
     D Kpd_YPORG       S                   INZ LIKE(pd_YPORG)                                 CLE134
     D Kpd_YVDAT       S                   INZ LIKE(pd_YVDAT)                                 CLE134
     D Kpd_YPLON       S                   INZ LIKE(pd_YPLON)                                 CLE134
     D Kpd_FECNUM      S                   INZ LIKE(pd_YECNUM)                                CLE134
     D Kpd_FEFACL      S                   INZ LIKE(pd_YEFACL)                                CLE134
     D Kpd_FELOAN      S                   INZ LIKE(pd_YPLON)                                 CLE134
     D Kpd_FEFSEQ      S                   INZ LIKE(pd_YESEQ)                                 CLE134
                                                                                              CLE134
     D DSBCN           S              4  0 INZ DIM(9) ASCEND                                  CLE134
     D DSBCD           S             25    INZ DIM(9)                                         CLE134
                                                                                              CLE134
     D DSBCAT          S              1S 0 INZ                                                CLE134
     D DSBIDT          S              5S 0 INZ                                                CLE134
     D DSBIDTFm        S              5S 0 INZ                                                CLE134
     D DSBIDTTo        S              5S 0 INZ                                                CLE134
                                                                                              CLE134
     D DSRCN           S              4  0 INZ DIM(9) ASCEND                                  CLE134
     D DSRCD           S             25    INZ DIM(9)                                         CLE134
                                                                                              CLE134
     D DSRCAT          S              1S 0 INZ                                                CLE134
     D DSRIDT          S              5S 0 INZ                                                CLE134
     D DSRIDTFm        S              5S 0 INZ                                                CLE134
     D DSRIDTTo        S              5S 0 INZ                                                CLE134
                                                                                              CLE134
     D DSDYS           S              9S 0 INZ                                                CLE134
     D #A              S              9S 0 INZ                                                CLE134
                                                                                              CLE134
     D P@BCAT          S              1S 0 INZ                                                CLE134
     D P@BIDTFm        S              5S 0 INZ                                                CLE134
     D P@BIDTTo        S              5S 0 INZ                                                CLE134
                                                                                              CLE134
     D P@RCAT          S              1S 0 INZ                                                CLE134
     D P@RIDTFm        S              5S 0 INZ                                                CLE134
     D P@RIDTTo        S              5S 0 INZ                                                CLE134
                                                                                              CLE134
     D P@MXCH          S              3S 0                                                    CLE134
     D P@PDSts         S             10A                                                      CLE134
     D P@PDVlD         S              5S 0                                                    CLE134
                                                                                              CLE134
     D P@NBDP          S              1S 0                                                    262513
      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** Ê Hook for non-core D-specs (all types)  Ê
      ** Ê also any I-specs (if necessary)        Ê
      ** Ê =====================================  Ê
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
      *
      **  GET ZMUSER to access default branch.                                               BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
      ** Call access object to ensure that change on ICD will be                              237347
      ** picked up online.  Sometimes QZDASOINIT does not end even if user                    237347
      ** signed off resulting to incorrect (previous) ICD value used, since                   237347
      ** *INZSR will only be executed on module activation.                                   237347
      *                                                                                       237347
      ** Do this only when fee autosettlement indicator has been left blank                   237347
      ** by user and needs defaulting.                                                        237347
      *                                                                                       237347
     C     DDEADV        Ifeq      *Blanks                                                    237347
     C                   CALL      'AOCLNDR0'                                                 237347
     C                   PARM      '*DBERR '     @RTCD                                        237347
     C                   PARM      '*FIRST '     @OPTN                                        237347
     C*****SDCLND        PARM      SDCLND        DSFDY                                 237347 CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *                                                                                       237347
     C     BPAURV        IFEQ      'Y'                                                        237347
     C                   MOVE      *ON           *IN88                                        237347
     C                   MOVE      'Y'           W#IN88                                       237347
     C                   ELSE                                                                 237347
     C                   MOVE      *OFF          *IN88                                        237347
     C                   MOVE      'N'           W#IN88                                       237347
     C                   ENDIF                                                                237347
     C                   Endif                                                                237347
      *                                                                                       237347
     C                   EXSR      RESETERRS

     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     DDLNRF        ANDNE     *blanks                                                   CLE141A
     C                   Eval      Kpd_RECI = 'D'                                            CLE141A
     C                   Eval      Kpd_LNRF = DDLNRF                                         CLE141A
     C     KCLOANL4      CHAIN     CLOANL4                                                   CLE141A
     C                   IF        %FOUND(CLOANL4)                                           CLE141A
      ** Set the value for Business Day Convention Fields                                    CLE141A
     C                   EVAL      CurLocDS1 = PD_C1PI                                       CLE141A
     C                   EVAL      CurLocDS2 = PD_C2PI                                       CLE141A
     C                   EVAL      CurLocDS3 = PD_C3PI                                       CLE141A
     C                   EVAL      CurLocDS4 = PD_C4PI                                       CLE141A
     C                   EVAL      CurLocDS5 = PD_C5PI                                       CLE141A
     C                   EVAL      CurLocDS6 = PD_C6PI                                       CLE141A
     C                   EVAL      CurLocDS7 = PD_C7PI                                       CLE141A
     C                   EVAL      CurLocDS8 = PD_C8PI                                       CLE141A
     C                   EVAL      CurLocDS9 = PD_C9PI                                       CLE141A
     C                   EVAL      CurLocDS10 = PD_C0PI                                      CLE141A
     C                   EVAL      CurLocDS11 = PD_L1PI                                      CLE141A
     C                   EVAL      CurLocDS12 = PD_L2PI                                      CLE141A
     C                   EVAL      CurLocDS13 = PD_L3PI                                      CLE141A
     C                   EVAL      CurLocDS14 = PD_L4PI                                      CLE141A
     C                   EVAL      CurLocDS15 = PD_L5PI                                      CLE141A
     C                   EVAL      CurLocDS16 = PD_L6PI                                      CLE141A
     C                   EVAL      CurLocDS17 = PD_L7PI                                      CLE141A
     C                   EVAL      CurLocDS18 = PD_L8PI                                      CLE141A
     C                   EVAL      CurLocDS19 = PD_L9PI                                      CLE141A
     C                   EVAL      CurLocDS20 = PD_L0PI                                      CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF                                                               CLE141A
      ** Check whether user is a web browser user, if so overwrite
      *
     C                   CALL      'SFC000026'
     C                   PARM      *BLANKS       USER             10

     C                   IF        USER <> *BLANKS
     C                   EVAL      PSUSER = USER
     C                   ENDIF
      *                                                                                     AR994776
      ** Skip validation process if action is reject.                                       AR994776
      *                                                                                     AR994776
     C     DRejFlg       IFEQ      'Y'                                                      AR994776
     C                   EXSR      SRRSFD                                                   AR994776
     C                   RETURN                                                             AR994776
     C                   ENDIF                                                              AR994776

      ** Call Validation Modules in Sequence
      *
      ** Fee Type
      ** ========
      *
     C                   EXSR      VEtyp
      *
      *
      ** Fee Code
      ** ========
      *
     C                   EXSR      VEcod
      *
      ** Fee Currency
      ** ============
      *
     C                   EXSR      VEcur
      *
      ** Fee Amount and sign
      ** ===================
      *
     C                   EXSR      VEamt
      *
      *
      ** Validate Period Start Date
      ** ==========================
      *
     C                   EXSR      VEpsd
      *
      ** Period End date validation
      ** ==========================
      *
     C                   EXSR      VEped
      *
      ** Validate Payment on Indicator
      ** =============================
      *
     C                   EXSR      VEpon
      *
      ** Validate advice indicator
      ** =========================
      *
     C                   EXSR      VEadv
      *
      ** Validate Shared Fee
      ** ===================
      *
     C                   EXSR      VEshr
      *
      ** Validate Calculation Type
      ** =========================
      *
     C                   EXSR      VCalt
      *
      *
      ** Validate Profit Center
      ** ======================
      *
     C                   EXSR      VPrfc
      *
      ** Validate Amortise Seperately Indicator                                               CAS019
      ** ======================================                                               CAS019
      *                                                                                       CAS019
     C                   EXSR      VAmSI                                                      CAS019
      *                                                                                       CAS019
      *                                                                                       CAS019
      ** Validate Amortisation Start Date                                                     CAS019
      ** ================================                                                     CAS019
      *                                                                                       CAS019
     C                   EXSR      VAmSD                                                      CAS019
      *                                                                                       CAS019
      *                                                                                       CAS019
      ** Validate Amortisation End Date                                                       CAS019
      ** ==============================                                                       CAS019
      *                                                                                       CAS019
     C                   EXSR      VAmED                                                      CAS019
      *                                                                                       CLE139
      ** Validate Fee Capitalisation Indicator                                                CLE139
      ** =====================================                                                CLE139
      *                                                                                       CLE139
     C                   EXSR      VCAPI                                                      CLE139
      *                                                                                       CAS019
      ** Validate Past Due Call Loan Values                                                   CLE134
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
                                                                                              CLE134
     C                   IF        DDLNRF <> *BLANKS AND                                      CLE134
     C                             DDEADV = 'C'                                               CLE134
     C                   EXSR      PIBRT                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EXSR      RPDCL                                                      CLE134
                                                                                              CLE134
     C                   EXSR      ERDFT                                                      CLE134
                                                                                              CLE134
     C                   EXSR      VRIDt                                                      CLE134
     C                   EXSR      VRCat                                                      CLE134
                                                                                              CLE134
     C                   EXSR      EBDFT                                                      CLE134
     C                   EXSR      VBIDt                                                      CLE134
     C                   EXSR      VBCat                                                      CLE134
                                                                                              CLE134
     C                   EXSR      VFSFA                                                      CLE134
     C                   EXSR      VSFAM                                                      CLE134
     C                   EXSR      VSFPM                                                      CLE134
     C                   EXSR      VFPPA                                                      CLE134
     C                   EXSR      VPSIn                                                      CLE134
     C                   EXSR      VPSLM                                                      CLE134
     C                   EXSR      VFEMC                                                      CLE134
      *****************************************************************              AR314017 CLE164
     C**********         EXSR      VSSIs                                             AR314017 CLE164
      *****************************************************************              AR314017 CLE164
     C                   ENDIF                                                                CLE134

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
      ** VETYP   - Validate Fee Type
      *****************************************************************
     C     VETYP         BEGSR
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *BLANK        WPTFI             1
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0202'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      '1'           *IN52
      *
      ** For loan fee...
     C     DDLNRF        IFNE      *BLANKS
      *
     C     CL_PTYP       IFEQ      66
     C     CL_LPFI       ANDNE     'I'
     C     CL_PTYP       OREQ      67
     C     CL_LPFI       ANDNE     'I'
     C     CL_PTYP       OREQ      69
     C     CL_LPFI       ANDNE     'I'
     C     CL_PTYP       OREQ      72
     C     CL_LPFI       ANDNE     'I'
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0203'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C**********         MOVE      'P'           WPTFI                                        CLE106
     C**********         MOVE      CL_LPFI       WPTFI                               CLE106 AR375892
     C**********         MOVE      'P'           WPTFI                            AR375892 AR375891B
     C                   MOVE      CL_LPFI       WPTFI                                     AR375891B
     C                   ENDIF
      *
     C     CL_PTYP       IFEQ      64
     C     CL_LPFI       ANDEQ     'I'
     C     CL_PTYP       OREQ      65
     C     CL_LPFI       ANDEQ     'I'
     C     CL_PTYP       OREQ      68
     C     CL_LPFI       ANDEQ     'I'
     C     CL_PTYP       OREQ      71
     C     CL_LPFI       ANDEQ     'I'
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0204'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      '0'           *IN52
     C                   MOVE      CL_LPFI       WPTFI
     C                   ENDIF
                                                                                              CLE106
      ** If Syndications Manager is available, always pass the value from loan                CLE106
                                                                                              CLE106
     C                   IF        CLE106 = 'Y' And DDACTN = 'I'                              CLE106
     C                   MOVE      CL_LPFI       WPTFI                                        CLE106
     C                   ENDIF                                                                CLE106
      *
     C                   ENDIF
      *
      ** For facility fee...
     C     DDLNRF        IFEQ      *BLANKS
      *
     C     FA_PRTR       IFEQ      'P'
     C     FA_PRTR       OREQ      'S'                                                        CLE106
     C     FA_PRTR       OREQ      'R'                                                        CLE106
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0203'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      FA_PRTR       WPTFI
     C                   ENDIF

     C     FA_PRTR       IFEQ      'I'
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0204'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      '0'           *IN52
     C                   MOVE      FA_PRTR       WPTFI
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CLE134
      ** Must be a live origin loan that is past due.                                         CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT      = '90'                                         CLE134
                                                                                              CLE134
     C                   IF        DDFACT     <> *BLANKS                                      CLE134
     C                   EVAL      DDFACTOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDFACT'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045561'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDFCNO     <> *BLANKS                                      CLE134
     C                   EVAL      DDFCNOOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDFCNO'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045770'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDLNRF      = *BLANKS                                      CLE134
     C                   EVAL      DDLNRFOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDLNRF'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045562'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        CL_RECI    <> 'D'                                          CLE134
     C                   EVAL      DDLNRFOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDLNRF'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045563'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        %SUBST(CL_LTYP:1:1) = 'X'  OR                              CLE134
     C                             %SUBST(CL_LTYP:1:1) = 'Y'  OR                              CLE134
     C                             %SUBST(CL_LTYP:1:1) = 'Z'                                  CLE134
     C                   EVAL      DDLNRFOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDLNRF'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045690'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DSPDSts     = *BLANKS                                      CLE134
                                                                                              CLE134
      ** - Fee Must Not Already Exists                                                        CLE134
                                                                                              CLE134
     C                   EVAL      Kpd_YPORG   = DDLNRF                                       CLE134
     C     KLEPDUFL4     SETLL     LEPDUFL4                                                   CLE134
     C     KLEPDUFL4     READE(E)  LEPDUFL4                                                   CLE134
                                                                                              CLE134
     C                   DOW       NOT %EOF(LEPDUFL4)          AND                            CLE134
     C                             DSFESts     <> '*LIVE'                                     CLE134
                                                                                              CLE134
     C                   IF        pd_YRECI     = 'D'                                         CLE134
     C                   EVAL      Kpd_FECNUM   = pd_YECNUM                                   CLE134
     C                   EVAL      Kpd_FEFACL   = pd_YEFACL                                   CLE134
     C                   EVAL      Kpd_FELOAN   = pd_YPLON                                    CLE134
     C                   EVAL      Kpd_FEFSEQ   = pd_YESEQ                                    CLE134
     C     KLEFEEDL0     CHAIN(E)  LEFEEDL0                                                   CLE134
                                                                                              CLE134
     C                   IF        %FOUND(LEFEEDL0)            AND                            CLE134
     C                             pd_FECALT   = '90'                                         CLE134
     C                   EVAL      DSFESts     = '*LIVE'                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DSFESts    <> '*LIVE'                                      CLE134
     C     KLEPDUFL4     READE(E)  LEPDUFL4                                                   CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
     C                   IF        DSPDSts    <> '*LIVE'                                      CLE134
     C**********         EVAL      DDLNRFOK    = 'N'                                          CLE134
     C**********         EVAL      Idx        += 1                                            CLE134
     C**********         EVAL      FldNamXAr(Idx) = 'DDLNRF'                                  CLE134
     C**********         EVAL      MsgIDXAr(Idx)  = '5045560'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      Kpd_YPORG   = DDLNRF                                       CLE134
                                                                                              CLE134
     C     KLEPDUEL2     SETLL     LEPDUEL2                                                   CLE134
     C     KLEPDUEL2     READE(E)  LEPDUEL2                                                   CLE134
                                                                                              CLE134
     C                   DOW       NOT %EOF(LEPDUEL2)          AND                            CLE134
     C                             DSPDSts    <> '*LIVE'                                      CLE134
                                                                                              CLE134
     C                   IF        pd_YRECI    = 'D'                                          CLE134
     C                   EVAL      Kpd_RECI    = 'D'                                          CLE134
     C                   EVAL      Kpd_LNRF    = pd_YPLON                                     CLE134
     C     KCLOANL4      CHAIN(E)  CLOANL4                                                    CLE134
                                                                                              CLE134
     C                   IF        %FOUND(CLOANL4)             AND                            CLE134
     C                             pd_CPAM    <> 0                                            CLE134
     C                   EVAL      DSPDSts     = '*LIVE'                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DSPDSts    <> '*LIVE'                                      CLE134
     C     KLEPDUEL2     READE(E)  LEPDUEL2                                                   CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
     C                   IF        DSPDSts    <> '*LIVE'                                      CLE134
     C**********         EVAL      DDLNRFOK    = 'N'                                          CLE134
     C**********         EVAL      Idx        += 1                                            CLE134
     C**********         EVAL      FldNamXAr(Idx) = 'DDLNRF'                                  CLE134
     C**********         EVAL      MsgIDXAr(Idx)  = '5045560'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VECOD   - Validate Fee code
      *****************************************************************
     C     VECOD         BEGSR
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   EVAL      WADJY = *BLANK                                             CAS011
     C                   ENDIF                                                                CAS011

     C                   CALL      'AOFEER0'
     C                   PARM      '*BLANKS'     PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDECOD        FKEY              2
     C     SDFEE         PARM      SDFEE         DSFDY

     C     PRTCD         IFNE      *BLANKS
     C                   Move      'N'           DDECODOK
     C                   Add       1             Idx
     C                   Movel     'DDECOD'      FldNamXAr(Idx)
     C                   Movel     'LER0018'     MsgIDXAr(Idx)
     C                   ELSE
     C                   IF        CAS009 = 'Y'                                               CAS011
      ** For Loan Fees                                                                      BUG10933
     C                   IF        DDLNRF <> *BLANKS                                        BUG10933
     C                   CALL      'AOLOANR0'                                                 CAS011
     C                   PARM      '*BLANKS'     PRTCD                                        CAS011
     C                   PARM      '*KEY   '     POPTN                                        CAS011
     C                   PARM      CL_LTYP       PLTYP                                        CAS011
     C                   PARM      CL_SUTP       PSUTP                                        CAS011
     C                   PARM      CL_CLAS       PCLAS                                        CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        CAS011
     C                   IF        PRTCD <> *BLANKS OR (AUADJY = 'Y'                          CAS011
     C                             AND AYACAI <> 'Y')                                         CAS011
     C                   EVAL      DDECODOK = 'N'                                             CAS011
     C                   ADD       1             Idx                                          CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDECOD'                                  CAS011
     C                   EVAL      MsgIDXAr(Idx) = 'LEV1071'                                  CAS011
     C                   ELSE                                                                 CAS011
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT      = '90'          AND                            CLE134
     C                             %SUBST(CL_LTYP:1:1) <> 'X'  AND                            CLE134
     C                             %SUBST(CL_LTYP:1:1) <> 'Y'  AND                            CLE134
     C                             %SUBST(CL_LTYP:1:1) <> 'Z'                                 CLE134
     C                   EVAL      DDECODOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDECOD'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045558'                                 CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      WADJY = AUADJY                                             CAS011
     C                   EVAL      DDECOD = *BLANKS                                           CAS011
     C                   EVAL      DDECOD = AUFECD                                            CAS011
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CAS011
      ** For Facility fees                                                                  BUG10933
     C                   ELSE                                                               BUG10933
     C                   EVAL      DDECOD = *BLANKS                                         BUG10933
     C                   EVAL      DDECOD = AUFECD                                          BUG10933
      ***Adjustment*to*yield*fee*code*is*not*allowed                              BUG10933 AR1053740
     C**********         IF        AUADJY = 'Y'                                   BUG10933 AR1053740
     C**********         EVAL      DDECODOK = 'N'                                 BUG10933 AR1053740
     C**********         ADD       1             Idx                              BUG10933 AR1053740
     C**********         EVAL      FldNamXAr(Idx) = 'DDECOD'                      BUG10933 AR1053740
     C**********         EVAL      MsgIDXAr(Idx) = 'LEV1071'                      BUG10933 AR1053740
     C**********         ENDIF                                                    BUG10933 AR1053740
     C                   ENDIF                                                              BUG10933
     C                   ELSE                                                                 CAS011
     C                   MOVE      *BLANKS       DDECOD
     C                   MOVEL     AUFECD        DDECOD
     C                   ENDIF                                                                CAS011
     C                   ENDIF
                                                                                              262461
     C**********         IF        CLE134 = 'Y'  AND DDEADV = 'C'   AND             262461A AR549983
     C**********                   %SUBST(CL_LTYP:1:1) <> 'X'  AND                  262461A AR549983
     C**********                   %SUBST(CL_LTYP:1:1) <> 'Y'  AND                  262461A AR549983
     C**********                   %SUBST(CL_LTYP:1:1) <> 'Z'                       262461A AR549983
     C                   IF        CLE134 = 'Y'  AND DDEADV = 'C'                           AR549983
     C                   IF        AUCLTY = *blanks OR                                        262461
     C                             AUCLST = *blanks                                           262461
     C                   EVAL      DDEADVOK = 'N'                                             262461
     C                   ADD       1             Idx                                          262461
     C                   EVAL      FldNamXAr(Idx) = 'DDEADV'                                  262461
     C                   EVAL      MsgIDXAr(Idx) = '5045666'                                  262461
     C                   ENDIF                                                                262461
     C                   ENDIF                                                                262461
                                                                                              262461
      *                                                                                    AR826996B
      ** Base Rate Code + Currency Validation                                              AR826996B
      *                                                                                    AR826996B
     C     DDACTN        IFEQ      'I'                                                     AR826996B
     C     DDEADV        ANDEQ     'C'                                                     AR826996B
     C     AUCBSR        ANDNE     *ZERO                                                   AR826996B
      *                                                                                    AR826996B
     C     DDACTN        OREQ      'A'                                                     AR826996B
     C     DDEADV        ANDEQ     'C'                                                     AR826996B
     C     AUCBSR        ANDNE     *ZERO                                                   AR826996B
      *                                                                                    AR826996B
     C     KCYBR         KLIST                                                             AR826996B
     C                   KFLD                    DDECUR                                    AR826996B
     C                   KFLD                    @BSRT                                     AR826996B
      *                                                                                    AR826996B
     C                   MOVE      *BLANKS       @CCYBR            5                       AR826996B
     C                   MOVE      *BLANK        @BSRT             2                       AR826996B
     C                   MOVE      AUCBSR        @BSRT                                     AR826996B
      *                                                                                    AR826996B
     C     KCYBR         CHAIN     SDBSRTL0                           31                   AR826996B
     C     *IN31         IFEQ      *ON                                                     AR826996B
     C     DDECUR        CAT       @BSRT         @CCYBR                                    AR826996B
     C                   EVAL      DDEADVOK    = 'N'                                       AR826996B
     C                   EVAL      Idx        += 1                                         AR826996B
     C                   EVAL      FldNamXAr(Idx) = 'DDEADV'                               AR826996B
     C                   EVAL      MsgIDXAr(Idx) = 'LER5607'                               AR826996B
     C                   EVAL      MsgDtaXAr = @CCYBR                                      AR826996B
     C                   ENDIF                                                             AR826996B
     C                   ENDIF                                                             AR826996B
      *                                                                                    AR826996B

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VECUR   - Validate Currency
      *****************************************************************
     C     VECUR         BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDECUR        K101              3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRTCD         IFNE      *BLANKS
     C                   Move      'N'           DDECUROK
     C                   Add       1             Idx
     C                   Movel     'DDECUR'      FldNamXAr(Idx)
     C                   Movel     'LER0019'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      *BLANKS       DDECUR
     C                   MOVE      A6CYCD        DDECUR
     C                   MOVE      A6MDIN        ZMDI2             1                           ??
     C                   Z-ADD     A6SPRT        ZRATE2           13 8                         ??
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEAMT   - Validate Fee amount
      *****************************************************************
     C     VEAMT         BEGSR

      ***If*LOAN*reference*entered*then*amount*is*mandatory************                       CAP084
      **********                                                                              CAP084
     C*****DDLNRF        IFNE      *BLANKS                                                    CAP084
     C*****DDEAMT        ANDEQ     *BLANKS                                                    CAP084
     C**********         Move      'N'           DDEAMTOK                                     CAP084
     C**********         Add       1             Idx                                          CAP084
     C**********         Movel     'DDEAMT'      FldNamXAr(Idx)                               CAP084
     C**********         Movel     'LER0020'     MsgIDXAr(Idx)                                CAP084
     C**********         ENDIF                                                                CAP084
      *
      ** Align
      *
     C     DDEAMT        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDEAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDEAMTOK
     C                   Add       1             Idx
     C                   Movel     'DDEAMT'      FldNamXAr(Idx)
     C                   Movel     'LER0021'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WFAMT
     C                   ENDIF
      *
      ** If facility amount blank
      *
     C                   ELSE
     C                   Z-ADD     0             WFAMT
     C                   ENDIF
      *
      ** If Loan fee, amount must be greater than zero
      ** If Loan reference entered then amount is mandatory                                   CAP084
      *
     C     DDLNRF        IFNE      *BLANKS
     C     WFAMT         ANDEQ     0
     C     CLE073        ANDNE     'Y'                                                        CLE073
     C     DDLNRF        ORNE      *BLANKS                                                    CAP084
     C     DDEAMT        ANDEQ     *BLANKS                                                    CAP084
     C     CLE073        ANDNE     'Y'                                                        CLE073
                                                                                              CLE073
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     WFAMT         ANDEQ     0                                                          CLE134
                                                                                              CLE134
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     WFAMT         ANDEQ     0                                                          CLE073
                                                                                              CLE134
     C     CLE073        OREQ      'Y'                                                      MD036962
     C     DDLNRF        ANDNE     *BLANKS                                                  MD039613
     C     DDCALT        ANDNE     '97'                                                     MD036962
     C     DDCALT        ANDNE     '98'                                                     MD036962
     C     WFAMT         ANDEQ     0                                                        MD036962
                                                                                            MD036962
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     DDEAMT        ANDEQ     *BLANKS                                                    CLE134
                                                                                              CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     DDEAMT        ANDEQ     *BLANKS                                                    CLE073
                                                                                            MD036962
     C     CLE073        OREQ      'Y'                                                      MD036962
     C     DDLNRF        ANDNE     *BLANKS                                                  MD039613
     C     DDCALT        ANDNE     '97'                                                     MD036962
     C     DDCALT        ANDNE     '98'                                                     MD036962
     C     DDEAMT        ANDEQ     *BLANKS                                                  MD036962
     C                   Move      'N'           DDEAMTOK
     C                   Add       1             Idx
     C                   Movel     'DDEAMT'      FldNamXAr(Idx)
     C                   Movel     'LER0020'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** If this is a non-calculated facility based fee the amount
      ** must be entered.
      *
     C     WFAMT         IFEQ      0
     C     DDFACT        ANDNE     *BLANKS
     C     DDCALT        ANDEQ     *BLANKS
     C                   Move      'N'           DDEAMTOK
     C                   Add       1             Idx
     C                   Movel     'DDEAMT'      FldNamXAr(Idx)
     C                   Movel     'LER0021'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Calculated fee cannot have negative accruals
      *
     C     DDCALT        IFEQ      *BLANKS
     C     WFAMT         ANDNE     0
     C     DDESGN        IFEQ      '-'
     C                   Z-SUB     WFAMT         WFAMT
     C                   ENDIF

     C     DDESGN        IFEQ      '-'
     C     DDESGN        OREQ      ' '
     C     DDESGN        OREQ      '+'
     C                   ELSE
     C                   Move      'N'           DDESGNOK
     C                   Add       1             Idx
     C                   Movel     'DDESGN'      FldNamXAr(Idx)
     C                   Movel     'LER0077'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDACTN        IFEQ      'I'                                                        257478
     C     DDESGN        IFNE      ' '
     C                   Move      'N'           DDESGNOK
     C                   Add       1             Idx
     C                   Movel     'DDESGN'      FldNamXAr(Idx)
     C                   Movel     'LER0233'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                                257478
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEpsd   - Validate Fee Period Start
      *****************************************************************
     C     VEpsd         BEGSR
      *                                                                                      241724
      ** Reset work field WPSTD (Fee Start Date)                                             241724
     C                   Eval      WPSTD = 0                                                 241724
      *
      ** Start date is mandatory and must be numeric
     C     DDEPSD        IFEQ      *BLANKS
     C                   Move      'N'           DDEPSDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPSD'      FldNamXAr(Idx)
     C                   Movel     'LER0022'     MsgIDXAr(Idx)
     C**********         ENDIF                                                                CAP084
     C                   ELSE                                                                 CAP084
      *
      ** Convert to Midas date format
     C                   MOVE      DDEPSD        DATEA
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
     C                   Move      'N'           DDEPSDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPSD'      FldNamXAr(Idx)
     C                   Movel     'LER0022'     MsgIDXAr(Idx)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WPSTD             5 0
     C                   ENDIF
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
      *
      ** If loan based fee
     C     DDLNRF        IFNE      *BLANKS
      *
      ** Warning if date is before start date or after maturity
      ** date of loan
     C     WPSTD         IFLT      CL_VDAT
     C     CLE073        ANDNE     'Y'                                                        CLE073
     C     WPSTD         ORGT      CL_MDAT
     C     CL_MDAT       ANDNE     0
     C     WPSTD         ORLT      CL_VDAT                                                    CLE073
     C     CLE073        ANDEQ     'Y'                                                        CLE073
     C     DDCALT        ANDNE     '97'                                                       CLE073
     C     DDCALT        ANDNE     '98'                                                       CLE073
     C     DDCALT        ANDNE     '99'                                                       CLE073
                                                                                              CLE134
     C     WPSTD         ORLT      CL_VDAT                                                    CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C     DDCALT        ANDNE     '90'                                                       CLE134
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'  AND @@FEFACL = 0 AND                         CAS011
     C                             WADJY = 'Y' AND DDCALT = *BLANKS                           CAS011
     C                             AND (DDEPON = 'S' OR DDEPON = ' ')                         CAS011
     C                   EVAL      DDEPSDOK = 'N'                                             CAS011
     C                   ADD       1             Idx                                          CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDEPSD'                                  CAS011
     C                   EVAL      MsgIDXAr(Idx) = 'LEV1072'                                  CAS011
     C                   ELSE                                                                 CAS011
     C                   IF        CLE073 = 'Y' AND WPSTD > CL_MDAT AND                     MD046370
     C                             CL_MDAT <> 0 AND (DDCALT = '97' OR                       MD046370
     C                             DDCALT = '98' OR DDCALT = '99')                          MD046370
     C                   MOVE      'N'           DDEPSDOK                                   MD046370
     C                   ADD       1             Idx                                        MD046370
     C                   MOVEL     'DDEPSD'      FldNamXAr(Idx)                             MD046370
     C                   MOVEL     'LER0112'     MsgIDXAr(Idx)                              MD046370
     C                   ELSE                                                               MD046370
     C                   Move      'W'           DDEPSDOK
     C                   Add       1             WId
     C                   Movel     'DDEPSD'      WFldNmXAr(WId)
     C                   Movel     'LER0023'     WMsgIdXAr(WId)
     C                   ENDIF                                                              MD046370
     C                   ENDIF                                                                CAS011
     C                   ENDIF
      *
     C     WPSTD         IFLT      CL_VDAT                                                    CLE073
     C     CLE073        ANDEQ     'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     WPSTD         ORLT      CL_VDAT                                                    CLE073
     C     CLE073        ANDEQ     'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C     WPSTD         ORLT      CL_VDAT                                                    CLE073
     C     CLE073        ANDEQ     'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     WPSTD         ORLT      CL_VDAT                                                    CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C                   MOVE      'N'           DDEPSDOK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDEPSD'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0012'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                      MD046370
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C     CL_CPAM       IFEQ      0                                                        MD046370
     C     DDCALT        ANDEQ     '97'                                                     MD046370
     C     CL_CPAM       OREQ      0                                                        MD046370
     C     DDCALT        ANDEQ     '98'                                                     MD046370
     C     CL_CPAM       OREQ      0                                                        MD046370
     C     DDCALT        ANDEQ     '99'                                                     MD046370
     C                   MOVE      '0'           *IN79                                      MD046370
     C                   Z-ADD     99999         WVDAT             5 0                      MD046370
     C                   Z-ADD     999           WLASN             3 0                      MD046370
     C                   Z-ADD     0             NWMAT             5 0                      MD046370
     C     KEYHST        SETGT     LEHISTLA                                                 MD046370
     C     KEYPHS        READPE    LEHISTLA                               79                MD046370
     C     *IN79         DOWEQ     '0'                                                      MD046370
     C     HP_CPAM       ANDEQ     0                                                        MD046370
     C                   Z-ADD     HP_VDAT       NWMAT                                      MD046370
     C     KEYPHS        READPE    LEHISTLA                               79                MD046370
     C                   ENDDO                                                              MD046370
      *                                                                                     MD046370
     C     WPSTD         IFGT      NWMAT                                                    MD046370
     C                   MOVE      'N'           DDEPSDOK                                   MD046370
     C                   ADD       1             Idx                                        MD046370
     C                   MOVEL     'DDEPSD'      FldNamXAr(Idx)                             MD046370
     C                   MOVEL     '5049054'     MsgIDXAr(Idx)                              MD046370
     C                   ENDIF                                                              MD046370
      *                                                                                     MD046370
     C                   ENDIF                                                              MD046370
     C                   ENDIF                                                              MD046370
      *                                                                                     MD046370
     C                   ELSE
      *
      ** If facility based fee warning if date is either before
      ** the availabilty date or after the expiry Date

      * Use WWDTEX if not zero (date set up in RTV module)
     C     WWDTEX        IFNE      0
     C                   Z-ADD     WWDTEX        FA_DTEX
     C                   ENDIF

     C     WPSTD         IFLT      FA_DTAP
     C     WPSTD         ORGT      FA_DTEX
      *
      ** If calculation type then error message rather than warning
      ** message
      *
     C     DDEAMT        IFEQ      *BLANK
     C                   Move      'N'           DDEPSDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPSD'      FldNamXAr(Idx)
     C                   Movel     'LER0112'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      'W'           DDEPSDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPSD'      WFldNmXAr(WId)
     C                   MOVEL     'LER0023'     WMsgIdXAr(WId)
     C                   MOVEL     'Y'           W#WARN            1                        ??
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Also if calc type then cannot be prior to start of History
     C     DDCALT        IFNE      *BLANKS
     C     WHISST        ANDGT     WPSTD
     C                   Move      'N'           DDEPSDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPSD'      FldNamXAr(Idx)
     C                   Movel     'LER0113'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Perform extra validation if Authorise action
     C     DDACTN        IFEQ      'X'
      *
     C     CEU004        IFEQ      'Y'
     C     WPTFI         IFEQ      *BLANKS
     C                   MOVE      @@FESCCY      WSCCY             3
     C                   ENDIF
     C     WPTFI         IFEQ      'P'
     C     WPTFI         OREQ      'S'                                                        CLE106
     C     WPTFI         OREQ      'R'                                                        CLE106
     C     WPTFI         OREQ      'A'                                                        CLE106
     C                   MOVE      @@FESCCY      WSCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** If settlement is start date and method is either 01 07 or 08,
      ** then check date for a holiday in both local and fee ccy.
      *
     C     DDEPSDOK      IFEQ      'Y'
     C     DDEPON        IFEQ      'S'
     C     DDEPON        OREQ      ' '
     C                   Z-ADD     WPSTD         ZDAYNO

     C     @@FESTTL      IFEQ      01
     C     @@FESTTL      OREQ      07
     C     @@FESTTL      OREQ      08

     C*****CLE141        IFEQ      'N'                                                CLE141 CLE141A
     C*****DDLNRF        OREQ      *blanks                                            CLE141 CLE141A
      *
      ** Fee Ccy check
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C                   MOVE      DDECUR        ZCCY              3
     C                   ENDIF

     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd        1
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPSDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPSD'      WFldNmXAr(WId)
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVEL     'LER0225'     WMsgIdXAr(WId)
     C                   ELSE
     C                   MOVEL     'LER0024'     WMsgIdXAr(WId)
     C                   ENDIF
     C                   ENDIF
      *
     C**********         ENDIF                                                        CLE141 CLE141A

     C                   ELSE
      *
      ** Local Ccy check
     C                   MOVE      BJLCCY        ZCCY
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPSDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPSD'      WFldNmXAr(WId)
     C                   MOVEL     'LER0032'     WMsgIdXAr(WId)
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     DDLNRF        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDEPSDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDEPSD'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048565'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEped   - Validate Fee Period End
      *****************************************************************
     C     VEped         BEGSR
      *                                                                                      241724
      ** Reset work field WPEND (Fee End Date)                                               241724
     C                   Eval      WPEND = 0                                                 241724
      *
      ** Period End Date if entered must be a valid date
      ** and greater than period start date
      *
     C     DDEPED        IFNE      *BLANKS
      *
      ** Convert to Midas date format
     C                   MOVE      DDEPED        DATEA
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
     C                   Move      'N'           DDEPEDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPED'      FldNamXAr(Idx)
     C                   Movel     'LER0193'     MsgIDXAr(Idx)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WPEND             5 0
     C                   ENDIF
      *
      ** If end date is less than start date then an error
     C     WPEND         IFLE      WPSTD
     C                   Move      'N'           DDEPEDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPED'      FldNamXAr(Idx)
     C                   Movel     'LER0025'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDEPEDOK      IFEQ      'Y'

     C     DDLNRF        IFNE      *BLANKS
      *
      ** Warning if date is before start date or after maturity
      ** date of loan.
      *
     C     WPEND         IFLT      CL_VDAT
     C     WPEND         ORGT      CL_MDAT
     C     CL_MDAT       ANDNE     0
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'  AND @@FEFACL = 0 AND                         CAS011
     C                             WADJY = 'Y' AND DDCALT = *BLANKS                           CAS011
     C                             AND (DDEPON = 'E' OR DDEPON = 'N')                         CAS011
     C                   EVAL      DDEPEDOK = 'N'                                             CAS011
     C                   ADD       1             Idx                                          CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDEPED'                                  CAS011
     C                   EVAL      MsgIDXAr(Idx) = 'LEV1073'                                  CAS011
     C                   ELSE                                                                 CAS011
     C                   IF        CLE073 = 'Y' AND AutoEndFee = 'Y' AND                    MD046370
     C                             WPEND > CL_MDAT AND CL_MDAT <> 0 AND                     MD046370
     C                             (DDCALT = '97' OR DDCALT = '98' OR                       MD046370
     C                             DDCALT = '99')                                           MD046370
     C                   MOVE      'N'           DDEPEDOK                                   MD046370
     C                   ADD       1             Idx                                        MD046370
     C                   MOVEL     'DDEPED'      FldNamXAr(Idx)                             MD046370
     C                   MOVEL     'LER0114'     MsgIDXAr(Idx)                              MD046370
     C                   ELSE                                                               MD046370
     C                   MOVE      'W'           DDEPEDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)
     C                   MOVEL     'LER0030'     WMsgIdXAr(WId)
     C                   MOVEL     'Y'           W#WARN                                     ??
     C                   ENDIF                                                              MD046370
     C                   ENDIF                                                                CAS011
     C                   ENDIF
      *                                                                                       CLE073
      ** Warning if End date is before the Loan maturity date                                 CLE073
      *                                                                                       CLE073
     C     WPEND         IFLT      CL_MDAT                                                    CLE073
     C     CL_MDAT       ANDNE     0                                                          CLE073
     C*****CLE073        ANDEQ     'Y'                                                 CLE073 CLE134
     C*****DDCALT        IFEQ      '97'                                                CLE073 CLE134
     C*****DDCALT        OREQ      '98'                                                CLE073 CLE134
     C*****DDCALT        OREQ      '99'                                                CLE073 CLE134
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT      = '90'          OR                             CLE134
     C                             CLE073      = 'Y'           AND                            CLE134
     C                             (DDCALT     = '97'          OR                             CLE134
     C                              DDCALT     = '98'          OR                             CLE134
     C                              DDCALT     = '99')                                        CLE134
     C                   MOVE      'W'           DDEPEDOK                                     CLE073
     C                   ADD       1             WId                                          CLE073
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)                               CLE073
     C                   MOVEL     'XLE0010'     WMsgIdXAr(WId)                               CLE073
     C                   ENDIF                                                                CLE073
     C                   ENDIF                                                                CLE073
      *
     C                   ELSE
      *
      ** Warning if Facility *ne 0 and date is either befor
      ** the Availabilty Date or after the Expiry Date

      * Use WWDTEX if not zero (date set up in RTV module)
     C     WWDTEX        IFNE      0
     C                   Z-ADD     WWDTEX        FA_DTEX
     C                   ENDIF

     C     WPEND         IFLT      FA_DTAP
     C     WPEND         ORGT      FA_DTEX
      *
      ** If calculation type output error message rather than
      ** warning message
     C     DDEAMT        IFEQ      *BLANK
     C                   Move      'N'           DDEPEDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPED'      FldNamXAr(Idx)
     C                   Movel     'LER0114'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      'W'           DDEPEDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)
     C                   MOVEL     'LER0030'     WMsgIdXAr(WId)
     C                   MOVEL     'Y'           W#WARN                                     ??
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Perform extra validation if Authorise action
     C     DDACTN        IFEQ      'X'
      *
      ** If settlement is end date and method is either 01 07 or 08,
      ** then check date for a holiday in both local and fee ccy.
      *
     C     DDEPEDOK      IFEQ      'Y'
     C     DDEPON        IFEQ      'E'
     C                   Z-ADD     WPEND         ZDAYNO

     C     @@FESTTL      IFEQ      01
     C     @@FESTTL      OREQ      07
     C     @@FESTTL      OREQ      08
      *
     C*****CLE141        IFEQ      'N'                                                CLE141 CLE141A
     C*****DDLNRF        OREQ      *blanks                                            CLE141 CLE141A

     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVE      WSCCY         ZCCY
     C                   ELSE
     C                   MOVE      DDECUR        ZCCY
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPEDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)
     C     CEU004        IFEQ      'Y'
     C     WSCCY         ANDNE     *BLANKS
     C                   MOVEL     'LER0216'     WMsgIdXAr(WId)
     C                   ELSE
     C                   MOVEL     'LER0031'     WMsgIdXAr(WId)
     C                   ENDIF
     C                   ENDIF

     C**********         ENDIF                                                        CLE141 CLE141A
      *
      ** Fee Ccy check
      *
     C                   ELSE
      *
      ** Local Ccy check
      *
     C                   MOVE      BJLCCY        ZCCY              3
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'W'           DDEPEDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDEPED'      WFldNmXAr(WId)
     C                   MOVEL     'LER0033'     WMsgIdXAr(WId)
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     DDLNRF        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDEPEDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDEPED'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048566'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Additional validation to protect selected fields when                                CLE071
      ** maintaining Fee details                                                              CLE071
      *                                                                                       CLE071
     C     DDEPEDOK      IFNE      'N'                                                        CLE071
     C     DDEPED        ANDNE     *BLANKS                                                    CLE071
     C     CLE071        ANDEQ     'Y'                                                        CLE071
      *                                                                                       CLE071
     C                   MOVEL     FA_BRCA       FCBRCA                                       CLE071
     C                   MOVEL     DDCSSN        FCCNUM                                       CLE071
     C                   MOVE      *BLANKS       WCFACL            5                          CLE071
     C                   EVAL      WCFACL = %TRIM(DDFACT) + %TRIM(DDFCNO)                     CLE071
     C                   MOVEL     WCFACL        FCFACL                                       CLE071
     C                   MOVEL     DDLNRF        FCLOAN                                       CLE071
     C                   MOVEL     DDFSEQ        FCFSEQ                                       CLE071
      *                                                                                       CLE071
     C     FCADKY        SETGT     LEFERCL1                                                   CLE071
     C     FCADKY        READPE    LEFERCL1                               75                  CLE071
     C     *IN75         IFEQ      '0'                                                        CLE071
      *                                                                                       CLE071
     C     FCRCVD        IFGE      WPEND                                                      CLE071
     C     FCRECI        ANDEQ     'D'                                                      MD021377
     C                   MOVE      'N'           DDEPEDOK                                     CLE071
     C                   ADD       1             Idx                                          CLE071
     C                   MOVEL     'DDEPED'      FldNamXAr(Idx)                               CLE071
     C                   MOVEL     '5049178'     MsgIDXAr(Idx)                                CLE071
     C                   ENDIF                                                                CLE071
      *                                                                                       CLE071
     C                   ENDIF                                                                CLE071
      *                                                                                       CLE071
     C                   ENDIF                                                                CLE071
      *                                                                                       CLE071
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEpon   - Validate Fee Payment on indicator
      *****************************************************************
     C     VEpon         BEGSR
      *
      ** Error if Loan fee type 97-99 and Payment on is not Next Pay Date                     CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     DDEPON        IFNE      'N'                                                        CLE073
     C                   MOVE      'N'           DDEPONOK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDEPON'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0006'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
     C                   ELSE                                                                 CLE073
      *                                                                                       CLE073
     C     DDEPED        IFEQ      *BLANKS
     C     DDEPON        ANDNE     *BLANKS
     C     CAS009        ANDNE     'Y'                                                        CAS011
      *
      ** Allow Payment On = 'N' when CAS009 is *On. Cannot be S or E.                         CAS011
                                                                                              CAS011
     C     DDEPED        OREQ      *BLANKS                                                    CAS011
     C     DDEPON        ANDEQ     'S'                                                        CAS011
     C     CAS009        ANDEQ     'Y'                                                        CAS011
     C     DDEPED        OREQ      *BLANKS                                                    CAS011
     C     DDEPON        ANDEQ     'E'                                                        CAS011
     C     CAS009        ANDEQ     'Y'                                                        CAS011
                                                                                              CAS011
     C     DDCALT        IFEQ      *BLANKS
     C                   Move      'N'           DDEPONOK
     C                   Add       1             Idx
     C                   Movel     'DDEPON'      FldNamXAr(Idx)
     C                   Movel     'LER0027'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDEPED        IFNE      *BLANKS
     C     DDEPON        IFEQ      'S'
     C     DDEPON        OREQ      'E'
     C     DDEPON        OREQ      'N'
     C                   ELSE
     C                   Move      'N'           DDEPONOK
     C                   Add       1             Idx
     C                   Movel     'DDEPON'      FldNamXAr(Idx)
     C                   Movel     'LER0028'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDEPON        IFEQ      'N'
     C     DDEAMT        ANDNE     *BLANKS
                                                                                              CAS011
      ** Allow Payment On = 'N' when CAS009 is *On.                                           CAS011
                                                                                              CAS011
     C     CAS009        ANDNE     'Y'                                                        CAS011
     C     CLE031        ANDEQ     'N'                                                        CLE031
     C/COPY WNCPYSRC,LEH00502
     C                   Move      'N'           DDEPONOK
     C                   Add       1             Idx
     C                   Movel     'DDEPON'      FldNamXAr(Idx)
     C                   Movel     'LER0094'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDEPON        IFEQ      'S'
     C     DDEAMT        ANDEQ     *BLANKS
     C                   Move      'N'           DDEPONOK
     C                   Add       1             Idx
     C                   Movel     'DDEPON'      FldNamXAr(Idx)
     C                   Movel     'LER0094'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CLE073
     C/COPY WNCPYSRC,LEH01331
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VEadv   - Validate Adv/Confirmed indicator
      *****************************************************************
     C     VEadv         BEGSR
      *                                                                                       CLE054
      ** If CLE054 = ON, reflect the value 'Default Auto-settle                               CLE054
      ** Indicator' from 'Customer Lending Data Maintenance' on                               CLE054
      ** Fee Input on 'Advise/Confirmed Indicator' field, both                                CLE054
      ** on Insert or Amend Mode.                                                             CLE054
      *                                                                                       CLE054
     C                   IF        CLE054 = 'Y'                                               CLE054
     C                             AND DDEADV = *BLANKS                                       CLE054
     C                   EVAL      DDEADV = BPDASI                                            CLE054
     C                   ENDIF                                                                CLE054
      *
      **  Can only be Y, N, or blank.
     C     DDEADV        IFEQ      *BLANKS
     C     DDEADV        OREQ      'N'
     C     DDEADV        OREQ      'Y'
     C     DDEADV        OREQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
                                                                                              CLE134
     C                   ELSE
     C                   Move      'N'           DDEADVOK
     C                   Add       1             Idx
     C                   Movel     'DDEADV'      FldNamXAr(Idx)
     C                   Movel     'LER0029'     MsgIDXAr(Idx)
     C                   ENDIF
      *                                                                                       237347
                                                                                            AR402732
      ** Pre-check not allowed for bullet fees                                              AR402732
                                                                                            AR402732
     C     DDEADV        IFEQ      'C'                                                      AR402732
     C     WPEND         ANDEQ     0                                                        AR402732
     C     WPSTD         ANDNE     0                                                        AR402732
     C     DDCALT        ANDEQ     *BLANKS                                                  AR402732
                                                                                            AR402732
     C                   MOVE      'N'           DDEADVOK                                   AR402732
     C                   ADD       1             Idx                                        AR402732
     C                   MOVEL     'DDEADV'      FldNamXAr(Idx)                             AR402732
     C                   MOVEL     '5045682'     MsgIDXAr(Idx)                              AR402732
     C                   ENDIF                                                              AR402732
                                                                                            AR402732
      ** Pre-check not allowed if Fee End Date is in the past                               AR402732
                                                                                            AR402732
     C     DDEADV        IFEQ      'C'                                                      AR402732
     C     WPEND         ANDGT     0                                                        AR402732
     C     WPEND         ANDLT     BJRDNB                                                   AR402732
                                                                                            AR402732
     C                   MOVE      'N'           DDEADVOK                                   AR402732
     C                   ADD       1             Idx                                        AR402732
     C                   MOVEL     'DDEADV'      FldNamXAr(Idx)                             AR402732
     C                   MOVEL     '5045683'     MsgIDXAr(Idx)                              AR402732
     C                   ENDIF                                                              AR402732
                                                                                            AR402732
      ** Default autosettlement indicator if DDEADV is left blank                             237347
      ** by user during Insert or Amend                                                       237347
      *                                                                                       237347
     C     DDEADV        Ifeq      *Blanks                                                    237347
     C     DDACTN        Andeq     'I'                                                        237347
     C     DDEADV        Oreq      *Blanks                                                    237347
     C     DDACTN        Andeq     'A'                                                        237347
     C                   Eval      DDEADV = BPDASI                                            237347
     C                   Endif                                                                237347
      *
      **  Can't auto settle calculated fees if adjustment outstanding
     C     DDCALT        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDEADV        ANDEQ     'Y'
      *
      **  Can't autosettle if there is any adjustment amount on LEFEED
     C     @@FEAMTA      IFNE      0
     C                   Move      'N'           DDEADVOK
     C                   Add       1             Idx
     C                   Movel     'DDEADV'      FldNamXAr(Idx)
     C                   Movel     'LER0144'     MsgIDXAr(Idx)
     C                   ELSE
      *
      **  Can't autosettle if there is any adjustment on LEFEEAD
     C     FEADKY        SETLL     LEFEEADF
     C     FEADKY        READE     LEFEEADF                               74
      *
     C     FARECI        DOWEQ     '*'
     C     *IN74         ANDEQ     '0'
     C     FATYPE        ORNE      *BLANK
     C     *IN74         ANDEQ     '0'
     C     FEADKY        READE     LEFEEADF                               74
     C                   ENDDO
      *
     C     *IN74         IFEQ      '0'
     C                   Move      'N'           DDEADVOK
     C                   Add       1             Idx
     C                   Movel     'DDEADV'      FldNamXAr(Idx)
     C                   Movel     'LER0144'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
                                                                                              CLE134
      ** If PDCL and Calc Type 90, Adv/Cnf must be Y or C.                                    CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT      = '90'          AND                            CLE134
     C**********                   DDEADV     <> 'Y'           AND                   CLE134 AR314017
     C                             DDEADV     <> 'C'           AND                            CLE134
     C                             DDEADVOK    = 'Y'                                          CLE134
     C                   EVAL      DDEADVOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDEADV'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045574'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VEshr   - Validate Shared fee
      *****************************************************************
     C     VEshr         BEGSR
      *                                                                                       241581
      ** Default Shared Fee to 'N' if CLE006 is off                                           241581
     C                   If        CLE006 =  'N' and                                          241581
     C                             DDESHR = *Blank                                            241581
     C                   Eval      DDESHR = 'N'                                               241581
     C                   EndIf                                                                241581
      *
      ** Default Shared Fee to 'N' if entered against direct
      ** Facilities or Loan, default to 'Y' if entered against
      ** syndicated Facilities or Loan
      *
     C     CLE006        IFEQ      'Y'
     C     DDACTN        ANDEQ     'I'
     C     DDESHR        ANDEQ     *BLANK
     C     WSYND         IFEQ      'N'
     C                   MOVE      'N'           DDESHR
     C                   ELSE
     C                   MOVE      'Y'           DDESHR
     C                   ENDIF
     C                   ENDIF
      *
     C     CLE006        IFEQ      'Y'
     C     DDESHR        IFNE      'Y'
     C     DDESHR        ANDNE     'N'
     C                   Move      'N'           DDESHROK
     C                   Add       1             Idx
     C                   Movel     'DDESHR'      FldNamXAr(Idx)
     C                   Movel     'LER0183'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Shared Fee must be 'N' for non-syndicated loan or facility
      *
     C     CLE006        IFEQ      'Y'
     C     DDESHR        IFNE      'N'
     C     WSYND         ANDEQ     'N'
     C     DDESHROK      ANDEQ     'Y'
     C                   Move      'N'           DDESHROK
     C                   Add       1             Idx
     C                   Movel     'DDESHR'      FldNamXAr(Idx)
     C                   Movel     'LER0184'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VCalt  - Validate Calculation type
      *****************************************************************

     C     Vcalt         BEGSR

     C                   MOVE      'N'           WFixfee           1                          CLE134
     C     CLE073        IFEQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '99'                                                       CLE134
                                                                                              CLE134
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C                   MOVE      'Y'           WFixfee                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C*****DDCALT        IFNE      *BLANKS                                                    CLE134
     C*****DDEAMT        ANDNE     *BLANKS                                                    CLE134
     C*****CLE073        ANDEQ     'N'                                                 CLE073 CLE134
                                                                                              CLE073
     C*****DDCALT        ORNE      *BLANKS                                             CLE073 CLE134
     C*****DDEAMT        ANDNE     *BLANKS                                             CLE073 CLE134
     C*****CLE073        ANDEQ     'Y'                                                 CLE073 CLE134
     C*****DDCALT        ANDNE     '99'                                                CLE073 CLE134
     C                   IF        DDCALT     <> *BLANKS       AND                            CLE134
     C                             DDEAMT     <> *BLANKS       AND                            CLE134
     C                             CLE073      = 'N'           AND                            CLE134
     C                             CLE134      = 'N'           OR                             CLE134
                                                                                              CLE134
     C                             DDCALT     <> *BLANKS       AND                            CLE134
     C                             DDEAMT     <> *BLANKS       AND                            CLE134
     C                             WFixFee    = 'N'                                           CLE134
      *                                                                                       CLE073
      ** Error if Loan fee type 97-98 and Fee amount not blank                                CLE073
      *                                                                                       CLE073
     C     DDCALT        IFEQ      '97'                                                       CLE073
     C     DDCALT        OREQ      '98'                                                       CLE073
     C*********          MOVE      'N'           DDCALTOK                              CLE073 256199
     C                   MOVE      'N'           DDEAMTOK                                     256199
     C                   ADD       1             Idx                                          CLE073
     C*********          MOVEL     'DDCALT'      FldNamXAr(Idx)                        CLE073 256199
     C                   MOVEL     'DDEAMT'      FldNamXAr(Idx)                               256199
     C                   MOVEL     'XLE0008'     MsgIDXAr(Idx)                                CLE073
     C                   ELSE                                                                 CLE073
     C                   Move      'N'           DDCALTOK
     C                   Add       1             Idx
     C                   Movel     'DDCALT'      FldNamXAr(Idx)
     C                   Movel     'LER0045'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE073
     C                   ENDIF
      *
      ** Error if Loan fee type 99 (fixed) and fee amount blank                               CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     DDEAMT        ANDEQ     *BLANKS                                                    CLE073
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     DDEAMT        ANDEQ     *BLANKS                                                    CLE134
     C**********         MOVE      'N'           DDCALTOK                              CLE073 256199
     C                   MOVE      'N'           DDEAMTOK                                     256199
     C                   ADD       1             Idx                                          CLE073
     C********           MOVEL     'DDCALT'      FldNamXAr(Idx)                        CLE073 256199
     C                   MOVEL     'DDEAMT'      FldNamXAr(Idx)                               256199
     C                   MOVEL     'XLE0007'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
      *
     C                   EXSR      SRCATP

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCATP  -  Validate Calculation Type                          *
      *****************************************************************
     C     SRCATP        BEGSR
      *
      ** If calculation type entered
      *
     C     DDCALT        IFNE      *BLANKS
      *
      ** Protect if fee already started
      *
     C     *IN77         IFEQ      '0'                                                    ???
      *
      ** must be a valid type
     C                   Z-ADD     1             X                 2 0
     C     DDCALT        LOOKUP    WCTP(X)                                78
     C**********         IF        *IN78 = *Off AND                                  CLE073 AR322844
     C**********                   CLE073 = 'Y' AND                                  CLE073 AR322844
     C                   IF        CLE073 = 'Y' And                                         AR322844
     C                             DDLNRF <> *Blanks                                          CLE073
     C                   Z-ADD     1             X                                          AR322844
     C     DDCALT        LOOKUP    ECTP(X)                                78                  CLE073
     C                   IF        DDCALT = '90' And                                        AR322844
     C                             CLE134 = 'N'                                             AR322844
     C                   SETOFF                                       78                    AR322844
     C                   ENDIF                                                              AR322844
     C                   ENDIF                                                                CLE073
     C     *IN78         IFNE      '1'
     C                   Move      'N'           DDCALTOK
     C                   Add       1             Idx
     C                   Movel     'DDCALT'      FldNamXAr(Idx)
     C                   Movel     'LER0046'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDEPED        IFEQ      *BLANKS
     C                   Move      'N'           DDEPEDOK
     C                   Add       1             Idx
     C                   Movel     'DDEPED'      FldNamXAr(Idx)
     C                   Movel     'LER0026'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** First rate is mandatory
      *                                                                                       CLE073
      ** If CLE073 is ON, first rate mandatory for calculation types '97' and '98'.           CLE073
      ** If CLE073 is ON, first rate must be blank for calculation type '99'(fixed)           CLE073
      *
     C     DDRTE1        IFEQ      *BLANKS
     C     CLE073        ANDEQ     'N'                                                        CLE073
      *                                                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDRTE1        ANDEQ     *BLANKS                                                    CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
      *                                                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDRTE1        ANDEQ     *BLANKS                                                    CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
      *                                                                                       CLE073
     C                   Move      'N'           DDRTE1OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE1'      FldNamXAr(Idx)
     C                   Movel     'LER0048'     MsgIDXAr(Idx)
     C                   ENDIF
                                                                                              CLE073
     C     DDRTE1        IFNE      *BLANKS                                                    CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     CLE073        ANDEQ     'Y'                                                        CLE073
                                                                                              CLE134
     C     DDRTE1        ORNE      *BLANKS                                                    CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C                   MOVE      'N'           DDRTE1OK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDRTE1'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0004'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
      *
      ** Check the rates input
      *
     C                   EXSR      RATE
      *
      ** Check the amounts input
      *
     C                   EXSR      AMNT
      *
      ** Check the correct calculation basis
      *
     C     DDCALC        IFNE      *BLANKS
     C*****DDCALT        IFEQ      '99'                                            AR738851 MD020592
     C*****CLE073        ANDEQ     'Y'                                             AR738851 MD020592
     C**********         MOVE      'N'           DDCALCOK                          AR738851 MD020592
     C**********         ADD       1             Idx                               AR738851 MD020592
     C**********         MOVEL     'DDCALC'      FldNamXAr(Idx)                    AR738851 MD020592
     C**********         MOVEL     'XLE0013'     MsgIDXAr(Idx)                     AR738851 MD020592
     C**********         ELSE                                                      AR738851 MD020592
     C                   MOVE      DDCALC        WCALC
      *
      ** Protect if fee already started                                                   ?????
      *
     C     *IN77         IFEQ      '0'
     C                   MOVE      '0'           TEST1             2
     C                   MOVEL     DDCALC        TEST1
     C                   TESTN                   TEST1                78
      *
     C     *IN78         IFEQ      '1'
     C     WCALC         ANDGE     1
     C     WCALC         ANDLE     6
     C                   ELSE
     C                   Move      'N'           DDCALCOK
     C                   Add       1             Idx
     C                   Movel     'DDCALC'      FldNamXAr(Idx)
     C                   Movel     'LER0056'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDEPON        IFEQ      'E'
     C     DDEPON        OREQ      'N'
     C                   ELSE
     C                   Move      'N'           DDCALCOK
     C                   Add       1             Idx
     C                   Movel     'DDCALC'      FldNamXAr(Idx)
     C                   Movel     'LER0057'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C**********         ENDIF                                                     AR738851 MD020592
      *
     C                   ELSE
      *
      ** Protect if fee already started                                                 ???????
      ** If CLE073 is ON, calc.basis mandatory for calculation types '97' and '98'.           CLE073
      *
     C     *IN77         IFEQ      '0'
     C*****DDCALT        ANDNE     '99'                                            AR738851 MD020592
     C     DDCALT        ANDNE     '99'                                                     MD020632
     C     DDCALT        IFEQ      '04'
     C     DDCALT        OREQ      '05'
     C     DDCALT        OREQ      '06'
     C     DDCALT        OREQ      '14'
     C     DDCALT        OREQ      '15'
     C     DDCALT        OREQ      '16'
     C     DDCALT        OREQ      '22'
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C                   Move      'N'           DDCALCOK
     C                   Add       1             Idx
     C                   Movel     'DDCALC'      FldNamXAr(Idx)
     C                   Movel     'LER0098'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      CL_FCCY       K101              3                         BUG3729
     C                   PARM      DDECUR        K101              3                         BUG3729
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS                                                   BUG3729
     C                   MOVE      A6DICB        WCALC
     C                   MOVE      A6DICB        DDCALC                                      BUG3729
     C                   ENDIF                                                               BUG3729
      *
     C                   ENDIF
                                                                                             BUG3729
     C     DDCALC        IFEQ      *BLANKS                                                   BUG3729
     C                   IF        CLE134     <> 'Y'           OR                             CLE134
     C                             CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT     <> '90'                                         CLE134
     C                   Move      'N'           DDCALCOK                                    BUG3729
     C                   Add       1             Idx                                         BUG3729
     C                   Movel     'DDCALC'      FldNamXAr(Idx)                              BUG3729
     C                   Movel     'LER0056'     MsgIDXAr(Idx)                               BUG3729
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                               BUG3729
                                                                                             BUG3729
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check the exchange rate
      *
     C     DDEXRT        IFNE      *BLANKS
      *
      ** Is rate a valid entry
      *
     C     *IN77         IFEQ      '0'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDEXRT        ZFIELD
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDEXRTOK
     C                   Add       1             Idx
     C                   Movel     'DDEXRT'      FldNamXAr(Idx)
     C                   Movel     'LER0058'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C     WA13          DIV       100000000     WERAT
     C                   ENDIF
      *
      ** Is fee ccy diff. to fac. ccy
      *
     C     DDECUR        IFEQ      CL_FCCY
     C                   Move      'N'           DDEXRTOK
     C                   Add       1             Idx
     C                   Movel     'DDEXRT'      FldNamXAr(Idx)
     C                   Movel     'LER0059'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If exchange rate field (alpha) on screen is blank, put zero
      ** in numeric version of field in program.
      *
     C                   ELSE
     C                   Z-ADD     0             WERAT
      *
      ** Default cross rate and multi/div indicator
      *
     C     DDECUROK      IFEQ      'Y'
     C     *IN77         ANDEQ     '0'
     C     DDECUR        ANDNE     FA_FCCY
     C     FA_FCCY       ANDNE     *BLANKS                                                  MD028931
     C     DDFACT        ANDNE     *BLANKS                                                  MD053942
     C     DDFCNO        ANDNE     *BLANKS                                                  MD053942
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FA_FCCY       PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      A6MDIN        ZMDI1             1
     C                   Z-ADD     A6SPRT        ZRATE1           13 8
     C                   EXSR      ZXRATE
     C                   Z-ADD     ZRATEX        WERAT
     C                   ENDIF
      *                                                                                     MD053942
     C     DDECUROK      IFEQ      'Y'                                                      MD053942
     C     *IN77         ANDEQ     '0'                                                      MD053942
     C     DDECUR        ANDNE     CL_CCY                                                   MD053942
     C     CL_CCY        ANDNE     *BLANKS                                                  MD053942
     C     DDLNRF        ANDNE     *BLANKS                                                  MD053942
     C                   CALL      'AOCURRR0'                                               MD053942
     C                   PARM      *BLANK        PRTCD                                      MD053942
     C                   PARM      '*KEY   '     POPTN                                      MD053942
     C                   PARM      CL_CCY        PCURR                                      MD053942
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD053942
      *                                                                                     MD053942
     C                   MOVE      A6MDIN        ZMDI1                                      MD053942
     C                   Z-ADD     A6SPRT        ZRATE1                                     MD053942
     C                   EXSR      ZXRATE                                                   MD053942
     C                   Z-ADD     ZRATEX        WERAT                                      MD053942
     C                   ENDIF                                                              MD053942
      *
     C                   ENDIF
      *
      ** Mult/Div ind
      *
     C     DDEXRT        IFEQ      *BLANKS
     C     DDMDIN        ANDNE     *BLANKS
     C                   Move      'N'           DDMDINOK
     C                   Add       1             Idx
     C                   Movel     'DDMDIN'      FldNamXAr(Idx)
     C                   Movel     'LER0111'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDEXRT        IFNE      *BLANKS
     C     DDMDIN        ANDEQ     *BLANKS
     C                   Move      'N'           DDMDINOK
     C                   Add       1             Idx
     C                   Movel     'DDMDIN'      FldNamXAr(Idx)
     C                   Movel     'LER0235'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDMDIN        IFNE      *BLANKS
     C     DDMDIN        IFEQ      'D'
     C     DDMDIN        OREQ      'M'
     C                   ELSE
     C                   Move      'N'           DDMDINOK
     C                   Add       1             Idx
     C                   Movel     'DDMDIN'      FldNamXAr(Idx)
     C                   Movel     'LER0111'     MsgIDXAr(Idx)
     C                   END
     C                   END
     C                   MOVE      DDMDIN        WMDIN
      *
     C     DDEXRT        IFEQ      *BLANKS
     C     DDMDIN        ANDEQ     *BLANKS
     C     DDECUR        ANDNE     FA_FCCY
     C     FA_FCCY       ANDNE     *BLANKS                                                  MD028931
     C     DDFACT        ANDNE     *BLANKS                                                  MD053942
     C     DDFCNO        ANDNE     *BLANKS                                                  MD053942
     C     DDEXRT        OREQ      *BLANKS                                                  MD053942
     C     DDMDIN        ANDEQ     *BLANKS                                                  MD053942
     C     DDECUR        ANDNE     CL_CCY                                                   MD053942
     C     CL_CCY        ANDNE     *BLANKS                                                  MD053942
     C     DDLNRF        ANDNE     *BLANKS                                                  MD053942
     C                   MOVE      ZMDIX         WMDIN
      *                                                                                      BUG8565
     C                   EVAL      ZFLD15=WERAT*100000000                                    BUG8565
     C                   EVAL      ZDECS=8                                                   BUG8565
     C                   CALLB     'ZSEDIT'                                                  BUG8565
     C                   PARM                    ZFLD15           15 0                       BUG8565
     C                   PARM                    ZDECS             1 0                       BUG8565
     C                   PARM      *BLANKS       ZECODE            1                         BUG8565
     C                   PARM                    ZOUT21           21                         BUG8565
     C                   EVAL      DDEXRT= %SUBST(ZOUT21:9:12)                               BUG8565
     C                   EVAL      DDMDIN = ZMDIX                                            BUG8565
      *                                                                                      BUG8565
     C                   ENDIF
                                                                                              CAS011
      ** Validate Next Payment Date, Frequency and Day in Month                               CAS011
                                                                                              CAS011
     C                   EXSR      SRNxtP                                                     CAS011
      **********                                                                              CAS011
      ***Next*Payment Date                                                                    CAS011
      **********                                                                              CAS011
      ***If*date not entered and payment on *EQ to N                                          CAS011
      **********                                                                              CAS011
     C*****DDEPON        IFEQ      'N'                                                        CAS011
     C*****DDNPYD        ANDEQ     *BLANKS                                                    CAS011
     C**********         Move      'N'           DDNPYDOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0060'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C*****DDNPYD        IFNE      *BLANKS                                                    CAS011
     C**********         MOVE      DDNPYD        DATEA                                        CAS011
     C**********         TESTN                   DATEA                9798                    CAS011
     C**********         CALLB     'ZDATE1'                                                   CAS011
     C**********         PARM                    DATEA             6                          CAS011
     C**********         PARM                    ZDAYNO            5 0                        CAS011
     C**********         PARM                    BJDFIN                                       CAS011
     C**********         PARM                    ErrorFlag         1                          CAS011
      **********                                                                              CAS011
      *****-*invalid format or not numeric                                                    CAS011
     C*****ErrorFlag     IFEQ      'Y'                                                        CAS011
     C******IN97         OREQ      '0'                                                        CAS011
     C******IN98         ANDEQ     '0'                                                        CAS011
     C**********         Move      'N'           DDNPYDOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0061'     MsgIDXAr(Idx)                                CAS011
     C**********         ELSE                                                                 CAS011
     C**********         Z-ADD     ZDAYNO        WNPYD                                        CAS011
      **********                                                                              CAS011
      ***If*date entered and *LT last payment date then error                                 CAS011
      **********                                                                              CAS011
     C*****DDACTN        IFEQ      'A'                                                        CAS011
     C*****WNPYD         ANDLT     @@FELPDT                                                   CAS011
     C**********         Move      'N'           DDNPYDOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0062'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ***If*date entered and payment on *NE to N                                              CAS011
      **********                                                                              CAS011
     C*****DDEPON        IFNE      'N'                                                        CAS011
     C**********         Move      'N'           DDNPYDOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0060'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C*****WPSTD         IFGE      WNPYD                                                      CAS011
     C**********         Move      'N'           DDNPYDOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0061'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C*****WPEND         IFLT      WNPYD                                                      CAS011
     C**********         Move      'N'           DDNPYDOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0099'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C*****DDACTN        IFEQ      'X'                                                        CAS011
      **********                                                                              CAS011
      ***Do*extra validations                                                                 CAS011
      **********                                                                              CAS011
      ***If*settlement is next payment date and method is either 01 07                        CAS011
      ***or*08,*then check date for a holiday in both local and fee ccy.                      CAS011
      **********                                                                              CAS011
     C*****DDNPYDOK      IFEQ      'Y'                                                        CAS011
     C*****DDEPON        IFEQ      'N'                                                        CAS011
     C**********         Z-ADD     WNPYD         ZDAYNO                                       CAS011
      **********                                                                              CAS011
     C*****@@FESTTL      IFEQ      01                                                         CAS011
     C*****@@FESTTL      OREQ      07                                                         CAS011
     C*****@@FESTTL      OREQ      08                                                         CAS011
      **********                                                                              CAS011
     C**********         MOVE      DDECUR        ZCCY                                         CAS011
      **********                                                                              CAS011
     C**********         CALLB     'ZCHKH'                                                    CAS011
     C**********         PARM                    ZDAYNO                                       CAS011
     C**********         PARM                    ZCCY                                         CAS011
     C**********         PARM                    BJSLCD                                       CAS011
     C**********         PARM                    HolidayInd                                   CAS011
     C**********                                                                              CAS011
     C****If*HolidayInd = 'H' then the date is a holiday.                                     CAS011
     C*****HolidayInd    IFEQ      'H'                                                        CAS011
     C**********         MOVE      'W'           DDNPYDOK                                     CAS011
     C**********         ADD       1             WId                                          CAS011
     C**********         MOVEL     'DDNPYD'      WFldNmXAr(WId)                               CAS011
     C**********         MOVEL     'LER0229'     WMsgIdXAr(WId)                               CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ELSE                                                                 CAS011
      **********                                                                              CAS011
      ***Local*Ccy check                                                                      CAS011
      **********                                                                              CAS011
     C**********         MOVE      BJLCCY        ZCCY              3                          CAS011
      **********                                                                              CAS011
     C**********         CALLB     'ZCHKH'                                                    CAS011
     C**********         PARM                    ZDAYNO                                       CAS011
     C**********         PARM                    ZCCY                                         CAS011
     C**********         PARM                    BJSLCD                                       CAS011
     C**********         PARM                    HolidayInd                                   CAS011
     C**********                                                                              CAS011
     C****If*HolidayInd = 'H' then the date is a holiday.                                     CAS011
     C*****HolidayInd    IFEQ      'H'                                                        CAS011
     C**********         MOVE      'W'           DDNPYDOK                                     CAS011
     C**********         ADD       1             WId                                          CAS011
     C**********         MOVEL     'DDNPYD'      WFldNmXAr(WId)                               CAS011
     C**********         MOVEL     'LER0230'     WMsgIdXAr(WId)                               CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C**********         ELSE                                                                 CAS011
     C**********         Z-ADD     0             WNPYD                                        CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      **Frequency of Payment                                                                  CAS011
      **********                                                                              CAS011
     C**********         MOVE      *BLANKS       WFREQ                                        CAS011
     C*****DDFREQ        IFNE      *BLANKS                                                    CAS011
      **********                                                                              CAS011
     C*****DDFREQ        IFEQ      'M'                                                        CAS011
     C*****DDFREQ        OREQ      'Q'                                                        CAS011
     C*****DDFREQ        OREQ      'X'                                                        CAS011
     C*****DDFREQ        OREQ      'Y'                                                        CAS011
     C**********         MOVE      DDFREQ        WFREQ                                        CAS011
     C**********         ELSE                                                                 CAS011
     C**********         Move      'N'           DDFREQOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0064'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ***If*next payment date is not entered then freq. cannot be                             CAS011
      ***entered                                                                              CAS011
      **********                                                                              CAS011
     C*****WNPYD         IFEQ      0                                                          CAS011
     C*****DDNPYDOK      ANDEQ     'Y'                                                        CAS011
     C**********         Move      'N'           DDFREQOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0100'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ***If*next payment date is entered then freq. must be entered                           CAS011
      **********                                                                              CAS011
     C*****DDFREQ        IFEQ      *BLANK                                                     CAS011
     C*****DDNPYD        ANDNE     *BLANK                                                     CAS011
      **********                                                                              CAS011
     C*****WNPYD         IFEQ      WPEND                                                      CAS011
     C*****WNPYD         OREQ      0                                                          CAS011
     C*****WNPYD         ORGT      0                                                          CAS011
     C*****DDEPON        ANDEQ     'N'                                                        CAS011
     C*****WPEND         ANDGT     0                                                          CAS011
     C**********         ELSE                                                                 CAS011
     C**********         Move      'N'           DDFREQOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0141'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ***Day*in*month                                                                         CAS011
      **********                                                                              CAS011
     C**********         Z-ADD     0             WDYIM                                        CAS011
     C*****DDDYIM        IFNE      *BLANKS                                                    CAS011
      **********                                                                              CAS011
      ***Frequency must be entered                                                            CAS011
      **********                                                                              CAS011
     C*****DDFREQ        IFEQ      *BLANKS                                                    CAS011
     C**********         Move      'N'           DDFREQOK                                     CAS011
     C**********         Move      'N'           DDDYIMOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDDYIM'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0065'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ***Must*be between 1 & 31                                                               CAS011
      **********                                                                              CAS011
     C**********         MOVE      '0'           TEST2             3                          CAS011
     C**********         MOVEL     DDDYIM        TEST2                                        CAS011
     C**********         TESTN                   TEST2                78                      CAS011
     C**********         MOVE      DDDYIM        WDYIM                                        CAS011
     C******IN78         IFEQ      '1'                                                        CAS011
     C*****WDYIM         ANDGT     0                                                          CAS011
     C*****WDYIM         ANDLT     32                                                         CAS011
     C**********         ELSE                                                                 CAS011
     C**********         Move      'N'           DDDYIMOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDDYIM'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0066'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ***If*day*in month not entered then default to day of                                   CAS011
      ***next*payment                                                                         CAS011
      **********                                                                              CAS011
     C*****DDDYIM        IFEQ      *BLANK                                                     CAS011
     C*****DDNPYDOK      ANDEQ     'Y'                                                        CAS011
     C*****WNPYD         ANDNE     0                                                          CAS011
     C*****DDFREQ        ANDNE     *BLANKS                                                    CAS011
     C******IN96         IFEQ      '0'                                                        CAS011
     C**********         MOVEL     DDNPYD        WDYIM                                        CAS011
     C**********         ELSE                                                                 CAS011
     C**********         MOVEL     DDNPYD        WRKRP             4 0                        CAS011
     C**********         MOVE      WRKRP         WDYIM                                        CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
      **********                                                                              CAS011
      ****Ensure next Next Payment Date is not after End Date                                 CAS011
      **********                                                                              CAS011
     C*****WDYIM         IFGT      0                                                          CAS011
     C*****WNPYD         ANDNE     *ZEROS                                                     CAS011
     C*****WPEND         ANDNE     *ZEROS                                                     CAS011
     C*****WFREQ         ANDNE     *BLANKS                                                    CAS011
     C*****DDECUR        ANDNE     *BLANKS                                                    CAS011
     C**********         MOVE      WNPYD         ZDAYNO                                       CAS011
     C**********         MOVE      WFREQ         ZFREQ                                        CAS011
     C**********         MOVE      WDYIM         ZMDAY                                        CAS011
     C**********         MOVE      DDECUR        ZCCY                                         CAS011
     C**********         CALLB     'ZFREQB'                                                   CAS011
     C**********         PARM      *BLANKS       @RTCD                                        CAS011
     C**********         PARM                    ZFREQ             1                          CAS011
     C**********         PARM                    ZDAYNO                                       CAS011
     C**********         PARM                    ZCCY                                         CAS011
     C**********         PARM      *ZERO         ZMDAY             2 0                        CAS011
     C**********         PARM                    BJDFIN                                       CAS011
     C**********         PARM      SDGELR        SDGELR                                       CAS011
      **********                                                                              CAS011
     C*****ZDAYNO        IFGT      WPEND                                                      CAS011
     C**********         Move      'N'           DDFREQOK                                     CAS011
     C**********         Move      'N'           DDDYIMOK                                     CAS011
     C**********         Add       1             Idx                                          CAS011
     C**********         Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0142'     MsgIDXAr(Idx)                                CAS011
     C**********         ENDIF                                                                CAS011
     C**********         ENDIF                                                                CAS011
      *
      ** If next payment date is amended for calculated fees,
      ** do not allow date to equal run date if there is a
      ** fee adjustment.
      *
     C     DDACTN        IFEQ      'A'
     C     @@FECALT      ANDNE     *BLANKS
     C     WNPYD         ANDNE     @@FENPYD
      *
     C     FEADKY        SETLL     LEFEEADF
     C     FEADKY        READE     LEFEEADF                               74
     C     FARECI        DOWEQ     '*'
     C     *IN74         ANDEQ     '0'
     C     FATYPE        ORNE      *BLANK
     C     *IN74         ANDEQ     '0'
     C     FEADKY        READE     LEFEEADF                               74
     C                   ENDDO
      *
     C     *IN74         IFEQ      '0'
     C     WNPYD         ANDEQ     BJRDNB
     C                   Move      'N'           DDNPYDOK
     C                   Add       1             Idx
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)
     C                   Movel     'LER1183'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Percent indicator
      *
     C     DDPIND        IFEQ      ' '
     C     DDPIND        OREQ      'A'
     C     DDPIND        OREQ      'P'
     C                   MOVE      DDPIND        WPIND
      *                                                                                       CLE073
      ** SFPIND must be 'P' for types '97' or '98' and 'A' for '99'.                          CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
      *                                                                                       CLE073
     C     DDCALT        IFEQ      '97'                                                       CLE073
     C     DDPIND        ANDNE     'P'                                                        CLE073
     C     DDCALT        OREQ      '98'                                                       CLE073
     C     DDPIND        ANDNE     'P'                                                        CLE073
     C     DDCALT        OREQ      '99'                                                       CLE073
     C     DDPIND        ANDNE     'A'                                                        CLE073
     C     DDCALT        OREQ      '90'                                                       CLE134
     C     DDPIND        ANDNE     'A'                                                        CLE134
     C                   MOVE      'N'           DDPINDOK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDPIND'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0009'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
     C                   ELSE                                                                 CLE073
      *
      ** Check % ind against calc type
      *
     C     DDPIND        IFEQ      ' '
     C     DDCALT        IFEQ      '03'
     C     DDCALT        OREQ      '06'
     C     DDCALT        OREQ      '13'
     C     DDCALT        OREQ      '16'
     C     DDCALT        OREQ      '21'
     C     DDCALT        OREQ      '22'
     C                   MOVE      'A'           WPIND
     C                   ELSE
     C                   Move      'N'           DDPINDOK
     C                   Add       1             Idx
     C                   Movel     'DDPIND'      FldNamXAr(Idx)
     C                   Movel     'LER0067'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDPIND        IFEQ      'A'
     C     DDPIND        OREQ      'P'
     C     DDCALT        IFEQ      '01'
     C     DDCALT        OREQ      '02'
     C     DDCALT        OREQ      '04'
     C     DDCALT        OREQ      '05'
     C     DDCALT        OREQ      '11'
     C     DDCALT        OREQ      '12'
     C     DDCALT        OREQ      '14'
     C     DDCALT        OREQ      '15'
     C                   ELSE
     C                   IF        (DDCALT = '03' OR                                        MD022378
     C                             DDCALT  = '06' OR                                        MD022378
     C                             DDCALT  = '13' OR                                        MD022378
     C                             DDCALT  = '16' OR                                        MD022378
     C                             DDCALT  = '21' OR                                        MD022378
     C                             DDCALT  = '22') AND                                      MD022378
     C                             (DDPIND = 'A')                                           MD022378
     C                   ELSE                                                               MD022378
     C                   Move      'N'           DDPINDOK
     C                   Add       1             Idx
     C                   Movel     'DDPIND'      FldNamXAr(Idx)
     C                   Movel     'LER0053'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                              MD022378
     C                   ENDIF
     C                   ENDIF                                                                CLE073
      *
     C                   ELSE
     C                   Move      'N'           DDPINDOK
     C                   Add       1             Idx
     C                   Movel     'DDPIND'      FldNamXAr(Idx)
     C                   Movel     'LER0067'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Next Payment Date                                                                    245071
      ** If date not entered and payment on *EQ to N                                          245071
                                                                                              245071
     C                   IF        DDNPYD = *BLANKS AND DDEPON = 'N'                          245071
     C                   EVAL      DDNPYDOK = 'N'                                             245071
     C                   EVAL      Idx = Idx + 1                                              245071
     C                   EVAL      FldNamXAr(Idx) = 'DDNPYD'                                  245071
     C                   EVAL      MsgIDXAr(Idx) = 'LER0060'                                  245071
     C                   ENDIF                                                                245071

      ** Calculation type is blank then all other fields must be blank
      *
     C     DDRTE1        IFEQ      *BLANKS
     C     DDRTE2        ANDEQ     *BLANKS
     C     DDRTE3        ANDEQ     *BLANKS
     C     DDRTE4        ANDEQ     *BLANKS
     C     DDRTE5        ANDEQ     *BLANKS
     C     DDFAMT1       ANDEQ     *BLANKS
     C     DDFAMT2       ANDEQ     *BLANKS
     C     DDFAMT3       ANDEQ     *BLANKS
     C     DDFAMT4       ANDEQ     *BLANKS
     C     DDFAMT5       ANDEQ     *BLANKS
     C     DDCALC        ANDEQ     *BLANKS
     C     DDEXRT        ANDEQ     *BLANKS
     C     DDNPYD        ANDEQ     *BLANKS
     C     DDFREQ        ANDEQ     *BLANKS
     C     DDDYIM        ANDEQ     *BLANKS
     C     DDPIND        ANDEQ     *BLANKS
     C     DDMDIN        ANDEQ     *BLANKS
                                                                                              CLE031
     C     DDRTE1        OREQ      *BLANKS                                                    CLE031
     C     DDRTE2        ANDEQ     *BLANKS                                                    CLE031
     C     DDRTE3        ANDEQ     *BLANKS                                                    CLE031
     C     DDRTE4        ANDEQ     *BLANKS                                                    CLE031
     C     DDRTE5        ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT1       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT2       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT3       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT4       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT5       ANDEQ     *BLANKS                                                    CLE031
     C     DDCALC        ANDEQ     *BLANKS                                                    CLE031
     C     DDEXRT        ANDEQ     *BLANKS                                                    CLE031
     C     DDPIND        ANDEQ     *BLANKS                                                    CLE031
     C     DDMDIN        ANDEQ     *BLANKS                                                    CLE031
     C     CLE031        ANDEQ     'Y'                                                        CLE031
     C     DDNPYD        ANDEQ     *BLANKS                                                    CLE031
     C     DDFREQ        ANDEQ     *BLANKS                                                    CLE031
     C     DDDYIM        ANDEQ     *BLANKS                                                    CLE031
     C     DDEPON        ANDNE     'N'                                                        CLE031
                                                                                              CLE031
     C     DDRTE1        OREQ      *BLANKS                                                    CLE031
     C     DDRTE2        ANDEQ     *BLANKS                                                    CLE031
     C     DDRTE3        ANDEQ     *BLANKS                                                    CLE031
     C     DDRTE4        ANDEQ     *BLANKS                                                    CLE031
     C     DDRTE5        ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT1       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT2       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT3       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT4       ANDEQ     *BLANKS                                                    CLE031
     C     DDFAMT5       ANDEQ     *BLANKS                                                    CLE031
     C     DDCALC        ANDEQ     *BLANKS                                                    CLE031
     C     DDEXRT        ANDEQ     *BLANKS                                                    CLE031
     C     DDPIND        ANDEQ     *BLANKS                                                    CLE031
     C     DDMDIN        ANDEQ     *BLANKS                                                    CLE031
     C     CLE031        ANDEQ     'Y'                                                        CLE031
     C     DDEPON        ANDEQ     'N'                                                        CLE031
     C/COPY WNCPYSRC,LEH00503
     C                   Z-ADD     0             WFRT1             7 5
     C                   Z-ADD     0             WFRT2             7 5
     C                   Z-ADD     0             WFRT3             7 5
     C                   Z-ADD     0             WFRT4             7 5
     C                   Z-ADD     0             WFRT5             7 5
     C                   Z-ADD     0             WCAMT1           11 0
     C                   Z-ADD     0             WCAMT2           11 0
     C                   Z-ADD     0             WCAMT3           11 0
     C                   Z-ADD     0             WCAMT4           11 0
     C                   Z-ADD     0             WCAMT5           11 0
     C                   Z-ADD     0             WCALC             1 0
     C                   Z-ADD     0             WERAT            13 8
     C                   MOVE      *BLANKS       WMDIN             1
     C                   Z-ADD     0             WNPYD             5 0
     C                   MOVE      *BLANKS       WFREQ             1
     C                   Z-ADD     0             WDYIM             2 0
     C                   MOVE      *BLANK        WPIND             1
     C                   MOVE      *BLANKS       WDIND             1
     C                   Z-ADD     0             WAMTP            13 0
     C                   Z-ADD     0             WAMTA            13 0
     C                   Z-ADD     0             WAMTS            13 0
     C                   Z-ADD     0             WSDAT             5 0
     C                   Z-ADD     0             WADAT             5 0
     C                   Z-ADD     0             WDDAT             5 0
     C/COPY WNCPYSRC,LEH00504
                                                                                              CLE031
      ** Allow Payment On set to Next Payment Date for non-calculated fees                    CLE031
      ** Validate entries related to Next Payment Date and frequency.                         CLE031
                                                                                              CLE031
     C                   IF        CLE031 = 'Y' And DDEPON = 'N'                              CLE031
                                                                                              CLE031
      ** If date not entered and payment on *EQ to N                                          CLE031
     C                   IF        DDEPON = 'N' And DDNPYD = *Blanks                          CLE031
     C                   Move      'N'           DDNPYDOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0060'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   IF        DDNPYD <> *Blanks                                          CLE031
     C                   MOVE      DDNPYD        DATEA                                        CLE031
     C                   TESTN                   DATEA                9798                    CLE031
     C                   CALLB     'ZDATE1'                                                   CLE031
     C                   PARM                    DATEA             6                          CLE031
     C                   PARM                    ZDAYNO            5 0                        CLE031
     C                   PARM                    BJDFIN                                       CLE031
     C                   PARM                    ErrorFlag         1                          CLE031
                                                                                              CLE031
      **   - invalid format or not numeric                                                    CLE031
     C                   IF        ErrorFlag = 'Y' Or                                         CLE031
     C                             *IN97 = *OFF And *IN98 = *OFF                              CLE031
     C                   Move      'N'           DDNPYDOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0061'     MsgIDXAr(Idx)                                CLE031
     C                   ELSE                                                                 CLE031
     C                   Z-ADD     ZDAYNO        WNPYD                                        CLE031
                                                                                              CLE031
      ** If date entered and *LT last payment date then error                                 CLE031
     C                   IF        DDACTN = 'A' And WNPYD < @@FELPDT                          CLE031
     C                   Move      'N'           DDNPYDOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0062'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   IF        WPSTD >= WNPYD                                             CLE031
     C                   Move      'N'           DDNPYDOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0061'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   IF        WPEND < WNPYD                                              CLE031
     C                   Move      'N'           DDNPYDOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0099'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   IF        DDACTN = 'X'                                               CLE031
                                                                                              CLE031
      ** Do extra validations                                                                 CLE031
                                                                                              CLE031
      ** If settlement is next payment date and method is either 01 07                        CLE031
      ** or 08, then check date for a holiday in both local and fee ccy.                      CLE031
                                                                                              CLE031
     C                   IF        DDNPYDOK = 'Y'                                             CLE031
     C                   IF        DDEPON = 'N'                                               CLE031
     C                   Z-ADD     WNPYD         ZDAYNO                                       CLE031
                                                                                              CLE031
     C     @@FESTTL      IFEQ      01                                                         CLE031
     C     @@FESTTL      OREQ      07                                                         CLE031
     C     @@FESTTL      OREQ      08                                                         CLE031

     C*****CLE141        IFEQ      'N'                                                CLE141 CLE141A
     C*****DDLNRF        OREQ      *blanks                                            CLE141 CLE141A
                                                                                              CLE031
     C                   MOVE      DDECUR        ZCCY                                         CLE031
                                                                                              CLE031
     C                   CALLB     'ZCHKH'                                                    CLE031
     C                   PARM                    ZDAYNO                                       CLE031
     C                   PARM                    ZCCY                                         CLE031
     C                   PARM                    BJSLCD                                       CLE031
     C                   PARM                    HolidayInd                                   CLE031
                                                                                              CLE031
      ** If HolidayInd = 'H' then the date is a holiday.                                      CLE031
     C     HolidayInd    IFEQ      'H'                                                        CLE031
     C                   MOVE      'W'           DDNPYDOK                                     CLE031
     C                   ADD       1             WId                                          CLE031
     C                   MOVEL     'DDNPYD'      WFldNmXAr(WId)                               CLE031
     C                   MOVEL     'LER0229'     WMsgIdXAr(WId)                               CLE031
     C                   ENDIF                                                                CLE031

     C**********         ENDIF                                                        CLE141 CLE141A

     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Local Ccy check                                                                      CLE031
                                                                                              CLE031
     C                   MOVE      BJLCCY        ZCCY              3                          CLE031
                                                                                              CLE031
     C                   CALLB     'ZCHKH'                                                    CLE031
     C                   PARM                    ZDAYNO                                       CLE031
     C                   PARM                    ZCCY                                         CLE031
     C                   PARM                    BJSLCD                                       CLE031
     C                   PARM                    HolidayInd                                   CLE031
                                                                                              CLE031
      ** If HolidayInd = 'H' then the date is a holiday.                                      CLE031
     C     HolidayInd    IFEQ      'H'                                                        CLE031
     C                   MOVE      'W'           DDNPYDOK                                     CLE031
     C                   ADD       1             WId                                          CLE031
     C                   MOVEL     'DDNPYD'      WFldNmXAr(WId)                               CLE031
     C                   MOVEL     'LER0230'     WMsgIdXAr(WId)                               CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     DDLNRF        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDNPYDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDNPYD'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048567'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      *                                                                                       CLE073
      ** Validate Next Payment Date is within loan period                                     CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     WNPYD         IFLT      CL_VDAT                                                    CLE073
     C     WNPYD         ORGT      CL_MDAT                                                    CLE073
     C     CL_MDAT       ANDNE     0                                                          CLE073
     C                   MOVE      'N'           DDNPYDOK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDNPYD'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0003'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
      ** Do not allow amendment if Payment is due today                                       CLE073
      *                                                                                       CLE073
     C     DDACTN        IFEQ      'A'                                                        CLE073
     C     WNPYD         ANDNE     @@FENPYD                                                   CLE073
     C     BJRDNB        ANDEQ     @@FELPDT                                                   CLE073
     C                   MOVE      'N'           DDNPYDOK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDNPYD'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0011'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C                   ELSE                                                                 CLE031
     C                   Z-ADD     0             WNPYD                                        CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Frequency of Payment                                                                 CLE031
                                                                                              CLE031
     C                   MOVE      *BLANKS       WFREQ                                        CLE031
     C     DDFREQ        IFNE      *BLANKS                                                    CLE031
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT      = '90'                                         CLE134
     C                   IF        DDFREQ      = 'P'                                          CLE134
     C                   EVAL      WFREQ       = DDFREQ                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DDFREQOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDFREQ'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045596'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
                                                                                              CLE031
     C     DDFREQ        IFEQ      'M'                                                        CLE031
     C     DDFREQ        OREQ      'Q'                                                        CLE031
     C     DDFREQ        OREQ      'X'                                                        CLE031
     C     DDFREQ        OREQ      'Y'                                                        CLE031
     C     DDFREQ        OREQ      'D'                                                        CLE064
     C     DDFREQ        OREQ      'W'                                                        CLE064
     C     DDFREQ        OREQ      'F'                                                        CLE064
     C     DDFREQ        OREQ      'T'                                                        CLE064
     C     DDFREQ        OREQ      '4'                                                        CLE064
     C     DDFREQ        OREQ      '5'                                                        CLE064
     C     DDFREQ        OREQ      '7'                                                        CLE064
     C     DDFREQ        OREQ      '8'                                                        CLE064
     C     DDFREQ        OREQ      '9'                                                        CLE064
     C     DDFREQ        OREQ      'V'                                                        CLE064
     C     DDFREQ        OREQ      'E'                                                        CLE064
     C     DDFREQ        OREQ      'C'                                                        CLE064
     C     DDFREQ        OREQ      'I'                                                        CLE064
     C     DDFREQ        OREQ      'J'                                                        CLE064
     C     DDFREQ        OREQ      'N'                                                        CLE064
     C     DDFREQ        OREQ      'U'                                                        CLE064
     C                   MOVE      DDFREQ        WFREQ                                        CLE031
     C                   ELSE                                                                 CLE031
     C                   Move      'N'           DDFREQOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDFREQ'      FldNamXAr(Idx)                               CLE031
     C**********         Movel     'LER0064'     MsgIDXAr(Idx)                         CLE031 CLE064
     C                   MOVEL     'LER5611'     MsgIDXAr(Idx)                                CLE064
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE134
                                                                                              CLE031
      ** If next payment date is not entered then freq. cannot be                             CLE031
      ** entered                                                                              CLE031
                                                                                              CLE031
     C     WNPYD         IFEQ      0                                                          CLE031
     C     DDNPYDOK      ANDEQ     'Y'                                                        CLE031
     C                   Move      'N'           DDFREQOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDFREQ'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0100'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** If next payment date is entered then freq. must be entered                           CLE031
                                                                                              CLE031
     C     DDFREQ        IFEQ      *BLANK                                                     CLE031
     C     DDNPYD        ANDNE     *BLANK                                                     CLE031
                                                                                              CLE031
     C     WNPYD         IFEQ      WPEND                                                      CLE031
     C     WNPYD         OREQ      0                                                          CLE031
     C     WNPYD         ORGT      0                                                          CLE031
     C     DDEPON        ANDEQ     'N'                                                        CLE031
     C     WPEND         ANDGT     0                                                          CLE031
     C                   ELSE                                                                 CLE031
     C                   Move      'N'           DDFREQOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDFREQ'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0141'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Day in month                                                                         CLE031
                                                                                              CLE031
     C                   Z-ADD     0             WDYIM                                        CLE031
     C     DDDYIM        IFNE      *BLANKS                                                    CLE031
                                                                                              CLE031
      ** Frequency must be entered                                                            CLE031
                                                                                              CLE031
     C     DDFREQ        IFEQ      *BLANKS                                                    CLE031
     C                   Move      'N'           DDFREQOK                                     CLE031
     C                   Move      'N'           DDDYIMOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDDYIM'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0065'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** Must be between 1 & 31                                                               CLE031
                                                                                              CLE031
     C                   MOVE      '0'           TEST2             3                          CLE031
     C                   MOVEL     DDDYIM        TEST2                                        CLE031
     C                   TESTN                   TEST2                78                      CLE031
     C                   MOVE      DDDYIM        WDYIM                                        CLE031
     C     *IN78         IFEQ      '1'                                                        CLE031
     C     WDYIM         ANDGT     0                                                          CLE031
     C     WDYIM         ANDLT     32                                                         CLE031
     C                   ELSE                                                                 CLE031
     C                   Move      'N'           DDDYIMOK                                     CLE031
     C                   Add       1             Idx                                          CLE031
     C                   Movel     'DDDYIM'      FldNamXAr(Idx)                               CLE031
     C                   Movel     'LER0066'     MsgIDXAr(Idx)                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      ** If day in month not entered then default to day of                                   CLE031
      ** next payment                                                                         CLE031
                                                                                              CLE031
     C     DDDYIM        IFEQ      *BLANK                                                     CLE031
     C     DDNPYDOK      ANDEQ     'Y'                                                        CLE031
     C     WNPYD         ANDNE     0                                                          CLE031
     C     DDFREQ        ANDNE     *BLANKS                                                    CLE031
     C     *IN96         IFEQ      '0'                                                        CLE031
     C                   MOVEL     DDNPYD        WDYIM                                        CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVEL     DDNPYD        WRKRP             4 0                        CLE031
     C                   MOVE      WRKRP         WDYIM                                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
      **  Ensure next Next Payment Date is not after End Date                                 CLE031
                                                                                              CLE031
     C     WDYIM         IFGT      0                                                          CLE031
     C     WNPYD         ANDNE     *ZEROS                                                     CLE031
     C     WPEND         ANDNE     *ZEROS                                                     CLE031
     C     WFREQ         ANDNE     *BLANKS                                                    CLE031
     C     DDECUR        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      WNPYD         ZDAYNO                                       CLE031
     C                   MOVE      WFREQ         ZFREQ                                        CLE031
     C                   MOVE      WDYIM         ZMDAY                                        CLE031
     C                   MOVE      DDECUR        ZCCY                                         CLE031
     C                   CALLB     'ZFREQB'                                                   CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM                    ZFREQ             1                          CLE031
     C                   PARM                    ZDAYNO                                       CLE031
     C                   PARM                    ZCCY                                         CLE031
     C                   PARM      *BLANKS       ZLOC              3                        AR702741
     C**********         PARM      *ZERO         ZMDAY             2 0               CLE031 MD022414
     C                   PARM                    ZMDAY             2 0                      MD022414
     C                   PARM                    BJDFIN                                       CLE031
     C                   PARM      SDGELR        SDGELR                                       CLE031
                                                                                              CLE031
     C     ZDAYNO        IFGT      WPEND                                                      CLE031
     C**********         Move      'N'           DDFREQOK                            CLE031 MD022414
     C**********         Move      'N'           DDDYIMOK                            CLE031 MD022414
     C**********         Add       1             Idx                                 CLE031 MD022414
     C**********         Movel     'DDFREQ'      FldNamXAr(Idx)                      CLE031 MD022414
     C**********         Movel     'LER0142'     MsgIDXAr(Idx)                       CLE031 MD022414
     C                   MOVE      'W'           DDFREQOK                                   MD022414
     C                   MOVE      'W'           DDDYIMOK                                   MD022414
     C                   ADD       1             WId                                        MD022414
     C                   MOVEL     'DDFREQ'      WFldNmXAr(WId)                             MD022414
     C                   MOVEL     'LER0142'     WMsgIdXAr(WId)                             MD022414
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      ** Then it must be an error
      *
     C                   Move      'N'           DDCALTOK
     C                   Add       1             Idx
     C                   Movel     'DDCALT'      FldNamXAr(Idx)
     C                   Movel     'LER0047'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ECATP         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RATE    -  Validate Rates entered                             *
      *****************************************************************
     C     RATE          BEGSR
      *                                                                                       CLE073
      ** For loan type 99, validation for Rate 1 blank is in SRCATP                           CLE073
      ** Here validation is for Rate 2 - 5 blank (so all Rate 1-5 must be blank for 99)       CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
                                                                                              CLE134
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
                                                                                              CLE134
     C     DDRTE2        IFNE      *BLANKS                                                    CLE073
     C     DDRTE3        ORNE      *BLANKS                                                    CLE073
     C     DDRTE4        ORNE      *BLANKS                                                    CLE073
     C     DDRTE5        ORNE      *BLANKS                                                    CLE073
     C                   MOVE      'N'           DDRTE2OK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDRTE2'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0004'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
      ** For loan types 97,98 only Rate 1 is used                                             CLE073
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C     DDRTE2        IFNE      *BLANKS                                                    CLE073
     C     DDRTE3        ORNE      *BLANKS                                                    CLE073
     C     DDRTE4        ORNE      *BLANKS                                                    CLE073
     C     DDRTE5        ORNE      *BLANKS                                                    CLE073
     C                   MOVE      'N'           DDRTE2OK                                     CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDRTE2'      FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'LER0049'     MsgIDXAr(Idx)                                CLE073
     C                   ENDIF                                                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
      *
      ** If more than one rate entered then calculation type must NOT equal
      ** 03,06,13,16,21,22.
      *
     C     DDRTE2        IFNE      *BLANKS
     C     DDCALT        IFEQ      '03'
     C     DDCALT        OREQ      '06'
     C     DDCALT        OREQ      '13'
     C     DDCALT        OREQ      '16'
     C     DDCALT        OREQ      '21'
     C     DDCALT        OREQ      '22'
     C                   Move      'N'           DDRTE2OK
     C                   Move      'N'           DDRTE3OK
     C                   Move      'N'           DDRTE4OK
     C                   Move      'N'           DDRTE5OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE2'      FldNamXAr(Idx)
     C                   Movel     'LER0049'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** A rate is invalid if the previous rate is blank
      *
     C     DDRTE2        IFEQ      *BLANKS
     C     DDRTE3        ANDNE     *BLANKS
     C     DDRTE2        OREQ      *BLANKS
     C     DDRTE4        ANDNE     *BLANKS
     C     DDRTE2        OREQ      *BLANKS
     C     DDRTE5        ANDNE     *BLANKS
     C                   Move      'N'           DDRTE2OK
     C                   Move      'N'           DDRTE3OK
     C                   Move      'N'           DDRTE4OK
     C                   Move      'N'           DDRTE5OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE2'      FldNamXAr(Idx)
     C                   Movel     'LER0050'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDRTE3        IFEQ      *BLANKS
     C     DDRTE4        ANDNE     *BLANKS
     C     DDRTE3        OREQ      *BLANKS
     C     DDRTE5        ANDNE     *BLANKS
     C                   Move      'N'           DDRTE2OK
     C                   Move      'N'           DDRTE3OK
     C                   Move      'N'           DDRTE4OK
     C                   Move      'N'           DDRTE5OK
     C                   Add       1             Idx
     C**********         Movel     'DDRTE2'      FldNamXAr(Idx)                              BUG9988
     C                   Movel     'DDRTE3'      FldNamXAr(Idx)                              BUG9988
     C                   Movel     'LER0050'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDRTE4        IFEQ      *BLANKS
     C     DDRTE5        ANDNE     *BLANKS
     C                   Move      'N'           DDRTE2OK
     C                   Move      'N'           DDRTE3OK
     C                   Move      'N'           DDRTE4OK
     C                   Move      'N'           DDRTE5OK
     C                   Add       1             Idx
     C**********         Movel     'DDRTE2'      FldNamXAr(Idx)                              BUG9988
     C                   Movel     'DDRTE4'      FldNamXAr(Idx)                              BUG9988
     C                   Movel     'LER0050'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** If rates have been entered in the correct sequence check
      ** for valid entry
      *
      * Rate 1
      * ~~~~~~
      *                                                                                       CLE073
     C     CLE073        IFEQ      'N'                                                        CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDRTE1        ANDNE     *BLANKS                                                    CLE073
      *                                                                                       CLE073
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDRTE1        ZFIELD
     C                   Z-ADD     2             ZADIG             2 0
     C                   Z-ADD     5             ZADEC
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDRTE1OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE1'      FldNamXAr(Idx)
     C                   Movel     'LER0051'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C     WA13          DIV       100000        WFRT1
     C                   ENDIF
     C                   ELSE                                                                 CLE073
     C                   Z-ADD     0             WFRT1                                        CLE073
     C                   EndIf                                                                CLE073
      *
      * Rate 2
      * ~~~~~~
     C     DDRTE2        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDRTE2        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     5             ZADEC
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDRTE2OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE2'      FldNamXAr(Idx)
     C                   Movel     'LER0051'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C     WA13          DIV       100000        WFRT2
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFRT2
     C                   ENDIF
      *
      * Rate 3
      * ~~~~~~
     C     DDRTE3        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDRTE3        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     5             ZADEC
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDRTE3OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE3'      FldNamXAr(Idx)
     C                   Movel     'LER0051'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C     WA13          DIV       100000        WFRT3
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFRT3
     C                   ENDIF
      *
      * Rate 4
      * ~~~~~~
     C     DDRTE4        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDRTE4        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     5             ZADEC
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDRTE4OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE4'      FldNamXAr(Idx)
     C                   Movel     'LER0051'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C     WA13          DIV       100000        WFRT4
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFRT4
     C                   ENDIF
      *
      * Rate 5
      * ~~~~~~
     C     DDRTE5        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDRTE5        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     5             ZADEC
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDRTE5OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE5'      FldNamXAr(Idx)
     C                   Movel     'LER0051'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C     WA13          DIV       100000        WFRT5
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFRT5
     C                   ENDIF
      *
      ** For calculation types "Threshold" or "Tierred":                                     BUG9988
      ** Rate 1 may be zero (not blank) only if rate 2 is not zero or blank                  BUG9988
     C     DDCALT        IFEQ      '01'                                                      BUG9988
     C     DDCALT        OREQ      '02'                                                      BUG9988
     C     DDCALT        OREQ      '04'                                                      BUG9988
     C     DDCALT        OREQ      '05'                                                      BUG9988
     C     DDCALT        OREQ      '11'                                                      BUG9988
     C     DDCALT        OREQ      '12'                                                      BUG9988
     C     DDCALT        OREQ      '14'                                                      BUG9988
     C     DDCALT        OREQ      '15'                                                      BUG9988
      *                                                                                      BUG9988
     C     WFRT1         IFEQ      0
     C     DDRTE1        ANDNE     *BLANKS                                                   BUG9988
     C     WFRT2         ANDEQ     0
     C                   Move      'N'           DDRTE2OK
     C                   Move      'N'           DDRTE3OK
     C                   Move      'N'           DDRTE4OK
     C                   Move      'N'           DDRTE5OK
     C                   Add       1             Idx
     C                   Movel     'DDRTE2'      FldNamXAr(Idx)
     C**********         Movel     'LER0050'     MsgIDXAr(Idx)                               BUG9988
     C                   Movel     'LER0237'     MsgIDXAr(Idx)                               BUG9988
     C                   ENDIF
      *                                                                                    AR1073605
     C                   ELSE                                                              AR1073605
      *                                                                                    AR1073605
     C     DDCALT        IFNE      '90'                                                    AR1073605
     C     DDCALT        ANDNE     '99'                                                    AR1073605
      *                                                                                    AR1073605
      ** For other calculation type, the rate must not be                                  AR1073605
      ** equals to zero.                                                                   AR1073605
      *                                                                                    AR1073605
     C     WFRT1         IFEQ      0                                                       AR1073605
     C     DDRTE1        ANDNE     *BLANKS                                                 AR1073605
     C                   MOVE      'N'           DDRTE1OK                                  AR1073605
     C                   ADD       1             Idx                                       AR1073605
     C                   MOVEL     'DDRTE1'      FldNamXAr(Idx)                            AR1073605
     C                   MOVEL     '5045926'     MsgIDXAr(Idx)                             AR1073605
      *                                                                                    AR1073605
     C                   ELSE                                                              AR1073605
      *                                                                                    AR1073605
      ** If CLE073 is switched *ON and calculation type not                                AR1073605
      ** equals to '97' or '98', the rate must not be *BLANK.                              AR1073605
      *                                                                                    AR1073605
     C     DDRTE1        IFEQ      *BLANKS                                                 AR1073605
     C     CLE073        ANDEQ     'Y'                                                     AR1073605
     C     DDCALT        ANDNE     '97'                                                    AR1073605
     C     DDCALT        ANDNE     '98'                                                    AR1073605
     C                   MOVE      'N'           DDRTE1OK                                  AR1073605
     C                   ADD       1             Idx                                       AR1073605
     C                   MOVEL     'DDRTE1'      FldNamXAr(Idx)                            AR1073605
     C                   MOVEL     '5029459'     MsgIDXAr(Idx)                             AR1073605
     C                   ENDIF                                                             AR1073605
      *                                                                                    AR1073605
     C                   ENDIF                                                             AR1073605
      *                                                                                    AR1073605
     C                   ENDIF                                                             AR1073605
     C                   ENDIF                                                               BUG9988
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AMNT    -  Validate Amounts entered                           *
      *****************************************************************
     C     AMNT          BEGSR
      *
     C     DDPIND        IFEQ      'A'
     C                   Z-ADD     11            ZADIG
     C                   Z-ADD     0             ZADEC
     C                   ELSE
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     3             ZADEC
     C                   ENDIF
      *                                                                                       CLE073
     C     CLE073        IFEQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '97'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '98'                                                       CLE073
     C     CLE073        OREQ      'Y'                                                        CLE073
     C     DDCALT        ANDEQ     '99'                                                       CLE073
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     DDCALT        ANDEQ     '90'                                                       CLE134
     C     DDFAMT1       IFNE      *BLANKS                                                    CLE073
     C     DDFAMT2       ORNE      *BLANKS                                                    CLE073
     C     DDFAMT3       ORNE      *BLANKS                                                    CLE073
     C     DDFAMT4       ORNE      *BLANKS                                                    CLE073
     C     DDFAMT5       ORNE      *BLANKS                                                    CLE073
     C                   MOVE      'N'           DDFAMT1OK                                    CLE073
     C                   ADD       1             Idx                                          CLE073
     C                   MOVEL     'DDFAMT1'     FldNamXAr(Idx)                               CLE073
     C                   MOVEL     'XLE0005'     MsgIDXAr(Idx)                                CLE073
     C                   ELSE                                                                 CLE073
     C                   Z-ADD     0             WCAMT1                                       CLE073
     C                   Z-ADD     0             WCAMT2                                       CLE073
     C                   Z-ADD     0             WCAMT3                                       CLE073
     C                   Z-ADD     0             WCAMT4                                       CLE073
     C                   Z-ADD     0             WCAMT5                                       CLE073
     C                   ENDIF                                                                CLE073
     C                   ELSE                                                                 CLE073
      *
      ** Amount 1
      *
     C     DDFAMT1       IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDFAMT1       ZFIELD
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDFAMT1OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT1'     FldNamXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C                   Z-ADD     WA13          WCAMT1
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             WCAMT1
     C                   ENDIF
      *
      ** Amount 2
      *
     C     DDFAMT2       IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDFAMT2       ZFIELD
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDFAMT2OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT2'     FldNamXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C                   Z-ADD     WA13          WCAMT2
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             WCAMT2
     C                   ENDIF
      *
      ** Amount 3
      *
     C     DDFAMT3       IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDFAMT3       ZFIELD
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDFAMT3OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT3'     FldNamXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C                   Z-ADD     WA13          WCAMT3
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             WCAMT3
     C                   ENDIF
      *
      ** Amount 4
      *
     C     DDFAMT4       IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDFAMT4       ZFIELD
     C                   MOVE      '0'           *IN99
      *
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDFAMT4OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT4'     FldNamXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C                   Z-ADD     WA13          WCAMT4
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             WCAMT4
     C                   ENDIF
      *
      ** Amount 5
      *
     C     DDFAMT5       IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDFAMT5       ZFIELD
     C                   MOVE      '0'           *IN99
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFNE      'Y'
     C                   Move      'N'           DDFAMT5OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT5'     FldNamXAr(Idx)
     C                   ELSE
     C                   MOVE      ZFIELD        WA13
     C                   Z-ADD     WA13          WCAMT5
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             WCAMT5
     C                   ENDIF
      *
     C     DDFAMT1OK     IFEQ      'N'
     C     DDFAMT2OK     OREQ      'N'
     C     DDFAMT3OK     OREQ      'N'
     C     DDFAMT4OK     OREQ      'N'
     C     DDFAMT5OK     OREQ      'N'
     C                   Z-ADD     1             AIdx                                       BUG10955
     C                   DOW       AIdx <= Idx                                              BUG10955
     C     DDPIND        IFEQ      'A'
     C**********         Movel     'LER0055'     MsgIDXAr(Idx)                              BUG10955
     C                   Movel     'LER0055'     MsgIDXAr(AIdx)                             BUG10955
     C                   ELSE
     C**********         Movel     'LER0072'     MsgIDXAr(Idx)                              BUG10955
     C                   Movel     'LER0072'     MsgIDXAr(AIdx)                             BUG10955
     C                   ENDIF
     C                   Add       1             AIdx                                       BUG10955
     C                   ENDDO                                                              BUG10955
     C                   Add       1             Idx
     C                   ENDIF
      *
     C     WCAMT2        IFNE      0
     C     WCAMT2        ANDLE     WCAMT1
     C     WCAMT3        ORNE      0
     C     WCAMT3        ANDLE     WCAMT2
     C     WCAMT4        ORNE      0
     C     WCAMT4        ANDLE     WCAMT3
     C     WCAMT5        ORNE      0
     C     WCAMT5        ANDLE     WCAMT4
     C                   Move      'N'           DDFAMT1OK
     C                   Move      'N'           DDFAMT2OK
     C                   Move      'N'           DDFAMT3OK
     C                   Move      'N'           DDFAMT4OK
     C                   Move      'N'           DDFAMT5OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT1'     FldNamXAr(Idx)
     C                   Movel     'LER0054'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     WCAMT1        IFEQ      0
     C     WCAMT2        ANDNE     0
     C     WCAMT1        OREQ      0
     C     WCAMT3        ANDNE     0
     C     WCAMT1        OREQ      0
     C     WCAMT4        ANDNE     0
     C     WCAMT1        OREQ      0
     C     WCAMT5        ANDNE     0
     C     WCAMT2        OREQ      0
     C     WCAMT3        ANDNE     0
     C     WCAMT2        OREQ      0
     C     WCAMT4        ANDNE     0
     C     WCAMT2        OREQ      0
     C     WCAMT5        ANDNE     0
     C     WCAMT3        OREQ      0
     C     WCAMT4        ANDNE     0
     C     WCAMT3        OREQ      0
     C     WCAMT5        ANDNE     0
     C     WCAMT4        OREQ      0
     C     WCAMT5        ANDNE     0
     C                   Move      'N'           DDFAMT1OK
     C                   Move      'N'           DDFAMT2OK
     C                   Move      'N'           DDFAMT3OK
     C                   Move      'N'           DDFAMT4OK
     C                   Move      'N'           DDFAMT5OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT1'     FldNamXAr(Idx)
     C                   Movel     'LER0052'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     WFRT2         IFNE      0
     C     WCAMT1        ANDEQ     0
     C     WFRT3         ORNE      0
     C     WCAMT2        ANDEQ     0
     C     WFRT4         ORNE      0
     C     WCAMT3        ANDEQ     0
     C     WFRT5         ORNE      0
     C     WCAMT4        ANDEQ     0
     C                   Move      'N'           DDFAMT1OK
     C                   Move      'N'           DDFAMT2OK
     C                   Move      'N'           DDFAMT3OK
     C                   Move      'N'           DDFAMT4OK
     C                   Move      'N'           DDFAMT5OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT1'     FldNamXAr(Idx)
     C                   Movel     'LER0052'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     WCAMT1        IFNE      0
     C     DDCALT        IFEQ      '03'
     C     DDCALT        OREQ      '06'
     C     DDCALT        OREQ      '13'
     C     DDCALT        OREQ      '16'
     C     DDCALT        OREQ      '21'
     C     DDCALT        OREQ      '22'
     C                   Move      'N'           DDFAMT1OK
     C                   Move      'N'           DDFAMT2OK
     C                   Move      'N'           DDFAMT3OK
     C                   Move      'N'           DDFAMT4OK
     C                   Move      'N'           DDFAMT5OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT1'     FldNamXAr(Idx)
     C                   Movel     'LER0053'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     WCAMT1        IFEQ      0
     C     DDCALT        IFEQ      '01'
     C     DDCALT        OREQ      '02'
     C     DDCALT        OREQ      '04'
     C     DDCALT        OREQ      '05'
     C     DDCALT        OREQ      '11'
     C     DDCALT        OREQ      '12'
     C     DDCALT        OREQ      '14'
     C     DDCALT        OREQ      '15'
     C                   Move      'N'           DDFAMT1OK
     C                   Move      'N'           DDFAMT2OK
     C                   Move      'N'           DDFAMT3OK
     C                   Move      'N'           DDFAMT4OK
     C                   Move      'N'           DDFAMT5OK
     C                   Add       1             Idx
     C                   Movel     'DDFAMT1'     FldNamXAr(Idx)
     C                   Movel     'LER0054'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * VPrfc   -  Validate Profit Center                             *
      *****************************************************************
     C     VPrfc         BEGSR
      *
      **  Validate Profit Centre if Profit Centre is used and
      **  is amendable, or during insert.
      *
     C     BKPRCU        IFEQ      'Y'
     C     BKPRCA        IFEQ      'Y'
     C     DDACTN        OREQ      'I'
     C*
      **  If Profit Centre is used then :-
      **  Validate the input Profit Centre if entered
      *
     C     DDPRFC        IFNE      *BLANKS

     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDPRFC        PPRFC             4
     C     SDPRFC        PARM      SDPRFC        DSFDY

     C     PRTCD         IFNE      *BLANKS
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'LER0146'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      DSPCCD        DDPRFC
     C                   ENDIF
      *
      **  Else /* Profit Centre is used but not entered */ :-
      **  Extract the default Profit Centre if input Profit Centre is
      **  blank and Profit Centre used flag is on and default flag is
      **  also on.
     C                   ELSE
     C                   MOVE      *BLANKS       RTCDPR
     C     @@FEACOF      IFNE      *BLANKS
     C                   MOVE      @@FEACOF      ACOFDM            2
     C                   ELSE
     C                   MOVE      CL_ACOF       ACOFDM
     C                   ENDIF
     C                   MOVEL     DDCSSN        CNUMDM            6
      *
     C     BKPCDU        IFEQ      'Y'
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       RTCDPR            1
     C                   PARM      CL_BOKC       BOOKPR            2
     C                   PARM      CL_LTYP       TRTPPR            5
     C                   PARM      CL_SUTP       SUTPPR            2
     C                   PARM      CL_BRCA       BRANPR            3
     C                   PARM      *BLANKS       DEPTPR            3
     C                   PARM      USER          USERPR           10
     C                   PARM      ACOFDM        ACOFPR            2
     C                   PARM      CNUMDM        CNUMPR            6
     C                   PARM      *BLANKS       PRFCPR            4

     C                   MOVE      PRFCPR        DDPRFC
     C     RTCDPR        IFEQ      '2'
     C                   Move      'N'           DDPRFCOK
     C                   Add       1             Idx
     C                   Movel     'DDPRFC'      FldNamXAr(Idx)
     C                   Movel     'LER0146'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SETUPVALID - Set up Valid file
      *****************************************************************
     C     SETUPVALID    BEGSR
      *
      * Fields from LEVFEEMPD File
     C                   MOVEL     DDACTN        VFLCHT
     C                   MOVEL     DDCSSN        VFCNUM
     C     DDLNRF        IFNE      *BLANKS                                                    242377
     C     PPCUST        ANDEQ     'O'                                                        242377
     C     CL_PTYP       IFEQ      64                                                         242377
     C     CL_PTYP       OREQ      65                                                         242377
     C     CL_PTYP       OREQ      68                                                         242377
     C     CL_PTYP       OREQ      71                                                         242377
     C                   MOVEL     CL_CNUM       VFCNUM                                       242377
     C                   ENDIF                                                                242377
     C                   ENDIF                                                                242377
     C                   MOVEL     DDFACT        VFFACL
     C                   MOVE      DDFCNO        VFFACL
     C                   MOVEL     DDLNRF        VFLOAN
     C                   MOVE      DDFSEQ        VFFSEQ
     C                   MOVE      DDECOD        VFFCOD
     C                   MOVE      DDECUR        VFFCCY
     C                   MOVE      WFAMT         VFFAMT
     C                   MOVE      WPSTD         VFPSTD
     C                   MOVE      WPEND         VFPEND
     C                   MOVE      DDEPON        VFPYON
     C                   MOVE      DDEADV        VFAUTO
     C                   MOVE      DDESHR        VFSHFI
     C                   MOVE      DDCALT        VFCALT
     C                   MOVE      WFRT1         VFFRT1
     C                   MOVE      WFRT2         VFFRT2
     C                   MOVE      WFRT3         VFFRT3
     C                   MOVE      WFRT4         VFFRT4
     C                   MOVE      WFRT5         VFFRT5
     C                   MOVE      WCAMT1        VFAMT1
     C                   MOVE      WCAMT2        VFAMT2
     C                   MOVE      WCAMT3        VFAMT3
     C                   MOVE      WCAMT4        VFAMT4
     C                   MOVE      WCAMT5        VFAMT5
     C**********         MOVE      DDPIND        VFPIND                                      BUG7290
     C                   MOVE      WPIND         VFPIND                                      BUG7290
     C                   MOVE      DDCALC        VFCALC
     C                   MOVE      WERAT         VFERAT
     C                   MOVE      WMDIN         VFMDIN
     C                   MOVE      WNPYD         VFNPYD
     C                   MOVE      DDFREQ        VFFREQ
     C                   MOVE      DDDYIM        VFDYIM
     C                   MOVE      DDPRFC        VFPRFC
     C                   MOVE      WPTFI         VFPTFI
     C                   MOVE      DDMASF        VFMASF                                       CLE106
     C                   MOVE      DDSTAL        VFSTAL                                       CLE034
                                                                                              CAS019
     C                   IF        (CAS016 = 'Y')                                             CAS019
     C                   MOVE      DDAMRI        VFAMRI                                       CAS019
     C                   IF        (DDSTPD <> *BLANKS)                                        CAS019
     C                   MOVE      DDSTPD        DATCNV            6                          CAS019
     C                   EXSR      CONVERT                                                    CAS019
     C                   MOVE      ZDAYNO        VFSTPD                                       CAS019
     C                   ENDIF                                                                CAS019
     C                   IF        (DDENPD <> *BLANKS)                                        CAS019
     C                   MOVE      DDENPD        DATCNV                                       CAS019
     C                   EXSR      CONVERT                                                    CAS019
     C                   MOVE      ZDAYNO        VFENPD                                       CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   EVAL      VFCAPI = DDCAPI                                            CLE139
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   MOVE      CL_LTYP       VFLTYP
     C                   MOVE      CL_SUTP       VFSUTP
     C                   MOVE      CL_CLAS       VFCLAS                                       CLE042
     C                   ELSE
     C                   MOVE      *BLANKS       VFLTYP
     C                   MOVE      *BLANKS       VFSUTP
     C                   MOVE      *BLANKS       VFCLAS                                       CLE042
     C                   ENDIF

     C     DDACTN        IFEQ      'I'                                                       BUG7528
     C                   Z-ADD     WAMTA         VFAMTA
     C**********         Z-ADD     WAMTS         VFAMTS                                       248820
     C**********         Z-ADD     WFAMT         VFAMTO                                      BUG7528
     C                   Z-ADD     WSDAT         VFSDAT
     C                   MOVE      WDIND         VFDIND
     C                   ENDIF                                                               BUG7528
      *                                                                                      BUG7528
     C**********         Z-ADD     WFAMT         VFAMTO                             BUG7528 AR760725

     C     ModeOfop      IFEQ      '*FRONT'
     C                   MOVEL     F3IUSR        VFIUSR
     C                   MOVEL     F3AUSR        VFAUSR
     C                   MOVEL     F3XUSR        VFXUSR
      *
      ** Set up Original Entry Date, and Last Change Date
     C                   MOVE      F3TRDS        WF3TDS
     C                   MOVEL     WF3DD         WFLD4             4
     C                   MOVE      WF3MM         WFLD4
     C                   MOVEL     WFLD4         WFLD6             6
     C                   MOVE      WF3YY         WFLD6
     C                   MOVEL     WFLD6         DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1

     C     ErrorFlag     IFEQ      'N'
     C                   Z-ADD     ZDAYNO        VFLCHD
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     ZDAYNO        VFORED
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      'A'           VFFSTS
      *
      ** Set up Last Change Type and PC transaction reference
      *
     C                   MOVE      DDACTN        VFLCHT
     C                   MOVE      F3TNRF        VFPCRF
     C                   MOVE      F3PCOB        VFPCOB
     C                   ELSE
     C                   Z-ADD     BJRDNB        VFLCHD
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     BJRDNB        VFORED
     C                   MOVEL     PSUSER        VFIUSR
     C                   MOVE      *BLANK        VFAUSR
     C                   MOVE      *BLANK        VFXUSR
     C                   ENDIF

     C     DDACTN        IFEQ      'A'
     C                   MOVEL     PSUSER        VFAUSR
     C                   ENDIF

     C                   ENDIF

     C     DDLNRF        IFNE      *BLANKS
     C                   MOVEL     CL_BRCA       WWBRCA            3
     C                   ELSE
     C                   MOVEL     FA_BRCA       WWBRCA
     C                   ENDIF

     C                   MOVEL     WWBRCA        VFBRCA

     C     ModeOfop      IFNE      '*FRONT'
     C     DDACTN        ANDEQ     'I'
     C     VFPCRF        ANDEQ     *BLANKS                                                   CSF011A
     C     CLE106        ANDNE     'Y'                                                       CSF011A

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WWBRCA        @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C     @RTCD         IFEQ      *BLANKS

     C                   IF        A8MQSM <> *BLANKS                                         CSF011A
     C                   Movel     A8MQSM        W#1ST3            3
     C                   ELSE                                                                CSF011A
     C                   MOVEL     WWBRCA        W#1ST3                                      CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
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
     C                   MOVEL     W1ST11        VFPCRF
     C                   MOVE      '0001'        VFPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
      *
     C                   ELSE
      *
     C     ModeOfop      IFEQ      '*FRONT'
     C                   MOVE      F3TNRF        VFPCRF
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CLE106
      ** If CLE106 is on, PC Reference must come from front office                            CLE106
                                                                                              CLE106
     C**********         IF        CLE106 = 'Y' OR F3TNRF <> *BLANKS                  CLE106 CSF011A
     C                   IF        CLE106 = 'Y' AND F3TNRF <> *BLANKS                        CSF011A
     C                             AND ModeOfop  <> '*FRONT'                                 CSF011A
     C                   EVAL      VFPCRF = F3TNRF                                            CLE106
     C                   ENDIF                                                                CLE106
      *

     C     CEU004        IFEQ      'Y'

     C     DDACTN        IFEQ      'X'
      ** info coming from file LEFEED
     C                   EVAL      VFSCCY = WSCCY
     C                   EVAL      VFICCY = @@FEICCY
     C                   ELSE
      ** info coming from input parameter
     C     WPTFI         IFEQ      ' '
     C                   IF        CL_PTYP = 66 or CL_PTYP = 67                            AR375891B
     C                             or CL_PTYP = 69 or CL_PTYP = 72                         AR375891B
     C                   EVAL      VFSCCY = DDPSCY                                         AR375891B
     C                   EVAL      VFICCY = DDIC72                                         AR375891B
     C                   ELSE                                                              AR375891B
     C                   EVAL      VFSCCY = DDRSCY
     C                   EVAL      VFICCY = *BLANKS
     C                   ENDIF                                                             AR375891B
     C                   ENDIF
     C     WPTFI         IFEQ      'P'
     C     WPTFI         OREQ      'S'                                                        CLE106
     C     WPTFI         OREQ      'R'                                                        CLE106
     C                   EVAL      VFSCCY = DDPSCY
     C                   EVAL      VFICCY = DDIC72
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVALR     DDPLNR      = %TRIM(DDPLNR)                                CLE134
     C                   MOVE      DDPLNR        VFEPLNR                                      CLE134
                                                                                              CLE134
     C**********         EVALR     DDRIDt      = %TRIM(DDRIDt)                         CLE134 263560
     C**********         MOVE      DDRIDt        VFERIDt                               CLE134 263560
                                                                                              263560
      ** Convert DDRIDt to Midas date format                                                  263560
                                                                                              263560
     C     DDRIDt        IFNE      *Blanks                                                    263560
     C                   MOVE      DDRIDt        DATEA                                        263560
     C                   CALLB     'ZDATE1'                                                   263560
     C                   PARM                    DATEA                                        263560
     C                   PARM                    ZDAYNO                                       263560
     C                   PARM                    BJDFIN                                       263560
     C                   PARM                    ErrorFlag                                    263560
     C                   Z-ADD     ZDAYNO        VFERIDt                                      263560
     C                   ELSE                                                                 263560
     C                   Z-ADD     0             VFERIDt                                      263560
     C                   ENDIF                                                                263560
                                                                                              263560
     C                   MOVE      DDRCat        VFERCat                                      CLE134
                                                                                              CLE134
     C**********         EVALR     DDBIDt      = %TRIM(DDBIDt)                         CLE134 263560
     C**********         MOVE      DDBIDt        VFEBIDt                               CLE134 263560
                                                                                              263560
      ** Convert DDBIDt to Midas date format                                                  263560
                                                                                              263560
     C     DDBIDt        IFNE      *Blanks                                                    263560
     C                   MOVE      DDBIDt        DATEA                                        263560
     C                   CALLB     'ZDATE1'                                                   263560
     C                   PARM                    DATEA                                        263560
     C                   PARM                    ZDAYNO                                       263560
     C                   PARM                    BJDFIN                                       263560
     C                   PARM                    ErrorFlag                                    263560
     C                   Z-ADD     ZDAYNO        VFEBIDt                                      263560
     C                   ELSE                                                                 263560
     C                   Z-ADD     0             VFEBIDt                                      263560
     C                   ENDIF                                                                263560
                                                                                              263560
     C                   MOVE      DDBCat        VFEBCat                                      CLE134
                                                                                              CLE134
     C                   EVAL      VFEFSFA     = DDFSFA                                       CLE134
                                                                                              CLE134
     C     DDSFAM        IFNE      *BLANKS                                                    CLE134
     C                   MOVE(P)   DDSFAM        ZFIELD                                       CLE134
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE134
     C     13            SUB       A6NBDP        ZADIG                                        CLE134
     C                   EXSR      ZALIGN                                                     CLE134
                                                                                              CLE134
     C     ZALIGNok      IFEQ      'Y'                                                        CLE134
     C                   MOVE      ZFIELD        VFESFAM                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C     DDSFPM        IFNE      *BLANKS                                             CLE134 263801
     C**********         MOVE(P)   DDSFPM        ZFIELD                                CLE134 263801
     C**********         Z-ADD     A6NBDP        ZADEC                                 CLE134 263801
     C*****13***         SUB       A6NBDP        ZADIG                                 CLE134 263801
     C**********         EXSR      ZALIGN                                              CLE134 263801
      **********                                                                       CLE134 263801
     C*****ZALIGNok      IFEQ      'Y'                                                 CLE134 263801
     C**********         MOVE      ZFIELD        VFESFPM                               CLE134 263801
     C**********         ENDIF                                                         CLE134 263801
     C                   MOVE      DDSFPM        VFESFPM                               CLE134 263801
     C                   ELSE                                                          CLE134 263801
     C                   Z-ADD     0             VFESFPM                               CLE134 263801
     C                   ENDIF                                                         CLE134 263801
                                                                                              CLE134
     C                   EVAL      VFEFPPA     = DDFPPA                                       CLE134
     C                   EVAL      VFEPSIn     = DDPSIn                                       CLE134
     C                   EVALR     DDPSLM      = %TRIM(DDPSLM)                                CLE134
                                                                                              CLE134
     C**********         MOVE      DDPSLM        VFEPSLM                                      262513
                                                                                              262513
     C     DDPSLM        IFNE      *BLANKS                                                    262513
     C                   MOVE(P)   DDPSLM        ZFIELD                                       262513
                                                                                              262513
     C                   IF        DDPSIn      = 'P'                                          262513
     C                   EVAL      ZADEC       = 0                                            262513
     C                   EVAL      ZADIG       = 3                                            262513
                                                                                              262513
     C                   ELSE                                                                 262513
     C                   EVAL      ZADEC       = A6NBDP                                       262513
     C                   EVAL      ZADIG       = 15 - A6NBDP                                  262513
     C                   ENDIF                                                                262513
                                                                                              262513
     C                   EXSR      ZALIGN                                                     262513
                                                                                              262513
     C     ZALIGNok      IFEQ      'Y'                                                        262513
     C                   MOVE      ZFIELD        VFEPSLM                                      262513
     C                   ENDIF                                                                262513
     C                   ENDIF                                                                262513
                                                                                              CLE134
     C                   EVAL      VFEFEMC     = DDFEMC                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDSR
      *****************************************************************                     AR994776
      /EJECT                                                                                AR994776
      *****************************************************************                     AR994776
      *                                                               *                     AR994776
      * SRRSFD  -  Restore orignal details (for Reject Action)        *                     AR994776
      *                                                               *                     AR994776
      *****************************************************************                     AR994776
     C     SRRSFD        BEGSR                                                              AR994776
      *                                                                                     AR994776
      ** Fee Code                                                                           AR994776
      *                                                                                     AR994776
     C                   MOVE      DDECOD        VFFCOD                                     AR994776
      *                                                                                     AR994776
      ** Currency Code                                                                      AR994776
      *                                                                                     AR994776
     C                   MOVE      DDECUR        VFFCCY                                     AR994776
      *                                                                                     AR994776
      ** Fee Amount                                                                         AR994776
      *                                                                                     AR994776
     C**********         MOVE      DDEAMT        VFFAMT                           AR994776 AR1049357
     C     DDEAMT        IFNE      *BLANKS                                                 AR1049357
     C                   MOVE      *BLANKS       ZFIELD                                    AR1049357
     C                   MOVE      DDEAMT        ZFIELD                                    AR1049357
     C                   CALL      'AOCURRR0'                                               MD031003
     C                   PARM      *BLANK        PRTCD                                      MD031003
     C                   PARM      '*KEY   '     POPTN                                      MD031003
     C                   PARM      DDECUR        PCURR                                      MD031003
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD031003
     C                   Z-ADD     A6NBDP        ZADEC                                     AR1049357
     C     13            SUB       A6NBDP        ZADIG                                     AR1049357
     C                   EXSR      ZALIGN                                                  AR1049357
     C                   MOVE      ZFIELD        VFFAMT                                    AR1049357
     C                   ENDIF                                                             AR1049357
      *                                                                                     AR994776
      ** Start Date                                                                         AR994776
      *                                                                                     AR994776
     C                   MOVE      DDEPSD        DATEA                                      AR994776
     C                   TESTN                   DATEA                9798                  AR994776
     C                   CALLB     'ZDATE1'                                                 AR994776
     C                   PARM                    DATEA                                      AR994776
     C                   PARM                    ZDAYNO                                     AR994776
     C                   PARM                    BJDFIN                                     AR994776
     C                   PARM                    ErrorFlag                                  AR994776
     C                   Z-ADD     ZDAYNO        VFPSTD                                     AR994776
      *                                                                                     AR994776
      ** End Date                                                                           AR994776
      *                                                                                     AR994776
     C                   MOVE      DDEPED        DATEA                                      AR994776
     C                   TESTN                   DATEA                9798                  AR994776
     C                   CALLB     'ZDATE1'                                                 AR994776
     C                   PARM                    DATEA                                      AR994776
     C                   PARM                    ZDAYNO                                     AR994776
     C                   PARM                    BJDFIN                                     AR994776
     C                   PARM                    ErrorFlag                                  AR994776
     C                   Z-ADD     ZDAYNO        VFPEND                                     AR994776
      *                                                                                     AR994776
      ** Payment On                                                                         AR994776
      *                                                                                     AR994776
     C                   MOVE      DDEPON        VFPYON                                     AR994776
      *                                                                                     AR994776
      ** Advance / Confirmed Indicator                                                      AR994776
      *                                                                                     AR994776
     C                   MOVE      DDEADV        VFAUTO                                     AR994776
      *                                                                                     AR994776
      ** Calculation Type                                                                   AR994776
      *                                                                                     AR994776
     C                   MOVE      DDCALT        VFCALT                                     AR994776
      *                                                                                     AR994776
      ** Rate 1                                                                             AR994776
      *                                                                                     AR994776
     C     DDRTE1        IFNE      *BLANKS                                                  AR994776
     C                   MOVE      *BLANKS       ZFIELD                                     AR994776
     C                   MOVE      DDRTE1        ZFIELD                                     AR994776
     C                   Z-ADD     2             ZADIG             2 0                      AR994776
     C                   Z-ADD     5             ZADEC                                      AR994776
     C                   MOVE      '0'           *IN99                                      AR994776
     C                   EXSR      ZALIGN                                                   AR994776
     C                   MOVE      ZFIELD        WA13                                       AR994776
     C     WA13          DIV       100000        WFRT1                                      AR994776
     C                   MOVE      WFRT1         VFFRT1                                     AR994776
     C                   ELSE                                                               AR994776
     C                   MOVE      *BLANKS       VFFRT1                                     AR994776
     C                   ENDIF                                                              AR994776
      *                                                                                     AR994776
      ** Rate 2                                                                             AR994776
      *                                                                                     AR994776
     C     DDRTE2        IFNE      *BLANKS                                                  AR994776
     C                   MOVE      *BLANKS       ZFIELD                                     AR994776
     C                   MOVE      DDRTE2        ZFIELD                                     AR994776
     C                   Z-ADD     2             ZADIG             2 0                      AR994776
     C                   Z-ADD     5             ZADEC                                      AR994776
     C                   MOVE      '0'           *IN99                                      AR994776
     C                   EXSR      ZALIGN                                                   AR994776
     C                   MOVE      ZFIELD        WA13                                       AR994776
     C     WA13          DIV       100000        WFRT2                                      AR994776
     C                   MOVE      WFRT2         VFFRT2                                     AR994776
     C                   ELSE                                                               AR994776
     C                   MOVE      *BLANKS       VFFRT2                                     AR994776
     C                   ENDIF                                                              AR994776
      *                                                                                     AR994776
      ** Rate 3                                                                             AR994776
      *                                                                                     AR994776
     C     DDRTE3        IFNE      *BLANKS                                                  AR994776
     C                   MOVE      *BLANKS       ZFIELD                                     AR994776
     C                   MOVE      DDRTE3        ZFIELD                                     AR994776
     C                   Z-ADD     2             ZADIG             2 0                      AR994776
     C                   Z-ADD     5             ZADEC                                      AR994776
     C                   MOVE      '0'           *IN99                                      AR994776
     C                   EXSR      ZALIGN                                                   AR994776
     C                   MOVE      ZFIELD        WA13                                       AR994776
     C     WA13          DIV       100000        WFRT3                                      AR994776
     C                   MOVE      WFRT3         VFFRT3                                     AR994776
     C                   ELSE                                                               AR994776
     C                   MOVE      *BLANKS       VFFRT3                                     AR994776
     C                   ENDIF                                                              AR994776
      *                                                                                     AR994776
      ** Rate 4                                                                             AR994776
      *                                                                                     AR994776
     C     DDRTE4        IFNE      *BLANKS                                                  AR994776
     C                   MOVE      *BLANKS       ZFIELD                                     AR994776
     C                   MOVE      DDRTE4        ZFIELD                                     AR994776
     C                   Z-ADD     2             ZADIG             2 0                      AR994776
     C                   Z-ADD     5             ZADEC                                      AR994776
     C                   MOVE      '0'           *IN99                                      AR994776
     C                   EXSR      ZALIGN                                                   AR994776
     C                   MOVE      ZFIELD        WA13                                       AR994776
     C     WA13          DIV       100000        WFRT4                                      AR994776
     C                   MOVE      WFRT4         VFFRT4                                     AR994776
     C                   ELSE                                                               AR994776
     C                   MOVE      *BLANKS       VFFRT4                                     AR994776
     C                   ENDIF                                                              AR994776
      *                                                                                     AR994776
      ** Rate 5                                                                             AR994776
      *                                                                                     AR994776
     C     DDRTE5        IFNE      *BLANKS                                                  AR994776
     C                   MOVE      *BLANKS       ZFIELD                                     AR994776
     C                   MOVE      DDRTE5        ZFIELD                                     AR994776
     C                   Z-ADD     2             ZADIG             2 0                      AR994776
     C                   Z-ADD     5             ZADEC                                      AR994776
     C                   MOVE      '0'           *IN99                                      AR994776
     C                   EXSR      ZALIGN                                                   AR994776
     C                   MOVE      ZFIELD        WA13                                       AR994776
     C     WA13          DIV       100000        WFRT5                                      AR994776
     C                   MOVE      WFRT5         VFFRT5                                     AR994776
     C                   ELSE                                                               AR994776
     C                   MOVE      *BLANKS       VFFRT5                                     AR994776
     C                   ENDIF                                                              AR994776
      *                                                                                     AR994776
      ** Amounts 1-5                                                                        AR994776
      **********                                                                   AR994776 MD004904
     C**********         MOVE      DDFAMT1       VFAMT1                            AR994776 MD004904
     C**********         MOVE      DDFAMT2       VFAMT2                            AR994776 MD004904
     C**********         MOVE      DDFAMT3       VFAMT3                            AR994776 MD004904
     C**********         MOVE      DDFAMT4       VFAMT4                            AR994776 MD004904
     C**********         MOVE      DDFAMT5       VFAMT5                            AR994776 MD004904
      *                                                                                     MD004904
     C     DDPIND        IFEQ      'A'                                                      MD004904
     C                   Z-ADD     11            ZADIG                                      MD004904
     C                   Z-ADD     0             ZADEC                                      MD004904
     C                   ELSE                                                               MD004904
     C                   Z-ADD     3             ZADIG                                      MD004904
     C                   Z-ADD     3             ZADEC                                      MD004904
     C                   ENDIF                                                              MD004904
      *                                                                                     MD004904
      ** Amount 1                                                                           MD004904
      *                                                                                     MD004904
     C     DDFAMT1       IFNE      *BLANKS                                                  MD004904
     C                   MOVE      *BLANKS       ZFIELD                                     MD004904
     C                   MOVEL     DDFAMT1       ZFIELD                                     MD004904
     C                   MOVE      '0'           *IN99                                      MD004904
     C                   EXSR      ZALIGN                                                   MD004904
     C                   MOVE      ZFIELD        WA13                                       MD004904
     C                   Z-ADD     WA13          WCAMT1                                     MD004904
     C                   MOVE      WCAMT1        VFAMT1                                     MD004904
     C                   ENDIF                                                              MD004904
      *                                                                                     MD004904
      ** Amount 2                                                                           MD004904
      *                                                                                     MD004904
     C     DDFAMT2       IFNE      *BLANKS                                                  MD004904
     C                   MOVE      *BLANKS       ZFIELD                                     MD004904
     C                   MOVEL     DDFAMT2       ZFIELD                                     MD004904
     C                   MOVE      '0'           *IN99                                      MD004904
     C                   EXSR      ZALIGN                                                   MD004904
     C                   MOVE      ZFIELD        WA13                                       MD004904
     C                   Z-ADD     WA13          WCAMT2                                     MD004904
     C                   MOVE      WCAMT2        VFAMT2                                     MD004904
     C                   ENDIF                                                              MD004904
      *                                                                                     MD004904
      ** Amount 3                                                                           MD004904
      *                                                                                     MD004904
     C     DDFAMT3       IFNE      *BLANKS                                                  MD004904
     C                   MOVE      *BLANKS       ZFIELD                                     MD004904
     C                   MOVEL     DDFAMT3       ZFIELD                                     MD004904
     C                   MOVE      '0'           *IN99                                      MD004904
     C                   EXSR      ZALIGN                                                   MD004904
     C                   MOVE      ZFIELD        WA13                                       MD004904
     C                   Z-ADD     WA13          WCAMT3                                     MD004904
     C                   MOVE      WCAMT3        VFAMT3                                     MD004904
     C                   ENDIF                                                              MD004904
      *                                                                                     MD004904
      ** Amount 4                                                                           MD004904
      *                                                                                     MD004904
     C     DDFAMT4       IFNE      *BLANKS                                                  MD004904
     C                   MOVE      *BLANKS       ZFIELD                                     MD004904
     C                   MOVEL     DDFAMT4       ZFIELD                                     MD004904
     C                   MOVE      '0'           *IN99                                      MD004904
     C                   EXSR      ZALIGN                                                   MD004904
     C                   MOVE      ZFIELD        WA13                                       MD004904
     C                   Z-ADD     WA13          WCAMT4                                     MD004904
     C                   MOVE      WCAMT4        VFAMT4                                     MD004904
     C                   ENDIF                                                              MD004904
      *                                                                                     MD004904
      ** Amount 5                                                                           MD004904
      *                                                                                     MD004904
     C     DDFAMT5       IFNE      *BLANKS                                                  MD004904
     C                   MOVE      *BLANKS       ZFIELD                                     MD004904
     C                   MOVEL     DDFAMT5       ZFIELD                                     MD004904
     C                   MOVE      '0'           *IN99                                      MD004904
     C                   EXSR      ZALIGN                                                   MD004904
     C                   MOVE      ZFIELD        WA13                                       MD004904
     C                   Z-ADD     WA13          WCAMT5                                     MD004904
     C                   MOVE      WCAMT5        VFAMT5                                     MD004904
     C                   ENDIF                                                              MD004904
      *                                                                                     AR994776
      ** Calculation Basis                                                                  AR994776
      *                                                                                     AR994776
     C                   MOVE      DDCALC        VFCALC                                     AR994776
      *                                                                                     MD004904
     C     DDEXRT        IFNE      *BLANKS                                                  MD004904
     C                   MOVE      *BLANKS       ZFIELD                                     MD004904
     C                   MOVE      DDEXRT        ZFIELD                                     MD004904
     C                   Z-ADD     5             ZADIG             2 0                      MD004904
     C                   Z-ADD     8             ZADEC                                      MD004904
     C                   EXSR      ZALIGN                                                   MD004904
     C                   MOVE      ZFIELD        WA13                                       MD004904
     C     WA13          DIV       100000000     WERAT                                      MD004904
     C                   MOVE      WERAT         VFERAT                                     MD004904
     C                   ELSE                                                               MD004904
     C                   MOVE      *BLANKS       VFERAT                                     MD004904
     C                   ENDIF                                                              MD004904
      **********                                                                   AR994776 MD004904
      ***Exchange Rate                                                             AR994776 MD004904
      **********                                                                   AR994776 MD004904
     C**********         CALL      'AOCURRR0'                                      AR994776 MD004904
     C**********         PARM      *BLANK        PRTCD                             AR994776 MD004904
     C**********         PARM      '*KEY   '     POPTN                             AR994776 MD004904
     C**********         PARM      DDECUR        PCURR                             AR994776 MD004904
     C*****SDCURR        PARM      SDCURR        DSSDY                             AR994776 MD004904
      **********                                                                   AR994776 MD004904
     C**********         MOVE      A6MDIN        ZMDI1                             AR994776 MD004904
     C**********         Z-ADD     A6SPRT        ZRATE1                            AR994776 MD004904
     C**********         EXSR      ZXRATE                                          AR994776 MD004904
     C**********         Z-ADD     ZRATEX        VFERAT                            AR994776 MD004904
      *                                                                                     AR994776
      ** Multiplication / Division Ind                                                      AR994776
      *                                                                                     AR994776
     C                   MOVE      DDMDIN        VFMDIN                                     AR994776
      *                                                                                     AR994776
      ** Next Payment Date                                                                  AR994776
      *                                                                                     AR994776
     C                   MOVE      DDNPYD        DATEA                                      AR994776
     C                   TESTN                   DATEA                9798                  AR994776
     C                   CALLB     'ZDATE1'                                                 AR994776
     C                   PARM                    DATEA                                      AR994776
     C                   PARM                    ZDAYNO                                     AR994776
     C                   PARM                    BJDFIN                                     AR994776
     C                   PARM                    ErrorFlag                                  AR994776
     C                   Z-ADD     ZDAYNO        VFNPYD                                     AR994776
      *                                                                                     AR994776
      ** Frequency                                                                          AR994776
      *                                                                                     AR994776
     C                   MOVE      DDFREQ        VFFREQ                                     AR994776
      *                                                                                     AR994776
      ** Day                                                                                AR994776
      *                                                                                     AR994776
     C                   MOVE      DDDYIM        VFDYIM                                     AR994776
      *                                                                                     AR994776
      ** Last Change Status                                                                 AR994776
      *                                                                                     AR994776
     C                   MOVE      'A'           VFFSTS                                     AR994776
     C                   ENDSR                                                              AR994776
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
      ** Transaction Details
     C                   PARM                    TranInPrim
      ** Customer Primary Details - Settlement instructions
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFraSttmt
      ** Current Fee file
     C                   PARM                    CrFeFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      ** Loan CL file format
     C                   PARM                    ClilFilFmt
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
      * Expiry date
     C                   PARM                    WWDTEX            5 0
      * Facility amount
     C                   PARM                    WWFAMT           13 0
      * CLE006
     C                   PARM                    CLE006            1
      * CEU004
     C                   PARM                    CEU004            1
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F3PCOB            3
     C                   PARM                    F3TNRF           15
     C                   PARM                    F3IUSR           10
     C                   PARM                    F3XUSR           10
     C                   PARM                    F3AUSR           10
     C                   PARM                    F3TRDS            8
      * Customer Extra Data file data
     C                   PARM                    ExtData         500

      * OUTPUTS

      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C**********         PARM                    Idx                                          CAP084
     C                   PARM                    IdxNew                                       CAP084
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C**********         PARM                    WId                                          CAP084
     C                   PARM                    WIdNew                                       CAP084
      * Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidFeem
      *
      ** Reject Action Flag                                                                 MD052696
     C                   PARM                    DRejFlg           1                        MD052696
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
     C                   MOVEL     'LEFEEMVAL'   DBPGM
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
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN96                          MMDDYY
     C                   ENDIF
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
      *                                                                                       CLE054
      **  Access SAR Details File To See if Customer Lending Fees                             CLE054
      **  Default Auto-settle Indicator is installed                                          CLE054
      *                                                                                       CLE054
     C                   CALL      'AOSARDR0'                                                 CLE054
     C                   PARM      '       '     PRtcd                                        CLE054
     C                   PARM      '*VERIFY'     POptn                                        CLE054
     C                   PARM      'CLE054'      PSard                                        CLE054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE054
      *                                                                                       CLE054
     C                   IF        PRtcd = *BLANK                                             CLE054
     C                   EVAL      CLE054 = 'Y'                                               CLE054
     C                   ELSE                                                                 CLE054
     C                   EVAL      CLE054 = 'N'                                               CLE054
     C                   ENDIF                                                                CLE054
                                                                                              CLE134
      ** Access SAR Details File To See if Customer Lending Fees                              CLE134
      ** Past Due Call Loan Processing is installed                                           CLE134
                                                                                              CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRtcd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSard                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        PRtcd       = *BLANK                                       CLE134
     C                   EVAL      CLE134      = 'Y'                                          CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134      = 'N'                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      DSBCN(1)    = BPCLN1                                       CLE134
     C                   EVAL      DSBCN(2)    = BPCLN2                                       CLE134
     C                   EVAL      DSBCN(3)    = BPCLN3                                       CLE134
     C                   EVAL      DSBCN(4)    = BPCLN4                                       CLE134
     C                   EVAL      DSBCN(5)    = BPCLN5                                       CLE134
     C                   EVAL      DSBCN(6)    = BPCLN6                                       CLE134
     C                   EVAL      DSBCN(7)    = BPCLN7                                       CLE134
     C                   EVAL      DSBCN(8)    = BPCLN8                                       CLE134
     C                   EVAL      DSBCN(9)    = BPCLN9                                       CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSBCN(#A)   = 0                                            CLE134
     C                   EVAL      DSBCN(#A)   = 9999                                         CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSBCD(1)    = BPCLD1                                       CLE134
     C                   EVAL      DSBCD(2)    = BPCLD2                                       CLE134
     C                   EVAL      DSBCD(3)    = BPCLD3                                       CLE134
     C                   EVAL      DSBCD(4)    = BPCLD4                                       CLE134
     C                   EVAL      DSBCD(5)    = BPCLD5                                       CLE134
     C                   EVAL      DSBCD(6)    = BPCLD6                                       CLE134
     C                   EVAL      DSBCD(7)    = BPCLD7                                       CLE134
     C                   EVAL      DSBCD(8)    = BPCLD8                                       CLE134
     C                   EVAL      DSBCD(9)    = BPCLD9                                       CLE134
                                                                                              CLE134
     C                   EVAL      DSRCN(1)    = BPRCN1                                       CLE134
     C                   EVAL      DSRCN(2)    = BPRCN2                                       CLE134
     C                   EVAL      DSRCN(3)    = BPRCN3                                       CLE134
     C                   EVAL      DSRCN(4)    = BPRCN4                                       CLE134
     C                   EVAL      DSRCN(5)    = BPRCN5                                       CLE134
     C                   EVAL      DSRCN(6)    = BPRCN6                                       CLE134
     C                   EVAL      DSRCN(7)    = BPRCN7                                       CLE134
     C                   EVAL      DSRCN(8)    = BPRCN8                                       CLE134
     C                   EVAL      DSRCN(9)    = BPRCN9                                       CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSRCN(#A)   = 0                                            CLE134
     C                   EVAL      DSRCN(#A)   = 9999                                         CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSRCD(1)    = BPRCD1                                       CLE134
     C                   EVAL      DSRCD(2)    = BPRCD2                                       CLE134
     C                   EVAL      DSRCD(3)    = BPRCD3                                       CLE134
     C                   EVAL      DSRCD(4)    = BPRCD4                                       CLE134
     C                   EVAL      DSRCD(5)    = BPRCD5                                       CLE134
     C                   EVAL      DSRCD(6)    = BPRCD6                                       CLE134
     C                   EVAL      DSRCD(7)    = BPRCD7                                       CLE134
     C                   EVAL      DSRCD(8)    = BPRCD8                                       CLE134
     C                   EVAL      DSRCD(9)    = BPRCD9                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE106
      ** Access switchable feature Syndications Manager                                       CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       PRtcd                                        CLE106
     C                   PARM      '*VERIFY'     POptn                                        CLE106
     C                   PARM      'CLE106'      PSard                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        PRtcd = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   END                                                                  CLE106
                                                                                              CLE031
      ** Access switchable feature Syndications Manager                                       CLE031
                                                                                              CLE031
     C                   EVAL      CLE031 = 'N'                                               CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *Blanks       PRtcd                                        CLE031
     C                   PARM      '*VERIFY'     POptn                                        CLE031
     C                   PARM      'CLE031'      PSard                                        CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
                                                                                              CLE031
     C                   IF        PRtcd = *Blanks                                            CLE031
     C                   EVAL      CLE031 = 'Y'                                               CLE031
     C                   END                                                                  CLE031
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
                                                                                              CAS011
      **  Access SAR details to see if CAS009 is switched on.                                 CAS011
                                                                                              CAS011
     C                   CALL      'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRtCd                                        CAS011
     C                   PARM      '*VERIFY'     POptn                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRtCd = *BLANKS                                            CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
                                                                                              CAS011
      ** Database error                                                                       CAS011
                                                                                              CAS011
     C                   IF        PRtCd <> '*NRF'                                            CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBase = 911                                                CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      SRERR                                                      CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
      ** Access EIR Recalculation Switcheable Feature                                         CAS019
                                                                                              CAS019
     C                   EVAL      CAS016 = 'N'                                               CAS019
     C                   CALLB     'AOSARDR0'                                                 CAS019
     C                   PARM      *Blanks       PRtcd                                        CAS019
     C                   PARM      '*VERIFY'     POptn                                        CAS019
     C                   PARM      'CAS016'      PSard                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
                                                                                              CAS019
     C                   IF        PRtcd = *Blanks                                            CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   END                                                                  CAS019
                                                                                              CLE071
      ** Access switchable feature for Value dating of                                        CLE071
      ** Rate changes to Fees                                                                 CLE071
                                                                                              CLE071
     C                   EVAL      CLE071 = 'N'                                               CLE071
     C                   CALLB     'AOSARDR0'                                                 CLE071
     C                   PARM      *BLANKS       PRTCD                                        CLE071
     C                   PARM      '*VERIFY'     POPTN                                        CLE071
     C                   PARM      'CLE071'      PSARD                                        CLE071
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE071
                                                                                              CLE071
     C                   IF        PRTCD = *Blanks                                            CLE071
     C                   EVAL      CLE071 = 'Y'                                               CLE071
     C                   ENDIF                                                                CLE071
                                                                                              CLE073
      ** Check if CLE083 - Calculation of loan based fees is installed                        CLE073
                                                                                              CLE073
     C                   CALL      'AOSARDR0'                                                 CLE073
     C                   PARM      *BLANKS       @RTCD                                        CLE073
     C                   PARM      '*KEY    '    @OPTN                                        CLE073
     C                   PARM      'CLE073'      @SARD             6                          CLE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
                                                                                              CLE073
     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
     C                   MOVEL     'Y'           CLE073                                       CLE073
     C                   ELSE                                                                 CLE073
     C                   MOVEL     'N'           CLE073            1                          CLE073
     C                   ENDIF                                                                CLE073
     C/COPY WNCPYSRC,LEH00505
                                                                                              CLE141
      ** Check if CLE141 - Business day Convention is on                                      CLE141
                                                                                              CLE141
     C                   CALL      'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       @RTCD                                        CLE141
     C                   PARM      '*KEY   '     @OPTN                                        CLE141
     C                   PARM      'CLE141'      @SARD                                        CLE141
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE141
                                                                                              CLE141
     C     @RTCD         IFEQ      *BLANKS                                                    CLE141
     C                   MOVEL     'Y'           CLE141                                       CLE141
     C                   ELSE                                                                 CLE141
     C                   MOVEL     'N'           CLE141                                       CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE073
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

     C                   MOVE      *OFF          *IN77                               ???forcompil???
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
      ** Key definition
      ** ==============
      *
     C     FEADKY        KLIST
     C                   KFLD                    @@FEBRCA
     C                   KFLD                    @@FECNUM
     C                   KFLD                    @@FEFACL
     C                   KFLD                    @@FELOAN
     C                   KFLD                    @@FEFSEQ
      *                                                                                       CLE071
     C     FCADKY        KLIST                                                                CLE071
     C                   KFLD                    FCBRCA                                       CLE071
     C                   KFLD                    FCCNUM                                       CLE071
     C                   KFLD                    FCFACL                                       CLE071
     C                   KFLD                    FCLOAN                                       CLE071
     C                   KFLD                    FCFSEQ                                       CLE071
                                                                                              CLE134
     C     KCLOANL4      KLIST                                                                CLE134
     C                   KFLD                    Kpd_RECI                                     CLE134
     C                   KFLD                    Kpd_LNRF                                     CLE134
                                                                                              CLE134
     C     KLEFEEDL0     KLIST                                                                CLE134
     C                   KFLD                    Kpd_FECNUM                                   CLE134
     C                   KFLD                    Kpd_FEFACL                                   CLE134
     C                   KFLD                    Kpd_FELOAN                                   CLE134
     C                   KFLD                    Kpd_FEFSEQ                                   CLE134
                                                                                              CLE134
     C     KLEPDUEL2     KLIST                                                                CLE134
     C                   KFLD                    Kpd_YPORG                                    CLE134
                                                                                              CLE134
     C     KLEPDUFL4     KLIST                                                                CLE134
     C                   KFLD                    Kpd_YPORG                                    CLE134
                                                                                              CLE134
     C******LIKE         DEFINE    pd_FECNUM     Wpd_FCNM                            AR314017 CLE164
     C******LIKE         DEFINE    pd_FELOAN     Wpd_FLNR                            AR314017 CLE164
     C******LIKE         DEFINE    pd_FEFACL     Wpd_FACT                            AR314017 CLE164
     C******LIKE         DEFINE    pd_FEFSEQ     Wpd_FSE1                            AR314017 CLE164
     C******LIKE         DEFINE    pd_FEFCOD     Wpd_FCOD                            AR314017 CLE164
     C******LIKE         DEFINE    pd_FEBRCA     Wpd_FCBR                            AR314017 CLE164
     C******LIKE         DEFINE    pd_FEFCCY     Wpd_ACCY                            AR314017 CLE164
                                                                                            AR314017
     C*****KLEACCNL1     KLIST                                                       AR314017 CLE164
     C**********         KFLD                    Wpd_FCNM                            AR314017 CLE164
     C**********         KFLD                    Wpd_FLNR                            AR314017 CLE164
     C**********         KFLD                    Wpd_FACT                            AR314017 CLE164
     C**********         KFLD                    Wpd_FSE1                            AR314017 CLE164
     C**********         KFLD                    Wpd_FCOD                            AR314017 CLE164
     C**********         KFLD                    Wpd_FCBR                            AR314017 CLE164
     C**********         KFLD                    Wpd_ACCY                            AR314017 CLE164
      *                                                                                     MD046370
     C     KEYHST        KLIST                                                              MD046370
     C                   KFLD                    CL_BRCA                                    MD046370
     C                   KFLD                    CL_CNUM                                    MD046370
     C                   KFLD                    DDLNRF                                     MD046370
     C                   KFLD                    WVDAT                                      MD046370
     C                   KFLD                    WLASN                                      MD046370
      *                                                                                     MD046370
     C     KEYPHS        KLIST                                                              MD046370
     C                   KFLD                    CL_BRCA                                    MD046370
     C                   KFLD                    CL_CNUM                                    MD046370
     C                   KFLD                    DDLNRF                                     MD046370
      *                                                                                       242377
      ** Check System Value: Use Original Borrower or Purchased From?                         242377
      ** Set up parameter so access object checks LoanCustOriginPurch                         242377
     C                   MOVE      *BLANKS       WPARM                                        242377
     C                   MOVEL     'LoanC'       WPARM1                                       242377
     C                   MOVEL     'ustOr'       WPARM2                                       242377
     C                   MOVEL     'iginP'       WPARM3                                       242377
     C                   MOVEL     'urch'        WPARM4                                       242377
     C                   MOVEL     WPARM         SVALK1                                       242377
      *                                                                                     MD046370
     C                   EVAL      SVALK2 = 'AutoEndCalcLoanFee'                            MD046370
      *                                                                                       242377
      * Call Access object:                                                                   242377
     C                   CALL      'AOSVALR0'                                                 242377
     C                   PARM                    RTNCDE            7                          242377
     C                   PARM                    SVALK1           20                          242377
     C                   PARM                    SVAL1           200                          242377
     C                   PARM                    SVALK2           20                          242377
     C                   PARM                    SVAL2           200                          242377
     C                   PARM                    SVALK3           20                          242377
     C                   PARM                    SVAL3           200                          242377
     C                   PARM                    SVALK4           20                          242377
     C                   PARM                    SVAL4           200                          242377
     C                   PARM                    SVALK5           20                          242377
     C                   PARM                    SVAL5           200                          242377
     C                   PARM                    SVALK6           20                          242377
     C                   PARM                    SVAL6           200                          242377
     C                   PARM                    SVALK7           20                          242377
     C                   PARM                    SVAL7           200                          242377
     C                   PARM                    SVALK8           20                          242377
     C                   PARM                    SVAL8           200                          242377
     C                   PARM                    SVALK9           20                          242377
     C                   PARM                    SVAL9           200                          242377
     C                   PARM                    SVALK0           20                          242377
     C                   PARM                    SVAL10          200                          242377
      *                                                                                       242377
      * If the system value is not found then issue a database error                          242377
     C     RTNCDE        IFNE      '        '                                                 242377
     C                   MOVEL     'SDSVALPD'    DBFILE                         ************* 242377
     C                   MOVEL     '901'         DBASE                          * DBERR 901 * 242377
     C                   MOVEL     '*FIRST  '    DBKEY                          ************* 242377
     C                   EXSR      *PSSR                                                      242377
     C                   ELSE                                                                 242377
      *                                                                                       242377
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              242377
     C                   MOVEL     SVAL1         WRK01             1                          242377
     C     WRK01         IFEQ      'O'                                                        242377
     C                   MOVE      'O'           PPCUST            1                          242377
     C                   ELSE                                                                 242377
     C                   MOVE      'P'           PPCUST                                       242377
     C                   ENDIF                                                                242377
      *                                                                                     MD046370
     C                   MOVEL     SVAL2         AutoEndFee        1                        MD046370
      *                                                                                     MD046370
     C                   ENDIF                                                                242377
      *
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
     C                   Z-ADD     *ZEROS        Idx                                          CAP084
     C                   Z-ADD     *ZEROS        WId                                          CAP084
      ** Initialize OK flags, field name array and index array                              BUG11390
     C                   Eval      OKFee = *ALL'Y'                                          BUG11390
     C**********         Eval      FldNameArr = *Blanks                              BUG11390 242784
     C**********         Eval      IdxNew = 0                                        BUG11390 242784
     C**********         Eval      WidNew = 0                                        BUG11390 242784

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
     C*****I****         SUB       1             Idx                                          CAP084
     C     I             SUB       1             IdxNew                                       CAP084
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
     C*****I****         SUB       1             WId                                          CAP084
     C     I             SUB       1             WIdNew                                       CAP084
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZXRATE        BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM      *ZEROS        ZRATEX           13 8
     C                   PARM      *BLANKS       ZMDIX             1
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS011
      * SRNxtP  -  Set EIR Indicators to re-calculate                 *                       CAS011
      *****************************************************************                       CAS011
     C     SRnxtP        BEGSR                                                                CAS011
                                                                                              CAS011
      ** Next Payment Date                                                                    CAS011
      ** If date not entered and payment on *EQ to N                                          CAS011
                                                                                              CAS011
     C                   IF        DDNPYD = *BLANKS AND DDEPON = 'N'                          CAS011
     C                   EVAL      DDNPYDOK = 'N'                                             CAS011
     C                   EVAL      Idx = Idx + 1                                              CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDNPYD'                                  CAS011
     C                   EVAL      MsgIDXAr(Idx) = 'LER0060'                                  CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        DDCALT = *BLANKS AND DDNPYD <> *BLANKS                     CAS011
     c                             AND DDFREQ <> *BLANK AND DDDYIM <> *BLANKS                 CAS011
     C                             AND DDEPON <> 'N'                                          CAS011
     C                   IF        DDNPYD <> *BLANKS                                          CAS011
     C                   EVAL      DDNPYDOK = 'N'                                             CAS011
     C                   EVAL      Idx = Idx + 1                                              CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDNPYD'                                  CAS011
     C                   ENDIF                                                                CAS011
     C                   IF        DDFREQ <> *BLANKS                                          CAS011
     C                   EVAL      DDFREQOK = 'N'                                             CAS011
     C                   EVAL      Idx = Idx + 1                                              CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDFREQ'                                  CAS011
     C                   ENDIF                                                                CAS011
     C                   IF        DDDYIM <> *BLANKS                                          CAS011
     C                   EVAL      DDDYIMOK = 'N'                                             CAS011
     C                   EVAL      Idx = Idx + 1                                              CAS011
     C                   EVAL      FldNamXAr(Idx) = 'DDDYIM'                                  CAS011
     C                   ENDIF                                                                CAS011
     C                   EVAL      MsgIDXAr(Idx) = 'LEV1074'                                  CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        DDNPYD <> *BLANKS                                          CAS011
     C                   MOVE      DDNPYD        DATEA                                        CAS011
     C                   TESTN                   DATEA                9798                    CAS011
     C                   CALLB     'ZDATE1'                                                   CAS011
     C                   PARM                    DATEA                                        CAS011
     C                   PARM                    ZDAYNO                                       CAS011
     C                   PARM                    BJDFIN                                       CAS011
     C                   PARM                    ErrorFlag                                    CAS011
                                                                                              CAS011
      **   - invalid format or not numeric                                                    CAS011
                                                                                              CAS011
     C                   IF        ErrorFlag = 'Y' OR (*IN97 = *OFF                           CAS011
     C                             AND *IN98 = *OFF)                                          CAS011
     C                   Move      'N'           DDNPYDOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0061'     MsgIDXAr(Idx)                                CAS011
     C                   ELSE                                                                 CAS011
     C                   Z-ADD     ZDAYNO        WNPYD                                        CAS011
                                                                                              CAS011
      ** If date entered and  LT last payment date then error                                 CAS011
                                                                                              CAS011
     C                   IF        DDACTN = 'A' AND WNPYD < @@FELPDT                          CAS011
     C                                                                                        CAS011
     C                   Move      'N'           DDNPYDOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0062'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** If date entered and payment on *NE to N                                              CAS011
                                                                                              CAS011
     C                   IF        DDEPON <> 'N'                                              CAS011
     C                   Move      'N'           DDNPYDOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0060'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        WPSTD >= WNPYD                                             CAS011
     C                   Move      'N'           DDNPYDOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0061'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        WPEND < WNPYD                                              CAS011
     C                   Move      'N'           DDNPYDOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDNPYD'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0099'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'           AND                            CLE134
     C                             DDCALT      = '90'          AND                            CLE134
     C                             DSPDSts     = '*LIVE'       AND                            CLE134
     C                             pd_VDAT    <> WNPYD                                        CLE134
     C                   EVAL      DDNPYDOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDNPYD'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045568'                                 CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CAS011
     C                   IF        DDACTN = 'X'                                               CAS011
                                                                                              CAS011
      ** Do extra validations                                                                 CAS011
                                                                                              CAS011
      ** If settlement is next payment date and method is either 01 07                        CAS011
      ** or 08, then check date for a holiday in both local and fee ccy.                      CAS011
                                                                                              CAS011
     C                   IF        DDNPYDOK = 'Y'                                             CAS011
     C                   IF        DDEPON = 'N'                                               CAS011
     C                   Z-ADD     WNPYD         ZDAYNO                                       CAS011
                                                                                              CAS011
     C                   IF        @@FESTTL = 01 OR @@FESTTL = 07                             CAS011
     C                             OR @@FESTTL = 08                                           CAS011
                                                                                              CAS011
     C*****CLE141        IFEQ      'N'                                                CLE141 CLE141A
     C*****DDLNRF        OREQ      *blanks                                            CLE141 CLE141A

     C                   MOVE      DDECUR        ZCCY                                         CAS011
                                                                                              CAS011
     C                   CALLB     'ZCHKH'                                                    CAS011
     C                   PARM                    ZDAYNO                                       CAS011
     C                   PARM                    ZCCY                                         CAS011
     C                   PARM                    BJSLCD                                       CAS011
     C                   PARM                    HolidayInd                                   CAS011
                                                                                              CAS011
      **  If HolidayInd = 'H' then the date is a holiday.                                     CAS011
                                                                                              CAS011
     C                   IF        HolidayInd = 'H'                                           CAS011
     C                   MOVE      'W'           DDNPYDOK                                     CAS011
     C                   ADD       1             WId                                          CAS011
     C                   MOVEL     'DDNPYD'      WFldNmXAr(WId)                               CAS011
     C                   MOVEL     'LER0229'     WMsgIdXAr(WId)                               CAS011
     C                   ENDIF                                                                CAS011

     C**********         ENDIF                                                        CLE141 CLE141A

     C                   ELSE                                                                 CAS011
                                                                                              CAS011
      ** Local Ccy check                                                                      CAS011
                                                                                              CAS011
     C                   MOVE      BJLCCY        ZCCY                                         CAS011
                                                                                              CAS011
     C                   CALLB     'ZCHKH'                                                    CAS011
     C                   PARM                    ZDAYNO                                       CAS011
     C                   PARM                    ZCCY                                         CAS011
     C                   PARM                    BJSLCD                                       CAS011
     C                   PARM                    HolidayInd                                   CAS011
                                                                                              CAS011
      **  If HolidayInd = 'H' then the date is a holiday.                                     CAS011
                                                                                              CAS011
     C                   IF        HolidayInd = 'H'                                           CAS011
     C                   MOVE      'W'           DDNPYDOK                                     CAS011
     C                   ADD       1             WId                                          CAS011
     C                   MOVEL     'DDNPYD'      WFldNmXAr(WId)                               CAS011
     C                   MOVEL     'LER0230'     WMsgIdXAr(WId)                               CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                      CLE141A
     C     CLE141        IFEQ      'Y'                                                       CLE141A
     C     DDLNRF        ANDNE     *Blanks                                                   CLE141A
     C     CurLocDS      ANDNE     *Blanks                                                   CLE141A
      *                                                                                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                CLE141A
     C                   PARM      *BLANKS       RetCode                                     CLE141A
     C                   PARM                    CurLocDS                                    CLE141A
     C                   PARM                    ZDAYNO                                      CLE141A
      *                                                                                      CLE141A
     C     RetCode       IFEQ      'HOLIDAY'                                                 CLE141A
     C                   EVAL      DDNPYDOK = 'W'                                            CLE141A
     C                   EVAL      WId = WId + 1                                             CLE141A
     C                   EVAL      WFldNmXAr(WId) = 'DDNPYD'                                 CLE141A
     C**********         EVAL      WMsgIDXAr(WId) = '5048508'                       CLE141A MD039016
     C                   EVAL      WMsgIDXAr(WId) = '5048567'                               MD039016
     C                   ENDIF                                                               CLE141A
      *                                                                                      CLE141A
     C                   ENDIF                                                               CLE141A
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ELSE                                                                 CAS011
     C                   Z-ADD     0             WNPYD                                        CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      **Frequency of Payment                                                                  CAS011
                                                                                              CAS011
     C                   MOVE      *BLANKS       WFREQ                                        CAS011
     C                   IF        DDFREQ <> *BLANKS                                          CAS011
                                                                                              CAS011
     C     CLE134        IFEQ      'Y'                                                     AR1035111
     C     DDCALT        ANDEQ     '90'                                                    AR1035111
      *                                                                                    AR1035111
     C                   IF        DDFREQ      = 'P'                                       AR1035111
     C                   MOVE      DDFREQ        WFREQ                                     AR1035111
     C                   ELSE                                                              AR1035111
     C                   EVAL      DDFREQOK    = 'N'                                       AR1035111
     C                   EVAL      Idx        += 1                                         AR1035111
     C                   EVAL      FldNamXAr(Idx) = 'DDFREQ'                               AR1035111
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5465'                              AR1035111
     C                   ENDIF                                                             AR1035111
     C                   ELSE                                                              AR1035111
     C                   IF        DDFREQ = 'M' OR DDFREQ = 'Q'                               CAS011
     C                             OR DDFREQ = 'X' OR DDFREQ = 'Y'                            CAS011
     C                             OR DDFREQ = 'D' OR DDFREQ = 'W'                            CLE064
     C                             OR DDFREQ = 'F' OR DDFREQ = 'T'                            CLE064
     C                             OR DDFREQ = '4' OR DDFREQ = '5'                            CLE064
     C                             OR DDFREQ = '7' OR DDFREQ = '8'                            CLE064
     C                             OR DDFREQ = '9' OR DDFREQ = 'V'                            CLE064
     C                             OR DDFREQ = 'E' OR DDFREQ = 'C'                            CLE064
     C                             OR DDFREQ = 'I' OR DDFREQ = 'J'                            CLE064
     C                             OR DDFREQ = 'N' OR DDFREQ = 'U'                            CLE064
     C**********                   OR DDFREQ = 'P' AND                              CLE134 AR1035111
     C**********                      CLE134 = 'Y'                                  CLE134 AR1035111
     C                   MOVE      DDFREQ        WFREQ                                        CAS011
     C                   ELSE                                                                 CAS011
     C                   Move      'N'           DDFREQOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C**********         Movel     'LER0064'     MsgIDXAr(Idx)                         CAS011 CLE064
     C                   MOVEL     'LER5611'     MsgIDXAr(Idx)                                CLE064
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                             AR1035111
                                                                                              CAS011
      ** If next payment date is not entered then freq. cannot be                             CAS011
      ** entered                                                                              CAS011
                                                                                              CAS011
     C                   IF        WNPYD = 0 AND DDNPYDOK = 'Y'                               CAS011
     C                   Move      'N'           DDFREQOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0100'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** If next payment date is entered then freq. must be entered                           CAS011
                                                                                              CAS011
     C                   IF        DDFREQ = *BLANK AND DDNPYD <> *BLANK                       CAS011
                                                                                              CAS011
     C                   IF        WNPYD = WPEND OR WNPYD = 0 OR                              CAS011
     C                             (WNPYD > 0 AND DDEPON = 'N' AND                            CAS011
     C                             WPEND > 0)                                                 CAS011
     C                   ELSE                                                                 CAS011
     C                   Move      'N'           DDFREQOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDFREQ'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0141'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** Day in month                                                                         CAS011
                                                                                              CAS011
     C                   Z-ADD     0             WDYIM                                        CAS011
     C                   IF        DDDYIM <> *BLANKS                                          CAS011
                                                                                              CAS011
      ** Frequency must be entered                                                            CAS011
                                                                                              CAS011
     C                   IF        DDFREQ = *BLANKS                                           CAS011
     C                   Move      'N'           DDFREQOK                                     CAS011
     C                   Move      'N'           DDDYIMOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDDYIM'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0065'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** Must be between 1 & 31                                                               CAS011
                                                                                              CAS011
     C                   MOVE      '0'           TEST2                                        CAS011
     C                   MOVEL     DDDYIM        TEST2                                        CAS011
     C                   TESTN                   TEST2                78                      CAS011
     C                   MOVE      DDDYIM        WDYIM                                        CAS011
     C                   IF        *IN78 = *ON AND WDYIM > 0 AND                              CAS011
     C                             WDYIM < 32                                                 CAS011
     C                   ELSE                                                                 CAS011
     C                   Move      'N'           DDDYIMOK                                     CAS011
     C                   Add       1             Idx                                          CAS011
     C                   Movel     'DDDYIM'      FldNamXAr(Idx)                               CAS011
     C                   Movel     'LER0066'     MsgIDXAr(Idx)                                CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** If day in month not entered then default to day of                                   CAS011
      ** next payment                                                                         CAS011
                                                                                              CAS011
     C                   IF        DDDYIM = *BLANKS AND DDNPYDOK = 'Y'                        CAS011
     C                             AND WNPYD <> 0 AND DDFREQ <> *BLANKS                       CAS011
                                                                                              CAS011
     C                   IF        *IN96 = *OFF                                               CAS011
     C                   MOVEL     DDNPYD        WDYIM                                        CAS011
     C                   ELSE                                                                 CAS011
     C                   MOVEL     DDNPYD        WRKRP                                        CAS011
     C                   MOVE      WRKRP         WDYIM                                        CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      **  Ensure next Next Payment Date is not after End Date                                 CAS011
                                                                                              CAS011
     C                   IF        WDYIM > 0 AND WNPYD <> *ZEROS                              CAS011
     C                             AND WPEND <> *ZEROS AND WFREQ <> *BLANKS                   CAS011
     C                             AND DDECUR <> *BLANKS                                      CAS011
     C                   MOVE      WNPYD         ZDAYNO                                       CAS011
     C                   MOVE      WFREQ         ZFREQ                                        CAS011
     C                   MOVE      WDYIM         ZMDAY                                        CAS011
     C                   MOVE      DDECUR        ZCCY                                         CAS011
     C                   CALLB     'ZFREQB'                                                   CAS011
     C                   PARM      *BLANKS       @RTCD                                        CAS011
     C                   PARM                    ZFREQ                                        CAS011
     C                   PARM                    ZDAYNO                                       CAS011
     C                   PARM                    ZCCY                                         CAS011
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C**********         PARM      *ZERO         ZMDAY                               CAS011 MD022414
     C                   PARM                    ZMDAY                                      MD022414
     C                   PARM                    BJDFIN                                       CAS011
     C                   PARM      SDGELR        SDGELR                                       CAS011
                                                                                              CAS011
     C                   IF        ZDAYNO > WPEND                                             CAS011
     C**********         Move      'N'           DDFREQOK                            CAS011 MD022414
     C**********         Move      'N'           DDDYIMOK                            CAS011 MD022414
     C**********         Add       1             Idx                                 CAS011 MD022414
     C**********         Movel     'DDFREQ'      FldNamXAr(Idx)                      CAS011 MD022414
     C**********         Movel     'LER0142'     MsgIDXAr(Idx)                       CAS011 MD022414
     C                   MOVE      'W'           DDFREQOK                                   MD022414
     C                   MOVE      'W'           DDDYIMOK                                   MD022414
     C                   ADD       1             WId                                        MD022414
     C                   MOVEL     'DDFREQ'      WFldNmXAr(WId)                             MD022414
     C                   MOVEL     'LER0142'     WMsgIdXAr(WId)                             MD022414
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       CAS019
      ** VAmSI   - Validate Amortise Over Whole Period Indicator                              CAS019
      *****************************************************************                       CAS019
     C     VAmSI         BEGSR                                                                CAS019
                                                                                              CAS019
      *                                                                                       248566
      ** Validate only loan based fees                                                        248566
      *                                                                                       248566
                                                                                              248566
     C                   IF        DDLNRF = *BLANKS                                           248566
     C                   LeaveSR                                                              248566
     C                   ENDIF                                                                248566
                                                                                              248566
      *                                                                                       CAS019
      ** Check if CAS019 is *ON otherwise do not perform validation                           CAS019
                                                                                              CAS019
     C                   IF        (CAS016 = 'N')                                             CAS019
     C                   LeaveSR                                                              CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
      ** Reset variables updated by each module before each call                              CAS019
      *                                                                                       CAS019
     C                   EXSR      RESETFLDS                                                  CAS019
      *                                                                                       CAS019
     C                   CALLB     'LEVAMRI'                                                  CAS019
     C                   PARM                    ReturnCode                                   CAS019
     C                   PARM                    MSG1                                         CAS019
     C                   PARM                    TranInPrim                                   CAS019
      *                                                                                       CAS019
      ** Information contained in these data structures are needed for validation             CAS019
     C                   PARM                    SDFEE                                        CAS019
     C                   PARM                    SDLOAN                                       CAS019
      *                                                                                       CAS019
     C                   IF        (MSG1 <> *Blanks) AND                                      CAS019
     C                             (ReturnCode = 'Error')                                     CAS019
     C                   EVAL      Idx = Idx + 1                                              CAS019
     C                   EVAL      FldNamXAr(Idx) = 'DDAMRI'                                  CAS019
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CAS019
     C                   ELSE                                                                 CAS019
     C                   IF        (MSG1 <> *Blanks) AND                                      CAS019
     C                             (ReturnCode = 'Warning')                                   CAS019
     C                   EVAL      WId = WId + 1                                              CAS019
     C                   EVAL      WFldNmXAr(WId) = 'DDAMRI'                                  CAS019
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
      ** Use the return code's value to set the field's OK flag                               CAS019
      *                                                                                       CAS019
     C                   CALLB     'ZASETOKFLG'                                               CAS019
     C                   PARM                    DDAMRIOK                                     CAS019
     C                   PARM                    ReturnCode                                   CAS019
     C                   PARM                    WarnGlobal                                   CAS019
                                                                                              CAS019
     C                   ENDSR                                                                CAS019
      *****************************************************************                       CAS019
      ** VAmSD   - Validate Amortisation Start Date                                           CAS019
      *****************************************************************                       CAS019
     C     VAmSD         BEGSR                                                                CAS019
                                                                                              CAS019
      *                                                                                       248566
      ** Validate only loan based fees                                                        248566
      *                                                                                       248566
                                                                                              248566
     C                   IF        DDLNRF = *BLANKS                                           248566
     C                   LeaveSR                                                              248566
     C                   ENDIF                                                                248566
                                                                                              248566
      *                                                                                       CAS019
      ** Check if CAS019 is *ON otherwise do not perform validation                           CAS019
                                                                                              CAS019
     C                   IF        (CAS016 = 'N')                                             CAS019
     C                   LeaveSR                                                              CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
      ** Reset variables updated by each module before each call                              CAS019
      *                                                                                       CAS019
     C                   EXSR      RESETFLDS                                                  CAS019
      *                                                                                       CAS019
     C                   CALLB     'LEVSTPD'                                                  CAS019
     C                   PARM                    ReturnCode                                   CAS019
     C                   PARM                    MSG1                                         CAS019
      ** Field(s) requiring validation                                                        CAS019
     C                   PARM                    TranInPrim                                   CAS019
      *                                                                                       CAS019
      ** Information contained in these data structures are needed for validation             CAS019
     C                   PARM                    SDFEE                                        CAS019
     C                   PARM                    SDLOAN                                       CAS019
     C                   PARM                    SDBANK                                       CAS019
     C                   PARM                    ClilFilFmt                                   CAS019
      *                                                                                       CAS019
      ** Amortisation Start & End Date                                                        CAS019
     C                   PARM                    WAStrDat                                     CAS019
     C                   PARM                    WAEndDat                                     CAS019
      *                                                                                       CAS019
      ** FEE Start & End Date                                                                 CAS019
     C                   PARM                    WPSTD                                        CAS019
     C                   PARM                    WPEND                                        CAS019
      *                                                                                       CAS019
     C                   IF        (MSG1 <> *Blanks) AND                                      CAS019
     C                             (ReturnCode = 'Error')                                     CAS019
     C                   EVAL      Idx = Idx + 1                                              CAS019
     C                   EVAL      FldNamXAr(Idx) = 'DDSTPD'                                  CAS019
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CAS019
     C                   ELSE                                                                 CAS019
     C                   IF        (MSG1 <> *Blanks) AND                                      CAS019
     C                             (ReturnCode = 'Warning')                                   CAS019
     C                   EVAL      WId = WId + 1                                              CAS019
     C                   EVAL      WFldNmXAr(WId) = 'DDSTPD'                                  CAS019
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
      ** Use the return code's value to set the field's OK flag                               CAS019
      *                                                                                       CAS019
     C                   CALLB     'ZASETOKFLG'                                               CAS019
     C                   PARM                    DDSTPDOK                                     CAS019
     C                   PARM                    ReturnCode                                   CAS019
     C                   PARM                    WarnGlobal                                   CAS019
                                                                                              CAS019
                                                                                              CAS019
     C                   ENDSR                                                                CAS019
      *****************************************************************                       CAS019
      ** VAmED   - Validate Amortisation End Date                                             CAS019
      *****************************************************************                       CAS019
     C     VAmED         BEGSR                                                                CAS019
                                                                                              CAS019
      *                                                                                       248566
      ** Validate only loan based fees                                                        248566
      *                                                                                       248566
                                                                                              248566
     C                   IF        DDLNRF = *BLANKS                                           248566
     C                   LeaveSR                                                              248566
     C                   ENDIF                                                                248566
                                                                                              248566
      *                                                                                       CAS019
      ** Check if CAS019 is *ON otherwise do not perform validation                           CAS019
                                                                                              CAS019
     C                   IF        (CAS016 = 'N')                                             CAS019
     C                   LeaveSR                                                              CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
      ** Reset variables updated by each module before each call                              CAS019
      *                                                                                       CAS019
     C                   EXSR      RESETFLDS                                                  CAS019
      *                                                                                       CAS019
     C                   CALLB     'LEVENPD'                                                  CAS019
     C                   PARM                    ReturnCode                                   CAS019
     C                   PARM                    MSG1                                         CAS019
      *                                                                                       CAS019
      ** Field(s) requiring validation                                                        CAS019
     C                   PARM                    TranInPrim                                   CAS019
      *                                                                                       CAS019
      ** Information contained in these data structures are needed for validation             CAS019
     C                   PARM                    SDFEE                                        CAS019
     C                   PARM                    SDLOAN                                       CAS019
     C                   PARM                    SDBANK                                       CAS019
     C                   PARM                    ClilFilFmt                                   CAS019
      *                                                                                       CAS019
      ** Amortisation Start & End Date                                                        CAS019
     C                   PARM                    WAStrDat                                     CAS019
     C                   PARM                    WAEndDat                                     CAS019
      *                                                                                       CAS019
      ** FEE Start & End Date                                                                 CAS019
     C                   PARM                    WPSTD                                        CAS019
     C                   PARM                    WPEND                                        CAS019
      *                                                                                       CAS019
     C                   IF        (MSG1 <> *Blanks) AND                                      CAS019
     C                             (ReturnCode = 'Error')                                     CAS019
     C                   EVAL      Idx = Idx + 1                                              CAS019
     C                   EVAL      FldNamXAr(Idx) = 'DDENPD'                                  CAS019
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CAS019
     C                   ELSE                                                                 CAS019
     C                   IF        (MSG1 <> *Blanks) AND                                      CAS019
     C                             (ReturnCode = 'Warning')                                   CAS019
     C                   EVAL      WId = WId + 1                                              CAS019
     C                   EVAL      WFldNmXAr(WId) = 'DDENPD'                                  CAS019
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
      ** Use the return code's value to set the field's OK flag                               CAS019
      *                                                                                       CAS019
     C                   CALLB     'ZASETOKFLG'                                               CAS019
     C                   PARM                    DDENPDOK                                     CAS019
     C                   PARM                    ReturnCode                                   CAS019
     C                   PARM                    WarnGlobal                                   CAS019
                                                                                              CAS019
     C                   ENDSR                                                                CAS019
      *****************************************************************                       CAS011
      /EJECT                                                                                  CAS011
      *****************************************************************                       CLE139
      *  VAmED   - Validate Fee Capitalisation Indicator              *                       CLE139
      *****************************************************************                       CLE139
     C     VCAPI         BEGSR                                                                CLE139
                                                                                              CLE139
      ** Reset variables updated by each module before each call                              CLE139
                                                                                              CLE139
     C                   EXSR      RESETFLDS                                                  CLE139
      *                                                                                       CLE139
     C**********         IF        DDCAPI <> 'Y' OR                                  CLE139 AR747729
     C**********                   DDLNRF  = *BLANKS                                 CLE139 AR747729
     C**********         EVAL      DDCAPI  = 'N'                                     CLE139 AR747729
     C**********         ELSE                                                        CLE139 AR747729
                                                                                              CLE139
      ** Entry is allowed only if Advice/Confirm indicator is 'Y', Fee                        CLE139
      ** period is within the loan period and Loan fee is in the same                         CLE139
      ** loan currency.                                                                       CLE139
                                                                                              CLE139
     C                   IF        DDLNRF <> *BLANKS                                        AR747729
     C                   IF        DDCAPI  = 'Y'                                              CLE139
                                                                                              CLE139
     C                   CALLB     'ZDATE1'                                                   CLE139
     C                   PARM                    DDEPSD                                       CLE139
     C                   PARM                    PDAYNS                                       CLE139
     C                   PARM                    BJDFIN                                       CLE139
     C                   PARM                    PErrFlag                                     CLE139
                                                                                              CLE139
     C                   CALLB     'ZDATE1'                                                   CLE139
     C                   PARM                    DDEPED                                       CLE139
     C                   PARM                    PDAYNE                                       CLE139
     C                   PARM                    BJDFIN                                       CLE139
     C                   PARM                    PErrFlag                                     CLE139
                                                                                              CLE139
     C                   IF        PDAYNS  < CL_VDAT OR                                       CLE139
     C                             PDAYNE  > CL_MDAT                                          CLE139
     C                   EVAL      Idx = Idx + 1                                              CLE139
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'                                  CLE139
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5602'                                 CLE139
     C                   EVAL      ReturnCode     = 'Error'                                   CLE139
     C                   ENDIF                                                                CLE139
                                                                                              CLE139
     C                   IF        DDEADV <> 'Y'                                              CLE139
     C                   EVAL      Idx = Idx + 1                                              CLE139
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'                                  CLE139
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5603'                                 CLE139
     C                   EVAL      ReturnCode     = 'Error'                                   CLE139
     C                   ENDIF                                                                CLE139
                                                                                              CLE139
     C                   IF        DDECUR <> CL_CCY                                           CLE139
     C                   EVAL      Idx = Idx + 1                                              CLE139
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'                                  CLE139
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5604'                                 CLE139
     C                   EVAL      ReturnCode     = 'Error'                                   CLE139
     C                   ENDIF                                                                CLE139
                                                                                              CLE139
     C                   ENDIF                                                                CLE139
      *                                                                                     AR747729
     C                   ELSE                                                               AR747729
      *                                                                                     AR747729
     C                   IF        DDCAPI = 'Y'                                             AR747729
     C                             AND DDFACT <> *BLANKS                                    AR747729
     C                             AND DDFCNO <> *BLANKS                                    AR747729
     C                   EVAL      Idx = Idx + 1                                            AR747729
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'                                AR747729
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5604'                               AR747729
     C                   EVAL      ReturnCode     = 'Error'                                 AR747729
     C                   ENDIF                                                              AR747729
      *                                                                                     AR747729
                                                                                              CLE139
     C                   ENDIF                                                                CLE139
                                                                                              CLE139
      ** Use the return code's value to set the field's OK flag                               CLE139
                                                                                              CLE139
     C                   CALLB     'ZASETOKFLG'                                               CLE139
     C                   PARM                    DDENPDOK                                     CLE139
     C                   PARM                    ReturnCode                                   CLE139
     C                   PARM                    WarnGlobal                                   CLE139
                                                                                              CLE139
     C                   ENDSR                                                                CLE139
                                                                                              CLE139
      *****************************************************************                       CLE139
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  RPDCL - Retrieve PDCL Details.                               *                       CLE134
      *****************************************************************                       CLE134
     C     RPDCL         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSPDSts     = *BLANKS                                      CLE134
                                                                                              CLE134
     C                   IF        DDPLNR     <> *BLANKS                                      CLE134
     C                   EVAL      Kpd_RECI    = 'D'                                          CLE134
     C                   EVAL      Kpd_LNRF    = DDPLNR                                       CLE134
     C     KCLOANL4      CHAIN(E)  CLOANL4                                                    CLE134
                                                                                              CLE134
     C                   IF        %FOUND(CLOANL4)             AND                            CLE134
     C                             pd_CPAM     <> 0                                           CLE134
     C                   EVAL      DSPDSts     = '*LIVE'                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Live Record Found, Default Initial Dates                                          CLE134
                                                                                              CLE134
     C                   IF        DSPDSts     = '*LIVE'       AND                            CLE134
     C                             pd_VDAT    <> 0                                            CLE134
     C                   IF        DDRIDT      = *BLANKS                                      CLE134
     C                   MOVE      pd_VDAT       ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVEL     ZDateFmt6     DDRIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DDBIDT      = *BLANKS                                      CLE134
     C                   MOVEL     ZDateFmt6     DDBIDT                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        DDFSFA      = 'Y'                                          CLE134
      ** Suspended Fee Amount Maximum                                                         CLE134
     C                   IF        DDSFAM      =  *BLANKS                                     CLE134
     C                   EVAL      ZFLD15      = AUSFAM                                       CLE134
     C                   IF        ZFLD15     <> 0                                            CLE134
     C                   EVAL      ZDECS       = A6NBDP                                       CLE134
     C                   EXSR      FMTAMT                                                     CLE134
     C                   EVALR     DDSFAM      = ZOUT21                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      ** Suspended Fee Payment Maximum                                                        CLE134
     C                   IF        DDSFPM      =  *BLANKS                                     CLE134
     C                   IF        AUSFPM     <> 0                                            CLE134
     C                             AND DDACTN = 'I'                                           CLE134
     C                   MOVE(P)   AUSFPM        DDSFPM                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      ** Partial Payment Allowed                                                              CLE134
     C                   IF        DDFPPA      =  *BLANKS                                     CLE134
     C                   EVAL      DDFPPA      = AUFPYA                                       CLE134
     C                   ENDIF                                                                CLE134
      ** Partial Indicator                                                                    CLE134
     C                   IF        DDPSIN      =  *BLANKS                                     CLE134
     C                   EVAL      DDPSIN      = AUPSIN                                       CLE134
     C                   ENDIF                                                                CLE134
      ** Partial Limit                                                                        CLE134
     C                   IF        DDPSLM      =  *BLANKS                                     CLE134
     C                   EVAL      ZFLD15      = AUPSLM                                       CLE134
     C                   IF        ZFLD15     <> 0                                            CLE134
     C                   IF        DDPSIN      = 'P'                                          CLE134
     C                   EVAL      ZDECS       = 0                                            CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      ZDECS       = A6NBDP                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   EXSR      FMTAMT                                                     CLE134
     C                   EVALR     DDPSLM      = %TRIM(ZOUT21)                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      ** Early Maturity Condition                                                             CLE134
     C                   IF        DDFEMC      =  *BLANKS   AND                               CLE134
     C                             (DDFPPA     = 'Y'        OR                                CLE134
     C                              DDFPPA     = 'P')                                         CLE134
     C                   EVAL      DDFEMC      = AUFEMC                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  ERDFT - Derive Reporting Default Values                      *                       CLE134
      *****************************************************************                       CLE134
     C     ERDFT         BEGSR                                                                CLE134
                                                                                              CLE134
      ** Initialisation                                                                       CLE134
                                                                                              CLE134
     C                   EVAL      DSRCAT      = 0                                            CLE134
     C                   EVAL      DSRIDTFm    = 0                                            CLE134
     C                   EVAL      DSRIDTTo    = 0                                            CLE134
                                                                                              CLE134
      ** If Reporting Classification Entered,                                                 CLE134
      ** Derive Valid Initial Date Range                                                      CLE134
                                                                                              CLE134
     C                   IF        DDRCAT     >= '1'           AND                            CLE134
     C                             DDRCAT     <= '9'                                          CLE134
     C                   EVAL      #A          = %DEC(DDRCAT:9:0)                             CLE134
                                                                                              CLE134
     C                   SELECT                                                               CLE134
     C                   WHEN      #A          = 1                                            CLE134
     C                   EVAL      DSRIDTFm    = BJRDNB - DSRCN(1)                            CLE134
     C                   EVAL      DSRIDTTo    = BJRDNB                                       CLE134
                                                                                              CLE134
     C                   WHEN      DSRCN(#A)   = 999           OR                             CLE134
     C                             DSRCN(#A)   = 0                                            CLE134
     C                   EVAL      DSRIDTFm    = 0                                            CLE134
     C                   EVAL      DSRIDTTo    = BJRDNB - DSRCN(#A-1)                         CLE134
                                                                                              CLE134
     C                   OTHER                                                                CLE134
     C                   EVAL      DSRIDTFm    = BJRDNB - DSRCN(#A)                           CLE134
     C                   EVAL      DSRIDTTo    = BJRDNB - DSRCN(#A-1)                         CLE134
     C                   ENDSL                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Reporting Initial Date Entered, Derive Valid Classification                       CLE134
                                                                                              CLE134
     C                   IF        DDRIDT     <> *BLANKS                                      CLE134
     C                   CALLB     'ZDATE1'                                                   CLE134
     C                   PARM                    DDRIDT                                       CLE134
     C     DSRIDT        PARM                    ZDAYNO                                       CLE134
     C                   PARM                    BJDFIN                                       CLE134
     C                   PARM                    ErrorFlag         1                          CLE134
                                                                                              CLE134
     C                   IF        DSRIDT     <= BJRDNB        AND                            CLE134
     C                             ErrorFlag  <> 'Y'                                          CLE134
     C                   EVAL      DSDYS       = BJRDNB - DSRIDT                              CLE134
                                                                                              CLE134
      ** Code finds array elements initialised to 9999 if PD                                MD027024
      ** date >= 999 days but these are really invalid array elements                       MD027024
                                                                                            MD027024
     C**********         IF        DSDYS       > 999                                 CLE134 MD027024
     C                   IF        DSDYS       >= 999                                       MD027024
     C                   EVAL      DSDYS       = 999                                          CLE134
     C**********         ENDIF                                                       CLE134 MD027024
                                                                                            MD027024
      ** Find last valid period if date >= 999 days                                         MD027024
                                                                                            MD027024
     C                   EVAL      DSRCAT      = %LOOKUPLE(DSDYS:DSRCN)                     MD027024
     C                   ELSE                                                               MD027024
                                                                                              CLE134
     C                   IF        BJRDNB      = @@FERCSD + @@FERCDY                        MD053837
     C                   EVAL      DSRCAT      = %LOOKUP(DSDYS:DSRCN)                       MD053837
     C                   ELSE                                                               MD053837
     C                   EVAL      DSRCAT      = %LOOKUPGT(DSDYS:DSRCN)                       CLE134
     C                   ENDIF                                                              MD053837
     C                   ENDIF                                                              MD027024
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Reporting Classification Not Entered, Set Default                                 CLE134
                                                                                              CLE134
     C                   IF        DDRCAT      = *BLANKS       AND                            CLE134
     C                             DSRCAT     <> 0                                            CLE134
     C                   EVAL      DDRCAT      = %CHAR(DSRCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Reporting Initial Date Not Entered, Set Default.                                  CLE134
                                                                                              CLE134
     C                   IF        DDRIDT      = *BLANKS       AND                            CLE134
     C                             DSRIDTTo   <> 0                                            CLE134
     C                   MOVE      DSRIDTTo      ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVE      ZDateFmt6     DDRIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VRIDt   Validate Reporting Past Due Initial Date             *                       CLE134
      *****************************************************************                       CLE134
     C     VRIDt         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDRIDT'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVRIDT'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
                                                                                              CLE134
     C                   PARM      DSRCAT        P@RCAT                                       CLE134
     C                   PARM      DSRIDTFm      P@RIDTFm                                     CLE134
     C                   PARM      DSRIDTTo      P@RIDTTo                                     CLE134
     C                   PARM      BPMXCH        P@MXCH                                       CLE134
     C                   PARM      DSPDSts       P@PDSts                                      CLE134
     C                   PARM      pd_VDAT       P@PDVlD                                      CLE134
                                                                                              CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    SDCLND                                       CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    CrFeFilFmt                                   CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDRIDTOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VRCat   Validate Reporting Past Due Classification           *                       CLE134
      *****************************************************************                       CLE134
     C     VRCat         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDRCAT'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVRCAT'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
                                                                                              CLE134
     C                   PARM      DSRCAT        P@RCAT                                       CLE134
     C                   PARM      DSRIDTFm      P@RIDTFm                                     CLE134
     C                   PARM      DSRIDTTo      P@RIDTTo                                     CLE134
     C                   PARM      BPMXCH        P@MXCH                                       CLE134
                                                                                              CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    SDCLND                                       CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    CrFeFilFmt                                   CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDRCATOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  EBDFT - Derive Basel II Default Values                       *                       CLE134
      *****************************************************************                       CLE134
     C     EBDFT         BEGSR                                                                CLE134
                                                                                              CLE134
      ** Initialisation.                                                                      CLE134
                                                                                              CLE134
     C                   EVAL      DSBCAT      = 0                                            CLE134
     C                   EVAL      DSBIDTFm    = 0                                            CLE134
     C                   EVAL      DSBIDTTo    = 0                                            CLE134
                                                                                              CLE134
      ** If Basel II Classification Entered,                                                  CLE134
      ** Derive Valid Initial Date Range.                                                     CLE134
                                                                                              CLE134
     C                   IF        DDBCAT     >= '1'           AND                            CLE134
     C                             DDBCAT     <= '9'                                          CLE134
     C                   EVAL      #A          = %DEC(DDBCAT:9:0)                             CLE134
                                                                                              CLE134
     C                   SELECT                                                               CLE134
     C                   WHEN      #A          = 1                                            CLE134
     C                   EVAL      DSBIDTFm    = BJRDNB - DSBCN(1)                            CLE134
     C                   EVAL      DSBIDTTo    = BJRDNB                                       CLE134
                                                                                              CLE134
     C                   WHEN      DSBCN(#A)   = 999           OR                             CLE134
     C                             DSBCN(#A)   = 0                                            CLE134
     C                   EVAL      DSBIDTFm    = 0                                            CLE134
     C                   EVAL      DSBIDTTo    = BJRDNB - DSBCN(#A-1)                         CLE134
                                                                                              CLE134
     C                   OTHER                                                                CLE134
     C                   EVAL      DSBIDTFm    = BJRDNB - DSBCN(#A)                           CLE134
     C                   EVAL      DSBIDTTo    = BJRDNB - DSBCN(#A-1)                         CLE134
     C                   ENDSL                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Basel II Initial Date Entered, Derive Valid Classification.                       CLE134
                                                                                              CLE134
     C                   IF        DDBIDT     <> *BLANKS                                      CLE134
     C                   CALLB     'ZDATE1'                                                   CLE134
     C                   PARM                    DDBIDT                                       CLE134
     C     DSBIDT        PARM                    ZDAYNO                                       CLE134
     C                   PARM                    BJDFIN                                       CLE134
     C                   PARM                    ErrorFlag         1                          CLE134
                                                                                              CLE134
     C                   IF        DSBIDT     <= BJRDNB        AND                            CLE134
     C                             ErrorFlag  <> 'Y'                                          CLE134
     C                   EVAL      DSDYS       = BJRDNB - DSBIDT                              CLE134
                                                                                              CLE134
      ** Code finds array elements initialised to 9999 if PD                                MD027024
      ** date >= 999 days but these are really invalid array elements                       MD027024
                                                                                            MD027024
     C**********         IF        DSDYS       > 999                                 CLE134 MD027024
     C                   IF        DSDYS       >= 999                                       MD027024
     C                   EVAL      DSDYS       = 999                                          CLE134
     C**********         ENDIF                                                       CLE134 MD027024
                                                                                            MD027024
      ** Find last valid period if date >= 999 days                                         MD027024
                                                                                            MD027024
     C**********         EVAL      DSRCAT      = %LOOKUPLE(DSDYS:DSBCN)            MD027024 MD053837
     C                   EVAL      DSBCAT      = %LOOKUPLE(DSDYS:DSBCN)                     MD053837
     C                   ELSE                                                               MD027024
                                                                                              CLE134
     C                   IF        BJRDNB      = @@FEBCSD + @@FEBCDY                        MD053837
     C                   EVAL      DSBCAT      = %LOOKUP(DSDYS:DSBCN)                       MD053837
     C                   ELSE                                                               MD053837
     C                   EVAL      DSBCAT      = %LOOKUPGT(DSDYS:DSBCN)                       CLE134
     C                   ENDIF                                                              MD053837
     C                   ENDIF                                                              MD027024
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Basel II Classification Not Entered, Set Default.                                 CLE134
                                                                                              CLE134
     C                   IF        DDBCAT      = *BLANKS       AND                            CLE134
     C                             DSBCAT     <> 0                                            CLE134
     C                   EVAL      DDBCAT      = %CHAR(DSBCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If Basel II Initial Date Not Entered, Set Default.                                   CLE134
                                                                                              CLE134
     C                   IF        DDBIDT      = *BLANKS       AND                            CLE134
     C                             DSBIDTTo   <> 0                                            CLE134
     C                   MOVE      DSBIDTTo      ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVE      ZDateFmt6     DDBIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VBIDT   Validate Basel II Past Due Initial Date              *                       CLE134
      *****************************************************************                       CLE134
     C     VBIDt         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDBIDT'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVBIDT'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
                                                                                              CLE134
     C                   PARM      DSBCAT        P@BCAT                                       CLE134
     C                   PARM      DSBIDTFm      P@BIDTFm                                     CLE134
     C                   PARM      DSBIDTTo      P@BIDTTo                                     CLE134
     C                   PARM      BPMXCH        P@MxCh                                       CLE134
     C                   PARM      DSPDSts       P@PDSts                                      CLE134
     C                   PARM      pd_VDAT       P@PDVlD                                      CLE134
                                                                                              CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    SDCLND                                       CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    CrFeFilFmt                                   CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDBIDTOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VBCat   Validate Basel II Past Due Classification            *                       CLE134
      *****************************************************************                       CLE134
     C     VBCat         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDBCAT'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process                                                           CLE134
                                                                                              CLE134
     C                   CALLB     'LEVBCAT'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
                                                                                              CLE134
     C                   PARM      DSBCAT        P@BCAT                                       CLE134
     C                   PARM      DSBIDTFm      P@BIDTFm                                     CLE134
     C                   PARM      DSBIDTTo      P@BIDTTo                                     CLE134
     C                   PARM      BPMXCH        P@MXCH                                       CLE134
                                                                                              CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    SDCLND                                       CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    CrFeFilFmt                                   CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDBCATOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VFSFA   - Validate Suspend Fee Allowed                       *                       CLE134
      *****************************************************************                       CLE134
     C     VFSFA         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDFSFA'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVFSFA'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDFSFAOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VSFAM   - Validate Suspend Fee Amount Maximum                *                       CLE134
      *****************************************************************                       CLE134
     C     VSFAM         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDSFAM'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVSFAM'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM      A6NBDP        P@NBDP                                       262513
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDSFAMOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VSFPM   - Validate Suspend Fee Payment Maximum               *                       CLE134
      *****************************************************************                       CLE134
     C     VSFPM         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDSFPM'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVSFPM'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDSFPMOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VFPPA   - Validate Partial Payment Allowed                   *                       CLE134
      *****************************************************************                       CLE134
     C     VFPPA         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDFPPA'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVFPPA'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDFPPAOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VPSIN   - Validate Partial Indicator                         *                       CLE134
      *****************************************************************                       CLE134
     C     VPSIn         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDPSIN'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVPSIN'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDPSINOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VPSLM   - Validate Partial Limit                             *                       CLE134
      *****************************************************************                       CLE134
     C     VPSLM         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDPSLM'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVPSLM'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM      A6NBDP        P@NBDP                                       262513
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDPSLMOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *  VFEMC   - Validate Early Maturity Condition                  *                       CLE134
      *****************************************************************                       CLE134
     C     VFEMC         BEGSR                                                                CLE134
                                                                                              CLE134
     C                   EVAL      DSField     = 'DDFEMC'                                     CLE134
                                                                                              CLE134
      ** Reset variables updated by each module before each call                              CLE134
                                                                                              CLE134
     C                   EXSR      RESETFLDS                                                  CLE134
                                                                                              CLE134
      ** Perform Validation Process.                                                          CLE134
                                                                                              CLE134
     C                   CALLB     'LEVFEMC'                                                  CLE134
     C                   PARM      *BLANKS       ReturnCode                                   CLE134
     C                   PARM                    MSG1                                         CLE134
     C                   PARM                    TranInPrim                                   CLE134
     C                   PARM                    SDFEE                                        CLE134
     C                   PARM                    SDLOAN                                       CLE134
     C                   PARM                    SDBANK                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
                                                                                              CLE134
      ** Add Any Error/Warning Message.                                                       CLE134
                                                                                              CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Error'                                      CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = DSField                                   CLE134
     C                   EVAL      MsgIDXAr(Idx) = MSG1                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        MSG1       <> *Blanks       AND                            CLE134
     C                             ReturnCode  = 'Warning'                                    CLE134
     C                   EVAL      WId        += 1                                            CLE134
     C                   EVAL      WFldNmXAr(WId) = DSField                                   CLE134
     C                   EVAL      WMsgIDXAr (WId) = MSG1                                     CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Use the return code's value to set the field's OK flag                               CLE134
                                                                                              CLE134
     C                   CALLB     'ZASETOKFLG'                                               CLE134
     C                   PARM                    DDFEMCOK                                     CLE134
     C                   PARM                    ReturnCode                                   CLE134
     C                   PARM                    WarnGlobal                                   CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                     AR314017
      ***VSSIs***-*Validate*PONS/RONS*of*SSIs*vs*auto*flag,*etc.*******              AR314017 CLE164
      *****************************************************************                     AR314017
     C*****VSSIs         BEGSR                                                       AR314017 CLE164
                                                                                            AR314017
      ***Reset*variables*updated*by*each*module*before*each*call*******              AR314017 CLE164
                                                                                            AR314017
     C**********         EXSR      RESETFLDS                                         AR314017 CLE164
                                                                                            AR314017
      ***Warnings*about*existing*records*in*Priority*Repayment*file****              AR314017 CLE164
                                                                                            AR314017
     C**********         IF        DDACTN = 'A'                                      AR314017 CLE164
                                                                                            AR314017
     C**********         MOVE      VFCNUM        Wpd_FCNM                            AR314017 CLE164
     C**********         MOVE      VFLOAN        Wpd_FLNR                            AR314017 CLE164
     C**********         MOVE      VFFACL        Wpd_FACT                            AR314017 CLE164
     C**********         MOVE      VFFSEQ        Wpd_FSE1                            AR314017 CLE164
     C**********         MOVE      VFFCOD        Wpd_FCOD                            AR314017 CLE164
     C**********         MOVE      VFBRCA        Wpd_FCBR                            AR314017 CLE164
     C**********         MOVE      VFFCCY        Wpd_ACCY                            AR314017 CLE164
                                                                                            AR314017
     C**********         IF        DDRONX <> @@RONS                                  AR314017 CLE164
     C*****KLEACCNL1     CHAIN(N)  LEACCNLB                           99             AR314017 CLE164
     C**********         IF        *IN99 = *OFF                                      AR314017 CLE164
     C**********         EVAL      WId += 1                                          AR314017 CLE164
     C**********         EVAL      WFldNamArr(WId) = 'DDRONX'                        AR314017 CLE164
     C**********         EVAL      WMsgIDArr(WId) = '5045708'                        AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
                                                                                            AR314017
     C**********         ENDIF                                                       AR314017 CLE164
                                                                                            AR314017
      ***Settlement*account*must*be*present*with*DDEADV*=*C************              AR314017 CLE164
                                                                                            AR314017
     C**********         IF        DDEADV = 'C'                                      AR314017 CLE164
                                                                                            AR314017
     C**********         IF        DDRONX = *BLANKS                                  AR314017 CLE164
     C**********                   AND DDRSTM <> '00'                                AR693137 CLE164
     C**********                   AND DDRSTM <> '  '                                AR693137 CLE164
     C**********         ADD       1             Idx                                 AR314017 CLE164
     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                        AR314017 CLE164
     C**********         MOVEL     '5045678'     MsgIDArr(Idx)                       AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
                                                                                            AR314017
      ***If*pre-deal*check*is*defined,*Receipt*Settlement*should*be****              AR693137 CLE164
      ***equal*to*01,*05,*08*or*14.************************************              AR693137 CLE164
                                                                                            AR693137
     C**********         IF        CLE134 = 'Y' AND                                  AR693137 CLE164
     C**********                   DDEADV = 'C' AND                                  AR693137 CLE164
     C**********                   DDACTN= 'I'  OR                                   AR693137 CLE164
     C**********                   CLE134 = 'Y' AND                                  AR693137 CLE164
     C**********                   DDEADV = 'C' AND                                  AR693137 CLE164
     C**********                   DDACTN= 'A'                                       AR693137 CLE164
     C**********         IF        DDRSTM <> '01' AND                                AR693137 CLE164
     C**********                   DDRSTM <> '05' AND                                AR693137 CLE164
     C**********                   DDRSTM <> '08' AND                                AR693137 CLE164
     C**********                   DDRSTM <> '14'                                    AR693137 CLE164
     C**********         ADD       1             Idx                                 AR693137 CLE164
     C**********         EVAL      FldNameArr(Idx) = 'DDRSTM'                        AR693137 CLE164
     C**********         MOVEL     'LES0613'     MsgIDArr(Idx)                       AR693137 CLE164
     C**********         ENDIF                                                       AR693137 CLE164
     C**********         ENDIF                                                       AR693137 CLE164
      *                                                                                     AR693137
     C**********         ENDIF                                                       AR314017 CLE164
                                                                                            AR314017
     C**********         ENDSR                                                       AR314017 CLE164
      *****************************************************************                     AR314017
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      *  PIBRT -  Validate PDCL Base Rate Code                        *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     PIBRT         BEGSR                                                                CLE134
                                                                                              CLE134
      ** Check PDCL base rate code                                                            CLE134
                                                                                              CLE134
     C                   IF        AUCBRT = 0                                                 CLE134
     C                   EVAL      @KEY1 = DDECUR                                             CLE134
     C                   MOVE      AUCBSR        @KEY2                                        CLE134
                                                                                              CLE134
     C                   IF        AUCBRT <> *ZEROS                                        AR1077167
     C                   CALLB     'AOBSRTR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY   '     @OPTN                                        CLE134
     C                   PARM                    @KEY1                                        CLE134
     C                   PARM                    @KEY2                                        CLE134
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD <> *BLANKS                                           CLE134
     C                             AND AUCBSR <> *ZEROS                                       CLE134
     C                             OR  AUCBSR = *ZEROS                                        CLE134
     C                             AND AUCRSP = *ZEROS                                        CLE134
     C                   EVAL      DDLNRFOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDECOD'                                  CLE134
     C**********         EVAL      MsgIdXAr(Idx) = 'LER5572'                        CLE134 AR1072101
     C                   EVAL      MsgIdXAr(Idx) = '5045664'                               AR1072101
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                             AR1077167
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
     C*****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      * FMTAMT - Format Amount for Display                            *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     FMTAMT        BEGSR                                                                CLE134
      *                                                                                       CLE134
     C                   CALLB     'ZSEDIT'                                                   CLE134
     C                   PARM                    ZFLD15                                       CLE134
     C                   PARM                    ZDECS                                        CLE134
     C                   PARM      *BLANKS       ZECODE                                       CLE134
     C                   PARM                    ZOUT21                                       CLE134
      *                                                                                       CLE134
     C                   EVAL      ZFLD15 = *ZEROS                                            CLE134
     C                   ENDSR                                                                CLE134
     C****************************************************************                        CLE134
      /EJECT                                                                                  CLE139
     C****************************************************************                        CAS011
     C*                                                              *                        CAS011
     C* SRERR - EXCEPTION ERRORS                                     *                        CAS011
     C*                                                              *                        CAS011
     C****************************************************************                        CAS011
     C     SRERR         BEGSR                                                                CAS011
                                                                                              CAS011
     C                   MOVEL     '*ERROR '     PRTCD                                        CAS011
     C                   MOVEL     'LEFEEMVAL'   DBPGM                                        CAS011
     C                   MOVE      '1'           *INU7                                        CAS011
     C                   MOVE      '1'           *INU8                                        CAS011
     C                   MOVE      '1'           *INLR                                        CAS011
     C                   DUMP                                                                 CAS011
                                                                                              CAS011
      ** Terminate the program                                                                CAS011
                                                                                              CAS011
     C                   RETURN                                                               CAS011
                                                                                              CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       CAS011
      /EJECT                                                                                  CAS011
      *****************************************************************                       CAS019
      *                                                               *                       CAS019
      ** RESETFLDS - Reset error information that is received back    *                       CAS019
      **             from each validation module.                     *                       CAS019
      *                                                               *                       CAS019
      *****************************************************************                       CAS019
      *                                                                                       CAS019
     C     RESETFLDS     BEGSR                                                                CAS019
      *                                                                                       CAS019
     C                   RESET                   Msg1                                         CAS019
     C                   RESET                   Msg2                                         CAS019
     C                   RESET                   Msg3                                         CAS019
     C                   RESET                   Msg4                                         CAS019
     C                   RESET                   Msg5                                         CAS019
     C                   RESET                   Msg6                                         CAS019
     C                   RESET                   Msg7                                         CAS019
                                                                                              CAS019
     C                   RESET                   WMsgID1                                      CAS019
     C                   RESET                   WMsgID2                                      CAS019
     C                   RESET                   WMsgID3                                      CAS019
     C                   RESET                   WMsgID4                                      CAS019
                                                                                              CAS019
     C                   RESET                   MSGDATA                                      CAS019
                                                                                              CAS019
     C                   EVAL      ReturnCode= *Blanks                                        CAS019
      *                                                                                       CAS019
     C                   ENDSR                                                                CAS019
      *****************************************************************                       CAS019
      *                                                               *                       CAS019
      ** CONVERT   - Convert to Midas Date                            *                       CAS019
      *                                                               *                       CAS019
      *****************************************************************                       CAS019
      *                                                                                       CAS019
     C     CONVERT       BEGSR                                                                CAS019
      ** Convert to Midas date format                                                         CAS019
     C                   MOVE      DATCNV        DATEA                                        CAS019
     C                   CALLB     'ZDATE1'                                                   CAS019
     C                   PARM                    DATEA             6                          CAS019
     C                   PARM                    ZDAYNO            5 0                        CAS019
     C                   PARM                    BJDFIN                                       CAS019
     C                   PARM                    ErrorFlag         1                          CAS019
                                                                                              CAS019
     C                   ENDSR                                                                CAS019
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  WCTP
0102030405061112131415162122
**  ECTP                                                                                      CLE073
90979899                                                                                    AR322844
**  CPY@
(c) Finastra International Limited 2002
