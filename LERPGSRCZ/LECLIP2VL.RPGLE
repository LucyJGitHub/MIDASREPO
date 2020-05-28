     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans screen 2 validations')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP2VL -  Customer Loans screen 2 validations             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055219           Date 27May20               *
      *  Prev Amend No. MD055059           Date 21May20               *
      *                 MD055220           Date 12May20               *
      *                 MD055128           Date 17Apr20               *
      *                 MD055714           Date 06May20               *
      *                 257533             Date 06May20               *
      *                 MD055074           Date 21Jan20               *
      *                 MD053297           Date 06Sep19               *
      *                 MD023254           Date 06Sep19               *
      *                 CLE170             Date 28Feb08               *
      *                 CER050             Date 16Jun19               *
      *                 MD052515           Date 24Jan19               *
      *                 MD036008           Date 24Jan19               *
      *                 MD034449           Date 24Jan19               *
      *                 AR988460           Date 24Jan19               *
      *                 MD053143           Date 04Apr19               *
      *                 MD052279           Date 14Nov18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034840           Date 10Feb17               *
      *                 MD041917           Date 20Dec16               *
      *                 MD040412           Date 17Aug16               *
      *                 MD039304           Date 19Jul16               *
      *                 CLE141             Date 08Feb16               *
      *                 MD031736           Date 02Mar15               *
      *                 MD031225           Date 10Dec14               *
      *                 MD025521           Date 19Aug14               *
      *                 MD022807C          Date 15Oct13               *
      *                 MD000091           Date 09May13               *
      *                 AR830785           Date 07May13               *
      *                 AR1085248          Date 07Feb13               *
      *                 AR1067935          Date 24Apr13               *
      *                 AR1096933          Date 02Apr13               *
      *                 AR740107A          Date 21Dec12               *
      *                 AR740107           Date 21Dec12               *
      *                 AR804863           Date 10Dec12               *
      *                 AR835048B          Date 27Nov12               *
      *                 AR835048A          Date 27Nov12               *
      *                 AR835048           Date 27Nov12               *
      *                 AR826115           Date 07Dec12               *
      *                 AR648838           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR993993           Date 27Jun12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR811153           Date 08Aug11               *
      *                 AR747825           Date 18Apr11               *
      *                 CLE064             Date 06Dec10               *
      *                 262433             Date 13Nov09               *
      *                 261714             Date 10Sep09               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23696           Date 07Apr09               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22311           Date 23Mar09               *
      *                 BUG21845A          Date 26Feb09               *
      *                 BUG21845           Date 23Feb09               *
      *                 BUG21853           Date 04Dec08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21152           Date 22Sep08               *
      *                 256564             Date 17Sep08               *
      *                 BUG16617           Date 01Mar08               *
      *                 BUG16385           Date 22Feb08               *
      *                 249268             Date 20Jul07               *
      *                 247325             Date 26Apr07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 246516             Date 19Mar07               *
      *                 BUG14788           Date 06Sep07               *
      *                 BUG13843           Date 02May07               *
      *                 BUG13239           Date 07Feb07               *
      *                 BUG13238           Date 07Feb07               *
      *                 BUG13178           Date 02Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241648             Date 01Sep06               *
      *                 241018             Date 22Aug06               *
      *                 BUG11329           Date 08May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 08May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10226           Date 07Feb06               *
      *                 BUG10225           Date 02Feb06               *
      *                 BUG9691            Date 22Dec05               *
      *                 BUG9634            Date 16Dec05               *
      *                 BUG8863            Date 06Oct05               *
      *                 BUG9239            Date 21Oct05               *
      *                 BUG9008            Date 18Oct05               *
      *                 BUG8526            Date 27Sep05               *
      *                 BUG8461            Date 12Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 21Jun05               *
      *                 BUG7147            Date 01Jun05               *
      *                 BUG5863            Date 14Feb04               *
      *                 BUG5070            Date 06Dec04               *
      *                 BUG4351 (reopen)   Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 TDA023             Date 24Mar04               *
      *                 225430             Date 03Mar04               *
      *                 225214             Date 23Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 29May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055219 - Interest rate must not be zero for discount and   *
      *             flat loan                                         *
      *  MD055059 - Allow negative fixed rate                         *
      *  MD055220 - Allow negative spread rate to be processed        *
      *  MD055128 - Allow  negative total interest when negative      *
      *             base rate code was used                           *
      *  MD055714 - Missing rebate posting after changing maturity    *
      *             date of discount loan. Restore original values of *
      *             ORTI, ORMD and TOTI fields after amend-reject of  *
      *             discount loan.                                    *
      *  257533 - ORMD and ORTI of a discount loan which was amended  *
      *           to have a new maturity date stored the new values   *
      *           instead of the original values. Amended program     *
      *           to ensure correct values will be stored.            *
      *         - Applied for MD055714  Z                             *
      *  MD055074 - Interest for processing type 80 is mandatory.     *
      *  MD053297 - Interest not posted correctly for Part sold       *
      *  MD023254 - LOAC does not show the correct interest schedule  *
      *             for a Bank. Add condition to default spread       *
      *             indicator(DDSPIN) to 'A' when defined loan type   *
      *             is 70,71,72.                                      *
      *           - Applied for MD053297                              *
      *  CLE170 - Allow Zero Interest Rate Loans                      *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD052515 - Negative fixed rate loan got unexpected errors    *
      *  MD036008 - Total Interest always displayed as positive.      *
      *           - Applied for MD052515                              *
      *  MD034449 - Used ZA0841 instead of ZALIGN for negative spread *
      *           - Applied for MD052515                              *
      *  AR988460 - Cannot input negative all-in-rate on Lending.     *
      *             Allow input and computation for negative          *
      *             all-in-rate on Lending.                           *
      *           - Applied for MD034449                              *
      *           - Applied for MD052515                              *
      *  MD053143 - CLE141 Business Day Convention processing to be   *
      *             applied for loan start date rate fixing.          *
      *  MD052279 - Negative rate loan got unexpected error 45021183  *
      *             (Entry is not allowed for discounted loans or zero*
      *             interests) and 45021165 (Valid rate is req. if no *
      *             base rate input).                                 *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034840 - No error issued for input of base rate even if    *
      *             Base Rate Change Facility ICD is set to 'N'.      *
      *  MD041917 - Total interest is calculated as zero when fixed   *
      *             rate has value and contractual spread is zero.    *
      *             Move DDFXRT to WSVRS to calculate TOTI accurately.*
      *  MD040412 - No description for error 45048709 ; fixed also    *
      *             the serious midas error when a user entered an    *
      *             invalid character in rate/spread field            *
      *  MD039304 - Prevent a combination of zero spread rate and a   *
      *             spread indicator equal to percentage.             *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  MD031736 - Make use of system values to condition use of rate*
      *             fixing on loan start date.                        *
      *  MD031225 - Show the correct error message when validating a  *
      *             rate.                                             *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  MD022807C - Repayment details amendment is prohibited on     *
      *              Past due call loans                              *
      *  MD000091 - Event Codes Substitution                          *
      *  AR830785 - Looping on insert of accrued interest adjustment  *
      *             Enhanced core fix 263533. (Child: AR830786)       *
      *  AR1085248 - Loan amendment failed when next repayment date   *
      *              is in the past due to error message LEL0508.     *
      *              Pattern fix to AR700865. (Child: AR1085249)      *
      *  AR1067935 - CLE134: Changes to repayment details for PDCL are*
      *              accepted. Do not allow repayment details for     *
      *              PDCL. (Child: AR1067936)                         *
      *  AR1096933 - Warning message of event code not found during   *
      *              complete and authorisation.                      *
      *  AR740107A - No warning message is encountered when maturity  *
      *              date is amended to be and has a repayment        *
      *              scheduled on the same date. Amend program such   *
      *              a warning message would be shown if maturity date*
      *              and repayment schedule has the same date.        *
      *              (Child: AR740108A)                               *
      *  AR740107 - Maturity changed equal to repayment date requires *
      *             warning message. Additional validation added      *
      *             between Maturity and Next Repayment date.         *
      *             (Child: AR740108)                                 *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  AR835048B - Facility currency repayment amount error. If the *
      *              facility currency is the same as base currency,  *
      *              use spot rate of loan currency as cross rate to  *
      *              get the calculated repayment amount. Enhance fix *
      *              BUG16385. (Child: AR835049B)                     *
      *            - Applied for AR835048 (Child: AR954882)           *
      *  AR835048A - Facility Currency repayment amount error. Extend *
      *              fix for AR835048 when Facility Currency repayment*
      *              account was left blank. (Child: AR835049A)       *
      *            - Applied for AR835048 (Child: AR954882)           *
      *  AR835048 - Facility Currency repayment amount error. Pattern *
      *             after fix 253393 and 254221. Partial fix applied. *
      *             (Child: AR954882)                                 *
      *  AR826115 - Component LEC0456 failed due to DBERR 10 in file  *
      *             SDBSRTPD. Removed validation of BPBRCF to prevent *
      *             database error when BPBRCF='N'. (Child: AR826116) *
      *  AR648838 - Rollover event defaulted interest payment date    *
      *           - CLE134 Rollover event defaulted interest payment  *
      *             date. Applied core fix 251225.                    *
      *             (Child: AR648839)                                 *
      *  251225 - When blank, do not default interest payment date to *
      *           rollover date.                                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR993993 - System does not allow only Contractual Spread     *
      *             without contractual details                       *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest   *
      *           Rate                                               *
      *  AR811153 - Rate / Spread is blanked out after authorize      *
      *  AR747825 - Receiver value too small to hold result           *
      *             (Child: AR747826)                                 *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  262433 - System sends error LEL0416 due to .01 diffrence in  *
      *           repayment amt calculation. Added another condition  *
      *           prior to sending LEL0416.                           *
      *  261714 - A serious Midas error has occurred. Prevent the     *
      *           divide by zero event by increasing the decimal      *
      *           positions of several fields.                        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23696 - Cannot amend an "EUR" loan transaction            *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG22311 - Wrong interest calculation when additional day    *
      *             indicator = 'L'                                   *
      *  BUG21845A - Wrong interest calculation for Flat Rate Loans   *
      *              Reopened                                         *
      *  BUG21845 - Wrong interest calculation for Flat Rate Loans    *
      *  BUG21853 - Rate / Spread is missing                          *
      *  BUG21152 - Applied Fix BUG20318                              *
      *  BUG20318 - Wrong computation of total interest               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16617 - Attempt to divide by zero while calculating       *
      *             repayment amount for repayment type 3. Do not     *
      *             calculate if effective interest rate is zero      *
      *  BUG16385-Inconsistent behavior of system on Facility Currency*
      *           Repayment Amount field                              *
      *  249268 - LEA0547 appears when the value of DDRTSP is zero.   *
      *  247325 - Incorrect validation of the Facility Currency       *
      *           Repayment amount during insertion of a Principal    *
      *           Transfer.                                           *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  246516 - Backvalued transactions should use historic base    *
      *           rates. Also interest calculation must be changed to *
      *           next interest date.                                 *
      *  BUG14788 - Error message appears on fixed rate field         *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  BUG13239 - Applied fix 245239, 245104B, 245104A and 243057.  *
      *  BUG13238 - Applied fix 245239                                *
      *  BUG13178 - Error on calculated facility currency repayment   *
      *             amount. Applied fix 243057.                       *
      *  245239 - Use ZFRQB2 to properly compute the number of        *
      *           payments before maturity date.                      *
      *  245104B - Remove LEL0699.                                    *
      *  245104A - Do not recompute for facility currency repayment   *
      *            amount.                                            *
      *  243057 - Error on calculated facility currency repayment     *
      *             amount.  (Bugzilla number 013178)                 *
      *  241648 - Allow repayment date equal to loan's maturity date. *
      *  241018  - Add validation to Facility Currency Repayment      *
      *            amount and reversed some codes by BUG3721.         *
      *  BUG11329  - Incorrect error message. See Bugzilla.           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG10226 - Amended validation of Interest for participants.  *
      *  BUG10225- Allow both base rate code and Spread rate to be    *
      *            blank for participants.                            *
      *          - Changes in Fixed/Based Rates should be switchable  *
      *            under CLE036, NOT CLE035.                          *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9634- Serious Midas Error-Customer Lending DrawDown Error *
      *           Decimal Data Error encountered when writing to file *
      *  BUG8863 - Total interest not recalculated for discount loans *
      *            if maturity date amended.                          *
      *  BUG9239- Spread Rate Indicator defaulted to 'A' if blanks    *
      *           to avoid error in interest rate calculation during  *
      *           COB.                                                *
      *  BUG9008- Move validation of the CLE005 fields before the     *
      *           validation of the repayment amount due to dependency*
      *  BUG8526- Facility Currency Exchange Rate should be used, if  *
      *           entered, in the calculation of the Facility         *
      *           Repayment amount.                                   *
      *  BUG8461- Discount amount in loan details enquiry not         *
      *           recalculated
      *  CLE106 - Syndications Manager                                *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits. Added *
      *           Base Rate and Fixed Rate validation.                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7147 - ZICALC defined as 1 alpha when GLINTC expects 1,0  *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  BUG5070 - Total interest amount is not being validated       *
      *            against calculated amount.                        *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *           Additional fixes: 217847, 219695                    *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  225430 - Display new error message LEL0679 if amending the   *
      *           Withholding Tax rate or indicator. Bug 794.         *
      *  225214 - Cannot amend loan with zero repayment type          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ***  FILES
      *    =====
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIP2V01
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D ArrayRtSp       S              1A   DIM(12)                                          MD034449
      * Incoming Spread Rate in screen format                                               MD034449
                                                                                            MD034449
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays
      *
     D NUMS            C                   CONST('123456789')
      ***  Work Array for Drawing Types
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D***WFREQ**         S              1    DIM(7) CTDATA PERRCD(7)                          CLE064
     D WFREQ           S              1    DIM(20) CTDATA PERRCD(20)                          CLE064
      ***  Frequency codes for interest and repayments
     D NDAYS           S              4S 0 DIM(21) CTDATA                                     CLE064
     D NFREQ           S              1    DIM(21) ALT(NDAYS)                                 CLE064
      ***  Days and Frequency Codes                                                           CLE064
     D RAARR           S              8    DIM(21) CTDATA                                     CLE064
      ***  Repayment Amount calculation                                                       CLE064
     D REARD           DS                                                                     CLE064
     D  REARR                         8    DIM(21)                                            CLE064
     D  RDAY1                         2S 0 OVERLAY(REARR)                                     CLE064
     D  RDAY2                         5S 0 OVERLAY(REARR:3)                                   CLE064
     D  RFREQ                         1    OVERLAY(REARR:8)                                   CLE064
      ***  Internal DS for Repayment Amount                                                   CLE064
      *
     D NUM             S              1    DIM(9)
      ***  Number array
     D AMTAB           S              1    DIM(15)
      ***  Loan currency repayment amount
      *
     D ExtData       E DS                  EXTNAME(LECLEXPD)
      ***  LE (CLIP) Extra Data - File (D/B) format
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP086
      ***  External DS for switchable features                                                CAP086
      *                                                                                       CAP086
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External DS for branch details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ***  Base rate codes
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)                                 246516
      ***  Historic Base rate codes                                                          246516
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                MD034449
     D                                     PREFIX(DL_)                                      MD034449
      ** External DS for Dealing Details                                                    MD034449
                                                                                            MD034449
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D ValidLnCl     E DS                  EXTNAME(LEVCLILPD)
      ***  Valid Loans CL layout -> CLOANCL
     D                                     PREFIX(C)
      *
     D ValidLnCk     E DS                  EXTNAME(LEVCLIKPD)
      ***  Valid Loans CK layout -> CLOANCK
      *
     D TranInScr1    E DS                  EXTNAME(LECLI1PD)                                 BUG3721
      ** Incoming Transaction Screen 1                                                       BUG3721
                                                                                             BUG3721
     D TranInScr2    E DS                  EXTNAME(LECLI2PD)
      ***  Incoming Transaction
                                                                                             BUG8526
     D TranInScr3    E DS                  EXTNAME(LECLI3PD)                                 BUG8526
      ** Incoming Transaction screen 3                                                       BUG8526
      *
     D TranInScr7    E DS                  EXTNAME(LECLI7PD)                                MD053143
     D  TrCurPR                1     30                                                     MD053143
     D  TrLocPR               31     60                                                     MD053143
      ** Incoming Transaction - Business Day Conv Screen                                    MD053143
                                                                                            MD053143
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL) PREFIX(@@)
      * (Current) Loans record CL in file Format

     D OKFlags1DS    E DS                  EXTNAME(LEECLI1PD)                                BUG3721
      ** Flags to indicate whether transaction fields are valid on 1st screen                BUG3721
      *
     D OKFlagsDS     E DS                  EXTNAME(LEECLI2PD)
      ***  Flags to indicate whether transaction fields are valid
      *
                                                                                              CAP086
      ** Interface Data Format Definition File format                                         CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
     D                 DS
      ***  Format amount returned by standard subroutine ZFRPED
     D  ZOUT22                 1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *
     D                 DS
      ***  Data structure of key list used in chaining to FCLTY
      *
     D  FCTREC                 1     12
     D**WFCNUM**               1      6  0                                                    CSD027
     D  WFCNUM                 1      6A                                                      CSD027
     D  WFFACT                 7      9  0
     D  WFFCNO                10     11  0
     D  WFRCTP                12     12
      *
     D                 DS
      ***  Separate date values
      *
     D  WDATE                  1      6
     D  WDAT1                  1      2
     D  WDAT2                  3      4
     D  WDAT3                  5      6
      *
     D  TransData      DS           500
      ***  Shared data
      *
     D  WLNPT                  1      2  0
     D  W72TP                  3      4
     D  BASER                  5     15  7
     D  WSVBX                 16     28  8
     D  WBMIN                 29     29
     D  WSVDD                 30     34  0
     D  WSVVD                 35     39  0
     D  WSVAM                 40     52  0
     D  WSVRS                 53     63  7
     D**FCUSM***              64     69  0                                                    CSD027
     D  FCUSM                 64     69A                                                      CSD027
     D  FTYPM                 70     72  0
     D  FSEQM                 73     74  0
     D  FCXRM                 75     87  8
     D  FMDIM                 88     88
     D  ORBRM                 89     91
     D  CRSKM                 92     93
     D  LINDM                 94     96
     D  PRFCM                 97    100
     D  ACOFM                101    102
     D  FCCYM                103    105
     D  FCLBM                106    108
     D  MCRAM                109    109
     D  PTYPM                110    111  0
     D  RLDTM                112    116  0
     D  NBRAM                117    118  0
     D  NCASM                119    119  0
     D  NCHIM                120    120
     D  NCCYM                121    123
     D  NFCEM                124    136  8
     D  NFMDM                137    137
     D  NBCEM                138    150  8
     D  NBMDM                151    151
     D  CNUMM                152    157
     D  BRCAM                158    160
     D  CCYM                 161    163
     D  CPAMM                164    176  0
     D  DDATM                177    181  0
     D  VDATM                182    186  0
     D  MDATM                187    191  0
     D  PSAMM                192    204  0
     D  WSVFX                205    217  8
     D  WFMIN                218    218
     D  FCCYF                219    221
     D  WLPFI                222    222
     D  WPASI                223    223
     D**WPTFC***             224    229  0                                                    CSD027
     D  WPTFC                224    229A                                                      CSD027
     D  WPTFT                230    232  0
     D  WPTFN                233    234  0
     D  WACEI                235    235
     D  WCBLI                236    236
     D  WORMD                237    241  0
     D  WORTI                242    254  0
     D  WSVMG                255    261  5
     D  WSVWT                262    272  7
     D  WOSDB                273    275
     D  WOMDB                276    278
     D  W#OIDT               279    283  0
     D  WTOTI                284    296  0
     D  WPTFR                297    300
     D  WFSRP                301    311  7
     D  WSVFA                312    324  0
     D  NBDPM                325    325  0
     D  WSVCN                326    331
     D  WRISP                332    332
     D  NYET                 333    333
     D  WFLAG                334    334
     D  WCDPL                335    335  0
     D  WCDPF                336    336  0
     D  WSVTX                337    338  0
     D  WTXND                339    340  0
     D  S#ICBS               341    341  0
     D  WSVRAM               342    354  0
     D  WSVRAP               355    367  0
     D  W@FCRA               368    382
     D  W@RAMT               383    397
     D  W#CCY                398    400
     D  W#FCY                401    403
     D  WSVAM2               404    416  0
     D  WSVIN                417    417
     D  WSVRT                418    430  8
     D  W@NRPD               431    435  0
     D  ACOFF                436    437
     D  SYINF                438    438
     D  WAGENT               439    444
     D**ANUM****             445    450  0                                                    CSD027
     D  ANUM                 445    450A                                                      CSD027
     D**CNUMF***             451    456  0                                                    CSD027
     D  CNUMF                451    456A                                                      CSD027
     D**PMFC*****            457    462  0                                                    CLE106
     D**W#PMFC***            457    462  0                                              CLE106CSD027
     D  W#PMFC               457    462A                                                      CSD027
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D  WLIND                471    473
     D  CRSKF                474    475
     D  WCHGA                476    488  0                                                   BUG3721
     D  WLCCD                489    491                                                      BUG3721
     D  WPRCS2               492    492                                                      BUG3721
      *
     D  DataOldRcd     DS           500
      ***  Fields used in setting confirmation indicators (old record)
      *
     D  OMDAT                  1      5  0
     D  ONIDT                  6     10  0
     D  ONRPD                 11     15  0
     D  OIFDY                 16     17  0
     D  OIPFR                 18     18
     D  ORDYN                 19     20  0
     D  ORFRQ                 21     21
     D  ORAMT                 22     34  0
     D  OSDST                 35     36  0
     D  STNOSX                37     38
     D***OOSDA**               37     48                                                      CGL029
     D  QQOSD1                37     48                                                       CGL029
     D  OTSTN                 49     58
     D  OFACO                 59     68
     D  OSPI1                 69     98
     D  OSPI2                 99    128
     D  OSPI3                129    158
     D  OSPI                  69    158
     D  OMDST                159    160  0
     D  MTNOSX               161    162
     D***OOMDA**              161    172                                                      CGL029
     D  QQOMD1               161    172                                                       CGL029
     D  OTMAN                173    182
     D  MATYX                159    182
     D  OINTR                183    193  7
     D  ORLDT                194    198  0
     D  ORLFQ                199    199
     D  ORLDY                200    201  0
     D  OOSDA                202    219                                                       CGL029
     D  OOMDA                220    237                                                       CGL029
     D  CONF1                  1     34
     D  LINK1                  6     34
     D  CONF2                 35    158
     D  LINK2                183    201
      *
     D  DataNewRcd     DS           500
      ***  Fields used in setting confirmation indicators (new record)
      *
     D  WSVMD                  1      5  0
     D  WSVID                  6     10  0
     D  WSVRP                 11     15  0
     D  WIFDY                 16     17  0
     D  WRDYN                 19     20  0
     D  SRFRQ                 21     21
     D  WSVRA                 22     34  0
     D  WSDST                 35     36  0
     D  STNOS                 37     38
     D***WOSDA**               37     48                                                      CGL029
     D  QQOSD2                37     48                                                       CGL029
     D  WTSTN                 49     58
     D  WFACO                 59     68
     D  DDSPI1                69     98
     D  DDSPI2                99    128
     D  DDSPI3               129    158
     D  DDSPI                 69    158
     D  WMDST                159    160  0
     D  MTNOS                161    162
     D***WOMDA**              161    172                                                      CGL029
     D  QQOMD2               161    172                                                       CGL029
     D  WTMAN                173    182
     D  WREC                 159    182
     D  WINTT                183    193  7
     D  WSVRD                194    198  0
     D  SRLFQ                199    199
     D  WRLDY                200    201  0
     D  WOSDA                202    219                                                       CGL029
     D  WOMDA                220    237                                                       CGL029
     D  CONFS1                 1     34
     D  LINKS1                 6     34
     D  CONFS2                35    158
     D  LINKS2               183    201
                                                                                             BUG3721
     D REPAY3          DS                                                                    BUG3721
     D  SVDAT                  1      6                                                      BUG3721
     D  SCPAM                  7     20                                                      BUG3721
     D  SMDAT                 21     26                                                      BUG3721
     D  SCALC                 27     27                                                      BUG3721
     D  SRAMT                 28     42                                                      BUG3721
     D  SREPT                 43     43                                                      BUG3721
     D  SPDDI                 44     44                                                      BUG3721
     D  SNRPD                 45     50                                                      BUG3721
     D  SRDYN                 51     52                                                      BUG3721
     D  SSPIN                 53     53                                                      BUG3721
     D  SRTSP                 54     65                                                      BUG3721
     D  SBRTT                 66     67                                                      BUG3721
     D REPY3B          DS                                                                    BUG3721
     D  WREPY3                 1     68                                                      BUG3721
     D  WSRAMT                28     42                                                      BUG3721
     D                 DS                                                                   BUG22311
      ***  Data structure for Date Field YYYYMMDD                                           BUG22311
     D  ADATEA                 1      8  0                                                  BUG22311
     D  ADYY1                  1      4  0                                                  BUG22311
     D                 DS                                                                   BUG22311
      ***  Data structure for Date Field YYYYMMDD                                           BUG22311
     D  ADATEB                 1      8  0                                                  BUG22311
     D  ADYY2                  1      4  0                                                  BUG22311
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
      ***  Index for arrays of of warning message ids etc
     D CAP086          S              1                                                       CAP086
     D WFXRT           S             11  7                                                    CLE035
     D WBASR           S             11  7                                                    CLE035
     D WEAIR           S             15  8                                                    CLE143
     D WIsRisk         S              1                                                       CLE035
     D*#DDRTSP**       S             11  7                                         BUG20318 BUG21853
                                                                                              CER043
     D CER043          S              1                                                       CER043
     D CAS009          S              1                                                       CLE143
     D CLE143          S              1                                                       CLE143
     D CRE073          S              1    INZ('N')                                           CRE073
     D CLE011          S              1                                                     MD031736
     D RateFixSt       S              1                                                     MD031736
     D TMCNSP          S             11P 7                                                    CRE073
     D TMBSRT          S             11P 7                                                    CRE073
     D PNewSpread      S             11P 7                                                    CRE073
     D PFinalRate      S             11P 7                                                  AR847249
     D PModule         S              6                                                       CRE073
     D PCurset         S              2  0                                                    CRE073
     D CLE141          S              1                                                     MD053143
     D PInpOutDay      S              5  0                                                  MD053143
     D PDaysBck        S              2S 0                                                  MD053143
     D PMODE           S              1                                                     MD053143
     D StartRateFix    S              1                                                     MD053143
      *                                                                                       CLE064
     D XDAYS           S              4S 0                                                    CLE064
     D*XFREQ****       S              1  0                                           CLE064 AR747825
     D*YFREQ****       S              1  0                                           CLE064 AR747825
     D XFREQ           S              2  0                                                  AR747825
     D YFREQ           S              2  0                                                  AR747825
      **                                                                                    MD031736
     D PSysVal01       S             20A   INZ('UseRateFixingDayatSt')                      MD031736
     D PCurSet01       S            200A                                                    MD031736
     D*PSysVal02       S             20A                                           MD031736 MD053143
     D PSysVal02       S             20A   INZ('RateFixingAtStartDat')                      MD053143
     D PCurSet02       S            200A                                                    MD031736
     D PSysVal03       S             20A                                                    MD031736
     D PCurSet03       S            200A                                                    MD031736
     D PSysVal04       S             20A                                                    MD031736
     D PCurSet04       S            200A                                                    MD031736
     D PSysVal05       S             20A                                                    MD031736
     D PCurSet05       S            200A                                                    MD031736
     D PSysVal06       S             20A                                                    MD031736
     D PCurSet06       S            200A                                                    MD031736
     D PSysVal07       S             20A                                                    MD031736
     D PCurSet07       S            200A                                                    MD031736
     D PSysVal08       S             20A                                                    MD031736
     D PCurSet08       S            200A                                                    MD031736
     D PSysVal09       S             20A                                                    MD031736
     D PCurSet09       S            200A                                                    MD031736
     D PSysVal10       S             20A                                                    MD031736
     D PCurSet10       S            200A                                                    MD031736
     D PERCD           S              1P 0                                                  MD034449
     D PAMT            S             15P 0                                                  MD034449
      ** Alpha field for numeric validation                                                 MD034449
     D @@ALPH          S             16A                                                    MD034449
      ** Millions/Thousands id (Y=function on)                                              MD034449
     D @@MTID          S              1A                                                    MD034449
      ** Amount calculation field                                                           MD034449
     D @@AMT           S             15  0                                                  MD034449
      ** Error code                                                                         MD034449
     D @@ERCD          S              1  0                                                  MD034449
      ** Number of decimal places                                                           MD034449
     D @@IDP           S              3  0                                                  MD034449
      ** Number of integers                                                                 MD034449
     D @@IINT          S              3  0                                                  MD034449
     D PZASignOk       S              1A                                                    MD034449
     D PZFld17         S             17A                                                    MD034449
     D PZDig           S              2P 0                                                  MD034449
     D PZDec           S              1P 0                                                  MD034449
     D PZSDCSP         S              1A                                                    MD034449
     D PZOut15         S             15A                                                    MD034449
     D PZFSign         S              1A                                                    MD034449
     D/COPY WNCPYSRC,LEH00617
      *
      ** +--------------------------------------+
      ** ¦ Rename fields                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
      *
     IFCLTYFMF
     I              RECI                        RECIF
     I              CNUM                        CNUMF
     I              BRCA                        BRCAF
     I              FCCY                        FCCYF
     I              DTAP                        DTAPF
     I              DTEX                        DTEXF
     I              COMD                        COMDF
     I              CDTE                        CDTEF
     I              MCCY                        MCCYF
     I              MCSI                        MCSIF
     I              CRSK                        CRSKF
     I              NAR1                        NAR1F
     I              NAR2                        NAR2F
     I              NAR3                        NAR3F
     I              NAR4                        NAR4F
     I              ACOF                        ACOFF
     I              ORBR                        ORBRF
     I              ORED                        OREDF
     I              TNLU                        TNLUF
     I              SYIN                        SYINF
     I              XUSR                        XUSRF
     I              RCSI                        RCSIF
     I              OSDB                        OSDBF
     I              OMDB                        OMDBF
     I              RSTM                        RSTMF
     I              RONS                        RONSF
     I              RIBN                        RIBNF
     I              RIBA                        RIBAF
     I              ROBN                        ROBNF
     I              ROCN                        ROCNF
     I              PSTM                        PSTMF
     I              PONS                        PONSF
     I              PIBN                        PIBNF
     I              PIBA                        PIBAF
     I              POBN                        POBNF
     I              POCN                        POCNF
     I              RCRN                        RCRNF
     I              RCRA                        RCRAF
     I              RVNO                        RVNOF
     I              AWBN                        AWBNF
     I              AWBA                        AWBAF
     I              BENN                        BENNF
     I              BENA                        BENAF
     I              DTP1                        DTP1F
     I              DTP2                        DTP2F
     I              DTP3                        DTP3F
     I              DTP4                        DTP4F
     I              DCHG                        DCHGF
     I              BTB1                        BTB1F
     I              BTB2                        BTB2F
     I              BTB3                        BTB3F
     I              BTB4                        BTB4F
     I              BTB5                        BTB5F
     I              BTB6                        BTB6F
     I              CVMR                        CVMRF
     I              PCOB                        PCOBF
     I              SCCY                        SCCYF
     I              ICCY                        ICCYF
      *
     IFCLTYFNF
     I              RECI                        RECIF
     I              CNUM                        CNUMF
     I              CALC                        CALCF
     I              ORED                        OREDF
     I              TNLU                        TNLUF
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LECLIP2V02
      *
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LECLIP2V03
      *
      ***  Validation for screen details 2
      *    ===============================
      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      /COPY WNCPYSRC,LECLIP2V04
     C*****CLE035        IFNE      'Y'                                               CLE035 BUG10225
     C     CLE036        IFNE      'Y'                                                      BUG10225
      *
      ***  Validate base rate type
      *
     C                   EXSR      SRBRTT
     C                   ENDIF                                                                CLE035
      *
      /COPY WNCPYSRC,LECLIP2V05
      *
      ***  Validate base rate change indicator
      *
     C                   EXSR      SRCHIN
      *
      /COPY WNCPYSRC,LECLIP2V06
     C*****CLE035        IFEQ      'Y'                                               CLE035 BUG10225
     C     CLE036        IFEQ      'Y'                                                      BUG10225
      *                                                                                       CLE035
      ** Validate Rates (Base and Fixed)                                                      CLE035
      *                                                                                       CLE035
     C                   EXSR      SRRATE                                                     CLE035
     C                   ELSE                                                                 CLE035
      *
      ***  Validate spread rate
      *
     C                   IF        CRE073 = 'N'                                               CRE073
     C                   EXSR      SRRTSP
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CLE035
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
                                                                                              CRE073
      ** Validate Contractual Spread/Sign                                                     CRE073
                                                                                              CRE073
     C                   EVAL      PSCRF  = DDCNSP                                          AR993993
     C                   EVAL      PNDIG  = 4                                               AR993993
     C                   EVAL      PNDEC  = 7                                               AR993993
     C                   CALL      'ZALIGN'      PPAR1                                      AR993993
     C                   MOVE      PRVAL         WSVRS                                      AR993993
     C                   IF        WSVRS <> *ZEROS                                          AR993993
     C                             OR  DDBRTT  <> ' '                                       AR993993
     C                             OR (WLNPT <>  70                                         AR993993
     C                             AND WLNPT <>  71                                         AR993993
     C                             AND WLNPT <>  72                                         AR993993
     C                             AND WPTFC  = *BLANKS                                     AR993993
     C                             AND WPTFT  = *ZEROS                                      AR993993
     C                             AND WPTFN  = *ZEROS)                                     AR993993
     C                                                                                      AR993993
     C                   EXSR      SRSPSG                                                     CRE073
     C                                                                                      AR993993
     C                   ENDIF                                                              AR993993
                                                                                              CRE073
      ** Validate Rounding Method                                                             CRE073
                                                                                              CRE073
     C                   IF        DDCNSPOK <> 'N'                                            CRE073
                                                                                              CRE073
     C                   EXSR      SRRNDM                                                     CRE073
                                                                                              CRE073
      ** Validate Rounding Fraction/Decimal                                                   CRE073
                                                                                              CRE073
     C                   EXSR      SRRNDF                                                     CRE073
                                                                                              CRE073
      ** If all interest rate rounding related fields are valid                               CRE073
      ** compute for the new spread rate                                                      CRE073
                                                                                              CRE073
     C                   IF        DDCNSGOK <> 'N' AND                                        CRE073
     C                             DDRDMTOK <> 'N' AND                                        CRE073
     C                             DDRDFDOK <> 'N' AND                                        CRE073
     C                             DDBRTTOK <> 'N' AND                                        CRE073
     C                             DDBASROK <> 'N'                                            CRE073
                                                                                              CRE073
     C                   Z-ADD     TMCNSP        CCLCNSP                                      CRE073
     C                   MOVEL     DDCNSG        CCLCNSG                                      CRE073
     C                   MOVEL     DDRDMT        CCLRDMT                                      CRE073
     C                   MOVEL     DDRDFD        CCLRDFD                                      CRE073
                                                                                              CRE073
     C                   EXSR      SRSPRT                                                     CRE073
     C                                                                                        CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      *
      /COPY WNCPYSRC,LECLIP2V07
      *
      ***  Validate spread indicator
      *
     C                   EXSR      SRSPIN
      *                                                                                     AR804863
      ** Skip validation process if action is reject.                                       AR804863
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   EXSR      SRRSFD                                                   AR804863
     C                   RETURN                                                             AR804863
     C                   ENDIF                                                              AR804863
      *
      /COPY WNCPYSRC,LECLIP2V08
      *
      ***  Validate interest date
      *
     C                   EXSR      SRNIDT
      *
      /COPY WNCPYSRC,LECLIP2V09
      *
      ***  Validate interest frequency
      *
     C                   EXSR      SRIPFR
      *
      /COPY WNCPYSRC,LECLIP2V10
      *
      ***  Validate interest day number
      *
     C                   EXSR      SRIFDY
      *
      /COPY WNCPYSRC,LECLIP2V11
      *
      ***  Validate interest validation basis
      *
     C                   EXSR      SRCALC
      *
      /COPY WNCPYSRC,LECLIP2V13
      *
      ***  Validate margin and negative indicator
      *
     C                   EXSR      SRMANI
      *
      /COPY WNCPYSRC,LECLIP2V14
      *
      ***  Validate withholding tax rate
      *
     C                   EXSR      SRWTRT
      *
      /COPY WNCPYSRC,LECLIP2V15
      *
      ***  Validate withholding tax indicator
      *
     C                   EXSR      SRWTIN
      *
      /COPY WNCPYSRC,LECLIP2V16
      *
      ***  Validate capitalisation indicator
      *
     C                   EXSR      SRINTC
      *
      /COPY WNCPYSRC,LECLIP2V17
      *
      ***  Validate round-down indicator
      *
     C                   EXSR      SRRDFC
      *
      /COPY WNCPYSRC,LECLIP2V12
      *
      ***  Validate interest/discount amount
      *
     C                   EXSR      SRIPRD
      *
      /COPY WNCPYSRC,LECLIP2V18
      *
      ***  Validate accrual indicator
      *
     C                   EXSR      SRADDI
                                                                                             BUG3721
      ** Validate the following if CLE028 is switched on                                     BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
                                                                                             BUG3721
      ** Validate Add on Interest indicator                                                  BUG3721
                                                                                             BUG3721
     C                   EXSR      SRADIF                                                    BUG3721
                                                                                             BUG3721
      ** Validate Add on Charges indicator                                                   BUG3721
                                                                                             BUG3721
     C                   EXSR      SRADCF                                                    BUG3721
                                                                                             BUG3721
      ** Validate Include Charges on Interest and Charge Amount                              BUG3721
                                                                                             BUG3721
     C                   EXSR      SRICIFCHGA                                                BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                              CLE143
      **  Validate Effective Annual Interest Rate                                             CLE143
                                                                                              CLE143
     C                   IF        CLE143 = 'Y' AND                                           CLE143
     C                             CAS009 = 'N'                                               CLE143
     C                   EXSR      SREAIR                                                     CLE143
     C                   ENDIF                                                                CLE143
      *
      /COPY WNCPYSRC,LECLIP2V19
      *
      ***  Validate repayment type
      *
     C                   EXSR      SRREPT
      *
      /COPY WNCPYSRC,LECLIP2V20
      *
      ***  Validate loan currency repayment amount
      *
     C                   EXSR      SRRAMT
      *
      /COPY WNCPYSRC,LECLIP2V21
      *
      *****Validate*facility*currency*repayment*amount*****************                      BUG3721
      *****(When*facility*details*are*valid)***************************                      BUG3721
      **********                                                                             BUG3721
     C*****CLE006        IFEQ      'Y'                                                       BUG3721
     C*****CLE007        OREQ      'Y'                                                       BUG3721
     C**********         EXSR      SRFCRA                                                    BUG3721
     C**********         ENDIF                                                               BUG3721
      *
      /COPY WNCPYSRC,LECLIP2V22
      *
      ***  Validate repayment date
      *
     C                   EXSR      SRNRPD
      *
      /COPY WNCPYSRC,LECLIP2V23
      *
      ***  Validate repayment frequency/day number
      *
     C                   EXSR      SRRFRQ
      *                                                                                      BUG9008
      ***  Validate CLE005 fields, payment taken/due day and grace days                      BUG9008
      ***  for interest/repayment                                                            BUG9008
      *                                                                                      BUG9008
     C     CLE005        IFEQ      'Y'                                                       BUG9008
     C                   EXSR      SRCL05                                                    BUG9008
     C                   ENDIF                                                               BUG9008
      *
      /COPY WNCPYSRC,LECLIP2V24
                                                                                             BUG3721
      ** Validate Repayment Amount/ First Repayment Date                                     BUG3721
                                                                                             BUG3721
     C                   EXSR      SRFRPD                                                    BUG3721
                                                                                             BUG3721
      ***  Validate facility currency repayment amount                                       BUG3721
      ***  (When facility details are valid)                                                 BUG3721
      *                                                                                      BUG3721
     C     CLE006        IFEQ      'Y'                                                       BUG3721
     C     CLE007        OREQ      'Y'                                                       BUG3721
     C                   EXSR      SRFCRA                                                    BUG3721
     C                   ENDIF                                                               BUG3721
      *
      ***  Validate bill/telex indicator
      *
     C                   EXSR      SRBTIN
      *
      /COPY WNCPYSRC,LECLIP2V25
      *
      ***  Validate billing days
      *
     C                   EXSR      SRBLDY
      *
      /COPY WNCPYSRC,LECLIP2V26
      *
      *****Validate*CLE005*fields,*payment*taken/due*day*and*grace*days                      BUG9008
      *****for*interest/repayment**************************************                      BUG9008
      *****************************************************************                      BUG9008
     C*****CLE005        IFEQ      'Y'                                                       BUG9008
     C**********         EXSR      SRCL05                                                    BUG9008
     C**********         ENDIF                                                               BUG9008
      *
      /COPY WNCPYSRC,LECLIP2V27
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      /COPY WNCPYSRC,LECLIP2V28
      *
      ***  Save the loan reference for warning
      *
     C                   MOVEL     DDLNR2        SaveDDLNR2        6
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBRTT - Validate base rate type                             *
      *****************************************************************
     C     SRBRTT        BEGSR
      *
     C                   Z-ADD     *ZEROS        BASER
     C     DDBRTT        IFEQ      '00'
     C                   MOVE      *BLANKS       DDBRTT
     C                   ENDIF
      *
     C     DDBRTT        IFNE      *BLANKS
     C                   MOVE      CCLCCY        @KEY1
     C                   MOVE      DDBRTT        @KEY2
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1             3
     C                   PARM                    @KEY2             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      BABSRC        DDBRTT
     C                   ENDIF
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDBRTT
     C                   ENDIF
      *
      ***  If not existing base rate code, or base rate change
      ***  facility is not Y, or base rate currency is different from
      ***  loan currency, invalidate entry
      *
     C     @RTCD         IFNE      *BLANKS
     C*****BPBRCF        ORNE      'Y'                                                      AR826115
     C     BPBRCF        ORNE      'Y'                                                      MD034840
     C     CCLCCY        ORNE      BACYCD
     C                   MOVE      'N'           DDBRTTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRTT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0139'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDBRTTOK      IFNE      'N'
     C     DDBRTT        ANDNE     *BLANKS
     C     BPBRCF        ANDEQ     'Y'
     C     WSVVD         IFLT      BAVDNR
     C     StartRateFix  OREQ      'Y'                                                      MD053143
     C                   Z-ADD     WSVVD         ZDAYNO                                       246516
     C                   MOVE      @KEY1         ZCCY                                         246516
     C                   MOVE      *BLANKS       ZLOC                                         246516
     C     RateFixSt     Ifeq      'Y'                                                      MD031736
     C                   MOVEL     DDRFDY        ZNRDYS                                       246516
     C                   Else                                                               MD031736
     C                   Z-Add     0             ZNRDYS                                     MD031736
     C                   Endif                                                              MD031736
      *                                                                                     MD053143
     C     CLE141        IFEQ      'Y'                                                      MD053143
     C                   CALL      'LEZBDYRF'                                               MD053143
     C                   PARM      WSVVD         PInpOutDay                                 MD053143
     C                   PARM      ZNRDYS        PDaysBck                                   MD053143
     C                   PARM                    TrCurPR                                    MD053143
     C                   PARM                    TrLocPR                                    MD053143
     C                   PARM      'B'           PMODE                                      MD053143
     C                   PARM      *ZEROS        @KEY3                                      MD053143
     C                   ELSE                                                               MD053143
     C                   EXSR      ZBKDT                                                      246516
     C                   MOVEL     ZDYNBR        @KEY3                                        246516
     C                   ENDIF                                                              MD053143
     C                   MOVEL     DDBRTT        @KEY2N                                       246516
      *                                                                                     MD053143
     C     StartRateFix  IFEQ      'Y'                                                      MD053143
     C     @KEY3         ANDGE     BAVDNR                                                   MD053143
     C                   Z-ADD     BANBRT        BASER                                      MD053143
     C                   ELSE                                                               MD053143
     C                   CALL      'AOBSHSR0'                                                 246516
     C                   PARM      *BLANKS       @RTCD                                        246516
     C                   PARM      '*KEY   '     @OPTN                                        246516
     C                   PARM                    @KEY1             3                          246516
     C                   PARM                    @KEY2N            2 0                        246516
     C                   PARM                    @KEY3             5 0                        246516
     C     SDBSHS        PARM      SDBSHS        DSFDY                                        246516
     C     @RTCD         IFEQ      *BLANKS                                                    246516
     C                   Z-ADD     G0CBSR        BASER                                        246516
     C                   ELSE                                                                 246516
     C                   Z-ADD     BACBSR        BASER
     C                   END                                                                  246516
     C                   ENDIF                                                              MD053143
     C                   ELSE
     C                   Z-ADD     BANBRT        BASER
     C                   ENDIF
     C                   ENDIF
      *
     C     DDBRTTOK      IFNE      'N'
     C                   MOVE      DDBRTT        CCLBRTT
     C                   Z-ADD     BASER         CCLBRTE
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCHIN - Validate base rate change indicator                 *
      *****************************************************************
     C     SRCHIN        BEGSR
     C                   MOVE      '0'           *IN48
      *
      ***  Must be 'D', 'R', 'N' or ' '
      ***  Must be blank if base rate not entered or '00' on insert
      *
     C     DDCHIN        IFNE      *BLANK
     C     DDCHIN        ANDNE     'D'
     C     DDCHIN        ANDNE     'R'
     C     DDCHIN        ANDNE     'N'
      *
     C     CCLCHTP       OREQ      'I'
     C     DDBRTT        ANDEQ     *BLANKS
     C     DDBASR        ANDEQ     *BLANKS                                                    CLE106
     C     DDCHIN        ANDNE     *BLANK
     C     DDPTFC        ANDEQ     *Blanks                                                    CLE106
      *
     C                   MOVE      '1'           *IN48
     C                   ENDIF
      *
      ***  Must be 'N' or blank for discounted loans/parts purhased/
      ***  parts sold
      ** must be 'N' or blank for flat rate personal loans                                    CLE028
      *
     C     DDCHIN        IFNE      'N'
     C     DDCHIN        ANDNE     *BLANK
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C     WLNPT         OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      '1'           *IN48
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN48         IFEQ      '1'
     C                   MOVE      'N'           DDCHINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCHIN'      FldNamXAr(Idx)
     C     WLNPT         IFEQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C     DDBRTT        ANDNE     *BLANKS                                                   BUG3721
     C                   MOVEL     'LEL0554'     MsgIDXAr(Idx)                               BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVEL     'LEL0143'     MsgIDXAr(Idx)
     C                   ENDIF                                                               BUG3721
     C                   ENDIF
      *
     C     DDCHINOK      IFNE      'N'
     C                   MOVEL     DDCHIN        CCLCHIN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTSP - Validate spread rate                                *
      *****************************************************************
     C     SRRTSP        BEGSR
      *
     C**********         MOVE      *BLANKS       PSCRF                                      MD034449
     C**********         MOVE      DDRTSP        PSCRF                                      MD034449
     C**********         Z-ADD     4             PNDIG                                      MD034449
     C**********         Z-ADD     7             PNDEC                                      MD034449
     C**********         CALL      'ZALIGN'      PPAR1                                      MD034449
     C**********         MOVE      PRVAL         WSVRS                                      MD034449
      *                                                                                     MD034449
     C                   Z-ADD     7             @@IDP                                      MD034449
     C                   Z-ADD     4             @@IINT                                     MD034449
     C                   MOVE      *BLANKS       @@ALPH                                     MD034449
     C                   MOVE      DDRTSP        @@ALPH                                     MD034449
     C                   MOVE      'N'           @@MTID            1                        MD034449
      *                                                                                     MD034449
     C                   EXSR      VALAMT                                                   MD034449
      *
      * If CLE170 is on, and Loan passes the criteria, suppress the error message             CLE170
      *                                                                                       CLE170
     C     CLE170        IFEQ      'Y'                                                        CLE170
     C     WLNPT         ANDNE     63                                                         CLE170
     C     WLNPT         ANDNE     65                                                         CLE170
     C     WLNPT         ANDNE     67                                                         CLE170
     C     WLNPT         ANDNE     80                                                       MD055074
      * CLE170 is on, Loan is not a Discount Loan - do nothing.                               CLE170
     C                   ELSE                                                                 CLE170
      * Loan does not meet criteria, or CLE170 is off - normal processing                     CLE170
      *                                                                                       CLE170
      ***  If loan is not a guarantee and no base rate has been
      ***  specified, spread rate must be entered
      *
     C*****PRTCD         IFNE      *BLANKS                                                  MD034449
     C     @@ERCD        IFNE      0                                                        MD034449
     C     WLNPT         ORNE      70
     C     WLNPT         ANDNE     71
     C     WLNPT         ANDNE     72
     C     DDBRTT        ANDEQ     *BLANKS
     C*****WSVRS         ANDEQ     *ZEROS                                                   MD034449
     C     @@AMT         ANDEQ     *ZEROS                                                   MD034449
                                                                                            BUG10225
      ** Bypass validation if loan is a participant                                         BUG10225
                                                                                            BUG10225
     C*****WPTFC         ANDEQ     *ZEROS                                           BUG10225 CSD027A
     C     WPTFC         ANDEQ     *Blanks                                                   CSD027A
     C     WPTFT         ANDEQ     *ZEROS                                                   BUG10225
     C     WPTFN         ANDEQ     *ZEROS                                                   BUG10225
                                                                                            BUG10225
     C                   MOVE      'N'           DDRTSPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRTSP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0140'     MsgIDXAr(Idx)
     C                   ENDIF
      *                                                                                     MD055219
     C     BASER         IFEQ      *ZEROS                                                   MD055219
     C     @@AMT         ANDEQ     *ZEROS                                                   MD055219
     C     WLNPT         IFEQ      63                                                       MD055219
     C     WLNPT         OREQ      65                                                       MD055219
     C     WLNPT         OREQ      67                                                       MD055219
     C     WLNPT         OREQ      80                                                       MD055219
     C                   MOVE      'N'           DDRTSPOK                                   MD055219
     C                   ADD       1             Idx                                        MD055219
     C                   MOVEL     'DDRTSP'      FldNamXAr(Idx)                             MD055219
     C                   MOVEL     'LEL0140'     MsgIDXAr(Idx)                              MD055219
     C                   ENDIF                                                              MD055219
     C                   ENDIF                                                              MD055219
      *
     C                   ENDIF                                                                CLE170
      *                                                                                       CLE170
     C     DDRTSPOK      IFNE      'N'
     C                   MOVE      @@ALPH        DDRTSP                                     MD034449
      *                                                                                     MD034449
     C                   MOVE      *BLANKS       PZFld17                                    MD034449
     C     RetCodeOut    IFEQ      *BLANKS                                                  MD034449
     C                   MOVEL     DDRTSP        PZFld17                                    MD034449
     C                   END                                                                MD034449
     C                   Z-ADD     4             PZDig                                      MD034449
     C                   Z-ADD     7             PZDec                                      MD034449
      *                                                                                     MD034449
     C                   EXSR      FMTAMT                                                   MD034449
     C                   MOVE      PZOut15       WNumBas          11 7                      MD034449
     C                   IF        DDNGVI = 'Y'                                             MD034449
     C                   Z-SUB     WNumBas       WSVRS                                      MD034449
     C                   ELSE                                                               MD034449
     C                   Z-ADD     WNumBas       WSVRS                                      MD034449
     C                   ENDIF                                                              MD034449
     C                   Z-ADD     WSVRS         CCLRTSP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE035
      *  SRRATE - Validate Fixed and Base Rate                        *                       CLE035
      *****************************************************************                       CLE035
     C     SRRATE        BEGSR                                                                CLE035
      *                                                                                       CLE035
      ** If loan is type 70, 71, 72 classify as Risk (guarantee) loan                         CLE035
                                                                                              CLE035
     C                   EVAL      WIsRisk = 'N'                                              CLE035
     C                   IF        WLNPT = 70 Or WLNPT = 71 Or WLNPT = 72                     CLE035
     C                   EVAL      WIsRisk = 'Y'                                              CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   EVAL      CCLBASR = 0                                               BUG9634
      ** Blank Out DDRTSP if initial is '0'                                                 BUG14788
     C                   IF        DDRTSP = '0           '                                  BUG14788
     C                   Eval      DDRTSP = *BLANKS                                         BUG14788
     C                   ENDIF                                                              BUG14788
     C                   IF        DDFXRT <> *BLANKS                                          CLE035
     C                   IF        DDBRTT <> *BLANKS OR DDBASR <> *BLANKS                     CLE035
     C                             OR DDRTSP <> *BLANKS                                       CLE035
     C                             AND %TRIMR(DDRTSP) <> '0'                                BUG23696
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   MOVEL     'DDFXRT'      FldNamXAr(Idx)                               CLE035
     C**********         MOVEL     'LEL0702'     MsgIDXAr(Idx)                       CLE035 BUG11329
                                                                                            BUG11329
      ** No other rates can be entered if Fixed Rate is entered.                            BUG11329
     C                   MOVEL     'LEL0715'     MsgIDXAr(Idx)                              BUG11329
     C                   ENDIF                                                                CLE035
     C                   MOVE      *BLANKS       PSCRF                                        CLE035
     C                   MOVEL     *BLANK        WFXRT1            1                        MD055059
     C                   MOVEL     *BLANK        WFXRT3           11                        MD055059
     C                   MOVEL     DDFXRT        WFXRT1                                     MD055059
     C                   MOVE      DDFXRT        WFXRT3                                     MD055059
     C     WFXRT1        IFEQ      '-'                                                      MD055059
     C                   MOVE      WFXRT3        PSCRF                                      MD055059
     C                   ELSE                                                               MD055059
     C                   MOVE      DDFXRT        PSCRF                                        CLE035
     C                   ENDIF                                                              MD055059
     C                   Z-ADD     4             PNDIG                                        CLE035
     C                   Z-ADD     7             PNDEC                                        CLE035
     C                   CALL      'ZALIGN'      PPAR1                                        CLE035
     C                   MOVE      PRVAL         WFXRT                                        CLE035
     C     WFXRT1        IFEQ      '-'                                                      MD055059
     C                   Z-SUB     WFXRT         WFXRT                                      MD055059
     C                   ENDIF                                                              MD055059
      *                                                                                       CLE170
      ** If CLE170 is on, and Loan passes the criteria, suppress the error message            CLE170
      *                                                                                       CLE170
     C     CLE170        IFEQ      'Y'                                                        CLE170
     C     WLNPT         ANDNE     63                                                         CLE170
     C     WLNPT         ANDNE     65                                                         CLE170
     C     WLNPT         ANDNE     67                                                         CLE170
     C     WLNPT         ANDNE     80                                                       MD055074
      *                                                                                       CLE170
     C                   ELSE                                                                 CLE170
      *                                                                                       CLE035
      ***  If loan is not a guarantee and no base rate code or base                           CLE035
      ***  rate has been specified, fixed rate must not be zero                               CLE035
      *                                                                                       CLE035
     C     PRTCD         IFNE      *BLANKS                                                    CLE035
     C     DDBRTT        OREQ      *BLANKS                                                    CLE035
     C     WFXRT         ANDEQ     *ZEROS                                                     CLE035
     C     WIsRisk       ANDEQ     'N'                                                        CLE035
     C     DDBASR        OREQ      *BLANKS                                                    CLE035
     C     WFXRT         ANDEQ     *ZEROS                                                     CLE035
     C     WIsRisk       ANDEQ     'N'                                                        CLE035
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   MOVEL     'DDFXRT'      FldNamXAr(Idx)                               CLE035
     C**********         MOVEL     'LEL0701'     MsgIDXAr(Idx)                       CLE035 MD031225
     C                   MOVEL     '5021165'     MsgIDXAr(Idx)                              MD031225
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE170
      *                                                                                       CLE035
     C     DDFXRTOK      IFNE      'N'                                                        CLE035
     C                   Z-ADD     WFXRT         CCLRTSP                                      CLE035
     C                   MOVE      PRVAL         WSVRS                                        CLE035
     C     WFXRT1        IFEQ      '-'                                                      MD055059
     C                   Z-SUB     WSVRS         WSVRS                                      MD055059
     C                   ENDIF                                                              MD055059
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** .. if fixed rate is blank validate the rest of the rates                             CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CLE035
      * Convert the field in numeric                                                          249268
     C**********         MOVE      DDRTSP        #DDRTSP          11 7               249268 BUG21853
     C                   MOVE      DDRTSP        #DDRTSP          12 7                      BUG21853
     C                   MOVEL     *BLANK        WRTSP1            1                        MD055220
     C                   MOVEL     *BLANK        WRTSP3           11                        MD055220
     C                   MOVEL     DDRTSP        WRTSP1                                     MD055220
     C                   MOVE      DDRTSP        WRTSP3                                     MD055220
     C                   IF        DDRTSP <> *BLANKS                                        BUG20318
     C                   MOVE      *Blanks       PSCRF                                      MD040412
     C     WRTSP1        IFEQ      '-'                                                      MD055220
     C                   MOVE      WRTSP3        PSCRF                                      MD055220
     C                   ELSE                                                               MD055220
     C                   MOVE      DDRTSP        PSCRF                                      MD040412
     C                   ENDIF                                                              MD055220
     C                   Z-ADD     4             PNDIG                                      MD040412
     C                   Z-ADD     7             PNDEC                                      MD040412
     C                   CALL      'ZALIGN'      PPAR1                                      MD040412
     C                   IF        PRTCD = *Blanks                                          MD040412
     C**********         EVAL      #DDRTSP = %DEC(DDRTSP:12:0)                     BUG20318 AR811153
     C                   EVAL      #DDRTSP = %DEC(DDRTSP:12:7)                              AR811153
     C                   ENDIF                                                              BUG20318
     C                   ENDIF                                                              MD040412
     C     DDRTSP        IFNE      *BLANKS                                                    CLE035
     C     #DDRTSP       ANDNE     0                                                          249268
     C     CRE073        ANDNE     'Y'                                                        CRE073
     C                   EXSR      SRRTSP2                                                    CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   IF        DDBRTT <> *BLANKS                                          CLE035
     C                   IF        DDBASR <> *BLANKS                                          CLE035
     C                   MOVE      'N'           DDBASROK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   MOVEL     'DDBASR'      FldNamXAr(Idx)                               CLE035
     C                   MOVEL     'LEL0712'     MsgIDXAr(Idx)                                CLE035
     C                   ENDIF                                                                CLE035
     C                   EXSR      SRBRTT                                                     CLE035
      *                                                                                     MD055219
     C     BASER         IFEQ      *ZEROS                                                   MD055219
     C     #DDRTSP       ANDEQ     *ZEROS                                                   MD055219
     C     WLNPT         IFEQ      63                                                       MD055219
     C     WLNPT         OREQ      65                                                       MD055219
     C     WLNPT         OREQ      67                                                       MD055219
     C     WLNPT         OREQ      80                                                       MD055219
     C                   MOVE      'N'           DDFXRTOK                                   MD055219
     C                   ADD       1             Idx                                        MD055219
     C                   MOVEL     'DDFXRT'      FldNamXAr(Idx)                             MD055219
     C                   MOVEL     'LEL0140'     MsgIDXAr(Idx)                              MD055219
     C                   ENDIF                                                              MD055219
     C                   ENDIF                                                              MD055219
      ** .. if base rate code is blank, validate base rate                                    CLE035
     C                   ELSE                                                                 CLE035
     C                   MOVE      *BLANKS       PSCRF                                        CLE035
     C                   MOVE      DDBASR        PSCRF                                        CLE035
     C                   Z-ADD     4             PNDIG                                        CLE035
     C                   Z-ADD     7             PNDEC                                        CLE035
     C                   CALL      'ZALIGN'      PPAR1                                        CLE035
     C                   MOVE      PRVAL         WBASR                                        CLE035
     C     PRTCD         IFNE      *BLANKS                                                    CLE035
     C                   MOVE      'N'           DDBASROK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   MOVEL     'DDBASR'      FldNamXAr(Idx)                               CLE035
     C                   MOVEL     'LEL0713'     MsgIDXAr(Idx)                                CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE170
      ** If CLE170 is on, and Loan passes the criteria, suppress the error message            CLE170
      *                                                                                       CLE170
     C     CLE170        IFEQ      'Y'                                                        CLE170
     C     WLNPT         ANDNE     63                                                         CLE170
     C     WLNPT         ANDNE     65                                                         CLE170
     C     WLNPT         ANDNE     67                                                         CLE170
     C     WLNPT         ANDNE     80                                                       MD055074
      *                                                                                       CLE170
     C                   ELSE                                                                 CLE170
                                                                                              CLE035
      ** Reaching this point if fixed and base rates are either blank or zero                 CLE035
      ** and loan is not a risk, fixed rate becomes mandatory                                 CLE035
                                                                                              CLE035
     C                   IF        WBASR = *Zero And WIsRisk = 'N'                            CLE035
     C                   MOVE      'N'           DDFXRTOK                                     CLE035
     C                   ADD       1             Idx                                          CLE035
     C                   MOVEL     'DDFXRT'      FldNamXAr(Idx)                               CLE035
     C**********         MOVEL     'LEL0701'     MsgIDXAr(Idx)                       CLE035 MD031225
     C                   MOVEL     '5021165'     MsgIDXAr(Idx)                              MD031225
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE170
                                                                                              CLE035
     C     DDBASROK      IFNE      'N'                                                        CLE035
     C                   EVAL      CCLBASR = WBASR                                            CLE035
     C                   EVAL      CCLBRTE = WBASR                                            CLE035
     C                   EVAL      BASER = WBASR                                              CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE170
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE035
     C                   ENDSR                                                                CLE035
      *****************************************************************                       CLE035
      /EJECT                                                                                  CLE035
      *****************************************************************                       CLE035
      ***SRRTSP2*-*Different*Spread*Rate*validation*if*CLE035*is*on****              CLE035 BUG10225
      *  SRRTSP2 - Different Spread Rate validation if CLE036 is on   *                     BUG10225
      *****************************************************************                       CLE035
     C     SRRTSP2       BEGSR                                                                CLE035
                                                                                              CLE035
      ** Spread Rate must be combined with either Base Rate or Base Rate Code                 CLE035
                                                                                              CLE035
     C                   IF        DDBRTT = *Blanks And DDBASR = *Blanks                      CLE035
     C                   EVAL      DDRTSPOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNamXAr(Idx) = 'DDRTSP'                                  CLE035
     C                   EVAL      MsgIDXAr(Idx) = 'LEA0547'                                  CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Valid amount must be entered                                                         CLE035
                                                                                              CLE035
     C                   MOVEL     *BLANK        WRTSP1                                     MD055220
     C                   MOVEL     *BLANK        WRTSP3                                     MD055220
     C                   MOVEL     DDRTSP        WRTSP1                                     MD055220
     C                   MOVE      DDRTSP        WRTSP3                                     MD055220
     C                   MOVE      *Blanks       PSCRF                                        CLE035
     C     WRTSP1        IFEQ      '-'                                                      MD055220
     C                   MOVE      WRTSP3        PSCRF                                      MD055220
     C                   ELSE                                                               MD055220
     C                   MOVE      DDRTSP        PSCRF                                        CLE035
     C                   ENDIF                                                              MD055220
     C                   Z-ADD     4             PNDIG                                        CLE035
     C                   Z-ADD     7             PNDEC                                        CLE035
     C                   CALL      'ZALIGN'      PPAR1                                        CLE035
     C                   MOVE      PRVAL         WSVRS                                        CLE035
                                                                                              CLE035
     C                   IF        PRTCD <> *Blanks                                           CLE035
     C                   EVAL      DDRTSPOK = 'N'                                             CLE035
     C                   EVAL      Idx = Idx + 1                                              CLE035
     C                   EVAL      FldNamXAr(Idx) = 'DDRTSP'                                  CLE035
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0138'                                  CLE035
     C                   ENDIF                                                                CLE035
     C     WRTSP1        IFEQ      '-'                                                      MD055220
     C                   Z-SUB     WSVRS         WSVRS                                      MD055220
     C                   ENDIF                                                              MD055220
                                                                                              CLE035
     C                   IF        DDRTSPOK <> 'N'                                            CLE035
     C                   EVAL      CCLRTSP = WSVRS                                            CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ENDSR                                                                CLE035
      *****************************************************************                       CLE035
      /EJECT                                                                                  CLE035
      *****************************************************************
      *  SRSPIN - Validate spread indicator                           *
      *****************************************************************
     C     SRSPIN        BEGSR
      *
     C     DDSPIN        IFEQ      *BLANKS
     C     DDBRTT        IFNE      *BLANKS
     C     DDRTSP        ORNE      *BLANKS
     C     DDFXRT        ORNE      *BLANKS                                                   BUG9239
     C     WLNPT         OREQ      70                                                       MD023254
     C     WLNPT         OREQ      71                                                       MD023254
     C     WLNPT         OREQ      72                                                       MD023254
     C     CLE170        OREQ      'Y'                                                      MD053297
     C                   MOVE      'A'           DDSPIN
     C                   ENDIF
     C                   ELSE
      *
     C     DDSPIN        IFNE      'A'
     C     DDSPIN        ANDNE     'S'
     C     DDSPIN        ANDNE     'P'
      *
      ***  Must be blank if no base rate or spread rate is entered
      ***  If CLE036 is available also check Base Rate                                      BUG10225
      *****If*CLE035*is*available*also*check*Base*Rate*****************              CLE035 BUG10225
      *
     C     CCLCHTP       OREQ      'I'
     C     DDBRTT        ANDEQ     *BLANKS
     C     DDSPIN        ANDNE     'A'
                                                                                              CLE035
     C**********         IF        CLE035 = 'N' Or                                   CLE035 BUG10225
     C**********                   CLE035 = 'Y' And DDBASR = *Blanks                 CLE035 BUG10225
     C                   IF        CLE036 = 'N' Or                                          BUG10225
     C                             CLE036 = 'Y' And DDBASR = *Blanks                        BUG10225
     C                   MOVE      'N'           DDSPINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSPIN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0142'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE035
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD039304
      ** SPIN should not be P if there is no spread rate.                                   MD039304
      *                                                                                     MD039304
     C     DDSPIN        IFEQ      'P'                                                      MD039304
     C     WSVRS         ANDEQ     *ZERO                                                    MD039304
     C                   MOVE      'N'           DDRTSPOK                                   MD039304
     C                   ADD       1             Idx                                        MD039304
     C                   MOVEL     'DDRTSP'      FldNamXAr(Idx)                             MD039304
     C                   MOVEL     '5048709'     MsgIDXAr(Idx)                              MD039304
     C                   ENDIF                                                              MD039304
      *
      ***  Calculate effective interest rate
      *
     C                   SELECT
     C     DDSPIN        WHENEQ    'A'
     C     BASER         ADD       WSVRS         WINTT            11 7
     C     DDSPIN        WHENEQ    'S'
     C     BASER         SUB       WSVRS         WINTT
     C     DDSPIN        WHENEQ    'P'
     C     WSVRS         DIV       100           WRK139           13 9
     C     WRK139        MULT(H)   BASER         WINTT
                                                                                              CLE035
      ***If*CLE035*is*ON*and*Spread*Ind*is*blank,*this*is*a*fixed*rate*              CLE035 BUG10225
      ** If CLE036 is ON and Spread Ind is blank, this is a fixed rate                      BUG10225
                                                                                              CLE035
     C     DDSPIN        WHENEQ    *Blank                                                     CLE035
     C*****CLE035        ANDEQ     'Y'                                               CLE035 BUG10225
     C     CLE036        ANDEQ     'Y'                                                      BUG10225
     C                   Z-ADD     WSVRS         WINTT                                        CLE035
     C                   ENDSL
      ***When*the*interest*is*negative,*set*it*to*zero.                            BUG10226 MD052279
     C*****WINTT         IFLT      *ZEROS                                          BUG10226 MD052279
     C**********         EVAL      WINTT = *ZEROS                                  BUG10226 MD052279
     C**********         ENDIF                                                     BUG10226 MD052279
      *
     C     DDSPINOK      IFNE      'N'
     C                   MOVEL     DDSPIN        CCLSPIN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNIDT - Validate interest date                              *
      *****************************************************************
     C     SRNIDT        BEGSR
      *
     C                   Z-ADD     *ZEROS        WSVID
     C     DDNIDT        IFNE      *BLANKS
     C                   DO
      *                                                                                    AR1067935
      ** Interest Payment Date must be blank for PDCL.                                     AR1067935
      *                                                                                    AR1067935
     C                   IF        CLE134      = 'Y'                                       AR1067935
     C                   IF        %SUBST(CCLLTYP:1:1) = 'X'     OR                        AR1067935
     C                             %SUBST(CCLLTYP:1:1) = 'Y'     OR                        AR1067935
     C                             %SUBST(CCLLTYP:1:1) = 'Z'                               AR1067935
     C                   MOVE      'N'           DDNIDTOK                                  AR1067935
     C                   ADD       1             Idx                                       AR1067935
     C                   MOVEL     'DDNIDT'      FldNamXAr(Idx)                            AR1067935
     C                   MOVEL     '5045904'     MsgIDXAr(Idx)                             AR1067935
     C                   LEAVE                                                             AR1067935
     C                   ENDIF                                                             AR1067935
     C                   ENDIF                                                             AR1067935
      *
     C                   MOVEL     DDNIDT        WNUM7             7 0
     C                   MOVEL     WNUM7         WALF6             6
     C                   MOVE      DDNIDT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        WSVID             5 0
     C                   Z-ADD     ZDAYNO        W#NIDT            5 0
     C     ZERR          IFNE      *BLANKS
     C     DDNIDT        ORNE      WALF6
     C                   MOVE      'N'           DDNIDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNIDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0144'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *
      ***  Must be greater than interest accrual control date
      *
     C                   MOVE      '0'           WIN51             1
     C     CCLCHTP       IFEQ      'I'
     C                   Z-ADD     WSVVD         CCLIACD
     C                   Z-ADD     *ZERO         CCLGDIN
     C                   ENDIF
      *                                                                                    AR1085248
      ** Skip validation against IACD if interest payment                                  AR1085248
      ** date is not changed.                                                              AR1085248
      *                                                                                    AR1085248
     C     CCLNIDT       IFNE      W#NIDT                                                  AR1085248
     C     WSVID         IFLE      CCLIACD
      *
      ***  Consider the grace day period for the next interest date.
      *
     C     CCLIACD       SUB       WSVID         WNUM1             2 0
     C     WNUM1         IFGT      CCLGDIN
     C     CCLGDIN       ANDGT     *ZERO
     C     CCLGDIN       OREQ      *ZERO
     C                   MOVE      '1'           WIN51
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                             AR1085248
      *
      ***  If new maturity date is entered, interest date must be
      ***  earlier than new maturity date, else, interest date must be
      ***  earlier than maturity date entered
      *
     C     CCLMDAT       IFNE      *ZEROS
     C     CCLNMDT       IFGT      *ZEROS
     C     CCLCHTP       ANDNE     'I'
     C                   Z-ADD     CCLNMDT       W0MDT             5 0
     C                   ELSE
     C                   Z-ADD     WSVMD         W0MDT
     C                   ENDIF
     C     WSVID         IFGE      W0MDT
     C                   MOVE      '1'           WIN51
     C                   ENDIF
     C                   ENDIF
      *
     C     WIN51         IFEQ      '1'
     C                   MOVE      'N'           DDNIDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNIDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0145'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *
      ***  Must be blank for zero interest amounts and discount loans
      ***  parts purchased and sold
      *
     C     WINTT         IFEQ      *ZEROS
     C**** @@PTFC        ANDEQ     *ZEROS                                           BUG10226 CSD027A
     C     @@PTFC        ANDEQ     *Blanks                                                   CSD027A
     C     @@PTFT        ANDEQ     *ZEROS                                                   BUG10226
     C     @@PTFN        ANDEQ     *ZEROS                                                   BUG10226
     C     WLNPT         OREQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C                   MOVE      'N'           DDNIDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNIDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0159'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Next interest date must be the same as the rollover date
      ***  if interest frequency = 'R'. If dates are different,
      ***  display error message and highlight both fields.
      *
     C     DDIPFR        IFEQ      'R'
     C     WSVID         ANDNE     WSVRD
     C     DDNIDT        ANDNE     *BLANKS
     C                   MOVE      'N'           DDIPFROK
     C                   MOVE      'N'           DDNIDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNIDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0516'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Send warning message if interest payment date is earlier
      ***  than rundate.
      *
     C     CCLCHTP       IFEQ      'A'
     C     CCLCHTP       OREQ      'X'
     C     WSVID         IFLT      BJRDNB
     C     CCLORED       ANDLT     BJRDNB
     C*****WE504         IFEQ      *BLANKS                                                   BUG4351
     C*****WE504         OREQ      'Y'                                                       BUG4351
     C*****WSVID         ANDNE     W1ID                                                      BUG4351
     C**********         Z-ADD     WSVID         W1ID              5 0                       BUG4351
     C**********         MOVE      'Y'           WE504             1                         BUG4351
     C                   MOVE      'W'           DDNIDTOK
     C                   ADD       1             WId
     C                   MOVEL     'DDNIDT'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0504'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF
      *
      ***  Save the old value of the interest date
      *
     C     CCLCHTP       IFEQ      'I'
     C                   Z-ADD     WSVID         W#OIDT            5 0
     C                   ELSE
     C     CCLCHTP       IFEQ      'X'
     C                   Z-ADD     CCLOIDT       W#OIDT
     C                   ELSE
     C                   Z-ADD     CCLNIDT       W#OIDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C     DDNIDTOK      IFNE      'N'
     C                   MOVE      WSVID         CCLNIDT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRIPFR - Validate interest frequency                         *
      *****************************************************************
     C     SRIPFR        BEGSR
      *
     C     DDNIDT        IFEQ      *BLANKS
     C     DDIPFR        ANDNE     *BLANKS
     C     DDIPFR        ANDNE     'R'
     C     DDNIDT        OREQ      *BLANKS
     C     DDIPFR        ANDEQ     'R'
     C     CCLRLDT       ANDEQ     *ZEROS
     C                   MOVE      'N'           DDIPFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIPFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0160'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ***  Valid frequency codes are W,F,M,T,Q,X,Y
      ***  If CLE005 is installed, R is also valid
      *
     C     DDIPFR        IFNE      *BLANK
     C     DDIPFR        LOOKUP    WFREQ                                  89
     C     *IN89         IFEQ      '0'
     C     DDIPFR        ANDNE     'R'
     C     DDIPFR        OREQ      'R'
     C     CLE005        ANDEQ     'N'
     C                   MOVE      'N'           DDIPFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIPFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0055'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDIPFROK      IFNE      'N'
     C                   MOVEL     DDIPFR        CCLIPFR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRIFDY - Validate interest day number                        *
      *****************************************************************
     C     SRIFDY        BEGSR
      *
      ***  Defaults to day number in interest date if valid
      *
     C     DDIFDY        IFEQ      *BLANKS
     C     DDNIDTOK      IFNE      'N'
     C     DDIPFROK      ANDNE     'N'
     C     DDNIDT        ANDNE     *BLANKS
     C     DDIPFR        ANDNE     *BLANKS
     C     DDIPFR        ANDNE     'W'
     C     DDIPFR        ANDNE     'F'
     C     DDIPFR        ANDNE     'R'
     C                   MOVE      DDNIDT        WDATE
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      WDAT2         DDIFDY
     C                   ELSE
     C                   MOVE      WDAT1         DDIFDY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDIPFR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDIFDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIFDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0277'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ***  Must be numeric, from 1 to 31
      *
     C                   MOVEL     DDIFDY        WNUM3             3 0
     C                   MOVEL     WNUM3         WALF2             2
     C     DDIFDY        IFNE      WALF2
     C     DDIFDY        ORLT      '01'
     C     DDIFDY        ORGT      '31'
     C                   MOVE      'N'           DDIFDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIFDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0279'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      DDIFDY        WIFDY
      *****************************************************************                       251225
      *****Default*interest*details*to*rollover*details*if*not*********                       251225
      *****entered*****************************************************                       251225
      *****************************************************************                       251225
     C*****CCLCHTP       IFEQ      'I'                                                        251225
     C*****CCLRLDT       ANDNE     *ZEROS                                                     251225
      *****************************************************************                       251225
      *****For*insert,*if*interest*payment*details*are*blank,*allow****                       251225
      *****default*of*values*held*in*rollover*details*provided:********                       251225
      *********1)*rollover*details*have*been*entered,*and;*************                       251225
      *********2)*processing*type*is*62*for*loans;*********************                       251225
      ************or*processing*type*is*64*for*parts*purchased;********                       251225
      ************or*processing*type*is*66*for*parts*sold;*************                       251225
      *********3)*either*interest*rate*or*base*rate*type*and*spread****                       251225
      ***************have*been*entered,*and;***************************                       251225
      *********4)*repayment*type*is*'2'*(int.*on*its*own*frequency)****                       251225
      *********5)***Rollover*Date*is*not*back-valued*******************                       251225
      *****************************************************************                       251225
     C*****DDNIDT        ANDEQ     *BLANKS                                                    251225
     C*****DDIPFR        ANDEQ     *BLANKS                                                    251225
     C*****DDIFDY        ANDEQ     *BLANKS                                                    251225
     C*****CCLRLDT       ANDNE     *ZEROS                                                     251225
     C*****DDREPT        ANDEQ     '2'                                                        251225
     C*****DDBRTTOK      ANDNE     'N'                                                        251225
     C*****DDRTSPOK      ANDNE     'N'                                                        251225
      *****************************************************************                       251225
     C******IN82         IFEQ      '1'                                                        251225
     C*****WLNPT         ANDEQ     64                                                         251225
     C******IN83         OREQ      '0'                                                        251225
     C******IN82         ANDEQ     '0'                                                        251225
     C*****WLNPT         ANDEQ     62                                                         251225
     C******IN83         OREQ      '1'                                                        251225
     C*****WLNPT         ANDEQ     66                                                         251225
     C******IN83         OREQ      '1'                                                        251225
     C*****WLNPT         ANDEQ     69                                                         251225
     C******IN83         OREQ      '1'                                                        251225
     C*****WLNPT         ANDEQ     72                                                         251225
     C*****W72TP         ANDEQ     '66'                                                       251225
      *****************************************************************                       251225
     C*****DDBRTT        IFNE      *BLANKS                                                    251225
     C*****DDRTSP        ORNE      *BLANKS                                                    251225
     C**********         Z-ADD     WSVRD         WSVID                                        251225
     C**********         MOVE      CCLRLDT       CCLNIDT                                      251225
     C**********         MOVE      CCLRLFQ       CCLIPFR                                      251225
     C**********         MOVE      CCLRLDY       CCLIFDY                                      251225
     C**********         CALL      'ZDATE2'                                                   251225
     C**********         PARM      CCLRLDT       ZDateNum          5 0                        251225
     C**********         PARM      BJDFIN        ZDateFmtInd       1                          251225
     C**********         PARM      *ZERO         ZDateFmt6         6 0                        251225
     C**********         PARM      *BLANK        ZDateFmt7         7                          251225
     C**********         MOVE      ZDateFmt6     DDNIDT                                       251225
     C**********         MOVE      CCLRLFQ       DDIPFR                                       251225
     C*****CCLRLDY       IFNE      *ZEROS                                                     251225
     C**********         MOVE      CCLRLDY       DDIFDY                                       251225
     C**********         ENDIF                                                                251225
     C**********         ENDIF                                                                251225
      *****************************************************************                       251225
     C**********         ENDIF                                                                251225
     C**********         ENDIF                                                                251225
      *
      ***  Also on insert, if interest frequency is 'R' and rollover
      ***  date is input, overwrite interest date with rollover date
      *
     C     CCLCHTP       IFEQ      'I'
     C     CCLRLDT       ANDNE     *ZEROS
     C     DDIPFR        ANDEQ     'R'
     C     CLE005        ANDEQ     'Y'
     C                   Z-ADD     WSVRD         WSVID
     C                   MOVE      CCLRLDT       CCLNIDT
     C                   CALL      'ZDATE2'
     C                   PARM      CCLRLDT       ZDateNum          5 0
     C                   PARM      BJDFIN        ZDateFmtInd       1
     C                   PARM      *ZERO         ZDateFmt6         6 0
     C                   PARM      *BLANK        ZDateFmt7         7
     C                   MOVE      ZDateFmt6     DDNIDT
     C                   ENDIF
      *
      ***  Also, if User clears the Next Interest Payment date field
      ***  whilst in Amend mode, and Interest Frequency = 'R', default
      ***  the Rollover date to the Interest Date field.
      *
     C     CCLCHTP       IFEQ      'A'
     C     CCLRLDT       ANDNE     *ZEROS
     C     DDIPFR        ANDEQ     'R'
     C     DDNIDT        ANDEQ     *BLANKS
     C     CLE005        ANDEQ     'Y'
     C                   Z-ADD     CCLRLDT       WSVID
     C                   MOVE      CCLRLDT       CCLNIDT
     C                   CALL      'ZDATE2'
     C                   PARM      CCLRLDT       ZDateNum          5 0
     C                   PARM      BJDFIN        ZDateFmtInd       1
     C                   PARM      *ZERO         ZDateFmt6         6 0
     C                   PARM      *BLANK        ZDateFmt7         7
     C                   MOVE      ZDateFmt6     DDNIDT
     C                   ENDIF
      *
     C     DDIFDYOK      IFNE      'N'
     C                   MOVE      DDIFDY        CCLIFDY
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCALC - Validate interest validation basis                  *
      *****************************************************************
     C     SRCALC        BEGSR
                                                                                             BUG3721
      ** Interest calculation basis must be blanks for Flat Rate Personal Loans              BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
                                                                                             BUG3721
     C     DDCALC        IFNE      *BLANK                                                    BUG3721
     C                   MOVE      'N'           DDCALCOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDCALC'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0555'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
      *
      ***  Access the facility
      *
     C     *IN83         IFEQ      '0'
     C                   MOVE      CCLFCUS       WFCNUM
     C                   MOVE      CCLFTYP       WFFACT
     C                   MOVE      CCLFSEQ       WFFCNO
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY   '    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     FCTREC        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Defaults to the calculation basis specified against the
      ***  facility to which it is being linked.
      *
     C     DDCALC        IFEQ      *BLANK
     C******IN83*********ANDEQ     '0'
     C     DICB          ANDNE     *ZEROS
     C                   MOVE      DICB          DDCALC
     C                   ENDIF
     C                   ENDIF
      *
      ***  For parts sold interest calculation defaults from sale of loan
      ***  number.
      *
     C     DDCALC        IFEQ      *BLANKS
     C     *IN83         ANDEQ     '1'
     C     S#ICBS        ANDNE     *ZERO
     C                   MOVE      S#ICBS        DDCALC
     C                   ENDIF
      *
     C     DDCALC        IFLT      '1'
     C     DDCALC        ORGT      '6'
     C                   MOVE      'N'           DDCALCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCALC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0141'     MsgIDXAr(Idx)
     C                   ENDIF
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
      *
     C     DDCALCOK      IFNE      'N'
     C                   MOVE      DDCALC        CCLICBS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRIPRD - Validate interest/discount amount                   *
      *****************************************************************
     C     SRIPRD        BEGSR
      *
      ***  On insert, interest should be valid numeric
      ** ... in amend mode, Rule of 78s is installed, loan processing                        BUG3721
      ** type is '80' and Interest field is amendable, interest should                       BUG3721
      ** be valid numeric.                                                                   BUG3721
      *
     C     CCLCHTP       IFEQ      'I'
     C     RespMode      ANDEQ     'S'
     C     DDIPRD        ANDNE     '*'
                                                                                             BUG3721
     C     CCLCHTP       OREQ      'A'                                                       BUG3721
     C     RespMode      ANDEQ     'S'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C     WPRCS2        ANDNE     'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
                                                                                             BUG3721
     C                   MOVEL     *BLANK        WIPRD1            1                         BUG3721
     C                   MOVEL     *BLANK        WIPR13           13                         BUG3721
     C                   MOVEL     DDIPRD        WIPRD1                                      BUG3721
     C                   MOVE      DDIPRD        WIPR13                                      BUG3721
                                                                                             BUG3721
     C     CLE028        IFNE      'Y'                                                       BUG3721
     C     WIPRD1        ANDEQ     '*'                                                       BUG3721
     C     WIPRD1        ORNE      '*'                                                       BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WIPRD1        ANDEQ     '*'                                                       BUG3721
     C     WIPR13        ANDNE     *BLANK                                                    BUG3721
                                                                                             BUG3721
     C                   MOVE      *BLANKS       PSCRF
     C     WIPRD1        IFEQ      '-'                                                      AR988460
     C                   MOVE      WIPR13        PSCRF                                      AR988460
     C                   ELSE                                                               AR988460
     C                   MOVE      DDIPRD        PSCRF
     C                   ENDIF                                                              AR988460
     C                   Z-ADD     WCDPL         PNDEC
     C     13            SUB       WCDPL         PNDIG
     C                   CALL      'ZALIGN'      PPAR1
     C                   MOVE      PRVAL         WTOTI            13 0
     C     WIPRD1        IFEQ      '-'                                                      AR988460
     C     PRTCD         ANDEQ     *BLANKS                                                  AR988460
     C                   Z-SUB     WTOTI         WTOTI                                      AR988460
     C                   ENDIF                                                              AR988460
      * If CLE170 is on, and Loan passes the criteria, and the interest amount is zero        CLE170
      * suppress the error message.                                                           CLE170
      *                                                                                       CLE170
     C     CLE170        IFEQ      'Y'                                                        CLE170
     C     WLNPT         ANDNE     63                                                         CLE170
     C     WLNPT         ANDNE     65                                                         CLE170
     C     WLNPT         ANDNE     67                                                         CLE170
     C     WLNPT         ANDNE     80                                                       MD055074
     C     WTOTI         ANDEQ     0                                                          CLE170
     C     WINTT         ANDEQ     0                                                          CLE170
      * CLE170 is on, Loan is not a Discount Loan, amount is zero, do nothing                 CLE170
     C                   ELSE                                                                 CLE170
      * Loan does not meet criteria, or CLE170 is off - normal processing                     CLE170
      *                                                                                       CLE170
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDIPRDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIPRD'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0146'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                               BUG3721
     C                   ENDIF
     C                   ENDIF                                                                CLE170
      *
      ***  ON INSERT
      ***  Check that the interest entered is within the calculated
      ***  amount to be within one unit of the currency specified.
      ***  Do this if amount, value date, maturity date, base rate,
      ***  spread rate, interest basis, interest date, spread indicator
      ***  and round-down indicator are valid
      *
     C     CCLCHTP       IFEQ      'I'
     C     DDBRTTOK      ANDNE     'N'
     C     DDRTSPOK      ANDNE     'N'
     C     DDBASROK      ANDNE     'N'                                                        CLE035
     C     DDFXRTOK      ANDNE     'N'                                                        CLE035
     C     DDCALCOK      ANDNE     'N'
     C     DDIPRDOK      ANDNE     'N'
     C     DDSPINOK      ANDNE     'N'
     C     DDRDFCOK      ANDNE     'N'
     C*****CLE028        ANDEQ     'Y'                                               BUG3721 BUG5070
     C     WLNPT         ANDNE     80                                                        BUG3721
                                                                                             BUG3721
     C                   EXSR      SRCINT
     C     DDIPRDOK      IFNE      'N'
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C                   Z-ADD     WTOTI         CCLTOTI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  ON AMEND
      ***  If loan is a discount loan, and it is an early repayment,
      ***  update interest amount, original total interest and maturity date
      *
     C     CCLCHTP       IFEQ      'A'
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C*****WSVMD*        IFLT      CCLMDAT                                                   BUG8461
     C*****WSVMD*        IFLT      @@MDAT                                            BUG8461 BUG8863
     C     CCLMDAT       IFLT      @@MDAT                                                    BUG8863
     C                   EXSR      SRCINT
     C                   Z-ADD     WTOTI         CCLTOTI
     C     CCLORTI       IFEQ      *ZEROS
     C     CCLORMD       ANDEQ     *ZEROS
     C     CCLORED       ANDLT     BJRDNB
     C     CCLVDAT       ANDLT     BJRDNB
     C**********         Z-ADD     CCLTOTI       CCLORTI                                      257533
     C**********         MOVE      CCLMDAT       CCLORMD                                      257533
     C                   Z-ADD     @@TOTI        CCLORTI                                      257533
     C                   MOVE      @@MDAT        CCLORMD                                      257533
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMANI - Validate margin and negative indicator              *
      *****************************************************************
     C     SRMANI        BEGSR
      *
     C                   MOVE      *BLANKS       PSCRF
     C                   MOVE      DDMARG        PSCRF
     C                   Z-ADD     5             PNDEC
     C                   Z-ADD     2             PNDIG
     C                   CALL      'ZALIGN'      PPAR1
     C                   MOVE      PRVAL         WSVMG             7 5
     C     PRTCD         IFEQ      *BLANKS
      *
      ***  Send warning msg if margin is greater than effective
      ***  interest or equal to blanks
      *
     C     WSVMG         IFGT      WINTT
     C     DDMARG        OREQ      *BLANKS
      *
      ***  Only give warning msg for margin eq to blanks if not risk loan
      *
     C     WLNPT         ANDNE     70
     C     WLNPT         ANDNE     71
     C     WLNPT         ANDNE     72
      *
     C     PRVAL         OREQ      *ZEROS
     C     WLNPT         ANDNE     70
     C     WLNPT         ANDNE     71
     C     WLNPT         ANDNE     72
      *
     C*****WE022         IFEQ      *BLANK                                                    BUG4351
     C*****WE022         OREQ      'Y'                                                       BUG4351
     C*****DDMARG        ANDNE     W1MG                                                      BUG4351
     C**********         MOVE      DDMARG        W1MG              8                         BUG4351
     C**********         MOVE      'Y'           WE022                                       BUG4351
     C                   MOVE      'W'           DDMARGOK
     C                   ADD       1             WId
     C                   MOVEL     'DDMARG'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0082'     WMsgIDXAr(WId)
     C                   ELSE
     C     PRVAL         IFEQ      *ZEROS
     C     DDMARG        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       DDMARG
     C                   MOVE      ' 0.00000'    DDMARG
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C     DDNEGV        IFEQ      'Y'
     C                   Z-SUB     WSVMG         WSVMG
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'N'           DDMARGOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMARG'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0147'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Negative indicator must be 'Y' or blank
      ***  Must be blank if margin is blank
      *
     C     DDNEGV        IFNE      *BLANK
     C     DDNEGV        ANDNE     'Y'
     C     DDMARG        OREQ      *BLANKS
     C     DDNEGV        ANDNE     *BLANK
     C                   MOVE      'N'           DDNEGVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMARG'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0148'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Margin and negative indicator are non-amendable for
      ***  discounted loans with input and value dates which are
      ***  earlier than rundate
      *
     C     CCLCHTP       IFEQ      'A'
     C     CCLORED       ANDLT     BJRDNB
     C     CCLVDAT       ANDLT     BJRDNB
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C     WSVMG         IFGE      *ZEROS
     C                   MOVE      *BLANK        W1NEG             1
     C                   Z-ADD     CCLMARG       W1MAR             7 5
     C                   ELSE
     C                   MOVE      'Y'           W1NEG
     C                   Z-SUB     CCLMARG       W1MAR
     C                   ENDIF
      *
     C     WSVMG         IFNE      W1MAR
      *
     C     CDE002        IFEQ      'Y'
      *
     C*****WE027         IFEQ      *BLANK                                                    BUG4351
     C*****WE027         OREQ      'Y'                                                       BUG4351
     C*****WSVMG         ANDNE     W1MARG                                                    BUG4351
      *
     C**********         Z-ADD     WSVMG         W1MARG            7 5                       BUG4351
     C**********         MOVE      'Y'           WE027                                       BUG4351
     C                   MOVE      'W'           DDMARGOK
     C                   ADD       1             WId
     C                   MOVEL     'DDMARG'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0527'     WMsgIDXAr(WId)
      *
     C**********         ENDIF                                                               BUG4351
      *
     C                   ELSE
      *
     C                   MOVE      'N'           DDMARGOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMARG'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0350'     MsgIDXAr(Idx)
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDNEGV        IFNE      W1NEG
     C                   MOVE      'N'           DDNEGVOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNEGV'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0351'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDMARGOK      IFNE      'N'
     C     DDNEGVOK      ANDNE     'N'
     C                   Z-ADD     WSVMG         CCLMARG
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRWTRT - Validate withholding tax rate                       *
      *****************************************************************
     C     SRWTRT        BEGSR
      *
     C                   MOVE      *BLANKS       PSCRF
     C                   MOVEL     DDWTRT        PSCRF
     C                   Z-ADD     7             PNDEC
     C                   Z-ADD     4             PNDIG
     C                   CALL      'ZALIGN'      PPAR1
     C                   MOVE      PRVAL         WSVWT            11 7
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDWTRTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWTRT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0153'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must be blank for non-term loans or for term loans
      ***  which are capitalising interest
      *
     C     WSVWT         IFNE      *ZEROS
     C     WLNPT         IFNE      62
     C     WLNPT         ANDNE     64
     C     WLNPT         ANDNE     66
     C     WLNPT         ANDNE     69
     C     WLNPT         ANDNE     72
     C     WLNPT         OREQ      72
     C     W72TP         ANDNE     '66'
     C     DDINTC        OREQ      'Y'
     C                   MOVE      'N'           DDWTRTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWTRT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0274'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  On amend, if withholding tax indicator is entered, so must
      ***  be the rate, and likewise
      *
     C     CCLCHTP       IFEQ      'A'
     C     WSVWT         IFNE      *ZEROS
     C     DDWTIN        ANDEQ     *BLANK
     C     WSVWT         OREQ      *ZEROS
     C     DDWTIN        ANDNE     *BLANK
     C                   MOVE      'N'           DDWTRTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWTRT'      FldNamXAr(Idx)
     C*********          MOVEL     'LEL0274'     MsgIDXAr(Idx)                                225430
     C                   MOVEL     'LEL0679'     MsgIDXAr(Idx)                                225430
     C                   ENDIF
     C                   ENDIF
      *
     C     DDWTRTOK      IFNE      'N'
     C                   MOVE      WSVWT         CCLWTRT
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRWTIN - Validate withholding tax indicator                  *
      *           Only on insert                                      *
      *****************************************************************
     C     SRWTIN        BEGSR
      *
     C     CCLCHTP       IFEQ      'I'
     C     DDWTIN        IFEQ      *BLANKS
     C     WSVWT         ANDNE     *ZEROS
     C     DDWTIN        ORNE      *BLANKS
     C     WSVWT         ANDEQ     *ZEROS
     C     DDWTIN        ORNE      *BLANKS
     C     DDWTIN        ANDNE     'R'
     C     DDWTIN        ANDNE     'N'
     C     DDWTIN        ANDNE     'G'
     C                   MOVE      'N'           DDWTINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWTIN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0154'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDWTINOK      IFNE      'N'
     C                   MOVEL     DDWTIN        CCLWTIN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRINTC - Validate capitalisation indicator                   *
      *****************************************************************
     C     SRINTC        BEGSR
      *
     C     CCLCHTP       IFEQ      'I'
     C     DDNIDT        ANDEQ     *BLANKS
     C     DDINTC        ANDNE     *BLANK
     C     DDINTC        ANDNE     'N'
     C                   MOVE      'N'           DDINTCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINTC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0276'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C     DDINTC        IFNE      *BLANK
     C     DDINTC        ANDNE     'Y'
     C     DDINTC        ANDNE     'N'
     C                   MOVE      'N'           DDINTCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINTC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0278'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C     DDINTC        IFEQ      *BLANKS
     C     DDNIDT        ANDNE     *BLANKS
     C                   MOVE      'N'           DDINTC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     DDINTC        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'N'           DDINTCOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDINTC'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0556'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
      *
     C     DDINTCOK      IFNE      'N'
     C                   MOVEL     DDINTC        CCLINTC
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRRDFC - Validate round-down indicator                       *
      *****************************************************************
     C     SRRDFC        BEGSR
      *
      ***  Validation carried out only on insert to avoid the field
      ***  being flagged in error if round-down indicator of currency or
      ***  branch code have since been changed from Y to N
      *
     C     CCLCHTP       IFEQ      'I'
     C     DDRDFC        IFNE      *BLANK
     C     DDRDFC        ANDNE     'Y'
     C     DDRDFC        ANDNE     'N'
     C                   MOVE      'N'           DDRDFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRDFC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0307'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDRDFC        IFEQ      *BLANK
     C                   MOVE      'N'           DDRDFC
     C                   ENDIF
      *
      ***  If 'Y', round down interest of loan currency and of branch
      ***  must also be 'Y'
      *
     C                   MOVE      CCLCCY        @CYCD
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     CCLCCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
     C     DDRDFC        IFEQ      'Y'
     C     A6RDFC        IFEQ      'N'
     C                   MOVE      'N'           DDRDFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRDFC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0308'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CCLBRCA       @BRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @BRCD         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A8RDFC        IFEQ      'N'
     C                   MOVE      'N'           DDRDFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRDFC'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0309'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDRDFCOK      IFNE      'N'
     C     DDBRTTOK      ANDNE     'N'
     C     DDRTSPOK      ANDNE     'N'
     C     DDBASROK      ANDNE     'N'                                                        CLE035
     C     DDFXRTOK      ANDNE     'N'                                                        CLE035
     C     DDCALCOK      ANDNE     'N'
     C     DDIPRDOK      ANDNE     'N'
     C     DDSPINOK      ANDNE     'N'
     C                   MOVEL     DDRDFC        CCLRDFC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRADDI - Validate accrual indicator                          *
      *****************************************************************
     C     SRADDI        BEGSR
      *
     C     DDADDI        IFEQ      *BLANK
     C     BKALDI        IFEQ      'Y'
     C                   MOVE      'L'           DDADDI
     C                   ELSE
     C                   MOVE      'F'           DDADDI
     C                   ENDIF
      *
     C                   ELSE
     C     DDADDI        IFNE      'F'
     C     DDADDI        ANDNE     'L'
     C     DDADDI        ANDNE     'B'
     C                   MOVE      'N'           DDADDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDADDI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0312'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDADDIOK      IFNE      'N'
     C                   MOVEL     DDADDI        CCLADDI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3721
      *  SRADIF - Validate Add on Interest                            *                      BUG3721
      *****************************************************************                      BUG3721
     C     SRADIF        BEGSR                                                               BUG3721
                                                                                             BUG3721
     C     DDADIF        IFEQ      *BLANK                                                    BUG3721
     C                   MOVE      'N'           DDADIF                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
     C     WLNPT         WHENNE    80                                                        BUG3721
     C     DDADIF        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'N'           DDADIFOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDADIF'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0546'     MsgIDXAr(Idx)                               BUG3721
                                                                                             BUG3721
     C     DDADIF        WHENNE    'Y'                                                       BUG3721
     C     DDADIF        ANDNE     'N'                                                       BUG3721
     C                   MOVE      'N'           DDADIFOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDADIF'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0547'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDSL                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDADIFOK      IFNE      'N'                                                       BUG3721
     C                   MOVEL     DDADIF        CCLADIF                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      *  SRADCF - Validate Add on Charges                             *                      BUG3721
      *****************************************************************                      BUG3721
     C     SRADCF        BEGSR                                                               BUG3721
                                                                                             BUG3721
     C     DDADCF        IFEQ      *BLANK                                                    BUG3721
     C                   MOVE      'N'           DDADCF                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
     C     WLNPT         WHENNE    80                                                        BUG3721
     C     DDADCF        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'N'           DDADCFOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDADCF'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0548'     MsgIDXAr(Idx)                               BUG3721
                                                                                             BUG3721
     C     DDADCF        WHENNE    'Y'                                                       BUG3721
     C     DDADCF        ANDNE     'N'                                                       BUG3721
     C                   MOVE      'N'           DDADCFOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDADCF'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0549'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDSL                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDADCFOK      IFNE      'N'                                                       BUG3721
     C                   MOVEL     DDADCF        CCLADCF                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      *  SRICIFCHGA - Validate Include Charges on Interest and        *                      BUG3721
      *               Charge amount                                   *                      BUG3721
      *****************************************************************                      BUG3721
     C     SRICIFCHGA    BEGSR                                                               BUG3721
                                                                                             BUG3721
     C     DDICIF        IFEQ      *BLANKS                                                   BUG3721
     C                   MOVE      'N'           DDICIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WCHGA            13 0                       BUG3721
     C                   MOVE      *BLANKS       PSCRF                                       BUG3721
     C                   MOVE      DDCHGA        PSCRF                                       BUG3721
     C                   Z-ADD     WCDPL         PNDEC                                       BUG3721
     C     13            SUB       WCDPL         PNDIG                                       BUG3721
     C                   CALL      'ZALIGN'      PPAR1                                       BUG3721
     C                   MOVE      PRVAL         WCHGA                                       BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
                                                                                             BUG3721
     C     DDADCF        WHENEQ    'Y'                                                       BUG3721
                                                                                             BUG3721
     C     DDICIF        IFNE      'Y'                                                       BUG3721
     C     DDICIF        ANDNE     'N'                                                       BUG3721
     C                   MOVE      'N'           DDICIFOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDICIF'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0550'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDCHGA        IFEQ      *BLANKS                                                   BUG3721
     C     WCHGA         OREQ      *ZEROS                                                    BUG3721
     C     PRTCD         ORNE      *BLANKS                                                   BUG3721
     C                   MOVE      'N'           DDCHGAOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDCHGA'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0552'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDADCF        WHENEQ    'N'                                                       BUG3721
                                                                                             BUG3721
     C     DDICIF        IFNE      'N'                                                       BUG3721
     C                   MOVE      'N'           DDICIFOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDICIF'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0553'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDCHGA        IFNE      *BLANKS                                                   BUG3721
     C     WCHGA         ANDNE     *ZEROS                                                    BUG3721
     C     PRTCD         ORNE      *BLANKS                                                   BUG3721
     C                   MOVE      'N'           DDCHGAOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDCHGA'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0551'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSL                                                               BUG3721
                                                                                             BUG3721
     C     DDICIFOK      IFNE      'N'                                                       BUG3721
     C                   MOVEL     DDICIF        CCLICIF                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDCHGAOK      IFNE      'N'                                                       BUG3721
     C                   Z-ADD     WCHGA         CCLCHGA                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                       CLE143
      *  SREAIR - Validate Effective Annual Interest Rate             *                       CLE143
      *****************************************************************                       CLE143
     C     SREAIR        BEGSR                                                                CLE143
                                                                                              CLE143
     C                   IF        DDEAIR <> *BLANKS                                          CLE143
                                                                                              CLE143
     C                   MOVE      *BLANKS       PSCRF                                        CLE143
     C                   MOVE      DDEAIR        PSCRF                                        CLE143
     C                   Z-ADD     7             PNDIG                                        CLE143
     C                   Z-ADD     8             PNDEC                                        CLE143
     C                   CALL      'ZALIGN'      PPAR1                                        CLE143
     C                   MOVE      PRVAL         WEAIR                                        CLE143
                                                                                              CLE143
     C     PRTCD         IFNE      *BLANKS                                                    CLE143
     C                   MOVE      'N'           DDEAIROK                                     CLE143
     C                   ADD       1             Idx                                          CLE143
     C                   MOVEL     'DDEAIR'      FldNamXAr(Idx)                               CLE143
     C                   MOVEL     'LEL0859'     MsgIDXAr(Idx)                                CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C     DDEAIROK      IFNE      'N'                                                        CLE143
     C                   Z-ADD     WEAIR         CCLEAIR                                      CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   ENDSR                                                                CLE143
      *****************************************************************                       CLE143
      /EJECT                                                                                  CLE143
      *****************************************************************
      *  SRREPT - Validate repayment type                             *
      *****************************************************************
     C     SRREPT        BEGSR
      *
      ***  For non-discount loans or guarantees, default to 2
      *
     C     CCLCHTP       IFEQ      'I'                                          225214
     C     DDREPT        IFEQ      *BLANK
     C     DDREPT        OREQ      '0'
     C     WLNPT         IFNE      63
     C     WLNPT         ANDNE     65
     C     WLNPT         ANDNE     67
     C     WLNPT         ANDNE     72
     C     WLNPT         ANDNE     80                                                        BUG3721
     C     WLNPT         OREQ      72
     C     W72TP         ANDNE     '67'
     C     W72TP         ANDNE     '63'
     C     W72TP         ANDNE     '65'
     C                   MOVE      '2'           DDREPT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  225214
      *
      ***  Must be blank for guarantees & disc loans/parts purchased
      ***  on insert
      *
     C     CCLCHTP       IFEQ      'I'
     C     DDREPT        ANDNE     *BLANK
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C                   MOVE      'N'           DDREPTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDREPT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0267'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be '2' if call/demand loan and interest details input
      ***  Must not be '3' if withholding tax details entered
      ***  Must be numeric, from 1 to 3
      *
     C     WLNPT         IFEQ      61
     C     CCLCHTP       IFEQ      'I'
     C     DDREPT        ANDNE     '2'
      *
     C     WLNPT         OREQ      68
     C     DDREPT        ANDNE     '2'
      *
     C     DDWTRTOK      ORNE      'N'
     C     DDWTINOK      ANDNE     'N'
     C     DDWTRT        ANDNE     *BLANKS
     C     DDWTIN        ANDNE     *BLANKS
     C     DDREPT        ANDEQ     '3'
      *
     C     CCLCHTP       OREQ      'I'
     C     DDREPT        ANDNE     *BLANK
     C     DDREPT        ANDNE     '1'
     C     DDREPT        ANDNE     '2'
     C     DDREPT        ANDNE     '3'
     C                   MOVE      'N'           DDREPTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDREPT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0155'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
                                                                                             BUG3721
      ** For flat rate personal loans, repayment type is mandatory and                       BUG3721
      ** valid values are '1' and '3' only                                                   BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     DDREPT        IFNE      '1'                                                       BUG3721
     C     DDREPT        ANDNE     '3'                                                       BUG3721
     C                   MOVE      'N'           DDREPTOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDREPT'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0557'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Add on interest only applicable if repayment type entered is '3'                    BUG3721
                                                                                             BUG3721
     C     DDADIF        IFEQ      'Y'                                                       BUG3721
     C     DDREPT        ANDNE     '3'                                                       BUG3721
     C                   MOVE      'N'           DDREPTOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDREPT'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0698'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
      *
      ***  Interest payment date must be blank for repayment type 1 & 3
      *
     C     DDREPT        IFNE      '2'
     C     DDREPT        ANDNE     *BLANKS
     C     DDNIDT        ANDNE     *BLANKS
     C     DDREPTOK      ANDNE     'N'
     C     DDNIDTOK      ANDNE     'N'
     C                   MOVE      'N'           DDNIDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNIDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0144'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDREPTOK      IFNE      'N'
     C                   MOVE      DDREPT        CCLREPT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRAMT - Validate loan currency repayment amount             *
      *****************************************************************
     C     SRRAMT        BEGSR
      *
      ***  Must not be more than principal amount or must not change
      *
     C                   Z-ADD     *ZEROS        WSVRA
     C                   Z-ADD     *ZEROS        WSVFA
     C                   MOVE      *BLANKS       PSCRF
      *                                                                                    AR1067935
      ** Repayment Date must be blank for PDCL.                                            AR1067935
      *                                                                                    AR1067935
     C                   IF        CLE134      = 'Y'                                       AR1067935
     C                   IF        %SUBST(CCLLTYP:1:1) = 'X'     OR                        AR1067935
     C                             %SUBST(CCLLTYP:1:1) = 'Y'     OR                        AR1067935
     C                             %SUBST(CCLLTYP:1:1) = 'Z'                               AR1067935
     C**********         IF        DDRAMT <> *BLANKS                             AR1067935 MD022807C
     C                   IF        DDRAMT <> *BLANKS AND CCLCHTP <> 'A'                    MD022807C
     C                   MOVE      'N'           DDRAMTOK                                  AR1067935
     C                   ADD       1             Idx                                       AR1067935
     C                   MOVEL     'DDRAMT'      FldNamXAr(Idx)                            AR1067935
     C                   MOVEL     '5045906'     MsgIDXAr(Idx)                             AR1067935
     C                   ENDIF                                                             AR1067935
     C                   ENDIF                                                             AR1067935
     C                   ENDIF                                                             AR1067935
      *                                                                                    AR1067935
     C                   IF        DDRAMTOK <> 'N'                                         AR1067935
                                                                                             BUG3721
      ** Allow '*' to be entered in the Loan Currency Repayment Amount field,                BUG3721
      ** This will be defaulted later on.                                                    BUG3721
                                                                                             BUG3721
     C                   MOVEL     *BLANK        WRAMT1            1                         BUG3721
     C                   MOVEL     *BLANK        WRAM14           14                         BUG3721
     C                   MOVEL     DDRAMT        WRAMT1                                      BUG3721
     C                   MOVE      DDRAMT        WRAM14                                      BUG3721
                                                                                             BUG3721
     C     WRAMT1        IFNE      '*'                                                       BUG3721
                                                                                             BUG3721
     C     WRAMT1        OREQ      '*'                                                       BUG3721
     C     CLE028        ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     WRAMT1        OREQ      '*'                                                       BUG3721
     C     WRAM14        ANDNE     *BLANK                                                    BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     WLNPT         OREQ      63                                                        BUG3721
     C     WLNPT         OREQ      65                                                        BUG3721
     C     WLNPT         OREQ      67                                                        BUG3721
                                                                                             BUG3721
     C     WLNPT         OREQ      72                                                        BUG3721
     C     W72TP         ANDEQ     '67'                                                      BUG3721
     C                   MOVE      DDRAMT        PSCRF
     C                   MOVE      WCDPL         PNDEC
     C     13            SUB       WCDPL         PNDIG
     C                   CALL      'ZALIGN'      PPAR1
     C                   MOVE      PRVAL         WSVRA
     C     PRTCD         IFNE      *BLANKS
     C     CCLCPAM       ORNE      *ZEROS
     C     WSVRA         ANDGT     WSVAM2
     C                   MOVE      'N'           DDRAMTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRAMT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0156'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                               BUG3721
      *                                                                                    MD022807C
      ** Repayment Amount amendment is prohibited for PDCLs                                MD022807C
      *                                                                                    MD022807C
     C                   IF        CLE134 = 'Y' AND CCLCHTP = 'A'                          MD022807C
     C                             AND WSVRA <> @@RAMT AND                                 MD022807C
     C                             (%SUBST(CCLLTYP:1:1) = 'X' OR                           MD022807C
     C                              %SUBST(CCLLTYP:1:1) = 'Y' OR                           MD022807C
     C                              %SUBST(CCLLTYP:1:1) = 'Z')                             MD022807C
     C                   MOVE      'N'           DDRAMTOK                                  MD022807C
     C                   ADD       1             Idx                                       MD022807C
     C                   MOVEL     'DDRAMT'      FldNamXAr(Idx)                            MD022807C
     C                   MOVEL     '5046138'     MsgIDXAr(Idx)                             MD022807C
     C                   ENDIF                                                             MD022807C
      *
      ***  Missed out in original copy, discounts and guarantees are
      ***  not allowed to have repayments
      *
     C     DDRAMT        IFNE      *BLANKS
     C     WSVRA         ANDNE     *ZEROS
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C                   MOVE      'N'           DDRAMTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRAMT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0156'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1067935
     C                   ENDIF                                                             AR1067935
      *
     C     DDRAMTOK      IFNE      'N'
     C                   MOVE      WSVRA         CCLRAMT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFCRA - Validate facility currency repayment amount         *
      *****************************************************************
     C     SRFCRA        BEGSR

     C     *IN83         IFEQ      '0'
     C                   MOVE      FCCYF         @CYCD
     C                   ELSE
     C                   MOVE      FCCYM         @CYCD
     C                   ENDIF
                                                                                              241018
     C                   MOVE      *BLANK        ZOUT20                                       241018
                                                                                              241018
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @CYCD         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *                                                                                      BUG8526
      ** The Facility Currency Exchange Rate and its Multiply/divide                         BUG8526
      ** will be fully validate in the next validation module but                            BUG8526
      ** those fields are needed now in this module. Therefore,                              BUG8526
      ** if no valid Facility Currency Exchange Rate and Multiply/                           BUG8526
      ** Divide indicator are entered, then system will continue with                        BUG8526
      ** the old way of cross-rate calculation between the loan ccy                          BUG8526
      ** and the facility ccy.                                                               BUG8526
     C                   MOVE      *BLANKS       PSCRF                                       BUG8526
     C                   MOVE      DDFCXR        PSCRF                                       BUG8526
     C                   Z-ADD     8             PNDEC                                       BUG8526
     C                   Z-ADD     5             PNDIG                                       BUG8526
     C                   CALL      'ZALIGN'      PPAR1                                       BUG8526
     C                   Z-ADD     0             WQFCXR           13 8                       BUG8526
      ** WQFCXR will only have a non-zero value if both the Facility                         BUG8526
      ** Currency Exchange Rate and its Multiply/Divide indicator are                        BUG8526
      ** both valid.                                                                         BUG8526
     C     PRTCD         IFEQ      *BLANKS                                                   BUG8526
     C     DDFMIN        IFEQ      'M'                                                       BUG8526
     C     DDFMIN        OREQ      'D'                                                       BUG8526
     C                   MOVE      PRVAL         WQFCXR                                      BUG8526
     C                   ENDIF                                                               BUG8526
     C                   ENDIF                                                               BUG8526
      *
      ***  Must be valid in facility currency
      *
     C                   MOVE      *BLANKS       PSCRF
     C                   MOVE      DDFCRA        PSCRF
     C                   MOVE      A6NBDP        PNDEC
     C     13            SUB       A6NBDP        PNDIG
     C                   CALL      'ZALIGN'      PPAR1
     C                   MOVE      PRVAL         WSVFA
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0416'     MsgIDXAr(Idx)
      *
      ***  Must not be more than the loan amount
      *
     C                   ELSE
     C     @CYCD         IFNE      CCLCCY
                                                                                             BUG3721
      ** Compute the calculated Facility ccy repayment amount                                BUG3721
      ** Get cross rate                                                                      BUG3721
                                                                                             BUG3721
     C     WSVRA         IFNE      0                                                         BUG3721
     C     DDRAMT        ANDNE     *BLANKS                                                   BUG3721
     C     DDRAMT        ANDNE     '*'                                                       BUG3721
     C     DDRAMTOK      ANDNE     'N'                                                       BUG3721
                                                                                             BUG3721
      ** Skip the cross-rate calculation if Facility Currency                                BUG8526
      ** Exchange Rate was entered.                                                          BUG8526
     C     WQFCXR        IFEQ      0                                                         BUG8526
     C**********         Z-ADD     WSVRT         ZRATE1                             BUG3721 BUG16385
     C**********         MOVE      WSVIN         ZMDI1                              BUG3721 BUG16385
     C**********         Z-ADD     A6SPRT        ZRATE2                             BUG3721 BUG16385
     C**********         MOVE      A6MDIN        ZMDI2                              BUG3721 BUG16385
     C                   Z-ADD     A6SPRT        ZRATE1                                     BUG16385
     C                   MOVE      A6MDIN        ZMDI1                                      BUG16385
     C                   Z-ADD     WSVRT         ZRATE2                                     BUG16385
     C                   MOVE      WSVIN         ZMDI2                                      BUG16385
                                                                                             BUG3721
     C                   CALLB     'ZXRATE'                                                  BUG3721
     C                   PARM                    ZRATE1           13 8                       BUG3721
     C                   PARM                    ZMDI1             1                         BUG3721
     C                   PARM                    ZRATE2           13 8                       BUG3721
     C                   PARM                    ZMDI2             1                         BUG3721
     C                   PARM                    ZRATEX           13 8                       BUG3721
     C                   PARM                    ZMDIX             1                         BUG3721
      *                                                                                     BUG16385
     C                   IF        FCCYF <> BJCYCD                                          BUG16385
      *                                                                                     BUG16385
     C                   IF        A6MDIN = 'M'                                             BUG16385
     C                   EVAL      ZMDIX = 'D'                                              BUG16385
     C                   ELSE                                                               BUG16385
     C                   EVAL      ZMDIX = 'M'                                              BUG16385
     C                   ENDIF                                                              BUG16385
     C                   ELSE                                                               BUG16385
     C                   EVAL      ZRATEX = WSVRT                                          AR835048B
     C                   IF        WSVIN = 'M'                                              BUG16385
     C                   EVAL      ZMDIX = 'M'                                              BUG16385
     C                   ELSE                                                               BUG16385
     C                   EVAL      ZMDIX = 'D'                                              BUG16385
     C                   ENDIF                                                              BUG16385
      *                                                                                     BUG16385
     C                   ENDIF                                                              BUG16385
                                                                                            BUG16385
     C                   ENDIF                                                               BUG8526
                                                                                             BUG3721
      ** Loan ccy repayment amount to Facility ccy repayment amount                          BUG3721
                                                                                             BUG3721
     C                   MOVE      CCLCCY        ZCCYI                                       BUG3721
     C                   MOVE      @CYCD         ZCCYO                                       BUG3721
     C                   MOVE      WCDPL         ZCDPI                                       BUG3721
     C                   MOVE      A6NBDP        ZCDPO                                       BUG3721
     C                   Z-ADD     WSVRA         ZAMTCI                                      BUG3721
      ** Use the Facility Currency Exchange Rate if entered.                                 BUG8526
     C     WQFCXR        IFNE      0                                                         BUG8526
     C                   Z-ADD     WQFCXR        ZEXCH                                       BUG8526
     C                   MOVE      DDFMIN        ZMD                                         BUG8526
     C                   ELSE                                                                BUG8526
     C                   Z-ADD     ZRATEX        ZEXCH                                       BUG3721
     C                   MOVE      ZMDIX         ZMD                                         BUG3721
     C                   ENDIF                                                               BUG8526
                                                                                             BUG3721
     C                   CALLB     'ZCONV'                                                   BUG3721
     C                   PARM                    ZAMTCI           15 0                       BUG3721
     C                   PARM                    ZEXCH            13 8                       BUG3721
     C                   PARM                    ZMD               1                         BUG3721
     C                   PARM                    ZCCYI             3                         BUG3721
     C                   PARM                    ZCCYO             3                         BUG3721
     C                   PARM                    ZCDPI             1 0                       BUG3721
     C                   PARM                    ZCDPO             1 0                       BUG3721
     C                   PARM                    ZAMTCO           15 0                       BUG3721
                                                                                             BUG3721
     C                   Z-ADD     ZAMTCO        WCFCRA           13 0                       BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Facility ccy repayment amount to Loan ccy repayment amount                          BUG3721
                                                                                             BUG3721
      ** Skip cross-rate calculation if Facility Currency Exchange                           BUG8526
      ** rate was entered.                                                                   BUG8526
     C     WQFCXR        IFEQ      0                                                         BUG8526
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     WSVRT         ZRATE2
     C                   MOVE      WSVIN         ZMDI2
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDIF                                                               BUG8526
      *
     C                   MOVE      @CYCD         ZCCYI
     C                   MOVE      CCLCCY        ZCCYO
     C                   MOVE      A6NBDP        ZCDPI
     C                   MOVE      WCDPL         ZCDPO
     C                   Z-ADD     WSVFA         ZAMTCI
      ** Use the Facility Currency Exchange Rate, if entered                                 BUG8526
     C     WQFCXR        IFNE      0                                                         BUG8526
     C                   Z-ADD     WQFCXR        ZEXCH                                       BUG8526
     C     DDFMIN        IFEQ      'M'                                                       BUG8526
     C                   MOVE      'D'           ZMD                                         BUG8526
     C                   ELSE                                                                BUG8526
     C                   MOVE      'M'           ZMD                                         BUG8526
     C                   ENDIF                                                               BUG8526
     C                   ELSE                                                                BUG8526
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   ENDIF                                                               BUG8526
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   ELSE
     C                   Z-ADD     WSVFA         ZAMTCO
     C                   ENDIF
      *
     C     ZAMTCO        IFGT      WSVAM2
     C     CCLCPAM       ANDNE     0                                                          247325
     C     WSVFA         IFGT      WCFCRA                                                     262433
     C                   MOVE      'N'           DDFCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0416'     MsgIDXAr(Idx)
     C                   ENDIF                                                                262433
     C                   ENDIF
     C                   ENDIF
      *
      ***  Discounts and guarantees must not have repayments
      *
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      70
     C     WLNPT         OREQ      71
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '70'
      *
     C     WSVFA         IFNE      *ZEROS
     C                   MOVE      'N'           DDFCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0416'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  For other loan types, repayments allowed dependent on the ccy
      ***  of the loan and fclty. If equal then no fclty allowed otherwise
      ***  loan and fclty repayment necessary.
      *
     C                   ELSE
      *
     C     W#CCY         IFEQ      FCCYF
      *
     C     DDFCRA        IFNE      *BLANK
     C                   MOVE      'N'           DDFCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0175'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDRAMT        IFNE      *BLANK
     C     DDFCRA        ANDEQ     *BLANK
     C     WSVRA         ORNE      *ZEROS
     C     WSVFA         ANDEQ     *ZEROS
     C**********         MOVE      'N'           DDFCRAOK                                    245104B
      * this will make this error message to become warning only, because the system fills    241018
      * the blank facility currency repayment amount from the calculation amount done above.  241018
     C*******************ADD       1             Idx                                          241018
     C**********         ADD       1             Widx                                 241018 245104B
     C*******************MOVEL     'DDFCRA'      FldNamXAr(Idx)                               241018
                                                                                             BUG3721
     C     DDRAMT        IFNE      '*'                                                       BUG3721
     C     DDRAMTOK      ANDNE     'N'                                                       BUG3721
     C     WSVRA         ANDNE     *ZEROS                                                    BUG3721
     C     WCFCRA        ANDNE     *ZEROS                                                    BUG3721
     C*******************MOVEL     'LEL0699'     MsgIDXAr(Idx)                        BUG3721 241018
     C**********         EVAL      WFldNamArr(Widx)='DDFCRA'                          241018 245104B
     C**********         EVAL      WMsgIDArr(Widx)='LEL0699'                          241018 245104B
                                                                                             BUG3721
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3721
     C                   MOVE      WCFCRA        ZFLD15                                      BUG3721
     C                   MOVE      'L'           ZECODE                                      BUG3721
     C**********         Z-ADD     WCDPL         ZDECS                             BUG3721 AR835048A
     C                   Z-ADD     A6NBDP        ZDECS                                     AR835048A
                                                                                             BUG3721
     C                   CALLB     'ZFRPED'                                                  BUG3721
     C                   PARM                    ZFLD15           15 0                       BUG3721
     C                   PARM                    ZDECS             1 0                       BUG3721
     C                   PARM                    ZECODE            1                         BUG3721
     C                   PARM      *BLANKS       ZOUT22                                      BUG3721
     C                   PARM      *BLANKS       ZOUT25                                      BUG3721
                                                                                             BUG3721
     C*******************MOVEL     ZOUT20        MsgDtaXAr(Idx)                       BUG3721 241018
     C**********         Eval      WMsgDtaArr(Widx)=ZOUT20                            241018 245104B
      * Move the calculated amount to facility currency repayment amount (defaulted)          241018
     C                   MOVE      ZOUT20        DDFCRA                                       241018
      *If the Input field WSVFA = 0, means the value of DDFCRA comes from the system default, 241018
      *    update also the Input field just to prevent the discrepancy.                       241018
     C                   IF        WSVFA=0 and DDFCRA<>*blank                                 241018
     C                   EVAL      WSVFA=WCFCRA                                               241018
     C                   ENDIF                                                                241018
      *                                                                                       241018
     C**********         ELSE                                                        BUG3721 245104B
      *****************************************************************              BUG3721 245104B
     C**********         ADD       1             Idx                                  241018 245104B
     C**********         MOVEL     'DDFCRA'      FldNamXAr(Idx)                       241018 245104B
     C**********         MOVEL     'LEL0175'     MsgIDXAr(Idx)                               245104B
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF
      * If the Facility Currency Repayment Amount has value, is should be equal to the        241018
      *        computed one.                                                                  241018
     C     DDFCRA        IFNE      *BLANK                                                     241018
     C**********         Z-ADD     WSVRT         ZRATE1                               241018 245104A
     C**********         MOVE      WSVIN         ZMDI1                                241018 245104A
     C**********         Z-ADD     A6SPRT        ZRATE2                               241018 245104A
     C**********         MOVE      A6MDIN        ZMDI2                                241018 245104A
      *****************************************************************               241018 245104A
     C**********         CALLB     'ZXRATE'                                           241018 245104A
     C**********         PARM                    ZRATE1           13 8                241018 245104A
     C**********         PARM                    ZMDI1             1                  241018 245104A
     C**********         PARM                    ZRATE2           13 8                241018 245104A
     C**********         PARM                    ZMDI2             1                  241018 245104A
     C**********         PARM                    ZRATEX           13 8                241018 245104A
     C**********         PARM                    ZMDIX             1                  241018 245104A
      *****************************************************************               241018 245104A
      ***Loan*ccy*repayment*amount*to*Facility*ccy*repayment*amount****               241018 245104A
      *****************************************************************               241018 245104A
     C**********         MOVE      CCLCCY        ZCCYI                                241018 245104A
     C**********         MOVE      @CYCD         ZCCYO                                241018 245104A
     C**********         MOVE      WCDPL         ZCDPI                                241018 245104A
     C**********         MOVE      A6NBDP        ZCDPO                                241018 245104A
     C**********         Z-ADD     WSVRA         ZAMTCI                               241018 245104A
     C**********         Z-ADD     ZRATEX        ZEXCH                                241018 245104A
     C**********         MOVE      ZMDIX         ZMD                                  241018 245104A
      *****************************************************************               241018 245104A
     C**********         CALLB     'ZCONV'                                            241018 245104A
     C**********         PARM                    ZAMTCI           15 0                241018 245104A
     C**********         PARM                    ZEXCH            13 8                241018 245104A
     C**********         PARM                    ZMD               1                  241018 245104A
     C**********         PARM                    ZCCYI             3                  241018 245104A
     C**********         PARM                    ZCCYO             3                  241018 245104A
     C**********         PARM                    ZCDPI             1 0                241018 245104A
     C**********         PARM                    ZCDPO             1 0                241018 245104A
     C**********         PARM                    ZAMTCO           15 0                241018 245104A
      *****************************************************************               241018 245104A
     C**********         Z-ADD     ZAMTCO        WCFCRA           13 0                241018 245104A
      *****************************************************************               241018 245104A
     C     WQFCXR        IFEQ      0                                                         245104A
     C**********         Z-ADD     WSVRT         ZRATE1                             245104A BUG16385
     C**********         MOVE      WSVIN         ZMDI1                              245104A BUG16385
     C**********         Z-ADD     A6SPRT        ZRATE2                             245104A BUG16385
     C**********         MOVE      A6MDIN        ZMDI2                              245104A BUG16385
     C                   Z-ADD     A6SPRT        ZRATE1                                     BUG16385
     C                   MOVE      A6MDIN        ZMDI1                                      BUG16385
     C                   Z-ADD     WSVRT         ZRATE2                                     BUG16385
     C                   MOVE      WSVIN         ZMDI2                                      BUG16385
      *                                                                                      245104A
     C                   CALLB     'ZXRATE'                                                  245104A
     C                   PARM                    ZRATE1           13 8                       245104A
     C                   PARM                    ZMDI1             1                         245104A
     C                   PARM                    ZRATE2           13 8                       245104A
     C                   PARM                    ZMDI2             1                         245104A
     C                   PARM                    ZRATEX           13 8                       245104A
     C                   PARM                    ZMDIX             1                         245104A
                                                                                            BUG16385
     C                   IF        FCCYF <> BJCYCD                                          BUG16385
      *                                                                                     BUG16385
     C                   IF        A6MDIN = 'M'                                             BUG16385
     C                   EVAL      ZMDIX = 'D'                                              BUG16385
     C                   ELSE                                                               BUG16385
     C                   EVAL      ZMDIX = 'M'                                              BUG16385
     C                   ENDIF                                                              BUG16385
     C                   ELSE                                                               BUG16385
     C                   EVAL      ZRATEX = WSVRT                                          AR835048B
     C                   IF        WSVIN = 'M'                                              BUG16385
     C                   EVAL      ZMDIX = 'M'                                              BUG16385
     C                   ELSE                                                               BUG16385
     C                   EVAL      ZMDIX = 'D'                                              BUG16385
     C                   ENDIF                                                              BUG16385
      *                                                                                     BUG16385
     C                   ENDIF                                                              BUG16385
                                                                                            BUG16385
     C                   ENDIF                                                               245104A
      *                                                                                      245104A
      ** Loan ccy repayment amount to Facility ccy repayment amount                          245104A
      *                                                                                      245104A
     C                   MOVE      CCLCCY        ZCCYI                                       245104A
     C                   MOVE      @CYCD         ZCCYO                                       245104A
     C                   MOVE      WCDPL         ZCDPI                                       245104A
     C                   MOVE      A6NBDP        ZCDPO                                       245104A
     C                   Z-ADD     WSVRA         ZAMTCI                                      245104A
      ** Use the Facility Currency Exchange Rate if entered.                                 245104A
     C     WQFCXR        IFNE      0                                                         245104A
     C                   Z-ADD     WQFCXR        ZEXCH                                       245104A
     C                   MOVE      DDFMIN        ZMD                                         245104A
     C                   ELSE                                                                245104A
     C                   Z-ADD     ZRATEX        ZEXCH                                       245104A
     C                   MOVE      ZMDIX         ZMD                                         245104A
     C                   ENDIF                                                               245104A
      *                                                                                      245104A
     C                   CALLB     'ZCONV'                                                   245104A
     C                   PARM                    ZAMTCI           15 0                       245104A
     C                   PARM                    ZEXCH            13 8                       245104A
     C                   PARM                    ZMD               1                         245104A
     C                   PARM                    ZCCYI             3                         245104A
     C                   PARM                    ZCCYO             3                         245104A
     C                   PARM                    ZCDPI             1 0                       245104A
     C                   PARM                    ZCDPO             1 0                       245104A
     C                   PARM                    ZAMTCO           15 0                       245104A
      *                                                                                      245104A
     C                   Z-ADD     ZAMTCO        WCFCRA           13 0                       245104A
     C     WSVFA         IFNE      WCFCRA                                                     241018
     C                   MOVE      *BLANKS       ZFLD15                                       241018
     C                   MOVE      WCFCRA        ZFLD15                                       241018
     C                   MOVE      'L'           ZECODE                                       241018
     C**********         Z-ADD     WCDPL         ZDECS                               241018 AR835048
     C                   Z-ADD     A6NBDP        ZDECS                                      AR835048
                                                                                              241018
     C                   CALLB     'ZFRPED'                                                   241018
     C                   PARM                    ZFLD15           15 0                        241018
     C                   PARM                    ZDECS             1 0                        241018
     C                   PARM                    ZECODE            1                          241018
     C                   PARM      *BLANKS       ZOUT22                                       241018
     C                   PARM      *BLANKS       ZOUT25                                       241018
     C                   MOVE      'N'           DDFCRAOK                                     241018
     C                   ADD       1             Idx                                          241018
                                                                                              241018
     C**********         MOVEL     ZOUT20        MsgDtaXar(idx)                      241018 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      MsgDtaXar(idx) = LenStr +%TRIM(ZOUT20)                   MD000091
     C                   MOVEL     'DDFCRA'      FldNamXAr(Idx)                               241018
     C                   MOVEL     'LEL0806'     MsgIDXAr(Idx)                                241018
     C                   ENDIF                                                                241018
     C                   ENDIF                                                                241018
      *
     C     DDFCRA        IFNE      *BLANK
     C     DDRAMT        ANDEQ     *BLANK
     C     WSVFA         ORNE      *ZEROS
     C     WSVRA         ANDEQ     *ZEROS
     C                   MOVE      'N'           DDFCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0175'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must be the equivalent of the loan currency repayment amount
      ***  in the facility currency allowing for the exchange rate tolerance
      *
     C     CCLCHTP       IFEQ      'I'
     C     DDFCRAOK      ANDNE     'N'                                                        CLE106
     C*****WSVRA         MULT      .75           WSVRAM           13 0                        243057
     C     WCFCRA        MULT      .75           WSVRAM           13 0                        243057
     C*****WSVRA         MULT      1.25          WSVRAP           13 0                        243057
     C     WCFCRA        MULT      1.25          WSVRAP           13 0                        243057
     C     ZAMTCO        IFLT      WSVRAM
     C     ZAMTCO        ORGT      WSVRAP
     C**********         MOVE      'N'           DDFCRAOK                                     243057
     C                   MOVE      'W'           DDFCRAOK                                     243057
     C**********         ADD       1             Idx                                          243057
     C                   ADD       1             WId                                          243057
     C**********         MOVEL     'DDFCRA'      FldNamXAr(Idx)                               243057
     C                   MOVEL     'DDFCRA'      WFldNmXAr(WId)                               243057
      ******************************************************************************* BUG3721 241018
     C*****DDRAMT        IFNE      '*'                                                BUG3721 241018
     C*****DDRAMTOK      ANDNE     'N'                                                BUG3721 241018
     C*****WSVRA         ANDNE     *ZEROS                                             BUG3721 241018
     C*****WCFCRA        ANDNE     *ZEROS                                             BUG3721 241018
     C**********         MOVEL     'LEL0699'     MsgIDXAr(Idx)                        BUG3721 241018
      **********                                                                      BUG3721 241018
     C**********         MOVE      *BLANKS       ZFLD15                               BUG3721 241018
     C**********         MOVE      WCFCRA        ZFLD15                               BUG3721 241018
     C**********         MOVE      'L'           ZECODE                               BUG3721 241018
     C**********         Z-ADD     WCDPL         ZDECS                                BUG3721 241018
      **********                                                                      BUG3721 241018
     C**********         CALLB     'ZFRPED'                                           BUG3721 241018
     C**********         PARM                    ZFLD15           15 0                BUG3721 241018
     C**********         PARM                    ZDECS             1 0                BUG3721 241018
     C**********         PARM                    ZECODE            1                  BUG3721 241018
     C**********         PARM      *BLANKS       ZOUT22                               BUG3721 241018
     C**********         PARM      *BLANKS       ZOUT25                               BUG3721 241018
      **********                                                                      BUG3721 241018
     C**********         MOVEL     ZOUT20        MsgDtaXAr(Idx)                       BUG3721 241018
     C**********         ELSE                                                         BUG3721 241018
      **********                                                                      BUG3721 241018
     C**********         MOVEL     'LEL0503'     MsgIDXAr(Idx)                                243057
     C                   MOVEL     'LEL0503'     WMsgIDXAr(WId)                               243057
     C**********         ENDIF                                                        BUG3721 241018
      **********                                                                      BUG3721 241018
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     DDFCRAOK      IFNE      'N'
     C                   MOVE      WSVFA         CCLFCRA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNRPD - Validate repayment date                             *
      *****************************************************************
     C     SRNRPD        BEGSR
      *
     C                   Z-ADD     *ZEROS        WSVRP
     C     DDNRPD        IFNE      *BLANKS
     C                   DO
      *                                                                                    AR1067935
      ** Next Repayment Date must be blank for PDCL.                                       AR1067935
      *                                                                                    AR1067935
     C                   IF        CLE134      = 'Y'                                       AR1067935
     C                   IF        %SUBST(CCLLTYP:1:1) = 'X'     OR                        AR1067935
     C                             %SUBST(CCLLTYP:1:1) = 'Y'     OR                        AR1067935
     C                             %SUBST(CCLLTYP:1:1) = 'Z'                               AR1067935
     C                   IF        CCLCHTP <> 'A'                                          MD022807C
     C                   MOVE      'N'           DDNRPDOK                                  AR1067935
     C                   ADD       1             Idx                                       AR1067935
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)                            AR1067935
     C                   MOVEL     '5045905'     MsgIDXAr(Idx)                             AR1067935
     C                   LEAVE                                                             AR1067935
     C                   ENDIF                                                             MD022807C
     C                   ENDIF                                                             AR1067935
     C                   ENDIF                                                             AR1067935
      *
     C                   MOVEL     DDNRPD        WNUM7             7 0
     C                   MOVEL     WNUM7         WALF6             6
     C                   MOVE      DDNRPD        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        WSVRP
     C                   Z-ADD     ZDAYNO        W@NRPD
     C     ZERR          IFNE      *BLANKS
     C     DDNRPD        ORNE      WALF6
     C                   MOVE      'N'           DDNRPDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0157'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *                                                                                    MD022807C
      ** Repayment Date amendment is prohibited for PDCLs                                  MD022807C
      *                                                                                    MD022807C
     C                   IF         CLE134 = 'Y' AND CCLCHTP = 'A'                         MD022807C
     C                              AND WSVRP <> @@NRPD AND                                MD022807C
     C                             (%SUBST(CCLLTYP:1:1) = 'X' OR                           MD022807C
     C                              %SUBST(CCLLTYP:1:1) = 'Y' OR                           MD022807C
     C                              %SUBST(CCLLTYP:1:1) = 'Z')                             MD022807C
     C                   MOVE      'N'           DDNRPDOK                                  MD022807C
     C                   ADD       1             Idx                                       MD022807C
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)                            MD022807C
     C                   MOVEL     '5046138'     MsgIDXAr(Idx)                             MD022807C
     C                   LEAVE                                                             MD022807C
     C                   ENDIF                                                             MD022807C
      *
      ***  Must be greater than interest accrual control date
      *
     C                   MOVE      '0'           WIN71             1
     C     CCLCHTP       IFEQ      'I'
     C                   Z-ADD     WSVVD         CCLIACD
     C                   Z-ADD     *ZERO         CCLGDIN
     C                   Z-ADD     *ZERO         CCLGDPR
     C                   ENDIF
      *                                                                                    AR1085248
      ** Skip validation against IACD if repayment date                                    AR1085248
      ** is not changed.                                                                   AR1085248
      *                                                                                    AR1085248
     C     CCLNRPD       IFNE      W@NRPD                                                  AR1085248
     C     WSVRP         IFLE      CCLIACD
      *
      ***  Consider the grace day period for the next repayment date.
      *
     C     CCLIACD       SUB       WSVRP         WNUM2             2 0
     C     CCLGDIN       IFGT      CCLGDPR
     C                   Z-ADD     CCLGDPR       WNUM4             2 0
     C                   ELSE
     C                   Z-ADD     CCLGDIN       WNUM4
     C                   ENDIF
     C     DDREPT        IFEQ      '2'
     C     WNUM2         IFGT      CCLGDPR
     C     CCLGDPR       ANDGT     *ZERO
     C     CCLGDPR       OREQ      *ZERO
     C                   MOVE      '1'           WIN71
     C                   ENDIF
     C                   ELSE
     C     WNUM2         IFGT      WNUM4
     C     WNUM4         ANDGT     *ZERO
     C     WNUM4         OREQ      *ZERO
     C                   MOVE      '1'           WIN71
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                             AR1085248
      *
      ***  If new maturity date is entered, repayment date must be
      ***  earlier than new maturity date, else, repayment date must be
      ***  earlier than maturity date
      *
     C     WSVRP         IFGT      CCLIACD
     C     CCLMDAT       ANDNE     *ZEROS
     C     CCLNMDT       IFGT      *ZEROS
     C     CCLCHTP       ANDNE     'I'
     C                   Z-ADD     CCLNMDT       W0MDT             5 0
     C                   ELSE
     C                   Z-ADD     WSVMD         W0MDT
     C                   ENDIF
     C*****WSVRP*        IFGE      W0MDT                                                      241648
     C     WSVRP         IFGT      W0MDT                                                      241648
     C                   MOVE      '1'           WIN71
     C                   ENDIF
     C     WSVRP         IFEQ      W0MDT                                                   AR740107A
     C                   MOVE      'W'           DDNRPDOK                                  AR740107A
     C                   ADD       1             WId                                       AR740107A
     C                   MOVEL     'DDNRPD'      WFldNmXAr(WId)                            AR740107A
     C**********         MOVEL     'LEL0813'     WMsgIDXAr(WId)                  AR740107A AR1096933
     C                   EVAL      WMsgIDXAr(WId) = '5045918'                              AR1096933
     C                   ENDIF                                                             AR740107A
     C                   ENDIF
      *                                                                                     AR740107
      ** If Next repayment date is amended equal to Maturity date                           AR740107
      ** generate a warning message.                                                        AR740107
      *                                                                                     AR740107
     C     WSVRP         IFNE      CCLNRPD                                                  AR740107
     C     WSVRP         ANDEQ     W0MDT                                                    AR740107
     C                   MOVE      'W'           DDNRPDOK                                   AR740107
     C                   ADD       1             WId                                        AR740107
     C                   MOVEL     'DDNRPD'      WFldNmXAr(WId)                             AR740107
     C**********         MOVEL     'LEL0813'     WMsgIDXAr(WId)                   AR740107 AR1096933
     C                   EVAL      WMsgIDXAr(WId) = '5045918'                              AR1096933
     C                   ENDIF                                                              AR740107
      *
     C     WIN71         IFEQ      '1'
     C                   MOVE      'N'           DDNRPDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)
     C     CCLCHTP       IFEQ      'I'
     C                   MOVEL     'LEL0158'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     'LEL0508'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
                                                                                             BUG3721
      ** If Rule of 78s is installed, loan processing type is '80'                           BUG3721
      ** and Repayment Date Field is amendable,  the First Repayment Da                      BUG3721
      ** te must fall within the following range:                                            BUG3721
      ** Rep Freq   No. of Days from the Start Date                                          BUG3721
      **    W            14                                                                  BUG3721
      **    F            28                                                                  BUG3721
      **    S            30                                                                  BUG3721
      **    M            60                                                                  BUG3721
      **    T           120                                                                  BUG3721
      **    Q           180                                                                  BUG3721
      **    X           360                                                                  BUG3721
      **    Y           720                                                                  BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     CCLCHTP       IFEQ      'I'                                                       BUG3721
     C     CCLCHTP       OREQ      'A'                                                       BUG3721
     C     WPRCS2        ANDNE     'Y'                                                       BUG3721
     C     WSVRP         SUB       WSVVD         WDAYS             5 0                       BUG3721
                                                                                             BUG3721
     C*****DDRFRQ        IFEQ      'W'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     14                                                 BUG3721 CLE064
     C*****DDRFRQ        OREQ      'F'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     28                                                 BUG3721 CLE064
     C*****DDRFRQ        OREQ      'S'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     30                                                 BUG3721 CLE064
     C*****DDRFRQ        OREQ      'M'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     60                                                 BUG3721 CLE064
     C*****DDRFRQ        OREQ      'T'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     120                                                BUG3721 CLE064
     C*****DDRFRQ        OREQ      'Q'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     180                                                BUG3721 CLE064
     C*****DDRFRQ        OREQ      'X'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     360                                                BUG3721 CLE064
     C*****DDRFRQ        OREQ      'Y'                                                BUG3721 CLE064
     C*****WDAYS         ANDGT     720                                                BUG3721 CLE064
                                                                                              CLE064
     C                   EVAL      XFREQ = %LOOKUP(DDRFRQ:NFREQ)                              CLE064
     C                   EVAL      XDAYS = NDAYS(XFREQ)                                       CLE064
     C     WDAYS         IFGT      XDAYS                                                      CLE064
                                                                                             BUG3721
     C                   MOVE      'N'           DDNRPDOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0577'     MsgIDXAr(Idx)                               BUG3721
     C                   LEAVE                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
      *
      ***  Must be blank if repayment amount is zero
      ***  Must be entered if repayment amount is entered
      *
     C     DDRAMTOK      IFNE      'N'
     C     WRAMT1        ANDNE     '*'                                                       BUG3721
     C                   MOVEA     DDRAMT        AMTAB
     C                   MOVEA     NUMS          NUM
     C                   Z-ADD     1             CNT               2 0
      *
     C     CNT           DOWLE     15
     C     AMTAB(CNT)    LOOKUP    NUM                                    69
      *
     C     *IN69         IFEQ      *ON
     C                   Z-ADD     15            CNT
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C                   ENDDO
      *
      ** If participant allow 0 repayment amount                                              CLE106
                                                                                              CLE106
     C     *IN69         IFEQ      *OFF
     C     DDPTFC        ANDEQ     *Blanks                                                    CLE106
     C                   MOVE      'N'           DDNRPDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0200'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
     C     DDRAMTOK      IFNE      'N'
     C     WRAMT1        ANDNE     '*'                                                       BUG3721
     C                   MOVEA     NUMS          NUM
     C                   MOVEA     DDRAMT        AMTAB
     C                   Z-ADD     1             CNT               2 0
      *
     C     CNT           DOWLE     15
     C     AMTAB(CNT)    LOOKUP    NUM                                    69
      *
     C     *IN69         IFEQ      *ON
     C                   Z-ADD     15            CNT
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C                   ENDDO
      *
      ** If participant allow 0 repayment amount                                              CLE106
                                                                                              CLE106
     C     *IN69         IFEQ      *ON
     C     DDPTFC        ANDEQ     *Blanks                                                    CLE106
     C                   MOVE      'N'           DDNRPDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNRPD'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0200'     MsgIDXAr(Idx)
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDNRPDOK      IFNE      'N'
     C                   MOVE      WSVRP         CCLNRPD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRFRQ - Validate repayment frequency/day number             *
      *****************************************************************
     C     SRRFRQ        BEGSR
      *                                                                                    MD022807C
      ** Repayment Freq/Day No amendment is prohibited for PDCLs                           MD022807C
      *                                                                                    MD022807C
     C                   IF        CLE134 = 'Y' AND CCLCHTP = 'A'                          MD022807C
     C                             AND (%SUBST(CCLLTYP:1:1) = 'X' OR                       MD022807C
     C                                  %SUBST(CCLLTYP:1:1) = 'Y' OR                       MD022807C
     C                                  %SUBST(CCLLTYP:1:1) = 'Z')                         MD022807C
     C                   IF        DDRFRQ <> @@RFRQ                                        MD022807C
     C                   MOVE      'N'           DDRFRQOK                                  MD022807C
     C                   ADD       1             Idx                                       MD022807C
     C                   MOVEL     'DDRFRQ'      FldNamXAr(Idx)                            MD022807C
     C                   MOVEL     '5046138'     MsgIDXAr(Idx)                             MD022807C
     C                   ENDIF                                                             MD022807C
     C                   MOVE      DDRDYN        NNRDYN            2 0                     MD022807C
     C                   IF        NNRDYN <> @@RDYN                                        MD022807C
     C                   MOVE      'N'           DDRDYNOK                                  MD022807C
     C                   ADD       1             Idx                                       MD022807C
     C                   MOVEL     'DDRDYN'      FldNamXAr(Idx)                            MD022807C
     C                   MOVEL     '5046138'     MsgIDXAr(Idx)                             MD022807C
     C                   ENDIF                                                             MD022807C
     C                   ENDIF                                                             MD022807C
     C                                                                                     MD022807C
      *
     C     CLE028        IFEQ      'N'                                                       BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WLNPT         ANDNE     80                                                        BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     CCLCHTP       ANDEQ     'I'                                                       BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     CCLCHTP       ANDEQ     'A'                                                       BUG3721
     C     WPRCS2        ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     DDRFRQ        IFNE      *BLANKS
     C     DDNRPD        IFEQ      *BLANKS
     C                   MOVE      'N'           DDRFRQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRFRQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0201'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C     DDRFRQ        LOOKUP    WFREQ                                  89
     C     *IN89         IFEQ      '0'
     C                   MOVE      'N'           DDRFRQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRFRQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0055'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
                                                                                             BUG3721
      ** Repayment frequency mandatory for flat rate personal loans                          BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     CCLCHTP       IFEQ      'I'                                                       BUG3721
     C     CCLCHTP       OREQ      'A'                                                       BUG3721
     C     WPRCS2        ANDNE     'Y'                                                       BUG3721
     C                   MOVE      'N'           DDRFRQOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDRFRQ'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0558'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDRDYN        IFNE      *BLANKS
     C                   MOVE      'N'           DDRDYNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRDYN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0277'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be numeric from 1 to 31
      *
     C     DDRDYNOK      IFNE      'N'
     C     DDRDYN        ANDNE     *BLANKS
     C                   MOVEL     DDRDYN        WNUM3             3 0
     C                   MOVEL     WNUM3         WALF2             2
     C     DDRDYN        IFNE      WALF2
     C     DDRDYN        ORLT      '01'
     C     DDRDYN        ORGT      '31'
     C                   MOVE      'N'           DDRDYNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRDYN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0279'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Day number must be left blank for W or F (weekly/every
      ***  two weeks)
      *
     C     DDRFRQOK      IFNE      'N'
     C     DDRDYNOK      ANDNE     'N'
     C     DDRDYN        ANDNE     *BLANKS
     C     DDRFRQ        IFEQ      'W'
     C     DDRFRQ        OREQ      'F'
     C                   MOVE      'N'           DDRDYNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRDYN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0056'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  If repayment day number is blank, default to repay day
      *
     C     DDRDYN        IFEQ      *BLANKS
     C     DDRFRQ        ANDNE     *BLANK
     C     DDRFRQ        ANDNE     *BLANK
     C     DDRFRQ        ANDNE     'W'
     C     DDRFRQ        ANDNE     'F'
     C     DDNRPDOK      ANDNE     'N'
     C     DDRFRQOK      ANDNE     'N'
     C     DDRDYNOK      ANDNE     'N'
     C                   MOVE      DDNRPD        WDATE
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      WDAT2         DDRDYN
     C                   ELSE
     C                   MOVE      WDAT1         DDRDYN
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      DDRDYN        WRDYN
     C                   ENDIF                                                               BUG3721
      *
     C     DDRFRQOK      IFNE      'N'
     C                   MOVEL     DDRFRQ        CCLRFRQ
     C                   ENDIF
      *
     C     DDRDYNOK      IFNE      'N'
     C                   MOVE      DDRDYN        CCLRDYN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3721
      *  SRFRPD - Validate Repayment Amount/ First Repayment Date     *                      BUG3721
      *****************************************************************                      BUG3721
     C     SRFRPD        BEGSR                                                               BUG3721
                                                                                             BUG3721
      ** For flat rate personal loans, if insert check that interest                         BUG3721
      ** entered is within the calculated amount to be within                                BUG3721
      ** one unit of the currency specified.                                                 BUG3721
      ** Do this if amount, maturity date, base rate, spread rate,                           BUG3721
      ** interest basis, repayment frequency, repayment date,                                BUG3721
      ** repayment day in month, include charges in interest,                                BUG3721
      ** charge amount, currency, and location are valid                                     BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     DDCHGAOK      ANDNE     'N'                                          *IN39        BUG3721
     C     DDMDATOK      ANDNE     'N'                                          *IN44        BUG3721
     C     DDBRTTOK      ANDNE     'N'                                          *IN47        BUG3721
     C     DDRTSPOK      ANDNE     'N'                                          *IN49        BUG3721
     C     DDBASROK      ANDNE     'N'                                                        CLE035
     C     DDFXRTOK      ANDNE     'N'                                                        CLE035
     C     DDCALCOK      ANDNE     'N'                                          *IN54        BUG3721
     C     DDIPRDOK      ANDNE     'N'                                          *IN55        BUG3721
     C     DDRAMTOK      ANDNE     'N'                                          *IN69        BUG3721
     C     DDRFRQOK      ANDNE     'N'                                          *IN72        BUG3721
     C     DDNRPDOK      ANDNE     'N'                                          *IN71        BUG3721
     C     DDRDYNOK      ANDNE     'N'                                          *IN73        BUG3721
     C     DDICIFOK      ANDNE     'N'                                          *IN38        BUG3721
                                                                                             BUG3721
     C     CCLCHTP       IFEQ      'I'                                                       BUG3721
     C     CCLCHTP       OREQ      'A'                                                       BUG3721
     C     WPRCS2        ANDNE     'Y'                                                       BUG3721
     C                   EXSR      SRCIN8                                                    BUG3721
                                                                                             BUG3721
     C     DDIPRDOK      IFNE      'N'                                                       BUG3721
     C                   Z-ADD     WTOTI         CCLFLTI                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C                   Z-ADD     CCLFLTI       WTOTI                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDCHGAOK      IFNE      'N'                                                       BUG3721
     C     DDMDATOK      ANDNE     'N'                                                       BUG3721
     C     DDBRTTOK      ANDNE     'N'                                                       BUG3721
     C     DDRTSPOK      ANDNE     'N'                                                       BUG3721
     C     DDBASROK      ANDNE     'N'                                                        CLE035
     C     DDFXRTOK      ANDNE     'N'                                                        CLE035
     C     DDCALCOK      ANDNE     'N'                                                       BUG3721
     C     DDIPRDOK      ANDNE     'N'                                                       BUG3721
     C     DDREPTOK      ANDNE     'N'                                                       BUG3721
     C     DDRAMTOK      ANDNE     'N'                                                       BUG3721
     C     DDRFRQOK      ANDNE     'N'                                                       BUG3721
     C     DDNRPDOK      ANDNE     'N'                                                       BUG3721
     C     DDRDYNOK      ANDNE     'N'                                                       BUG3721
     C     DDICIFOK      ANDNE     'N'                                                       BUG3721
     C     WLNPT         ANDNE     63                                                        BUG3721
     C     WLNPT         ANDNE     65                                                        BUG3721
     C     WLNPT         ANDNE     67                                                        BUG3721
                                                                                             BUG3721
     C     WPRCS2        IFNE      'Y'                                                       BUG3721
     C                   EXSR      SRCRPA                                                    BUG3721
     C                   Z-ADD     WSVRP         WFRPD             5 0                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     CCLFRPD       WFRPD                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     WFRPD         CCLFRPD                                     BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************
      *  SRBTIN - Validate bill/telex indicator                       *
      *           (for loans and parts purch)                         *
      *****************************************************************
     C     SRBTIN        BEGSR
      *
     C     *IN83         IFEQ      '0'
     C     DDBTIN        IFEQ      *BLANK
     C                   MOVE      BPBTIN        DDBTIN
     C                   ENDIF
     C     DDBTIN        IFNE      'B'
     C     DDBTIN        ANDNE     'T'
     C     DDBTIN        ANDNE     'N'
     C                   MOVE      'N'           DDBTINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBTIN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0169'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDBTINOK      IFNE      'N'
     C                   MOVEL     DDBTIN        CCLBTIN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBLDY - Validate billing days                               *
      *           (for loans and parts purchased)                     *
      *****************************************************************
     C     SRBLDY        BEGSR
      *
     C     *IN83         IFEQ      '0'
     C     DDBLDY        IFEQ      *BLANKS
     C     DDBTINOK      ANDNE     'N'
     C     DDBTIN        IFEQ      'N'
     C                   MOVE      '00'          DDBLDY
     C                   ELSE
     C                   MOVE      BPDBDY        DDBLDY
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be 0 if bill/telex indicator is 'N'
      ***  Must be from 1 to 28 if bill/telex indicator is 'B'
      ***  Must be from 1 to 9 if bill/telex indicator is 'T'
      *
     C     DDBTIN        IFEQ      'N'
     C     DDBLDY        ANDNE     '00'
      *
     C     DDBTIN        OREQ      'B'
     C     DDBLDY        ANDGT     '28'
     C     DDBTIN        OREQ      'B'
     C     DDBLDY        ANDLT     '01'
      *
     C     DDBTIN        OREQ      'T'
     C     DDBLDY        ANDGT     '09'
     C     DDBTIN        OREQ      'T'
     C     DDBLDY        ANDLT     '01'
     C                   MOVE      'N'           DDBLDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBLDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0170'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDBLDYOK      IFNE      'N'
     C                   MOVE      DDBLDY        CCLBLDY
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCINT - Calculate interest amount between value date        *
      *           and maturity date                                   *
      *****************************************************************
     C     SRCINT        BEGSR
      *
     C                   Z-ADD     WSVVD         ZIBEG
     C     CCLCHTP       IFEQ      'A'
     C                   Z-ADD     CCLSLID       ZIBEG
     C                   ENDIF
     C                   MOVE      CCLICBS       ZICALC
     C     WSVID         IFEQ      0                                                          246516
     C                   Z-ADD     WSVMD         ZIEND
     C                   ELSE                                                                 246516
     C                   Z-ADD     WSVID         ZIEND                                        246516
     C                   END                                                                  246516
     C     ZIEND         IFEQ      *ZEROS
     C     WSVVD         ADD       1             ZIEND
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00618
      *
      ***  Accrual on first/last day indicator for loans
      *
     C     *IN82         IFEQ      '0'
     C     *IN83         ANDEQ     '0'
     C     DDADDI        IFEQ      'B'
     C     CCLCHTP       IFEQ      'A'
     C     CCLIACD       IFEQ      WSVVD
     C     ZIEND         ADD       1             ZIEND
     C                   ENDIF
     C                   ELSE
     C     ZIEND         ADD       1             ZIEND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     WSVAM         ZIAMT
     C                   Z-ADD     WINTT         ZIRATE
      *                                                                                     BUG22311
      ***  Adjust no. of days For Additional Day Indicator = 'L'                            BUG22311
      *                                                                                     BUG22311
     C     DDADDI        IFEQ      'L'                                                      BUG22311
     C                   Z-ADD     ZIBEG         ZIBEG1            5 0                      BUG22311
     C                   ADD       1             ZIBEG1                                     BUG22311
     C                   Z-ADD     ZIBEG1        ADDAYN            5 0                      BUG22311
     C                   CALLB     'ZDATE9'                                                 BUG22311
     C                   PARM                    ADDAYN                                     BUG22311
     C                   PARM                    ADVDT             8 0                      BUG22311
     C                   PARM                    ADRTN             1                        BUG22311
      *                                                                                     BUG22311
     C     ADRTN         IFEQ      *BLANKS                                                  BUG22311
     C                   Z-ADD     ADVDT         ADATEA                                     BUG22311
     C                   ENDIF                                                              BUG22311
      *                                                                                     BUG22311
     C                   Z-ADD     ZIEND         ZIEND1            5 0                      BUG22311
     C                   ADD       1             ZIEND1                                     BUG22311
     C                   Z-ADD     ZIEND1        ADDAYN                                     BUG22311
     C                   CALLB     'ZDATE9'                                                 BUG22311
     C                   PARM                    ADDAYN                                     BUG22311
     C                   PARM                    ADVDT                                      BUG22311
     C                   PARM                    ADRTN                                      BUG22311
      *                                                                                     BUG22311
     C     ADRTN         IFEQ      *BLANKS                                                  BUG22311
     C                   Z-ADD     ADVDT         ADATEB                                     BUG22311
     C                   ENDIF                                                              BUG22311
      *                                                                                     BUG22311
     C     ADYY2         IFGT      ADYY1                                                    BUG22311
     C                   Z-ADD     ZIBEG1        ZIBEG                                      BUG22311
     C                   Z-ADD     ZIEND1        ZIEND                                      BUG22311
     C                   ENDIF                                                              BUG22311
      *                                                                                     BUG22311
     C                   ENDIF                                                              BUG22311
      *
     C                   CALLB     'MM1030'
     C                   PARM                    ZIBEG             5 0
     C                   PARM                    ZIEND             5 0
     C                   PARM                    ZICALC            1
     C                   PARM                    ZIAMT            15 0
     C                   PARM                    ZIRATE           11 7
     C                   PARM                    CCLRDFC
     C                   PARM      *ZERO         ZINTR            15 0
      *
      ***  For amend
      *
     C     CCLCHTP       IFEQ      'A'
     C     DDRDFC        IFEQ      'N'
     C                   Z-ADD(H)  ZINTR         WTOTI
     C                   ELSE
     C                   Z-ADD     ZINTR         WTOTI
     C                   ENDIF
     C                   ENDIF
      *
      ***  For insert
      *
     C     CCLCHTP       IFEQ      'I'
      *
     C     DDRDFC        IFEQ      'N'
     C                   Z-ADD(H)  ZINTR         WCHKI            13 0
     C                   ELSE
     C                   Z-ADD     ZINTR         WCHKI
     C                   ENDIF

     C*****WCHKI         IFLT      *ZEROS                                                   AR988460
     C**********         Z-SUB     WCHKI         WCHKI                                      AR988460
     C**********         MOVE      'Y'           WSUB              1                        AR988460
     C**********         ELSE                                                               AR988460
     C**********         MOVE      *BLANK        WSUB                                       AR988460
     C**********         ENDIF                                                              AR988460
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WCHKI         ZFLD15
     C                   Z-ADD     WCDPL         ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM      *BLANKS       ZOUT22
     C                   PARM      *BLANKS       ZOUT25           25
      *
      ***  For batch mode or if the input interest is '*'
      ***  interest is the calculated interest with no need to validate
      ** If '*' is entered in the interest/discount amount field default the                 BUG3721
      ** calculated interest to DDIPRD                                                       BUG3721
      *
     C                   MOVEL     DDIPRD        WIPRD1                                      BUG3721
      *                                                                                      BUG3721
     C     RespMode      IFNE      'S'
     C     DDIPRD        OREQ      '*'
     C     WIPRD1        OREQ      '*'                                                       BUG3721
     C     DDIPRD        OREQ      *BLANKS                                                    CER043
     C     CER043        ANDEQ     'Y'                                                        CER043
     C/COPY WNCPYSRC,LEH00701
      *
     C                   Z-ADD     WCHKI         WTOTI
     C     WCHKI         IFLT      0                                                        MD036008
     C                   MOVE      ZOUT22        DDIPRD                                     MD036008
     C                   ELSE                                                               MD036008
     C                   MOVE      ZOUT20        DDIPRD
     C                   ENDIF                                                              MD036008
      *
     C                   ELSE
      *
     C     WTOTI         SUB       WCHKI         WCHK2            13 0
     C     WCHK2         IFLT      *ZEROS
     C                   Z-SUB     WCHK2         WCHK2
     C                   ENDIF
                                                                                              CAP086
      ** If Auto-authorise and CAP086 is enable, bypass tolerance validation                  CAP086
      ** for interest calculation.                                                            CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             IF_AUTH = 'Y'                                              CAP086
     C                   EVAL      WCHK2 = *ZERO                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *
      ***  Check that the calculated amount should be within one unit
      ***  of the currency specified
      ***  If entry is invalid, display the calculated discount or
      ***  interest
      *
     C     WCHK2         IFGT      1
     C     WCHK2         ORLT      -1                                                       AR988460
     C                   MOVE      'N'           DDIPRDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIPRD'      FldNamXAr(Idx)
     C     WLNPT         IFEQ      63
     C     WLNPT         OREQ      65
     C     WLNPT         OREQ      67
     C     WLNPT         OREQ      72
     C     W72TP         ANDEQ     '67'
     C                   MOVEL     'LEL0003'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     'LEL0004'     MsgIDXAr(Idx)
     C                   ENDIF
     C**********         MOVEL     ZOUT20        MsgDtaXAr(Idx)                             MD000091
     C     ZNEG          IFEQ      '-'                                                      MD052515
     C                   MOVE      *BLANKS       WRKFLD1          20                        MD052515
     C                   EVAL      WRKFLD1 = %trim(ZOUT20)                                  MD052515
     C     '-'           CAT       WRKFLD1       ZOUT20                                     MD052515
     C                   ENDIF                                                              MD052515
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(ZOUT20)                   MD000091
     C                   ENDIF
     C                   ENDIF
      *
     C     DDIPRDOK      IFNE      'N'
     C     WSUB          ANDEQ     'Y'
     C                   Z-SUB     WTOTI         WTOTI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      * SRCIN8  -  Calculate interest amount for Flat Rate Personal   *                      BUG3721
      *            Loans                                              *                      BUG3721
      * Called by: SRVAL2 - Validate second detail screen             *                      BUG3721
      * Calls    : INRP78 - Calculate total flat interest & principal *                      BUG3721
      *                     repayment based on Rule of 78             *                      BUG3721
      *****************************************************************                      BUG3721
     C     SRCIN8        BEGSR                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     WSVVD         ZIBEG                                       BUG3721
     C                   MOVE      DDCALC        ZICALC                                      BUG3721
     C                   Z-ADD     WSVMD         ZIEND                                       BUG3721
                                                                                             BUG3721
      ** For flat rate personal loans use INRP78 subroutine                                  BUG3721
      ** to compute the interest rate                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     ZIEND         W78MDT                                      BUG3721
     C                   Z-ADD     WSVAM         W78PRN                                      BUG3721
     C                   Z-ADD     WINTT         W78IRT                                      BUG3721
     C                   MOVE      DDRFRQ        W78RPF                                      BUG3721
     C                   Z-ADD     WSVRP         W78RPD                                      BUG3721
     C                   MOVE      DDRDYN        W78RPM                                      BUG3721
     C                   MOVE      DDICIF        W78ICI                                      BUG3721
     C                   Z-ADD     WCHGA         W78CGA                                      BUG3721
     C                   MOVE      W#CCY         W78CCY                                      BUG3721
     C                   MOVE      *BLANKS       W78LCN                                      BUG3721
                                                                                             BUG3721
     C                   EXSR      INRP78                                                    BUG3721
                                                                                             BUG3721
     C                   Z-ADD     W78INT        ZINTR                                       BUG3721
     C                   Z-ADD(H)  W78RPY        WRPYA            13 0                       BUG3721
                                                                                             BUG3721
      ** Validate interest for insert and amend only                                         BUG3721
                                                                                             BUG3721
     C     CCLCHTP       IFEQ      'I'                                                       BUG3721
     C     CCLCHTP       OREQ      'A'                                                       BUG3721
     C     WPRCS2        ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C                   MOVE      *BLANK        WSUB              1                         BUG3721
     C                   Z-ADD(H)  ZINTR         WCHKI            13 0                       BUG3721
     C*****WCHKI         IFLT      *ZEROS                                           BUG3721 AR988460
     C**********         Z-SUB     WCHKI         WCHKI                              BUG3721 AR988460
     C**********         MOVE      'Y'           WSUB                               BUG3721 AR988460
     C**********         ENDIF                                                      BUG3721 AR988460
                                                                                             BUG3721
      ** For batch mode, interest is the calculated interest                                 BUG3721
      ** and no need to validate                                                             BUG3721
                                                                                             BUG3721
     C     RespMode      IFNE      'S'                                                       BUG3721
     C                   Z-ADD     WCHKI         WTOTI                                       BUG3721
     C                   MOVE      ZOUT20        DDIPRD                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C     WTOTI         SUB       WCHKI         WCHK2            13 0                       BUG3721
     C     WCHK2         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WCHK2         WCHK2                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Check that the calculated amount should be within one unit                          BUG3721
      ** of the currency specified                                                           BUG3721
      ** If entry is invalid, display the calculated discount or                             BUG3721
      ** interest                                                                            BUG3721
                                                                                             BUG3721
      ** If '*' is entered in the interest/discount amount field default the                 BUG3721
      ** calculated interest to DDIPRD                                                       BUG3721
                                                                                             BUG3721
     C                   MOVEL     DDIPRD        WIPRD1                                      BUG3721
                                                                                             BUG3721
     C     WIPRD1        IFEQ      '*'                                                       BUG3721
     C                   Z-ADD(H)  ZINTR         WTOTI            13 0                       BUG3721
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3721
     C                   MOVE      WTOTI         ZFLD15                                      BUG3721
     C                   MOVE      'L'           ZECODE                                      BUG3721
     C                   Z-ADD     WCDPL         ZDECS                                       BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZFRPED'                                                  BUG3721
     C                   PARM                    ZFLD15           15 0                       BUG3721
     C                   PARM                    ZDECS             1 0                       BUG3721
     C                   PARM                    ZECODE            1                         BUG3721
     C                   PARM      *BLANKS       ZOUT22                                      BUG3721
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3721
                                                                                             BUG3721
     C                   IF        WTOTI < 0                                                MD055128
     C                             AND CLE028 = 'Y'                                         MD055128
     C                             AND WLNPT = 80                                           MD055128
     C                   MOVE      ZOUT22        DDIPRD                                     MD055128
     C                   ELSE                                                               MD055128
     C                   MOVE      ZOUT20        DDIPRD                                      BUG3721
     C                   ENDIF                                                              MD055128
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                              CAP086
      ** If Auto-authorise and CAP086 is enable, bypass tolerance validation                  CAP086
      ** for interest calculation.                                                            CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             IF_AUTH = 'Y'                                              CAP086
     C                   EVAL      WCHK2 = *ZERO                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                             BUG3721
     C*****WCHK2         IFGT      1                                                BUG3721 AR988460
     C     WCHK2         IFNE      0                                                        AR988460
                                                                                             BUG3721
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3721
     C                   MOVE      WCHKI         ZFLD15                                      BUG3721
     C                   Z-ADD     WCDPL         ZDECS                                       BUG3721
     C                   MOVE      'L'           ZECODE                                      BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZFRPED'                                                  BUG3721
     C                   PARM                    ZFLD15           15 0                       BUG3721
     C                   PARM                    ZDECS             1 0                       BUG3721
     C                   PARM                    ZECODE            1                         BUG3721
     C                   PARM      *BLANKS       ZOUT22                                      BUG3721
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           DDIPRDOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDIPRD'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0004'     MsgIDXAr(Idx)                               BUG3721
                                                                                             BUG3721
     C**********         MOVEL     ZOUT20        MsgDtaXAr(Idx)                     BUG3721 MD000091
     C     ZNEG          IFEQ      '-'                                                      AR988460
     C                   MOVE      *BLANKS       WRKFLD1          20                        AR988460
     C                   EVAL      WRKFLD1 = %trim(ZOUT20)                                  AR988460
     C*****'-'**         CAT       WRKFLD1       MsgDtaXAr(Idx)                    AR988460 MD055128
     C     '-'           CAT       WRKFLD1       ZOUT20                                     MD055128
     C                   ENDIF                                                              AR988460
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(ZOUT20)                   MD000091
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C*****DDIPRDOK      IFNE      'N'                                              BUG3721 AR988460
     C*****WSUB          ANDEQ     'Y'                                              BUG3721 AR988460
     C**********         Z-SUB     WTOTI         WTOTI                              BUG3721 AR988460
     C**********         ENDIF                                                      BUG3721 AR988460
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      * INRP78  -  Calculate total flat interest & principal          *                      BUG3721
      *            repayment based on Rule of 78                      *                      BUG3721
      * Called by: SRCIN8 - Calculate interest amount for flat rate   *                      BUG3721
      *            personal loans                                     *                      BUG3721
      * Calls    : None                                               *                      BUG3721
      *****************************************************************                      BUG3721
                                                                                             BUG3721
     C     INRP78        BEGSR                                                               BUG3721
                                                                                             BUG3721
      ** Define input and output fields                                                      BUG3721
                                                                                             BUG3721
     C                   Z-ADD     W78MDT        W78MDT            5 0                       BUG3721
     C                   Z-ADD     W78PRN        W78PRN           15 0                       BUG3721
     C                   Z-ADD     W78IRT        W78IRT           11 7                       BUG3721
     C                   MOVE      W78RPF        W78RPF            1                         BUG3721
     C                   Z-ADD     W78RPD        W78RPD            5 0                       BUG3721
     C                   Z-ADD     W78RPM        W78RPM            2 0                       BUG3721
     C                   MOVE      W78ICI        W78ICI            1                         BUG3721
     C                   Z-ADD     W78CGA        W78CGA           15 0                       BUG3721
     C                   MOVE      W78CCY        W78CCY            3                         BUG3721
     C                   MOVE      W78LCN        W78LCN            3                         BUG3721
     C                   Z-ADD     W78INT        W78INT           30 9                       BUG3721
     C                   Z-ADD     W78RPY        W78RPY           30 9                       BUG3721
     C**********         Z-ADD     W78NPY        W78NPY            5 0              BUG3721 BUG21845
     C**********         Z-ADD     W78NPY        W78NPY           15 6            BUG21845 BUG21845A
     C                   Z-ADD     W78NPY        W78NPY           30 9                     BUG21845A
     C                   Z-ADD     W78PYR        W78PYR            3 0                       BUG3721
                                                                                             BUG3721
      ** Compute for the total number of payments during the life of                         BUG3721
      ** the loan, depending on the repayment frequency                                      BUG3721
                                                                                             BUG3721
     C                   Z-ADD     1             W78NPY                                      BUG3721
     C                   Z-ADD     W78RPD        ZDAYNO                                      BUG3721
     C                   MOVE      W78RPF        ZFREQ                                       BUG3721
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3721
     C                   MOVE      W78CCY        ZCCY                                        BUG3721
     C                   MOVE      W78LCN        ZLOC                                        BUG3721
     C                   EXSR      ZFREQB                                                    BUG3721
                                                                                             BUG3721
     C     ZDAYNO        DOWLT     W78MDT                                                    BUG3721
     C     ZDAYNO        ANDGE     W78RPD                                                   AR830785
     C                   ADD       1             W78NPY                                      BUG3721
     C                   EXSR      ZFREQB                                                    BUG3721
     C                   ENDDO                                                               BUG3721
                                                                                             BUG3721
      ** Add 1 to total number of payments to include repayment on                           BUG3721
      ** maturity date                                                                       BUG3721
                                                                                             BUG3721
     C                   ADD       1             W78NPY                                      BUG3721
      *                                                                                     BUG21845
      ** Disregard previous calculation for W78NPY to include decimals                      BUG21845
      *                                                                                     BUG21845
     C                   Z-ADD     0             W78NPY                                     BUG21845
     C     W78MDT        SUB       WSVVD         WDAYT             5 0                      BUG21845
                                                                                             BUG3721
      ** Compute for the number of payments per year                                         BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
     C     W78RPF        WHENEQ    'W'                                                       BUG3721
     C                   Z-ADD     52            W78PYR                                      BUG3721
     C**********         Z-ADD     7             WDAY              3 0            BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'F'                                                       BUG3721
     C                   Z-ADD     26            W78PYR                                      BUG3721
     C**********         Z-ADD     14            WDAY                             BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'M'                                                       BUG3721
     C                   Z-ADD     12            W78PYR                                      BUG3721
     C**********         Z-ADD     30            WDAY                             BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'T'                                                       BUG3721
     C                   Z-ADD     6             W78PYR                                      BUG3721
     C**********         Z-ADD     60            WDAY                             BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'Q'                                                       BUG3721
     C                   Z-ADD     4             W78PYR                                      BUG3721
     C**********         Z-ADD     90            WDAY                             BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'X'                                                       BUG3721
     C                   Z-ADD     2             W78PYR                                      BUG3721
     C**********         Z-ADD     180           WDAY                             BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'Y'                                                       BUG3721
     C                   Z-ADD     1             W78PYR                                      BUG3721
     C**********         Z-ADD     360           WDAY                             BUG21845 BUG21845A
     C     W78RPF        WHENEQ    'S'                                                       BUG3721
     C                   Z-ADD     24            W78PYR                                      BUG3721
     C**********         Z-ADD     15            WDAY                             BUG21845 BUG21845A
     C                   ENDSL                                                               BUG3721
                                                                                            BUG21845
     C     360           DIV       W78PYR        WDAY              9 6                     BUG21845A
     C     WDAYT         DIV       WDAY          W78NPY                                     BUG21845
                                                                                             BUG3721
      ** Compute for the interest                                                            BUG3721
                                                                                             BUG3721
     C     W78ICI        IFEQ      'Y'                                                       BUG3721
     C                   ADD       W78CGA        W78PRN                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C     W78NPY        DIV       W78PYR        W78INT                                      BUG3721
                                                                                             BUG3721
      ** Compute for Total intest using Net Treasury Rate                                    BUG3721
                                                                                             BUG3721
     C     CAS005        IFEQ      'Y'                                                       BUG3721
                                                                                             BUG3721
     C                   Z-ADD     W78INT        W78IN2           30 9                       BUG3721
                                                                                             BUG3721
     C     W78IRT        SUB       CCLMARG       WMARG             7 5                       BUG3721
     C                   MULT      WMARG         W78INT                                      BUG3721
     C                   DIV       100           W78INT                                      BUG3721
     C                   MULT(H)   W78PRN        W78INT                                      BUG3721
     C                   Z-ADD     W78INT        CCLTOTN                                     BUG3721
                                                                                             BUG3721
     C                   Z-ADD     W78IN2        W78INT                                      BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   MULT      W78IRT        W78INT                                      BUG3721
     C                   DIV       100           W78INT                                      BUG3721
     C                   MULT(H)   W78PRN        W78INT                                      BUG3721
                                                                                             BUG3721
      ** Compute for the loan amount                                                         BUG3721
                                                                                             BUG3721
     C     DDREPT        IFEQ      '3'                                                       BUG3721
     C     DDREPT        OREQ      '1'                                                       BUG3721
     C     DDADIF        ANDEQ     'Y'                                                       BUG3721
     C     W78PRN        ADD       W78INT        WLNAMT           30 9                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     W78PRN        WLNAMT                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     W78ICI        IFNE      'Y'                                                       BUG3721
     C                   ADD       W78CGA        WLNAMT                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Compute for the principal repayment                                                 BUG3721
                                                                                             BUG3721
     C     WLNAMT        DIV(H)    W78NPY        W78RPY                                      BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      * SRCRPA  -  Calculate repayment amount                         *                      BUG3721
      * Called by: SRFRPD - Validate second detail screen             *                      BUG3721
      *****************************************************************                      BUG3721
                                                                                             BUG3721
     C     SRCRPA        BEGSR                                                               BUG3721
                                                                                             BUG3721
      ** For flat rate personal loan use previously calculated repayment                     BUG3721
      ** amount                                                                              BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WCRPYA           13 0          Calc Rpy Amt BUG3721
     C     WLNPT         IFEQ      80                                                        BUG3721
     C                   Z-ADD     WRPYA         WCRPYA                                      BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
      ** Compute for the total number of payments during the life of                         BUG3721
      ** the loan, depending on the repayment frequency                                      BUG3721
      ** do not compute if repayment frequency not available                                 BUG3721
                                                                                             BUG3721
     C     WSVRP         IFNE      *ZEROS                                       Repay Date   BUG3721
     C     DDRFRQ        ANDNE     *BLANKS                                      Repay Freq   BUG3721
     C     WSVMD         ANDNE     0                                            Matur Date   BUG3721
     C                   Z-ADD     1             WTNPY             5 0                       BUG3721
     C                   Z-ADD     WSVRP         ZDAYNO                                      BUG3721
     C                   MOVE      DDRFRQ        ZFREQ                                       BUG3721
     C                   MOVE      DDRDYN        ZMDAY                                       BUG3721
     C                   MOVE      W#CCY         ZCCY                                        BUG3721
     C                   MOVE      *BLANKS       ZLOC                                        BUG3721
     C***********        EXSR      ZFREQB                                             BUG3721 245239
     C                   EXSR      ZFRQB2                                                     245239
                                                                                             BUG3721
     C     ZDAYNO        DOWLT     WSVMD                                                     BUG3721
     C     ZDAYNO        ANDGE     WSVRP                                                    AR830785
     C                   ADD       1             WTNPY                                       BUG3721
     C***********        EXSR      ZFREQB                                             BUG3721 245239
     C                   EXSR      ZFRQB2                                                     245239
     C                   ENDDO                                                               BUG3721
                                                                                             BUG3721
      ** Add 1 to total number of payments to include repayment on                           BUG3721
      ** maturity date                                                                       BUG3721
                                                                                             BUG3721
     C                   ADD       1             WTNPY                                       BUG3721
                                                                                             BUG3721
      ** Compute for the principal repayment                                                 BUG3721
                                                                                             BUG3721
     C     DDREPT        IFEQ      '1'                                                       BUG3721
     C     DDREPT        OREQ      '2'                                                       BUG3721
     C     WSVAM         DIV(H)    WTNPY         W78RPY                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C     DDREPT        IFEQ      '3'                                                       BUG3721
     C     WSVAM         ADD       WTOTI         W78RPY                                      BUG3721
     C     W78RPY        DIV(H)    WTNPY         W78RPY                                      BUG3721
                                                                                             BUG3721
     C                   MOVE      *BLANKS       REPAY3                                      BUG3721
     C                   MOVE      DDVDAT        SVDAT                                       BUG3721
     C                   MOVE      DDCPAM        SCPAM                                       BUG3721
     C                   MOVE      DDMDAT        SMDAT                                       BUG3721
     C                   MOVE      DDCALC        SCALC                                       BUG3721
     C                   MOVE      DDRAMT        SRAMT                                       BUG3721
     C                   MOVE      DDREPT        SREPT                                       BUG3721
     C                   MOVE      DDPDDI        SPDDI                                       BUG3721
     C                   MOVE      DDNRPD        SNRPD                                       BUG3721
     C                   MOVE      DDRDYN        SRDYN                                       BUG3721
     C                   MOVE      DDSPIN        SSPIN                                       BUG3721
     C                   MOVE      DDRTSP        SRTSP                                       BUG3721
     C                   MOVE      DDBRTT        SBRTT                                       BUG3721
                                                                                             BUG3721
     C                   MOVEL     REPAY3        WREP3A           68                         BUG3721
     C                   MOVE      DDRFRQ        WREP3A                                      BUG3721
                                                                                             BUG3721
     C     WREP3A        IFNE      WREPY3                                                    BUG3721
     C     WINTT         ANDNE     *ZEROS                                                   BUG16617
     C                   EXSR      SRREP3                                                    BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD(H)  WREPYA        W78RPY                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** WCRPYA is the calculated Repayment Amount                                           BUG3721
                                                                                             BUG3721
     C                   Z-ADD     W78RPY        WCRPYA                         Calc Rpy Amt BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** If '*' is entered in the repayment amount field default                             BUG3721
      ** the repayment amount computed to the screen. Else,                                  BUG3721
      ** check that the calculated amount should be within one unit                          BUG3721
      ** of the currency specified                                                           BUG3721
      ** If entry is invalid, display the calculated loan currency                           BUG3721
      ** repayment amount in the error message                                               BUG3721
                                                                                             BUG3721
     C     WCRPYA        IFNE      0                                            Calc Rpy Amt BUG3721
                                                                                             BUG3721
     C     WRAMT1        IFEQ      '*'                                                       BUG3721
                                                                                             BUG3721
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3721
     C                   MOVE      WCRPYA        ZFLD15                                      BUG3721
     C                   MOVE      'L'           ZECODE                                      BUG3721
     C                   Z-ADD     WCDPL         ZDECS                                       BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZFRPED'                                                  BUG3721
     C                   PARM                    ZFLD15           15 0                       BUG3721
     C                   PARM                    ZDECS             1 0                       BUG3721
     C                   PARM                    ZECODE            1                         BUG3721
     C                   PARM      *BLANKS       ZOUT22                                      BUG3721
     C                   PARM      *BLANKS       ZOUT25                                      BUG3721
                                                                                             BUG3721
     C                   MOVE      ZOUT20        DDRAMT                                      BUG3721
                                                                                             BUG3721
     C                   MOVEL     DDRAMT        WSRAMT           15                         BUG3721
     C                   Z-ADD     WCRPYA        WSVRA                          Repay Amnt   BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
      ** Show Warning message if different from calculated                                   BUG3721
                                                                                             BUG3721
     C     WSVRA         SUB       WCRPYA        WCHK3            13 0                       BUG3721
     C     WCHK3         IFLE      *ZEROS                                                    BUG3721
     C                   Z-SUB     WCHK3         WCHK3                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WCHK3         IFGT      1                                                         BUG3721
                                                                                             BUG3721
     C*****WERPA         IFEQ      *BLANK                                            BUG3721 BUG4351
     C*****WERPA         OREQ      'Y'                                               BUG3721 BUG4351
     C*****WSVRA         ANDNE     PWSVRA                                            BUG3721 BUG4351
     C*****WERPA         OREQ      'Y'                                               BUG3721 BUG4351
     C*****WCHGA         ANDNE     PWCHGA                                            BUG3721 BUG4351
     C*****WERPA         OREQ      'Y'                                               BUG3721 BUG4351
     C*****DDADIF        ANDNE     PDDADIF                                           BUG3721 BUG4351
     C*****WERPA         OREQ      'Y'                                               BUG3721 BUG4351
     C*****DDADCF        ANDNE     PDDADCF                                           BUG3721 BUG4351
     C*****WERPA         OREQ      'Y'                                               BUG3721 BUG4351
     C*****DDICIF        ANDNE     PDDICIF                                           BUG3721 BUG4351
     C**********         Z-ADD     WSVRA         PWSVRA           13 0               BUG3721 BUG4351
     C**********         Z-ADD     WCHGA         PWCHGA           13 0               BUG3721 BUG4351
     C**********         MOVE      DDADIF        PDDADIF           1                 BUG3721 BUG4351
     C**********         MOVE      DDADCF        PDDADCF           1                 BUG3721 BUG4351
     C**********         MOVE      DDICIF        PDDICIF           1                 BUG3721 BUG4351
                                                                                             BUG3721
     C**********         MOVE      'Y'           WERPA             1                 BUG3721 BUG4351
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3721
     C                   MOVE      WCRPYA        ZFLD15                                      BUG3721
     C                   MOVE      'L'           ZECODE                                      BUG3721
     C                   Z-ADD     WCDPL         ZDECS                                       BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZFRPED'                                                  BUG3721
     C                   PARM                    ZFLD15           15 0                       BUG3721
     C                   PARM                    ZDECS             1 0                       BUG3721
     C                   PARM                    ZECODE            1                         BUG3721
     C                   PARM      *BLANKS       ZOUT22                                      BUG3721
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3721
                                                                                             BUG3721
     C                   MOVE      'W'           DDRAMTOK                                    BUG3721
     C                   ADD       1             WId                                         BUG3721
     C                   MOVEL     'DDRAMT'      WFldNmXAr(WId)                              BUG3721
     C                   MOVEL     'LEL0559'     WMsgIDXAr(WId)                              BUG3721
     C**********         MOVEL     ZOUT20        WMsgDtXAr(WId)                     BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT20))                               MD000091
     C                   EVAL      WMsgDtXAr(WId) = LenStr +%TRIM(ZOUT20)                   MD000091
                                                                                             BUG3721
     C**********         ENDIF                                                       BUG3721 BUG4351
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C     WRAMT1        IFEQ      '*'                                                       BUG3721
     C                   MOVE      'N'           DDRAMTOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDRAMT'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0560'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      * SRREP3  -  Calculate Repayment Amount for Repayment type 3    *                      BUG3721
      *            For Non-Flat rate personal loans.                  *                      BUG3721
      *****************************************************************                      BUG3721
                                                                                             BUG3721
     C     SRREP3        BEGSR                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WDUMMY            9 0                       BUG3721
     C                   Z-ADD     *ZEROS        WODIFF           30 9                       BUG3721
     C                   Z-ADD     WSVAM         HCPAM            18 0                       BUG3721
     C                   Z-ADD     *ZEROS        WTOTIN           30 9                       BUG3721
     C                   MOVE      'N'           ADDI1             1                         BUG3721
     C                   MOVE      'N'           SUBI1             1                         BUG3721
     C                   MOVE      'N'           ADDI5             1                         BUG3721
     C                   MOVE      'N'           SUBI5             1                         BUG3721
     C                   MOVE      'N'           ADDI10            1                         BUG3721
     C                   MOVE      'N'           SUBI10            1                         BUG3721
     C                   MOVE      'N'           ADD100            1                         BUG3721
     C                   MOVE      'N'           SUB100            1                         BUG3721
     C                   MOVE      'N'           ADD1K             1                         BUG3721
     C                   MOVE      'N'           SUB1K             1                         BUG3721
     C                   MOVE      'N'           ADD10K            1                         BUG3721
     C                   MOVE      'N'           SUB10K            1                         BUG3721
     C                   MOVE      'N'           AD100K            1                         BUG3721
     C                   MOVE      'N'           SU100K            1                         BUG3721
     C                   MOVE      'N'           USE10K            1                         BUG3721
     C                   MOVE      'N'           USE1K             1                         BUG3721
     C                   MOVE      'N'           USE100            1                         BUG3721
     C                   MOVE      'N'           USE10             1                         BUG3721
     C                   MOVE      'N'           USE5              1                         BUG3721
     C                   MOVE      'N'           USE1              1                         BUG3721
                                                                                             BUG3721
     C**********         SELECT                                                       BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'W'                                                BUG3721 CLE064
     C*****WINTT         DIV       5200          MI               15 9                BUG3721 261714
     C*****WINTT         DIV       5200          MI               1511                261714  CLE064
     C*****DDRFRQ        WHENEQ    'F'                                                BUG3721 CLE064
     C*****WINTT         DIV       2600          MI                                   BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'M'                                                BUG3721 CLE064
     C*****WINTT         DIV       1200          MI                                   BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'T'                                                BUG3721 CLE064
     C*****WINTT         DIV       600           MI                                   BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'Q'                                                BUG3721 CLE064
     C*****WINTT         DIV       400           MI                                   BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'X'                                                BUG3721 CLE064
     C*****WINTT         DIV       200           MI                                   BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'Y'                                                BUG3721 CLE064
     C*****WINTT         DIV       100           MI                                   BUG3721 CLE064
     C*****DDRFRQ        WHENEQ    'S'                                                BUG3721 CLE064
     C*****WINTT         DIV       2400          MI                                   BUG3721 CLE064
     C**********         ENDSL                                                        BUG3721 CLE064
      *                                                                                      BUG3721
     C                   EVAL      REARR = RAARR                                              CLE064
     C                   EVAL      YFREQ = %LOOKUP(DDRFRQ:RFREQ)                              CLE064
     C     WINTT         DIV       RDAY2(YFREQ)  MI               1511                        CLE064
     C                   EVAL      MI = MI * RDAY1(YFREQ)                                     CLE064
      *                                                                                       CLE064
     C**********         Z-ADD     1             BASE             15 9                BUG3721 261714
     C*****1****         ADD       MI            MBASE            15 9                BUG3721 261714
     C                   Z-ADD     1             BASE             1511                        261714
     C     1             ADD       MI            MBASE            1511                        261714
     C                   Z-ADD     *ZEROS        IND              15 9                       BUG3721
     C     IND           DOWLT     WTNPY                                                     BUG3721
     C                   ADD       1             IND              15 9                       BUG3721
     C     BASE          MULT      MBASE         BASE                                        BUG3721
     C                   ENDDO                                                               BUG3721
     C     1             DIV       BASE          BASE                                        BUG3721
     C     1             SUB       BASE          BASE                                        BUG3721
     C     HCPAM         MULT      MI            WORK1            30 9                       BUG3721
     C     WORK1         DIV       BASE          WORK1                                       BUG3721
     C                   Z-ADD(H)  WORK1         W78RPY                                      BUG3721
                                                                                             BUG3721
     C                   Z-ADD     W78RPY        WREPYA           15 2                       BUG3721
     C                   Z-ADD     *ZEROS        WOUTPR           30 9                       BUG3721
     C                   Z-ADD     W@NRPD        WFREND            5 0                       BUG3721
     C                   MOVE      'N'           REPIND            1                         BUG3721
                                                                                             BUG3721
     C     WTOTPR        DOUEQ     WSVAM                                                     BUG3721
     C     WOLRPA        OREQ      WNWRPA                                                    BUG3721
     C     REPIND        OREQ      'Y'                                                       BUG3721
     C                   Z-ADD     WSVAM         WOUTPR                                      BUG3721
     C                   Z-ADD     *ZEROS        WTOTPR           13 0                       BUG3721
     C     CCLCHTP       IFEQ      'I'                                                       BUG3721
     C                   Z-ADD     WSVVD         WFRBEG            5 0                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     CCLSLID       WFRBEG                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   Z-ADD     W@NRPD        WFREND            5 0                       BUG3721
                                                                                             BUG3721
     C                   Z-ADD     1             WCTR              5 0                       BUG3721
     C     WCTR          DOWLE     WTNPY                                                     BUG3721
     C     WFREND        ORLE      WSVMD                                                     BUG3721
     C     WFREND        ANDGE     W@NRPD                                                   AR830785
                                                                                             BUG3721
      ** Compute for the interest to be repaid using work outstanding principal              BUG3721
                                                                                             BUG3721
     C                   Z-ADD     WOUTPR        ZIAMT                                       BUG3721
     C                   Z-ADD     WINTT         ZIRATE                                      BUG3721
      *******************MOVE******DDCALC********ZICALC                              BUG3721 BUG7147
     C                   Z-ADD     0             ZICALCN                                     BUG7147
     C                   SELECT                                                              BUG7147
     C     DDCALC        WHENEQ    '1'                                                       BUG7147
     C                   Z-ADD     1             ZICALCN                                     BUG7147
     C     DDCALC        WHENEQ    '2'                                                       BUG7147
     C                   Z-ADD     2             ZICALCN                                     BUG7147
     C     DDCALC        WHENEQ    '3'                                                       BUG7147
     C                   Z-ADD     3             ZICALCN                                     BUG7147
     C     DDCALC        WHENEQ    '4'                                                       BUG7147
     C                   Z-ADD     4             ZICALCN                                     BUG7147
     C     DDCALC        WHENEQ    '5'                                                       BUG7147
     C                   Z-ADD     5             ZICALCN                                     BUG7147
     C     DDCALC        WHENEQ    '6'                                                       BUG7147
     C                   Z-ADD     6             ZICALCN                                     BUG7147
     C                   ENDSL                                                               BUG7147
     C                   Z-ADD     WFRBEG        ZIBEG                                       BUG3721
     C                   Z-ADD     WFREND        ZIEND                                       BUG3721
                                                                                             BUG3721
     C     ZIEND         IFEQ      *ZEROS                                                    BUG3721
     C     WSVVD         ADD       1             ZIEND                                       BUG3721
     C                   ELSE                                                                BUG3721
     C     ZIEND         IFGT      WSVMD                                                     BUG3721
     C                   Z-ADD     WSVMD         ZIEND                                       BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WOUTPR        IFGT      *ZEROS                                                    BUG3721
                                                                                             BUG3721
     C                   CALLB     'GLINTC'                                                  BUG3721
     C                   PARM                    ZIBEG             5 0                       BUG3721
     C                   PARM                    ZIEND             5 0                       BUG3721
      *******************PARM********************ZICALC                              BUG3721 BUG7147
     C                   PARM                    ZICALCN           1 0                       BUG7147
     C                   PARM                    ZIAMT            15 0                       BUG3721
     C                   PARM                    ZIRATE           11 7                       BUG3721
     C                   PARM                    ZINTRGC          30 9                       BUG3721
                                                                                             BUG3721
     C                   Z-ADD(H)  ZINTRGC       WINTRP           16 3                       BUG3721
     C                   Z-ADD(H)  ZINTRGC       ZINTR                                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     *ZEROS        WINTRP                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ADD       WINTRP        WTOTIN                                      BUG3721
     C     WTOTIN        SUB       WREPYA        WTOTIN                                      BUG3721
     C     WTOTIN        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WTOTIN        WPRNRP           16 3                       BUG3721
     C                   Z-ADD     *ZEROS        WTOTIN                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     *ZEROS        WPRNRP                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WPRNRP        IFGT      *ZEROS                                                    BUG3721
     C                   ADD(H)    WPRNRP        WTOTPR                                      BUG3721
     C                   SUB       WPRNRP        WOUTPR                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Compute number of days per payment period                                           BUG3721
                                                                                             BUG3721
     C                   Z-ADD     WFREND        ZDAYNO                                      BUG3721
     C                   MOVE      DDRFRQ        ZFREQ                                       BUG3721
     C                   MOVE      DDRDYN        ZMDAY                                       BUG3721
     C                   MOVE      W#CCY         ZCCY                                        BUG3721
     C                   MOVE      WLCCD         ZLOC                                        BUG3721
     C                   EXSR      ZFREQB                                                    BUG3721
     C                   Z-ADD     WFREND        WFRBEG                                      BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
     C     DDPDDI        WHENEQ    'P'                                                       BUG3721
     C                   EXSR      ZBKDT                                                     BUG3721
                                                                                             BUG3721
     C     DDPDDI        WHENEQ    'N'                                                       BUG3721
     C     DDPDDI        OREQ      *BLANK                                                    BUG3721
     C                   EXSR      ZFWDT                                                     BUG3721
                                                                                             BUG3721
     C     DDPDDI        WHENEQ    'A'                                                       BUG3721
     C                   Z-ADD     ZDAYNO        ZDYNBR                                      BUG3721
                                                                                             BUG3721
     C     DDPDDI        WHENEQ    'M'                                                       BUG3721
     C                   CALLB     'ZDATE2'                                                  BUG3721
     C                   PARM                    ZDAYNO            5 0                       BUG3721
     C                   PARM                    BJDFIN                                      BUG3721
     C                   PARM      *ZEROS        ZDATE             6 0                       BUG3721
     C                   PARM                    ZADATE            7                         BUG3721
                                                                                             BUG3721
     C     BJDFIN        IFNE      'M'                                                       BUG3721
     C                   MOVE(P)   ZDATE         MMYY              4 0                       BUG3721
     C                   MOVEL(P)  MMYY          MMNLCD            2 0                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVEL(P)  ZDATE         MMNLCD                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     ZDAYNO        @DAYNO            5 0                       BUG3721
     C                   EXSR      ZFWDT                                                     BUG3721
     C                   Z-ADD     ZDYNBR        ZDAYNO                                      BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZDATE2'                                                  BUG3721
     C                   PARM                    ZDAYNO            5 0                       BUG3721
     C                   PARM                    BJDFIN                                      BUG3721
     C                   PARM      *ZEROS        ZDATE             6 0                       BUG3721
     C                   PARM                    ZADATE            7                         BUG3721
                                                                                             BUG3721
     C     BJDFIN        IFNE      'M'                                                       BUG3721
     C                   MOVE(P)   ZDATE         MMYY                                        BUG3721
     C                   MOVEL(P)  MMYY          MMNWKD            2 0                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVEL(P)  ZDATE         MMNWKD                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     MMNLCD        IFNE      MMNWKD                                                    BUG3721
     C                   Z-ADD     @DAYNO        ZDAYNO                                      BUG3721
     C                   EXSR      ZBKDT                                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDSL                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     ZDAYNO        WFREND                                      BUG3721
     C                   ADD       1             WCTR                                        BUG3721
     C                   ENDDO                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WTOTIN                                      BUG3721
     C     WTOTPR        IFNE      WSVAM                                                     BUG3721
     C                   ADD       1             WDUMMY                                      BUG3721
     C     WSVAM         SUB       WTOTPR        WDIFF            30 9                       BUG3721
     C                   Z-ADD     WOLRPA        WOOLRA           30 9                       BUG3721
     C                   Z-ADD(H)  WREPYA        WOLRPA           13 0                       BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     AD100K        ANDEQ     'Y'                                                       BUG3721
     C     SU100K        ANDEQ     'Y'                                                       BUG3721
     C     USE10K        ANDNE     'Y'                                                       BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     AD100K        ANDEQ     'Y'                                                       BUG3721
     C     SU100K        ANDEQ     'Y'                                                       BUG3721
     C     USE10K        ANDNE     'Y'                                                       BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C                   MOVE      'Y'           USE10K                                      BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3           30 9                       BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4           30 9                       BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     ADD10K        ANDEQ     'Y'                                                       BUG3721
     C     SUB10K        ANDEQ     'Y'                                                       BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     ADD10K        ANDEQ     'Y'                                                       BUG3721
     C     SUB10K        ANDEQ     'Y'                                                       BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C                   MOVE      'Y'           USE1K                                       BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3                                      BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4                                      BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     ADD1K         ANDEQ     'Y'                                                       BUG3721
     C     SUB1K         ANDEQ     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     ADD1K         ANDEQ     'Y'                                                       BUG3721
     C     SUB1K         ANDEQ     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   MOVE      'Y'           USE100                                      BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3                                      BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4                                      BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     ADD100        ANDEQ     'Y'                                                       BUG3721
     C     SUB100        ANDEQ     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     ADD100        ANDEQ     'Y'                                                       BUG3721
     C     SUB100        ANDEQ     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   MOVE      'Y'           USE10                                       BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3                                      BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4                                      BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     ADDI10        ANDEQ     'Y'                                                       BUG3721
     C     SUBI10        ANDEQ     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     ADDI10        ANDEQ     'Y'                                                       BUG3721
     C     SUBI10        ANDEQ     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C                   MOVE      'Y'           USE5                                        BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3                                      BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4                                      BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     ADDI5         ANDEQ     'Y'                                                       BUG3721
     C     SUBI5         ANDEQ     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     ADDI5         ANDEQ     'Y'                                                       BUG3721
     C     SUBI5         ANDEQ     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   MOVE      'Y'           USE1                                        BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3                                      BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4                                      BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDGT     *ZEROS                                                    BUG3721
     C     ADDI1         ANDEQ     'Y'                                                       BUG3721
     C     SUBI1         ANDEQ     'Y'                                                       BUG3721
     C     WODIFF        ORGT      *ZEROS                                                    BUG3721
     C     WDIFF         ANDLT     *ZEROS                                                    BUG3721
     C     ADDI1         ANDEQ     'Y'                                                       BUG3721
     C     SUBI1         ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'Y'           REPIND                                      BUG3721
     C     WODIFF        IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WODIFF        WDIFF3                                      BUG3721
     C     WDIFF3        IFGT      WDIFF                                                     BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF4                                      BUG3721
     C     WDIFF4        IFGT      WODIFF                                                    BUG3721
     C                   Z-ADD     WOOLRA        WREPYA                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WOLRPA        WREPYA                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     REPIND        IFNE      'Y'                                                       BUG3721
     C     WDIFF         IFGT      *ZEROS                                                    BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
     C     WDIFF         WHENGT    10000000                                                  BUG3721
     C     USE10K        ANDNE     'Y'                                                       BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   ADD       100000        WREPYA                                      BUG3721
     C                   MOVE      'Y'           AD100K                                      BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENGT    1000000                                                   BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   ADD       10000         WREPYA                                      BUG3721
     C                   MOVE      'Y'           ADD10K                                      BUG3721
     C                   MOVE      'Y'           USE10K                                      BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENGT    100000                                                    BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   ADD       1000          WREPYA                                      BUG3721
     C                   MOVE      'Y'           ADD1K                                       BUG3721
     C                   MOVE      'Y'           USE1K                                       BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENGT    10000                                                     BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   ADD       100           WREPYA                                      BUG3721
     C                   MOVE      'Y'           ADD100                                      BUG3721
     C                   MOVE      'Y'           USE100                                      BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENGT    1000                                                      BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   ADD       10            WREPYA                                      BUG3721
     C                   MOVE      'Y'           ADDI10                                      BUG3721
     C                   MOVE      'Y'           USE10                                       BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENGT    500                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   ADD       5             WREPYA                                      BUG3721
     C                   MOVE      'Y'           ADDI5                                       BUG3721
     C                   MOVE      'Y'           USE5                                        BUG3721
                                                                                             BUG3721
     C                   OTHER                                                               BUG3721
     C                   ADD       1             WREPYA                                      BUG3721
     C                   MOVE      'Y'           ADDI1                                       BUG3721
     C                   MOVE      'Y'           USE1                                        BUG3721
     C                   ENDSL                                                               BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C                   SELECT                                                              BUG3721
     C     WDIFF         WHENLT    -10000000                                                 BUG3721
     C     USE10K        ANDNE     'Y'                                                       BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   SUB       100000        WREPYA                                      BUG3721
     C                   MOVE      'Y'           SU100K                                      BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENLT    -1000000                                                  BUG3721
     C     USE1K         ANDNE     'Y'                                                       BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   SUB       10000         WREPYA                                      BUG3721
     C                   MOVE      'Y'           SUB10K                                      BUG3721
     C                   MOVE      'Y'           USE10K                                      BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENLT    -100000                                                   BUG3721
     C     USE100        ANDNE     'Y'                                                       BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   SUB       1000          WREPYA                                      BUG3721
     C                   MOVE      'Y'           SUB1K                                       BUG3721
     C                   MOVE      'Y'           USE1K                                       BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENLT    -10000                                                    BUG3721
     C     USE10         ANDNE     'Y'                                                       BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   SUB       100           WREPYA                                      BUG3721
     C                   MOVE      'Y'           SUB100                                      BUG3721
     C                   MOVE      'Y'           USE100                                      BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENLT    -1000                                                     BUG3721
     C     USE5          ANDNE     'Y'                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   SUB       10            WREPYA                                      BUG3721
     C                   MOVE      'Y'           SUBI10                                      BUG3721
     C                   MOVE      'Y'           USE10                                       BUG3721
                                                                                             BUG3721
     C     WDIFF         WHENLT    500                                                       BUG3721
     C     USE1          ANDNE     'Y'                                                       BUG3721
     C                   SUB       5             WREPYA                                      BUG3721
     C                   MOVE      'Y'           SUBI5                                       BUG3721
     C                   MOVE      'Y'           USE5                                        BUG3721
                                                                                             BUG3721
     C                   OTHER                                                               BUG3721
     C                   SUB       1             WREPYA                                      BUG3721
     C                   MOVE      'Y'           SUBI1                                       BUG3721
     C                   MOVE      'Y'           USE1                                        BUG3721
                                                                                             BUG3721
     C                   ENDSL                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     WDIFF         WODIFF           30 9                       BUG3721
     C                   Z-ADD(H)  WREPYA        WNWRPA           13 0                       BUG3721
                                                                                             BUG3721
     C     WDIFF         IFLT      *ZEROS                                                    BUG3721
     C                   Z-SUB     WDIFF         WDIFF2           30 9                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   Z-ADD     WDIFF         WDIFF2                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C     WDIFF2        IFLT      5                                                         BUG3721
     C                   MOVE      'Y'           REPIND                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD(H)  WREPYA        WNWRPA           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDDO                                                               BUG3721
     C                   Z-ADD(H)  WREPYA        W78RPY                                      BUG3721
     C                   MOVEL     WREP3A        WREPY3                                      BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      *  ZFREQB - Calculate day number of next payment                *                      BUG3721
      *****************************************************************                      BUG3721
     C     ZFREQB        BEGSR                                                               BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZFREQB'                                                  BUG3721
     C                   PARM      *BLANKS       @RTCD                                       BUG3721
     C                   PARM                    ZFREQ             1                         BUG3721
     C                   PARM                    ZDAYNO            5 0                       BUG3721
     C                   PARM                    ZCCY              3                         BUG3721
     C                   PARM                    ZLOC                                       AR702741
     C                   PARM                    ZMDAY             2 0                       BUG3721
     C                   PARM                    BJDFIN                                      BUG3721
     C                   PARM      SDGELR        SDGELR                                      BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                  245239
      *****************************************************************                       245239
      *  ZFRQB2 - Calculate day number of next payment                *                       245239
      *****************************************************************                       245239
     C     ZFRQB2        BEGSR                                                                245239
                                                                                              245239
     C                   CALLB     'ZFRQB2'                                                   245239
     C                   PARM      *BLANKS       @RTCD                                        245239
     C                   PARM                    ZFREQ             1                          245239
     C                   PARM                    ZDAYNO            5 0                        245239
     C                   PARM                    ZCCY              3                          245239
     C                   PARM                    ZLOC              3                          245239
     C                   PARM                    ZMDAY             2 0                        245239
     C                   PARM                    BJDFIN                                       245239
     C                   PARM      SDGELR        SDGELR                                       245239
                                                                                              245239
     C                   ENDSR                                                                245239
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      *  ZBKDT  - Calculate previous working day number               *                      BUG3721
      *****************************************************************                      BUG3721
     C     ZBKDT         BEGSR                                                               BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZBKDT'                                                   BUG3721
     C                   PARM                    ZDAYNO            5 0                       BUG3721
     C                   PARM                    ZCCY              3                         BUG3721
     C                   PARM                    ZLOC              3                         BUG3721
     C                   PARM                    ZNRDYS            2 0                       BUG3721
     C                   PARM                    ZDYNBR            5 0                       BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT                                                                                 BUG3721
      *****************************************************************                      BUG3721
      *  ZFWDT  - Calculate number of working days forward            *                      BUG3721
      *****************************************************************                      BUG3721
     C     ZFWDT         BEGSR                                                               BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZFWDT'                                                   BUG3721
     C                   PARM                    ZDAYNO                                      BUG3721
     C                   PARM                    ZNRDYS                                      BUG3721
     C                   PARM                    ZDYNBR                                      BUG3721
     C                   PARM                    ZCCY                                        BUG3721
     C                   PARM                    ZLOC                                        BUG3721
                                                                                             BUG3721
     C                   ENDSR                                                               BUG3721
      *****************************************************************                      BUG3721
      /EJECT
      *****************************************************************
      *  SRCL05 - Validate CLE005 fields                              *
      *****************************************************************
     C     SRCL05        BEGSR
      *
      ***  VALIDATE PAYMENT DUE DAY (if CLE005 is installed)
      ***  entry is allowed only for repayment type '2'
      ***  Entry now allowed for types '1' and '3' also.
      *
     C     DDREPT        IFEQ      '2'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '1'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '3'
     C     DDREPTOK      ANDNE     'N'
                                                                                             BUG3721
     C     DDPDDI        IFEQ      *BLANK
                                                                                             BUG3721
     C     CLE028        IFNE      'Y'                                                       BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WLNPT         ANDNE     80                                                        BUG3721
     C                   MOVE      'M'           DDPDDI
     C                   ELSE                                                                BUG3721
     C                   MOVE      'A'           DDPDDI                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ELSE
                                                                                             BUG3721
     C     CLE028        IFNE      'Y'                                                       BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WLNPT         ANDNE     80                                                        BUG3721
                                                                                             BUG3721
     C     DDPDDI        IFNE      'A'
     C     DDPDDI        ANDNE     'P'
     C     DDPDDI        ANDNE     'N'
     C     DDPDDI        ANDNE     'M'
     C                   MOVE      'N'           DDPDDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0419'     MsgIDXAr(Idx)
     C                   ENDIF
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C     DDPDDI        IFNE      'A'                                                       BUG3721
     C                   MOVE      'N'           DDPDDIOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDPDDY'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0578'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF
      *
     C                   ELSE
     C     DDPDDI        IFNE      *BLANK
     C     DDREPT        ANDNE     '1'
     C     DDREPT        ANDNE     '2'
     C     DDREPT        ANDNE     '3'
     C                   MOVE      'N'           DDPDDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0422'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Validate payment taken day (if CLE005 is installed)
      ***  Entry is allowed only for repayment type '2' if payment
      ***  is due on actual date.
      ***  Also allow entry of 'M' when payment due is modified.
      ***  Entry now allowed for types '1' and '3' also.
      *
     C     DDREPT        IFEQ      '2'
     C     DDPDDI        ANDEQ     'A'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '1'
     C     DDPDDI        ANDEQ     'A'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '3'
     C     DDPDDI        ANDEQ     'A'
     C     DDREPTOK      ANDNE     'N'
     C     DDPTDI        IFEQ      *BLANK
     C                   MOVE      'M'           DDPTDI
     C                   ELSE
     C     DDPTDI        IFNE      'P'
     C     DDPTDI        ANDNE     'N'
     C     DDPTDI        ANDNE     'M'
     C                   MOVE      'N'           DDPTDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0420'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C     DDREPT        IFEQ      '2'
     C     DDPDDI        ANDEQ     'M'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '1'
     C     DDPDDI        ANDEQ     'M'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '3'
     C     DDPDDI        ANDEQ     'M'
     C     DDREPTOK      ANDNE     'N'
     C     DDPTDI        IFEQ      *BLANK
     C                   MOVE      'M'           DDPTDI
     C                   ELSE
     C     DDPTDI        IFNE      'M'
     C                   MOVE      'N'           DDPTDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0425'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
     C     DDREPT        IFEQ      '2'
     C     DDPDDI        ANDEQ     'P'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '1'
     C     DDPDDI        ANDEQ     'P'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '3'
     C     DDPDDI        ANDEQ     'P'
     C     DDREPTOK      ANDNE     'N'
     C     DDPTDI        IFEQ      *BLANK
     C                   MOVE      'P'           DDPTDI
     C                   ELSE
     C     DDPTDI        IFNE      'P'
     C                   MOVE      'N'           DDPTDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0425'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDREPT        IFEQ      '2'
     C     DDPDDI        ANDEQ     'N'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '1'
     C     DDPDDI        ANDEQ     'N'
     C     DDREPTOK      ANDNE     'N'
     C     DDREPT        OREQ      '3'
     C     DDPDDI        ANDEQ     'N'
     C     DDREPTOK      ANDNE     'N'
     C     DDPTDI        IFEQ      *BLANK
     C                   MOVE      'N'           DDPTDI
     C                   ELSE
     C     DDPTDI        IFNE      'N'
     C                   MOVE      'N'           DDPTDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0425'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDPTDI        IFNE      *BLANK
     C     DDREPT        ANDNE     '1'
     C     DDREPT        ANDNE     '2'
     C     DDREPT        ANDNE     '3'
     C                   MOVE      'N'           DDPTDIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0421'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Validate grace days por repayment (if CLE005 is installed)
      ***  Defaults to grace days from lending ICD if blank
      *
     C     DDGDIN        IFEQ      *BLANK
     C                   MOVE      BPGRIR        DDGDIN
     C                   ELSE
     C                   MOVEL     DDGDIN        WNUM3
     C                   MOVEL     WNUM3         WALF2
     C     DDGDIN        IFNE      WALF2
     C                   MOVE      'N'           DDGDINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGDIN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0417'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDGDPR        IFEQ      *BLANK
     C                   MOVE      BPGRPR        DDGDPR
     C                   ELSE
     C                   MOVEL     DDGDPR        WNUM3
     C                   MOVEL     WNUM3         WALF2
     C     DDGDPR        IFNE      WALF2
     C                   MOVE      'N'           DDGDPROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDGDPR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0418'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDPDDIOK      IFNE      'N'
     C     DDGDINOK      ANDNE     'N'
     C     DDGDPROK      ANDNE     'N'
     C     DDPTDIOK      ANDNE     'N'
     C                   MOVEL     DDPDDI        CCLPDDI
     C                   MOVE      DDGDIN        CCLGDIN
     C                   MOVE      DDGDPR        CCLGDPR
     C                   MOVEL     DDPTDI        CCLPTDI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     AR804863
      /EJECT                                                                                AR804863
      *****************************************************************                     AR804863
      *                                                               *                     AR804863
      * SRRSFD  -  Restore original details (for Reject Action)       *                     AR804863
      *                                                               *                     AR804863
      *****************************************************************                     AR804863
     C     SRRSFD        BEGSR                                                              AR804863
      *                                                                                     AR804863
      ** Interest Date                                                                      AR804863
      *                                                                                     AR804863
     C                   Z-ADD     *ZEROS        WSVID                                      AR804863
     C     DDNIDT        IFNE      *BLANKS                                                  AR804863
     C                   MOVEL     DDNIDT        WNUM7                                      AR804863
     C                   MOVEL     WNUM7         WALF6                                      AR804863
     C                   MOVE      DDNIDT        ZDATE                                      AR804863
     C                   MOVE      BJDFIN        ZDATFM                                     AR804863
     C                   CALL      'ZDATE1'                                                 AR804863
     C                   PARM      *BLANKS       ZERR                                       AR804863
     C                   PARM                    ZDATE                                      AR804863
     C                   PARM                    ZDATFM                                     AR804863
     C                   PARM                    ZDAYNO                                     AR804863
     C                   Z-ADD     ZDAYNO        WSVID                                      AR804863
     C                   MOVE      WSVID         CCLNIDT                                    AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
      ** Interest Frequency                                                                 AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDIPFR        CCLIPFR                                    AR804863
      *                                                                                     AR804863
      ** Interest Day Number                                                                AR804863
      *                                                                                     AR804863
     C                   MOVE      DDIFDY        CCLIFDY                                    AR804863
      *                                                                                     AR804863
      ** Interest/Discount Amount                                                           AR804863
      *                                                                                     AR804863
     C     CCLCHTP       IFEQ      'A'                                                      AR804863
     C     RespMode      ANDEQ     'S'                                                      AR804863
     C     CLE028        ANDEQ     'Y'                                                      AR804863
     C     WPRCS2        ANDNE     'Y'                                                      AR804863
     C     WLNPT         ANDEQ     80                                                       AR804863
     C                   MOVEL     *BLANK        WIPRD1            1                        AR804863
     C                   MOVEL     *BLANK        WIPR13           13                        AR804863
     C                   MOVEL     DDIPRD        WIPRD1                                     AR804863
     C                   MOVE      DDIPRD        WIPR13                                     AR804863
                                                                                            AR804863
     C     CLE028        IFNE      'Y'                                                      AR804863
     C     WIPRD1        ANDEQ     '*'                                                      AR804863
     C     WIPRD1        ORNE      '*'                                                      AR804863
     C     CLE028        OREQ      'Y'                                                      AR804863
     C     WIPRD1        ANDEQ     '*'                                                      AR804863
     C     WIPR13        ANDNE     *BLANK                                                   AR804863
                                                                                            AR804863
     C                   MOVE      *BLANKS       PSCRF                                      AR804863
     C                   MOVE      DDIPRD        PSCRF                                      AR804863
     C                   Z-ADD     WCDPL         PNDEC                                      AR804863
     C     13            SUB       WCDPL         PNDIG                                      AR804863
     C                   CALL      'ZALIGN'      PPAR1                                      AR804863
     C                   MOVE      PRVAL         WTOTI                                      AR804863
     C                   ENDIF                                                              AR804863
     C                   ENDIF                                                              AR804863
     C     CCLCHTP       IFEQ      'A'                                                      AR804863
     C     WLNPT         IFEQ      63                                                       AR804863
     C     WLNPT         OREQ      65                                                       AR804863
     C     WLNPT         OREQ      67                                                       AR804863
     C     WLNPT         OREQ      72                                                       AR804863
     C     W72TP         ANDEQ     '67'                                                     AR804863
     C*****WSVMD         IFLT      CCLMDAT                                         AR804863 MD055714
     C*****WLNPT         OREQ      63                                              AR804863 MD055714
     C**********         EXSR      SRCINT                                          AR804863 MD055714
     C**********         Z-ADD     WTOTI         CCLTOTI                           AR804863 MD055714
     C*****CCLORTI       IFEQ      *ZEROS                                          AR804863 MD055714
     C*****CCLORMD       ANDEQ     *ZEROS                                          AR804863 MD055714
     C*****CCLORED       ANDLT     BJRDNB                                          AR804863 MD055714
     C*****CCLVDAT       ANDLT     BJRDNB                                          AR804863 MD055714
     C**********         Z-ADD     CCLTOTI       CCLORTI                           AR804863 MD055714
     C**********         MOVE      CCLMDAT       CCLORMD                           AR804863 MD055714
     C**********         ENDIF                                                     AR804863 MD055714
     C**********         ENDIF                                                     AR804863 MD055714
      *                                                                                     MD055714
     C                   MOVE      *BLANKS       PSCRF                                      MD055714
     C                   MOVE      DDIPRD        PSCRF                                      MD055714
     C                   Z-ADD     WCDPL         PNDEC                                      MD055714
     C     13            SUB       WCDPL         PNDIG                                      MD055714
     C                   CALL      'ZALIGN'      PPAR1                                      MD055714
     C                   MOVE      PRVAL         WTOTI                                      MD055714
     C                   Z-ADD     WTOTI         CCLTOTI                                    MD055714
      *                                                                                     MD055714
     C     DDOMDT        IFEQ      *BLANKS                                                  MD055714
     C                   Z-ADD     *ZEROS        CCLORTI                                    MD055714
     C                   Z-ADD     *ZEROS        CCLORMD                                    MD055714
     C                   ENDIF                                                              MD055714
      *                                                                                     MD055714
     C                   ENDIF                                                              AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
      ** Margin and Negative Indicator                                                      AR804863
      *                                                                                     AR804863
     C                   MOVE      *BLANKS       PSCRF                                      AR804863
     C                   MOVE      DDMARG        PSCRF                                      AR804863
     C                   Z-ADD     5             PNDEC                                      AR804863
     C                   Z-ADD     2             PNDIG                                      AR804863
     C                   CALL      'ZALIGN'      PPAR1                                      AR804863
     C                   MOVE      PRVAL         WSVMG                                      AR804863
     C                   Z-ADD     WSVMG         CCLMARG                                    AR804863
      *                                                                                     AR804863
      ** Withholding Tax Rate                                                               AR804863
      *                                                                                     AR804863
     C                   MOVE      *BLANKS       PSCRF                                      AR804863
     C                   MOVEL     DDWTRT        PSCRF                                      AR804863
     C                   Z-ADD     7             PNDEC                                      AR804863
     C                   Z-ADD     4             PNDIG                                      AR804863
     C                   CALL      'ZALIGN'      PPAR1                                      AR804863
     C                   MOVE      PRVAL         WSVWT                                      AR804863
     C                   MOVE      WSVWT         CCLWTRT                                    AR804863
      *                                                                                     AR804863
      ** Loan Currency Repayment                                                            AR804863
      *                                                                                     AR804863
     C                   Z-ADD     *ZEROS        WSVRA                                      AR804863
     C                   Z-ADD     *ZEROS        WSVFA                                      AR804863
     C                   MOVE      *BLANKS       PSCRF                                      AR804863
     C                   MOVE      DDRAMT        PSCRF                                      AR804863
     C                   MOVE      WCDPL         PNDEC                                      AR804863
     C     13            SUB       WCDPL         PNDIG                                      AR804863
     C                   CALL      'ZALIGN'      PPAR1                                      AR804863
     C                   MOVE      PRVAL         WSVRA                                      AR804863
     C                   MOVE      WSVRA         CCLRAMT                                    AR804863
      *                                                                                     AR804863
     C     CLE006        IFEQ      'Y'                                                      AR804863
     C     DDFCRA        ANDNE     *BLANKS                                                  AR804863
     C     CLE007        OREQ      'Y'                                                      AR804863
     C     DDFCRA        ANDNE     *BLANKS                                                  AR804863
      *                                                                                     AR804863
      ** Facility Currency repayment amount                                                 AR804863
      *                                                                                     AR804863
     C                   MOVE      CCLFCUS       WFCNUM                                     AR804863
     C                   MOVE      CCLFTYP       WFFACT                                     AR804863
     C                   MOVE      CCLFSEQ       WFFCNO                                     AR804863
     C                   MOVE      'A'           WFRCTP                                     AR804863
     C     WKFAC         CHAIN(N)  FCLTY                              99                    AR804863
     C     *IN83         IFEQ      '0'                                                      AR804863
     C                   MOVE      FCCYF         @CYCD                                      AR804863
     C                   ELSE                                                               AR804863
     C                   MOVE      FCCYM         @CYCD                                      AR804863
     C                   ENDIF                                                              AR804863
     C                   CALLB     'AOCURRR0'                                               AR804863
     C                   PARM      *BLANKS       @RTCD                                      AR804863
     C                   PARM      '*KEY   '     @OPTN                                      AR804863
     C                   PARM                    @CYCD                                      AR804863
     C     SDCURR        PARM      SDCURR        DSSDY                                      AR804863
     C                   MOVE      *BLANKS       PSCRF                                      AR804863
     C                   MOVE      DDFCRA        PSCRF                                      AR804863
     C                   MOVE      A6NBDP        PNDEC                                      AR804863
     C     13            SUB       A6NBDP        PNDIG                                      AR804863
     C                   CALL      'ZALIGN'      PPAR1                                      AR804863
     C                   MOVE      PRVAL         WSVFA                                      AR804863
     C                   MOVE      WSVFA         CCLFCRA                                    AR804863
      *                                                                                     AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
      ** Repayment Date                                                                     AR804863
      *                                                                                     AR804863
     C                   Z-ADD     *ZEROS        WSVRP                                      AR804863
     C                   MOVEL     DDNRPD        WNUM7                                      AR804863
     C                   MOVEL     WNUM7         WALF6                                      AR804863
     C                   MOVE      DDNRPD        ZDATE                                      AR804863
     C                   MOVE      BJDFIN        ZDATFM                                     AR804863
     C                   CALL      'ZDATE1'                                                 AR804863
     C                   PARM      *BLANKS       ZERR                                       AR804863
     C                   PARM                    ZDATE                                      AR804863
     C                   PARM                    ZDATFM                                     AR804863
     C                   PARM                    ZDAYNO                                     AR804863
     C                   Z-ADD     ZDAYNO        WSVRP                                      AR804863
     C                   MOVE      WSVRP         CCLNRPD                                    AR804863
      *                                                                                     AR804863
      ** Repayment Frequencey/Day Number                                                    AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDRFRQ        CCLRFRQ                                    AR804863
     C                   MOVE      DDRDYN        CCLRDYN                                    AR804863
      *                                                                                     AR804863
      ** Bill/Telex Indicator                                                               AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDBTIN        CCLBTIN                                    AR804863
      *                                                                                     AR804863
      ** Billing Days                                                                       AR804863
      *                                                                                     AR804863
     C                   MOVE      DDBLDY        CCLBLDY                                    AR804863
      *                                                                                     AR804863
      ** CLE005 Fields                                                                      AR804863
      *                                                                                     AR804863
     C     CLE005        IFEQ      'Y'                                                      AR804863
     C                   MOVEL     DDPDDI        CCLPDDI                                    AR804863
     C                   MOVE      DDGDIN        CCLGDIN                                    AR804863
     C                   MOVE      DDGDPR        CCLGDPR                                    AR804863
     C                   MOVEL     DDPTDI        CCLPTDI                                    AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
     C                   ENDSR                                                              AR804863
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPSG        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDBASR                                       CRE073
     C                   PARM                    DDBRTT                                       CRE073
     C                   PARM                    DDFXRT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDCNSG                                       CRE073
     C                   PARM      *ZERO         TMCNSP                                       CRE073
     C                   PARM      'LOAN  '      Pmodule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDCNSPOK                                     CRE073
     C                   PARM                    DDCNSGOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDM - Validate Rounding Method                            *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDM        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      'LOAN  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDRDMTOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDF        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM      'LOAN  '      PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
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
     C                   Z-ADD     BASER         TMBSRT                                       CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    TMBSRT                                       CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDCNSG                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      *ZERO         PNewSpread                                   CRE073
     C                   PARM      *ZERO         PFinalRate                                 AR847249
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C**********         IF        PFinalRate <= 0 AND                             AR847249 AR947093
     C**********                   DDRDMT <> *BLANKS                               AR847249 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      Idx = Idx + 1                                   AR847249 AR947093
     C**********         EVAL      FldNamXAr(Idx) = 'DDRDMT'                       AR847249 AR947093
     C**********         EVAL      MsgIDXAr(Idx) = 'USS0015'                       AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaXAr(Idx) = %EDITC(PFinalRate:'J')         AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        PNewSpread = *ZERO                                         CRE073
     C                   EVAL      DDRTSP = *BLANKS                                           CRE073
     C                   EVAL      DDSPIN = DDCNSG                                            CRE073
     C                   ELSEIF    PNewSpread < *ZERO                                         CRE073
     C                             AND DDCNSG <> 'P'                                          CRE073
                                                                                            AR847249
     C                   EVAL      DDSPINOK = 'W'                                           AR847249
     C                   EVAL      Wid = Wid + 1                                            AR847249
     C                   EVAL      WFldNmXAr(WId) = 'DDSPIN'                                AR847249
     C                   EVAL      WMsgIDXAr(WId) = 'USS0016'                               AR847249
     C**********         EVAL      WMsgDtXAr(WId) = %EDITC(PNewSpread:'J')         AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(PNewSpread:'J')                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WId) = LenStr +%TRIM(MsgDtaTmp)                MD000091
                                                                                            AR847249
     C                   EVAL      PNewSpread = %ABS(PNewSpread)                              CRE073
     C                   EVAL      DDRTSP = %CHAR(PNewSpread)                                 CRE073
                                                                                              CRE073
     C                   IF        DDCNSG = 'A'                                               CRE073
     C                   EVAL      DDSPIN = 'S'                                               CRE073
     C                   ELSEIF    DDCNSG = 'S'                                               CRE073
     C                   EVAL      DDSPIN = 'A'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDSPIN = DDCNSG                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDRTSP = %CHAR(PNewSpread)                                 CRE073
     C                   EVAL      DDSPIN = DDCNSG                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   Z-ADD     PNewSpread    CCLRTSP                                      CRE073
     C                   Z-ADD     PNewSpread    WSVRS                                      AR947093
     C                   MOVEL     DDSPIN        CCLSPIN                                      CRE073
     C**********         ENDIF                                                     AR847249 AR947093
     C                   ELSE                                                                 CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        WFXRT <> *ZEROS                                            CRE073
     C                             AND DDFXRTOK <> 'N'                                        CRE073
     C                             AND DDCNSP = *BLANKS                                       CRE073
     C                   Z-ADD     WFXRT         CCLRTSP                                      CRE073
     C                   Z-ADD     WFXRT         WSVRS                                      MD041917
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ***  Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                              CRE073
      ** Reset Index of Errors                                                                CRE073
                                                                                              CRE073
     C                   EVAL      Idx = *ZERO                                                CRE073
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
      ***  Reset error indicators
      *
     C                   MOVE      '0'           *IN44
     C                   MOVE      *ALL'0'       WVAL2A           16
     C                   MOVE      *ALL'0'       WVAL2B           12
     C                   MOVEA     WVAL2A        *IN(10)
     C                   MOVEA     WVAL2B        *IN(22)
      *
      ***  Reset warning flags
      *
     C     SaveDDLNR2    IFNE      DDLNR2
     C**********         MOVE      *BLANK        WE504             1                         BUG4351
     C**********         MOVE      *BLANK        WE022             1                         BUG4351
     C**********         MOVE      *BLANK        WE027             1                         BUG4351
     C**********         MOVE      *BLANK        WERPA                               BUG3721 BUG4351
     C                   MOVE      *BLANK        WREPY3                                      BUG3721
     C                   ENDIF
      *
      ***  Check type of processing
      *
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      ***  Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ***  Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C*****I*****        SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD034449
      * VALAMT - VALIDATE/REFORMAT AMOUNT                             *                     MD034449
      *****************************************************************                     MD034449
      *                                                                                     MD034449
     C     VALAMT        BEGSR                                                              MD034449
      *                                                                                     MD034449
     C                   CALLB     'ZA0841'                                                 MD034449
      *                                                                                     MD034449
     C                   PARM      *BLANK        RetCodeOut                                 MD034449
     C                   PARM                    @@ALPH                                     MD034449
     C                   PARM                    @@IDP                                      MD034449
     C                   PARM                    @@IINT                                     MD034449
     C                   PARM      'N'           @@MTID                                     MD034449
     C                   PARM      *ZERO         @@ERCD                                     MD034449
     C                   PARM      *ZERO         @@AMT                                      MD034449
     C                   PARM                    DL_BNDCSP                                  MD034449
      *                                                                                     MD034449
     C                   ENDSR                                                              MD034449
      *****************************************************************                     MD034449
      /EJECT                                                                                MD034449
      *****************************************************************                     MD034449
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *                     MD034449
      *****************************************************************                     MD034449
     C     FMTAMT        BEGSR                                                              MD034449
      *                                                                                     MD034449
      * Sadly ZASIGN rejects a minus with a non blank following. So format                  MD034449
      * non-siged version for database update and use DDNGVI to sign amount.                MD034449
      *                                                                                     MD034449
     C     '-'           SCAN      DDRTSP        PT                2 0                      MD034449
     C     PT            IFNE      0                                                        MD034449
      *                                                                                     MD034449
     C                   MOVE      'Y'           DDNGVI            1                        MD034449
      *                                                                                     MD034449
     C                   MOVEA     DDRTSP        ArrayRtSp                                  MD034449
     C                   MOVE      ' '           ArrayRtSp(PT)                              MD034449
     C                   MOVEA     ArrayRtSp     PZFld17                                    MD034449
      *                                                                                     MD034449
     C                   ELSE                                                               MD034449
     C                   MOVE      ' '           DDNGVI                                     MD034449
     C                   ENDIF                                                              MD034449
      *                                                                                     MD034449
     C                   CALLB     'ZASIGN'                                                 MD034449
     C                   PARM      'Y'           PZASignOk                                  MD034449
     C                   PARM                    PZFld17                                    MD034449
     C                   PARM                    PZDig                                      MD034449
     C                   PARM                    PZDec                                      MD034449
     C                   PARM      DL_BNDCSP     PZSDCSP                                    MD034449
     C                   PARM                    PZOut15                                    MD034449
     C                   PARM                    PZFSign                                    MD034449
      *                                                                                     MD034449
     C                   ENDSR                                                              MD034449
      *****************************************************************                     MD034449
      /EJECT                                                                                MD034449
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      *
      ***  Loan details screen 1
     C                   PARM                    TranInScr2
      *                                                                                      BUG8526
      ** Loan details screen 3                                                               BUG8526
     C                   PARM                    TranInScr3                                  BUG8526
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      *
      ***  Extended data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
      *
      ***  Calling type
     C                   PARM                    LoanType          4
      *
      ***  User from Loan manager
     C                   PARM                    @USER            16
      *
      ***  Seq  from Loan manager
     C                   PARM                    W#SEQ             4 0
      *
      ***  PC Originating Branch from Loan manager
     C                   PARM                    W#PCOB            3
      *
      ***  Generated by Principal Transfer from PT Midas input
     C                   PARM                    PGNTF             1
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
                                                                                             BUG3721
      ** (Current) loan in file format CL                                                    BUG3721
      ** Loan details screen 1                                                               BUG3721
      ** OK flags from screen 1                                                              BUG3721
     C                   PARM                    CliLFilFmt                                  BUG3721
     C                   PARM                    TranInScr1                                  BUG3721
     C                   PARM                    OKFlags1DS                                  BUG3721
                                                                                            MD053143
      ** Business Day Convention Screen Detail                                              MD053143
     C                   PARM                    TranInScr7                                 MD053143
      ** OUTPUTS                                                                            MD053143
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C*************      PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Valid Loan CL layout (DS) from/to caller
     C                   PARM                    ValidLnCl
      *
      ***  Valid Loan CK layout (DS) from/to caller
     C                   PARM                    ValidLnCk
      *
      ***  Next available loan number
     C                   PARM                    PRANG             2
      *
      ***  Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      *
      ***  Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      *
      ***  Shared data
     C                   PARM                    TransData
      *
      ***  PC Processing
     C                   PARM                    PPTIN             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
      *
      ***  Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LECLIP2VL'   DBPGM
     C                   OUT       LDA
      *
      ***  Define working fields
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     BPGIAV        IFEQ      'Y'
     C                   MOVE      '1'           *IN24
     C                   ENDIF
      *
      ***  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   Z-ADD     7             DBASE                          * DBERR 007 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVE      'N'           CLE006            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE006
     C                   END
      *
     C                   MOVE      'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE007
     C                   END
      *
     C                   MOVE      'N'           CDE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE002
     C                   END
                                                                                             BUG3721
     C                   MOVE      'N'           CAS005            1                         BUG3721
     C                   CALLB     'AOSARDR0'                                                BUG3721
     C                   PARM      *BLANKS       @RTCD                                       BUG3721
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3721
     C                   PARM      'CAS005'      @SARD                                       BUG3721
                                                                                             BUG3721
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3721
     C                   MOVE      'Y'           CAS005                                      BUG3721
     C                   END                                                                 BUG3721
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   Z-ADD     8             DBASE                          * DBERR 008 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 9                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CLE035
      ***Determine*if*Nordea*LE*Enh.*Phase*1*Pty*2*-*Income*Splits*****              CLE035 BUG10225
      ***is*installed**************************************************              CLE035 BUG10225
      ** Determine if Fixed Base Rate and Repayments in Facility                            BUG10225
      ** Currency(CLE036) is installed                                                      BUG10225
      *                                                                                       CLE035
     C**********         MOVE      'N'           CLE035            1                 CLE035 BUG10225
     C                   MOVE      'N'           CLE036            1                        BUG10225
     C                   CALLB     'AOSARDR0'                                                 CLE035
     C                   PARM      *BLANKS       @RTCD                                        CLE035
     C                   PARM      '*VERIFY'     @OPTN                                        CLE035
     C**********         PARM      'CLE035'      @SARD             6                 CLE035 BUG10225
     C                   PARM      'CLE036'      @SARD             6                        BUG10225
      *                                                                                       CLE035
     C     @RTCD         IFEQ      *BLANKS                                                    CLE035
     C**********         MOVE      'Y'           CLE035                              CLE035 BUG10225
     C                   MOVE      'Y'           CLE036                                     BUG10225
     C                   ELSE                                                                 CLE035
     C     @RTCD         IFEQ      '*NRF'                                                     CLE035
     C**********         MOVE      'N'           CLE035                              CLE035 BUG10225
     C                   MOVE      'N'           CLE036                                     BUG10225
     C                   ELSE                                                                 CLE035
      *                                                                                       CLE035
      ** DATABASE ERRO                                                                        CLE035
      *                                                                                       CLE035
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE035
     C                   Z-ADD     9             DBASE                          * DBERR 009 * CLE035
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE035
     C                   EXSR      *PSSR                                                      CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                    AR1067935
      ** Check if CLE134 is installed                                                      AR1067935
      *                                                                                    AR1067935
     C                   CALLB     'AOSARDR0'                                              AR1067935
     C                   PARM      *BLANK        @RTCD                                     AR1067935
     C                   PARM      '*VERIFY'     @OPTN                                     AR1067935
     C                   PARM      'CLE134'      @SARD                                     AR1067935
      *                                                                                    AR1067935
     C                   IF        @RTCD = *BLANK                                          AR1067935
     C                   MOVE      'Y'           CLE134            1                       AR1067935
     C                   ELSE                                                              AR1067935
     C                   MOVE      'N'           CLE134                                    AR1067935
     C                   ENDIF                                                             AR1067935
                                                                                              CER043
      ** Check if CER043 is on                                                                CER043
                                                                                              CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       @RTCD                                        CER043
     C                   PARM      '*VERIFY'     @OPTN                                        CER043
     C                   PARM      'CER043'      @SARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER043
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER043
     C                   EVAL      DBKey  = 'CER043'                                          CER043
     C                   EVAL      DBase  = 10                                                CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        @RTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
     C/COPY WNCPYSRC,LEH00619
                                                                                              CLE143
      ** Check if CAS009 is on                                                                CLE143
                                                                                              CLE143
     C                   EVAL      CAS009 = 'N'                                               CLE143
     C                   CALLB     'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       @RTCD                                        CLE143
     C                   PARM      '*VERIFY'     @OPTN                                        CLE143
     C                   PARM      'CAS009'      @SARD                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
                                                                                              CLE143
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE143
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE143
     C                   EVAL      DBKey  = 'CAS009'                                          CLE143
     C                   EVAL      DBase  = 11                                                CLE143
     C                   EXSR      *PSSR                                                      CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   IF        @RTCD = *BLANKS                                            CLE143
     C                   EVAL      CAS009 = 'Y'                                               CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
      ** Check if CLE143 is on                                                                CLE143
                                                                                              CLE143
     C                   EVAL      CLE143 = 'N'                                               CLE143
     C                   CALLB     'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       @RTCD                                        CLE143
     C                   PARM      '*VERIFY'     @OPTN                                        CLE143
     C                   PARM      'CLE143'      @SARD                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
                                                                                              CLE143
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE143
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE143
     C                   EVAL      DBKey  = 'CLE143'                                          CLE143
     C                   EVAL      DBase  = 12                                                CLE143
     C                   EXSR      *PSSR                                                      CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   IF        @RTCD = *BLANKS                                            CLE143
     C                   EVAL      CLE143 = 'Y'                                               CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CRE073
      ** Check if CRE073 Interest Rate Rounding feature is installed                          CRE073
                                                                                              CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       @RTCD                                        CRE073
     C                   PARM      '*VERIFY'     @OPTN                                        CRE073
     C                   PARM      'CRE073'      @SARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CRE073
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKey  = 'CRE073'                                          CRE073
     C                   EVAL      DBase  = 11                                                CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        @RTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                     MD053143
      ** Determine if CLE141 is switched on                                                 MD053143
      *                                                                                     MD053143
     C                   MOVE      'N'           CLE141                                     MD053143
     C                   CALLB     'AOSARDR0'                                               MD053143
     C                   PARM      *BLANKS       @RTCD                                      MD053143
     C                   PARM      '*VERIFY'     @OPTN                                      MD053143
     C                   PARM      'CLE141'      @SARD                                      MD053143
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD053143
      *                                                                                     MD053143
     C                   IF        @RTCD = *BLANKS                                          MD053143
     C                   EVAL      CLE141 = 'Y'                                             MD053143
     C                   ENDIF                                                              MD053143
      *                                                                                       CLE170
      ** Check if CLE170 Allow Zero Interest Rate Loan is installed.                          CLE170
      *                                                                                       CLE170
     C                   MOVE      'N'           CLE170            1                          CLE170
     C                   CALLB     'AOSARDR0'                                                 CLE170
     C                   PARM      *BLANKS       @RTCD                                        CLE170
     C                   PARM      '*VERIFY'     @OPTN                                        CLE170
     C                   PARM      'CLE170'      @SARD                                        CLE170
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE170
      *                                                                                       CLE170
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE170
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE170
     C                   EVAL      DBKey  = 'CLE170'                                          CLE170
     C                   EVAL      DBase  = 15                                                CLE170
     C                   EXSR      *PSSR                                                      CLE170
     C                   ENDIF                                                                CLE170
                                                                                              CLE170
     C                   IF        @RTCD = *BLANKS                                            CLE170
     C                   EVAL      CLE170 = 'Y'                                               CLE170
     C                   ENDIF                                                                CLE170
      *                                                                                     MD031736
      ** Check if CLE011 is ON.                                                             MD031736
      *                                                                                     MD031736
     C                   EVAL      CLE011 = 'N'                                             MD031736
     C                   CALLB     'AOSARDR0'                                               MD031736
     C                   PARM      *BLANKS       @RTCD                                      MD031736
     C                   PARM      '*VERIFY'     @OPTN                                      MD031736
     C                   PARM      'CLE011'      @SARD                                      MD031736
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD031736
      *                                                                                     MD031736
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                MD031736
     C                   EVAL      DBFile = 'SCSARDPD'                                      MD031736
     C                   EVAL      DBKey  = 'CLE011'                                        MD031736
     C                   EVAL      DBase  = 13                                              MD031736
     C                   EXSR      *PSSR                                                    MD031736
     C                   ENDIF                                                              MD031736
      *                                                                                     MD031736
     C                   IF        @RTCD = *BLANKS                                          MD031736
     C                   EVAL      CLE011 = 'Y'                                             MD031736
     C                   ENDIF                                                              MD031736
      *                                                                                     MD031736
      ** Check if a System Value exists for this maintenance.                               MD031736
      *                                                                                     MD031736
     C                   IF        CLE011 = 'Y'                                             MD031736
      *                                                                                     MD031736
     C                   EVAL      RateFixSt = 'N'                                          MD031736
     C                   EVAL      StartRateFix = 'N'                                       MD053143
      *                                                                                     MD031736
     C                   CALLB     'AOSVALR0'                                               MD031736
     C                   PARM      *BLANKS       PRtCd                                      MD031736
     C                   PARM                    PSysVal01                                  MD031736
     C                   PARM                    PCurSet01                                  MD031736
     C                   PARM                    PSysVal02                                  MD031736
     C                   PARM                    PCurSet02                                  MD031736
     C                   PARM                    PSysVal03                                  MD031736
     C                   PARM                    PCurSet03                                  MD031736
     C                   PARM                    PSysVal04                                  MD031736
     C                   PARM                    PCurSet04                                  MD031736
     C                   PARM                    PSysVal05                                  MD031736
     C                   PARM                    PCurSet05                                  MD031736
     C                   PARM                    PSysVal06                                  MD031736
     C                   PARM                    PCurSet06                                  MD031736
     C                   PARM                    PSysVal07                                  MD031736
     C                   PARM                    PCurSet07                                  MD031736
     C                   PARM                    PSysVal08                                  MD031736
     C                   PARM                    PCurSet08                                  MD031736
     C                   PARM                    PSysVal09                                  MD031736
     C                   PARM                    PCurSet09                                  MD031736
     C                   PARM                    PSysVal10                                  MD031736
     C                   PARM                    PCurSet10                                  MD031736
      *                                                                                     MD031736
     C                   IF        PRtCd = *BLANKS                                          MD031736
     C                   MOVEL     PCurSet01     RateFixSt                                  MD031736
     C                   MOVEL     PCurSet02     StartRateFix                               MD053143
     C                   ELSE                                                               MD031736
      *                                                                                     MD031736
     C                   If        PRtcd <> '*NRF   ' AND                                   MD031736
     C                             PRtcd <> *Blanks                                         MD031736
     C                   Eval      DBFile = 'SDSVALPD'                                      MD031736
     C                   Eval      DBKey = PSysVal01                                        MD031736
     C                   Eval      DBase = 14                                               MD031736
     C                   Exsr      *PSSR                                                    MD031736
     C                   Endif                                                              MD031736
      *                                                                                     MD031736
     C                   Endif                                                              MD031736
     C                   Endif                                                              MD031736
      *
      ***  Define parameter list for ZALIGN
      *
     C     PPAR1         PLIST
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PSCRF            16
     C                   PARM                    PNDEC             1 0
     C                   PARM                    PNDIG             2 0
     C                   PARM      *BLANKS       PRVAL            16
      *                                                                                     MD034449
      ** Access Dealing Details                                                             MD034449
      *                                                                                     MD034449
     C                   CALL      'AODEALR1'                                               MD034449
     C                   PARM      *BLANKS       @RTCD                                      MD034449
     C                   PARM      '*FIRST '     @OPTN                                      MD034449
     C     SDDEAL        PARM      SDDEAL        DSSDY                                      MD034449
      *                                                                                     MD034449
      * Database Error                                                                      MD034449
      *                                                                                     MD034449
     C     @RTCD         IFNE      *BLANK                                                   MD034449
     C                   EVAL      DL_BNDCSP =  '.'                                         MD034449
     C                   ENDIF                                                              MD034449
      *
      *
      ***  Key list for Facilities file
      *
     C     WKFAC         KLIST
     C**********         KFLD                    WFCNUM            6 0                        CSD027
     C                   KFLD                    WFCNUM            6                          CSD027
     C                   KFLD                    WFFACT            3 0
     C                   KFLD                    WFFCNO            2 0
     C                   KFLD                    WFRCTP            1
                                                                                             BUG3721
     C                   MOVE      *BLANK        WREPY3                                      BUG3721
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIP2V29
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *                                                                                       CLE064
      ** Elements of Array FREQ were amended from 'WFMTQXY' to 'DWFMTQ45X789VEYCIJNU'         CLE064
      *                                                                                       CLE064
**  CPY@
(c) Finastra International Limited 2002
** WFREQ **      Table of frequency codes for interests and repayments
DWFMTQ45X789VEYCIJNU                                                                          CLE064
** NDAYS/NFREQ **      Table of Days and frequency codes                                      CLE064
  14W                                                                                         CLE064
  28F                                                                                         CLE064
  30S                                                                                         CLE064
  60M                                                                                         CLE064
 120T                                                                                         CLE064
 180Q                                                                                         CLE064
 360X                                                                                         CLE064
 720Y                                                                                         CLE064
   2D                                                                                         CLE064
 2404                                                                                         CLE064
 3005                                                                                         CLE064
 4207                                                                                         CLE064
 4808                                                                                         CLE064
 5409                                                                                         CLE064
 600V                                                                                         CLE064
 660E                                                                                         CLE064
1440C                                                                                         CLE064
2160I                                                                                         CLE064
2880J                                                                                         CLE064
3600N                                                                                         CLE064
7200U                                                                                         CLE064
** RAARR **      Table for Repayment Amount calculation                                       CLE064
0105200W                                                                                      CLE064
0102600F                                                                                      CLE064
0101200M                                                                                      CLE064
0100600T                                                                                      CLE064
0100400Q                                                                                      CLE064
0100200X                                                                                      CLE064
0100100Y                                                                                      CLE064
0102400S                                                                                      CLE064
0136500D                                                                                      CLE064
01003004                                                                                      CLE064
01002405                                                                                      CLE064
07012007                                                                                      CLE064
01001508                                                                                      CLE064
03004009                                                                                      CLE064
0100120V                                                                                      CLE064
1101200E                                                                                      CLE064
0100050C                                                                                      CLE064
0300100I                                                                                      CLE064
0100025J                                                                                      CLE064
0100020N                                                                                      CLE064
0100010U                                                                                      CLE064
